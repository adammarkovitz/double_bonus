cls
clear all
capture log close

log using "$log/dbq8 bacon 100pct", replace

* collapse to quality measure-FIPS-year data set for Goodman-Bacon decomposition
use "$data/dbq_all_100pct", clear
gen wt=1
forvalues i=2/9 {
	gen d`i'=(dum==`i')
}

gcollapse (max) exp time cohort itt tr db_year (mean) $x y ma $dum (sum) wt, by(fips year)

bysort fips: egen fipss=mode(fips), maxmode
loc n=1
bysort fips: egen count=sum(`n')
bysort fips: egen wtt=sum(wt)
compress
save "$data/dbq_fips_year_100pct", replace

* estimate Goodman-Bacon decomposition for each 2x2 estimate and weight
use "$data/dbq_fips_year_100pct", clear
keep if count==11
xtset fips year
xtdescribe

bacondecomp y itt $x $dum [pw=wtt], vce(cluster fipss) stub(Bacon_)
est sto a
graph export "$fig/dbq_bacon_cohort_100pct.png", replace height(1000)

keep in 1/22
keep Bacon*
drop Bacon_R2 Bacon_gp
rename Bacon_T tr
rename Bacon_C ctrl
rename Bacon_cgroup group
rename Bacon_B dd

mat w = e(wt)'
svmat w
rename w1 wt

mat a = (e(b),.) \ e(sumdd)
svmat a

loc x group tr ctrl wt dd a1 a2
order `x'
keep `x'

save "$mat/dbq_bacon_cohort_100pct", replace
