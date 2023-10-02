clear all
clear
************answer 1************************************


**********Please run the codes one at a time. The tables from the results are compiled in the pdf file along with other answers.

global datadir "C:\Users\Administrator\Desktop\Econometrics\homework 4\Final exam\"

use "card1993.dta", clear


**************************Answer 1b*******************
*creating the age dummies
gen age14to15=0
replace age14to15 = 1 if age==24
replace age14to15 = 1 if age==25
sum age14to15


gen age16to17=0
replace age16to17=1 if age==26
replace age16to17=1 if age==27
sum age16to17


gen age18to20=0
replace age18to20=1 if age==28
replace age18to20=1 if age==29
replace age18to20=1 if age==30
sum age18to20

gen age21to24=0
replace age21to24=1 if age==31 
replace age21to24=1 if age==32 
replace age21to24=1 if age==33
replace age21to24=1 if age==34
sum age21to24

*summary table of SMSA to determine mean, standard deviation, minimum, maximum and number of observations.
sum smsa
*summary table of nearc4 (location near 4 year college) to determine mean, standard deviation, minimum, maximum and number of observations.
sum nearc4

*family str at age 14
* summary table  to determine mean, standard deviation, minimum, maximum and number of observation of living with mum and dad at 14
sum momdad14

* summary table  to determine mean, standard deviation, minimum, maximum and number of observation of living with mum only at age 14
sum sinmom14

*average parental education
* summary table  to determine mean, standard deviation, minimum, maximum and number of observation of mothers education
sum motheduc

* summary table  to determine mean, standard deviation, minimum, maximum and number of observation of father's education
sum fatheduc

** summary table  to determine mean, standard deviation, minimum, maximum and number of observation of black
sum black

** summary table  to determine mean, standard deviation, minimum, maximum and number of observation of average score on kww test
sum kww

* summary table  to determine mean, standard deviation, minimum, maximum and number of observation education
sum educ 

* summary table  to determine mean, standard deviation, minimum, maximum and number of observation of individuals living in south
sum south

* the compiled result of all the variables is shown in word file






*************************answer 1c***************************
clear
*using the data set for analysis
use "card1993.dta", clear

*determining the log of wage
gen lnwage=ln(wage)

*generating the square of experiences by: 
gen expersq= (exper^2)

*dividing the squares of experiences value by 100

gen expersq100=(exper^2 / 100)

*determining the square of ages
gen agesq=age^2

**A linear education term, a quadratic function of potential experience (age-education-6), a racial indicator, and dummies for residence in the South and a metropolitan area (SMSA) in 1976 are also included in all models.
* to determine the column 1 of table 2
*column1
reg lnwage educ exper expersq black south smsa 
estimates store a1
esttab a1

*Using the region and smsa66 variable to determine the log of wage estimator in addition to the model for column 1
*column2
reg lnwage educ exper expersq black south smsa region smsa66


*replacing the father's education and mother's education null values by zero to determine the combined effect for column 3
replace fatheduc=0 if fatheduc==.
replace motheduc=0 if motheduc==.

gen parenteduc= fatheduc+motheduc

*column3
reg lnwage educ exper expersq black south smsa region smsa66 parenteduc

*determining the parent education's interaction for column 4
gen parentinter=fatheduc*motheduc

*column4
reg lnwage educ exper expersq black south smsa region smsa66 parenteduc parentinter

* using the family structure at 14 years in addition to column 4 to determine column 5
*column5
gen famstr14=momdad14+sinmom14+step14

reg lnwage educ exper expersq black south smsa region smsa66 parenteduc parentinter famstr14





****************ANSWER 1e****************************
*The dependent variable in column 1 and 2 is completed education in 1976 and that in column 3 and 4 is log of wages in 1976.
*treat experience and experience squared as exogenous
*column a1
reg educ nearc4 exper expersq black south smsa region smsa66 
estimates store e1
esttab e1


*column a2
reg educ nearc4 exper expersq black south smsa region smsa66 parenteduc parentinter famstr14
estimates store e2
esttab e2


*column a3
reg lnwage nearc4 exper expersq black south smsa region smsa66 
estimates store e3
esttab e3


*column a4
reg lnwage nearc4 exper expersq black south smsa region smsa66 parenteduc parentinter famstr14
estimates store e4
esttab e4

*family interaction is the variables representing mothers and fathers education, indicators for missing fathers or mothers education interaction of mothers education, dummies for family structure at age 14

*treat experience and experience squared as endogenous
*column B1
ivreg educ nearc4 (exper expersq= age agesq) black south smsa region smsa66
estimates store e5
esttab e5


*column B2
ivreg educ nearc4 (exper expersq= age agesq) black south smsa region smsa66 momdad14 sinmom14  parenteduc parentinter famstr14
estimates store e6
esttab e6

*column B3
ivreg lnwage nearc4 (exper expersq= age agesq) black south smsa region smsa66
estimates store e7
esttab e7

*column B4
ivreg lnwage nearc4 (exper expersq= age agesq) black south smsa region smsa66 momdad14 sinmom14  parenteduc parentinter famstr14
estimates store e8
esttab e8





***************************ANSWER 1f*****************************



gen age14to15=0
replace age14to15 = 1 if age==24
replace age14to15 = 1 if age==25
sum age14to15

gen age16to17=0
replace age16to17=1 if age==26
replace age16to17=1 if age==27
sum age16to17


gen age18to20=0
replace age18to20=1 if age==28
replace age18to20=1 if age==29
replace age18to20=1 if age==30
sum age18to20

gen age21to24=0
replace age21to24=1 if age==31 
replace age21to24=1 if age==32 
replace age21to24=1 if age==33
replace age21to24=1 if age==34
sum age21to24





*Basic specification OLS estimate
reg lnwage educ nearc4 exper expersq black south smsa region smsa66 motheduc parenteduc parentinter famstr14
estimates store f1
esttab f1



*column B
*row1
ivreg lnwage (educ exper expersq= nearc4 age agesq) black south smsa region smsa66 momdad14 sinmom14  parenteduc parentinter famstr14
estimates store f6
esttab f6



drop if kww==.


*include kww test score (n=2963 with valid kww) OLS ESTIMATE
reg lnwage educ nearc4 exper expersq black south smsa region smsa66 motheduc parenteduc parentinter famstr14 kww
estimates store f2
esttab f2

*column B
*row2
ivreg lnwage (educ exper expersq= nearc4 age agesq) black south smsa region smsa66 momdad14 sinmom14  parenteduc parentinter famstr14 kww
estimates store f7
esttab f7

*include kww test score instrument kww with IQ  
reg lnwage educ kww nearc4 exper expersq black south smsa region smsa66 motheduc parenteduc parentinter famstr14 
estimates store f3
esttab f3


*column B
*row3
ivreg lnwage (educ exper expersq kww= nearc4 age agesq iq) black south smsa region smsa66 momdad14 sinmom14  parenteduc parentinter famstr14
estimates store f8
esttab f8

*use proximity to public college as instrument for education
reg lnwage educ nearc4 exper expersq black south smsa region smsa66 motheduc parenteduc parentinter famstr14
estimates store f4
esttab f4

ivreg lnwage (educ exper expersq kww= nearc4 nearc2 age agesq iq) black south smsa region smsa66 momdad14 sinmom14  parenteduc parentinter famstr14
estimates store f9
esttab f9


*use subsample age 14-19 in 1966
reg lnwage educ nearc4 exper expersq black south smsa region smsa66 motheduc parenteduc parentinter famstr14 age14to15 age16to17 age18to20
estimates store f5
esttab f5

ivreg lnwage (educ exper expersq kww= nearc4 nearc2 age agesq iq) black south smsa region smsa66 momdad14 sinmom14  parenteduc parentinter famstr14 age14to15 age16to17 age18to20
estimates store f10
esttab f10




