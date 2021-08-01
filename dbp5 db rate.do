********************************************************************************
**		Merge: Plan/Contract, Star, Ratebook			      **
********************************************************************************

use "$data/contract_plan", clear
keep if year<=2018
drop if plantype=="Medicare Prescription Drug Plan" | plantype=="Employer/Union Only Direct Contract PDP"
count
gen keep = ( plantype=="HMO/HMOPOS" | plantype=="Local PPO" | plantype=="PFFS" | plantype=="Regional PPO")
sum keep

* 1) Regional PPOs
use "$data/contract_plan", clear
keep if year<=2018
keep if plantype=="Regional PPO"
gen regional=1

* a) Merge with regional rates
merge m:1 ssa year using "$data/region_ssa_rates", nogen keep(match)

* b) merge with star rating data
merge m:1 contractid year using "$data/star_ratings", nogen keep(match)

tempfile a
save `a'

* 2) HMO/POS and local PPOs
use "$data/contract_plan", clear
keep if year<=2018
keep if plantype=="HMO/HMOPOS" | plantype=="Local PPO" | plantype=="PFFS"
gen regional=0

* a) merge with county-level ratebook data 
merge m:1 ssa year using "$data/ratebook", nogen keep(match)

* b) merge with star rating data
merge m:1 contractid year using "$data/star_ratings", nogen keep(match)

* 3) append regional PPOs and HMO/local PPOs
append using `a'

* 4) merge with race/ethnicity data from MBSF
merge m:1 ssa year using "$stars/data/mbsf_ssa_year_100pct"
drop if _merge==2
drop _merge

********************************************************************************
** Estimate payment for each plan as f(star rating, count/region)
********************************************************************************

* Drop if both partC and partCD stars data insufficient
drop if star_partC_str=="Not Applicable" & star_partCD_str=="Not Applicable"
drop if star_partC_str=="Not enough data to calculate summary rating" & star_partCD_str=="Not enough data to calculate overall rating"
drop if star_partC_str=="Not enough data to calculate summary rating" & star_partCD_str==""
drop if star_partC_str=="Not enough data available" & star_partCD_str=="Not enough data available"
drop if star_partC_str=="Not enough data available" & star_partCD_str==""
drop if star_partC_str=="Not enough data available" & star_partCD_str=="Not Applicable"

gen star=.
replace star=star_partCD if star_partCD!=.
replace star=star_partC if star==. & star_partC!=.

* DB received = in DB county + high-star rating (3+ 2012-2014, 4+ 2015-2020)
gen db_received=0
replace db_received = 1 if db==1 & ((star>=3 & star<=5 & year<=2014) | star>=4 & star<=5 & year>=2015)

**********************************************************
**		Rates 2012-2014 QBP Demo		**
**********************************************************

* convert monthly rates to annual rates 
loc x rate_50star rate_45star rate_40star rate_35star rate_30star rate_25star rate_50percentbonus rate_35percentbonus rate_0percentbonus
foreach x in `x' {
	replace `x'=`x'*12
}

gen rate=.

* rates based on star ratings
replace rate=rate_50star if star==5 & year<=2014
replace rate=rate_45star if star==4.5 & year<=2014
replace rate=rate_40star if star==4 & year<=2014
replace rate=rate_35star if star==3.5 & year<=2014
replace rate=rate_30star if star==3 & year<=2014
replace rate=rate_25star if star<=2.5 & year<=2014

* rates based on new plans: 3% in 2012, 3% in 2013, 3.5% in 2014
replace rate=rate_25star*1.03 if star==. & (star_partC_new==1 | star_partCD_new==1) & year==2012
replace rate=rate_25star*1.03 if star==. & (star_partC_new==1 | star_partCD_new==1) & year==2013
replace rate=rate_25star*1.035 if star==. & (star_partC_new==1 | star_partCD_new==1) & year==2014

**********************************************************
**		Rates for 2015-2020 QBP			**
**********************************************************

** 5%-10% if 4+ stars (incorporated DB)
replace rate=rate_50percentbonus if (star>=4 & star<=5) & year>=2015
** 0% if <4 stars
replace rate=rate_0percentbonus if (star>=1.5 & star<=3.5) & year>=2015
* 3.5% if new plan
replace rate=rate_35percentbonus if star==. & (star_partC_new==1 | star_partCD_new==1) & year>=2015

* 5 star rates
gen rate5 =rate_50star if year<=2014
replace rate5=rate_50percentbonus if year>2014

* calculate benchmark payments: observed payment for low-star contracts
gen benchmark=rate_25star if year<=2014
replace benchmark=rate_0percentbonus if year>=2015

drop star_partC_new star_partCD_new rate_50star rate_45star rate_40star rate_35star rate_30star rate_25star rate_50percentbonus rate_35percentbonus rate_0percentbonus

* calculate bonus
gen bonus=rate-benchmark

* benchmark bonus
gen bbonus=bonus if db_received==0
replace bbonus=bonus/2 if db_received==1

* double bonus (incremental effect, ie half of total bonus if high-star plan in DB county)
gen dbonus=0
replace dbonus = (rate-benchmark)/2 if db_received==1

* generate whole star ratings for regression
gen istar=star*2		// stars need to be integers
replace istar=0 if star==.	// other star category for missing star (too new)

compress
save "$data/star_rates", replace
