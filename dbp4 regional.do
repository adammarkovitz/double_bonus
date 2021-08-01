* define payment rates across star ratings for each region

** clean region-state crosswalk
insheet using "$rate/region_state.csv", comma clear
reshape long state, i(region)
keep if state!=""
drop _j

* merge to get SSA codes
merge 1:m state using "$data/ssa_state_crosswalk", nogen
sort region state ssa

compress
save "$data/region_state_ssa_crosswalk", replace

forvalues i=2012/2014 {
	insheet using "$rate/regionalrate`i'.csv", comma clear
	drop in 1/2
	rename v1 region
	rename v2 rate_50star
	rename v3 rate_45star
	rename v4 rate_40star
	rename v5 rate_35star
	rename v6 rate_30star
	rename v7 rate_25star
	gen year=`i'
	loc x region year rate_50star rate_45star rate_40star rate_35star rate_30star rate_25star
	keep `x'
	order `x'
	tempfile a`i'
	save `a`i''  
}

forvalues i=2015/2018 {
	insheet using "$rate/regionalrate`i'.csv", comma clear
	drop in 1/2
	rename v1 region
	rename v2 rate_0percentbonus
	rename v3 rate_35percentbonus
	rename v4 rate_50percentbonus
	gen year=`i'
	loc x region year rate_0percentbonus rate_35percentbonus rate_50percentbonus
	keep `x'
	order `x'
	tempfile a`i'
	save `a`i''
}

use `a2012'
forvalues i=2013/2018 {
	append using `a`i''
}

loc x region rate_50star rate_45star rate_40star rate_35star rate_30star rate_25star rate_0percentbonus rate_35percentbonus rate_50percentbonus
foreach x in `x' {
	destring `x', replace
}

* merge to SSA level
joinby region using "$data/region_state_ssa_crosswalk"

unique year ssa

order region ssa year
sort region ssa year
drop state
compress
save "$data/region_ssa_rates", replace
