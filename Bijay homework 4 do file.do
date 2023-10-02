

clear

global datadir "C:\Users\Administrator\Desktop\Econometrics\homework 4\"

ssc install bcuse

bcuse card.dta


*creating a logarithmatic function of wage
sum wage, det
gen lnwage= ln(wage)
label var lnwage "log of wage"
sum lnwage, det

*Model 1: Running a regression of log earnings on years of education.
reg lnwage educ

*****report and interpret the result
*The result shows that the coefficient of education, i.e. 0.52, explains that log of wage is (5.57+0.52 times education level). Also, the p value at 95 percent of confidence level is less than 0.05, so, the education has significant impact on wage level.
*Also, we can see from the table that R square value is 0.987 which explains that only 9.87 percent of variation in wage is explained by the dependent variable education i.e. out of 592.64 sum of square values, only 58.51 values are explained by the variable education in the dependent variable lnwage.


**In this regression, the potential variable that is correlated with earnings might be age, experience, gender, IQ, place of stay, health status etc.

* Model 2: Repeating Model 1 adding a control for IQ
reg lnwage educ IQ


 ****showing the results and discuss how the results have changed in the context of omitted variables bias*********
 *After including one of the omitted variable i.e IQ in the model, the coefficient of education in the regression equation has decreased from 0.52 to 0.26. Also, in other words, the log value of  wage is equal to (5.58+ 0.0263*education + 0.00379*IQ)
 *The probability value for both the education and IQ is less than 0.05 at 95% level of confidence showing that both of them have significant effect on wage level.
 
 ****** Model 3: Repeat Model 1 using "ivreg" in Stata using nearc4 as thee IV.
 ivreg lnwage educ
 ivregress 2sls lnwage (educ=nearc4), vce(robust)
 
 *the coefficient of education is increased from 0.052 to 0.188 after including the impact of IV in wage through education. Also, the P value is extremely small showing that the impact of IV in wage through education has significant impact.
 
****why this might be a good instrument for a missing value?
 *this might be a good instrument for a missing variable because it shows a significant impact on wage level through education. and it can be clearly seen in the regression table that IV has significant impact in wage level indirectly through education.
 
 *****Interpret your results and state what this tells you about bias in your initial regression
 *The initial regression although shows the significant impact of education in wage but we can confirm that R square value is 0.987 which explains that only 9.87 percent of variation in wage is explained by the dependent variable education i.e. out of 592.64 sum of square values, only 58.51 values are explained by the variable education in the dependent variable lnwage. 
 
****Is your instrument relevant? Why or why not?

*Yes, the IV is relevent as the coefficient of education is increased from 0.052 to 0.188 after including the impact of IV in wage through education. We can conclude it by following: 
*checking whether education is really a endogenous variable or not
 estat endog
 
 *Since the p value for both robust score statistics and robust regression statistic is extremely small, which explains that the null hypothesis of treating the variable exogenous is rejected and is endogenous.
 
****Is your instrument valid? Why or why not?
estat firststage, all forcenonrobust

* as the f-statistic value is 60.37, which is larger than any significance level in the result table, which allows us to reject the null hypothesis that instrument is weak. Hence the results shows that IV is both relevant and valid.

***Discuss your results in the context of a local average treatment effect.



****Discuss your results in the context of a weak instrument. Explain in which way you think the variable might be correlated with the unobservables, and what this says about bounds that you can put on the true β.
estat firststage, all forcenonrobust

* as the f-statistic value is 60.37, which is larger than any significance level in the result table, which allows us to reject the null hypothesis that instrument is weak. Hence the results shows that IV is both relevant and valid.

****Now add 2 new instruments - mother's education and father's education as instruments to Model. Do you think these instruments are useful or not?
ivregress 2sls lwage ( educ = fatheduc ), vce(robust) 
ivregress 2sls lwage ( educ = motheduc ), vce(robust)
 **the coefficient of education is increased from 0.052 to 0.068 after including the impact of IV (father's education) in wage through education. Also, the P value is extremely small showing that the impact of IV in wage through education has significant impact.
*Simultaneously, for the IV (mother's education), the coefficient of education is increased from 0.052 to 0.080 showing that the impact of IV in wage level due to mothers education through education. Here, the P value is less than that at 95 % confidence level, hence shows significant impact.
 
 
*************ANSWER 4**************

clear

ssc install winsor
ssc install winsor2

clear all
clear

global datadir "C:\Users\Administrator\Desktop\Econometrics\homework 4\"

use "Homework2Data.dta", clear

***Create a BMI variable that is biofbmi/100 . Remove all invalid values (90 and above) and missing values. Winsorize the top 1% of the data to the highest value.

gen BMI = (biofbmi/100)

drop if BMI==.

drop if BMI>=90

winsor BMI, p(.01) gen(BMI_1)

*Generate a variable obesity that takes a value of 1 is BMI≥25. Summarize this variable and discuss the mean and standard deviation

gen obesity=1 if BMI>=25

replace obesity=0 if obesity ==.

sum obesity

*from the summary table, we can see that the the mean of the variable obisity is 1.958 and standard deviation of 0.3968.

 *****Createing 5 dummy variables that take values 1 for a respective wealth quintiles.
gen Poorest=0
replace Poorest = 1 if wealthq==1

gen Poorer=0
replace Poorer = 1 if wealthq==2

gen Middle=0
replace Middle = 1 if wealthq==3

gen Richer=0
replace Richer = 1 if wealthq==4

gen Richest=0
replace Richest = 1 if wealthq==5

***Creating a dummy variable that takes a value of 1 if the person lives in an urban area
. gen liv_urban = 1 if urban==1

****Creating a dummy variables that take a value of 1 if the person reports a very high frequency of eating fried foods -
gen high_atefried = 1 if atefriedfq==3


****Create a dummy variables that take a value of 1 if the person reports a very high frequency of drinking soda

gen high_drinking = 1 if dranksodafq==3

global xlist age wealthq total_child Poorest Poorer Middle Richer Richest liv_urban educlvl high_atefried high_drinking

regress obesity age high_atefried high_drinking Poorest Poorer Middle Richer Richest liv_urban total_child sample educlvl

logit obesity age high_atefried high_drinking Poorest Poorer Middle Richer Richest liv_urban total_child sample educlvl

probit obesity age high_atefried high_drinking Poorest Poorer Middle Richer Richest liv_urban total_child sample educlvl

*Running the regression above post your results using the logit (Model 1), probit (Model 2) and LPM models (Model 3)
*model 1
logit obesity $xlist, vce(robust)
outreg2 using Model, se bdec(3) ctitle("Model 1") word append

*model 2
probit obesity $xlist, vce(robust)
outreg2 using Model, se bdec(3) ctitle("Model 2") word append

*model 3
reg obesity $xlist, vce(robust)
outreg2 using Model, se bdec(3) ctitle("Model 3") word append


*Are the variables jointly significant or not in each of these models?
*Yes, the variables are jointly significant in each of these models. and can be seen from the table at the end of the homework page