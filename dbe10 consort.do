cls
clear all
capture log close

********************************************************
*  		CONSORT description
********************************************************

log using "$log/dbe9 consort 100pct", replace

use "$data/mbsf_all_100pct", clear

keep bene_id year female tr db count1 race ma

gen female_drop=(female==.)
gen db_drop=(db==.)
gen count_drop=(count1==0)

* drop if: missing female, missing DB data, later cohort (2016 onward)
unique bene_id
foreach x in female_drop db_drop count_drop {
	di "re missing `x'"
	unique bene_id if `x'==1
	count if `x'==1
	drop if `x'==1
	unique bene_id
	count
}

loc x bene_id year female db tr count1 race year ma
sum `x'
mdesc `x'

* confirm against analytic data set
use "$data/dbe_100pct", clear
unique bene_id
count

log close
