use spillere, clear
tab period
keep if period == 2
for sex agegrp1 elite: tab @1 gruppe , chi row
for sex agegrp1 elite: tab @1 gruppe if sportn == 1, chi row
for sex agegrp1 elite: tab @1 gruppe if sportn == 2, chi row
for sex agegrp1 elite: tab @1 gruppe if sportn == 3, chi row
