**************************************************************
* Exhibit Code for Changes in Quality under Double Bonuses

**************************************************************
**			Event Study of Quality - all 9 Measures
**************************************************************

use "$mat/dbq_event_y1_100pct", clear
loc i 10
gen coef`i' = m1
gen lb`i' = m2
gen ub`i'=m3
keep coef`i' year lb`i' ub`i'
global coef $coef coef`i'
tempfile coef`i'
save `coef`i''

forvalues i=1/9 {
	use "$mat/dbq_event_dum`i'_100pct", clear
	gen coef`i' = m1
	gen lb`i' = m2
	gen ub`i'=m3
	keep coef`i' year lb`i' ub`i'
	tempfile coef`i'
	save `coef`i''
}

global coef "coef1"
use `coef1'
forvalues i=2/10 {
	append using `coef`i''
	global coef $coef coef`i'
}
	
colorpalette ptol rainbow, n(9) globals

twoway ///
(scatter $coef year, mcolor(gs13 gs13 gs13 gs13 gs11 gs11 gs11 gs11 gs13 orange_red) ///
msymbol(O D S triangle O D S triangle X triangle) msize(*.5 ..)) ///
(line $coef year, lcolor(gs13 gs13 gs13 gs13 gs11 gs11 gs11 gs11 gs13 orange_red) ///
	lw(thin thin thin thin thin thin thin thin thin medthick)) ///
(rarea lb1 ub1 year, color(gs13%5)) ///
(rarea lb2 ub2 year, color(gs13%5)) ///
(rarea lb3 ub3 year, color(gs13%5)) ///
(rarea lb4 ub4 year, color(gs13%5)) ///
(rarea lb5 ub5 year, color(gs11%5)) ///
(rarea lb6 ub6 year, color(gs11%5)) ///
(rarea lb7 ub7 year, color(gs11%5)) ///
(rarea lb8 ub8 year, color(gs11%5)) ///
(rarea lb9 ub9 year, color(gs13%5)) ///
(rarea lb10 ub10 year, color(orange_red%12) ///
ylab(-10(5)15) ///
xlab(-4(1)3) ///
yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) ///
xline(-.5, lcolor(black) lwidth(thin) lpattern(dash)) ///
text(-9 -0.3 "Double Bonuses Begin", size(*.9) place(e)) ///
xtitle("Years Relative to Start of Double-Bonus Eligibility") xscale(titlegap(2)) ///
title( ///
"Difference in Probability of Quality Measure Being Met for Medicare Advantage" ///
"Beneficiaries in Double-Bonus vs. Non-Double-Bonus Counties (Percentage Point)" ///
, just(left) size(*.63) place(11) span color(black)) ///
legend(order( ///
10 "Overall" ///
1 "Diabetic A1c Monitoring"  ///
2 "Diabetic LDL Screening"  ///
3 "Diabetic Retinopathy Screening" /// 
4 "Diabetic Nephropathy Management"  ///
5 "Breast Cancer Screening"  ///
6 "Rheumatoid Arthritis Management" /// 
7 "Statin Adherence"  ///
8 "RAS Inhibitors Adherence" ///
9 "Diabetic Medication Adherence") ///
	position(10) ring(0) cols(3) colfirst size(*.6) region(lstyle(none)) symx(*0.3) rowgap(*.5)))
graph export "$fig/dbq_event_all_measures_100pct.png", replace height(1000)

*********************************************************
**		Event Studies of DB and quality
*********************************************************

foreach z in 0 1 2 {
	use "$mat/dbq_event_y`z'_100pct", clear
	rename m1 coef
	rename m2 ci_lower
	rename m3 ci_upper
	twoway ///
	(scatter coef year, mcolor(orange_red) msize(*0.5) msym(O)) ///
	(line coef year, lcolor(orange_red)) ///
	(rarea ci_upper ci_lower year, color("214 96 77%12") ///
	ylab(-15(5)15) ///
	xlab(-4(1)3) ///
	yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) ///
	xline(-.5, lcolor(black) lwidth(thin) lpattern(dash)) ///
	text(-14 -0.3 "Double Bonuses Begin", size(*.9) place(e)) ///
	xtitle("Years Relative to Start of Double-Bonus Eligibility") xscale(titlegap(2)) ///
	title( ///
	"Difference in Quality Performance for Medicare Advantage Beneficiaries" ///
	"in Double-Bonus vs. Non-Double-Bonus Counties (Percentage Point)" ///
	, just(left) size(medsmall) place(11) span color(black)) ///
	legend(off))
	graph export "$fig/dbq_event_y`z'_100pct.png", replace height(1000)
}

**************************************************************
**			Event Study of Pr(Cov)
**************************************************************

loc x11 "Beneficiary Age"
loc x12 "(Years)"
loc x21 "Beneficiary Probability of Female Sex"
loc x22 "(Percentage Point)"
loc x31 "ZCTA % Black"
loc x32 "(Percentage Point)"
loc x41 "ZCTA % High School Education"
loc x42 "(Percentage Point)"
loc x51 "ZCTA % Living Below Poverty Level"
loc x52 "(Percentage Point)"
loc x61 "ZCTA % Unemployment"
loc x62 "(Percentage Point)"
loc x71 "Beneficiary Number of Chronic Conditions"
loc x72
loc x81 "ZCTA Median Household Income"
loc x82 "($)"
loc r1 "-3(1)3"
loc r2 "-3(1)3"
loc r3 "-3(1)3"
loc r4 "-3(1)3"
loc r5 "-3(1)3"
loc r6 "-3(1)3"
loc r7 "-2(0.5)2"
loc r8 "-6000(2000)6000"
loc n 1

foreach w in age female black educ pov unemp ccw income {
	use "$mat/dbq_event_cov_`w'_100pct", clear
	rename m1 coef
	rename m2 ci_lower
	rename m3 ci_upper
	twoway ///
	(scatter coef year, mcolor(orange_red) msize(*0.5) msym(O)) ///
	(line coef year, lcolor(orange_red)) ///
	(rarea ci_upper ci_lower year, color("214 96 77%8") ///
	xlab(-4(1)3, labsize(small)) ///
	ylab(`r`n'', labsize(small)) ///
	yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) ///
	xline(-.5, lcolor(black) lwidth(thin) lpattern(dash)) ///
	xtitle("Years Relative to Start of Double-Bonus Eligibility") xscale(titlegap(2)) ///
	title( ///
	"Difference in `x`n'1'" ///
	"in Double-Bonus vs. Non-Double Counties `x`n'2'" ///
	, just(left) size(medsmall) place(11) span color(black)) ///
	legend(off))
	graph export "$fig/dbq_event_cov_`w'_100pct.png", replace
	loc n=`n'+1
}

**************************************************************
**				Trend - Pooled
**************************************************************

use "$mat/dbq_trend1_ols_100pct", clear
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
ylab(60(5)85) ///
xsize(9) ysize(7) ///
xline(2012, lcolor(black) lwidth(thin) lpattern(dash)) ///
text(61 2012.2 "Start of Double Bonuses", size(*.9) place(e)) ///
title("Quality Performance in Medicare Advantage (%)", size(*.9) place(11) span color(black)) ///
legend(order(2 "Double Bonus" 1 "Non-Double Bonus") position(10) ring(0) ///
	col(1) region(lstyle(none)) size(small)))
graph export "$fig/dbq_trend_100pct.png", replace height(2000)

*********************************************************
**	Pre-Period Trends in MA Enrollment and Quality in DB vs non-DB
*********************************************************

use  "$mat/dbq_spline_100pct", clear

loc i=1
foreach x in m1 m2 m3 {
	gen var`i' = strofreal(round(`x', 0.01), "%4.2f")
	loc i = `i' + 1
}

loc x m4
gen var`i' = strofreal(round(`x', 0.001), "%4.3f")
loc i = `i' + 1
loc x m5
gen var`i' = strofreal(round(`x', 0.001), "%15.0fc")

gen est = var1 + " (" + var2 + ", " + var3 + ")"

keep est var4 var5

gen var = "Pre-period trend in enrollment in double-bonus vs. never double-bonus counties" in 1 
replace var = "Pre-period trend in quality in double-bonus vs. never double-bonus counties" in 2
loc x var est var4 var5
order `x'
keep `x'
export excel using "$fig/dbe_spline_100pct", replace

**************************************************************
**		Characteristics of MA enrollees in DB vs non-DB
**************************************************************

use "$mat/dbq_table1_pre_100pct", clear
rename tr0 tr00
rename tr1 tr01
rename std std0
merge 1:1 _n using "$mat/dbq_table1_post_100pct", nogen
rename tr0 tr10
rename tr1 tr11

foreach x in tr00 tr01 tr10 tr11 {
	rename `x' `x'_str
	gen `x' = strofreal(`x'_str, "%4.1f")
	replace `x' = strofreal(`x'_str, "%11.0fc") in 1/2
	replace `x' = strofreal(`x'_str, "%4.1fc") in 3
	replace `x' = strofreal(`x'_str*100, "%4.1fc") in 4
	replace `x' = strofreal(`x'_str, "%4.1fc") in 5/9	
	replace `x' = strofreal(`x'_str, "%11.0fc") in 10
}

foreach x in std0 std {
	rename `x' `x'_str
	gen `x' = strofreal(`x'_str, "%4.2f") in 3/10
}

// age female ccw black educ pov unemp income
loc n = 2
gen mod = "Beneficiary characteristics" in `n'
local ++n
replace mod = "Age" in `n'
local ++n
replace mod = "Female" in `n'
local ++n
replace mod = "No. Chronic Conditions" in `n'
local ++n
replace mod = "% Black, ZCTA-level" in `n'
local ++n
replace mod = "% At Least High School Education, ZCTA-level" in `n'
local ++n
replace mod = "% Below Poverty Level, ZCTA-level" in `n'
local ++n
replace mod = "% Unemployed, ZCTA-level" in `n'
local ++n
replace mod = "Median Household Income, ZCTA-level" in `n'

loc x mod tr01 tr00 std0 tr11 tr10 std
order `x'
keep `x'

export excel using "$fig/dbq_table1_100pct", replace

*********************************************************
**		Pre-period quality levels
*********************************************************

use "$mat/dbq_etable_quality_levels_100pct", clear

expand 2 in 1
loc i = 1
foreach x in a1 a2 {
	gen var`i' = strofreal(round(`x', 0.1), "%4.1f")
	replace var`i' = "" in 11
	drop `x'
	loc i = `i' + 1
}

loc n = 1
gen Group = "Overall Quality" in `n'
loc n = `n' + 1
replace Group = "Diabetic A1c Monitoring" in `n'
loc n = `n' + 1
replace Group = "Diabetic LDL Screening" in `n'
loc n = `n' + 1
replace Group = "Diabetic Retinopathy Screening" in `n'
loc n = `n' + 1
replace Group = "Diabetic Nephropathy Management" in `n'
loc n = `n' + 1
replace Group = "Breast Cancer Screening" in `n'
loc n = `n' + 1
replace Group = "Rheumatoid Arthritis Management" in `n'
loc n = `n' + 1
replace Group = "Adherence to Statins" in `n'
loc n = `n' + 1
replace Group = "Adherence to RAS Inhibitors" in `n'
loc n = `n' + 1
replace Group = "Adherence to Diabetes Medication" in `n'

expand 5 in 11
gen n = _n
replace n = 0 in 11
sort n

replace var1="Double-Bonus" in 1
replace var2="Non-Double-Bonus" in 1

order Group var1 var2
drop n
keep in 1/11
export excel using "$fig/dbq_levels_100pct", replace

*********************************************************
**			Bacon Decomposition
*********************************************************

use "$mat/dbq_bacon_cohort_100pct", clear

twoway ///
(scatter dd wt if group==1, mcolor(black) msym(Oh)) ///
(scatter dd wt if group==3, mcolor(gray) msym(triangle)) ///
(scatter dd wt if group==4, mcolor(black) msym(X) ///
ytitle("") ///
xlab(0(0.2)1, labsize(3.0)) xmtick(0.1(0.2)0.9, labsize(3.0)) ///
ylab(-15(5)20, labsize(3.0)) ///
yline(.9373, lcolor(red)) ///
text(0.0 0.4 "{bf:Overall DID}", placement(c) size(*.73)) ///
text(-1.3 0.4 "{bf:Estimate, +0.9pp}", placement(c) size(*.73)) ///
text(-1.0 .77 "{bf:Never Double Bonus vs.}", placement(e) size(*.7)) ///
text(-2.3 .77 "{bf:2012 Cohort, -0.3 pp}", placement(e) size(*.7)) ///
text(13.5 0.1 "{bf:Never Double Bonus vs.}", placement(e) size(*.7)) ///
text(12.2 0.1 "{bf:2016 Cohort, +14.3 pp}", placement(e) size(*.7)) ///
text(9.3 0.01 "{bf:2017 Cohort vs.}", placement(e) size(*.73)) ///
text(8.0 0.01 "{bf:2016 Cohort, +10.8pp}", placement(e) size(*.73)) ///
xtitle("2x2 DID Weight", size(4)) ///
title("2x2 DID Estimate for Change in Quality Performance (pp)" , just(left) size(4) place(11) span color(black)) ///
legend(order(1 "Later vs. Earlier Double Bonus" 2 "Never vs. Ever Double Bonus" 3 "Within (Before vs. After Double Bonus)") ///
	position(2) ring(0)	col(1) size(*.9)))
graph export "$fig/dbq_bacon_100pct.png", replace height(1000)

******************************************************************
**		Forest Plot of DID estimates of changes in quality
******************************************************************

use "$mat/dbq_did_100pct", clear

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
replace mod = "Only Counties Retaining Double Bonus Eligibility" in `n'
local ++n
replace mod = "Only Counties With Baseline MA Enrollment 20-30%" in `n'
local ++n
replace mod = "All Cohorts (Including 2016-2018 Cohorts)" in `n'
local ++n
replace mod = "Diabetic A1c Monitoring" in `n'
loc n = `n' + 1
replace mod = "Diabetic LDL Screening" in `n'
loc n = `n' + 1
replace mod = "Diabetic Retinopathy Screening" in `n'
loc n = `n' + 1
replace mod = "Diabetic Nephropathy Management" in `n'
loc n = `n' + 1
replace mod = "Breast Cancer Screening" in `n'
loc n = `n' + 1
replace mod = "Rheumatoid Arthritis Management" in `n'
loc n = `n' + 1
replace mod = "Adherence to Statins" in `n'
loc n = `n' + 1
replace mod = "Adherence to RAS Inhibitors" in `n'
loc n = `n' + 1
replace mod = "Adherence to Diabetes Medication" in `n'
loc n= `n'+ 1
replace mod = "Female" in `n'
loc n = `n' + 1
replace mod = "Male" in `n'
loc n = `n' + 1
replace mod = "Age 65 and Younger" in `n'
loc n = `n' + 1
replace mod = "Older Than Age 65" in `n'
loc n = `n' + 1
replace mod = "High Comorbidity" in `n'
loc n = `n' + 1
replace mod = "Non-High Comorbidity" in `n'
loc n = `n' + 1
replace mod = "High-Black ZCTA" in `n'
loc n = `n' + 1
replace mod = "Non-High-Black ZCTA" in `n'
loc n = `n' + 1
replace mod = "High-Education ZCTA" in `n'
loc n = `n' + 1
replace mod = "Non-High Education ZCTA" in `n'
loc n = `n' + 1
replace mod = "High Poverty ZCTA" in `n'
loc n = `n' + 1
replace mod = "Non-High Poverty ZCTA" in `n'
loc n = `n' + 1
replace mod = "High Unemployment ZCTA" in `n'
loc n = `n' + 1
replace mod = "Non-High Unemployment ZCTA" in `n'
loc n = `n' + 1
replace mod = "High Income ZCTA" in `n'
loc n = `n' + 1
replace mod = "Non-High Income ZCTA" in `n'

gen group = "Across Model Specifications" in 1/2
order group
replace group = "Across Sample Definitions" in 3/5
replace group = "Across Performance Measures" in 6/14
replace group = "Across Beneficiary Characteristics" in 15/30

gen es = C
gen lci = D
gen uci = E

gen ctrl = strofreal(round(A,0.1), "%4.1f")
gen tr = strofreal(round(B,0.1), "%4.1f")
gen pvalue = strofreal(G, "%4.3f")
replace pvalue = "<.001" if pvalue == "0.000"
gen n = strofreal(H, "%12.0fc")
gen effect = strofreal(round(es,0.1), "%4.1f") + " (" + strofreal(round(lci,0.1), "%4.1f") + ", " + strofreal(round(uci,0.1), "%4.1f") + ")"
gen percent = strofreal(round(F,0.1), "%4.1f")

admetan es lci uci, lcols(mod ctrl tr) rcols(effect pvalue percent n) by(group) ///
	nosubgroup nohet nowt saving($mat/dbq_forest, replace)

use $mat/dbq_forest, clear
label variable effect  `" `"Difference"' `"(95% CI)"' "'
label variable ctrl  `" `"Baseline"' `"Non- "' `"Double"' "'
label variable tr `" `"Baseline"' `"Double"' `"Bonus"' "'
label variable pvalue "P value"
label variable percent `" `"Difference"' `"Percent"' "'
label variable n `" `"Measure-"' `"Beneficiary-"' `"Years"' "'

label variable _LABELS ""
replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==0

order _ES
replace _ES=-100000 if _USE==0
replace _ES=100000 if _USE==6

gen by=0 if _BY==2
order by
replace by=1 if _BY==4
replace by=2 if _BY==3
replace by=3 if _BY==1

gen row=_n
order by row

gsort by _ES
bysort by: gen row2=_n
order by row row2
replace row=row2 if (by<=2)

sort by row

forestplot, lcols(ctrl tr) rcols(effect pvalue n) ///
nowt nooverall nobox nostats ///
dp(1) leftjustify spacing(1.6) astext(80) ///
xlabel(-3(1)5, format(%2.0f) nogrid) ////
text(-2.3 1 "Difference in MA Quality", size(*.5) place(c)) ///
text(-3.1 1 "Performance (pp)", size(*.5) place(c)) 
graph export "$fig/dbq_forest_100pct.png", replace height(4000)

*********************************************************************
**		Trends in Performance for 9 Quality Measures across Cohorts
*********************************************************************

loc p1 "Diabetic A1c Monitoring" 
loc p2 "Diabetic LDL Screening" 
loc p3 "Diabetic Retinopathy Screening" 
loc p4 "Diabetic Nephropathy Management" 
loc p5 "Breast Cancer Screening" 
loc p6 "Rheumatoid Arthritis Management" 
loc p7 "Adherence to Statins" 
loc p8 "Adherence to RAS Inhibitors" 
loc p9 "Adherence to Diabetes Medication"

forvalues z=1/9 {
	use "$mat/dbq_trend_dum`z'_cohort_100pct", clear
	loc x _margin _at1 _at2 _ci_lb _ci_ub
	order `x'
	keep `x'
	rename _at1 tr
	rename _at2 year

	global scatter ""
	global ub ""
	global lb ""

	forvalues i=0/6 {
		gen scatter`i' = _margin if tr==`i'
		gen lb`i' = _ci_lb if tr==`i'
		gen ub`i' = _ci_ub if tr==`i'		
		global scatter $scatter scatter`i'
		global lb $lb lb`i'
		global ub $ub ub`i'
	}
	
	twoway ///
	(scatter $scatter year, mcolor($p8 $p1 $p2 $p3 $p4 $p6 $p5) msize(*.6 ..) msym(O triangle ..)) ///
	(line $scatter year, lcolor($p8 $p1 $p2 $p3 $p4 $p6 $p5) lw(*.9 ..) ///
	ytitle("") xtitle("") ///
	xlab(2008(2)2018) ///
	ylab(0(20)100) ymtick(10(20)90) yscale(r(0 100)) ///
	xsize(10) ysize(7) ///
	title("Performance for `p`z'' (%)" , just(left) size(medsmall) place(11) span color(black)) ///
	legend(order(1 "Non-Double" 2 "2012 Cohort" 3 "2013 Cohort" 4 "2014 Cohort" ///
			5 "2015 Cohort" 6 "2016 Cohort" 7 "2017 Cohort") position(2) ring(1) ///
		col(1) region(lstyle(none)) size(small)))
	graph export "$fig/dbq_trend_dum`z'_cohort_100pct.png", replace height(1000)
	
}
