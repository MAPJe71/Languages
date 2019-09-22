capture log close
log using partgam2.log,replace
set more on
*
* Example based on S.Kreiner, danish statistical textbook 
* table 12-3
*
clear
input child wifeage job c
1 1 1  5 
1 1 0  7
1 0 1  64
1 0 0  88 
0 1 1  233 
0 1 0  91
0 0 1  142
0 0 0  35  
end

label var job "Wife having a job"
label var wifeage "Age of wife"
label var child "Has a child"

label define age 0 "-38" 1 "39+"
label value wifeage age
label define yn 0 "No" 1 "Yes"
label value child yn
label value job yn
more
list
sort wifeage
tabulate wifeage job [freq=c], chi gamma  
more
by wifeage: tabulate wifeage job [freq=c], chi gamma  
more
* tables with various options:
*table wifeage  job child [freq=c]
*table wifeage job  child [freq=c], col
*table wifeage job child [freq=c], col row
more
sort child
* tables with various options:
table wifeage  job [freq=c], by(child)
table wifeage  job [freq=c], col by(child)
table wifeage  job [freq=c], col row by(child)
more
* finally the partial gamma
push partgam wifeage job[freq=c], adj(child) table
partgam wifeage job[freq=c], adj(child) table
more
push partgam wifeage job[freq=c], adj(child) subtable
partgam wifeage job[freq=c], adj(child) subtable

push partgam wifeage job[freq=c], adj(child) subpct
partgam wifeage job[freq=c], adj(child) subpct

log close
