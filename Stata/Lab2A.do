
/* 
This Lab covers OLS and GLS for heteroskedasticity

visit the link below for a description of data
http://fmwww.bc.edu/ec-p/data/wooldridge/wage2.des
*/

clear
set mem 300m
set more off 

*Open data
use http://fmwww.bc.edu/ec-p/data/wooldridge/wage2.dta,clear

* Run a OLS regression of wage on educ age and IQ

regress wage age educ IQ 

* Save the residuals and fitted values

predict e,res

predict yhat

* Run a Breush Pagan Test of Heteroskedasticity

hettest

* Run a White's General Heteroskedasticity Test

estat imtest, white


* Run a OLS regression of wage on educ age educ IQ with heterosk robust standard errors

regress wage age educ IQ, rob

* Run OLS regression of wage on educ age IQ by weighting the model by IQ

regress wage age educ IQ [aw=IQ]

