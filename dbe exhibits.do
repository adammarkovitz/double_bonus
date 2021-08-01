colorpalette RdBu, n(8) reverse globals

set scheme s2color
grstyle init
grstyle graphsize x 5.5
grstyle graphsize y 4.5
grstyle color background white
grstyle anglestyle vertical_tick horizontal
grstyle yesno draw_major_hgrid yes
grstyle color major_grid gs8
grstyle linewidth major_grid thin
grstyle linepattern major_grid dot
grstyle linewidth plineplot medthick
grstyle yesno grid_draw_min yes
grstyle yesno grid_draw_max yes

*********************************************************
**		Exhibit 2: event study of DB and MA enrollment
*********************************************************

foreach z in 0 1 2 {
	use "$mat/dbe_event_ma`z'_100pct", clear
	rename m1 coef
	rename m2 ci_lower
	rename m3 ci_upper
	twoway ///
	(scatter coef year, mcolor(orange_red) msize(*0.5) msym(triangle)) ///
	(line coef year, lcolor(orange_red)) ///
	(rarea ci_upper ci_lower year, color("214 96 77%12") ///
	ylab(-10(5)10)  xlab(-4(1)3) ///
	yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) ///
	xline(-.5, lcolor(black) lwidth(thin) lpattern(dash)) ///
	text(-9 -0.3 "Double Bonuses Begin", size(*.9) place(e)) ///
	xtitle("Years Relative to Start of Double-Bonus Eligibility") xscale(titlegap(2)) ///
	title( ///
	"Difference in Enrollment in Medicare Advantage for Beneficiaries" ///
	"in Double-Bonus vs. Non-Double-Bonus Counties (Percentage Point)" ///
	, just(left) size(medsmall) place(11) span color(black)) ///
	legend(off))
	graph export "$fig/dbe_event_ma`z'_100pct.png", replace height(1000)
}

*********************************************************
**			Event study of DB and Pr(Cov) - MA vs non-mA
*********************************************************

loc y1 "Beneficiary Probability of Black"
loc y11 "(pp)"
loc y2 "Beneficiary Probability of Dual Medicaid"
loc y21 "(pp)"
loc y3 "Beneficiary Probability of Disability/ESRD"
loc y31 "(pp)"
loc y4 "Beneficiary Probability of Female"
loc y41 "(pp)"
loc y5 "Beneficiary Age"
loc y51 "(Years)"

loc n=1
foreach y in black dual orig female age {
	use "$mat/dbe_event_cov_`y'_100pct", clear
	loc i=1
	foreach m in 1 4 7 {
		loc j=`m'+1
		loc k=`m'+2
		gen coef`i'=m`m'
		gen lb`i'=m`j'
		gen ub`i'=m`k'
		loc i=`i'+1
	}
	twoway ///
	(scatter coef3 year, mcolor(orange_red) msize(*0.5) msym(triangle)) ///
	(line coef3 year, lcolor(orange_red)) ///
	(rarea ub3 lb3 year, color("214 96 77%12") ///
	ylab(-6(2)6) ///
	xlab(-4(1)3) ///
	yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) ///
	xline(-.5, lcolor(black) lwidth(thin) lpattern(dash)) ///
	text(-5.8 -0.3 "Double Bonuses Begin", size(*.9) place(e)) ///
	xtitle("Years Relative to Start of Double-Bonus Eligibility") xscale(titlegap(2)) ///
	title( ///
		"Differential Change in `y`n'' in MA vs. TM" ///
		"in Double-Bonus vs. Non-Double Counties `y`n'1'" ///
		, just(left) size(3) place(11) span color(black)) ///	
	legend(off))
	graph export "$fig/dbe_event_cov_`y'`z'_100pct.png", replace height(1000)
	loc n=`n'+1
}

*********************************************************
**		Combined Map Exhibit
*********************************************************

use "$mat/mbsf_fips_100pct", clear
rename fips county
replace black=black*100
sum black

_pctile black, nq(3)
return list

gen qt=.
replace qt=1 if black<0.4 & tr==0
replace qt=2 if black>=0.4 & black <4.7 & tr==0
replace qt=3 if black>= 4.7 & tr==0
replace qt=4 if black<0.4 & tr==1
replace qt=5 if black>=0.4 & black <4.7 & tr==1
replace qt=6 if black>= 4.7 & tr==1

gen qt2=.
replace qt2=3 if qt==1
replace qt2=2 if qt==2
replace qt2=1 if qt==3
replace qt2=4 if qt==4
replace qt2=5 if qt==5
replace qt2=6 if qt==6

maptile qt2, geo(county2014) ///
cutvalues(1.5 2.5 3.5 4.5 5.5) ///
fcolor(RdBu) ///
ndfcolor(gs15) ///
twopt(legend(symx(*0.9) rowgap(*.5) size(*.7)  ///
order( /// 
4 "Non-Double: 0.0-0.3%" ///
3 "Non-Double: 0.4-4.6%" ///
2 "Non-Double: 4.7-88.4%" ///
5 "Double-Bonus: 0.0-0.3%" ///
6 "Double-Bonus:0.4-4.6%" ///
7 "Double-Bonus:4.7-88.4%" ///
1 "No Data") ///
title("{bf:Share of Black}" "{bf:Beneficiaries (%)}", size(*.6) just(center))))
graph export "$fig/map_db_black_lab1.png", replace height(1000)

*********************************************************
**		efig: Map of DB cohort
*********************************************************

colorpalette RdBu, n(8) reverse globals

*use "$mat/map_cohort_100pct", replace
use "$mat/mbsf_fips_100pct", clear

rename fips county
tab cohort
maptile cohort, geo(county2014) cutvalues(0.99(1)6.99) ///
fcolor(gs10 ///
orange_red*1 orange_red*.85 orange_red*.7 orange_red*.65 ///
dknavy*1 dknavy*.85 dknavy*.7) ///
ndfcolor(gs15) legd(0) ///
twopt(legend(symx(*0.9) rowgap(*.5) ///
lab(9 "2018 Cohort") lab(8 "2017 Cohort") ///
lab(7 "2016 Cohort") lab(6 "2015 Cohort") ///
lab(5 "2014 Cohort") lab(4 "2013 Cohort") ///
lab(3 "2012 Cohort") lab(2 "Never Double") ///
lab(1 "Missing Data") ///
title("{bf:Double-Bonus}", size(*.7) just(center))))
graph export "$fig/dbe_map_cohort_100pct.png", replace height(1000)

*********************************************************
**			Bacon Decomposition
*********************************************************

use "$mat/dbe_bacon_cohort_100pct", clear

twoway ///
(scatter dd wt if group==1, mcolor(black) msym(Oh)) ///
(scatter dd wt if group==3, mcolor(gray) msym(triangle)) ///
(scatter dd wt if group==4, mcolor(black) msym(X) ///
ytitle("") ///
xlab(0(0.2)1, labsize(3.0)) xmtick(0.1(0.2)0.9, labsize(3.0)) ///
ylab(-15(5)10, labsize(3.0)) ///
yline(-.457, lcolor(red)) ///
text(1.3 0.45 "{bf:Overall DID}", placement(c) size(*.73)) ///
text(0.3 0.45 "{bf:Estimate, -0.5pp}", placement(c) size(*.73)) ///
text(6.0 0.02 "{bf:Never Double Bonus vs.}", placement(e) size(*.7)) ///
text(5.0 0.02 "{bf:2018 Cohort, +6.5 pp}", placement(e) size(*.7)) ///
text(-1.0 .77 "{bf:Never Double Bonus vs.}", placement(e) size(*.7)) ///
text(-2.0 .77 "{bf:2012 Cohort, -0.4 pp}", placement(e) size(*.7)) ///
xtitle("2x2 DID Weight", size(4)) ///
title("2x2 DID Estimate for Change in MA Enrollment (pp)" , just(left) size(4) place(11) span color(black)) ///
legend(order(1 "Later vs. Earlier Double Bonus" 2 "Never vs. Ever Double Bonus" 3 "Within (Before vs. After Double Bonus)") ///
	position(2) ring(0)	col(1) size(*.9)))
graph export "$fig/dbe_bacon_100pct.png", replace height(1000)

*********************************************************
**		table: db formation
*********************************************************

* table of association between black race and pr(DB eligibility)
use "$mat/dbe_formation_100pct", clear
loc j = 1
loc k = 2
loc l = 3
loc e = 1
forvalues e=1/4 {
	di `j' `k' `l'
	gen b`e' = strofreal(round(a`j', 0.1), "%4.1f") + " (" + strofreal(round(a`k', 0.1), "%4.1f") + ", " + strofreal(round(a`l', 0.1), "%4.1f") + ")" in 1/3
	replace b`e' = strofreal(round(a`j', 1), "%4.0f") + " (" + strofreal(round(a`k', 1), "%4.0f") + ", " + strofreal(round(a`l', 1), "%4.0f") + ")" in 4
	drop a`j' a`k' a`l'
	loc e=`e'+1
	loc j=`j'+3
	loc k=`k'+3
	loc l=`l'+3
}

keep b*

export excel using "$fig/dbe_formation_100pct", replace

*********************************************************
**		figure: trend in MA enrollment in ever-DB vs never-DB counties 2008-2018
*********************************************************

use "$mat/dbe_trend_ols_100pct", clear
loc x _margin _at1 _at2 _ci_lb _ci_ub
order `x'
keep `x'
rename _at1 tr
rename _at2 year

global scatter ""
global ub ""
global lb ""

forvalues i=0/1 {
	gen scatter`i' = _margin if tr==`i'
	gen lb`i' = _ci_lb if tr==`i'
	gen ub`i' = _ci_ub if tr==`i'		
	global scatter $scatter scatter`i'
	global lb $lb lb`i'
	global ub $ub ub`i'
}

twoway ///
(scatter $scatter year, mcolor($p2 $p8) msize(*.6 ..) msym(O triangle)) ///
(line $scatter year, lcolor($p2 $p8) lw(*.9 ..)) ///
(rarea lb0 ub0 year, color("67 147 195%15")) ///
(rarea lb1 ub1 year, color("214 96 77%15") ///
ytitle("") xtitle("") ///
xlab(2008(2)2018) xscale(range(2008 2018)) ///
ylab(0(10)60) ///
xsize(9) ysize(7) ///
xline(2012, lcolor(black) lwidth(thin) lpattern(dash)) ///
text(2 2012.2 "Start of Double Bonuses", size(*.9) place(e)) ///
title("Medicare Advantage Enrollment (%)", size(medsmall) place(11) span color(black)) ///
legend(order(2 "Double Bonus" 1 "Non-Double Bonus") position(10) ring(0) ///
	col(1) region(lstyle(none)) size(*0.9)))
	
graph export "$fig/dbe_trend_100pct.png", replace height(2000)

*********************************************************
**		efig db exit
*********************************************************

use "$mat/dbe_exit_bene_100pct", clear
loc k = 1
loc j = 2
forvalues i=1(2)16 {
	gen var`i' = strofreal(a`i', "%15.0fc")
	gen var`j' = strofreal(round(a`j', 1), "%4.0f")
	gen b`k'=var`i' + " (" + var`j' + "%)"
	loc j = `j' + 2
	loc k = `k' + 2
}
keep b*

replace b1 = substr(b1, 1, 5) in 1
loc n = 8
foreach i in 15 13 11 9 7 5 {
	replace b`i'="" in `n'/8
	loc n = `n'-1
}

expand 2 in 8
gen n=_n
replace n=0 in 9
sort n
replace b1="" in 1
replace b3="" in 1

gen b0=""
loc n=1
loc n=1
replace b0="Beneficiary-level" in `n'
loc ++n
replace b0="Eligible for double-bonus 2012-2018" in `n'
loc ++n
forvalues i=2012/2018 {
	replace b0="Starting in `i'" in `n'
	loc ++n
}
order b0

tempfile a
save `a'

use "$mat/dbe_exit_ssa_100pct", clear
loc k = 1
loc j = 2
forvalues i=1(2)16 {
	gen var`i' = strofreal(a`i', "%15.0fc")
	gen var`j' = strofreal(round(a`j', 1), "%4.0f")
	gen b`k'=var`i' + " (" + var`j' + "%)"
	loc j = `j' + 2
	loc k = `k' + 2
}
keep b*

replace b1 = substr(b1, 1, 5) in 1
loc n = 8
foreach i in 15 13 11 9 7 5 {
	replace b`i'="" in `n'/8
	loc n = `n'-1
}

expand 2 in 8
gen n=_n
replace n=0 in 9
sort n
replace b1="" in 1
replace b3="" in 1

gen b0=""
loc n=1
loc n=1
replace b0="County-level" in `n'
loc ++n
replace b0="Eligible for double-bonus 2012-2018" in `n'
loc ++n
forvalues i=2012/2018 {
	replace b0="Starting in `i'" in `n'
	loc ++n
}
order b0
append using `a'
drop n

export excel using "$fig/dbe_exit_100pct", replace

*********************************************************
**		efig descriptive table
*********************************************************

use "$mat/dbe_table1_pre_100pct", clear
rename tr0 tr00
rename tr1 tr01
rename std std0
merge 1:1 _n using "$mat/dbe_table1_post_100pct", nogen
rename tr0 tr10
rename tr1 tr11
order tr00 tr01 tr10 tr11 

foreach x in tr00 tr01 tr10 tr11 {
	rename `x' `x'_str
	gen `x' = strofreal(`x'_str, "%11.0fc") in 1/2
	replace `x' = strofreal(`x'_str, "%4.1fc") in 3/11
}

foreach x in std0 std {
	rename `x' `x'_str
	gen `x' = strofreal(`x'_str, "%4.2f") in 3/11
}

loc x tr01 tr00 std0 tr11 tr10 std
order `x'
keep `x'

export excel using "$fig/dbe_table1_100pct", replace

*********************************************************
**		forest plot: difference-in-difference estimates
*********************************************************
 
use "$mat/dbe_did_100pct", replace

tempvar drop
gen `drop'=0
forvalues i=10(4)26 {
	replace `drop'=1 in `i'
}
forvalues i=11(4)27 {
	replace `drop'=1 in `i'
}
drop if `drop'==1

di %16.0fc m8

loc i=1
loc x A B C D E F G H
foreach x in `x' {
	rename m`i' `x'
	loc i=`i'+1
}

gen mod = ""
order mod
local n = 1
replace mod = "Intention-To-Treat Double Bonus (Current/Prior)" in `n'
local ++n
replace mod = "Time-Varying Double Bonus (Given Year)" in `n'
local ++n
replace mod = "MA enrollment in December (vs. January)" in `n'
local ++n
replace mod = "MA enrollment for entire year (vs. January)" in `n'
local ++n
replace mod = "Only Counties Retaining Double-Bonus Eligibility" in `n'
local ++n
replace mod = "Only Counties With Baseline MA Enrollment 20-30%" in `n'
local ++n
replace mod = "All Cohorts (Including 2016-2018 Cohorts)" in `n'
local ++n
replace mod = "Female" in `n'
local ++n
replace mod = "Male" in `n'
local ++n
replace mod = "Age 66 and Older" in `n'
local ++n
replace mod = "Age 65 and Younger" in `n'
local ++n
replace mod = "Black" in `n'
local ++n
replace mod = "White" in `n'
local ++n
replace mod = "Entitled Due to Disability/ESRD" in `n'
local ++n
replace mod = "Entitled Due to Old Age" in `n'
local ++n
replace mod = "Medicaid Dual-Eligibility" in `n'
local ++n
replace mod = "Non-Medicaid" in `n'
local ++n

gen group = "Across Model Specifications" in 1/4
order group
replace group = "Across Sample Definitions" in 5/7
replace group = "Across Beneficiary Characteristics" in 8/17

gen es = C
gen lci = D
gen uci = E

gen ctrl = strofreal(round(A,0.1), "%4.1f")
gen tr = strofreal(round(B,0.1), "%4.1f")
gen pvalue = strofreal(G, "%4.3f")
replace pvalue = "<.001" if pvalue == "0.000"
gen n = strofreal(H, "%16.0fc")
replace n = "583,038,891" in 1/3
replace n = "583,038,891" in 8/17

gen effect = strofreal(round(es,0.1), "%4.1f") + " (" + strofreal(round(lci,0.1), "%4.1f") + ", " + strofreal(round(uci,0.1), "%4.1f") + ")"

admetan es lci uci, lcols(mod ctrl tr) rcols(effect pvalue n) by(group) ///
	nosubgroup nohet nowt saving($mat/dbe_forest, replace)

use $mat/dbe_forest, clear
label variable effect  `" `"Difference"' `"(95% CI)"' "'
label variable ctrl  `" `"Baseline"' `"Non- "' `"Double"' "'
label variable tr `" `"Baseline"' `"Double"' `"Bonus"' "'
label variable pvalue "P value"
label variable n `" `"Beneficiary-"' `"Years"' "'

label variable _LABELS ""
replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==0

order _ES
replace _ES=-100000 if _USE==0
replace _ES=100000 if _USE==6

gen by=0 if _BY==2
order by
replace by=1 if _BY==3
replace by=2 if _BY==1

gen row=_n
order by row

gsort by _ES
bysort by: gen row2=_n
order by row row2
replace row=row2 if (by==0 | by==1)

sort by row

forestplot, lcols(ctrl tr) rcols(effect pvalue n) ///
nowt nooverall nobox nostats ///
dp(1) leftjustify spacing(1.6) astext(80) ///
xlabel(-4(1)4, format(%2.0f) nogrid) ///
xlabel(,labsize(*1.1)) ///
graphregion(color(white)) ///
text(-2 0 "Difference in MA Enrollment (pp)", size(*.6) place(c))
graph export "$fig/dbe_forest_100pct.png", replace height(4000)
