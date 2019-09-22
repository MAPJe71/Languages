
* Example of Simpsons paradox from the literature
*
* Example based on S.Kreiner, danish statistical textbook 
* table 12-2
*
capture log close
log using partgam1,replace
clear
input victime killer dp c
1 1 1 11 
1 1 0 2209 
1 0 1  0
1 0 0  111 
0 1 1  48 
0 1 0  239
0 0 1  72
0 0 0  2074  
end

label var dp "Death Penalty"
label var killer "Race of killer"
label var victime "Race of killed person"

more

label define rac 0 "white" 1 "black"
label define yn 0 "no" 1 "yes"
label value killer rac
label value victime rac
label value dp yn
list
sort victime
tabulate killer dp [freq=c], chi gamma  
by victime: tabulate killer dp [freq=c], chi gamma  
more
push partgam killer dp[freq=c], adj(victime) table
partgam killer dp[freq=c], adj(victime) 
more
partgam killer dp[freq=c], adj(victime) sub
log close
