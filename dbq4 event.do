cls
clear all
capture log close

log using "$log/dbq4 event 100pct", replace

********************************************************
*  	Event study of DB and total quality performance
********************************************************

* Perform for 3 groups: 
* all cohorts
* DB cohorts entering 2012-2015 (main analysis)
* DB cohorts entering 2012-2015 and within narrow MA bandwidth
foreach z in 0 1 2 {

	use "$data/dbq_all_100pct", clear
	gen count0=1
	keep if count`z'==1
	count
	tab cohort
	keep y year fips $x time dum tr
	xtset fips
	
	xtreg y i.time i.year $x i.dum, fe vce(cluster fips)	
	mat m=J(8,3,0)
	loc n=1
	foreach i in 1 2 3 4 6 7 8 {
		loc x `i'.time
		mat m[`i',1]= _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x']
	}
	mat li m
	preserve
	clear
	svmat double m
	gen year=_n-5	
	save "$mat/dbq_event_y`z'_100pct", replace
	restore

}

********************************************************
*  	Event study of DB and quality for 6 individual performance measures
********************************************************

use "$data/dbq_100pct", clear
count
keep y year fips $x time dum tr
xtset fips

forvalues d=1/9 {
	xtreg y i.time i.year $x if dum==`d', fe vce(cluster fips)
	mat m=J(8,3,0)
	loc n=1
	foreach i in 1 2 3 4 6 7 8 {
		loc x `i'.time
		mat m[`i',1]= _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x']
	}
	mat li m
	preserve
	clear
	svmat double m
	gen year=_n-5	
	save "$mat/dbq_event_dum`d'_100pct", replace
	restore
}

********************************************************
*  	Event study of DB and Pr(Cov)
********************************************************

replace female=female*100
foreach y in $x {
	xtreg `y' i.time i.year i.dum, fe vce(cluster fips)	
	mat m=J(8,3,0)
	loc n=1
	foreach i in 1 2 3 4 6 7 8 {
		loc x `i'.time
		mat m[`i',1]= _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x']
	}
	mat li m
	preserve
	clear
	svmat double m
	gen year=_n-5	
	save "$mat/dbq_event_cov_`y'_100pct", replace
	restore
}

log close
