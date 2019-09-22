
/* We estimate a time series model, test for autocorrelation 
and run models to correct autcorrelation

The data is a state level trafic accidents data
visit http://fmwww.bc.edu/ec-p/data/wooldridge/traffic2.des
for a description of the variables

*/

clear
set mem 300m
set more off

use http://fmwww.bc.edu/ec-p/data/wooldridge/traffic2.dta,clear

* set up the data using the trend variable t

tsset t

* run OLS of prcfat on t, wkends, unem,spdlaw,beltlaw

reg prcfat t wkends unem spdlaw beltlaw

* Check if residual at t and residuals at t-1 are correlated

predict e,res

gen lage=l.e

corr e lage

* Run Durbin Watson test

dwstat 

***********Correct for Serial Correlation

* Prais_Winsten Regression

prais prcfat t wkends unem spdlaw beltlaw

* Cochran Orcutt Regression

prais prcfat t wkends unem spdlaw beltlaw, corc

* OLS with Autocorrelation Robust Standard errors

newey prcfat t wkends unem spdlaw beltlaw,lag(1)
