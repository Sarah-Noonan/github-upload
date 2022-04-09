**SSS and Depression and Analysis Sample Variables Coding, Available Case Analysis and Descriptive Statistics

/*Before FamilyCodingNS.do finished:
use  "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/AHDemoCoded.dta", clear
*/
*After applying family do-file code
cd "/Users/Sarah/Documents/_NYU/Thesis/Data/Master"
use "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/AHFamilyEdCoded.dta", clear

*Subjective Social Status based on MacArthur Scale in Wave 1: 
*Education section - School Connectedness (Resnick 1997)
/*h1ed19 "You felt close to people at your school" - more agreement - lower score
h1ed20 same pattern "Felt like a part of your school
h1ed23 teachers treat students fairly
(so reverse code)*/

foreach x in 19 20 23{
gen revc_h1ed`x'=5-h1ed`x' if h1ed`x'<=5
tab revc_h1ed`x' h1ed`x', m
}

corr revc_h1ed19 revc_h1ed20 revc_h1ed23

pwcorr revc_h1ed19 revc_h1ed20 revc_h1ed23

alpha revc_h1ed19 revc_h1ed20 revc_h1ed23
*Almost 7 and used in Resnick

factor revc_h1ed19 revc_h1ed20 revc_h1ed23
factor revc_h1ed19 revc_h1ed20 revc_h1ed23, pcf

*Same results if standardize items?

gen schoolstatus1 = revc_h1ed19 + revc_h1ed20 + revc_h1ed23
label var schoolstatus1 "Subjective School Status at Wave I"
sum schoolstatus1 
*0-12 point scale, mean=8.04

*Wave II
foreach x in 15 16 19{
gen revc_h2ed`x' =5 - h2ed`x' if h2ed`x'<=5
tab revc_h2ed`x' h2ed`x', m
}

alpha revc_h2ed15 revc_h2ed16 revc_h2ed19

gen schoolstatus2=revc_h2ed15 + revc_h2ed16 + revc_h2ed19
label var schoolstatus2 "Subjective School Status at Wave II"
sum schoolstatus2
/*Almost 7 and used in Resnick paper*/

/* Personality - King (2010) - measure self-esteem
h1pf30 - lot of good qualities - reverse code
h1pf32 - lot to be proud of
h1pf33 - like self as is
*/

foreach i in 0 2 3 4 5 6 {
gen revc_h1pf3`i' = 5-h1pf3`x' if h1pf3`x'<=5
tab revc_h1pf3`i' h1pf3`i', m
}
alpha revc_h1pf30 revc_h1pf32 revc_h1pf33 revc_h1pf34 revc_h1pf35 revc_h1pf36 
*alpha=1

*principal factors
factor revc_h1pf30 revc_h1pf32 revc_h1pf33 revc_h1pf34 revc_h1pf35 revc_h1pf36 

*pcf
factor revc_h1pf30 revc_h1pf32 revc_h1pf33 revc_h1pf34 revc_h1pf35 revc_h1pf36 , pcf

gen selfstatus1= revc_h1pf30 + revc_h1pf32 + revc_h1pf33 + revc_h1pf34 + revc_h1pf35 +revc_h1pf36
label var selfstatus1 "Subjective Self Status at Wave I"
sum selfstatus1
*Mean=18 (out of 24)

*Wave II
foreach x in 1 3 4 5 6 7{
gen revc_h2pf2`x'=5-h2pf2`x' if h2pf2`x'<=5
tab revc_h2pf2`x' h2pf2`x', m
}

alpha revc_h2pf21 revc_h2pf23 revc_h2pf24 revc_h2pf25 revc_h2pf26 revc_h2pf27
*Alpha=.85

gen selfstatus2=revc_h2pf21 + revc_h2pf23 + revc_h2pf24 + revc_h2pf25 + revc_h2pf26 + revc_h2pf27
label var selfstatus2 "Subjective Self Status at Wave II"
sum selfstatus2
*Mean=19.19

*factor, pcf, icf, maximum loading, rotate

*Depression in Waves I and II based on CES-D
*reverse code: 8, 11 15

foreach x in 4 8 11 15{
gen revc_h1fs`x'=.
replace revc_h1fs`x'=3-h1fs`x' if h1fs`x'<=3 
gen revc_h2fs`x'=.
replace revc_h2fs`x'=3-h2fs`x' if h2fs`x'<=3 
}

foreach x in 1 2 3 5 6 7 9 10 12 13 14 16 17 18 {
gen rc_h1fs`x' = .
replace rc_h1fs`x'=h1fs`x' if h1fs`x'<=3
gen rc_h2fs`x'=.
replace rc_h2fs`x'=h2fs`x' if h2fs`x'<=3
}

foreach x in 1 2 {
alpha rc_h`x'fs1 rc_h`x'fs2 rc_h`x'fs3 revc_h`x'fs4 rc_h`x'fs5 rc_h`x'fs5 rc_h`x'fs6 rc_h`x'fs7 revc_h`x'fs8 rc_h`x'fs9 revc_h`x'fs11 rc_h`x'fs13 rc_h`x'fs14 revc_h`x'fs15 rc_h`x'fs16 rc_h`x'fs17 rc_h`x'fs18 
gen cesdscore`x' = rc_h`x'fs1 + rc_h`x'fs2 + rc_h`x'fs3 + revc_h`x'fs4 + rc_h`x'fs5 + rc_h`x'fs5 + rc_h`x'fs6 + rc_h`x'fs7 + revc_h`x'fs8 + rc_h`x'fs9 + revc_h`x'fs11 + rc_h`x'fs13 + rc_h`x'fs14 + revc_h`x'fs15 + rc_h`x'fs16 + rc_h`x'fs17 + rc_h`x'fs18 
sum cesdscore`x'
}

label var cesdscore1 "CES-D Score at Wave I"
label var cesdscore2 "CES-D Score at Wave II"

*Alpha Wave 1=.85
*Alpha Wave 2=.86

*sum Wave 1=10.7
*sum Wave 2=10.6
 
*18 items-> 54 points

*Examine relationships between variables
/*Objective v. Subjective Status
corr parenthighested1 schoolstatus1 selfstatus1
corr parenthighested2 schoolstatus2 selfstatus2

*Wave 1
corr schoolstatus1 selfstatus1 cesdscore1
*Correlations are <.33

pwcorr schoolstatus1 selfstatus1 cesdscore1
*Still <.33

*Wave 2
corr schoolstatus2 selfstatus2 cesdscore2
pwcorr schoolstatus2 selfstatus2 cesdscore2

*Placebo test 
reg cesdscore1 schoolstatus2 selfstatus2
*Coef schoolstatus2 -.5, p<.001
*Coef selfstatus2 -.63, p<.001

*Large enough?
*Made it smaller - go back to AHFullCoded.dta
 use "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/AHFullCoded.dta", clear*/

gen analysissample=(female!=.)&(race!=.)&(wave1grade!=.)&(parenthighested1!=.)&(parenthighested2!=.)&(famtype1!=.)&(schoolstatus1!=.)&(schoolstatus2!=.)&(selfstatus1!=.)&(selfstatus2!=.)&(cesdscore1!=.)&(cesdscore2!=.)
tab analysissample, m


save "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/AHAnalysisSample.dta"
log close


