/***************************
Time Series Modelling Part 1
OBJECTIVES
-Example of Spurious regression
-Detrending and including trend
-Basic line graphs
-Autocorrelation and Partial Autocorrelation functions
-Dickey Fuller and Augmented Dickey Fuller test for Unit Root
- taking lags and differences of data
*****************************/

log using time_series_Lab.log,replace

/******* PART A. DATA GENERATION
Note: This part generates some data that
we will use in this program. If you have your own data 
you don't need this part.
*/
clear all
set obs 100

* Time trend
gen t=_n

* Random Errors
gen e=rnormal()
gen v=rnormal()

* Serially Correlated Errors
gen u=0
replace u=0.8*u[_n-1]+e in 2/100

*Trending Series
gen y=0.5*t+e
gen x=1+0.3*t+v

label var y "Trending Series"
label var x "Trending Series"

*AR(1) : Stationary
gen y1=0
replace y1=0.8*y1[_n-1]+e in 2/100
label var y1 "AR(1) Stationary"
*MA(1) : Stationary 
gen y4=0
replace y4=e - 0.8*e[_n-1] in 2/100
label var y4 "MA(1) Stationary"
*RANDOM WALK
gen y2=0
replace y2=y2[_n-1]+e in 2/100
label var y2 "Random Walk" 
*EXPLOSIVE SERIES
gen y3=0
replace y3=1.05*y3[_n-1]+e in 2/100
label var y3 "Explosive Series"
*Trend Stationaty
gen y5=0
replace y5=0.5*t+u
label var y5 "Trend Stationary"

* RANDOM WALK WITH A DRIFT
gen y6=0
replace y6=1+y6[_n-1]+e in 2/100
label var y6 "Random Walk w Drift" 
 
********PART A ENDS **************

** Part B : Example of Spurious Regressions & Detrending

tsset t //set the time variable


reg y x 

* Include a trend into the model

reg y x t

* Detrending

reg y t
predict detrend_y, res
reg x t
predict detrend_x, res

* Now run the model with detrended data

reg detrend_y detrend_x

*********** PART B ENDS *****************


***** PART C : Autocorr and PartAurocorr functions

*ACF
ac y
ac y1
ac y2

*PACF
pac y
pac y1
pac y2

** Line Plot of series against time

line y t 
line y1 t
line y2 t

**** PART C ENDS

*** PART D : DICKER FULLER TEST FOR UNIT ROOT
* test for Unit root of trending variable y1

dfuller y1, noconstant

* include drift
dfuller y1

* include a trend and drift 

dfuller y1, trend

* ADF statistics including lag of Deltay1

dfuller y1, lags(1)

**** PART D ENDS


*** PART E : Transforming Nonstationary Series

* first differencing the Random Walk y2

gen dy2 = d.y2

*** PART E ENDS

log close
