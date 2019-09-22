* materiale og non-response analyse

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


use spillere, clear 	/* spiller information */
drop if periode == 1
gen test = 1 if gruppe != "K"
replace test = 0 if gruppe == "K"
qui label define v1  0 "Control" 1 "Test"
qui label value test v1
qui label var sportn "Discipline"
qui label var test "Area"
qui label define v2 1 "Badminton" 2 "Handball" 3 "Football"
qui label value sportn v2

table sex sportn test,  row col
table agegrp1 sportn test,  row col
table elite sportn test,  row col

for sex agegrp1 elite: tab @1 test if sportn == 1, chi row 
for sex agegrp1 elite: tab @1 test if sportn == 2, chi row 
for sex agegrp1 elite: tab @1 test if sportn == 3, chi row 

* endelig sammenlignes retroskemaer med øvrige indenfor kontrol og test område:

sort sportn test
tab test inretro, chi row
by sportn test: tab elite inretro, chi row
by sportn test: tab agegrp1 inretro, chi row
by sportn test: tab sex inretro, chi row

* samme træningsvaner ??

recode anttrn 4=3
label def anttrn 1 "1" 2 "2" 3 "3+", modify
label var anttrn "Weekly training sessions (incl. match)"
etab test anttrn if sportn == 1, row chi
etab test anttrn if sportn == 2, row chi
etab test anttrn if sportn == 3, row chi

