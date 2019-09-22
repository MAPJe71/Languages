gen km = postnr

recode km 1138/2770 = 28.5
recode km 2791/2990 = 28.5
recode km 3000/3390 = 30.5
recode km 3400/3660 = 27
recode km 3700/3770 = 32
recode km 4000/4070 = 24

* by adding "qui {" lines are not shown in output window:
qui {
recode km 4100/4180 = 21
recode km 4200/4296 = 16.5
recode km 4300/4390 = 20.5
recode km 4400/4571 = 21
recode km 4600/4681 = 25
recode km 4690= 23
recode km 4700/4750 = 22
recode km 4760/4780 = 24
recode km 4800/4873 = 26
recode km 4900/4970 = 19.5
recode km 5000/5290 = 7
recode km 5300/5380 = 9
recode km 5400 = 3.5
recode km 5450 = 6.5
recode km 5462/5492 = 5.5
recode km 5500/5592 = 0
recode km 5600 = 5.5
recode km 5610/5690 = 6.5
recode km 5700 = 12
recode km 5750/5792 = 9.5
recode km 5800/5892 = 12
recode km 5863  = 10
recode km 5953/5970 = 15
recode km 6000 = 3
recode km 6040/6093 = 5.
recode km 6100  = 6.5
recode km 6200/6230 = 10
recode km 6261/6280 = 13
recode km 6300/6392 = 11.5
recode km 6400/6440 = 12
recode km 6500 = 7.5
recode km 6534/6535 = 10.5
recode km 6550/6683 = 5.25
recode km 6600/6623 = 6.5
recode km 6700/6715 = 13.5
recode km 6720/6780 = 11.75
recode km 6800/6880 = 13
recode km 6900/6933 = 14.5
recode km 6950/6990 = 18
recode km 7000 = 0
recode km 7080 = 0
recode km 7100/7150 = 3
recode km 7160/7183 = 6
recode km 7190 = 7
recode km 7200/7260 = 9
recode km 7300 = 5
recode km 7321/7361 = 7.5
recode km 7400/7451 = 13
recode km 7470/7490 = 15
recode km 7500 = 18.5
recode km 7570/7790 = 20.5
recode km 7800/7870 = 19.5
recode km 8000/8270 = 11.75
recode km 8300 = 8.5
recode km 8305/8382 = 11
recode km 8410/8530 = 18.25
recode km 8541/8586 = 14
recode km 8600/8643 = 11
recode km 8660/8680 = 9
recode km 8700/8721 = 5.5
recode km 8722/8766 = 3
recode km 8800/8990 = 16.25
recode km 9000/9440 = 27
recode km 9500/9560 = 19.5
recode km 9600/9750 = 22
recode km 9800/9940 = 34
}

* recodings only partially shown

replace km = km + 15 if postnr > 1137 & postnr < 4901

recode km 9997/9999 = .
* recode from distance in cm to distance in Km
replace km = int(km*6.1)

gen kmgrp = km
recode kmgrp 0/25 = 1 26/62 = 2 63/120 = 3 121/max = 4 

recode kmgrp min/max=5 if km > 1137 & km < 3701
recode kmgrp min/max=6 if km > 3700 & km < 4901


label var kmgrp "Residence of runner" 
          
label define kmlbl 1 "0- 25 km" 2 "26-62 km"  3 "63 -120" /*
        */ 4 "120+ km" 5 "Copenhagen" 6 "East Denmark Other"

label value kmgrp kmlbl
tab kmgrp

replace km    = . if postnr == 812
replace kmgrp = . if postnr == 812

* easier syntax would be:
*for var kmgrp km: replace X = . if postnr == 812

tab kmgrp

tab kmgrp, missing
