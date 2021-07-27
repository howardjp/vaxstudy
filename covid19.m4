divert(-1)
## COVID-19
## This is a model for COVID-19 with several degrees of transmissibility
divert(1)dnl
define(`TRANSMISSIBILITY', esyscmd(`/bin/echo -n $TRANSMISSIBILITY'))dnl

# CONDITIONS
include_condition = COVID19

# STATES
COVID19.states = S Sv Sar E Is Ia R Import
COVID19.import_start_state = Import

# TRANSMISSION
COVID19.transmission_mode = proximity
COVID19.transmissibility = TRANSMISSIBILITY
COVID19.R0_a = 0.0398238
COVID19.R0_b = 0.611043

# VISUALIZATION
COVID19.S.is_dormant = 1
COVID19.Sv.is_dormant = 1
COVID19.R.is_dormant = 1

# RULES

if exposed(COVID19) then next(E)

if state(COVID19,S) then set_sus(COVID19,1)
if state(COVID19,S) then wait()

if state(COVID19,Sv) then set_sus(COVID19,1)
if state(COVID19,Sv) then wait()

if state(COVID19,Sar) then set_sus(COVID19,1)
if state(COVID19,Sar) then wait()

if state(COVID19,E) then set_sus(COVID19,0)
if state(COVID19,E) then wait(24*lognormal(1.9,1.23))
if state(COVID19,E) then next(Is) with prob(0.70)
if state(COVID19,E) then next(Ia) with prob(0.30)

if state(COVID19,Is) then set_trans(COVID19,1)
if state(COVID19,Is) then wait(24 * lognormal(2.2, 0.05))
if state(COVID19,Is) then next(R)

if state(COVID19,Ia) then set_trans(COVID19,0.5)
if state(COVID19,Ia) then wait(24 * lognormal(2.2, 0.05))
if state(COVID19,Ia) then next(R)

if state(COVID19,R) then set_trans(COVID19,0)
if state(COVID19,R) then wait()

### IMPORTED COVID19 INFECTIONS
if state(COVID19,Import) then import_count(10)
if state(COVID19,Import) then wait()
