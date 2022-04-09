** AH Master Family Coding - NoSyntax **
log using "/Users/Sarah/Documents/_NYU/Thesis/Rerun.log"
cd "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/"
use "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/AHDemoCoded.dta", clear

/*Logic - Identifies parent type and corresponding Wave 1 education, tries to
matches Wave 2 education with same person.
Identifies household composition in wave 1 and will look for any changes in Wave II
*/
/*recode h1rm1, h1rf1 h2rm1 so 10=0
global ed "h1rm1 h1rf1 h2rm1"
foreach i of varlist $ed{
recode `i' (10=0)
tab `i', m
}
*/

*Identify parent composition: Wave 1
*Mother
label define mom 1 "1 Biological resident mother" 2 "2 Biological-nonresident mother (no resident mother)" 3 "3 Non resident biological mother and resident nonbiological mother (Placeholder)" 4 "4 Resident mother serves as mother figure (no biological mother)" 5 "5 No mother figure identified" 
gen momtype1=.
label var momtype1 "Description of mother whose SEP is measured in Wave I"
label values momtype1 mom

*Coding for momtype1
*Biological resident
replace momtype1=1 if h1nm1==7

*Information on how many nonres biol mothers years of schooling where there is also no resident mother?
tab h1nm4 if h1nm4!=97, m
replace momtype1=2 if h1nm4<=9 & h1hr12==0
replace momtype1=2 if h1nm4<=9 & h1pf1==7
tab momtype1, m

*No resident mother figure nor biological nonresident mother identified
replace momtype1=5 if momtype1==. & h1nm1!=1 & h1nm1!=7 & h1hr12==0
replace momtype1=5 if momtype1==. & h1nm1!=1 & h1nm1!=7 & h1pf1==7
tab momtype1, m

* 3 Resident nonbiological mothers
foreach x in a b c d e f g h i j k l m n o p q r s t{
replace momtype1=4 if momtype1==. & h1hr3`x'==14 & h1hr6`x'>=8 & h1hr6`x'!=97
}

tab momtype1, m

*If don't know biological mother's education, use resident mother's.
replace momtype1=4 if momtype1==. & h1nm4>=11 & h1nm4!=97 & h1rm1<=9
tab momtype1, m

*If don't know nonbiores mother's education, use biomom's
replace momtype1=2 if momtype1==. & h1rm1>=11 & h1rm1!=97 & h1nm4<=9
tab momtype1, m

*If information available on both biological and resident mother's educations, use higher value
tab h1nm4 h1rm1, m
replace momtype1=2 if momtype1==. & h1nm4>=h1rm1 & h1nm4<=9 & h1rm1<=9 & h1nm1!=7
replace momtype1=4 if momtype1==. & h1nm4<h1rm1 & h1nm4<=9 & h1rm1<=9 & h1nm1!=7

tab momtype1, m /*54 missing cases*/

// Apply dad code and see for how many both missing.
*Coding for dadtype1
gen dadtype1=.
label define dad 1 "1 Biological father is resident father" 2 "2 Biological-nonresident father (no resident father)" 3 "3 Biological nonresident father and/or resident nonbiological father (Placeholder)" 4 "4 Resident father serves as father (no biological father)" 5 "5 No father figure identified"
label values dadtype1 dad
label var dadtype1 "Description of father whose SEP is measured in Wave II"

*Biological resident
replace dadtype1=1 if h1nf1==7

*Information on how many nonres biol fathers years of schooling where there is also no resident father?
*tab h1nf4 if h1nf4!=97, m
replace dadtype1=2 if h1nf4<=9 & h1hr12==0
replace dadtype1=2 if h1nf4<=9 & h1pf23==7
tab dadtype1, m

*No resident father figure nor biological nonresident father identified
replace dadtype1=5 if dadtype1==. & h1nf1!=1 & h1nf1!=7 & h1hr12==0
replace dadtype1=5 if dadtype1==. & h1nf1!=1 & h1nf1!=7 & h1pf23==7
tab dadtype1, m

*Resident nonbiological fathers
foreach x in a b c d e f g h i j k l m n o p q r s t{
replace dadtype1=4 if dadtype1==. & h1hr3`x'==11 & h1hr6`x'>=2 & h1hr6`x'<=6
}

tab dadtype1, m

*If don't know biological father's education, use resident father's.
replace dadtype1=4 if dadtype1==. & h1nf4>=11 & h1nf4!=97 &  h1rf1<=9
tab dadtype1, m

*If don't know resident father's education, use biological father's
replace dadtype1=2 if dadtype1==. & h1nf4<=9 & h1rf1>=9 & h1rf1!=97 
tab dadtype1, m

*If information on both biological and resident father's educations, use higher value
replace dadtype1=2 if dadtype1==. & h1nf4>=h1rf1 & h1nf4<=9 & h1rf1<=9 & h1nf1!=7
replace dadtype1=4 if dadtype1==. & h1nf4<h1rf1 & h1nf4<=9 & h1rf1<=9 & h1nf1!=7
tab dadtype1, m
*274 missing

tab momtype1 dadtype1, m
*19 mutual missing
*174 indicate living with neither biomother nor biofather
tab h1hr12 h1hr13 if momtype1==2 & dadtype1==2, m
replace momtype1=4 if momtype1==2 & dadtype1==2 & h1hr12>=1 & h1hr12<=8

tab momtype1 dadtype1, m
*83 cases where indicate living with neither biomother nor biofather
tab h1hr12 h1hr13 if momtype1==2 & dadtype1==2, m
replace dadtype1=4 if momtype1==2 & dadtype1==2 & h1hr13>=1 & h1hr13<=6

tab momtype1 dadtype1, m
tab h1hr12 h1hr13 if momtype1==2 & dadtype1==2, m
*71 cases where no mother figure nor father figure in household

/*9 cases where momtype1 and/or dadtype1 should both be recoded as 4 but don't know which to recode*/
tab h1hr12 if momtype1==2 & dadtype1==2, m
tab h1hr13 if momtype1==2 & dadtype1==2, m 

*Still don't know, so will recode mother as type 4
replace momtype1=4 if momtype1==2 & dadtype1==2 & h1hr12==97

tab h1hr12 h1hr13 if momtype1==. & dadtype1==.
replace momtype1=4 if momtype1==. & dadtype1==. & h1hr12>=1 & h1hr12<=8
replace dadtype1=4 if momtype1==. & dadtype1==. & h1hr13>=1 & h1hr13<=6
replace dadtype1=4 if dadtype1==. & h1hr13>=1 & h1hr13<=8

tab momtype1 dadtype1, m /*Down to 5 mutual missing*/
*recode as 5
*Again, can't recode both so will recode mom
replace momtype1=5 if momtype1==. & dadtype1==.
tab momtype1 dadtype1, m

**Dummy variables for momtypes, Wave 1
gen bioresmom1=(momtype1==1)
label var bioresmom1 "Biological resident mother at Wave I"
label values bioresmom1 binary
gen biononresmom1=(momtype1==2)
label var biononresmom1 "Biological nonresident mother at Wave I"
label values biononresmom1 binary
gen nonbioresmom1=(momtype1==4)
label var nonbioresmom1 "Non biological resident mother at Wave I"
label values nonbioresmom1 binary
gen nomom1=(momtype1==5)
label var nomom1 "No mother figure reported/known at Wave I"
label values nomom1 binary

*Dummy variables for dadtype Wave 1
gen bioresdad1=(dadtype1==1)
label var bioresdad1 "Biological resident father at Wave I"
label values bioresdad1 binary
gen biononresdad1=(dadtype1==2)
label var biononresdad1 "Biological nonresident father at Wave I"
label values biononresdad1 binary
gen nonbioresdad1=(dadtype1==4)
label var nonbioresdad1 "Non biological resident father at Wave I"
label values nonbioresdad1 binary
gen nodad1=(dadtype1==5)
label var nodad1 "No father figure reported/known at Wave I"
label values nodad1 binary


*Family type
/*Look at King's cited papers for guidance on how to consolidate these categories*/
gen famtype1=.
label var famtype1 "Family-Household Composition at Wave I"
label define family 1 "1 Lives with both biological parents" 2 "2 Lives with one biological parent" 3 "3 Lives with one biological parent and one nonbiological parent"  4 "4 Lives with two nonbiological parents" 5 "5 Other or unknown living arrangement" 
label values famtype1 family

replace famtype1=1 if momtype1==1 & dadtype1==1

replace famtype1=2 if momtype1==1 & dadtype1==.
replace famtype1=2 if dadtype1==1 & momtype1==.
replace famtype1=2 if momtype1==1 & dadtype1==5
replace famtype1=2 if dadtype1==1 & momtype1==5

replace famtype1=2 if momtype1==1 & dadtype1==2
replace famtype1=2 if dadtype1==1 & momtype1==2

replace famtype1=3 if momtype1==1 & dadtype1==4
replace famtype1=3 if momtype1==4 & dadtype1==1

replace famtype1=4 if momtype1==4 & dadtype1==4

replace famtype1=5 if momtype1==4 & dadtype1==.
replace famtype1=5 if dadtype1==4 & momtype1==.
replace famtype1=5 if momtype1==4 & dadtype1==2
replace famtype1=5 if momtype1==2 & dadtype1==4

replace famtype1=5 if momtype1==2 & dadtype1==2
replace famtype1=5 if momtype1==. & dadtype1==.
replace famtype1=5 if momtype1==2 & dadtype1==.
replace famtype1=5 if momtype1==. & dadtype1==2

tab momtype1 famtype1, m
*One case where momtype1==4 & famtype1==.
tab dadtype1 if momtype1==4 & famtype1==., m
*No father figure identifed
replace famtype1=5 if famtype1==. & momtype1==4 & dadtype1==5
tab dadtype1 famtype1, m
*No changes to make

/*corr momtype1 famtype1 /*.58*/
corr dadtype1 famtype1 /*.71*/
*/

gen twobiorespar1=(famtype1==1)
label var twobiorespar1 "Lives with both biological parents at Wave I"
label values twobiorespar1 binary
gen onebiorespar1=(famtype1==2)
label values onebiorespar1 binary
label var onebiorespar1 "Lives with one biological parent at Wave I"
gen bioblended1=(famtype1==3)
label var bioblended1 "Lives with one biological parent and one nonbiological parent at Wave I"
label values bioblended1 binary
gen twononbiorespar1=(famtype1==4)
label var twononbiorespar1 "Lives with two non-biological parents at Wave I"
label values twononbiorespar1 binary
gen fam_other1=(famtype1==5)
label var fam_other1 "Other or unknown living arrangement at Wave I"
label values fam_other1 binary 

//
* Mother's education, Wave 1
gen mothered1=.
label var mothered1 "Mother's years of schooling at Wave I"

replace mothered1=8 if momtype1==1 & h1rm1==1
replace mothered1=10 if momtype1==1 & h1rm1==2
replace mothered1=12 if momtype1==1 & h1rm1>=3 & h1rm1<=5
replace mothered1=14 if momtype1==1 & h1rm1>=6 & h1rm1<=7
replace mothered1=16 if momtype1==1 & h1rm1==8
replace mothered1=18 if momtype1==1 & h1rm1==9

* Biological mother's education not measured in Wave II, so code as same
* Introduces bias/threat to validity - Goodman paper
gen mothered2=.
label var mothered2 "Mother's years of schooling at Wave II"

replace mothered1=8 if momtype1==2 & h1nm4==1
replace mothered1=10 if momtype1==2 & h1nm4==2
replace mothered1=12 if momtype1==2 & h1nm4>=3 & h1nm4<=5
replace mothered1=14 if momtype1==2 & h1nm4>=6 & h1nm4<=7
replace mothered1=16 if momtype1==2 & h1nm4==8
replace mothered1=18 if momtype1==2 & h1nm4==9

replace mothered2=mothered1 if momtype1<=2

* Resident mother only
replace mothered1=8 if momtype1==4 & h1rm1==1
replace mothered1=10 if momtype1==4 & h1rm1==2
replace mothered1=12 if momtype1==4 & h1rm1>=3 & h1rm1<=5
replace mothered1=14 if momtype1==4 & h1rm1>=6 & h1rm1<=7
replace mothered1=16 if momtype1==4 & h1rm1==8
replace mothered1=18 if momtype1==4 & h1rm1==9

*Resident mother only, Wave 2
*No obseverations
replace mothered2=8 if momtype1==4 & mothered1==8 & h2rm1==1
replace mothered2=10 if momtype1==4 & mothered1<=10 & h2rm1==2
replace mothered2=12 if momtype1==4 & mothered1>=10 & mothered1<=12 & h2rm1>=3 & h2rm1<=5
replace mothered2=14 if momtype1==4 & mothered1<=12 & mothered1<=14 & h2rm1>=6 & h2rm1<=7
replace mothered2=16 if momtype1==4 & mothered1>=14 & mothered1<=16 & h2rm1==8
replace mothered2=18 if momtype1==4 & mothered1>=16 & h2rm1==9

*tab mothered1 h2rm1 if mothered2==.
replace mothered2=mothered1 if mothered1!=. & mothered2==.
replace mothered1=mothered2 if mothered1==. & mothered2!=.

tab mothered1 mothered2, m

tab momtype1 if mothered1==. & mothered2==., m
tab h1rm1 if momtype1==1 & mothered1==. & mothered2==., m
*6 cases where biological, resident mother didn't go to school - keep as .
*tab h2rm1 if momtype1==1 & mothered1==.
tab h1rm1 if momtype1==4 & mothered1==. & mothered2==., m
tab h2rm1 if momtype==4 & mothered1==. & mothered2==. , m
/*6 cases where non biol, res mother1's ed indicated in Wave II but 
don't know if it is same person--keep as missing.*/

tab momtype1 mothered1, m
tab momtype1 mothered2, ,

corr mothered1 mothered2

*Father's education Wave 1
gen fathered1=.
label var fathered1 "Father's years of schooling at Wave I"

* Biological Resident Father
replace fathered1=8 if dadtype1==1 & h1rf1==1
replace fathered1=10 if dadtype1==1 & h1rf1==2
replace fathered1=12 if dadtype1==1 & h1rf1>=3 & h1rf1<=5
replace fathered1=14 if dadtype1==1 & h1rf1>=6 & h1rf1<=7
replace fathered1=16 if dadtype1==1 & h1rf1==8
replace fathered1=18 if dadtype1==1 & h1rf1==9

*Biological nonresident dad
replace fathered1=8 if dadtype1==1 & h1nf4==1
replace fathered1=10 if dadtype1==1 & h1nf4==2
replace fathered1=12 if dadtype1==2 & h1nf4>=3 & h1nf4<=5
replace fathered1=14 if dadtype1==2 & h1nf4>=6 & h1nf4<=7
replace fathered1=16 if dadtype1==2 & h1nf4==8
replace fathered1=18 if dadtype1==2 & h1nf4==9

* Resident father only
replace fathered1=8 if dadtype1==1 & h1rf1==1
replace fathered1=10 if dadtype1==1 & h1rf1==2
replace fathered1=12 if dadtype1==4 & h1rf1>=3 & h1rf1<=5
replace fathered1=14 if dadtype1==4 & h1rf1>=6 & h1rf1<=7
replace fathered1=16 if dadtype1==4 & h1rf1==8
replace fathered1=18 if dadtype1==4 & h1rf1==9

*Wave II
gen fathered2=.
label var fathered2 "Father's years of schooling at Wave II"

*Biological fathers (resident and nonresident)
replace fathered2=fathered1 if dadtype1<=2

*Non-biological resident fathers
replace fathered2=8 if dadtype1==4 & fathered1==8 & h2rm1==1
replace fathered2=10 if dadtype1==4 & fathered1<=10 & h2rm1==2
replace fathered2=12 if dadtype1==4 & fathered1>=10 & fathered1<=12 & h2rm1>=3 & h2rm1<=5
replace fathered2=14 if dadtype1==4 & fathered1<=12 & fathered1<=14 & h2rm1>=6 & h2rm1<=7
replace fathered2=16 if dadtype1==4 & fathered1>=14 & fathered1<=16 & h2rm1==8
replace fathered2=18 if dadtype1==4 & fathered1>=16 & h2rm1==9

tab dadtype1 fathered1, m
tab dadtype1 fathered2, m
tab fathered1 fathered2, m
corr fathered1 fathered2, m


*Compare father type at Wave 1 with education at Wave 1
*Parents' highest combined educational attainment
*Compare
tab mothered1 fathered1, m
tab dadtype1 fathered1, m

*Highest educational attainment combined
gen parenthighested1=.
label var parenthighested1 "Highest Parental Educational Attainment at Wave I"
label def parentref 1 "Mother" 2 "Father"
gen parentref1=.
label var parentref1 "Parent being measured at Wave I"
label values parentref1 parentref

replace parenthighested1=mothered1 if mothered1!=. & fathered1==.
replace parenthighested1=fathered1 if fathered1!=. & mothered1==.

replace parenthighested1=mothered1 if mothered1>=fathered1 & mothered1!=. & fathered1!=.
replace parentref1=1 if parenthighested1==mothered1 

replace parenthighested1=fathered1 if fathered1>mothered1 & mothered1!=. & fathered1!=.
replace parentref1=2 if parenthighested1==fathered1
tab mothered1 parenthighested1 if parentref==1, m
tab fathered1 parenthighested1 if parentref1==2, m

*Missing values for 938 respondents
*Combined wave 2
gen parenthighested2=parenthighested1
label var parenthighested2 "Highest Parental Educational Attainment at Wave II"

replace parenthighested2=mothered2 if mothered2>=parenthighested1 & mothered2!=. & parenthighested1!=.
replace parenthighested2=fathered2 if fathered2>=parenthighested1 & fathered2>=parenthighested2 & fathered2!=. & parenthighested1!=.

tab parenthighested1 parenthighested2, m

tab mothered1 parenthighested2, m
tab fathered1 parenthighested2, m

tab mothered2 parenthighested2, m
tab fathered2 parenthighested2, m



corr parenthighested1 parenthighested2, m

tab famtype1 parenthighested1, m
*We could check for information based on momtype1, dadtype1 & questionnaire

tab famtype1 parenthighested2, m



*EOF
save "/Users/Sarah/Documents/_NYU/Thesis/Data/Master/AHFamilyCoded.dta", replace
