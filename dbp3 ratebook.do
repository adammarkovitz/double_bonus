* define double-bonus eligibility for each county
* define payment rates across star ratings for each county

***********************************************************************************
** 2012-2020 MA Rate Calculation Files to determine Double-Bonus Status
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
rename v29 rate_50star
rename v30 rate_45star
rename v31 rate_40star
rename v32 rate_35star
rename v33 rate_30star
rename v34 rate_25star
gen uspcc = 743.54
rename v15 ffs
gen year=`i'
keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year rate_50star rate_45star rate_40star rate_35star rate_30star rate_25star
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
rename v27 rate_50star
rename v28 rate_45star
rename v29 rate_40star
rename v30 rate_35star
rename v31 rate_30star
rename v32 rate_25star
gen uspcc = 767.99
gen year=`i'
keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year rate_50star rate_45star rate_40star rate_35star rate_30star rate_25star
tempfile db_`i'
save `db_`i''

loc drop_2014 = 27
loc i 2014
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
rename v28 rate_50star
rename v29 rate_45star
rename v30 rate_40star
rename v31 rate_35star
rename v32 rate_30star
rename v33 rate_25star
gen uspcc = 795.11
gen year=`i'
keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year rate_50star rate_45star rate_40star rate_35star rate_30star rate_25star
tempfile db_`i'
save `db_`i''

loc drop_2015 = 27
loc i 2015
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
rename v32 rate_50percentbonus
rename v33 rate_35percentbonus
rename v34 rate_0percentbonus
gen uspcc = 795.11
gen year=`i'
keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year rate_50percentbonus rate_35percentbonus rate_0percentbonus
tempfile db_`i'
save `db_`i''

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
rename v34 rate_50percentbonus
rename v35 rate_35percentbonus
rename v36 rate_0percentbonus
gen uspcc = 800.21
gen year=`i'
keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year rate_50percentbonus rate_35percentbonus rate_0percentbonus
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
rename v35 rate_50percentbonus
rename v36 rate_35percentbonus
rename v37 rate_0percentbonus
gen uspcc = 825.20
gen year=`i'
keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year rate_50percentbonus rate_35percentbonus rate_0percentbonus
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
rename v36 rate_50percentbonus
rename v37 rate_35percentbonus
rename v38 rate_0percentbonus
gen uspcc = 847.73
gen year=`i'
keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year rate_50percentbonus rate_35percentbonus rate_0percentbonus
tempfile db_`i'
save `db_`i''

loc i 2019
loc drop_2019 = 23
insheet using "$rate/risk`i'.csv", comma clear
drop in 1/`drop_`i''
rename v1 ssa
rename v2 state
rename v3 county
rename v25 urban_floor
rename v27 mapen_25
rename v29 ffs_lower
rename v30 qualifying
rename v14 ffs
rename v26 mapen
rename v35 rate_50percentbonus
rename v36 rate_35percentbonus
rename v37 rate_0percentbonus
gen uspcc = 891.07
gen year=`i'
keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year rate_50percentbonus rate_35percentbonus rate_0percentbonus
tempfile db_`i'
save `db_`i''

loc i 2020
loc drop_2020 = 27
insheet using "$rate/risk`i'.csv", comma clear
drop in 1/`drop_`i''
rename v1 ssa
rename v2 state
rename v3 county
rename v25 urban_floor
rename v27 mapen_25
rename v29 ffs_lower
rename v30 qualifying
rename v28 ffs
rename v26 mapen
rename v35 rate_50percentbonus
rename v36 rate_35percentbonus
rename v37 rate_0percentbonus
gen uspcc = 940.81
gen year=`i'
keep ssa state county urban_floor mapen_25 ffs_lower ffs mapen uspcc qualifying year rate_50percentbonus rate_35percentbonus rate_0percentbonus
tempfile db_`i'
save `db_`i''

use `db_2012'
forvalues i=2013/2020 {
	append using `db_`i''
}

drop if ssa==""
drop if state=="AMERCAN SAMOA" | state=="AMERICAN SAMOA" | state == "American Samoa" | ///
state=="NORTHERN MARIANA ISLANDS" | state=="Northern Mariana Isl" | ///
state=="PR" | state=="GU" | state=="VI" 

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

rename county ssa_name
rename ssa ssa_str
destring ssa_str, gen(ssa) force

* tr
bysort ssa: egen tr=max(db)

* Destring payment rates
loc x rate_50star rate_45star rate_40star rate_35star rate_30star rate_25star rate_50percentbonus rate_35percentbonus rate_0percentbonus
foreach x in `x' {
	replace `x' = subinstr(`x',",", "",.)
	destring `x', replace
}

compress

save "$data/ratebook_full", replace

use  "$data/ratebook_full", clear
loc x ssa ssa_name state year db rate_50star rate_45star rate_40star rate_35star rate_30star rate_25star rate_50percentbonus rate_35percentbonus rate_0percentbonus
order `x'
keep `x'
save "$data/ratebook", replace

use "$data/ratebook", clear
keep ssa state
duplicates drop ssa state, force
save "$data/ssa_state_crosswalk", replace
