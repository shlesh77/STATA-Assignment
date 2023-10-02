global datadir "\\bfs.coba.unr.edu\studenthome\bpaudyal\Downloads\741\"

global savedir "\\bfs.coba.unr.edu\studenthome\bpaudyal\Downloads\741\"

*generating X and U following normal distributions with mean 0 and variance 1  and n=10000
set seed 1 
clear 
set obs 10000

gen X = rnormal()
gen U = rnormal()
*generating Y variable such that Y=-10X+3.5U

gen Y=-10*X+3.5*U


*plotting the Y and X scatter along with the line of best fit

twoway (lfit Y X, lcolor(yellow) lwidth(thin)) (scatter Y X, mcolor(blue) msize(small) msymbol(circle)), title(OLS Regression Line) 

cd "$savedir" 

graph export Simulation1.gph, as(png) replace

*Regression of Y on X 
reg Y X 

predict Uhat1, residual
predict Yhat1

*plotting the residuals graph 
rvfplot, yline(0)

*showing expected uhat1 =0 and and expected (X*uhat=0)
mean Uhat1
gen X_uhat = X*Uhat1
label var X_uhat "X and Uhat"
mean X_uhat

*since the mean values of both Uhat and X*uhat is zero from the tabe, the expectation of these two variables is also zero. i.e.E(uhat) = 0 and E(X*uhat) = 0.

*reporting the t-stat

*ANSWER 6

clear 
global workdir"\\bfs.coba.unr.edu\studenthome\bpaudyal\Downloads\741\"
cap log close
cd "$workdir"

*opening the log file to store results
use "$workdir\homework2data.dta", clear

log using homework2.log,replace

*Plotting the histogram of variable 'biofbmi'
histogram biofbmi, title(Histogram for biofbmi) xtitle(Body Mass Index) ytitle(frequency) name(a, replace ) 

*plotting the Kernel density of variable 'biofbmi'
kdensity biofbmi, title(Kernel Density for biofbmi) xtitle(Body Mass Index) ytitle(frequency) name(b, replace ) 

*The graph shows that the variable is sekwed to one end i.e the variable 'biofbmi' has outliners in its data.

*Combining the histogram and kernel density graph
graph combine a b, cols(2) 

replace biofbmi=. if biofbmi==9998
drop if biofbmi==.

ssc install estout
estpost sum biofbmi age evermarried wealthq total_child urban educlvl ethnicityia atefriedfq dranksodafq
esttab , cells("count mean(fmt(a2)) sd(fmt(a2)) min(fmt(a1)) max(fmt(a3))") noobs
esttab using "SummaryStats.doc", cells("count mean(fmt(a2)) sd(fmt(a2)) min(fmt(a1)) max(fmt(a3))") noobs replace 

tab biofbmi
 
tab age

*creating histogram for age
histogram  age, title(Histogram of Age) xtitle(age) ytitle(frequency)

sum age

* the min value for age is 15 and the maximum value is 49.


*creating dummy variable that takes value 1 for respective wealth quintile

gen Poorest=0
replace Poorest  = 1 if wealthq==1

gen Poorer=0
replace Poorer  = 1 if wealthq==2

gen Middle=0
replace Middle = 1 if wealthq==3

gen Richer=0
replace Richer = 1 if wealthq==4

gen Richest=0
replace Richest = 1 if wealthq==5

*generating variable that interacts age and wealth quintile

gen age_wealthq = age*wealthq

*generating variable that interacts urban status and wealth quintile

gen urban_wealthq = urban*wealthq

*t test
estpost ttest biofbmi, by(urban)
esttab, wide nonumber mtitle("difference")
esttab using ttest_bmi_urban.doc, wide nonumber mtitle("difference") replace

*generating t test for y variables across whether people drink soda or not

gen drink_soda=0
replace drink_soda = 1 if dranksodafq>0

*t test
ttest biofbmi, by(drink_soda) 
esttab, wide nonumber mtitle("difference") 
esttab using ttest2.doc, wide nonumber mtitle("difference") replace

*
reg biofbmi age evermarried Poorest Poorer Middle Richer Richest total_child urban educlvl ethnicityia atefriedfq dranksodafq age_w urban_w , vce(robust)
estimates store REG2
esttab REG2, b(%9.4f) se stats(N r2 F ll) replace 

*Checking joint significance using F-test
testparm urban currwork atefriedfq dranksodafq biofbmi

*Ploting the residuals of the model 
rvfplot







