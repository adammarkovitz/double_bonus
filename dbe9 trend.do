cls
clear all
capture log close

log using "$log/dbe9 trend 100pct", replace

* adjusted trend in MA enrollment in never vs ever DB counties 2008-2018
use "$data/dbe_100pct", clear
keep ma year ssa $w3 tr
reg ma i.tr##i.year $w4, vce(cluster ssa)
margins, at(year=(2008(1)2018) tr=(0 1)) saving("$mat/dbe_trend_ols_100pct", replace) noestimcheck force
marginsplot
graph export "$fig/dbe_trend_ols_100pct.png", replace height(500)

log close
