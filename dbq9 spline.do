cls
clear all
capture log close

log using "$log/dbq9 spline 100pct", replace

********************************************************
*  	Spline Estimates of MA enrollment in DB vs non-DB
********************************************************

use "$data/dbe_100pct", clear
keep ma tr year ssa race age female orig dual

mkspline sp1 2012 sp2 = year

xtset ssa
loc x "i.race age female orig dual"
xtreg ma i.tr##(c.sp1 c.sp2) `x', fe vce(cluster ssa)


loc x "1.tr#c.sp1"
mat m1 = _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)

********************************************************
*  	Spline Estimates of Quality in DB vs non-DB
********************************************************

use "$data/dbq_100pct", clear
keep y tr year fips dum age female ccw black educ pov unemp income
mkspline sp1 2012 sp2 = year
xtset fips
loc x "age female ccw black educ pov unemp income"
xtreg y i.tr##(c.sp1 c.sp2) `x' i.dum, fe vce(cluster fips)

loc x "1.tr#c.sp1"
mat m2 = _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)

mat m = m1\m2
mat li m
clear
svmat double m

save "$mat/dbq_spline_100pct", replace

log close