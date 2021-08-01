cls
clear all
capture log close

log using "$log/dbq5 did 100pct", replace

mat m = J(30,12,0)
loc n = 1

********************************************************
*  	DiD estimates of DB and quality in MA
********************************************************

use "$data/dbq_100pct", clear
keep y tr db itt year $x dum fips exit ma25

qui reg y i.year##i.tr $x i.dum if year<=2011
margins, at(tr=(1 0) year=2011)
mat a = r(table)

* Main Model: ITT estimate
xtset fips
xtreg y itt i.year $x i.dum, fe vce(cluster fips)
loc x "itt"
mat m[`n',1] = a[1,1], a[1,2], _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], 100*_b[`x']/a[1,1], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
loc n = `n' + 1

* Time-varying estimate
xtreg y db i.year $x i.dum, fe vce(cluster fips)
loc x "db"
mat m[`n',1] = a[1,1], a[1,2], _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], 100*_b[`x']/a[1,1], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
loc n = `n' + 1

* Among non-exiting counties
qui reg y i.year##i.tr $x i.dum if exit==0 & year<=2011
margins, at(tr=(1 0) year=2011)
mat a = r(table)
xtreg y itt i.year $x i.dum if exit==0, fe vce(cluster fips)
loc x "itt"
mat m[`n',1] = a[1,1], a[1,2], _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], 100*_b[`x']/a[1,1], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
loc n = `n' + 1

* Among narrow MA bandwidth
qui reg y i.year##i.tr $x i.dum if ma25==1 & year<=2011
margins, at(tr=(1 0) year=2011)
mat a = r(table)
xtreg y itt i.year $x i.dum if ma25==1, fe vce(cluster fips)
loc x "itt"
mat m[`n',1] = a[1,1], a[1,2], _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], 100*_b[`x']/a[1,1], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
loc n = `n' + 1

* Among all cohorts
use "$data/dbq_all_100pct", clear
keep y tr db itt year $x dum fips
qui reg y i.year##i.tr $x i.dum if year<=2011
margins, at(tr=(1 0) year=2011)
mat a = r(table)
xtreg y itt i.year $x i.dum, fe vce(cluster fips)
loc x "itt"
mat m[`n',1] = a[1,1], a[1,2], _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], 100*_b[`x']/a[1,1], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
loc n = `n' + 1

********************************************************
*  	DiD estimates of DB and quality - measures
********************************************************

use "$data/dbq_100pct", clear
keep y tr db itt year $x dum fips
xtset fips

forvalues i=1/9 {
	qui reg y i.year##i.tr $x if year<=2011 & dum==`i'
	margins, at(tr=(1 0) year=2011)
	mat a = r(table)
	xtreg y itt i.year $x if dum==`i', fe vce(cluster fips)
	loc x "itt"
	mat m[`n',1] = a[1,1], a[1,2], _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], 100*_b[`x']/a[1,1], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
	loc n = `n' + 1
}

********************************************************
*  	DiD estimates of DB and quality - subgroups
********************************************************

use "$data/dbq_100pct", clear
keep y tr db itt year $x dum fips

gen byte age66=(age>=66)

loc m=`n'+1

foreach y in female age66 {
	* levels
	qui reg y `y'##i.year##i.tr i.dum $z if year<=2011
	margins, at(tr=(1 0) year=2011 `y'=(1 0)) force noestimcheck
	mat a = r(table)
	mat m[`n',1]=a[1,1..2]\a[1,3..4]
	* ITT
	xtreg y `y'##(itt i.year i.tr) i.dum $z, fe vce(cluster fips)
	margins, dydx(itt) at(`y'=(1 0)) post noestimcheck force
	mat a = r(table)'
	mat a = a[3..4, 1], a[3..4, 5..6], (100*a[3,1]/m[`n',1] \ 100*a[4,1]/m[`m',1]), a[3..4, 4], (e(N)\e(N))
	* difference in ITT across margins (e.g., high vs low black population %)
	lincom _b[1.itt:1._at]-_b[1.itt:2._at]
	mat b=r(estimate),r(estimate)-invnormal(0.975)*r(se),r(estimate)+invnormal(0.975)*r(se), 2*normal(-abs(r(estimate)/r(se)))
	mat b = b\(.,.,.,.)	
	mat m[`n',3] = a,b
	loc n=`n'+2
	loc m=`n'+1
}

foreach y in ccw black educ pov unemp income {
	tempvar x
	gquantiles `x'=`y', xtile nq(4)
	sca q=r(min)
	tempvar h
	gen `h'=(`x'==4)
	* levels
	qui reg y `h'##i.year##i.tr i.dum $z if year<=2011
	margins, at(tr=(1 0) year=2011 `h'=(1 0)) force noestimcheck
	mat a = r(table)
	mat m[`n',1]=a[1,1..2]\a[1,3..4]
	* ITT
	xtreg y `h'##(itt i.year i.tr) i.dum $z, fe vce(cluster fips)
	margins, dydx(itt) at(`h'=(1 0)) post noestimcheck force
	mat a = r(table)'
	mat a = a[3..4, 1], a[3..4, 5..6], (100*a[3,1]/m[`n',1] \ 100*a[4,1]/m[`m',1]), a[3..4, 4], (e(N)\e(N))
	* difference in ITT across margins (e.g., high vs low black population %)
	lincom _b[1.itt:1._at]-_b[1.itt:2._at]
	mat b=r(estimate),r(estimate)-invnormal(0.975)*r(se),r(estimate)+invnormal(0.975)*r(se), 2*normal(-abs(r(estimate)/r(se)))
	mat b = b\(.,.,.,.)	
	mat m[`n',3] = a,b
	loc n=`n'+2
	loc m=`n'+1
}

mat li m
clear
svmat double m
save "$mat/dbq_did`z'_100pct", replace

log close
