divert(-1)
## COVID-19
## This is a model for COVID-19 with several degrees of transmissibility
divert(1)dnl
define(`WILLINGNESS', esyscmd(`/bin/echo -n $WILLINGNESS'))dnl
define(`MIN_AGE', esyscmd(`/bin/echo -n $MIN_AGE'))dnl

##### Vaccination
include_condition = COVIDVAX
COVIDVAX.states = Start Offered Unwilling Willing AgeRestrict Receive Immune Failed Import
COVIDVAX.import_start_state = Import

# RULES
if enter(COVIDVAX,Start) then set_sus(COVIDVAX, 1.0)
if state(COVIDVAX,Start) then wait()

if state(COVIDVAX,Import) then import_per_capita(10)
if state(COVIDVAX,Import) then wait()

if exposed(COVIDVAX) then next(Offered)
if state(COVIDVAX,Offered) then wait(90 * 24)
if state(COVIDVAX,Offered) then next(Willing) with prob(WILLINGNESS)
if state(COVIDVAX,Offered) then default(Unwilling)

if enter(COVIDVAX,Unwilling) then wait()

if enter(COVIDVAX,Willing) and (age < MIN_AGE) then next(AgeRestrict)
if enter(COVIDVAX,Willing) then wait(24*lognormal(10,2))
if state(COVIDVAX,Willing) then next(Receive)

if enter(COVIDVAX,AgeRestrict) then set_state(COVID19,S,Sar)
if enter(COVIDVAX,AgeRestrict) then wait()

if enter(COVIDVAX,Receive) then wait(24*7)
if enter(COVIDVAX,Receive) then next(Immune) with prob(0.95)
if state(COVIDVAX,Receive) then default(Failed)

if enter(COVIDVAX,Immune) then set_sus(COVID19,0.0)
if state(COVIDVAX,Immune) then wait()
if enter(COVIDVAX,Failed) then set_state(COVID19,S,Sv)
if state(COVIDVAX,Failed) then wait()

# DORMANT STATES
COVIDVAX.Immune.is_dormant = 1
COVIDVAX.Failed.is_dormant = 1
