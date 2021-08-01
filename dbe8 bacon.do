cls
clear all
capture log close

log using "$log/dbe8 bacon 100pct", replace

* collapse to SSA-year level
use "$data/mbsf_all_100pct", clear
keep if female!=. & race!= . & tr!=.
keep exp time cohort itt tr db_year $w3 y ma ssa year
gen wt=1
gen byte black = (race==1)
gen byte hispanic = (race==2)
gen byte asian = (race==3)
gen byte other = (race==4)
drop race

gcollapse (max) exp time cohort itt tr db_year (mean) $w5 ma (sum) wt, by(ssa year)

bysort ssa: egen wtt=sum(wt)
tempvar n
gen `n'=1
bysort ssa: egen count=count(`n')

bysort ssa: egen ssas=mode(ssa), maxmode

save "$data/dbe_bacon_100pct", replace

* bacon decomposition
use "$data/dbe_bacon_100pct", clear
xtset ssa year
xtdescribe
keep if count==11

bacondecomp ma itt $w5 [pw=wtt], vce(cluster ssas) stub(Bacon_)

graph export "$fig/dbe_bacon_cohort_100pct.png", replace height(1000)

keep in 1/29
keep Bacon*
drop Bacon_R2 Bacon_gp
rename Bacon_T tr
rename Bacon_C ctrl
rename Bacon_cgroup group
rename Bacon_B dd

* rename Bacon_S wt
mat w = e(wt)'
svmat w
rename w1 wt

mat a = (e(b),.) \ e(sumdd)
svmat a

loc x group tr ctrl wt dd a1 a2
order `x'
keep `x'

save "$mat/dbe_bacon_cohort_100pct", replace

log close
