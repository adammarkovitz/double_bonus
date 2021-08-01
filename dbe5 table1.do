clear all
capture log close

log using "$log/dbe5 table1 100pct", replace

********************************************************
*  		Sample description
********************************************************

* overall means
use "$data/dbe_100pct", clear
keep bene_id year db itt ma
count
unique bene_id

* post-period averages
keep if year>=2012
sum itt db ma

******************************************************************************		
** Table 1: DB vs never-DB in pre-period (2008-2011)
******************************************************************************		

* standardized differences (2008-2011 vs 2012-2018)
loc p0 pre
loc p1 post
forvalues i=0/1 {
	use "$data/dbe_100pct", clear
	gen byte post=(year>=2012)
	keep if post==`i'
	keep year race $w2 tr ma bene_id
	drop black
	gen byte white = (race==0)
	gen byte black = (race==1)
	gen byte hispanic = (race==2)
	gen byte asian = (race==3)
	gen byte other = (race==4)
	foreach y in female orig dual white black hispanic asian other {
		replace `y'=`y'*100
	}
	* tab
	tab tr, matcell(c)
	mat c = c[2,1],c[1,1],0
	
	* unique
	unique bene_id if tr == 1
	sca b = r(unique)
	unique bene_id if tr == 0
	mat b = b, r(unique), 0
	
	* std diff
	covbal tr age female orig dual white black hispanic asian other
	mat a = r(table)
	mat a = c \ b \ a[1..9,1], a[1..9,4], a[1..9,7]
	clear
	svmat a
	rename a1 tr1
	rename a2 tr0
	rename a3 std
	save "$mat/dbe_table1_`p`i''_100pct", replace
}

log close
