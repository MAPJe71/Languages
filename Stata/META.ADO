*! version 2.06 jacs/sjs March 1998  

program define meta
version 5.0

local varlist "req ex min(2) max(4)"
local if "opt"
local in "opt"
local options "EForm ID(string) Level(integer $S_level) PRint EBayes"
local options "`options' GRaph(string) YLABel(string) XLOG"
local options "`options' Var CI STLevel(integer $S_level)"
local options "`options' Symbol(string) FMult(real 1)  BOXYsca(real 1)"
local options "`options' BOXSHad(integer 0) CLine YTick GAP"
local options "`options' LTRunc(string) RTRunc(string) *"

parse "`*'"

if "`id'"~="" {
	confirm string variable `id'
}
if "`var'"~=""&"`ci'"~="" {
	di in re "Do not use the var option and the ci option at the same time"
	exit 198
}
if "`graph'"~="" {
	capture assert "`graph'"=="r" | "`graph'"=="f" | "`graph'"=="e"
	if _rc~=0 {
		di in re "Must specify graph(f) or graph(r) or graph(e)"
		exit 198
	}
       	if "`graph'"=="e" {
		local ebayes "ebayes"
		local print "print"
	}
}
if "`ylabel'"~="" {
	di in re "ylabel option not permitted"
	exit 198
}
if "`xlog'"~="" {
	di in re "xlog option not permitted (use eform option)"
	exit 198
}
if "`symbol'"~="" {
	di in re "symbol option not permitted"
	exit 198
}
if "`ytick'"~="" {
	di in re "ytick option not permitted"
	exit 198
}
if "`gap'"~="" {
	di in re "gap option not permitted"
	exit 198
}
if "`fmult'"~="" {
	capture assert `fmult'>0
	if _rc~=0 {
         	di in re "Label font scaling factor must be >0"
         	exit 198
       	}
      	local fmult "fmult(`fmult')"
}
if "`boxysca'"~="" {
	capture assert `boxysca'<=1 & `boxysca'>0
       	if _rc~=0 {
         	di in re "Y scaling factor for box must be between 0 and 1"
         	exit 198
       	}
	local boxysca "boxysca(`boxysca')"
}
if "`boxshad'"~="" {
	capture assert `boxshad'<=4 & `boxshad'>=0
     	if _rc~=0 {
        	 di in re "Box shading must be between 0 and 4"
        	 exit 198
       	}
       	local boxshad "boxshad(`boxshad')"
}

capture assert `level'<=99 & `level'>=10
if _rc~=0 {
       	 di in re "CI level must be between 10 and 99"
       	 exit 198
}
capture assert `stlevel'<=99 & `stlevel'>=10
if _rc~=0 {
      	 di in re "Study graph CI level must be between 10 and 99"
       	 exit 198
}

tempvar touse w wpsi qi w2 wstar wstarps v zz
tempname sumwpsi sumw sumw2 cappsi rcappsi lc uc rlc ruc Q k tausq vareb seeb
tempname swstar swstarp  rt ft slab

parse "`varlist'", parse(" ")
local psi1 `1'
local se1 `2'
tempvar psi se
qui gen `psi'=`psi1'
qui gen `se'=`se1'

capture assert `se'>0
if _rc~=0 {
	di in re "Standard error/variance/confidence limit must be>0 or missing for all studies"
       	exit 198
}
if "`ci'" != "ci" & "`3'" != "" {
     di _n in bl "Warning: varlist has 3 variables but option 'ci' not specified; 'ci' assumed."
     local ci "ci"
     local var ""
}
quietly {
	mark `touse' `if' `in'
       	markout `touse' `psi' `se'
       	if "`3'"~="" {
         	markout `touse' `3'
       	}
}
if "`var'" == "var" {
	qui replace `se'=sqrt(`se') if `touse'
}
if "`ci'" == "ci" {
	capture confirm variable `4'
        if _rc~=0 {
		qui gen `zz'  = invnorm(.975)
	}
        else {
		qui replace `4' = `4' * 100 if `4' < 1
            	qui gen `zz' = -1 * invnorm((1- `4' / 100) / 2 )
            	qui replace `zz' = invnorm(.025) if `zz'==.
		}
        qui replace `se' = ( ln(`3') - ln(`2')) / 2 / `zz' if `touse'
        qui replace `psi'   = ln(`psi') if `touse'
}
qui gen `v'=`se'^2 if `touse'


* FIXED EFFECTS
qui {
	gen `w'=1/`v' if `touse'
	gen `wpsi'=`w'*`psi' if `touse'
	summ `wpsi'
	scalar def `sumwpsi'=_result(3)*_result(1)
     	local k=_result(1)
     	summ `w'
     	scalar def `sumw'=_result(3)*_result(1)

	scalar def `cappsi'=`sumwpsi'/`sumw'
	scalar def `lc'=`cappsi'-invnorm(`level'*0.005 + 0.5)*(`sumw'^(-0.5))
	scalar def `uc'=`cappsi'+invnorm(`level'*0.005 + 0.5)*(`sumw'^(-0.5))
	scalar def `ft'=`cappsi'/(`sumw'^(-0.5))     
}

* RANDOM EFFECTS
qui {
	gen `qi'=`w'*((`psi'-`cappsi')^2) if `touse'
     	summ `qi'
     	scalar def `Q'=_result(3)*_result(1)
     	gen `w2'=`w'^2 if `touse'
     	summ `w2'
     	scalar def `sumw2'=_result(3)*_result(1)
     	scalar def `tausq'=max(0,(`Q'-(`k'-1))/(`sumw'-(`sumw2'/`sumw')))
     	gen `wstar'=(`v'+`tausq')^(-1) if `touse'
     	gen `wstarps'=`wstar'*`psi' if `touse'
     	summ `wstarps'
     	scalar def `swstarp'=_result(3)*_result(1)
     	summ `wstar'
     	scalar def `swstar'=_result(3)*_result(1)
	scalar def `rcappsi'=`swstarp'/`swstar'
     	scalar def `rlc'=`rcappsi'-invnorm(`level'*0.005 + 0.5)*((`swstar')^(-0.5))
     	scalar def `ruc'=`rcappsi'+invnorm(`level'*0.005 + 0.5)*((`swstar')^(-0.5))
     	scalar def `rt'=`rcappsi'/((`swstar')^(-0.5))
     	if "`eform'"~="" {
		scalar define `cappsi'=exp(`cappsi')
           	scalar define `lc'=exp(`lc')
           	scalar define `uc'=exp(`uc')
           	scalar define `rcappsi'=exp(`rcappsi')
           	scalar define `rlc'=exp(`rlc')
           	scalar define `ruc'=exp(`ruc')
           	local ef=" (exponential form)"
           	local efu="-------------------"
	}
}

tempvar Est Lower Upper z_value p_value

scalar `p_value'=2*min((1-normprob(`ft')),normprob(`ft'))
di in gr _n "Meta-analysis `ef'" _n
di in gr "       |  Pooled      `level'% CI         Asymptotic      No. of"
di in gr "Method |     Est   Lower   Upper  z_value  p_value   studies"
di in gr "-------+----------------------------------------------------"
di in gr "Fixed  |" in ye %8.3f `cappsi' %8.3f `lc' %8.3f `uc' %9.3f `ft' %9.3f `p_value' %7.0f `k'
scalar `p_value'=2*min((1-normprob(`rt')),normprob(`rt'))
di in gr "Random |" in ye %8.3f `rcappsi' %8.3f `rlc' %8.3f `ruc' %9.3f `rt' %9.3f `p_value'

di in gr _n "Test for heterogeneity: Q= " in ye %6.3f /*
*/ `Q' in gr " on " in ye (`k'-1) in gr " degrees of freedom (p=" /*
*/ in ye %6.3f chiprob(`k'-1,`Q') in gr ")"
di in gr  "Moment-based estimate of between studies variance = " in ye %6.3f /*
*/ `tausq'


if "`print'"~="" {
	if "`ebayes'"~="" & `tausq'~=0 {
       		di in ye _n"Note: estimates and confidence limits are empirical Bayes"
       	}
     	if "`ebayes'"~="" & `tausq'==0 {
       		di in ye _n"Note: between studies variance is 0, so empirical Bayes estimates "
       		di in ye "cannot be calculated - estimates and confidence limits reported are "
       		di in ye "calculated from the data"
       	}
   
	tempvar Fixed Random
     
     	qui {
		gen `Fixed'=`w' if `touse'
     		gen `Random'=`wstar' if `touse'
	}

	if "`ebayes'"~="" & `tausq'~=0{
       	if "`eform'"~="" {
        	scalar define `rcappsi'=log(`rcappsi')
       	}  
     qui {
		gen `Est'=(`psi'/(`v') + `rcappsi'/`tausq') / (1/(`v') + 1/`tausq') if `touse'
        	gen `vareb'=(`tausq'*`v')/(`tausq'+`v')+((`v'/(`tausq'+`v'))^2)/`swstar' if `touse'
        	gen `seeb'=sqrt(`vareb') if `touse'
        	gen `Lower'=`Est'-invnorm(`level'*0.005 + 0.5)*sqrt(`vareb') if `touse'       
 		gen `Upper'=`Est'+invnorm(`level'*0.005 + 0.5)*sqrt(`vareb') if `touse'
	}
       	if "`eform'"~="" { scalar define `rcappsi'=exp(`rcappsi') }  
	}

	if "`ebayes'"=="" | ("`ebayes'"~="" & `tausq'==0) {
	qui {
		gen `Est'=`psi' if `touse'
     	gen `Lower'=`psi'- invnorm(`level'*0.005 + 0.5)*(`v'^(0.5)) if `touse'
      	gen `Upper'=`psi'+ invnorm(`level'*0.005 + 0.5)*(`v'^(0.5)) if `touse'
     }
	}
if "`eform'"~="" {
	qui {
		replace `Est'=exp(`Est') if `touse'
     	 	replace `Lower'=exp(`Lower') if `touse'
      		replace `Upper'=exp(`Upper') if `touse'
	}
}
else {}
     
format `Fixed' `Random' `Est' `Lower' `Upper' %6.2f
 
tempvar Study
     
if "`id'"~="" {
	local sf: format `id'
       	local sf = substr("`sf'", 2, length("`sf'")-2)
       	local sn = max(int(real("`sf'")),5)
       	qui gen str`sf' `Study'=`id' if `touse'
}
else {
	local sn 5
       	qui gen str5 `Study'=string(_n) if `touse'
}

* do header of tabled study output
    
local sp = `sn' - 5
di
di in gr    _skip(`sp') "      |      Weights      Study       `stlevel'% CI"
di in gr    _skip(`sp') "Study |   Fixed  Random     Est   Lower   Upper"
di in gr _dup(`sp') "-" "------+----------------------------------------"

* in while loop, display body of table

local i 1
while `i' <= _N {
if `touse'[`i'] {
  local sp = `sn' - length(`Study'[`i'])
  di in gr _skip(`sp') `Study'[`i'] " |" in ye %8.2f `Fixed'[`i'] _c
  di in ye %8.2f `Random'[`i'] %8.2f `Est'[`i'] %8.2f `Lower'[`i'] %8.2f `Upper'[`i']
}
  local i = `i' + 1

  }
}
    
     if "`id'"~="" {
       local id "id(`id')"
     }

     if "`graph'"=="r" | "`graph'"=="e" {
       local cappsi=`rcappsi'
       local lc=`rlc'
       local uc=`ruc'
     }

     if "`graph'"~="" {

	preserve

      qui keep if `touse'
 
       if "`ltrunc'"~="" {
         local ltrunc "ltrunc(`ltrunc')"
       }
       if "`rtrunc'"~="" {
         local rtrunc "rtrunc(`rtrunc')"
       }
       if "`graph'"~="e" {
         metagrph `psi1' `v', `id' cappsi(`cappsi') poollc(`lc') pooluc(`uc') /*
         */ `eform' `fmult' `boxysca' `boxshad' `cline' `ltrunc' `rtrunc' /*
         */ stlevel(`stlevel')  /*
         	*/  `ci' `options'

       }




       if "`graph'"=="e" {
        if `tausq'==0 {
         di in re "Note: between studies variance is 0, so cannot calculate empirical Bayes estimates"
        }
        else {
          if "`eform'"~="" {
            qui replace `Est'=log(`Est')
          }
          local xvarlab : variable label `psi'
          if "`xvarlab'"~="" {
            label var `Est' "`xvarlab' (Empirical Bayes)"
          }
          else {
            label var `Est' "Empirical Bayes estimate"
          } 
          metagrph `Est' `vareb', `id' cappsi(`cappsi') poollc(`lc') /*
          */ pooluc(`uc') `eform' `fmult' `boxysca' `boxshad' `cline' `ltrunc' /*
          */ `rtrunc' stlevel(`stlevel') `options'
         }
       }
restore

     }
     
     global S_1 = `cappsi'
     global S_2 = (`sumw'^(-0.5))
     global S_3 = `lc'
     global S_4 = `uc'
     global S_5 = `ft'
     global S_6 = tprob(`k'-1,`ft')
     global S_7 = `rcappsi'
     global S_8 = (`swstar'^(-0.5))
     global S_9 = `rlc'
     global S_0 = `ruc'
     global S_11 = `rt'
     global S_12 = tprob(`k'-1,`rt')
     global S_13 = `tausq'

     if ("`ebayes'"~="" | "`graph'"=="e") & `tausq'~=0 {
       cap drop ebest
       cap drop ebse

       if "`eform'"~="" {
         scalar define `rcappsi'=log(`rcappsi')
       }  

       qui gen ebest = (`psi'/(`v') + `rcappsi'/`tausq') / (1/(`v') + 1/`tausq') if `touse' 
       qui gen ebse=sqrt((`tausq'*`v')/(`tausq'+`v')+((`v'/(`tausq'+`v'))^2)/`swstar') if `touse'

       if "`eform'"~="" {
         qui replace ebest=exp(ebest) if `touse'
       }
     }



end

program define metagrph
  version 5.0

  local varlist "req ex min(2) max(2)"

  local options "ID(string) CAPPSI(string) POOLLC(string)"
  local options "`options' POOLUC(string) SAving(string) EFORM"
  local options "`options' STLEVEL(integer $S_level) FMult(real 1)"
  local options "`options' BOXYsca(real 1) BOXSHad(integer 0) CLine"
  local options "`options' LTRunc(string) RTRunc(string) CI *"
  parse "`*'"

  tempvar se obsno lci uci idlen psi
  tempname obslab k

  parse "`varlist'", parse(" ")
  local psi1 `1'
  local v `2'

  gen `psi'=`psi1'
  if "`ci'"  == "ci" { qui replace `psi' = ln(`psi') } 
  label var `psi' "`psi1'"
  local psi1l : variable label `psi1'
  if "`psi1l'" != "" { label var `psi' "`psi1l'" }

  gen `obsno'=_n
  gsort -`obsno'

  if _N>20 {
    local fdiv1=20/_N
  }
  else {
    local fdiv1=1
  }
  local fdiv=`fdiv1'

  local k=_N
  quietly {
    gen `se'=sqrt(`v')
    gen `lci'=`psi'-invnorm(`stlevel'*0.005 + 0.5)*`se'
    gen `uci'=`psi'+invnorm(`stlevel'*0.005 + 0.5)*`se'

    if "`eform'"~="" {
      replace `psi'=exp(`psi')
      replace `lci'=exp(`lci')
      replace `uci'=exp(`uci')
      local xlog "xlog"
    }

    if "`ltrunc'"~="" {
      quietly summ `psi'
      if `ltrunc'>_result(5) {
        di in re "Left truncation must be less than all effect estimates"
        exit 198
      }
      quietly replace `lci'=`ltrunc' if `lci'<`ltrunc'
    }
    if "`rtrunc'"~="" {
      quietly summ `psi'
      if `rtrunc'<_result(6) {
        di in re "Right truncation must be greater than all effect estimates"
        exit 198
      }
      quietly replace `uci'=`rtrunc' if `uci'>`rtrunc'
    }

    if "`saving'"~="" {
      local saving "saving(`saving')"
    }
  
  quietly replace `obsno'=_n+1
  local i 1
  local ylab="0"
  local ytick="2"
  while `i'<=_N {
    local i=`i'+1

    if `i'>2 {
      local ytick "`ytick',`i'"
    }
  }
  local i=`i'+1

  if _N<26 {
    local ytick "ytick(`ytick')"
  }
  else {
    local ytick ""
  }

  local nobs1=_N+1
  local nobs2=_N+2
  quietly {
    set obs `nobs2'
    summ `lci'
    replace `psi'=_result(5) in `nobs1'
    summ `uci'
    replace `psi'=_result(6) in `nobs2'

    replace `obsno'=0 in `nobs1'
    replace `obsno'=`nobs2' in `nobs2'

    label define `obslab' 0 " " `nobs2' " ", add
    label values `obsno' `obslab'
  }

  sort `obsno'

  graph `obsno' `psi', ylab(`ylab') `ytick' s(i) gap(10) `xlog' `options'

  parse "$S_G1", parse(",")
* noi display "* `*'"
  local leftgph `3'
  local dr `9'
  local dc `11'

  parse "$S_G2", parse(",")
  local leftdat `3'
  local rgttext=(`leftdat'-`leftgph')*.75

  local imax=_N
  local i=2
  tempvar boxwid

  quietly gen `boxwid'=1/`se'

  if "`id'"~="" {
    gen `idlen'=length(`id')
    quietly summarize `idlen'
    local idleng=_result(6)
    
    if `idleng'>8 {
      local fdiv2=8/`idleng'
    }
    else {
      local fdiv2=1
    }
  
    local fdiv=min(`fdiv1',`fdiv2')
*   noi display "`fdiv'  `fdiv1'  `fdiv2'"

  }
  local dr=`dr'*.7*`fdiv'*`fmult'
  local dc=`dc'*.7*`fdiv'*`fmult'

  gph open, `saving'
  graph
  local ay=_result(5)
  local by=_result(6)
  local ax=_result(7)
  local bx=_result(8)

  gph font `dr' `dc'

  local st=`obsno'[1]
  local row=(`st'*`ay') + `by'
  local textrow=`row'+(`dc'/2)
  local chari=`id'[`i']

  gph text `textrow' `rgttext' 0 1 Combined

  while `i'<`imax' {

* row value
    local st=`obsno'[`i']
    local row=(`st'*`ay') + `by'

* label y axis
    if "`id'"~="" {
      local textrow=`row'+(`dc'/2)
      local chari=`id'[`i']

      gph text `textrow' `rgttext' 0 1 `chari'
    }

* draw box with area proportional to inverse variance

    local mu=`psi'[`i']

    if "`eform'"~="" {
      local col=(log(`mu')*`ax') + `bx'
    }
    else {
      local col=(`mu'*`ax') + `bx'
    }

* derive maximum box size (yrange)
    quietly summ `obsno'
    local ymin=_result(5)
    local ymax=_result(6)
    local ynum=_result(1)
    local rmin=(`ymin'*`ay') + `by'
    local rmax=(`ymax'*`ay') + `by'
    local yrange=abs(`rmax'-`rmin')/(2*`ynum')

* draw box
    quietly summ `boxwid'
    local widmax=_result(6)
    local width=`boxwid'[`i']
    local mult=`yrange'*`width'/`widmax'
    local xscale=320/233
    local boxlr=`row'-(`mult'*`boxysca')
    local boxur=`row'+(`mult'*`boxysca')
    local boxlc=`col'-(`mult'/`xscale')
    local boxuc=`col'+(`mult'/`xscale')
    gph box `boxlr' `boxlc' `boxur' `boxuc' `boxshad '

* confidence interval
    local lc=`lci'[`i']
    local uc=`uci'[`i']

    if "`eform'"~="" {
      local cleft=(log(`lc')*`ax') + `bx'
      local cright=(log(`uc')*`ax') + `bx'
    }
    else {
      local cleft=(`lc'*`ax') + `bx'
      local cright=(`uc'*`ax') + `bx'
    }
    gph line  `row' `cleft' `row' `cright'

    local i=`i'+1
  }

* diamond for overall estimate

* row value
  local st=`obsno'[1]
  local row=(`st'*`ay') + `by'
  local rowup=`row'+(`yrange'/3)
  local rowdn=`row'-(`yrange'/3)

  if "`eform'"~="" {
    local cmiddle=(log(`cappsi')*`ax') + `bx'
    local cleft=(log(`poollc')*`ax') + `bx'
    local cright=(log(`pooluc')*`ax') + `bx'
  }
  else {
    local cmiddle=(`cappsi'*`ax') + `bx'
    local cleft=(`poollc'*`ax') + `bx'
    local cright=(`pooluc'*`ax') + `bx'
  }
  gph line  `rowup' `cmiddle' `row' `cright'
  gph line  `row' `cright' `rowdn' `cmiddle'
  gph line  `rowup' `cmiddle' `row' `cleft'
  gph line  `row' `cleft' `rowdn' `cmiddle'

* dotted line at the combined estimate
  if "`cline'"~="" {
    local top=`obsno'[_N-1] + 0.5
    local rowup=(`top'*`ay') + `by'
    local incr=(`rowup'-`rowdn')/100
    local j 0
    while `j'<50 {
      local i=2*`j'
      local lower=`rowdn'+(`i'*`incr')
      local upper=`rowdn'+((`i'+1)*`incr')
      gph line `lower' `cmiddle' `upper' `cmiddle'
      local j=`j'+1
    }
  }
  gph close

  }
end












