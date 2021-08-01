********************************************************************************
**	Estimate  Average Marginal Cost of Double-Bonus Policy		      **
********************************************************************************

use "$data/star_rates", clear

sum star
// mean star rating 3.75
tab plantype
// HMO/HMOPOS (36%), Local POS (41%), PFFS (6%), Regional PPO (17%)

reg db_received c.benchmark i.istar i.year [pw=enroll]
margins
// 22.7% of MA benes were enrolled in high-quality plan in DB county 2012-2018

* step 0: average spending overall and for black/white benes
loc x black hispanic asian other age female orig dual
reg rate `x' c.benchmark i.istar i.year [pw=enroll]
est sto a
margins, post
sca spend = _b[_cons]
sca li spend
// $10,245 - average spending
est resto a
margins, at(black=(0 1)) post
sca spend_white = _b[1._at]
sca li spend_white
// $10,252 - average white spending
sca spend_black = _b[2._at]
sca li spend_black
// $10,181 - average black spending

* step 1: marginal effect of DB county on payment rates
reg rate db c.benchmark i.istar i.year [pw=enroll]
// n=293,434 plan-years
// n=101,627,486 beneficiary-years (enrollment weighted)

sca diff_rate=_b[db]
sca li diff_rate
// Rates in DB vs non-DB counties DB differ by $319

* step 2: exposure to DB (from MBSF)
sca db_exp=.2685562 // mean DB exposure
sca db_exp_black=.1877
sca db_exp_white=.2867422
sca db_exp_disp=db_exp_black-db_exp_white
sca li db_exp_disp

* step 3: absolute effect of DB county on payment rates ($)
sca db_effect = db_exp*diff_rate
sca li db_effect
// DB raises payments by 85.36 / $85 per bene per year

sca db_effect_black = diff_rate*db_exp_black
sca li db_effect_black
// DB raise black payments by $59.66 / $60

sca db_effect_white = diff_rate*db_exp_white
sca li db_effect_white
// DB raise white payments by $91.14 / $91

sca db_effect_disp=diff_rate*(db_exp_black-db_exp_white)
sca li db_effect_disp
// Black-White disparity is -$31.48 / -$31

* step 4: relative effect of DB on payment rates (%)
sca db_effect_pct = 100*db_effect/spend
sca li db_effect_pct
// DB raises average MA spending by 0.83% / 0.8%

sca db_effect_black_pct = 100*db_effect_black/spend_black
sca li db_effect_black_pct
// DB raise black payments by 0.59% / 0.6%

sca db_effect_white_pct = 100*db_effect_white/spend_white
sca li db_effect_white_pct
// DB raise white payments by 0.89% / 0.9%

sca db_effect_disp_pct=db_effect_black_pct-db_effect_white_pct
sca li db_effect_disp_pct
// Black-White disparity is -0.30pp / -0.3pp

* Step 5: aggregate effect of DB on payments 2012-2018
di %15.0fc db_effect*119866713
// $10.2b in DB payments total

di %15.0fc db_effect*21017528
// $1.8b in DB payments in 2018

di %15.0fc db_effect_disp*14162321
// -$446m black-white disparity in DB payments

********************************************************************************
**	 	Wayne County (Detroit) vs Lapeer County			      **
********************************************************************************

use "$data/star_rates", clear
keep if state=="MI"
keep if ssa_name=="LAPEER" | ssa_name=="WAYNE"
duplicates drop ssa_name year, force 
loc x ssa_name year db benchmark rate5
order `x'
keep `x'

gen bonus=rate5-benchmark
gen double_bonus=bonus/2 if db==1
replace double_bonus=0 if db==0

gsort year -ssa_name
keep if year==2017
list
/*
ssa_name	year	db	benchmark	rate5	bonus	double_bonus
WAYNE	2017	0	9761.04	10274.76	513.7197	0
LAPEER	2017	1	9447	10391.76	944.7598	472.3799
*/

// calculated diff: $456.65
mat a=9761.04*.05
mat b=9447*.10 
mat c=b-a
mat li c

// observed diff: $431.04
mat a=513.7197
mat b=944.7598
mat c=b-a
mat li c
