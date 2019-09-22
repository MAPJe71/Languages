/***************************
Time Series Modelling Part 1B 
OBJECTIVES
-to repeat Part 1A (see program Lab5.do) by using real data

- Data : quarterly data on 3-month and 6-month US T-Bills

see http://fmwww.bc.edu/ec-p/data/wooldridge/intqrt.des 
for a description of the variables
*****************************/

// Open Data 

use "http://fmwww.bc.edu/ec-p/data/wooldridge/intqrt.dta",clear


// the time variable is yq 
// it has a special form indicating quarterly data
//set dataset as time series

tsset yq

// Run an OLS regression of int rate of 6month Tbill on int rate of 3monthly bill

reg r6 r3


// create a trend variable

gen t = _n

* Include a trend into the model

reg r6 r3 t

* Detrending data

reg r6 t
predict detrend_r6, res
reg r3 t
predict detrend_r3, res

* Now run the model with detrended data

reg detrend_r6 detrend_r3

******************************************
******************************************


*****  Autocorr and PartAurocorr functions and Time Series Plots

*ACF
ac r6
ac r3


*PACF
pac r6
pac r3

** Line Plot of series against time

tsline r6 r3

******************************************
******************************************



*** DICKER FULLER TEST FOR UNIT ROOT
* test for Unit root of trending variable y1

dfuller r6, noconstant

* include drift
dfuller r6

* include a trend and drift 

dfuller r6, trend

* ADF statistics including lag of Deltay1

dfuller r6, lags(1)

******************************************
******************************************

*** Transforming Nonstationary Series

* first differencing :if r6 is I(1) than r6_t - r6_(t-1) is I(0)

gen dr6 = d.r6


*** PART E ENDS
