

***********************************************************************************
** 2012-2018 MA Rate Calculation Files to determine Double-Bonus Status
***********************************************************************************

loc i 2012
loc drop_2012 = 16
insheet using "$rate/risk`i'.csv", comma clear
drop in 1/`drop_`i''
rename v1 ssa
rename v2 state
rename v3 county
rename v24 urban_floor
rename v26 mapen_25
rename v27 ffs_lower
rename v28 qualifying
rename v25 mapen
gen uspcc = 743.54
rename v14 AGA
rename v13 DOD
rename v12 GME
rename v15 ffs
gen year=`i'
keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year 
tempfile db_`i'
save `db_`i''

loc i 2013
loc drop_2013 = 30
insheet using "$rate/risk`i'.csv", comma clear
drop in 1/`drop_`i''
rename v1 ssa
rename v2 state
rename v3 county
rename v22 urban_floor
rename v24 mapen_25
rename v25 ffs_lower
rename v26 qualifying
rename v13 ffs
rename v23 mapen
gen uspcc = 767.99
gen year=`i'
keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year 
tempfile db_`i'
save `db_`i''

loc drop_2014 = 27
loc drop_2015 = 27
forvalues i=2014/2015 {
	insheet using "$rate/risk`i'.csv", comma clear
	drop in 1/`drop_`i''
	rename v1 ssa
	rename v2 state
	rename v3 county
	rename v23 urban_floor
	rename v25 mapen_25
	rename v26 ffs_lower
	rename v27 qualifying
	rename v4 ffs
	rename v24 mapen
	gen uspcc = 795.11
	gen year=`i'
	keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year 
	tempfile db_`i'
	save `db_`i''
}

loc i 2016
loc drop_2016 = 28
insheet using "$rate/risk`i'.csv", comma clear
drop in 1/`drop_`i''
rename v1 ssa
rename v2 state
rename v3 county
rename v25 urban_floor
rename v27 mapen_25
rename v28 ffs_lower
rename v29 qualifying
rename v4 ffs
rename v26 mapen
gen uspcc = 800.21
gen year=`i'

keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year 
tempfile db_`i'
save `db_`i''

loc i 2017
loc drop_2017 = 21
insheet using "$rate/risk`i'.csv", comma clear
drop in 1/`drop_`i''
rename v1 ssa
rename v2 state
rename v3 county
rename v26 urban_floor
rename v28 mapen_25
rename v29 ffs_lower
rename v30 qualifying
rename v4 ffs
rename v27 mapen
gen uspcc = 825.20
gen year=`i'
keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year 
tempfile db_`i'
save `db_`i''

loc i 2018
loc drop_2018 = 22
insheet using "$rate/risk`i'.csv", comma clear
drop in 1/`drop_`i''
rename v1 ssa
rename v2 state
rename v3 county
rename v26 urban_floor
rename v28 mapen_25
rename v30 ffs_lower
rename v31 qualifying
rename v15 ffs
rename v27 mapen
gen uspcc = 847.73
gen year=`i'
keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year 
tempfile db_`i'
save `db_`i''

use `db_2012'
forvalues i=2013/2018 {
	append using `db_`i''
}

drop if ssa==""

drop if state=="AMERCAN SAMOA" | state=="AMERICAN SAMOA" | state == "American Samoa" | ///
state =="NORTHERN MARIANA ISLANDS" | state=="Northern Mariana Isl" | state=="PR" | ///
state=="GU" | state=="VI" 

foreach x in urban_floor mapen_25 {
	tab `x'
	rename `x' `x'_str
	gen `x' = (`x'_str=="Yes" | `x'_str=="YES")
	drop `x'_str
}

foreach x in qualifying {
	tab `x'
	rename `x' `x'_str
	gen `x' = (`x'_str=="Yes" | `x'_str=="YES")
	drop `x'_str
}

foreach x in ffs_lower {
	tab `x'
	rename `x' `x'_str
	gen `x' = (`x'_str=="Yes" | `x'_str=="YES")
	replace `x' = . if `x'_str=="N/A"
	drop `x'_str
}

foreach x in ffs mapen {
	destring `x', replace force
}

rename qualifying db
compress

drop ffs uspcc

rename county ssa_name
rename ssa ssa_str
destring ssa_str, gen(ssa) force

* expand to pre-period (2008-2011)
expand 5 if year==2012
sort ssa year
bysort ssa: gen year2=_n+2007
replace year = year2
drop year2
xtset ssa year
xtdescribe

* set to 0 in pre-period
foreach x in db ffs_lower  {
	replace `x' = 0 if year<2012
}

* tr: ever vs never double-bonus
bysort ssa: egen tr=max(db)

* db_year: year that county started double-bonus eligibility (DB)
gen db_yr=year if db==1
bysort ssa: egen db_year=min(db_yr)
replace db_year=2011 if tr==0
drop db_yr

* itt: intention-to-treat indicated, 1 if current/past DB, 0 otherwise
gen byte itt=0 if tr==0
replace itt = 0 if (year<db_year) & tr==1
replace itt = 1 if (year>=db_year) & tr==1

* exit_year: year county exited DB status
gen exit_yr = year if (itt==1 & db==0)
bysort ssa: egen exit_year = min(exit_yr)
replace exit_year=2019 if exit_year==. & tr==1
drop exit_yr
tab exit_year

* exp: time relative to start of DB
gen byte exp=year-db_year
replace exp=0 if tr==0

* time_count: number of 
sort ssa year
tempvar n
bysort ssa year: gen `n'=1 if _n==1 & (exp>=-4 & exp<=3)
bysort ssa: egen byte time_count=count(`n')
drop `n'

* save
compress

drop mapen_25

save "$data/fips/db_ssa", replace

***********************************************************************************
** 			2008-2018 SSA FIPS crosswalk
***********************************************************************************

* Crosswalk to link SSA county variables (from CMS) to FIPS county (from ACS and Optum)
use "$data/fips/ssa_fips_state_county2008", clear
rename ssa ssa_str 
rename fips fips_str
rename abbr state
gen year=2008
keep ssa_str fips_str year state county
expand 4
sort ssa year
bysort ssa: replace year=year+_n-1
tempfile a2008
save `a2008'

forvalues i=2012/2017 {
	use "$data/fips/ssa_fips_state_county`i'", clear
	rename ssacounty ssa_str 
	rename fipscounty fips_str
	gen year=`i'
	keep ssa_str fips_str year state county
	tempfile a`i'
	save `a`i''
}

loc i 2018
use "$data/fips/ssa_fips_state_county`i'", clear
rename ssacd ssa_str 
rename FIPS_County_Code fips_str
rename State state
rename County_Name county
gen year=`i'
keep ssa_str fips_str year state county
tempfile a`i'
save `a`i''

use `a2008'
forvalues i=2012/2018 {
	append using `a`i''
}

sort ssa_str year
drop if ssa_str == ""

destring ssa_str, gen(ssa)
destring fips_str, gen(fips)

rename county fips_name

drop if fips_name == "STATEWIDE"
drop if state == "PR"

unique ssa fips year
unique ssa year
unique fips year

loc n=1
bysort ssa year fips: gen sum=sum(`n')
list if sum>1
drop if sum>1
drop sum

unique ssa fips year

sort ssa year
compress

save "$data/fips/ssa_fips", replace

***********************************************************************************
** 					Merge DB-SSA and SSA-FIPS crosswalk
***********************************************************************************

use "$data/fips/db_ssa", clear
unique ssa year
merge 1:m ssa year using "$data/fips/ssa_fips"
drop if _merge==2
drop fips_name fips_str _merge

unique ssa year

* resolve non-unique SSA-Year pairs
loc n=1
bysort ssa year: egen sum=sum(`n')
list ssa fips year if sum>1
drop sum
drop if ssa==10120 & fips==12025 & (year==2014 | year==2015)
unique ssa year
xtset ssa year
xtdescribe

compress
save "$data/fips/dbe_db_ssa_fips", replace
