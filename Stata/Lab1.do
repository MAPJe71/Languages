
* This is a comment 
* Comments are not executed by Stata
* programmers use them to put reminders for themselves
* Note the '*' at the beginning of each line
// This is another way to put inline comments

/* 

This is a  block comment.
Everything between /* and */ will not be executed by STATA.

*/


* Next 3 lines are standard. Put them beginnning of all of your do-files
 
clear
set mem 300m // allocating memory
set more off  // option to run the entire do-file in one shot


* STATA can open local files as well as
* Data that is stored in webpages

* Try following:

use "http://fmwww.bc.edu/ec-p/data/wooldridge/wage2.dta" ,clear

/*
You can  see the definition of the variables in this dataset by visiting
http://fmwww.bc.edu/ec-p/data/wooldridge/wage2.des
*/


* BASIC DATA MANIPULATION

* rename command (OR ren for short)

rename sibs numsibs

* generate (or gen for short)

* Generate an age square variable

gen age2 = age^2

* Remove  the 'lwage' variable from the data

drop lwage

* CREATING DUMMY VARIABLES

* Create a dummy variable for people that has IQ>100

generate smart =0
replace smart =1 if IQ>100

* DATA AND VALUE LABELS

* Variable Label
label var smart "IQ more than 100"

* Value Label

label define smartlabel 0 "NotSmart" 1 "Smart"
label val smart smartlabel

*Create a log(wage) variable

generate lwage=log(wage)

* Obtain basic summary statistics about IQ and age

summarize IQ age // Try adding  ,det option to this command


* You can tabulate categorical variables as follows

tab married

* Cross tabulate 2 categorical variables

tab married smart


* Create a Histogram using IQ variable

hist IQ

* Create a scatter diagram using wage and IQ

scatter wage IQ

* RUNNING COMMANDS FOR A SUBSAMPLE

* Calculate summary statistics of wage and age for married people only

summarize wage age if married == 1 // note the double equal sign

* Run a OLS regression of wage on education, age and age square and IQ

regress wage age age2 educ IQ

* Run a OLS regression of wage on educ age age2 for only smart people

regress wage age age2 educ IQ if smart == 1


/*
It is a good practice to never over-write the raw data file
If you make data manipulation save it as a different file
Save the data file in folder C:\testfolder and name it test.dta
You have to change the folder according thefolder structure in your computer 
Note that there is a '*' in front in the command line below. You have to remove the * if you want STATA to execute that line
*/

*save C:\testfolder\test.dta, replace


