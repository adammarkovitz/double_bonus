cls
clear all
set more off, perm
capture log close

log using "$log/dbq3 table1 100pct", replace

******************************************************************************		
** 	Characteristics of MA benes in ever-DB vs never-DB counties
******************************************************************************		

* standardized differences (2008-2011 vs 2012-2018)
loc p0 pre
loc p1 post
forvalues i=0/1 {
	use  "$data/dbq_100pct", clear
	gen post = (year>=2012)
	keep if post==`i'
	keep y $x year tr patid
	
	* tab
	tab tr, matcell(c)
	mat c = c[2,1],c[1,1],0
	
	* unique
	unique patid if tr == 1
	sca b = r(unique)
	unique patid if tr == 0
	mat b = b, r(unique), 0

	* std diff
	covbal tr $x 
	mat a = r(table)
	mat a = c \ b \ a[1..8,1], a[1..8,4], a[1..8,7]
	clear
	svmat double a
	rename a1 tr1
	rename a2 tr0
	rename a3 std

	save "$mat/dbq_table1_`p`i''_100pct", replace
}

********************************************************************************
** 	Average pre-period quality performance for DB vs never DB counties
********************************************************************************

use "$data/dbq_100pct", replace
count
keep y year tr $x dum
keep if year<=2011
reg y i.tr##i.dum $x i.year
est sto a
margins, at(tr=(1 0))
mat a = r(table)
mat li a
mat a0 = a[1,1], a[1,2]
est resto a
margins, at(tr=(1 0) dum=(1(1)9))
mat a = r(table)'
mat a1 = a[1..9,1]
mat a2 = a[10..18,1]
mat a = (a0) \ (a2, a1)
mat li a
clear
svmat double a
save "$mat/dbq_etable_quality_levels_100pct", replace

log close
