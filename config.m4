divert(-1)
## COVID-19
## This is a model for COVID-19 with several degrees of transmissibility
divert(1)dnl
define(`SEED', esyscmd(`/bin/echo -n $SEED'))dnl

##### CONDITIONS
include covid19.fred
include covidvax.fred

seed = SEED

##### Simulated Location
locations = Butler_County_OH

##### Simulated Timeframe
start_date = 2018-Oct-01
end_date = 2018-Dec-31

##### Output Options
enable_health_records = 0
