cls
clear all
capture log close

log using "$log/dbe7 db formation100pct", replace

********************************************************
*  Association between beneficiary race and residing in DB county
********************************************************

use "$data/mbsf_all_100pct", clear

* restrict to only MA beneficiaries in the post-DB period (2012 onward) - include all cohorts
keep if female!=. & race!= . & db!=. & ma==100 & year>=2012
count
count if year==2018
count if race==1
count if race==0
tab race

keep year ssa race age female orig dual db ffs_lower mapen_25 urban_floor
mdesc

mat a=J(4,12,0)
loc j=1
loc k=1
foreach y in db {
	logit `y' i.race age female orig dual i.year, vce(cluster ssa)
	est sto a
	* adjusted pr(residing in a DB county)
	margins
	* black-white disparities in pr(residing in a DB county)
	margins, at(race=(1 0)) post
	mat b=r(table)'*100
	mat a[1,`j']=b[1..2,1], b[1..2,5..6]
	lincom _b[1._at]-_b[2._at]
	mat a[3,`j']=r(estimate)*100, r(lb)*100, r(ub)*100
	nlcom -(1-(_b[1._at]/_b[2._at]))*100, post
	mat a[4,`j'] = _b[_nl_1], _b[_nl_1] - invnormal(0.975)*_se[_nl_1], _b[_nl_1] + invnormal(0.975)*_se[_nl_1]
	loc j =`j'+3
}
 
* black-white disparities in pr(criteria for DB eligibility)
* 1) average county-level FFS spending below national average
* 2) baseline MA enrollment of at least 25% in 2009
* 3) urban floo designation in 2004
foreach y in ffs_lower mapen_25 urban_floor {
	logit `y' i.race age female orig dual i.year, vce(cluster ssa)
	margins, at(race=(1 0)) post
	mat b=r(table)'*100
	mat a[1,`j']=b[1..2,1], b[1..2,5..6]
	lincom _b[1._at]-_b[2._at]
	mat a[3,`j']=r(estimate)*100, r(lb)*100, r(ub)*100
	nlcom -(1-(_b[1._at]/_b[2._at]))*100, post
	mat a[4,`j'] = _b[_nl_1], _b[_nl_1] - invnormal(0.975)*_se[_nl_1], _b[_nl_1] + invnormal(0.975)*_se[_nl_1]
	loc j =`j'+3

}
mat li a
clear
svmat a
save "$mat/dbe_formation_100pct", replace

log close
