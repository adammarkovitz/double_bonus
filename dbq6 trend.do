cls
clear all
capture log close

log using "$log/dbq6 trend 100pct", replace

********************************************************
*  	Adjusted trend in quality across 9 performance measures and 6 DB cohorts
********************************************************

use "$data/dbq_all_100pct", clear 
keep y cohort year $x dum fips
keep if cohort<=6
forvalues i=1/9 {
	reg y i.cohort##i.year $x if dum==`i', vce(cluster fips)
	margins, at(year=(2008(1)2018) cohort=(0(1)6)) saving("$mat/dbq_trend_dum`i'_cohort_100pct", replace) noestimcheck force
	marginsplot
	graph export "$fig/dbq_trend_dum`i'_cohort_100pct.png", replace height(1000)
}

********************************************************
*  	Adjusted trend in total quality across DB vs non-DB
********************************************************

use "$data/dbq_100pct", clear
keep y tr year $x dum fips
reg y i.tr##i.year $x i.dum, vce(cluster fips)
margins, at(year=(2008(1)2018) tr=(0 1)) saving("$mat/dbq_trend1_ols_100pct", replace) noestimcheck force
marginsplot
graph export "$fig/dbq_trend1_ols_100pct.png", replace height(1000)

log close
