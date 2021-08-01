/*******************************************************************************
            Impact of Double Quality Bonuses on MA Enrollment, 2008-2012
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

global w1 ""
global w2 "black age female orig dual"
global w3 "race age female orig dual"
global w4 "i.race c.age i.female i.orig i.dual"
global w5 "black hispanic asian other age female orig dual"
global time 1.time 2.time 3.time 5.time 6.time 7.time 8.time

* Great Lakes:
global stars "/nfs/turbo/amryan-turbo/stars"
global data "$stars/data"
global rate "$stars/data/cms/ratebook"
global dbe "$stars/dbe"
global github "$stars/github"
global code "$github/code"
global out "$github/out"
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

do "$dbe/dbe1 db ssa"
do "$dbe/dbe2 clean"
do "$dbe/dbe3 event"
do "$dbe/dbe4 did"
do "$dbe/dbe5 table1"
do "$dbe/dbe6 db exit"
do "$dbe/dbe7 db formation"
do "$dbe/dbe8 bacon"
do "$dbe/dbe9 trend"
do "$dbe/dbe10 consort"
do "$dbe/dbe exhibits"


