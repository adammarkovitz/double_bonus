***********************************************************************************
* MA plan enrollment data
***********************************************************************************

insheet using "$cpsc/CPSC_Enrollment_Info_2012_01.csv", comma clear

* Enrollment
forvalues i=2012(1)2020 {
	loc monthlist "01 02 03 04 05 06 07 08 09 10 11 12"
	foreach m of loc monthlist {
		insheet using "$cpsc/CPSC_Enrollment_Info_`i'_`m'.csv", comma clear
		drop if enrollment=="*" 
		destring enrollment, replace

		capture confirm variable contractnumber
		if !_rc {
		  rename contractnumber contractid
		}

		capture confirm variable ssastatecountycode
		if !_rc {
		  rename ssastatecountycode ssa
		}

		capture confirm variable fipsstatecountycode
		if !_rc {
		  rename fipsstatecountycode fips
		}

		keep contractid planid ssa fips enrollment
		compress
		tempfile a_`m'
		save `a_`m''
	}

	use `a_01'
	loc monthlist "02 03 04 05 06 07 08 09 10 11 12"
	foreach m of loc monthlist {
	append using `a_`m''
	}
	compress
	bysort contractid planid ssa: egen fipss=mode(fips), maxmode
	replace fips=fipss
	drop fipss

	gcollapse (mean) enrollment (first) fips, by(contractid planid ssa)
	gen int year=`i'
	compress
	save "$cpsc/plan_enrollment_`i'", replace
}

* MA plan contract information
forvalues i=2012(1)2020 {
	* Clean Contract Info
	loc monthlist "01 02 03 04 05 06 07 08 09 10 11 12"
	loc mo=1
	foreach m of loc monthlist {
		qui insheet using "$cpsc/CPSC_Contract_Info_`i'_`m'.csv", clear comma

		qui gen partd = (offerspartd=="Yes")
		qui gen snp = (snpplan=="Yes")

		loc x contractid planid plantype parentorganization snp partd
		keep `x'
		order `x'
		gen month=`mo'
		compress
		tempfile a_`m'
		save `a_`m''
		loc mo=`mo'+1
	}
		
	use `a_01'	
	loc monthlist "02 03 04 05 06 07 08 09 10 11 12"
	foreach m of loc monthlist {
		append using `a_`m''
	}

	* replace SNP and partD and plan type info with modal observation
	foreach x in snp partd plantype {
		bysort contractid planid: egen `x'_mode=mode(`x'), maxmode
		replace `x'=`x'_mode
		drop `x'_mode
	}

	* replace parentcompany with last observation of year (in case acquired)
	sort contractid planid month
	bysort contractid planid: keep if _n==_N
	drop month
	gen int year=`i'
	
	merge 1:m contractid planid year using "$cpsc/plan_enrollment_`i'"
	keep if _merge==3
	drop _merge
	tempfile plan`i'
	compress
	save "$cpsc/contract_plan_`i'", replace
}

use "$cpsc/contract_plan_2012", clear
forvalues i=2013(1)2020 {
	append using "$cpsc/contract_plan_`i'"
}
compress

bysort contractid planid: egen fips_mode=mode(fips), maxmode
replace fips=fips_mode if fips==.
drop fips_mode

save "$data/contract_plan", replace
