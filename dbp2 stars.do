* Define Star Ratings for all contracts

***********************************************************************************
** 2012 files

import delimited using ///
  "$star_rating/2012_Part_C_Report_Card_Master_Table_2011_11_01_Summary.csv", ///
  delimiters(",") varnames(2) stripquotes(yes) clear
rename contractnumber contractid
gen year=2012
gen PartC_Summary_Star=.
gen PartCD_Summary_Star=.
forvalues x=1.5(.5)5 {
  replace PartC_Summary_Star=`x' if partcsummaryrating=="`x' out of 5 stars"
  replace PartC_Summary_Star=`x' if partcsummaryrating=="`x' stars"
  replace PartCD_Summary_Star=`x' if overallrating=="`x' out of 5 stars"
  replace PartCD_Summary_Star=`x' if overallrating=="`x' stars"  
}
rename partcsummaryrating star_partC_str
rename overallrating star_partCD_str
loc x contractid year PartC_Summary_Star PartCD_Summary_Star parentorganization organizationtype star_partC_str star_partCD_str
order `x'
keep `x'
tempfile stars_2012
save `stars_2012', replace
sum

***********************************************************************************
** 2013 files

import delimited using ///
  "$star_rating/2013_Part_C_Report_Card_Master_Table_2012_10_17_Summary.csv", ///
  delimiters(",") varnames(2) stripquotes(yes) clear
rename contractnumber contractid
gen year=2013
gen PartC_Summary_Star=.
gen PartCD_Summary_Star=.
forvalues x=1.5(.5)5 {
  replace PartC_Summary_Star=`x' if partcsummaryrating=="`x'"
  replace PartCD_Summary_Star=`x' if overallrating=="`x'"
}
rename partcsummaryrating star_partC_str
rename overallrating star_partCD_str
loc x contractid year PartC_Summary_Star PartCD_Summary_Star parentorganization organizationtype star_partC_str star_partCD_str
order `x'
keep `x'
tempfile stars_2013
save `stars_2013', replace
sum

***********************************************************************************
** 2014 files

import delimited using ///
  "$star_rating/2014_Part_C_Report_Card_Master_Table_2013_10_17_summary.csv", ///
  delimiters(",") varnames(2) stripquotes(yes) clear
rename contractnumber contractid
gen year=2014
gen PartC_Summary_Star=.
gen PartCD_Summary_Star=.
forvalues x=1.5(.5)5 {
  replace PartC_Summary_Star=`x' if partcsummaryrating=="`x'"
  replace PartCD_Summary_Star=`x' if overallrating=="`x'"
}
rename partcsummaryrating star_partC_str
rename overallrating star_partCD_str
loc x contractid year PartC_Summary_Star PartCD_Summary_Star parentorganization organizationtype star_partC_str star_partCD_str
order `x'
keep `x'
tempfile stars_2014
save `stars_2014', replace

***********************************************************************************
** 2015 files

import delimited using ///
  "$star_rating/2015_Report_Card_Master_Table_2014_10_03_summary.csv", ///
  delimiters(",") varnames(2) stripquotes(yes) clear
rename contractnumber contractid
gen year=2015
gen PartC_Summary_Star=.
gen PartCD_Summary_Star=.
forvalues x=1.5(.5)5 {
  replace PartC_Summary_Star=`x' if partcsummary=="`x'"
  replace PartCD_Summary_Star=`x' if overall=="`x'"
}
rename partcsummary star_partC_str
rename overall star_partCD_str
loc x contractid year PartC_Summary_Star PartCD_Summary_Star parentorganization organizationtype star_partC_str star_partCD_str
order `x'
keep `x'
tempfile stars_2015
save `stars_2015', replace

***********************************************************************************
** 2016 files

import delimited using ///
  "$star_rating/2016_Report_Card_Master_Table_2015_10_02_summary.csv", ///
  delimiters(",") varnames(2) stripquotes(yes) clear
rename contractnumber contractid
gen year=2016
gen PartC_Summary_Star=.
gen PartCD_Summary_Star=.
forvalues x=1.5(.5)5 {
  replace PartC_Summary_Star=`x' if partcsummary=="`x'"
  replace PartCD_Summary_Star=`x' if overall=="`x'"
}
rename partcsummary star_partC_str
rename overall star_partCD_str
loc x contractid year PartC_Summary_Star PartCD_Summary_Star parentorganization organizationtype star_partC_str star_partCD_str
order `x'
keep `x'
tempfile stars_2016
save `stars_2016', replace

***********************************************************************************
** 2017 files

import delimited using ///
  "$star_rating/2017_Report_Card_Master_Table_2016_10_26_summary.csv", ///
  delimiters(",") varnames(2) stripquotes(yes) clear
rename contractnumber contractid
gen year=2017
gen PartC_Summary_Star=.
gen PartCD_Summary_Star=.
forvalues x=1.5(.5)5 {
  replace PartC_Summary_Star=`x' if partcsummary=="`x'"
  replace PartCD_Summary_Star=`x' if overall=="`x'"
}
rename partcsummary star_partC_str
rename overall star_partCD_str
loc x contractid year PartC_Summary_Star PartCD_Summary_Star parentorganization organizationtype star_partC_str star_partCD_str
order `x'
keep `x'
tempfile stars_2017
save `stars_2017', replace

***********************************************************************************
** 2018 files

import delimited using ///
  "$star_rating/2018_Report_Card_Master_Table_2017_11_01_summary.csv", ///
  delimiters(",") varnames(2) stripquotes(yes) clear
rename contractnumber contractid
gen year=2018
gen PartC_Summary_Star=.
gen PartCD_Summary_Star=.
forvalues x=1.5(.5)5 {
  replace PartC_Summary_Star=`x' if partcsummary=="`x'"
  replace PartCD_Summary_Star=`x' if overall=="`x'"
}
rename partcsummary star_partC_str
rename overall star_partCD_str
loc x contractid year PartC_Summary_Star PartCD_Summary_Star parentorganization organizationtype star_partC_str star_partCD_str
order `x'
keep `x'
tempfile stars_2018
save `stars_2018', replace

***********************************************************************************
** 2019 files

import delimited using ///
  "$star_rating/2019_Report_Card_Master_Table_2018_11_13_summary.csv", ///
  delimiters(",") varnames(2) stripquotes(yes) clear
rename contractnumber contractid
gen year=2019
gen PartC_Summary_Star=.
gen PartCD_Summary_Star=.
forvalues x=1.5(.5)5 {
  replace PartC_Summary_Star=`x' if partcsummary=="`x'"
  replace PartCD_Summary_Star=`x' if overall=="`x'"
}
rename partcsummary star_partC_str
rename overall star_partCD_str
loc x contractid year PartC_Summary_Star PartCD_Summary_Star parentorganization organizationtype star_partC_str star_partCD_str
order `x'
keep `x'
tempfile stars_2019
save `stars_2019', replace

***********************************************************************************
** 2020 files

import delimited using ///
  "$star_rating/2020 Star Ratings Data Table - Summary Stars (Oct 21 2019).csv", ///
  delimiters(",") varnames(2) stripquotes(yes) clear
rename contractnumber contractid
gen year=2020
gen PartC_Summary_Star=.
gen PartCD_Summary_Star=.
forvalues x=1.5(.5)5 {
  replace PartC_Summary_Star=`x' if partcsummary=="`x'"
  replace PartCD_Summary_Star=`x' if overall=="`x'"
}

rename partcsummary star_partC_str
rename overall star_partCD_str
loc x contractid year PartC_Summary_Star PartCD_Summary_Star parentorganization organizationtype star_partC_str star_partCD_str
order `x'
keep `x'
tempfile stars_2020
save `stars_2020', replace

***********************************************************************************
/* Clean and Append Data */
***********************************************************************************

use `stars_2012', clear
forvalues i=2013/2020 {
	append using `stars_`i''
}
compress

gen star_partC_insuff=0
replace star_partC_insuff=1 if (star_partC_str== "Not enough data to calculate summary rating" | ///
star_partC_str== "Not enough data available")

gen star_partCD_insuff=0
replace star_partCD_insuff=1 if (star_partCD_str== "Not enough data to calculate summary rating" | ///
star_partC_str== "Not enough data available")

gen star_partC_new= (star_partC_str=="Plan too new to be measured")
gen star_partCD_new= (star_partCD_str=="Plan too new to be measured")

gen star_partC_na= (star_partC_str=="Not Applicable")
gen star_partCD_na= (star_partCD_str=="Not Applicable")

* generate numeric star variables
foreach x in C CD {
	replace star_part`x'_str=strtrim(star_part`x'_str)
	gen star_part`x' = .
	replace star_part`x' = 1.5 if star_part`x'_str=="1.5"
	replace star_part`x' = 2 if star_part`x'_str=="2" | star_part`x'_str=="2 out of 5 stars"
	replace star_part`x' = 2.5 if star_part`x'_str=="2.5" | star_part`x'_str=="2.5 out of 5 stars"
	replace star_part`x' = 3 if star_part`x'_str=="3" | star_part`x'_str=="3 out of 5 stars"
	replace star_part`x' = 3.5 if star_part`x'_str=="3.5" | star_part`x'_str=="3.5 out of 5 stars"
	replace star_part`x' = 4 if star_part`x'_str=="4" | star_part`x'_str=="4 out of 5 stars"
	replace star_part`x' = 4.5 if star_part`x'_str=="4.5" | star_part`x'_str=="4.5 out of 5 stars"
	replace star_part`x' = 5 if star_part`x'_str=="5" | star_part`x'_str=="5 stars"

}

// check correlation
sum PartC_Summary_Star star_partC PartCD_Summary_Star star_partCD
	
compress

save "$data/star_ratings", replace
