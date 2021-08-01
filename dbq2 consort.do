cls
clear all
capture log close

********************************************************
*  					CONSORT diagram
********************************************************

log using "$log/dbq2 consort 100pct", replace

use "$data/db2", clear
count
mdesc
count
unique patid
keep black educ income pov unemp patid year count1 db tr

* ACS ZIP code data data
gen x_drop=0
foreach x in black educ income pov unemp {
	replace x_drop=1 if `x'==.
}

gen tr_drop=(tr==. | db==.)
gen count_drop=(count1==0)

* DB data
count
*unique patid
foreach x in x_drop tr_drop count_drop {
	di "re missing `x'"
	count if `x'==1
	unique patid if `x'==1
	drop if `x'==1
	count
	unique patid
}

mdesc
count

********************************************************
*  		Descriptives
********************************************************

use "$data/dbq_100pct", clear
count
unique patid
mdesc
sum

sum db tr if year>=2012

log close
