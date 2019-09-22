/***************************
Time Series Modelling Part 2
OBJECTIVES
-Dynamic Models
-ARMA & ARIMA
-ARCH(1) 
-GARCH(1,1)
*****************************/

log using time_series2_Lab.log,replace

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


tsset t //set the time variable


** Part B : Dynamic Models

*FDL of order 2

reg y x l.x l2.x


*RDL of order 1

reg y l.y x l.x


*** PART B ENDS ****


** PART C : ARIMA MODELS


*ARIMA(1,1,1) - y is differenced once, regression has 1 lag of y and has MA(1) 
*Note that an indipendent variable x can be added to the regression

arima y4 ,arima(1,1,1)

*ARIMA(0,1,0) - same as a simple AR(1) model 

arima y4, arima(1,0,0)

*ARIMA(0,0,1)  - same as a model with MA(1) only

arima y4, arima(0,0,1)

*ARIMA(1,0,1) - same as ARMA(1,1)
arima y4, arima(1,0,1)

*** PART C ENDS ****

** PART D : ARCH(1,1) AND GARCH(1,1)

*ARCH(1)
arch y4

*GARCH(1,1)

arch y4, arch(1) garch(1)


*** PART D ENDS *****

log close
exit
