* Example from stata course at London School of Trophical Medicine and Hygiene
* by J.Sterne

* for reference to meta analysis and an example see also:
* Normand SLT, Tutorial in Biostatistics: 
*      Meta Analysis: Formulating, evaluating, Combining and reporting. 
*      Statistics in Medicine 1999; 18: 321-359
*
* Meta analysis is much more than just making the graphs !!!
* 
set more on
use diuretic,clear
help diuretic
more
d
gen or=(pet/(nt-pet))/(pec/(nc-pec))
gen logor = log(or)
label var or "Odds ratio"
label var logor "Log odds ratio"
gen selogor=sqrt((1/pec)+(1/(nc-pec))+(1/pet)+(1/(nt-pet)))

gen ul=logor+1.96*selogor
gen ll=logor-1.96*selogor
sort or
gen n=_n
gra or ul ll trial, xlab ylab(-2,-1,0,1,2,3) t1("OR 95 cfi for diuretic studies")

more
metan nt nc pet pec, or chi2 label(namevar=trialid)
more
meta logor selogor,eform gr(f) cline xline(1) id(trialid) xlab var
more
meta logor selogor,eform gr(r) cline xline(1) id(trialid) xlab(0.05,0.5,1,5,10,15)
more

* Example 2. Magnesium and Myocardial Infarction:

use magnes, clear

* influence of individual studies:
* notice graph and point estimate with and without trial 16
metan pop1 deaths1 pop0  deaths0,  label(namevar=trialnam) saving(all,replace)
* first all data
more
metan pop1 deaths1 pop0  deaths0 if trial < 16, label(namevar=trialnam) saving(excl16,replace)
* second we exclude ISIS-4 trial 
more

* 
* funnel plot for publication bias:
*
metabias logrr selogrr ,graph(b) saving(allbias,replace) ylab(-4,-1.5,-1,0,1,1.5,4)
* Notice the asymmetrical plot

more
metabias logrr selogrr if trial < 16,graph(b) saving(biase16,replace) ylab(-4,-1.5,-1,0,1,1.5,4)
* Notice the asymmetrical plot

more
gra using all allbias excl16 biase16
*finally we plot both graphs simultaneuously.
more
gra using all excl16 allbias biase16

* try help meta                try:   help metan


