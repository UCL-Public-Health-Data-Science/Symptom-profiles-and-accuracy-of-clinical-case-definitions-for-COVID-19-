capture log close
//cd "private-file-path"

// program: symp-stat02_v5_Figure_1.do
// task: data management - Generates Figures 1a-b.  Symptoms by swab outcome & Symptom timing in COVID+ cases
// project: Symtpom profiles (symp)
// author:  Ellen \ 03 Mar 2021
// programme setup

version 16
clear all
set more off

// Generates Figures 1a-c.  Symptoms by swab outcome & Symptom timing in COVID+ and COVID- illnesses & equivalent among COVID+ by VOC hotspot
//
// 	1. OPEN DATA & CUT SOME VAR NAMES DOWN OUT OF NECESSITY
//
//	2. DROP ILLNESSES THAT ARE SUBSEQUENT REPEAT COVID+ ILLNESSES IN THE SAME PERSON 
//
//	3. Generates CSV for Figure 1a.  Symptoms by swab outcome  (for PAPER) 
//
//	4. CREATE FILEWRITE Figure 1b&c- Symptom by day heatmaps for COVID+ and COVID- illnesses (for PAPER) 
//
//	5. CREATE FILEWRITE Figure 1a- Symptom presence by VOC hotspot among COVID+ (for NERVTAG)
//
//	6. CREATE FILEWRITE Figure 1b&c- Symptom by day heatmaps for COVID+ illnesses by VOC hotspot (for NERVTAG)

//	
*creates the following file to copy and paste into excel for formatting
*symp-stat02_Figure_1a.txt
*symp-stat02_Figure_1b.txt
*symp-stat02_Figure_1c.txt



*1) OPEN DATA & CUT SOME VAR NAMES DOWN OUT OF NECESSITY
use "${DATA_derived}\symp-data04_v6.dta", clear
	
	
*2) DROP ILLNESSES THAT ARE SUBSEQUENT REPEAT COVID+ ILLNESSES IN THE SAME PERSON
codebook individual_id if (n_pos!=. & n_pos!=1)
tab n_pos if dayofillness==1
drop if (n_pos!=. & n_pos!=1)


*================================
* PAPER
*================================

*3) CREATE FILEWRITE Figure 1a - Symptom presence by swab outcome
tempname myhandle
file open `myhandle' using "${RESULTS}\symp-stat02_v5_Figure_1a.txt", write replace

*TABLE TITLE 
*file write `myhandle' "Table 1. Symptoms by swab outcome" _n(2)

file write `myhandle' "symptom" _tab "swab_outcome" _tab "prop_with_symptom" _n

tab swaboutcome if dayofillness==1 & swaboutcome==1
local mydenom_1=r(N)

tab swaboutcome if dayofillness==1 & swaboutcome==0
local mydenom_0=r(N)
	
foreach s in fever_bin cough_bin smell_taste_bin fevercat_bin feeling_feverish_bin chills_bin night_sweats_bin muscle_ache_bin bone_ache_bin loss_of_appetite_bin headache_bin concentration_bin dizzy_bin not_sleeping_bin fatigue_bin daily_activities_bin extra_bed_bin out_of_bed_bin confusion_bin runny_nose_bin blocked_nose_bin sinus_pain_bin loss_of_smell_bin loss_of_taste_bin /* dry_cough_bin white_phlegm_bin green_phlegm_bin */ sneezing_bin sore_throat_bin swollen_tonsils_bin swollen_glands_bin ear_pain_bin ear_fluid_bin sob_bin wheezing_bin chest_pain_nc_bin chest_pain_br_bin diarrhoea_bin vomiting_bin nausea_bin abdo_pain_bin redeye_bin sticky_eye_bin eye_pain_bin eye_deter_bin rash_allover_bin rash_local_bin { 

foreach i in 0 1 {
	tab `s'_illmax if swaboutcome==`i' & dayofillness==1
	local my`s'`i'=r(N)
	file write `myhandle'  ("`s'") _tab (`i') _tab ((`my`s'`i'')/(`mydenom_`i''))  _n
	}
}


*================================
* paper
*================================

*4) CREATE FILEWRITE Figure 1b&c- Symptom heatmap by day graphs

*Figure 1b (COVID+ illnesses) 
preserve 
	keep if swaboutcome==1	

	tempname myhandle
	file open `myhandle' using "${RESULTS}\symp-stat02_v5_Figure_1b.txt", write replace

	*TABLE TITLE 
	*file write `myhandle' "Data for Figure 1b. Timing of symptom onset among COVID+ illnesses" _n(2)

	file write `myhandle' "day" _tab "symptom" _tab "proprtion_on_that_day" _n
	
	tab swaboutcome if dayofillness==1
	local mydenom=r(N)
	
foreach s in fevercat_bin wheezing_bin vomiting_bin swollen_tonsils_bin swollen_glands_bin sticky_eye_bin sore_throat_bin sneezing_bin sinus_pain_bin sob_bin runny_nose_bin redeye_bin rash_local_bin rash_allover_bin out_of_bed_bin not_sleeping_bin night_sweats_bin nausea_bin muscle_ache_bin loss_of_taste_bin loss_of_smell_bin loss_of_appetite_bin concentration_bin headache_bin feeling_feverish_bin fatigue_bin eye_pain_bin extra_bed_bin ear_pain_bin ear_fluid_bin dizzy_bin diarrhoea_bin daily_activities_bin confusion_bin chills_bin chest_pain_nc_bin chest_pain_br_bin bone_ache_bin blocked_nose_bin abdo_pain_bin cough_bin smell_taste_bin eye_deter_bin    { 	
	
	foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 {
		tab swaboutcome if dayofillness==`i' & `s'==1
		local myd`i'`s'=r(N)
		file write `myhandle'  (`i') _tab ("`s'") _tab ((`myd`i'`s'')/(`mydenom'))  _n
		}
	}
restore


*Figure 1c (COVID- illnesses) 
preserve 
	keep if swaboutcome==0	

	tempname myhandle
	file open `myhandle' using "${RESULTS}\symp-stat02_v5_Figure_1c.txt", write replace

	*TABLE TITLE 
	*file write `myhandle' "Data for Figure 1c. Timing of symptom onset among COVID- illnesses" _n(2)

	file write `myhandle' "day" _tab "symptom" _tab "proprtion_on_that_day" _n
	
	tab swaboutcome if dayofillness==1
	local mydenom=r(N)
	
foreach s in fevercat_bin wheezing_bin vomiting_bin swollen_tonsils_bin swollen_glands_bin sticky_eye_bin sore_throat_bin sneezing_bin sinus_pain_bin sob_bin runny_nose_bin redeye_bin rash_local_bin rash_allover_bin out_of_bed_bin not_sleeping_bin night_sweats_bin nausea_bin muscle_ache_bin loss_of_taste_bin loss_of_smell_bin loss_of_appetite_bin concentration_bin headache_bin feeling_feverish_bin fatigue_bin eye_pain_bin extra_bed_bin ear_pain_bin ear_fluid_bin dizzy_bin diarrhoea_bin daily_activities_bin confusion_bin chills_bin chest_pain_nc_bin chest_pain_br_bin bone_ache_bin blocked_nose_bin abdo_pain_bin cough_bin smell_taste_bin eye_deter_bin     { 	
	
	foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 {
		tab swaboutcome if dayofillness==`i' & `s'==1
		local myd`i'`s'=r(N)
		file write `myhandle'  (`i') _tab ("`s'") _tab ((`myd`i'`s'')/(`mydenom'))  _n
		}
	}
restore




*================================
* NERVTAG - Strain-specific
*================================

*5) CREATE FILEWRITE Figure 1A NERVTAG- Symptom presence by strain hotspot among COVID+ illnesses (NERVTAG).  This version of graphic will have three paired columns - one for each strain hotspot.

preserve 
	keep if swaboutcome==1 & nVar!=. 

	tempname myhandle
	file open `myhandle' using "${RESULTS}\symp-stat02_v5_Figure_1a_All_Strains_Hotspot.txt", write replace

	*TABLE TITLE 
	file write `myhandle' "Table 1. Symptoms among COVID+ illnesses by Hotspot status" _n(2)

	file write `myhandle' "symptom" _tab "Strain" _tab "prop_with_symptom" _n
	
	tab swaboutcome if dayofillness==1 & nVar==0
	local mydenom_0=r(N)
	
	tab swaboutcome if dayofillness==1 & nVar==1
	local mydenom_1=r(N)

	tab swaboutcome if dayofillness==1  & nVar==2
	local mydenom_2=r(N)
		
foreach s in fever_bin cough_bin smell_taste_bin fevercat_bin feeling_feverish_bin chills_bin night_sweats_bin muscle_ache_bin bone_ache_bin loss_of_appetite_bin headache_bin concentration_bin dizzy_bin not_sleeping_bin fatigue_bin daily_activities_bin extra_bed_bin out_of_bed_bin confusion_bin runny_nose_bin blocked_nose_bin sinus_pain_bin dry_cough_bin white_phlegm_bin green_phlegm_bin loss_of_smell_bin loss_of_taste_bin sneezing_bin sore_throat_bin swollen_tonsils_bin swollen_glands_bin ear_pain_bin ear_fluid_bin sob_bin wheezing_bin  chest_pain_nc_bin chest_pain_br_bin diarrhoea_bin vomiting_bin nausea_bin abdo_pain_bin redeye_bin sticky_eye_bin eye_pain_bin eye_deter_bin rash_allover_bin rash_local_bin { 

	foreach i in 0 1 2 {
		capture egen `s'_illmax =max(`s'), by(illnessid)
		order `s'_illmax, after(`s')
		capture tab `s'_illmax if nVar==`i' & dayofillness==1
		local my`s'`i'=r(N)
		file write `myhandle'  ("`s'") _tab (`i') _tab ((`my`s'`i'')/(`mydenom_`i''))  _n
		}
	}

restore


*================================
*6)  CREATE FILEWRITE Figures 1b&c- Symptom by day heatmaps for COVID+ and COVID- illnesses by STRAIN HOTSPOT -  NERVTAG

*Figure 1b (COVID+ve illnesses IN STRAIN X HOTSPOTS) 

foreach strain in 0 1 2 {
	preserve 
		keep if swaboutcome==1 & nVar==`strain'	

		tempname myhandle
		file open `myhandle' using "${RESULTS}\symp-stat02_v5_Figure_1b_COVID+ve_STRAIN_`strain'_HOTSPOT.txt", write replace

		*TABLE TITLE 
		*file write `myhandle' "Data for Figure 1b. Timing of symptom onset among COVID+ illnesses in Strain `strain' hotpsots" _n(2)

		file write `myhandle' "day" _tab "symptom" _tab "proprtion_on_that_day" _n
		
		tab swaboutcome if dayofillness==1
		local mydenom=r(N)
		
	foreach s in fevercat_bin wheezing_bin vomiting_bin swollen_tonsils_bin swollen_glands_bin sticky_eye_bin sore_throat_bin sneezing_bin sinus_pain_bin sob_bin runny_nose_bin redeye_bin rash_local_bin rash_allover_bin out_of_bed_bin not_sleeping_bin night_sweats_bin nausea_bin muscle_ache_bin loss_of_taste_bin loss_of_smell_bin loss_of_appetite_bin concentration_bin headache_bin feeling_feverish_bin fatigue_bin eye_pain_bin extra_bed_bin ear_pain_bin ear_fluid_bin dizzy_bin diarrhoea_bin daily_activities_bin confusion_bin chills_bin chest_pain_nc_bin chest_pain_br_bin bone_ache_bin blocked_nose_bin abdo_pain_bin cough_bin smell_taste_bin eye_deter_bin    { 	
		
		foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 {
			tab swaboutcome if dayofillness==`i' & `s'==1
			local myd`i'`s'=r(N)
			file write `myhandle'  (`i') _tab ("`s'") _tab ((`myd`i'`s'')/(`mydenom'))  _n
			}
		}
	restore
}



*Figure 1c (COVID-ve illnesses IN STRAIN X HOTSPOTS) 

foreach strain in 0 1 2 {
	preserve 
		keep if swaboutcome==0 & nVar==`strain'	

		tempname myhandle
		file open `myhandle' using "${RESULTS}\symp-stat02_v5_Figure_1c_COVID-ve_STRAIN_`strain'_HOTSPOT.txt", write replace

		*TABLE TITLE 
		*file write `myhandle' "Data for Figure 1b. Timing of symptom onset among COVID-ve illnesses in Strain `strain' hotpsots" _n(2)

		file write `myhandle' "day" _tab "symptom" _tab "proprtion_on_that_day" _n
		
		tab swaboutcome if dayofillness==1
		local mydenom=r(N)
		
	foreach s in fevercat_bin wheezing_bin vomiting_bin swollen_tonsils_bin swollen_glands_bin sticky_eye_bin sore_throat_bin sneezing_bin sinus_pain_bin sob_bin runny_nose_bin redeye_bin rash_local_bin rash_allover_bin out_of_bed_bin not_sleeping_bin night_sweats_bin nausea_bin muscle_ache_bin loss_of_taste_bin loss_of_smell_bin loss_of_appetite_bin concentration_bin headache_bin feeling_feverish_bin fatigue_bin eye_pain_bin extra_bed_bin ear_pain_bin ear_fluid_bin dizzy_bin diarrhoea_bin daily_activities_bin confusion_bin chills_bin chest_pain_nc_bin chest_pain_br_bin bone_ache_bin blocked_nose_bin abdo_pain_bin cough_bin smell_taste_bin eye_deter_bin    { 	
		
		foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 {
			tab swaboutcome if dayofillness==`i' & `s'==1
			local myd`i'`s'=r(N)
			file write `myhandle'  (`i') _tab ("`s'") _tab ((`myd`i'`s'')/(`mydenom'))  _n
			}
		}
	restore
}
