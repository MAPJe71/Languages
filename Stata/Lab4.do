/* Lab 4 : Probit, Logit , LPM and Tobit Models

Aims: 
[1]Estimate the impact of education  and work experience
on the likelihood of participating in the labour force

[2] Estimate the impact impact of education  and work experience
on working hours

we will use a survey data on women's labour force outcomes
for the description of the variables in the dataset see 
http://fmwww.bc.edu/ec-p/data/wooldridge/mroz.des

*/
 
clear
set mem 300m
set more off 


* Open data

use "http://fmwww.bc.edu/ec-p/data/wooldridge/mroz.dta",clear

*
* NOTE Marginal Effects in this do-file are calculated using 
* an outdated command 'mfx'
* Check STATA help for the use of new 'margins' command
*


********** BINARY CHOICE MODEL OF LABOUR FORCE PARTICIPATION




* Linear Probability Model

reg inlf age educ exper expersq nwifeinc

* Probit Model

probit inlf age educ exper expersq nwifeinc

* marginal Effects

mfx

* Logit Model 

logit inlf age educ exper expersq nwifeinc


* marginal Effects

mfx

/* 

Likelihood Ratio Test 
 test Ho: Beta_exper = Beta_expersq = 0

 */
 
* First run the unrestricted model and store the results

probit inlf age educ exper expersq nwifeinc

store A

* now run the restricted model and store the results

probit inlf age educ nwifeinc

store B

* Run the LR test

lrtest A B


 
********** OLS AND TOBIT ESTIMATE OF HOURS WORKED

* OLS Estimation
reg hours age educ exper expersq nwifeinc

* Tobit Estimation

tobit hours age educ exper expersq nwifeinc,ll(0)

* Marginal effects

* Effect on expected value of observed dependent variable (E[y|y>0])
mfx compute, predict(e(0,.))

* Effect on non-negative portion of the latent variable (E[y*|y>0])

mfx compute, predict(ystar(0,.))
*log close
