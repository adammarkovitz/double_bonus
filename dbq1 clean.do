********************************************************************************
** 	Merge CMS Double bonus (DB) data with NBER FIPS-SSA crosswalk (need FIPS)
use "$data/fips/db_ssa", clear
unique ssa year
merge 1:m ssa year using "$data/fips/ssa_fips"
keep if _merge==3
drop _merge
loc x ssa fips year db urban_floor ffs_lower mapen
order `x'
keep `x'

* two SSAs for FIPS 6037 (SSA 5200 and 5210)
unique fips year
loc n=1
bysort fips year: egen sum=sum(`n')
sort fips year ssa
li fips year ssa db if sum==2
drop sum
drop if ssa==5200 & fips==6037 

* check no duplicates
unique fips year
sum
xtset fips year
xtdescribe	// 99.71% present (3115 of 3144)
compress
save "$data/fips/db_fips", replace

********************************************************************************
** 	Merge Optum 5 digit ZIP code data --> HUD FIPS-ZIP xwalk --> CMS DB county data

** collapse Optum data to ZIP5-year level
use "$data/star2", clear
keep if year>=2008
drop if zip==0
keep zip year
gen byte wt=1
gcollapse (first) wt, by(zip year)
drop wt
compress
save "$data/optum_zip_year", replace

* clean FIPS-ZIP HUD file
use "$data/fips/hud_fips_zip", clear
keep zip fips year TOT_RATIO
unique zip year
destring fips, replace
destring zip, replace
gsort zip year -TOT_RATIO 
bysort zip year: keep if _n==1	// keep 1 unique ZIP-FIPS pair
keep fips zip year
compress
save "$data/fips/hud_fips_zip_clean", replace

* merge Optum ZIPs with HUDS FIPS-ZIP crosswalk
use "$data/optum_zip_year", clear
merge 1:1 zip year using "$data/fips/hud_fips_zip_clean"
drop if _merge==2
drop _merge

* merge Optum ZIP/FIPS with DB/FIPS data
merge m:1 fips year using "$data/fips/db_fips"
drop if _merge==2
drop _merge

* keep counties 1) present in post-period and 2) DB value in post-period
tempvar i
tempvar x
gen `i'=(db!=. & year>=2012)
bysort fips: egen `x'=max(`i')
keep if `x'==1

* tr: ever vs never double-bonus
replace db=0 if year<=2011
bysort fips: egen tr=max(db)

* db_year: year that county started DB eligibility
gen db_yr=year if db==1
bysort fips: egen db_year=min(db_yr)
replace db_year=2011 if tr==0
drop db_yr

* itt: intention-to-treat indicated, 1 if current/past DB, 0 otherwise
gen byte itt=0 if tr==0
replace itt = 0 if (year<db_year) & tr==1
replace itt = 1 if (year>=db_year) & tr==1

* exit_year: year county exited DB status
gen exit_yr = year if (itt==1 & db==0)
bysort fips: egen exit_year = min(exit_yr)
replace exit_year=2019 if exit_year==. & tr==1
drop exit_yr
tab exit_year

* exp: time relative to start of DB
gen byte exp=year-db_year
replace exp=0 if tr==0

* time_count: number of years in data set
sort fips year
tempvar n
bysort fips year: gen `n'=1 if _n==1 & (exp>=-4 & exp<=3)
bysort fips: egen byte time_count=count(`n')
drop `n'

* drop variables
drop urban_floor ffs_lower

* save
compress

save "$data/optum_zip_fips_db", replace

***********************************************************************************
** Merge measure-bene-year Optum data with DB data at zip-year level
use "$data/star2", clear
keep if year>=2008 & ma==1
merge m:1 zip year using "$data/optum_zip_fips_db"
drop if _merge==2
drop _merge

drop li Product zip ssa hrr

compress
save "$data/db1", replace

*use "$data/db1", clear
* time: time relative to start of DB, trimmed and non-negative
gen byte time=exp
recode time (-10/-4=-4) (3/10=3)
replace time=time+5
fvset base 5 time

* exit: 1 if ever exited from DB, 0 otherwise
gen byte exit=(exit_year>=2013 & exit_year<=2018)
drop exit_year

* cohort: cohort of year entering DB
gen byte cohort=0 if tr==0
loc t=2012
forvalues i=1/7 {
	replace cohort=`i' if db_year==`t'
	loc t=`t'+1
}

* Baseline MA enrollment 20-30%
gen byte ma25=(mapen>=.20 & mapen<=.30)
drop mapen

* count1=1 if cohorts 1-4, count1=2 if cohorts 1-4 + baseline MA enrollment 20-30%
gen byte count1=(time_count>=8)
gen byte count2=(time_count>=8 & ma25==1)
drop time_count

egen plan=group(Group_Nbr)
drop Group_Nbr
compress
save "$data/db2", replace

*use "$data/db2", replace
count
mdesc
loc x ma y $x db 
foreach x in `x' {
	drop if `x'==.
}
mdesc
compress
save "$data/dbq_all_100pct", replace
keep if r<.01
save "$data/dbq_all_01pct", replace

use "$data/dbq_all_100pct", clear
tab cohort
keep if count1==1
tab cohort
compress
save "$data/dbq_100pct", replace
*use "$data/dbq_100pct", clear
keep if r<.01
save "$data/dbq_01pct", replace
keep if r<.001
save "$data/dbq_001pct", replace
