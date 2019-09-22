use hipraw,clear

* first convert numerical to date variable. 
list born in 1/5

* make string variable:
gen str8 d1 = string(born)
replace d1 = " " + d1 if length(d1) == 5

list born d1 in 1/5

*Add separation of day, month and year:
replace d1 = substr(d1,1,2)+"/"+substr(d1,3,2)+"/"+substr(d1,5,2)

list born d1 in 1/5

* now convert to the proper date format using the function date. 
* Note the dm19y because of the two digit year entered.

gen db = date(d1,"dm19y")
format db %d

list born d1 db in 1/5

* drop the intermediate variables:
drop d1

label var db "Date of Birth"

gen v1 = h10a*30 if h10a != .

replace v1 = 2 if h10 == 1
replace v1 = 7 if h10 == 2
replace v1 = 30 if h10 == 3
replace v1 = hda - h4 if v1 == .
lab var v1 "Hip Protector Usage - Days"

replace h9 = 5 if h8 == 2
lab define h9 0 "Stopped-Various reasons" 1 "Stopped-continence" 4 "Used until Dead" 5 "Still Using"

lab val h9 h9
 
* note long lines separated on two lines like this:

ltable v1 h8, by(h9) graph b2(" ") b1(" ") ylab(0(0.2)1.0) yline(0.5) /*
       */ xline(30) noconf saving(1,replace) xlab(0,30,100(100)400)

gra using 1, t1("              Length of Hipprotector Use - Days")  margin(5) saving(final,replace)
 

