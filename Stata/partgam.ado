*! version 1.0.8 13dec1999
*! partly based on tabodds & mhodds - thanks 
*! author Jens M.Lauritsen & Svend Kreiner 

program define partgam, rclass
	version 6
	syntax varlist(min=2 max=2) [if] [in] [fweight] [, ADJust(string) BY(string) /*
		*/ Ref(int 1) DL(int 132) ONE Info/*
		*/ Level(int $S_level) NOTable Table SUBtable TABPct SUBPct TEST MATrix]

	preserve
	if "`by'"!="" {local adjust = "`by'"}
	if "`if'" != "" {qui keep `if'}
	if "`in'" != "" {qui keep `in'}
	tokenize `varlist'

	local w = ""
	if "`exp'"!="" {local wtopt "[fw `exp']"
	local w = substr("`exp'",3,8)}
        local xdat1 "`1'"
	local xdat2 "`2'"
	keep `xdat1' `xdat2' `adjust' `w'
	
qui set d l `dl'
qui set log l `dl'

local pside = cond("`one'" =="",2,1)
local info = cond("`info'" =="",0,1)
local tbl_tst = cond("`sw'" =="",0,1)
local tbl_tst = cond("`test'" =="",`tbl_tst',1)
local notable = cond("`notable'" =="",0,1)

capture confirm string variable `xdat1'
	if _rc==0 {
		noi di in red "non numeric variable `1' not allowed"
		exit 198
	}

capture confirm string variable `xdat2'
	if _rc==0 {
		noi di in red "non numeric variable `2' not allowed"
		exit 198 
		}

	local t2:word count `adjust'

	* exchange x1 and x2 ?
	tempvar grp mx1 mx2
	qui inspect `xdat1'
	local mx1 = r(N_unique)              
	qui inspect `xdat2'
	local mx2 = r(N_unique)              
 	if `mx2' > `mx1' {
		local t = "`xdat2'"
		local xdat2 = "`xdat1'"
	        local xdat1 = "`t'"
	}

	if max(`mx1',`mx2') > 250 | min(`mx1',`mx2') > 20 {
                noi di in red "Error: too many categories in: `xdat1'(`mx1') or `xdat2'(`mx2')"
		exit 198 
		}
	local n = 0
	qui count if (`1' == . | `2' == .)
	local n = r(N)
	
	qui drop if `1' == .
	qui drop if `2' == .

	* drop missing observations
	local vars = "`adjust'"
	dropmiss "`vars'" 
	scalar nm = r(nmiss)

	tempvar grp
	qui egen `grp'=group(`adjust')
	qui sum `grp',mean
	local max=r(max)              
	sort `grp'

        noi di _n in yel "Gamma coefficient for " in wh "`xdat1'" in yel" by " in wh "`xdat2'" in yel " (Assumed ordinal)"
	if `info' == 1 {global S_pg1 = ""
			global S_pg2 = ""
			global S_pgadj = "" }

        if ("$S_pg1" != "`xdat1'") | ("$S_pg2" != "`xdat2'") {
		local lb: var l `xdat1' 
		di " `xdat1' " _col(12) "`lb'"
		local lb: var l `xdat2' 
		di " `xdat2' " _col(12) "`lb'"
		global S_pg1 = "`xdat1'"
		global S_pg2 = "`xdat2'"}

	if `info' == 1 {
		local l = cond(`pside' == 1,"one","two")
	  	di _n in gre " P-values of single gamma's are `l'-sided"
		if `n' > 0 { di in gre " Excluded (" in yel "`xdat1'" in gre " and/or " in yel "`xdat2'" in gre " missing):" in yel %6.0f _col(45)  `n'}
		if "`adjust'" != "" {di in gre " Excluded (" in yel "`adjust'" in gre " missing) :" in yel %6.0f _col(45) nm }
		if (`mx1' +`mx2') > 40 {di in yel "Caution: Very large number of categories: `xdat1'(`mx1') `xdat2'(`mx2')" }
		if `max' > 20 {di _n in yel "Observe the large number of subtables" _n(2) }
	}

		if "`table'"!="" {di _n in yel "Unstratified table is "
		noi tabulate `xdat1' `xdat2' `wtopt' , gamma chi}

		if "`tabpct'"!="" {di _n in yel "Unstratified table with row percentage is"
				noi tab `xdat1' `xdat2' `wtopt', row}


	if "`adjust'"!="" {
			tempvar lbl l1

			jl_lbl "`adjust'"
			local i = 1
			while `i' <= r(groups) {
			  local lbl`i' = r(label`i')
			  local i = `i' +1 }

			local max = r(groups)
	        	local t2:word count `adjust'
			di in gr _n "Stratified on/ Conditional on: " in yel "`adjust'" 

	if ((`info' == 1) | (`info' == 0 & "$S_pgadj" != "`adjust'" )) {
			tokenize `adjust'
			while "`1'" != "" {
			local lb: var l `1' 
			di " `1' " _col(12) "`lb'"
			mac shift
			}
			global S_pgadj = "`adjust'"
			}


			local adjlen = (`t2')*9
			local wrdln=max(12,`adjlen')+2
			if "`subtable'"!="" {di _n in yel "Stratified table is "
				sort  `adjust'
				noi table `xdat1' `xdat2' `wtopt', by(`adjust') row col}
			if "`subpct'"!="" {di _n in yel "Stratified table with row percentage is"
				sort  `adjust'
				by `adjust': tab `xdat1' `xdat2' `wtopt', row}
			}
	else {local label = " "
               		local max = 1 
                	local t2 = 0 
			local wrdln= 13
	        }


* output overall gamma:
	local Ncol = 1
	local lg =  8
	local lglo =  18
	local lghi =  26
	local lpg =  32
	local lgch = 40
	local lgdf = 56
	line `wrdln'
	top `wrdln' `level' 1
	line `wrdln'

	local lng=`wrdln'-length("unstratified")
	local labx = "unstratified"
	qui tab `xdat1' `xdat2' `wtopt', chi gam
	scalar un_low = r(gamma) - invnorm(((100-`level')/2.0+`level')/100)*r(ase_gam)
	scalar un_high = r(gamma) + invnorm(((100-`level')/2.0+`level')/100)*r(ase_gam)
	if r(ase_gam) > 0.0 {scalar z = r(gamma)/r(ase_gam)}
                     else {scalar z = 0.0 }
	scalar un_p_gam = `pside'*(1.0-normprob(abs(z)))
	scalar un_df     = (r(r)-1)*(r(c)-1) 	
	scalar un_gam    = r(gamma)
	scalar un_chi    = r(chi2)
        scalar un_p_chi = chiprob(un_df,un_chi)
	scalar un_n      = r(N)
	noi di in gr _col(`lng') "`labx'" _col(`wrdln') "|" /*
       			*/ _col(`Ncol') in ye %6.0f un_n %10.3f _col(`lg')  un_gam /*
			*/ %8.3f _col(`lglo') un_low %7.3f _col(`lghi')  un_high %7.3f _col(`lpg') un_p_gam   /*
			*/ _col(`lgch') %8.1f un_chi %7.3f un_p_chi _col(`lgdf') %5.0f un_df  

if `t2' > 0 {

tokenize `adjust'
scalar j = 0
while "`1'" != "" {
    local i = 9 - length("`1'")
    scalar j = j + 9
    di in yel _col(`i') "`1' " _c
	mac shift
	}
    local i = `wrdln' - j 
noi di _col(`i') in gre "|" 

local i = `max' + 1

matrix gamma =J(`i',1,0)

matrix low =J(`i',1,0)
matrix high =J(`i',1,0)
matrix Nobs=J(`i',1,0)
matrix Chi=J(`i',1,0)
matrix p_chi=J(`i',1,0)
matrix df=J(`i',1,0)
matrix gweight=J(`i',1,0)
matrix ase=J(`i',1,0)
matrix p_gam=J(`i',1,0)
matrix variance=J(`i',1,0)

local i = 0
local pchi = 0


while `i' < `max' {

local i = `i' + 1
	

* step through levels of stratified variables
    qui sum `grp' if (`grp' == `i'), mean
	    local lblx = r(min) 
            qui tabulate `xdat1' `xdat2' `wtopt' if (`grp' == `i'), gamma chi

	capture assert r(gamma) < 2 
	if _rc != 9 {
		mat ase[`i',1] =r(ase_gam)
		mat low[`i',1] = r(gamma) - invnorm(((100-`level')/2.0+`level')/100)*ase[`i',1]
		mat high[`i',1] = r(gamma) + invnorm(((100-`level')/2.0+`level')/100)*ase[`i',1]
		mat gamma[`i',1] = r(gamma)
		if ase[`i',1] > 0.0 {scalar z = r(gamma)/ase[`i',1]}
                     else {scalar z = 0.0 }
		mat p_gam[`i',1] = `pside'*(1.0-normprob(abs(z)))
		mat df[`i',1] = (r(r)-1)*(r(c)-1) 
		mat Nobs[`i',1] = r(N)
		mat Chi[`i',1] = r(chi2)
		mat p_chi[`i',1] = r(p)
		}
	else {	mat low[`i',1] =0
		mat high[`i',1] =0
		mat gamma[`i',1] =0
		mat Chi[`i',1] = 0
		mat p_chi[`i',1] =0
		mat df[`i',1] = 0
		mat Nobs[`i',1] =0	
	}

	local lng = `wrdln'-length("`lbl`i''")
	local labx = "`lbl`i''"

        
  if `notable' == 0 {
	* first labels:
		jl_dilbl "`lbl`i''" 10 `t2'
		if df[`i',1] > 0 & float(gamma[`i',1]) < 1.0 & float(gamma[`i',1]) != -1.0{
			di _col(`Ncol') in ye %6.0f r(N) %9.3f _col(`lg')  gamma[`i',1] /*
			*/ %7.3f _col(`lglo') low[`i',1] %6.3f _col(`lghi')  high[`i',1] %7.3f _col(`lpg') p_gam[`i',1]   /*
			*/ _col(`lgch') %7.1f Chi[`i',1] %7.3f p_chi[`i',1] _col(`lgdf') %3.0f df[`i',1]
		}		
		else if float(gamma[`i',1]) == 1.0 | float(gamma[`i',1]) == -1.0{
			noi di in gr _col(`Ncol') in ye %6.0g r(N) %9.3f _col(`lg')  gamma[`i',1] /*
			*/ _col(`lgch') %7.1f Chi[`i',1] %7.3f p_chi[`i',1] _col(`lgdf') %3.0f df[`i',1]}
		else {
			noi di in gr _col(`Ncol') in ye %6.0g r(N)  _col(`lgdf') %3.0f df[`i',1]  
		}
      }
if `max' == 1 {local i = 2}
}

* weighted gamma (partial):

* total weights:

scalar pg_sumw = 0
scalar N_sum = 0

local i = 0
while `i' < `max'+1 {
       local i = `i' + 1
	mat gweight[`i',1] = 0.0
	mat variance[`i',1] = 0.0
	scalar N_sum = N_sum + Nobs[`i',1]
	if ase[`i',1] > 0.0 {
		mat gweight[`i',1] = 1/(ase[`i',1]*ase[`i',1])
		mat variance[`i',1] = ase[`i',1]*ase[`i',1]
	}
	scalar pg_sumw = pg_sumw + gweight[`i',1]
}

* total weights added to individual strata and partial gamma:
local i = 0
scalar partgam = 0.0
scalar partvar = 0.0
scalar chisum = 0.0
scalar dfsum = 0.0

while `i' < `max'+1 {
       local i = `i' + 1
	mat gweight[`i',1] = gweight[`i',1]/pg_sumw
	scalar partgam = partgam + gweight[`i',1]*gamma[`i',1]
	scalar partvar = partvar + gweight[`i',1]*gweight[`i',1]*(ase[`i',1]*ase[`i',1])
	scalar chisum  = chisum + Chi[`i',1]
	scalar dfsum = dfsum + df[`i',1]
}

scalar p_chisum = chiprob(dfsum,chisum)
scalar partase = sqrt(partvar)
scalar uu = partgam/partase
scalar pp =`pside'*(1.0-normprob(abs(uu)))
scalar plow = partgam - invnorm(((100-`level')/2.0+`level')/100)*partase
scalar phigh = partgam+ invnorm(((100-`level')/2.0+`level')/100)*partase

local labx = "Partial"
local lng=`wrdln'-length("`labx'")
noi di _col(`wrdln') in gre "|" 
noi di in yel _col(`lng') "`labx'" _col(`wrdln') in gre "|" /*
	*/ _col(`Ncol') in ye %6.0f N_sum %10.3f _col(`lg')  partgam /*
	*/ %8.3f _col(`lglo') plow %7.3f _col(`lghi')  phigh %8.3f  /*
	*/   %7.3f pp   %8.1f chisum %7.3f p_chisum _col(`lgdf') %5.0f dfsum

if `tbl_tst' == 1 {
	* consider ref group:
	if `ref' > `max' {local ref = `max'  }

	line `wrdln'
	di _n 
	di _col(`wrdln') in gre " Stratum weights & tests for gamma = gamma(ref)"
	line `wrdln'
	local lng=`wrdln'-length("`adjust'")
	top `wrdln' `level' 2
	line `wrdln'
  

tokenize `adjust'
scalar j = 0
while "`1'" != "" {
    local i = 9 - length("`1'")
    scalar j = j + 9
    di in yel _col(`i') "`1' " _c
	mac shift
	}
    local i = `wrdln' - j 
noi di _col(`i') in gre "|" 

	*compare gammas with reference 
 	local i = 1

	while `i' < `max'+1 {
		local lng=`wrdln'-length("`lbl`i''")
		* compare gamma with ref:
		scalar se = sqrt(ase[`i',1]*ase[`i',1]+ase[`ref',1]*ase[`ref',1])
		scalar z = (gamma[`i',1]-gamma[`ref',1])/se
		scalar pz = `pside'*(1.0-normprob(abs(z)))

		jl_dilbl "`lbl`i''" 10 `t2'

	if `i' == `ref' {
		di _col(`Ncol') in ye %6.0f Nobs[`i',1] %9.3f _col(`lg')  gamma[`i',1] /*
		*/ %7.3f _col(`lglo') p_gam[`i',1] %8.2f _col(`lghi') gweight[`i',1]  %10.3f _col(`lpg') ase[`i',1] /*
   		*/ _col(`lgch') "       ref" }
	else if df[`i',1] > 0 & gamma[`i',1] < 1.0 & gamma[`i',1] != -1.0{
		noi di _col(`Ncol') in ye %6.0f Nobs[`i',1] %9.3f _col(`lg')  gamma[`i',1] /*
		*/ %7.3f _col(`lglo') p_gam[`i',1] %8.2f _col(`lghi') gweight[`i',1]  %10.3f _col(`lpg') ase[`i',1] /*
   		*/ %10.1f _col(`lgch')  z %10.3f pz }
	else {	noi di in gr _col(`Ncol') in ye %6.0g Nobs[`i',1] %9.3f _col(`lg')  gamma[`i',1] _col(`lgdf') }

	       local i = `i' + 1
       }
}

line `wrdln'
local l = cond(`pside' == 1,". One sided tests for gamma",".")
di in gre `n'+nm " missing obs. excluded`l'" 
* test of gamma homogeneous across stata ?

* how many strata with > 0 variance ?
local i = 1
local strata = 0

while `i' <= `max' {
	if gweight[`i',1] > 0 {local strata = `strata' +1}
	local i = `i' +1
	}

matrix comgam    = J(`strata',1,0)
matrix comres    = J(`strata',1,0)
matrix comvar    = J(`strata',1,0)
matrix comvgt	 = J(`strata',1,0)
matrix comgrpnr  = J(`strata',1,0)
matrix varsq     = J(`strata',`strata',0)
* move values to new complete matrices
* 

local j = 1
local i= 1
	while `i' <= `max' {
		if gweight[`i',1] > 0 {
			matrix comgam[`j',1]   = gamma[`i',1]
			matrix comres[`j',1]   = gamma[`i',1] - partgam
			matrix comvar[`j',1]   = variance[`i',1]
			matrix comvgt[`j',1] =   gweight[`i',1]
			matrix comgrpnr[`j',1] = `j'
		local  j = `j' + 1}	
		local i = `i' +1
	}
	
* prepare variance matrix square format for inversion:
local i= 1
	while `i' <= `strata' {
			matrix varsq[`i',`i']  = comvar[`i',1]
		local i = `i' +1
	}

matrix invvar = inv(varsq)

scalar chi = 0.0
local i= 1
	while `i' < `strata' {
		local j = 1
		while `j' < `strata' {
			scalar chi = chi + comres[`i',1]*comres[`i',1]*invvar[`i',`j']
			local  j = `j' + 1
			}	
		local i = `i' +1
	}
   	di in gre "Test of homogeneity (equal gamma) chi2(" in yel (`strata'-1) in gre ") =" %7.2f _col(46)  in yel chi  
	if `pside' == 1 {di in gre "                    (two sided) "_col(35) "Pr>chi2 ="  %7.2f _col(46)  in yel chiprob(`strata'-1,chi) 
	     }
	else {di _col(35) in gre "Pr>chi2 ="  %8.3f _col(46)  in yel chiprob(`strata',chi) 
	     }
	     
	if `strata' < `max' { di "(" `max'-`strata' ") strata uninformative" }

return scalar un_gam = un_gam
return scalar un_low = un_low
return scalar un_high = un_high
return scalar un_p_gam = un_p_gam
return scalar partgam = partgam
return scalar p_gamma = pp
return scalar lo_gam  = plow
return scalar hi_gam = phigh
return scalar chi_gam = chi
return scalar p_chi = chiprob(`strata',chi)
return scalar strata = `strata'
return scalar uninfo = `max'-`strata'

if "`matrix'"!="" {
return matrix gamma  gamma
return matrix ase ase
return matrix low  low
return matrix high  high
return matrix comgam comgam
return matrix comres comres
return matrix comvar comvar
return matrix invvar invvar
return matrix comvgt comvgt
return matrix comgrpnr comgrpnr
return matrix varsq  varsq 
di _n "all matrices available, hit PgUp (one or more times)"
push return list
}

}
else {line `wrdln'
local l = cond(`pside' == 1,". One sided tests for gamma",".")
di in gre `n'+nm " missing obs. excluded`l'" 
}


restore
end

program define line
	local lp = `1'-1
	di in gr _dup(`lp') "-" "+" _dup(65) "-"
end

program define top
	if `3' == 1 {
	noi di in gre  _col(`1') "|" /*
	*/ "     N    gamma     [ `2'% CI ] p(gamma)    Chi2   p     df"}
	else {
	noi di in gre  _col(`1') "|" /*
	*/ "     N    gamma  p(gamma)     Weight    ase  Test: Z     p(z)"}
end

program define topraw
	if `3' == 1 {
	noi di in gre "|;" /*
	*/ "N;gamma;[ `2'% CI ];p(gamma);Table: Chi2;p;df;"}
	else {
	noi di in gre "|;" /*
	*/ "N;gamma;p(gamma);Weight;ase;Test: Z;p(z);"}
end

program define dropmiss, rclass
	parse "`1'", parse(" ")
	local n 0
	while "`1'"~="" { 
		qui count if `1' == .
		local n = `n' + r(N)
        	qui drop if `1' == . 
        	mac shift
		}
	return scalar nmiss = `n'
end

program define jl_lbl, rclass
local vars = "`1'"
local t2 : word count `vars'
tempname v1 v2 v3 vmx1 vmx2 vmx3 vmm1 vmm2 vmm3 lab1 lab2 lab3 i j j1 j2 j3
local i = 1
while `i' < 4 {
 local v`i' = ""
 local vmm`i' = 0
 local vmx`i' = 0
 local vmg`i' = 0
 local lab`i' = ""
 local i = `i' + 1
}

local i = 0
local maxgrp = 1

tokenize `vars'
while "`1'" != "" {
   local i = `i' + 1
   qui summ `1',mean
   local vmm`i'= r(min) 
   local vmx`i'= r(max) 
	local v`i' = "`1'"
	qui inspect `1'
	local vmg`i' = r(N_unique)              
	local maxgrp = `maxgrp' * `vmg`i''
	mac shift
}


if "`v1'" != "" {local lab1: value label `v1' }
if "`v2'" != "" {local lab2: value label `v2' }
if "`v3'" != "" {local lab3: value label `v3' }

local j = 0
local j1 = `vmm1'
local j2 = `vmm2'
local j3 = `vmm3'

while `j' < `maxgrp' {
* di in ye %10.6f "`j'  `j1'  `j2' `j3'"
 * j: group index 
 * j1: by var1 index
 * j2: by var2 index
 * j3: by var3 index
local j = `j' +1
local out = ""

 jl_out "`lab1'" `j1' "`v1'"
 local out = r(out)

 if "`v2'"!="" { jl_out "`lab2'" `j2' "`v2'"
					 local out = "`out'" +"~" + r(out)}

 if "`v3'"!="" { jl_out "`lab3'" `j3' "`v3'"
					 local out = "`out'" +"~" + r(out)}

  			if `j3' >= `vmx3' { 
				if `j2' >= `vmx2' {
					if `j1' > `vmx1' {local j1 = `vmm1'}
 					else 				{jl_add `j1' `v1' `vmx1'
			                     local j1 = r(counter)}
					local j2 = `vmm2'}
				else	{jl_add `j2' `v2' `vmx2'
                     local j2 = r(counter)}
				local j3 = `vmm3'}
			else {jl_add `j3' `v3' `vmx3'
                     local j3 = r(counter)}

  return local label`j' = "`out'"
}
return scalar groups = `maxgrp'
end

program define jl_add,rclass
local j1 = `1' + 1
qui count if `2' == `j1'  
while r(N) == 0 & `j1' < `3' {
         local j1 = `j1' + 1
      qui count if `2' == `j1'}  
return local counter = `j1'
end

program define jl_out,rclass
if "`1'" !="" {local labx: label `1' `2' 8}
else {local labx = string(`2')}
return local out = "`labx'"
end


program define jl_dilbl
tempname whole i first

if `3' == 1 {di "   " _c }
if index("`1'","~") > 0 {
local rest = "`1'"
  while index("`rest'","~") > 0 {
	local first = substr("`rest'",1,index("`rest'","~")-1)
	local rest = substr("`rest'",index("`rest'","~")+1,80)
	local len=`2'-length("`first'")
	di in gr  _col(`len') %8.0g "`first'" _c }
  }
else {local rest="`1'"}
	local len=`2'-length("`rest'")
	di in gr  _col(`len') %8.0g "`rest' |"_c 
end


