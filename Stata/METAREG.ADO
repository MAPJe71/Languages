*! version 1.06 copyright Stephen Sharp January 1998

program define metareg
	
version 5.0
local varlist "req ex min(1)"
local if "opt"
local in "opt"
local options "WSSe(string) WSVar(string) BSest(string) TOLeran(integer 4) Level(integer $S_level)"
local options "`options' NOITer"

parse "`*'"
if "`wsse'"=="" & "`wsvar'"=="" {
	di in re "Must specify a variable containing estimate of precision"
	di in re "within each trial, using either wsse() or wsvar() option"
	exit 198
}
if "`wsse'"~="" & "`wsvar'"~=""{
	confirm variable `wsse'
	confirm variable `wsvar'
	local i=1
	while `i'<=_N {
		if abs(`wsse[`i']'^2-`wsvar[`i']')>0.00001 {
			di in re "Within study variance should be square of within study standard error"
			exit 198
		}
	local i=`i'+1
	}
}
if "`wsvar'"~="" {
	confirm variable `wsvar'
}	
if "`wsse'"~="" {
	confirm variable `wsse'
	tempvar wsvar
	qui gen `wsvar'=`wsse'^2
}	
if "`bsest'"=="" {
	local bsest "reml"
}
if "`bsest'"~="reml" & "`bsest'"~="ml" & "`bsest'"~="eb" & "`bsest'"~="mm" & "`bsest'"~="" {
	di in re "Between study variance estimation method invalid:"
	di in re "should be either reml, ml, eb or mm"
	exit 198
}
if "`noiter'"~="" & "`bsest'"=="mm" {
	di in bl "Warning: mm is a non-iterative method, noiter option ignored"
}	
parse "`varlist'", parse(" ")

local y "`1'"
mac shift
local xvars "`*'"

tempvar touse
preserve
qui {
	mark `touse' `if' `in'
	markout `touse' `y' `xvars'
	keep if `touse'
}

qui regress `y' `xvars'
local p=_result(3)
local N=_result(1)

if "`bsest'"=="mm" {
	tempvar wt ypred numi one
	qui {
		gen `wt'=`wsvar'^-1
		regress `y' `xvars' [aw=`wt']
		predict `ypred'
		gen `one'=1
		tempname X C Xt C1 XtC1 A A1 A1XtC1 C1X B
		mkmat `one' `xvars', matrix(`X')
		matrix `C'=J(`N',`N',0)
		local i=1
		while `i'<=_N {
			matrix `C'[`i',`i']=`wsvar'[`i']
			local i=`i'+1
		}
		mat `Xt'=`X''
		mat `C1'=inv(`C')
		mat `XtC1'=`Xt'*`C1'
		mat `A'=`XtC1'*`X'
		mat `A1'=inv(`A')
		mat `A1XtC1'=`A1'*`XtC1'
		mat `C1X'=`C1'*`X'
		mat `B'=`C1X'*`A1XtC1'
		local trB=trace(`B')
		summ `wt'
		local denom=_result(18)-`trB'
		gen `numi'=`wt'*((`y'-`ypred')^2)
		summ `numi'
		local num=max(_result(18)-(`N'-(`p'+1)),0)
		local newtsq=`num'/`denom'
	}	
}

if "`bsest'"~="mm" {

	local tsq=0.1
	local newtsq=0
	local j=1

	while abs(`tsq'-`newtsq')>=10^(-`toleran') {
		tempvar wt ypred wtsq numi 
		local tsq=`newtsq'
		if "`noiter'"=="" {
			di in gr  "Iteration " `j' ": tau^2 = " in ye `tsq'
		}
		qui {
			gen `wt'=(`wsvar'+`tsq')^-1
			regress `y' `xvars' [aw=`wt']
			predict `ypred'
			gen `wtsq'=`wt'^2
		}
		if "`bsest'"=="reml" {
			qui {
				gen `numi'=(`wtsq')*(((`N'/(`N'-(`p'+1)))*((`y'-`ypred')^2))-`wsvar')
				summ `numi'
				local num=max(_result(18),0)
				summ `wtsq'
				local denom=_result(18)
				local newtsq=`num'/`denom'
			}
		}

		if "`bsest'"=="ml" {
			qui {
				gen `numi'=(`wtsq')*(((`y'-`ypred')^2)-`wsvar')
				summ `numi'
				local num=max(_result(18),0)
				summ `wtsq'
				local denom=_result(18)
				local newtsq=`num'/`denom'
			}
		}

		if "`bsest'"=="eb" {
			qui {
				gen `numi'=(`wt')*(((`N'/(`N'-(`p'+1)))*((`y'-`ypred')^2))-`wsvar')
				summ `numi'
				local num=max(_result(18),0)
				summ `wt'
				local denom=_result(18)
				local newtsq=`num'/`denom'
			}
		}

	local j=`j'+1

	}
}

tempvar wt
qui {
gen `wt'=(`wsvar'+`newtsq')^-1
summ `wt'
}
local sumwt=_result(18)

#delimit ;
di _n
	in gr "Meta-analysis regression"
		_col(56) "No of studies =   " in ye  `N' _n
		in gr _col(56) "tau^2 method      " in ye "`bsest'" _n
		in gr _col(56) "tau^2 estimate = "  in ye %6.5g `newtsq' _n ; 
	#delimit cr
if "`bsest'"=="ml" | "`bsest'"=="reml" |  "`bsest'"=="eb" {
	di in bl "Successive values of tau^2 differ by less than 10^-"`toleran' " :convergence achieved"
}

qui regress `y' `xvars' [aw=`wt']

local scpar=(`sumwt'*(_result(9)^2))/_result(1)
local scpar1=(1/`scpar')

matrix V=get(VCE)
matrix b=get(_b)

matrix v=`scpar1'*V


mat post b v
mat mlout, level(`level')

     global S_1 = `N'
     global S_2 = `newtsq'

restore

end

