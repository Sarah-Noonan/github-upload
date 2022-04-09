*Starting with Wave 1
use "/Users/Sarah/Documents/_NYU/Thesis/Data/WaveI/21600-0001-Data.dta", clear 

*Adding Waves
*2
merge 1:1 AID using "/Users/Sarah/Documents/_NYU/Thesis/Data/WaveII/21600-0003-Data.dta"
rename _merge _mergeWII

**
*3
merge 1:1 AID using "/Users/Sarah/Documents/_NYU/Thesis/Data/WaveIII/21600-0012-Data.dta"
rename _merge _mergeWIII

*4
merge 1:1 AID using "/Users/Sarah/Documents/_NYU/Thesis/Data/WaveIV/21600-0023-Data.dta"
rename _merge _mergeWIV


/*Applying Sampling Weights
merge 1:1 aid using

rename _merge _mergeweights

*/
//save
save "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/AH_NoSyntaxMerged.dta", replace
