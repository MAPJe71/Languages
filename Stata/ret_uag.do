use grunduag.dta,clear
set log l 132
* er alle udtrukket korrekt ? 

sort pnr
gen id = _n

gen pnr1 = int(pnr)
drop pnr
rename pnr1 pnr
format pnr %10.0f

gen diagok = 0
replace diagok = 1 if (index(dia1,"812") > 0  | index(dia1,"813") > 0 ) 
replace diagok = 1 if (index(dia2,"812") > 0  | index(dia2,"813") > 0 ) 
replace diagok = 1 if (index(dia3,"812") > 0  | index(dia3,"813") > 0 ) 
replace diagok = 1 if (index(diagnose,"812") > 0  | index(diagnose,"813") > 0 ) 

* det viser sig, at personer med obs diagnose også er med her 

* nogle grupper skal ikke med fordi det ikke er ulykker

gen caseok = 10
replace caseok = 1 if (skaar < 80) 
replace caseok = 2 if (ukode == 20 | ukode == 30) 
replace caseok = 3 if ((ukode == 20 | ukode == 30 ) & (skaar > 86) ) 
replace caseok = 4 if ( ukode == 2  & skaar > 86 ) 
replace caseok = 11 if ( pnr < 100 | nukomm == 999)
replace caseok = 12 if ( diagok == 0)

*problem pnr will not replace for small pnr:
count if pnr < 100
d pnr
list pnr caseok in 1/5
replace caseok = 11 if ( pnr < 100)
mvdecode pnr,mv(-1)
mvdecode pnr,mv(0)
mvencode pnr,mv(10)
count if pnr < 100
list pnr caseok in 1/5
replace caseok = 11 if pnr < 11
list pnr caseok in 1/5
count if pnr < 100
d pnr 				

gen kk1 = bopkomm  
gen kk2 = nukomm

qui for kk1 kk2: recode @ min/438 440 442/446 448/460 462/470 472/482 484 486/490 492/496 498/max =999 
label define _kk 439  "Kertemin" 441  "Langesko" 447  "Munkebo" 461  "Odense"     /*
  */ 471  "Otterup" 483  "Søndersø" 485  "Tommerup" 491  "Vissenbj" 497  "Årslev" 999 "non-Fyn"

replace kk1 = kk2 if kk1 == 999 & kk2 != 999

drop kk2
rename kk1 kk
label value kk _kk
tab kk

assert kk != . 

label define _l1 15 "revisit" 9 "non-area" 13 "age<50" 12 "obs pro" 11 "cpr err" 10 "no injury" /*
   */ 1 "bfr 1980" 2 "code 20/30" 3 "20/30 86+" 4 "code 2 86+"

label value caseok _l1
replace caseok = 9 if (kk == 999 & caseok != 11)

recode kk 439/497=1 999=0
rename kk area
label drop _kk
label def _k1 0 "No" 1 "Yes"
label value area _k1

* omform til datoer:
replace skaar = 1900+skaar
replace baar = 1900+baar
replace faar = 1800+faar if faar > 50
replace faar = 1900+faar if faar < 50

gen dinj = mdy(skmaaned,skdag,skaar)
gen dtrt = mdy(bmaaned,bdag,baar)
gen dborn   = mdy(fmaaned,fdag,faar)
drop skaar baar skdag skmaaned bdag bmaaned fdag fmaaned
tab caseok area

drop if caseok > 9
tab caseok area
sort pnr dinj dtrt
qui by pnr: gen fnr = _n

*/
* flere henvendelser på samme skade ?
replace caseok = 15  if dinj[_n-1] == dinj & pnr == pnr[_n-1]

gen dslf= dinj-dinj[_n-1] if pnr == pnr[_n-1]
gen dtnf= -dinj+dinj[_n+1] if pnr == pnr[_n+1]

gen again = 0
replace again = 1 if ( (pnr == pnr[_n+1]) & dinj[_n+1] == dinj )
replace again = 2 if ( caseok == 15)
replace again = 3 if ( (pnr == pnr[_n+1]) & abs(dslf) < 43)


format dinj-dborn %ddmcY
sort pnr dinj dtrt 
list pnr dinj dtrt dslf dtnf fnr again ag if (id < 125 & id > 50 & ag > 0),nodispl

tab again

drop if ((again == 2) | (again == 3))
* beregn forfra.

format dinj-dborn %12.0f
drop dslf dtnf again fnr 

sort pnr dinj dtrt 
gen dslf= dinj-dinj[_n-1] if pnr == pnr[_n-1]
gen dtnf= -dinj+dinj[_n+1] if pnr == pnr[_n+1]
qui by pnr: gen fnr = _n

label var fnr "Fracture number"

label data "Incident fractures ICD=812/812 Denmark, Odense 1976-1993"

save "\projekt\fraktur\uagdata\event_fracture.dta,replace

