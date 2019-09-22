capture log off
set more off


/*   OUTLINE
I. File Operations

1) Merge 2 (or more) files that have different variables for the same individual (all files refer to the same year)
2) Convert a WIDE format longitudinal file to a LONG format
3) Append 2 files that data were collected from different years (periods) for the same individuals 

II. Preparing the data for Panel Analysis with: tsset 

III. Linear Panel Data Models
1) Pooled Estimator (OLS)
2) Fixed Effects Estimator
3) Random Effects Estimator

IV. Specification Tests
1) Fixed Effects vs Random Effects (Hausman Test)
2) Pooled vs Fixed Effects - F-Test (Chow Test) 
*/


/*
I1. Merge 2 files
We assume that you have 2 files in the folder that you store your DO-file
File names are : merge_a.dta and merge_b.dta
Both  files have a variable that uniquely identifies each individuals in the dataset
The idenfication variable is:  xid
*/

use "http://home.cc.umanitoba.ca/~oguzoglu/4130/oldstuff/mergexample_a",clear

merge xid using "http://home.cc.umanitoba.ca/~oguzoglu/4130/oldstuff/mergexample_b"
drop _merge

save merge_ab,replace

/*
I2. Reshape a Wide file 
Assume that you have a longitudinal file that you want to convert from WIDE to LONG format
File name: widepanel.dta
We also assume that we have a identification variable called xid
*/

use "http://home.cc.umanitoba.ca/~oguzoglu/4130/oldstuff/widepanel.dta",clear
reshape long  age sex inc work city baplus immig health, i(xid) j(year)
save longpanel.dta,replace

/*
I3.Append 2 files
We have 2 files data1.dta and data2.dta 
Both files contain same information except that data1 refers to 2001 and data2 refers to 2002
Both files have the xid variable
They also contain a variable called: year
*/

use "http://home.cc.umanitoba.ca/~oguzoglu/4130/oldstuff/data1.dta",clear
append using "http://home.cc.umanitoba.ca/~oguzoglu/4130/oldstuff/data2.dta"

save data_12.dta,replace

/*
II. Set up for Panel Data Analysis
Before any panel command is executed the data should be declared as a Panel
The file that we'll use, 4130macrodata.dta, contain longitudinal information about several countries
The ID variable is : code
Time variable is : year
*/

use "http://home.cc.umanitoba.ca/~oguzoglu/4130/oldstuff/4130Macrodata.dta"

*To set the data as a panel we type

xtset code year

/*
III. Linear Panel Data Models
Below we will run a simple growth regression 
growth=f(linitial, lsec)
where linitial=log(initial GDP) and lsec = log(average years of secondary schooling in population)
*/

gen linitial = log(initial)
gen lsec = log(sec)

*POOLED REGRESSION

reg growth lsec linitial

*Fixed Effects Regression

xtreg growth lsec linitial,fe

*Random Effects Regression

xtreg growth lsec linitial,re


/* IV. Hausman Specification Test */

xtreg growth lsec linitial,fe
est store fixed_effects

xtreg growth lsec linitial,re

est store random_effects

hausman fixed

/* BREUSH PAGAN LM TEST : RE VS POOLED OLS */
xttest0
