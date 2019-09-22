* oparbejd.do will read raw data from bromraw.txt
*capture version 5
insheet id pnr born sex runtime using bromraw.txt, clear    
describe		  
list in 1/8
codebook 		  
count if born == .	
capture noisily assert born != . 	

* make variable counting number of missing
generate error = 0	
replace error = 1 if born == . 	
replace error = error+1 if pnr == "" 	
list  if error > 1 in 1/100 	
list if error == 2	
tabulate error sex	

* ALTERNATIVE STRATEGY FOR MISSING:
* pattern born postnr sex, detail      /* try search pattern */

generate str5 pnr1 = pnr           /* generate copy of type string 5*/
* foreign and invalid postal numbers are identified: 
replace pnr = "9998" if (index(pnr,"pl") > 0)
replace pnr = "9998" if length(pnr) > 4
replace pnr = "" if length(trim(pnr)) < 4
replace pnr = "9998" if (index(pnr,"-") > 0)
replace pnr = "" if index(pnr," ") > 0    /* embedded blank */
count if pnr1 != pnr				/* count changed observations */
count if pnr == "9998"			/* foreign postal codes */
list pnr1 pnr if pnr != pnr1          /*list all changed observations */
drop if pnr == "9998"			/* foreign postal codes */
drop if error > 1 			/* sex and postal code missing */

list if pnr != pnr1

drop pnr1
describe

* ready to generate numeric postnr 
generate postnr = real(pnr)


* compute distance from race to residence:
do brompost


* sex omdøbes til en talvariabel samtidig label
destring sex
tab sex, nolabel

* age:
gen age = 96-born
generate agegrp = int(age/10)*10
* alternativt: generate agegrp = recode(age,10,20,30,40,50,60,70,80,90,100)
* alternativt: egen agegrp = cut(age) , at(10(10)70,100) label
* alternativt: egen agegrp = cut1(age) , at(10(10)70,100) label interval 

label var agegrp  "Age (10 year intervals)" 
label var age  "Age (1996-year of birth)" 

notes age: Age calculated as 96-the year given as year of birth.
codebook age agegrp
notes      

* notice that two persons have "wrongly coded=illegal" ages:
replace age = . if age  < 16
replace age = . if age  > 90
replace agegrp = . if age  < 16
replace agegrp = . if age  > 90

* time changed to decimaltime 
gen time=int(runtime/10000)
gen minute=int((runtime-time*10000)/100)
list id-runtime time minute in 1/10
gen dectime = time + minute/60
egen decgrp = cut1(dectime), group(4) interval x(2)

*generate binomial variable indicating completion of race
generate runok = cond(dectime != . , 1,0)
label var runok "Marathon race completed ?"
label define yn 0 "No" 1 "Yes"
label value runok yn 
label var error "Number of variables missing"
label var dectime "Completion time - Hours" 
label var km "Distance in km from residence"
label var decgrp "Completion time - Hours" 

save temp, replace
* drop unneeded variables.
drop runtime pnr postnr born time minut

sort id

compress             /* variabel types compressed */
label data "Marathon data - 1995 across bridges from Funen and West-Jutland" 
describe
save bromar, replace

gra dectime age, xlab(20(20)80) ylab(2.5(1)6) saving(1,replace)
graph using 1, margin(15)

