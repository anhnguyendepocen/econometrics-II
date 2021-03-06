* MMA06P2TWOSTAGE.DO March 2005 for Stata version 8.0
clear
capture log close 
log using mma06p2twostage.txt, text replace

********** OVERVIEW OF MMA06P2TWOSTAGE.DO **********

* STATA Program 
* copyright C 2005 by A. Colin Cameron and Pravin K. Trivedi 
* used for "Microeconometrics: Methods and Applications" 
* by A. Colin Cameron and Pravin K. Trivedi (2005)
* Cambridge University Press 

* NOTE: Stata does not have a NL2SLS command

* Chapter 6.5.4 nonlinear 2SLS example on pages 198-9.

* Table 6.4 partial only
*   (1) OLS        inconsistent
*   (2) NL2SLS     consistent    NOT INCLUDED AS STATA DOES NOT DO
*   (3) Twostage   Here 2SLS using Theil's interpretation of 2SLS is inconsistent

* To run this program you need data set
*           mma06p1nl2sls.asc
* generated by Limdep program MMA06P1NL2SLS.LIM

* Some of the analysis is done in Limdep which (unlike Stata) has 
* an NL2SLS command

********** SETUP ********** 

set more off
version 8.0

********** READ DATA and SUMMARIZE **********

* Model is  y = 1*x^2 + u
*           x = 1*z + v
* where  u and v are joint normal (0,0,1,1,0.8)

infile y x xsq z zsq u v using mma06p1nl2sls.asc

* Descriptive Statistics
describe
summarize

********** DO THE ANALYSIS: ESTIMATE MODELS **********

* (1) OLS is inconsistent (first column of Table 4.4)
regress y xsq, noconstant
estimates store olswrong
regress y xsq, noconstant robust
estimates store olswrongrob

* (2) NL2SLS command Stata does not have
*     See LIMDEP program MMA06P1NL2SLS.LIM
*     See also code further down

* (3A) Theil's 2sls where first regress x on z 
*      and then use xhat^2 as instrument for x^2 is inconsistent
 
regress x z, noconstant
predict xhat
gen xhatsq = xhat*xhat
regress y xhatsq, noconstant
estimates store twostage

********** DISPLAY KEY RESULTS Table 6.4 p.199 **********

* Table 4.4 p.199 first and third columns
estimates table olswrong twostage, b(%8.3f) se stats(N r2) keep(xsq xhatsq)

********** FURTHER ANALYSIS **********

* For this particular example there are ways to get linear IV to work
* as the problem is not very nonlinear

* (2A) regress xsq on z giving xsqhat and then regress y on xsqhat
*      Gives nl2sls estimator though not correct standard errors

* Note we get estimator 0.969 which is correct - Table 6.4 had typo
regress xsq z, noconstant
predict xsqhat
regress y xsqhat, noconstant

* (2B) IV with instrument z for xsq should work but Stata cannot do
*      for some reason due to here z = 1 which has no variation
ivreg y (xsq = z), noconstant 

********** CLOSE OUTPUT **********
log close
clear
exit

