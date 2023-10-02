clear all
clear

global datadir "C:\Users\Administrator\Desktop\Econometrics\homework 4\"

use "Homework2Data.dta", clear


gen age14to15=0
replace age14to15 = 1 if age==24
replace age14to15 = 1 if age==25


gen age16to17=0
replace age16to17=1 if age==26
replace age16to17=1 if age==27

gen age18to20=0
replace age18to20=1 if age==28

replace age18to20=1 if age==29
replace age18to20=1 if age==30

gen age21to24=0
replace age21to24=1 if age==31 
replace age21to24=1 if age==32 
replace age21to24=1 if age==33
replace age21to24=1 if age==34

