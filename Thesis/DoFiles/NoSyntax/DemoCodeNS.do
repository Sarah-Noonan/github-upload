*Demographic Variable Coding File -No Syntax* 
cd "/Users/Sarah/Documents/_NYU/Thesis/Data/Master"
use "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/AH_NoSyntaxMerged.dta", clear

*Codes for: race, gender, grade

*make variables lowercase
rename *, lower

*binary code
label define binary 1 "1: Yes" 0 "0: No"

//Controls
*gender
gen female=.
replace female=1 if bio_sex==2
replace female=0 if bio_sex==1
label var female "Female"
label values female binary
tab female bio_sex, m
gen male=(female==0)
label var male "Male"
label values male binary
tab female male, m

*Race - Based on AddHealth coding (link) and adding "Two or more" option.
gen race=. 
replace race=1 if h1gi4==1
replace race=2 if h1gi6b==1 & h1gi4==0 & h1gi8==7 
replace race=3 if h1gi6d==1 & h1gi4==0 & h1gi8==7 
replace race=4 if h1gi6c==1 & h1gi4==0 & h1gi8==7 
replace race=5 if h1gi6e==1 & h1gi4==0 & h1gi8==7 
replace race=6 if h1gi6a==1 & h1gi4==0 & h1gi8==7 
replace race=7 if h1gi8!=7

label define race 1 "1 Hispanic" 2 "2 Black" 3 "3 Asian" 4 "4 Native American" 5 "5 Other race" 6 "6 White" 7 "7 Multiple racial groups"
label values race race
label var race "Race"
tab race h1gi4, m

*Create dummy variables for each category or 6.race
gen hispanic=(race==1)
label var hispanic "Hispanic"
gen black=(race==2)
label var black "Black"
gen asian=(race==3)
label var asian "Asian"
gen natamer=(race==4)
label var natamer "Native American"
gen otherrace=(race==5)
label var otherrace "Other race"
gen white=(race==6)
label var white "White"
gen multirace=(race==7)
label var multirace "Multiple racial identities"

global races "hispanic black white asian natamer otherrace white multirace"
foreach i of varlist $races{
label values `i' binary
tab `i' race, m
}

alpha hispanic black asian natamer otherrace white multirace

factor hispanic black asian natamer otherrace white multirace
*What does uniqueness indicate? How much variance unexplained by common factors

factor hispanic black asian natamer otherrace white multirace, pcf


*drop if not in school in W1
 
*Grade Wave 1 and Wave 2
gen wave1grade=.
replace wave1grade=h1gi20 if h1gi20<=12
tab wave1grade h1gi20, m
list h1gi20 if aid=="57100270"

label var wave1grade "Grade in School at Wave 1"
*gen gradeW2=.
*replace gradeW2=h2gi9 if h2gi9<=13
*tab gradeW1 gradeW2, m
*Drop Wave 1 12th grader who reported being in 11th grade in Wave 2 /*N=6503*/ 
*drop if gradeW1==12 & h2gi9<=11

save "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/AHDemoCoded.dta", replace

