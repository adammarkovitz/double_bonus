clear all
capture log close

log using "$log/dbe4 did 001pct", replace

********************************************************
*  	DiD estimates of DB and MA Enrollment
********************************************************

mat m = J(22,12,0)
loc n = 1

* Main Model: ITT estimate of Pr(MA) before/after DB
use "$data/dbe_001pct", clear
count
keep ma ma2 year $w3 itt tr db ssa
xtset ssa

qui reg ma i.year##i.tr $w4 if year<=2011
margins, at(tr=(1 0) year=2011)
mat a = r(table)

xtreg ma itt i.year $w4, fe vce(cluster ssa)
loc x "itt"
mat m[`n',1] = a[1,1], a[1,2], _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], _b[`x']/a[1,1], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
loc n = `n' + 1

* Time-varying estimate of Pr(MA) before/after DB
xtreg ma db i.year $w4, fe vce(cluster ssa)
loc x "db"
mat m[`n',1] = a[1,1], a[1,2], _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], _b[`x']/a[1,1], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
loc n = `n' + 1

* MA defined as last vs 1st month enrollment
qui reg ma2 i.year##i.tr $w4 if year<=2011
margins, at(tr=(1 0) year=2011)
mat a = r(table)

xtreg ma2 itt i.year $w4, fe vce(cluster ssa)
loc x "itt"
mat m[`n',1] = a[1,1], a[1,2], _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], _b[`x']/a[1,1], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
loc n = `n' + 1

* MA defined as all or nothing (12mo vs 0 mo)
use "$data/dbe_001pct", clear
keep if ma3 !=.
keep ma3 year $w3 itt tr db ssa
xtset ssa

qui reg ma3 i.year##i.tr $w4 if year<=2011
margins, at(tr=(1 0) year=2011)
mat a = r(table)

xtreg ma3 itt i.year $w4, fe vce(cluster ssa)
loc x "itt"
mat m[`n',1] = a[1,1], a[1,2], _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], _b[`x']/a[1,1], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
loc n = `n' + 1

* among DB counties that remained in DB (no exit)
use "$data/dbe_001pct", clear
keep if exit==0
keep ma year $w3 itt tr db ssa
xtset ssa

qui reg ma i.year##i.tr $w4 if year<=2011
margins, at(tr=(1 0) year=2011)
mat a = r(table)

xtreg ma itt i.year $w4, fe vce(cluster ssa)
loc x "itt"
mat m[`n',1] = a[1,1], a[1,2], _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], _b[`x']/a[1,1], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
loc n = `n' + 1

* among DB counties within MA 20-30% bandwidth
use "$data/dbe_001pct", clear
keep if ma25==1
keep ma year $w3 itt tr db ssa
xtset ssa

qui reg ma i.year##i.tr $w4 if year<=2011
margins, at(tr=(1 0) year=2011)
mat a = r(table)

xtreg ma itt i.year $w4, fe vce(cluster ssa)
loc x "itt"
mat m[`n',1] = a[1,1], a[1,2], _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], _b[`x']/a[1,1], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
loc n = `n' + 1

* among all DB counties (cohorts 1-7)
use "$data/mbsf_all_001pct", clear
keep if female!=. & race!= . & tr!=.
tab cohort
keep ma year $w3 itt tr db ssa
xtset ssa

qui reg ma i.year##i.tr $w4 if year<=2011
margins, at(tr=(1 0) year=2011)
mat a = r(table)

xtreg ma itt i.year $w4, fe vce(cluster ssa)
loc x "itt"
mat m[`n',1] = a[1,1], a[1,2], _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], _b[`x']/a[1,1], 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
loc n = `n' + 1

* DDD across subgroups
use "$data/dbe_001pct", clear
keep ma year $w3 itt tr ssa count1 count2
gen byte age66 =(age>=66)
xtset ssa

foreach y in female age66 race orig dual {		
	loc m=`n'+1
	* levels
	qui reg ma i.`y'##i.year##i.tr if year<=2011
	margins, at(tr=(1 0) year=2011 `y'=(1 0)) force noestimcheck
	mat a = r(table)
	mat m[`n',1]=a[1,1..2]\a[1,3..4]
	* regression model
	xtreg ma i.`y'##(itt i.year i.tr), fe vce(cluster ssa)
	sca n=e(N)
	* ITT for covariate=1 (eg female)
	lincom _b[1.`y'#1.itt]+_b[1.itt]
	mat m[`n',3]=r(estimate),r(lb),r(ub), (100*r(estimate)/m[`n',1]), r(p), e(N)
	* ITT for covariate=0 (eg male)
	loc x 1.itt
	mat m[`m',3] = _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], (100*_b[`x']/m[`n',1]), 2*ttail(e(df_r),abs(_b[`x']/_se[`x'])), e(N)
	* Difference in ITT across covariate (eg female vs male)
	loc x 1.`y'#1.itt
	mat m[`n',9] = _b[`x'], _b[`x'] - invttail(e(df_r),0.025)*_se[`x'], _b[`x'] + invttail(e(df_r),0.025)*_se[`x'], 2*ttail(e(df_r),abs(_b[`x']/_se[`x']))
	loc n=`n'+2
	loc m=`n'+1
	mat li m
	}
}

* save
clear
mat li m
svmat double m
save "$mat/dbe_did_001pct", replace

log close
