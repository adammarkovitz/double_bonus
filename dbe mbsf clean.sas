**********************************************************************;
* Code to clean MBSF files, 2008-2018;

* Yotta Z drive;
libname conf "Z:\stars\orig\Confinement" access=readonly;
libname diag "Z:\stars\orig\Diagnosis" access=readonly;
libname med "Z:\stars\orig\Medical" access=readonly;
libname member "Z:\stars\orig\Member" access=readonly;
libname proc "Z:\stars\orig\Procedure" access=readonly;
libname lab "Z:\stars\orig\Laboratory" access=readonly;
libname pharm "Z:\stars\orig\Pharmacy" access=readonly;
libname data "Z:\stars\data";
libname ndc "Z:\stars\ndc";
libname hrr "Z:\stars\data\HRR";
libname hedis "Z:\stars\data\hedis";
libname acs "Z:\stars\data\acs";

* CHOP;
libname denom "X:\Denom_MBSF" access=readonly;


* MBSF;
*rti_race_cd;
%macro denom18(yr);
data denom_20&yr.(keep=year bene_id age race female buyin hmo_mo female zip ssa ssa_str orig hmo_mo hmo1 hmo12);
set denom.denom&yr.
(keep=bene_id bene_birth_dt bene_race_cd zip_cd sex_ident_cd entlmt_rsn_orig bene_hmo_cvrage_tot_mons hmo_ind_01 hmo_ind_12 bene_state_buyin_tot_mons state_code county_cd);
* race;
if bene_race_cd in ("1") then race = 0;
if bene_race_cd in ("2") then race = 1;
if bene_race_cd in ("5") then race = 2;
if bene_race_cd in ("4") then race = 3;
if race = . then race = 4;
* SSA;
if 0 < input(cats(state_code), 2.0) <= 53;
ssa_str=cats(state_code, county_cd);
ssa=input(cats(state_code, county_cd),5.0);
if ssa ne 0 and ssa ne 999;
* Zip;
zip=input(substr(zip_cd, 1, 5), 5.0);
* age;
age = 20&yr.-year(bene_birth_dt);
* female;
if sex_ident_cd = "2" then female = 1; 
if sex_ident_cd = "1" then female = 0;
* orig;
if entlmt_rsn_orig in ("1" "2" "3") then orig=1; else orig=0;
* HMO coverage;
rename bene_hmo_cvrage_tot_mons = hmo_mo;
%do i=1 %to 1;
    if hmo_ind_0&i. in ("1" "C")then hmo&i. = 1; else hmo&i. = 0;
%end;
%do i=12 %to 12;
    if hmo_ind_&i. in ("1" "C") then hmo&i. = 1; else hmo&i. = 0;
%end;
* State Buy In;
rename bene_state_buyin_tot_mons = buyin;
* Year;
year=20&yr.;
run;
%mend denom18;

%denom18(18);
%denom18(17);
%denom18(16);
%denom18(15);

%macro denom14(yr);
data denom_20&yr.(keep=year bene_id age race female buyin hmo_mo female zip ssa ssa_str orig hmo_mo hmo1 hmo12);
set denom.denom&yr.
(keep=bene_id bene_birth_dt bene_race_cd bene_zip_cd bene_sex_ident_cd bene_entlmt_rsn_orig bene_hmo_cvrage_tot_mons bene_hmo_ind_01 bene_hmo_ind_12 bene_state_buyin_tot_mons state_code bene_county_cd);
* race;
if bene_race_cd in ("1") then race = 0;
if bene_race_cd in ("2") then race = 1;
if bene_race_cd in ("5") then race = 2;
if bene_race_cd in ("4") then race = 3;
if race = . then race = 4;
* SSA code;
if 0 < input(cats(state_code), 2.0) <= 53;
ssa_str=cats(state_code, bene_county_cd);
ssa=input(cats(state_code, bene_county_cd),5.0);
if ssa ne 0 and ssa ne 999;
* Zip;
zip=input(substr(bene_zip_cd, 1, 5), 5.0);
* age;
age = 20&yr.-year(bene_birth_dt);
* female;
if bene_sex_ident_cd = "2" then female = 1; 
if bene_sex_ident_cd = "1" then female = 0;
* orig;
if bene_entlmt_rsn_orig in ("1" "2" "3") then orig=1; else orig=0;
* HMO coverage;
 rename bene_hmo_cvrage_tot_mons = hmo_mo;
%do i=1 %to 1;
    if bene_hmo_ind_0&i. in ("1" "C")then hmo&i. = 1; else hmo&i. = 0;
%end;
%do i=12 %to 12;
    if bene_hmo_ind_&i. in ("1" "C") then hmo&i. = 1; else hmo&i. = 0;
%end;
* State Buy In;
rename bene_state_buyin_tot_mons = buyin;
* Year;
year=20&yr.;
run;
%mend denom14;

%denom14(14);
%denom14(13);

%macro denom12(yr);
data denom_20&yr.(keep=year bene_id age race female buyin hmo_mo female zip ssa ssa_str orig hmo_mo hmo1 hmo12);
set denom.denom&yr.
(keep=bene_id birth_dt race_cd zip_cd sex_ident_cd entlmt_rsn_orig hmo_cvrage_tot_mons hmo_ind_01 hmo_ind_12 state_buyin_tot_mons state_code county_cd);
* race;
if race_cd in ("1") then race = 0;
if race_cd in ("2") then race = 1;
if race_cd in ("5") then race = 2;
if race_cd in ("4") then race = 3;
if race = . then race = 4;
* SSA code;
if 0 < input(cats(state_code), 2.0) <= 53;
ssa_str=cats(state_code, county_cd);
ssa=input(cats(state_code, county_cd),5.0);
if ssa ne 0 and ssa ne 999;
* Zip;
zip=input(substr(zip_cd, 1, 5), 5.0);
* age;
age = 20&yr.-year(birth_dt);
* female;
if sex_ident_cd = "2" then female = 1; 
if sex_ident_cd = "1" then female = 0;
* orig;
if entlmt_rsn_orig in ("1" "2" "3") then orig=1; else orig=0;
* HMO coverage;
 rename hmo_cvrage_tot_mons = hmo_mo;
%do i=1 %to 1;
    if hmo_ind_0&i. in ("1" "C")then hmo&i. = 1; else hmo&i. = 0;
%end;
%do i=12 %to 12;
    if hmo_ind_&i. in ("1" "C") then hmo&i. = 1; else hmo&i. = 0;
%end;
* State Buy In;
rename state_buyin_tot_mons = buyin;
* Year;
year=20&yr.;
run;
%mend denom12;

%denom12(12);
%denom12(11);

%macro denom10(yr);
data denom_20&yr.(keep=year bene_id age race female buyin hmo_mo female zip ssa ssa_str orig hmo_mo hmo1 hmo12);
set denom.denom&yr.
(keep=bene_id bene_birth_dt bene_race_cd bene_zip_cd bene_sex_ident_cd bene_entlmt_rsn_orig bene_hmo_cvrage_tot_mons bene_hmo_ind_01 bene_hmo_ind_12 bene_state_buyin_tot_mons state_code bene_county_cd);
* race;
if bene_race_cd in ("1") then race = 0;
if bene_race_cd in ("2") then race = 1;
if bene_race_cd in ("5") then race = 2;
if bene_race_cd in ("4") then race = 3;
if race = . then race = 4;
* SSA code;
if 0 < input(cats(state_code), 2.0) <= 53;
ssa_str=cats(state_code, bene_county_cd);
ssa=input(cats(state_code, bene_county_cd),5.0);
if ssa ne 0 and ssa ne 999;
* Zip;
zip=input(substr(bene_zip_cd, 1, 5), 5.0);
* age;
age = 20&yr.-year(bene_birth_dt);
* female;
if bene_sex_ident_cd = "2" then female = 1; 
if bene_sex_ident_cd = "1" then female = 0;
* orig;
if bene_entlmt_rsn_orig in ("1" "2" "3") then orig=1; else orig=0;
* HMO coverage;
 rename bene_hmo_cvrage_tot_mons = hmo_mo;
%do i=1 %to 1;
    if bene_hmo_ind_0&i. in ("1" "C")then hmo&i. = 1; else hmo&i. = 0;
%end;
%do i=12 %to 12;
    if bene_hmo_ind_&i. in ("1" "C") then hmo&i. = 1; else hmo&i. = 0;
%end;
* State Buy In;
rename bene_state_buyin_tot_mons = buyin;
* Year;
year=20&yr.;
run;

%mend denom10;
%denom10(10);
%denom10(09);
%denom10(08);

* append + save;
data scratch.mbsf1;
set denom_20:;
run;

* delete individual years;
proc datasets nolist; delete denom_20:; quit;

* Dounble bonus file;
proc import out=db_ssa datafile = "Y:\stars\data\fips\dbe_db_ssa_fips.dta" replace; 
run;

data db_ssa;
set db_ssa(drop=ssa state ssa_name);
run;

* merge;
proc sql; create table scratch.mbsf2_test as select 
a.bene_id, a.hmo_mo, a.buyin, a.race, 
a.age, a.female, a.orig, a.hmo1, a.hmo12, a.year, a.ssa,
b.tr, b.db, b.itt, b.db_year, b.exit_year, b.mapen, b.urban_floor, 
b.ffs_lower, b.time_count, b.exp, b.fips,
rand("Uniform") as r
from scratch.mbsf1 (drop=fips) as a
left join db_ssa as b on a.ssa_str=b.ssa_str and a.year=b.year;
quit;
