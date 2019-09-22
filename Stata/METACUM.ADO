*! version 1.02 jacs January 1998

program define metacum
     version 5.0
     local varlist "req ex min(2) max(4)"
     local if "opt"
     local in "opt"
     local options "EFOrm ID(string) Level(integer $S_level)"
     local options "`options' EFFect(string) YLABel(string) XLOG GRaph"
     local options "`options' Var CI"
     local options "`options' Symbol(string) FMult(real 1)"
     local options "`options' CLine YTick GAP CSize(real 180)"
     local options "`options' LTRunc(string) RTRunc(string) SAving(string) *"

     parse "`*'"

     if "`id'"~=""{
          confirm variable `id'
     }

     if "`var'"~=""&"`ci'"~="" {
         di in re "Do not use the var option and the ci option at the same time"
         exit 198
     }

     if "`effect'"~="" {
       capture assert "`effect'"=="r" | "`effect'"=="f"
       if _rc~=0 {
         di in re "Must specify effect(f) or effect(r)"
         exit 198
       }
     }
     else {
       di in re "Must specify effect(f) or effect(r)"
       exit 198
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
     }

     tempvar touse v zz cumpsi cumse lc uc z pvalue idlen
     parse "`varlist'", parse(" ")
     local psi `1'
     local se `2'
     capture assert `se'>0
     if _rc~=0 {
       di in re "Standard error/variance/confidence limit must be>0 or missing for all studies"
       exit 198
     }

     quietly {
       preserve
       mark `touse' `if' `in'
       markout `touse' `psi' `se'
       if "`3'"~="" {
         markout `touse' `3'
       }
       keep if `touse'
     }


     if "`var'" == "var" {qui replace `se'=sqrt(`se')}

     if "`ci'" == "ci" {
     	capture confirm variable `4'
        if _rc~=0 { qui gen `zz'  = invnorm(.975) }
          else { qui replace `4' = `4' * 100 if `4' < 1
            qui gen `zz' = -1 * invnorm((1- `4' / 100) / 2 )
            qui replace `zz' = invnorm(.025) if `zz'==.
          }
        qui replace `se' = ( ln(`3') - ln(`2')) / 2 / `zz'
        qui replace `psi'   = ln(`psi')
      }
 
     quietly gen `v'=`se'^2

     local obs=_N
     capture assert `obs'>=2
     if _rc~=0 {
       di in re "Need at least two studies"
       exit 198
     }

     quietly {
       if "`id'"~="" {
         gen `idlen'=length(`id')
         quietly summarize `idlen'
         local idleng=_result(6)
       } 
       gen `cumpsi'=`psi' in 1
       gen `cumse'=`se' in 1
       local i 2
       while `i'<=`obs' {
         meta `psi' `se' in 1/`i'
         if "`effect'"=="f" {
           replace `cumpsi'=$S_1 in `i'
           replace `cumse'=$S_2 in `i'
         }       
         else if "`effect'"=="r" {
           replace `cumpsi'=$S_7 in `i'
           replace `cumse'=$S_8 in `i'
         }       
         local i=`i'+1
       }     
       gen `lc'=`cumpsi'-invnorm(`level'*0.005 + 0.5)*(`cumse')
       gen `uc'=`cumpsi'+invnorm(`level'*0.005 + 0.5)*(`cumse')
       gen `z'=`cumpsi'/`cumse'
       gen `pvalue'=2*min((1-normprob(`z')),normprob(`z'))
       if "`eform'"~="" {
             replace `cumpsi'=exp(`cumpsi')
             replace `lc'=exp(`lc')
             replace `uc'=exp(`uc')
             local ef=" (exponential form)"
             local efu="-------------------"
       }
     }
     if "`effect'"=="f" {
       local et="fixed-effects "
       local etu="--------------"
     }
     if "`effect'"=="r" {
       local et="random-effects "
       local etu="---------------"
     }

     di in gr _n "Cumulative " "`et'" "meta-analysis of `obs' studies `ef'"
     di in ye "----------" "`etu'" "----------------------------`efu'"
     di " "
     if "`id'"=="" {
       di in gr "Cumulative       `level'% CI"
       di in gr "  estimate    Lower  Upper         z  P value"
     }
     else {
       local idleng1=max((`idleng'+1), 8)
       di in gr _column(`idleng1') " Cumulative       `level'% CI"
       di in gr "Trial" _column(`idleng1') "   estimate    Lower  Upper         z  P value"
       local col1=`idleng1'+5
       local col2=`idleng1'+14
       local col3=`idleng1'+21
       local col4=`idleng1'+31
       local col5=`idleng1'+40
     }
     local i 1
     while `i'<=`obs' {
       if "`id'"=="" {
         di in ye _column(5) %6.3f `cumpsi'[`i'] _column(14) %6.3f `lc'[`i'] /*
          */ _column(21) %6.3f `uc'[`i'] _column(31) %6.3f `z'[`i'] /*
          */ _column(40) %6.3f `pvalue'[`i']
       }
       else {
         di in ye `id'[`i'] /*
          */ _column(`col1') %6.3f `cumpsi'[`i'] _column(`col2') %6.3f `lc'[`i'] /*
          */ _column(`col3') %6.3f `uc'[`i'] _column(`col4') %6.3f `z'[`i'] /*
          */ _column(`col5') %6.3f `pvalue'[`i']
       }
       local i=`i'+1
     }
*     list `psi' `se' `cumpsi' `cumse'

*****************************
*  draw graph               *
*****************************
  if "`graph'"~="" {
  tempvar obsno
  tempname obslab k

  gen `obsno'=_n
  gsort -`obsno'
  quietly replace `obsno'=_n

  if _N>20 {
    local fdiv1=20/_N
  }
  else {
    local fdiv1=1
  }
  local fdiv=`fdiv1'

  local k=_N
  quietly {

    if "`eform'"~="" {
      local xlog "xlog"
    }

    if "`ltrunc'"~="" {
      summ `cumpsi'
      if `ltrunc'>_result(5) {
        di in re "Left truncation must be less than all effect estimates"
        exit 198
      }
      replace `lc'=`ltrunc' if `lc'<`ltrunc'
    }
    if "`rtrunc'"~="" {
      summ `cumpsi'
      if `rtrunc'<_result(6) {
        di in re "Right truncation must be greater than all effect estimates"
        exit 198
      }
      replace `uc'=`rtrunc' if `uc'>`rtrunc'
    }

    if "`saving'"~="" {
      local saving "saving(`saving')"
    }
  
  local i 1
  local ylab="1"
  local ytick="1"
  while `i'<=_N {
    if `i'>=2 {
      local ytick "`ytick',`i'"
    }
    local i=`i'+1
  }

  if _N<26 {
    local ytick "ytick(`ytick')"
  }
  else {
    local ytick ""
  }

  label define `obslab' 1 " "
  label values `obsno' `obslab'


  replace `psi'=`cumpsi'
  summ `lc'
  replace `psi'=_result(5) in 1
  summ `uc'
  replace `psi'=_result(6) in 2
  }
  label var `obsno' " "
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
  local i=1

  if "`id'"~="" {
    if `idleng'>8 {
      local fdiv2=8/`idleng'
    }
    else {
      local fdiv2=1
    }
  
    local fdiv=min(`fdiv1',`fdiv2')

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

  while `i'<=`imax' {

* row value
    local st=`obsno'[`i']
    local row=(`st'*`ay') + `by'

* label y axis
    if "`id'"~="" {
      local textrow=`row'+(`dc'/2)
      local chari=`id'[`i']

      gph text `textrow' `rgttext' 0 1 `chari'
    }
    local mu=`cumpsi'[`i']

    if "`eform'"~="" {
      local col=(log(`mu')*`ax') + `bx'
    }
    else {
      local col=(`mu'*`ax') + `bx'
    }
    gph point `row' `col' `csize' 1


* confidence interval
    local l=`lc'[`i']
    local u=`uc'[`i']

    if "`eform'"~="" {
      local cleft=(log(`l')*`ax') + `bx'
      local cright=(log(`u')*`ax') + `bx'
    }
    else {
      local cleft=(`l'*`ax') + `bx'
      local cright=(`u'*`ax') + `bx'
    }
    gph line  `row' `cleft' `row' `cright'

    local i=`i'+1
  }


* dotted line at the combined estimate
  if "`cline'"~="" {
    if "`eform'"~="" {
      local cmiddle=(log(`cumpsi'[1])*`ax') + `bx'
    }
    else {
      local cmiddle=(`cumpsi'[1]*`ax') + `bx'
    }

    local top=`obsno'[1] 
    local rowup=(`top'*`ay') + `by'
    local incr=(`rowup'-`row')/100
    local j 0
    while `j'<50 {
      local i=2*`j'
      local lower=`row'+(`i'*`incr')
      local upper=`row'+((`i'+1)*`incr')
      gph line `lower' `cmiddle' `upper' `cmiddle'
      local j=`j'+1
    }
  }
  gph close
  }
end

