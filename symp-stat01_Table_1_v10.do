capture log close
cd "private-file-path"

// program: symp-stat01_Table1_v10.do
// task: data management - Generates Table 1 - baseline char of illnesses for paper & NERVTAG hotspot report
// project: Symtpom profiles (symp)
// author:  Ellen \ 15 jun 2021
// programme setup

version 16
clear all
set more off

// GENERATES TABLE 1 - BASELINE CHARACTERISTICS OF ILLNESSES BY DEMOGRAPHICS, TIME AND REGION - for paper & NERVTAG
//
// 	1. OPEN DATA
//
//	2. KEEP IF DAYOFILLNESS==1 
//
//	3. HIGHLIGHT DUPLICATE POSITIVE SWABS FOR TABLE NOTE 
//
//	4. FILE WRITE TABLE 1 - Symptom profile paper
//	
//	5. FILE WRITE TABLE 1 - NERVTAG
//
*creates the following file to copy and paste into excel for formatting
*symp-stat01_v10_Table_1.txt



*1) OPEN DATA
use "${DATA_derived}\symp-data04_v6.dta", clear



*2) KEEP IF DAYOFILLNESS==1 
keep if dayofillness==1



*3) HIGHLIGHT DUPLICATE POSITIVE SWABS FOR TABLE NOTE 

tab n_pos if n_pos!=. & n_pos!=1
local my_dropped_multipositives=r(N)



*4) FILE WRITE TABLE 1 

tempname myhandle
file open `myhandle' using "${RESULTS}\symp-stat01_Table1_v10.txt", write replace


*-------TITLE-----------
file write `myhandle' "Table 1. Characteristics of illnesses by demographics, VOC hotspots and swab outcome" _n(3)


*-------HEADERS-----------
file write `myhandle' _tab(2) "All illnesses" _tab(2) "Swabbed illnesses" _tab "Swab+ illnesses" _n

file write `myhandle' _tab(2) "N" _tab "% of all illnesses (column %)" _tab "N" _tab "N" _tab "% of swabbed illnesses (row %)" _n


*-------OVERALL-----------
file write `myhandle' _tab "Overall" _tab

desc illnessid
return list
local my_N_illnesses=r(N)

tab swaboutcome if (n_pos==. | n_pos==1)
return list
local my_denom=r(N) /*swabbing denominator*/

tab swaboutcome if swaboutcome==1 &  n_pos==1
return list
local my_pos=r(N) /*number PCR+ */

file write `myhandle'  (`my_N_illnesses') _tab (`my_N_illnesses'/`my_N_illnesses') _tab (`my_denom') _tab (`my_pos') _tab (`my_pos'/`my_denom') _n


*-----CALCULATING MISSING FOR FOOTNOTE-------------
foreach i in age2 sex_bin region month_cat nVar {
	tab `i'
	return list
	local mytotal_`i'=r(N)
	tab `i', mis
	return list
	local mymissing_`i'=r(N)
	local mymissing_`i'=(`mymissing_`i''-`mytotal_`i'')
}

foreach i in age2 sex_bin region month_cat nVar {
	display `mymissing_`i''
	}

	
*-----BY Strain Type hotspot --------------------------- 
file write `myhandle' _tab "By Strain Hotspot*" _n 

foreach i in 0 1 2 {
	local mynVar_`i'name: label (nVar) `i'
	tab nVar
	local my_illness_denom=r(N)
	tab nVar if nVar==`i' 
	local my_illnesses_`i'=r(N) /*N illnesses in strata*/
	tab swaboutcome if nVar==`i' & (n_pos==. | n_pos==1)
	local my_denom_`i'=r(N) /*swabbing denominator*/
	tab swaboutcome if swaboutcome==1 & nVar==`i' &  n_pos==1
	local my_pos_`i'=r(N) /*number PCR+ */
	
	file write `myhandle' _tab "`mynVar_`i'name'" _tab (`my_illnesses_`i'') _tab (`my_illnesses_`i''/`my_illness_denom') _tab (`my_denom_`i'') _tab (`my_pos_`i'') _tab (`my_pos_`i''/`my_denom_`i'') _n
	}
	
	
*-----BY AGE GROUP ---------------------------
file write `myhandle' _tab "By Age Group**" _n 

foreach i in 1 2 3 4 5  {
	local myage_`i'name: label (age2) `i'
	tab age2
	local my_illness_denom=r(N)
	tab age2 if age2==`i' 
	local my_illnesses_`i'=r(N) /*N illnesses in strata*/
	tab swaboutcome if age2==`i' & (n_pos==. | n_pos==1)
	local my_denom_`i'=r(N) /*swabbing denominator*/
	tab swaboutcome if swaboutcome==1 & age2==`i' &  n_pos==1
	local my_pos_`i'=r(N) /*number PCR+ */
	
	file write `myhandle' _tab "`myage_`i'name'" _tab (`my_illnesses_`i'') _tab (`my_illnesses_`i''/`my_illness_denom') _tab (`my_denom_`i'') _tab (`my_pos_`i'') _tab (`my_pos_`i''/`my_denom_`i'') _n
	}

	
*-----BY SEX_BIN ---------------------------
file write `myhandle' _tab "By Sex***" _n 

foreach i in 1 2 {
	local mysex_`i'name: label (sex_bin) `i'
	tab sex_bin
	local my_illness_denom=r(N)
	tab sex_bin if sex_bin==`i' 
	local my_illnesses_`i'=r(N) /*N illnesses in strata*/
	tab swaboutcome if sex_bin==`i'  & (n_pos==. | n_pos==1)
	local my_denom_`i'=r(N) /*swabbing denominator*/
	tab swaboutcome if swaboutcome==1 & sex_bin==`i' &  n_pos==1
	local my_pos_`i'=r(N) /*number PCR+ */
	
	file write `myhandle' _tab "`mysex_`i'name'" _tab (`my_illnesses_`i'') _tab (`my_illnesses_`i''/`my_illness_denom') _tab (`my_denom_`i'') _tab (`my_pos_`i'') _tab (`my_pos_`i''/`my_denom_`i'') _n
	}

	
*-----BY REGION ---------------------------
file write `myhandle' _tab "By Region****" _n 

foreach i in 1 2 3 4 5 8 9 10 11 12 {
	local myreg_`i'name: label (region) `i'
	tab region
	local my_illness_denom=r(N)
	tab region if region==`i' 
	local my_illnesses_`i'=r(N) /*N illnesses in strata*/
	tab swaboutcome if region==`i'  & (n_pos==. | n_pos==1)
	local my_denom_`i'=r(N) /*swabbing denominator*/
	tab swaboutcome if swaboutcome==1 & region==`i' &  n_pos==1
	local my_pos_`i'=r(N) /*number PCR+ */
	
	file write `myhandle' _tab "`myreg_`i'name'" _tab (`my_illnesses_`i'') _tab (`my_illnesses_`i''/`my_illness_denom') _tab (`my_denom_`i'') _tab (`my_pos_`i'') _tab (`my_pos_`i''/`my_denom_`i'') _n
	}	
	
	
*-----BY Month ---------------------------
file write `myhandle' _tab "By Month*****" _n 

forvalues i=8/21 {
	local mymonth_`i'name: label (month_cat) `i'
	tab month_cat
	local my_illness_denom=r(N)
	tab month_cat if month_cat==`i' 
	local my_illnesses_`i'=r(N) /*N illnesses in strata*/
	tab swaboutcome if month_cat==`i'  & (n_pos==. | n_pos==1)
	local my_denom_`i'=r(N) /*swabbing denominator*/
	tab swaboutcome if swaboutcome==1 & month_cat==`i' &  n_pos==1
	local my_pos_`i'=r(N) /*number PCR+ */
	
	file write `myhandle' _tab "`mymonth_`i'name'" _tab (`my_illnesses_`i'') _tab (`my_illnesses_`i''/`my_illness_denom') _tab (`my_denom_`i'') _tab (`my_pos_`i'') _tab (`my_pos_`i''/`my_denom_`i'') _n
	}		
	
	
	
foreach i in age2 sex_bin region month_cat {
	display `mymissing_`i''
	}

*================== TABLE FOOTNOTES ===============

file write `myhandle' _tab "*    Strain hotspot not classifiable or between classifiations for `mymissing_nVar' illnesses" _n	
file write `myhandle' _tab "**    Age missing for `mymissing_age2' illnesses" _n	
file write `myhandle' _tab "***   Sex missing for `mymissing_sex_bin' illnesses"  _n		
file write `myhandle' _tab "****  Region missing for `mymissing_region' illnesses" _n	
file write `myhandle' _tab "***** Month missing for `mymissing_month_cat' illnesses"  _n(2)			
file write `myhandle' _tab "Note 1: The last 3 columns are currently limited to the first swab positive illness if a person has multiple illnesses that merged with a positive swab.  We are currently dropping `my_dropped_multipositives' illnesses that were 2nd, 3rd of 4th swab+ illnesses for a person from these coloumns.  These `my_dropped_multipositives' illnesses are still included in the other coloumns though.  Although we could investigate this - we don't currently know if these were different swabs testing positive or the same positive swab merging with two illnesses close in time."  _n		
file write `myhandle' _tab "Note 2:  The swabbed illnesses column is really just swabbed illnesses which we have a result for.  We know of some illnesses which were swabbed which we never got a result for and those are not included in this coloumn." _n


