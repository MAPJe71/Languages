qui use fyn,clear
gen sex = 1 in 3
replace sex = 2 in 4
label define sexlbl 1 male 2 female
label value sex sexlbl
drop if sex == .
gen id = _n


reshape long c, i(id) j(age) 
replace age = age-2                                                          

drop if age > 99 | age < 0

gen count = real(c)
gen males = -real(c) if sex == 1
gen females = real(c) if sex == 2

replace females = real(c[_n+100]) if sex == 1
drop in 101/200
gen lbl =  age
replace lbl = . if mod(age,10) > 0 

hbar males females, l(lbl)
gen str2 slbl = string(lbl)
replace slbl = " " if lbl == .

hbar males females, l(slbl) lap /*
  */ xla(-4250,-4000,-3000,-2000,-1000,0,1000,2000,3000,4000,4250) /*
  */ ttick t1(Demographic composition, 1998) t2(Funen County, Denmark)/*
  */ barfrac(0.85) xline(-1000,-2000,-3000,0,1000,2000,3000) saving(pyramid,replace)

gsort -age

more
hbar males females, l(slbl) lap /*
  */ xla(-4250,-4000,-3000,-2000,-1000,0,1000,2000,3000,4000,4250) /*
  */ ttick t1(Demographic composition, 1998) t2(Funen County, Denmark)/*
  */ barfrac(0.85) xline(-1000,-2000,-3000,0,1000,2000,3000) saving(pyramid,replace)

more

gen dif = males - (-females)
label var dif "Male             Female          "

hbar dif, l(slbl) lap /*
  */ xla(-500,-250,0,250,500) t2(Diffence N males - N of females) /*
  */ ttick t1(Female preponderance with age) /*
  */ barfrac(0.85) xline(-250,0,250,500)

