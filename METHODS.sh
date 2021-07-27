#!/bin/bash

export FRED_HOME=$HOME/prj/vax/FRED
export PATH=$FRED_HOME/bin:$PATH

echo -n 'simulations started '
date

list_of_trans="0.5 0.75 1.0 1.25 1.5 1.75 2.0 2.25 2.5"
list_of_vax_uptake="0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75"
list_of_min_ages="0 12 18"
list_of_vaxavailperday="1000 5000 10000 25000 50000"

for i in $list_of_vax_uptake; do
    for j in $list_of_min_ages; do
        echo "WILLINGNESS=$i MIN_AGE=$j m4 config.m4 > config.fred"
        WILLINGNESS=$i MIN_AGE=$j m4 covidvax.m4 > covidvax.fred
        for k in $list_of_trans; do
            echo "TRANSMISSIBILITY=$k m4 covid19.m4 > covid19.fred"
            TRANSMISSIBILITY=$k m4 covid19.m4 > covid19.fred
            echo "m4 config.m4 > config.fred"
            m4 config.m4 > config.fred
            # FRED job with n runs on m cores
            JOBNAME=vaxtest-$i-$j-$k
            echo fred_job -k $JOBNAME -n 1 -m 1 -p config.fred
            fred_job -k $JOBNAME -n 1 -m 1 -p config.fred
            done
        done
    done
done

echo
echo -n 'simulations finished '
date
