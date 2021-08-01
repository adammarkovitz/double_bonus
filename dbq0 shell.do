/*******************************************************************************
	     Impact of Double Quality Bonuses on MA Quality, 2008-2012
*******************************************************************************/

clear all
set maxvar 120000, perm
set max_memory ., perm
set more off, perm
capture log close

ssc install bacondecomp, replace
ssc install addplot, replace
ssc install maptile, replace
maptile_install using "http://files.michaelstepner.com/geo_county2014.zip"
ssc install mdesc, replace
ssc install palettes, replace

global x age female ccw black educ pov unemp income
global z c.age i.female c.ccw c.black c.educ c.pov c.unemp c.income
global dum d2 d3 d4 d5 d6 d7 d8 d9
global time 1.time 2.time 3.time 4.time 6.time 7.time 8.time

* Great Lakes:
global stars "/nfs/turbo/amryan-turbo/stars"
global data "$stars/data"
global rate "$stars/data/cms/ratebook"
global dbq "$stars/dbq"
global code "$stars/github/dbq/code"
global out "$stars/github/dbq/out"
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

*do "$code/dbq1 clean"
do "$code/dbq2 consort"
do "$code/dbq3 table1"
do "$code/dbq4 event"
do "$code/dbq5 did"
do "$code/dbq6 trend"
do "$code/dbq7 spline"
do "$code/dbq8 bacon"
do "$code/dbq exhibits"
