clear all
capture log close

log using "$log/dbe3 event 001pct", replace

********************************************************
*  	Event study of DB and Pr(MA enrollment)
********************************************************

use "$data/mbsf_all_001pct", clear
keep if female!=. & race!= . & tr!=.
count
keep ma year ssa $w3 time black count1 count2 tr
xtset ssa

* estimates across 3 samples: all cohorts, cohorts 2012-215 (main analysis), and cohorts 2012-2015 with MA baseline 20-30%
foreach z in 0 1 2 {
	gen count0=1
	xtreg ma i.time i.year $w4 if count`z'==1, fe vce(cluster ssa)
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
	save "$mat/dbe_event_ma`z'_001pct", replace
	restore
}

********************************************************
*  	Event study of DB and Pr(Cov) across MA vs non-MA
********************************************************

use "$data/dbe_001pct", clear
count
keep ma year ssa $w3 time black count1 count2 tr
xtset ssa

replace ma=ma/100
foreach y in black dual orig female {
	replace `y'=`y'*100
}

foreach y in black dual orig age female {
	xtreg `y' i.ma##(i.time i.year i.tr), fe vce(cluster ssa)
	est sto a
	mat m=J(8,9,0)
	loc n=1
	foreach i in 1 2 3 4 6 7 8 {
		loc x `i'.time
		mat m[`i',1]= _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x']
		qui lincom _b[`i'.time]+_b[1.ma#`i'.time]
		mat m[`i',4]=r(estimate),r(lb),r(ub)
		loc x 1.ma#`i'.time
		mat m[`i',7]= _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x']
	}
	mat li m
	preserve
	clear
	svmat double m
	gen year=_n-5	
	save "$mat/dbe_event_cov_`y'_001pct", replace
	restore
}

log close
