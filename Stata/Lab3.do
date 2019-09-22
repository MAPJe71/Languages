
/* Lab 3 : Endogenety - IV / 2SLS and GMM Estmation

Data from Card(1996) 
Aim: Estimate the return on education  

for the description of the variables in the dataset see 
home.cc.umanitoba.ca/~oguzoglu/4130/card.pdf 

*/
 
clear
set mem 300m
set more off 

* Activate and modify line below if you want to save an output file

* log using regressionoutput.out,replace


* Open data

use "http://home.cc.umanitoba.ca/~oguzoglu/4130/card.dta",clear


* generate some new variables 

gen logwage=log(wage)
gen exper_sq=exper^2

* OLS regression

regress logwage educ exper exper_sq south black

* 2 SLS using father and mother education as instrument

ivregress 2sls logwage exper exper_sq south black (educ = fathereduc mothereduc)

* 2 SLS using father and mother education and proximity to college as instruments

ivregress 2sls logwage exper exper_sq south black (educ = fathereduc mothereduc nearc2 nearc4)

* TESTS

* significance of instruments
estat firststage

* test of overidentification 
estat overid 

* test for endogeneity of all variables 

estat endogenous 

* GMM using the same instrument set 

ivregress gmm logwage exper exper_sq south black (educ = fathereduc mothereduc nearc2 nearc4)

