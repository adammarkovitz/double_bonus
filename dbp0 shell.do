/*******************************************************************************
    Impact of Double Bonuses on Black-White MA Payment Disparities 2012-2018
*******************************************************************************/

clear all
set max_memory ., perm
set more off, perm
capture log close

ssc install bacondecomp, replace
ssc install addplot, replace
ssc install maptile, replace
maptile_install using "http://files.michaelstepner.com/geo_county2014.zip"
ssc install mdesc, replace
ssc install palettes, replace

* Great Lakes:
global stars "/nfs/turbo/amryan-turbo/stars"
*global stars "Y:/stars"
global cpsc "$stars/data/cms/cpsc"
global star_rating "$stars/data/cms/star_rating"
global rate "$stars/data/cms/ratebook"
global dbp "$stars/dbp"
global data "$dbp/data"
global github "$stars/github"
global code "$github/dbp/code"
global out "$github/dbp/out"
global log "$out/log"
global mat "$out/mat"
global fig "$out/figure"

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

do "$code/dbp1 plans"
do "$code/dbp2 stars"
do "$code/dbp3 ratebook"
do "$code/dbp4 regional"
do "$code/dbp5 db rate"
do "$code/dbp6 db impact"
