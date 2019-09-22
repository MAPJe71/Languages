* resultater 
use spillere, clear 	/* spiller information */
drop if periode == 1
gen test = 1 if gruppe != "K"
replace test = 0 if gruppe == "K"
qui label define v1  0 "Control" 1 "Test"
qui label value test v1
qui label var sportn "Discipline"
qui label var test "Intervention Area ?"
qui label define v2 1 "Badminton" 2 "Handball" 3 "Football"
qui label value sportn v2

recode anttrn 4=3
label def anttrn 1 "1" 2 "2" 3 "3+", modify

gen test1 = cond(test == 1,0,1)
label var test1 "Intervention area ?"

capture program drop table3
program define table3
local a="`1'"
local b="`2'"
local varlbl : variable label `1'   
display _newline "table for `1': `varlbl'"
ta `a' if sportn == `b'
cc `a' test if sportn == `b',exact
end

keep if inretro   /* kun dem med retroskema er med i analysen*/

label var anttrn "Weekly training sessions (incl. match)"
*************************************************************************
* generelle markører for indsats:
for sr3b sr3g: tab test @1, row chi


* Table 3. Indicators for adaptation of the structured training methods. 

* Information at player level ("end of season questionnaires")
for sr3e sr3h sr3f: table3 @1 1
for sr3e sr3h sr3f: table3 @1 2
for sr3e sr3h sr3f: table3 @1 3


*Table 4 Indicators for implementation of post injury rehabilitation principles 
for sr3c sr3i sr3j: table3 @1 1
for sr3c sr3i sr3j: table3 @1 2
for sr3c sr3i sr3j: table3 @1 3

for sr5a sr5b sr5c: mvdecode @1, mv(99)
for sr5a sr5b sr5c: recode @1 2=0

*Table 5 Measures of effect on injury occurrence in the control and intervention are
for sr5a sr5b sr5c: table3 @1 1
for sr5a sr5b sr5c: table3 @1 2
for sr5a sr5b sr5c: table3 @1 3


for sr5anmr sr5bnmr sr5cnmr : ta @1 test if sportn == 1, col chi gamma
for sr5anmr sr5bnmr sr5cnmr : ta @1 test if sportn == 2, col chi  gamma
for sr5anmr sr5bnmr sr5cnmr : ta @1 test if sportn == 3, col chi  gamma

for sr5anmr sr5bnmr sr5cnmr : kwallis @1 if sportn == 1, by(test)
for sr5anmr sr5bnmr sr5cnmr : kwallis @1 if sportn == 2, by(test)
for sr5anmr sr5bnmr sr5cnmr : kwallis @1 if sportn == 3, by(test)

for sr5anmr sr5bnmr sr5cnmr : recode @1 3/max=3 

for sr5anmr sr5bnmr sr5cnmr : ta @1 test if sportn == 1, row chi gamma
for sr5anmr sr5bnmr sr5cnmr : ta @1 test if sportn == 2, row chi gamma
for sr5anmr sr5bnmr sr5cnmr : ta @1 test if sportn == 3, row chi gamma

x
use hold, clear   	/* hold information */
drop if periode == 1
gen test = 1 if gruppe != "K"
replace test = 0 if gruppe == "K"
qui label define v1  0 "Control" 1 "Test"
qui label value test v1
qui encode sport, g(sportn)
qui label var sportn "Discipline"
qui label var test "Area"
qui label define v2 1 "Badminton" 2 "Handball" 3 "Football"
qui label value sportn v2
tab sportn test


*Information at team level
*- based on direct observation by external supervisors

*- trainer "end of season" questionnaires


