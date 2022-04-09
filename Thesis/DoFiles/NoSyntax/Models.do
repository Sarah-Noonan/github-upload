**AH Analysis Sample and Models Do-File**
log using "/Users/Sarah/Documents/_NYU/Thesis/Rerun.log", append
cd "/Users/Sarah/Documents/_NYU/Thesis/Data/Master"

use "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/AHAnalysisSample.dta", clear

*Summary Statistics
outsum cesdscore1 cesdscore2 schoolstatus1 schoolstatus2 selfstatus1 selfstatus2 parenthighested1 parenthighested2 twobiorespar1 oneresbiopar1 bioblended1 twononbiorespar1 fam_other1 hispanic black asian natamer otherrace white multirace female male wave1grade if analysissample==1 using AHDescStats.txt, bracket title("Summary Statistics") ctitle ("Mean and [Standard Deviation]") replace


*Cross-sectional models - summary variables (FamType1 and ParentHighestEd Only)
reg cesdscore1 schoolstatus1 selfstatus1 parenthighested1 i.famtype1 b6.race wave1grade female if analysissample==1, robust
eststo crosssectionalw1


reg cesdscore2 schoolstatus2 selfstatus2 parenthighested2 i.famtype1 b6.race wave1grade female if analysissample==1, robust
eststo crosssectionalw2

estout crosssectionalw1 crosssectionalw2 using crosssectionalswide.txt, 

/*
Family:
Biological and stand in p<.01
Two resident non-biological p<.01
Other (no resident parent figures) p<.05

Race:
Hispanic p<.001
Black p<.001
Asian p<.001
Other p<.01

*/

*Save file before taking extract
save "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/AHAnalysisSample.dta", replace

*Keep variables to change to panel format
keep aid cesdscore1 cesdscore2 schoolstatus1 schoolstatus2 selfstatus1 selfstatus2 parenthighested1 parenthighested2 famtype1 momtype1 dadtype1 mothered1 mothered2 fathered1 fathered2 female race wave1grade analysissample

*Reshape to long format
reshape long cesdscore schoolstatus selfstatus parenthighested mothered fathered, i(aid race wave1grade female momtype1 dadtype1 famtype1 analysissample) j(wave)

*Save as separate file 
save "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/AHLongFileVariables.dta", replace

*Cross-sectional models: Rerun for each wave:
reg cesdscore schoolstatus selfstatus parenthighested i.famtype1 b6.race female wave1grade if analysissample==1 & wave==1, robust
*same results as in cross-sectional wide format - good.

reg cesdscore if wave=2, robust
*again same results: Good

*Repeat with objective SEP measures 

*Run fixed effects model(s)
encode aid, gen (aid1)
xtset aid1 wave
xtdescribe
xtsum

xtreg cesdscore parenthighested i.famtype1 female b6.race wave1grade if analysissample==1, fe

xtreg cesdscore schoolstatus selfstatus parenthighested i.famtype1 female b6.race wave1grade if analysissample==1, fe
*If doing fixed effects, need to include controls at all?

xtreg cesdscore schoolstatus selfstatus parenthighested i.famtype1 female b6.race wave1grade if analysissample==1, re
*Key explanatory variables all p<.001, with school status largest in magnitude
/*Covariates
p<.001
Single bioparent

p<.01

(Finish reporting covariates)

*Is egen mysample same as analysissample==1?

xtreg cesdscore if Mysample, fe

xtreg cesdscore schoolstatus parenthighested if Mysample, fe

*Hausman test

*Random effects reflecting unoberserved difference 

xtreg cesdscore SSS b2.parenthighested i.famtype1 female b6.race wave1grade, re
gen Mysample=e(sample)
xtreg cesdscore if Mysample, re

xtreg cesdscore SSS parenthighested if Mysample, re
 





/* cesdscore ObjSEP SSS b6.race female grade

*Set up and estout tables.*/
estout  using  , cells(b(star fmt(%9.2f)) se(fmt(%9.2f) par([ ]))) starlevels(* .05 ** .01 *** .001) stats(N) replace

*Save extract in panel format
save "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/AHLongFileVariables.dta", replace
