cls
clear all
capture log close

log using "$log/dbe2 clean 100pct", replace

use "$data/mbsf2_test", clear
count // 602,572,715
mdesc
* time: time relative to start of DB, trimmed and non-negative
gen byte time=exp
recode time (-10/-4=-4) (3/10=3)
replace time=time+5
fvset base 5 time

* exit: 1 if ever exited from DB, 0 otherwise
gen byte exit=(exit_year>=2013 & exit_year<=2018)

* cohort: cohort of year entering DB
gen byte cohort=0 if tr==0
loc t=2012
forvalues i=1/7 {
	replace cohort=`i' if db_year==`t'
	loc t=`t'+1
}

* Baseline MA enrollment 20-30%
gen byte ma25=(mapen>=.20 & mapen<=.30)

* count1=1 if cohorts 1-4, count1=2 if cohorts 1-4 + baseline MA enrollment 20-30%
gen byte count1=(time_count>=8)
gen byte count2=(time_count>=8 & ma25==1)
drop time_count

* label
lab define tr 0 "Never DB" 1 "Ever DB", replace
label values tr tr

lab define itt 0 "Never DB" 1 "ITT DB", replace
label values tr tr

lab define cohort 0 "Never DB" 1 "2012"  2 "2013" 3 "2014" 4 "2015" 5 "2016" 6 "2017" 7 "2018", replace
label values cohort cohort

* ma: MA enrollment - defined as enrolled in January of year (main definition)
rename hmo1 ma

* ma2: MA enrollment - alternate definition as enrolled in December of year
rename hmo12 ma2

* ma3: MA enrollment - alternate all-vs-none definition (12mo vs 0mo)
gen byte ma3 = 1 if hmo_mo==12
replace ma3 = 0 if hmo_mo==0
drop hmo_mo

foreach y in ma ma2 ma3 {
	replace `y'=`y'*100
}

rename BENE_ID bene_id

* Race defined by MBSF race variable
gen byte black = 0 if race==0
replace black = 1 if race==1

gen byte dual=(buyin>0)
drop buyin
compress

save "$data/mbsf_all_100pct", replace
preserve
keep if r<.001
save "$data/mbsf_all_001pct", replace
restore

* analytic data
*use "$data/mbsf_all_100pct", clear
mdesc
count if female!=. & race!= . & tr!=. & ma==100 & year>2012
keep if female!=. & race!= . & tr!=.
keep if count1==1
count
keep bene_id ma ma2 ma3 year ssa $w3 black tr db itt time r exit cohort count1 count2 r ma25
sum
save "$data/dbe_100pct", replace
keep if r<.001
save "$data/dbe_001pct", replace

* FIPS-level data set (for map): 
use "$data/mbsf_all_100pct", clear
keep if female!=. & race!= . & db!=.
keep cohort tr black race ssa fips ma
gen hispanic=(race==2)
gen asian=(race==3)
gen other=(race==4)

bysort ssa: egen fipss=mode(fips)
replace fips=fipss if fips==.
drop if fips==.

gcollapse (max) cohort tr (mean) ma black hispanic asian other, by(fips)
unique fips

save "$mat/mbsf_fips_100pct", replace
save "$data/mbsf_fips_100pct", replace

* SSA-year level data set
use "$data/mbsf_all_100pct", clear
keep if female!=. & race!= . & db!=.
keep ssa year db cohort tr ma race age female orig dual
gen black=(race==1)
gen hispanic=(race==2)
gen asian=(race==3)
gen other=(race==4)

gcollapse (max) db cohort tr (mean) ma black hispanic asian other age female orig dual, by(ssa year)
unique ssa year

save "$mat/mbsf_ssa_year_100pct", replace
save "$data/mbsf_ssa_year_100pct", replace

log close
