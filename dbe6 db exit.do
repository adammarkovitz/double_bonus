cls
clear all
capture log close

log using "$log/dbe6 db exit 100pct", replace

* collapse to county-year data set
use "$data/mbsf_all_100pct", clear
keep if female!=. & race!= . & tr!=.
keep if tr==1 & year>=2012
replace exit_year=2012 if exit_year==2019
keep tr db itt exit_year cohort ssa year
gen byte wt=1
gcollapse (sum) wt (max) tr db itt exit_year cohort, by(ssa year)
gen female=1
gen race=1
save "$data/ssa_year_100pct", replace

********************************************************
*  				DB exit patterns
********************************************************

* estimate patterns of county- and bene- level attrition from DB eligibility

loc f0 mbsf_all_100pct
loc f1 ssa_year_100pct
loc p0 dbe_exit_bene_100pct
loc p1 dbe_exit_ssa_100pct

forvalues z=0/1 {
	use "$data/`f`z''", clear
	keep if female!=. & race!= . & tr!=.
	keep if tr==1 & year>=2012
	replace exit_year=2012 if exit_year==2019
	keep tr db itt exit_year cohort ssa year

	loc c=0
	mat a`c' = J(1,16,0)
	qui count
	sca n = r(N)
	loc j=1
	mat a`c'[1,`j']=n,0
	loc j=`j'+2
	forvalues x=2012/2018 {
		qui count if exit_year==`x' & tr==1
		mat a`c'[1,`j']=r(N), 100*r(N)/n
		loc j=`j'+2
	}
	
	mat a = J(7,16,0)
	forvalues c=1/7 {
		mat a`c' = J(1,16,0)
		qui count if cohort==`c'
		sca b = r(N)
		sca b1 = 100*(b/n)
		loc j=1
		mat a`c'[1,`j']=b,b1
		loc j=`j'+2
		forvalues x=2012/2018 {
			qui count if exit_year==`x' & cohort==`c'
			mat a`c'[1,`j']=r(N), 100*r(N)/b
			loc j=`j'+2
		}
		
		mat a[`c',1] =a`c' 
	}

	mat a = a0\a

	tab cohort
	tab cohort exit_year, row

	mat li a
	clear
	svmat double a

	save "$mat/`p`z''", replace
}

log close
