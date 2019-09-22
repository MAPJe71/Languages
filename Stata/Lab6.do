/*****************************

Lab 6 : Basic Panel Data Models

The dataset that we will be usig 
contains longitudinal information abot indivuals labour market characteristics.
Further details can be found below
http://fmwww.bc.edu/ec-p/data/wooldridge/wagepan.des

******************************/

set more off


* prepare data for panel command
* we need an ID variable that identify separate individuals
* we also need a variable that describe time
* in this dataset we have nr (id variable) and year (time variable)

use http://fmwww.bc.edu/ec-p/data/wooldridge/WAGEPAN.dta,clear

xtset nr year

*** POOLED OLS ESTIMATION

reg lwage educ black hisp exper expersq married union

**** FE ESTIMATION 

xtreg lwage educ black hisp exper expersq married union,fe

**** RE ESTIMATION 

xtreg lwage educ black hisp exper expersq married union,re



**** MODEL SELECTION TESTS
*** we first have to re-estimate FE and RE model and "store" them
** first clear any previously stored estimates

est clear

** run the FE and RE models and store them under fixed_effects AND random_effects

xtreg lwage educ black hisp exper expersq married union,fe

est store fixed_effects

xtreg lwage educ black hisp exper expersq married union,re

est store random_effects

* HAUSMAN TEST : RE vs FE 

hausman fixed_effects

* LM test : RE vs POOLED OLS

xttest0




