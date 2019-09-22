*! version 1.0 5May98  STB-44 sbe24
program define metan
    version 5.0
    local varlist "req ex min(4) max(6)"
    local if "opt"
    local in "opt"
    #delimit ;
    local options "LABEL(string) ILevel(int $S_level) OLevel(int $S_level) 
     SORTBY(string) OR RR RD FIXED FIXEDI RANDOM RANDOMI PETO noSTAndard 
     HEDGES GLASS COHEN noKEEP noTABLE CHI2 CORNFIELD noGRAPH SAVING(string)  
     XLAbel(string) FORCE BOXSCA(real 1.0) BOXSHA(int 4) TEXTS(real 1.0) noOVErall
     T1(string) T2(string) B1(string) noWT noSTATS";
    #delimit cr
    parse "`*'" 
    global MA_FBSH=`boxsha'
    global MA_FBSC=`boxsca'
    if (`texts'>2 | `texts'<0.1 ) {local texts=1} 
    global MA_FTSI=`texts'
    if "`saving'"!="" { local saving "saving(`saving')" }
     else { local saving "saving(NO)" }
    if "`overall'"!="" {local wt "nowt"}
    if `ilevel'<1 {local ilevel=`ilevel'*100 }
    if `ilevel'>99 | `ilevel'<10 { local ilevel $S_level }
    global ZIND= -invnorm((100-`ilevel')/200)
    if `olevel'<1 {local olevel=`olevel'*100 }   
    if `olevel'>99 | `olevel'<10 { local olevel $S_level }
    global ZOVE= -invnorm((100-`olevel')/200)
    global IND=`ilevel'
    global OVE=`olevel'
    if "`fixed'`random'`fixedi'`randomi'`peto'"=="" { local fixed "fixed" }
    if "`label'"!="" {
	parse "`label'", parse("=,")
	while "`1'"!="" {
		cap confirm var `3'
		if _rc!=0  {
			di in re "Variable `3' not defined"
			exit _rc
		}
		local `1' "`3'" 
		mac shift 4
	}
    }
    #delimit ;
    global S_1 "."; global S_2 "."; global S_3 "."; global S_4 "."; global S_5 ".";
    global S_6 "."; global S_7 "."; global S_8 "."; global S_9 "."; global S_10 ".";
    global S_11 "."; global S_12 "."; 
    #delimit cr
    tempvar code
    qui {
	if "`namevar'"!="" {
		local lbnvl : value label `namevar' 
		if "`lbnvl'"!=""  { quietly decode `namevar', gen(`code') }
		 else {
		      gen str10 `code'=""  
		      cap confirm string variable `namevar'
		      if _rc==0       { replace `code'=`namevar' }
		       else if _rc==7 { replace `code'=string(`namevar') }
		}
	 }
	 else { gen str3 `code'=string(_n) }
	if "`yearvar'"!=""  {
		  local yearvar "`yearvar'" 
		  cap confirm string variable `yearvar'
		  if _rc==7 { local str "string" }
		  if "`namevar'"=="" { replace `code'=`str'(`yearvar') }
		   else { replace `code'=`code'+" ("+`str'(`yearvar')+")" }
	}
     } /* End of quietly loop */
     if "`sortby'"!=""  { local sortby "sortby(`sortby')" }
     if "`xlabel'"!=""  { local xlabel "`xlabel'" }
      else { local xlabel "NONE" }
     parse "`varlist'", parse(" ")
     if "`6'"=="" {
	cap { 
		assert int(abs(`1'))==`1'
		assert int(abs(`2'))==`2'
		assert int(abs(`3'))==`3'
		assert int(abs(`4'))==`4'
	}
	if _rc!=0 {
		di in re "Non integer or non-positive variables found" 
		 exit _rc
	}
	if "`peto'"!="" { local or "or" }
	  capture {
		assert ( ("`or'"!="")+("`rr'"!="")+("`rd'"!="") <=1 )
		assert ("`fixed'"!="")+("`fixedi'"!="")+("`random'"!="")+ /* 
 */ ("`randomi'"!="")+("`peto'"!="") <=1
	  }
	  if _rc!=0 {
		di in re "Invalid specifications for combining trials" 
		exit 198
	  }
	  if "`or'"!=""         {local sumstat "OR"  }
	   else if "`rd'"!=""   {local sumstat "RD"  }
	   else                 {local sumstat "RR"  }
	  if "`random'`randomi'"!=""  {local method  "D+L" }
	   else if "`peto'"!="" {local method  "Peto"}
	   else if "`fixedi'"!="" {local method  "I-V"}
	   else                 {local method  "M-H" }
	  if "`peto'"!=""       {local callalg "Peto"}
	   else                 {local callalg "`sumstat'"}
	  if ("`sumstat'"!="OR" | "`method'"=="D+L") & "`chi2'"!="" {
		di in re "Chi-squared option invalid for `method' `sumstat'"
		exit 
	  }
	  if "`keep'"=="" { 
		cap drop _SS
		gen _SS =`1'+`2'+`3'+`4' 
	  }
      }
      else {
	if "`random'`randomi'"!="" {
	  local randomi
	  local random "random"
	}
	if "`fixed'`fixedi'"!="" {
	  local fixedi
	  local fixed "fixed"
	}
	cap{
	  assert ("`hedges'"!="")+ ("`glass'"!="")+ ("`cohen'"!="")+ ("`standard'"!="")<=1
	  assert ("`random'"=="") | ("`fixed'"=="")
	}
	if _rc!=0 {
		di in re "Invalid specifications for combining trials" 
		exit 198
	}	
	if  "`standard'"!=""    {local stand "none"  }
	 else if "`hedges'"!="" {local stand "hedges"}
	 else if "`glass'"!=""  {local stand "glass" }
	 else {local stand "cohen"}
	local stand "standard(`stand')"
	if "`random'"!=""    { local method  "D+L" }
	 else                { local method  "I-V" }
	local callalg "MD"
	  if "`keep'"=="" { 
		cap drop _SS
		gen _SS =`1'+`4' 
	  }
     }
    `callalg' `varlist' `if' `in',  `sortby' `cornfield' `randomi' method(`method') /*
  */ `keep' `chi2' `table' label(`code')  `graph' xlabel(`xlabel') `force' `stand'  /*
  */ `saving' `overall'  t1(".`t1'") t2(".`t2'") b1(".`b1'") `wt' `stats'
    if $S_8<0 { di in re "Insufficient data to perform this meta-analysis" }
end

program define OR 
    version 5.0
    local varlist "req ex min(4) max(4)"
    local if "opt"
    local in "opt"
    #delimit ;
    local options "LABEL(string) SORTBY(string) noGRAPH noTABLE CHI2 RANDOMI
      METHOD(string) XLAbel(string) FORCE CORNFIELD noKEEP SAVING(string) 
      T1(string) T2(string) B1(string) noOVERALL noWT noSTATS";
    #delimit cr
    parse "`*'" 
    qui {
	tempvar a b c d use zeros r1 r2 c1 t or lnor v se ill iul ea /*
  */ va weight qhet id
	tempname R S PR PS QR QS ORmh lnORmh W lnOR vlnOR A EA VA
	parse "`varlist'", parse(" ")
	gen double `a' =`1'
	gen double `b' =`2'
	gen double `c' =`3'
	gen double `d' =`4'
	gen double `r1'=`a'+`b'
	gen double `r2'=`c'+`d'
	gen byte `use'=1 `if' `in'
	replace `use'=9 if `use'==.
	replace `use'=9 if (`r1'==.) | (`r2'==.)
	replace `use'=2 if (`use'==1) & (`r1'==0 | `r2'==0 )
	replace `use'=2 if (`use'==1) & ((`a'==0 & `c'==0) | (`b'==0 & `d'==0))
	count if `use'==1
	global S_8  =_result(1)-1 
	if $S_8<0 { exit }
	if "`method'"=="D+L" & ($S_8==0) { local method "M-H"}
	replace `a'=. if `use'!=1
	replace `b'=. if `use'!=1
	replace `c'=. if `use'!=1
	replace `d'=. if `use'!=1
	replace `r1'=. if `use'!=1
	replace `r2'=. if `use'!=1
	gen double `c1'=`a'+`c'
	gen double `t' =`r1'+`r2'
* Chi-squared test for effect
	sum `a',meanonly
	scalar `A'=_result(18)
	gen double `ea'=(`r1'*`c1')/`t' 
	gen double `va'=`r1'*`r2'*`c1'*(`b'+`d')/(`t'*`t'*(`t'-1)) 
	sum `ea',meanonly
	scalar `EA'=_result(18)
	sum `va',meanonly
	scalar `VA'=_result(18)
	global S_10=( (`A'-`EA')^2 )/`VA' /* chi2 effect value */
	global S_11=chiprob(1,$S_10)      /*  p(chi2)  */
	if "`cornfield'"!="" {
	   gen `ill'=.
	   gen `iul'=.
	   local j=1
	   tempname i al aj c1j r1j r2j alold
	   while `j'<=_N {
	    if `use'[`j']==1 {
	      scalar `i'  = 0 
	      scalar `al' =`a'[`j']
	      scalar `aj' =`a'[`j']
	      scalar `c1j'=`c1'[`j']
	      scalar `r1j'=`r1'[`j']
	      scalar `r2j'=`r2'[`j']
	      scalar `alold'= .
	      while abs(`al'-`alold')>.001 & `al'!=. { 
		 scalar `alold' = `al'
		 scalar `al'=`aj'-($ZIND)/sqrt( (1/`al') + 1/(`c1j'-`al') + /*
 */   1/(`r1j'-`al') +  1/(`r2j'-`c1j'+`al') ) 
		 if `al'==. {
			scalar `i'=`i'+1
			scalar `al'=`aj'-`i'
			if (`al'<0 | (`r2j'-`c1j'+`al')<0) {scalar `al'= . }
		 }
	      }
	      if `al'==. { scalar `al'= 0 } 
 replace `ill'=`al'*(`r2j'-`c1j'+`al')/((`c1j'-`al')*(`r1j'-`al')) in `j'
	      scalar `al'= `a'[`j']
	      scalar `alold'= . 
	      scalar `i'= 0 
	      while abs(`al'-`alold')>.001 & `al'!=. {
		 scalar `alold'= `al'
		 scalar `al'=`aj'+($ZIND)/sqrt( (1/`al')+ 1/(`c1j'-`al') + /*
 */  1/(`r1j'-`al') +  1/(`r2j'-`c1j'+`al') )
		 if `al'==. {
			  scalar `i'=`i'+1
			  scalar `al'=`aj'+`i'
			  if (`al'>`r1j' | `al'>`c1j' ) { scalar `al' = . }
		 }
	      }
 replace `iul'=`al'*(`r2j'-`c1j'+`al')/((`c1j'-`al')*(`r1j'-`al')) in `j'
	    }
	    local j=`j'+1
	   }
	 }
	gen `zeros'=1 if `use'==1 & (`a'<1 | `b'<1 | `c'<1 | `d'<1 )
	replace `a'=`a'+0.5 if `zeros'==1
	replace `b'=`b'+0.5 if `zeros'==1
	replace `c'=`c'+0.5 if `zeros'==1
	replace `d'=`d'+0.5 if `zeros'==1
	replace `r1'=`r1'+1 if `zeros'==1
	replace `r2'=`r2'+1 if `zeros'==1
	replace `t' =`t' +2 if `zeros'==1
	gen double `or'  =(`a'*`d')/(`b'*`c')
	gen double `lnor'=log(`or') 
	gen double `v'   =1/`a' +1/`b' +1/`c' + 1/`d' 
	gen double `se'  =sqrt(`v')
	if "`cornfield'"=="" {
		gen `ill' =exp(`lnor'-$ZIND*`se')
		gen `iul' =exp(`lnor'+$ZIND*`se')
	}
	if "`method'"=="M-H" | ( "`method'"=="D+L" & "`randomi'"=="" ) {
		tempname p q r s pr ps qr qs
		gen double `r'   =`a'*`d'/`t'
		gen double `s'   =`b'*`c'/`t'
		sum `r', meanonly
		scalar `R'  =_result(18)
		sum `s', meanonly
		scalar `S'  =_result(18)
		global S_1  =`R'/`S'
*  Heterogeneity
		scalar `lnOR'=log($S_1) 
		gen double `qhet' =( (`lnor'-`lnOR')^2 )/`v'
		sum `qhet', meanonly
		global S_7 =_result(18)           /*Chi-squared */
		global S_9 =chiprob($S_8,$S_7)    /*p(chi2 het) */
		gen double `p'   =(`a'+`d')/`t'
		gen double `q'   =(`b'+`c')/`t'
		gen double `pr'  =`p'*`r' 
		gen double `ps'  =`p'*`s'
		gen double `qr'  =`q'*`r'
		gen double `qs'  =`q'*`s'
		sum `pr', meanonly
		scalar `PR' =_result(18)
		sum `ps', meanonly
		scalar `PS' =_result(18)
		sum `qr', meanonly
		scalar `QR' =_result(18)
		sum `qs', meanonly
		scalar `QS' =_result(18)
		gen  `weight'=100*`s'/`S' 
		global S_2  =sqrt( (`PR'/(`R'*`R')+(`PS'+`QR')/(`R'*`S') + /* 
   */  `QS'/(`S'*`S'))/2 )
		global S_3  =exp(`lnOR' -$ZOVE*($S_2))
		global S_4  =exp(`lnOR' +$ZOVE*($S_2))
		global S_5  =abs(`lnOR')/($S_2) 
		global S_6  =normprob(-abs($S_5))*2    
		drop `p' `q' `r' `pr' `ps' `qr' `qs' 
	}
	if "`method'"!="M-H" {
		cap gen `weight'=.
		iv `lnor' `v', method(`method') `randomi' eform
		replace `weight'=100/( (`v'+$S_12)*($MA_W) )
	}
	replace `weight'=0 if `weight'==.
	gen `id'=_n
	sort `use' `sortby' `id'
	}  /* End of "quietly" loop  */    
	_disptab `or' `se' `ill' `iul' `weight' `use' `label',`keep' /*
 */ `table' method(`method') sumstat(OR) `chi2' xla(`xlabel') `force' `graph' /*
 */ saving(`saving') t1("`t1'") t2("`t2'") b1("`b1'") `overall' `wt' `stats'
end

program define Peto
    version 5.0
    local varlist "req ex min(4) max(4)"
    local if "opt"
    local in "opt"
    #delimit ;
    local options "LABEL(string) ORDER(string) noGRAPH METHOD(string) CHI2
      XLAbel(string) FORCE noKEEP SAVING(string) noTABLE SORTBY(string)
      T1(string) T2(string) B1(string) noOVERALL noWT noSTATS";
    #delimit cr
    parse "`*'" 
    qui {
	tempvar a b c d use r1 r2 t ea olesse v lnor or se ill iul p weight id
	tempname OLESSE V SE P lnOR A C R1 R2 
	parse "`varlist'", parse(" ")      
	gen double `a'  =`1' `if' `in'
	gen double `b'  =`2' `if' `in'
	gen double `c'  =`3' `if' `in'
	gen double `d'  =`4' `if' `in'
	gen double `r1'  =`a'+`b'
	gen double `r2'  =`c'+`d'
	gen byte `use'=1   `if' `in' 
	replace `use'=9 if `use'==.
	replace `use'=9 if (`r1'==.) | (`r2'==.)
	replace `use'=2 if (`use'==1) & (`r1'==0 | `r2'==0 )
	replace `use'=2 if (`use'==1) & ((`a'==0 & `c'==0 ) | (`b'==0 & `d'==0))
	count if `use'==1
	global S_8  =_result(1)-1  
	if $S_8<0 { exit }
	replace `a'=. if `use'!=1
	replace `b'=. if `use'!=1
	replace `c'=. if `use'!=1
	replace `d'=. if `use'!=1
	replace `r1'=. if `use'!=1
	replace `r2'=. if `use'!=1
	gen double `t'     =`r1'+`r2'  
	gen double `ea'    =`r1'*(`a'+`c')/`t'  
	gen double `olesse'=`a'-`ea'
	gen double `v'     =`r1'*`r2'*(`a'+`c')*(`b'+`d')/( `t'*`t'*(`t'-1) ) 
	gen double `lnor'  =`olesse'/`v'   
	gen double `or'    = exp(`lnor')
	gen double `se'    = 1/(sqrt(`v'))
	gen double `ill'   = exp(`lnor'-$ZIND*`se')
	gen double `iul'   = exp(`lnor'+$ZIND*`se')
	gen double `p'     =(`olesse')*(`olesse')/`v'
	sum `olesse', meanonly
	scalar `OLESSE'=_result(18)
	sum `v', meanonly
	scalar `V' =_result(18)
	sum `p', meanonly
	scalar `P'    =_result(18)
	scalar `lnOR' =`OLESSE'/`V'
	global S_1 =exp(`lnOR')
	global S_2 =1/sqrt(`V')
	global S_3 =exp(`lnOR'-$ZOVE*($S_2))
	global S_4 =exp(`lnOR'+$ZOVE*($S_2))
	sum `a', meanonly
	scalar `A'  =_result(18)
	sum `c', meanonly
	scalar `C'  =_result(18)
	sum `r1', meanonly
	scalar `R1' =_result(18)
	sum `r2', meanonly
	scalar `R2' =_result(18)
	global S_10 =(`OLESSE'^2)/`V'  /*Chi-squared effect*/
	global S_11 =chiprob(1,$S_10)
	global S_5  =abs(`lnOR')/($S_2)
	global S_6  =normprob(-abs($S_5))*2
/*Heterogeneity */
	global S_7=`P'-$S_10
	global S_9 =chiprob($S_8,$S_7) 
	gen `weight' =100*`v'/`V' 
	replace `weight'=0 if `weight'==.
	gen `id'=_n
	sort `use' `sortby' `id'
    }  /* End of quietly loop */
_disptab `or' `se' `ill' `iul' `weight' `use' `label',`keep' /*
 */ `table' method(`method') sumstat(OR) `chi2' xla(`xlabel') `force' `graph' /*
 */ saving(`saving') t1("`t1'") t2("`t2'") b1("`b1'") `overall' `wt' `stats'
end

program define RR
    version 5.0
    local varlist "req ex min(4) max(4)"
    local if "opt"
    local in "opt"
    #delimit ;
    local options "LABEL(string) SORTBY(string) noGRAPH noTABLE RANDOMI
      METHOD(string) XLAbel(string) FORCE noKEEP SAVING(string) 
      T1(string) T2(string) B1(string) noOVERALL noWT noSTATS";
    #delimit cr
    parse "`*'" 
    qui {
	tempvar a b c d use zeros r1 r2 t p r s rr lnrr v se ill iul w q weight id
	tempname P R S RRmh lnRRmh W lnRR vlnRR zval
	parse "`varlist'", parse(" ")      
	gen double `a'  =`1'
	gen double `b'  =`2'
	gen double `c'  =`3'
	gen double `d'  =`4'
	gen double `r1' =`a'+`b'
	gen double `r2' =`c'+`d'
	gen byte `use'=1   `if' `in' 
	gen `zeros'=1 if ( `use'==1) & (`a'< 1 | `c'< 1) 
	replace `use'=9 if `use'==.
	replace `use'=9 if (`r1'==.) | (`r2'==.)
	replace `use'=2 if (`use'==1) & (`r1'==0 | `r2'==0 ) 
	replace `use'=2 if (`use'==1) & ((`a'==0 & `c'==0 ) | (`b'==0 & `d'==0))
	count if `use'==1
	global S_8  =_result(1)-1  
	if $S_8<0 { exit }
	if "`method'"=="D+L" & ($S_8==0) { local method "M-H"}
	replace `a'=`a'+0.5 if `zeros'==1
	replace `b'=`b'+0.5 if `zeros'==1
	replace `c'=`c'+0.5 if `zeros'==1
	replace `d'=`d'+0.5 if `zeros'==1
	replace `r1'=`r1'+1 if `zeros'==1
	replace `r2'=`r2'+1 if `zeros'==1
	replace `a'=. if `use'!=1
	replace `b'=. if `use'!=1
	replace `c'=. if `use'!=1
	replace `d'=. if `use'!=1
	replace `r1'=. if `use'!=1
	replace `r2'=. if `use'!=1
	gen double `t'   =`r1'+`r2'
	gen double `r'   =`a'*`r2'/`t'
	gen double `s'   =`c'*`r1'/`t'
	gen double `rr'  =`r'/`s'
	gen double `lnrr'=log(`rr') 
	gen double `v'   =1/`a' +1/`c' - 1/`r1' - 1/`r2' 
	gen double `se'  =sqrt(`v')
	gen double `ill' =exp(`lnrr'-$ZIND*`se')
	gen double `iul' =exp(`lnrr'+$ZIND*`se')
	if "`method'"=="M-H" | "`method'"=="D+L" & "`randomi'"=="" {
		gen double `p'  =`r1'*`r2'*(`a'+`c')/(`t'*`t') - `a'*`c'/`t'
		sum `p', meanonly
		scalar `P'  =_result(18)
		sum `r', meanonly
		scalar `R'  =_result(18)
		sum `s', meanonly
		scalar `S'  =_result(18)
		global S_1 =`R'/`S'
		scalar `lnRR'=log($S_1)
*  Heterogeneity
		gen double `q'   =( (`lnrr'-`lnRR')^2 )/`v'
		sum `q', meanonly
		global S_7 =_result(18)
		global S_9 =chiprob($S_8,$S_7) 
		gen `weight'=100*`s'/`S' 
		global S_2 =sqrt( `P'/(`R'*`S') )
		global S_3 =exp(`lnRR' -$ZOVE*($S_2)) 
		global S_4 =exp(`lnRR' +$ZOVE*($S_2))
		global S_5 =abs(`lnRR')/($S_2)      
		global S_6 =normprob(-abs($S_5))*2
	}
	if "`method'"!="M-H" {
		cap gen `weight'=.
		iv `lnrr' `v', method(`method') `randomi' eform
		replace `weight'=100/( (`v'+$S_12)*($MA_W) )
	}
	replace `weight'=0 if `weight'==.
	gen `id'=_n
	sort `use' `sortby' `id'
    }  /* End of "quietly" loop  */ 
    _disptab `rr' `se' `ill' `iul' `weight' `use' `label', `keep' /*
 */ `table' method(`method') sumstat(RR) xla(`xlabel') `force' `graph' /*
 */ saving(`saving') t1("`t1'") t2("`t2'") b1("`b1'") `overall' `wt' `stats'
end

program define RD
    version 5.0
    local varlist "req ex min(4) max(4)"
    local if "opt"
    local in "opt"
    #delimit ;
    local options "LABEL(string) SORTBY(string) noGRAPH noTABLE RANDOMI
      METHOD(string) noKEEP SAVING(string) XLAbel(string) FORCE  
       T1(string) T2(string) B1(string) noOVERALL noWT noSTATS";
    #delimit cr
    parse "`*'" 
    qui {
	tempvar a b c d use zeros r1 r2 t rd weight rdnum v se ill iul vnum q id w
	tempname RDNUM VNUM RDmh W vRD zval
	parse "`varlist'", parse(" ")      
	gen double `a'  =`1'
	gen double `b'  =`2'
	gen double `c'  =`3'
	gen double `d'  =`4'
	gen double `r1'  =`a'+`b'
	gen double `r2'  =`c'+`d'
	gen byte `use'=1   `if' `in' 
	replace `use'=9 if `use'==.
	replace `use'=9 if (`r1'==.) | (`r2'==.)
	replace `use'=2 if ( `use'==1) & (`r1'==0 | `r2'==0 )
	count if `use'==1
	global S_8  =_result(1)-1  
	if $S_8<0 { exit }
	if "`method'"=="D+L" & ($S_8==0) { local method "M-H"}
	replace `a'=. if `use'!=1
	replace `b'=. if `use'!=1
	replace `c'=. if `use'!=1
	replace `d'=. if `use'!=1
	replace `r1'=. if `use'!=1
	replace `r2'=. if `use'!=1
	gen double `t'   =`r1'+`r2'
	gen double `rd'  =`a'/`r1' - `c'/`r2'
	gen `weight'=`r1'*`r2'/`t'
	sum `weight',meanonly
	scalar `W'  =_result(18)
	gen double `rdnum'=( (`a'*`r2')-(`c'*`r1') )/`t'
/*  Zero cell adjustments, placed here to ensure 0/n1 v 0/n2 really IS RD=0 */
	gen `zeros'=1 if `use'==1 & (`a'<1 | `b'<1 | `c'<1 | `d'<1)
	replace `a'=`a'+0.5 if `zeros'==1
	replace `b'=`b'+0.5 if `zeros'==1
	replace `c'=`c'+0.5 if `zeros'==1
	replace `d'=`d'+0.5 if `zeros'==1
	replace `r1'=`r1'+1 if `zeros'==1
	replace `r2'=`r2'+1 if `zeros'==1
	replace `t' = `t'+2 if `zeros'==1
	gen double `v'   =`a'*`b'/(`r1'^3)+`c'*`d'/(`r2'^3)
	gen double `se'  =sqrt(`v')
	gen double `ill' = `rd'-$ZIND*`se'
	gen double `iul' = `rd'+$ZIND*`se'
	if "`method'"=="M-H" | ("`method'"=="D+L" & "`randomi'"=="" ) {
		sum `rdnum',meanonly
		scalar `RDNUM'=_result(18)
		global S_1 =`RDNUM'/`W'
		gen double `q' =( (`rd'-$S_1)^2 )/`v'
		sum `q', meanonly
		global S_7 =_result(18)
		global S_9 =chiprob($S_8,$S_7)
		gen double `vnum'=( (`a'*`b'*(`r2'^3) )+(`c'*`d'*(`r1'^3)))  /*
   */ /(`r1'*`r2'*`t'*`t')
		sum `vnum',meanonly
		scalar `VNUM'=_result(18)
		global S_2 =sqrt( `VNUM'/(`W'*`W') )
		replace `weight'=`weight'*100/`W'
		global S_3 =$S_1 -$ZOVE*($S_2)
		global S_4 =$S_1 +$ZOVE*($S_2)
		global S_5 =abs($S_1)/($S_2)
		global S_6 =normprob(-abs($S_5))*2
	}
	if "`method'"!="M-H" {
		iv `rd' `v', method(`method') `randomi'
		replace `weight'=100/( (`v'+$S_12)*($MA_W) )
	}
	replace `weight'=0 if `weight'==.
	gen `id'=_n
	sort `use' `sortby' `id'
    }  /* End of "quietly" loop  */    
    _disptab `rd' `se' `ill' `iul' `weight' `use' `label', `keep' /*
 */ `table' method(`method') sumstat(RD) xla(`xlabel') `force' `graph'       /* 
 */ saving(`saving') t1("`t1'") t2("`t2'") b1("`b1'") `overall' `wt' `stats'
end

program define MD
    version 5.0
    local varlist "req ex min(6) max(6)"
    local if "opt"
    local in "opt"
    #delimit ;
    local options "LABEL(string) SORTBY(string) noGRAPH METHOD(string) 
      noKEEP SAVING(string) noTABLE STANDARD(string) XLAbel(string) 
      FORCE T1(string) T2(string) B1(string) noOVERALL noWT noSTATS";
    #delimit cr
    parse "`*'" 
    qui {
	tempvar n1 x1 sd1 n2 x2 sd2 use n s md v se ill iul weight id
	tempname W W_MD MDiv vMD 
	parse "`varlist'", parse(" ")      
	gen double `n1' =`1' 
	gen double `x1' =`2'
	gen double `sd1'=`3'
	gen double `n2' =`4'
	gen double `x2' =`5'
	gen double `sd2'=`6'
	gen `use'=1 `if' `in' 
	replace `use'=9 if `use'==.
	replace `use'=9 if (`n1'==.) | (`n2'==.) | (`x1'==.) | (`x2'==.) | /*
 */  (`sd1'==.) | (`sd2'==.)
	replace `use'=2 if ( `use'==1) & (`n1' <2  | `n2' <2  )
	replace `use'=2 if ( `use'==1) & (`sd1'<=0 | `sd2'<=0 )
	count if `use'==1
	global S_8  =_result(1)-1  
	if $S_8<0 { exit }
	if "`method'"=="D+L" & ($S_8==0) { local method "I-V"}
	replace `n1' =. if `use'!=1
	replace `x1' =. if `use'!=1
	replace `sd1'=. if `use'!=1
	replace `n2' =. if `use'!=1
	replace `x2' =. if `use'!=1
	replace `sd2'=. if `use'!=1
	gen double `n'  =`n1'+`n2'
	if "`standard'"=="none" {
		gen double `md' =`x1'-`x2'
		gen double `v'=(`sd1'^2)/`n1' + (`sd2'^2)/`n2'
		local prefix "W"
	 }
	 else {
 gen double `s'=sqrt( ((`n1'-1)*(`sd1'^2)+(`n2'-1)*(`sd2'^2) )/(`n'-2) )
		if "`standard'"=="cohen" {
 gen double `md' = (`x1'-`x2')/`s' 
 gen double `v'= ( `n'/(`n1'*`n2') )+( (`md'^2)/(2*(`n'-2)) )
		 }
		 else if "`standard'"=="hedges" {
 gen double `md' =( (`x1'-`x2')/`s' )*( 1-  3/(4*`n'-9) )
 gen double `v'=( `n'/(`n1'*`n2') ) + ( (`md'^2)/(2*(`n'-3.94)) )
		 }
		 else if "`standard'"=="glass" {
 gen double `md' =  (`x1'-`x2')/`sd2' 
 gen double `v'= (`n'/(`n1'*`n2')) + ( (`md'^2)/(2*(`n2'-1)) )
		}
	   local prefix "S"
	}
	gen double `se'  =sqrt(`v')
	gen double `ill'  =`md'-$ZIND*`se' 
	gen double `iul'  =`md'+$ZIND*`se' 
	iv `md' `v', method(`method') randomi
	gen `weight'=100/( (`v'+$S_12)*($MA_W) )
	replace `weight'=0 if `weight'==.
	gen `id'=_n
	sort `use' `sortby' `id'
    }  /* End of quietly loop  */
    _disptab `md' `se' `ill' `iul' `weight' `use' `label', `keep' /*
 */`table' method(`method') sumstat(`prefix'MD) xla(`xlabel') `force' `graph' /*
 */ saving(`saving') t1("`t1'") t2("`t2'") b1("`b1'") `overall' `wt' `stats'
end

program define iv 
	version 5.0
	local varlist "req ex min(2) max(2)"
	local if "opt"
	local in "opt"
	local options "METHOD(string) RANDOMI EFORM"
	tempvar stat v w qhet w2 wnew e_w e_wnew 
	tempname W W2 C T2 E_W E_WNEW OV vOV QHET
	parse "`*'"
	if "`eform'"!="" { local exp "exp" }
	parse "`varlist'", parse(" ")
	gen `stat'=`1'
	gen `v'   =`2'
	gen `w'   =1/`v'
	sum `w',meanonly
	scalar `W'=_result(18)
	global S_12=0
	global MA_W =`W'
	if ("`randomi'"=="" & "`method'"=="D+L") { scalar `QHET'=$S_7 }
	 else {
		gen `e_w' =`stat'*`w'
		sum `e_w',meanonly
		scalar `E_W'=_result(18)
		scalar `OV' =`E_W'/`W'
*  Heterogeneity
		gen `qhet' =( (`stat'-`OV')^2 )/`v'
		sum `qhet', meanonly
		scalar `QHET'=_result(18)
		global S_7=`QHET'
	}
	if "`method'"=="D+L" {
		gen `w2'  =`w'*`w'
		sum `w2',meanonly
		scalar `W2' =_result(18)
		scalar `C'  =`W' - `W2'/`W'
		global S_12 =max(0, ((`QHET'-$S_8)/`C') )
		gen `wnew'  =1/(`v'+$S_12)
		gen `e_wnew'=`stat'*`wnew'
		sum `wnew',meanonly
		global MA_W =_result(18)
		sum `e_wnew',meanonly
		scalar `E_WNEW'=_result(18)
		scalar `OV' =`E_WNEW'/$MA_W
	}
	global S_1 =`exp'(`OV')
	global S_2 =sqrt( 1/$MA_W )
	global S_3 =`exp'(`OV' -$ZOVE*($S_2))
	global S_4 =`exp'(`OV' +$ZOVE*($S_2))
	global S_5 =abs(`OV')/($S_2) 
	global S_6 =normprob(-abs($S_5))*2
	global S_9 =chiprob($S_8,$S_7)
end

program define _disptab
    version 5.0
    local varlist "req ex min(7) max(7)"
    #delimit ;
    local options "noLOG XLAbel(string) FORCE noKEEP SAVING(string) 
      noTABLE noGRAPH METHOD(string) SUMSTAT(string) CHI2 T1(string) 
      T2(string) B1(string) noOVERALL noWT noSTATS";
    #delimit cr
    parse "`*'"
    tempvar effect se lci uci weight use label tlabel
    parse "`varlist'", parse(" ")
    qui {
	gen `effect'=`1'
	gen `se'    =`2'
	gen `lci'   =`3'
	gen `uci'   =`4'
	gen `weight'=`5'
	gen byte `use'=`6'
	format `weight' %5.1f
	gen str10 `label'=""
	replace `label'=`7'
	gen str16 `tlabel'=`7'
	local usetot=$S_8+1
	count if `use'==2
	local alltot=_result(1)+`usetot'
	global IND:  displ %2.0f $IND
	if "`keep'"=="" {
	   #delimit ;
	    cap drop _ES ; cap drop _seES; cap drop _LCI ; cap drop _UCI; cap drop _WT;
	    gen _ES  =`effect';label var _ES "`sumstat'";
	    gen _seES=`se';    label var _seES "se(`sumstat')";
	    gen _LCI =`lci';   label var _LCI "Lower CI (`sumstat')";
	    gen _UCI =`uci';   label var _UCI "Upper CI (`sumstat')";
	    gen _WT=`weight';label var _WT "`method' weight";
	    replace _SS  =. if `use'!=1; label var _SS "Sample size";
	   #delimit cr
	}
    } /* End of quietly loop */
    if "`table'"=="" {
	di _n in gr _col(12) "Study |" _col(26) "`sumstat'" _col(31) /*
 */ "[$IND% Conf. Interval]    % Weight"  _n _dup(17) "-" "+" _dup(55) "-"
	local i=1
	while `i'<= `usetot' {
	   di in gr `tlabel'[`i'] _col(18) "| " in ye  %8.0g  `effect'[`i'] /* 
 */ "    " %8.0g `lci'[`i'] "  " %8.0g `uci'[`i'] "     "  %8.0g `weight'[`i'] 
	   local i=`i'+1
	}
	while `i'<= `alltot'  {
	   di in gr  `tlabel'[`i'] _col(18) "|   Excluded"
	   local i=`i'+1
	} 
	if $IND!=$OVE { 
	   global OVE: displ %2.0f $OVE
	   local insert "[$OVE% Conf. Interval]" 
	 } 
	 else { local insert "--------------------" }
	di in gr _dup(17) "-" "+" _dup(12) "-"  "`insert'" _dup(23) "-"
	if "`sumstat'"=="OR" | "`sumstat'"=="RR" {local h0=1}
	 else {local h0=0}
	di in gr "  `method' pooled `sumstat'" _col(18) "| " in ye %8.0g /*
  */  $S_1  "    "  %8.0g  $S_3 "  "  %8.0g $S_4
	di in gr _dup(17) "-" "+" _dup(55) "-" 
	di in gr "  Heterogeneity chi-squared = " in ye %6.2f $S_7 in gr /*
  */  " (d.f. = " in ye $S_8 in gr  ") p = "   in ye %4.3f $S_9
	if "`method'"=="D+L" { di in gr "  Estimate of between-study variance " /*
  */ "Tau-squared = " in ye %7.4f $S_12 }
	if "`chi2'"!="" {  di in gr "  Test of OR=1: chi-squared =  " in ye %4.2f /*
  */  $S_10 in gr  " (d.f. = 1) p = "  in ye %4.3f $S_11 }
	 else { di in gr "  Test of `sumstat'=`h0' : z= " in ye %4.2f $S_5  /*
  */  in gr  " p = "  in ye %4.3f $S_6 }
    }
    if "`graph'"=="" & `usetot'>1 { 
	_dispgph `effect' `lci' `uci' `weight' `use' `label', `log' xla(`xlabel') /*
  */ `force' sumstat(`sumstat') saving(`saving') t1("`t1'") t2("`t2'") /*
 */ b1("`b1'") `overall' `wt' `stats'
end

program define _dispgph
    version 5.0
    local varlist "req ex min(6) max(6)"
    #delimit ;
    local options "noLOG XLAbel(string) FORCE SAVING(string) SUMSTAT(string)
 T1(string) T2(string) B1(string) noOVERALL noWT noSTATS";
    #delimit cr
    parse "`*'"
    tempvar effect lci uci weight use label tlabel id yrange xrange Ghsqrwt
    parse "`varlist'", parse(" ")
    qui {
	gen `effect'=`1'
	gen `lci'   =`2'
	gen `uci'   =`3'
	gen `weight'=`4'
	gen byte `use'=`5'
	format `weight' %5.1f
	gen str10 `label'=""
	replace `label'=`6'
	local usetot=$S_8+1
	count if `use'==2
	local alltot=_result(1)+`usetot'
	local ymax=`alltot'
	gen `id'=`ymax'-_n+3 if `use'<=2
	if "`t1'"=="." {local t1 }
	 else {
		local t1=substr("`t1'",2,.)
		local t1 "t1(`t1')"
	}
	if "`t2'"=="." {local t2 }
	 else {
		local t2=substr("`t2'",2,.)
		local t2 "t2(`t2')"
	}
	if "`b1'"=="." {local b1 }
	 else {
		local b1=substr("`b1'",2,.)
		local b1 "b1(`b1')"
	}
	sum `lci'
	local Gxlo=_result(5) /* minimum of CIs*/
	sum `uci'
	local Gxhi=_result(6) /* maximum of CIs*/
	local h0=0
	if ("`sumstat'"=="OR" | "`sumstat'"=="RR") {
	   local h0=1
	   if "`log'"=="" {
		local xlog "xlog" 
		local log  "log"
		local exp  "exp"
		replace `lci'=1e-9 if `lci'<1e-8
		replace `lci'=1e9  if `lci'>1e8 & `lci'!=.
		replace `uci'=1e-9 if `uci'<1e-8
		replace `uci'=1e9  if `uci'>1e8 & `uci'!=.
		if `Gxlo'<1e-8 {local Gxlo=1e-8}
		if `Gxhi'>1e8  {local Gxhi=1e8}
	   }
	}
	if "`log'"=="nolog" {local log}
	local flag1=0
	if "`xlabel'"!="NONE" {
* capture inappropriate label
	   cap assert ("`xlog'"=="" ) | /* 
  */  ( ( min(`xlabel',`Gxhi')>1e-8 ) & (max(`xlabel',`Gxlo')<1e8) )
	   if _rc!=0 {
		  local flag1=10 
		  local xlabel 
	    }
	    else {
		if "`force'"!="" {
		   parse "`xlabel'", parse(",")
		   if "`3'"!="" {
			local Gxlo=`exp'(0)
			local Gxhi=`exp'(0)
		   }
		}
		local Gxlo=min(`xlabel',`Gxlo')
		local Gxhi=max(`xlabel',`Gxhi')
	   }
	}
	if "`xlabel'"=="NONE" | (`flag1'>1) {
	   local Gmodxhi=max( abs(`log'(`Gxlo')),abs(`log'(`Gxhi')))
	   if `Gmodxhi'==. {local Gmodxhi=2}
	   local Gxlo=`exp'(-`Gmodxhi')
	   local Gxhi=`exp'( `Gmodxhi')
	   local xlabel "`Gxlo',`h0',`Gxhi'"
	}
	local Gxlo=`log'(`Gxlo')
	local Gxhi=`log'(`Gxhi')
	local Gx2lo=`Gxlo'-0.1*`Gxhi'
	local Gx2hi=1.5*`Gxhi'-`Gxlo'
	local Gxmhi=(2*`Gxhi'+3*`Gx2hi')/5
	local Gyhi=`id'[1]
	gen `xrange'=`exp'(`Gx2lo') in 1
	if "`stats'"==""  { replace `xrange'=`exp'(`Gx2hi') in 2 }
	 else {
	    if "`wt'"=="" { replace `xrange'=`exp'(`Gxmhi') in 2 }
	    if "`wt'"!="" { replace `xrange'=`exp'(`Gxhi')  in 2 }
	}
	if "`overall'"!="" {
	    replace `id'=`id'-1
	    local Gyhi=`Gyhi'-1
	}
	gen `yrange'=0 in 1
	replace `yrange'=`Gyhi'+3 in 2
	cap label drop metatmpl
	local dummy =`Gyhi'+3
	label define metatmpl `dummy' "Study"
	label values `yrange' metatmpl
	if "`sumstat'"=="OR"        {local sscale "Odds ratio"}
	 else if "`sumstat'"=="RR"  {local sscale "Risk ratio"}
 else if "`sumstat'"=="RD"  {local sscale "Risk difference"}
 else if "`sumstat'"=="WMD" {local sscale "Weighted Mean diff."}
 else if "`sumstat'"=="SMD" {local sscale "Standardised Mean diff."}
	if "`saving'"!="NO" { local saving "saving(`saving')" }
	 else { local saving }
	gph open, `saving'
	gph font 650 350 
	graph `yrange' `xrange', s(i) xli(`h0') xlabel(`xlabel') `xlog' /*
 */  noaxis  yla(`dummy') gap(10) b2(`sscale') `t1' `t2' `b1'
	local r5=_result(5)
	local r6=_result(6)
	local r7=_result(7)
	local r8=_result(8)
	gph pen 1
	local Axlo =`r7'*(`Gxlo') +`r8'
	local Axhi =`r7'*(`Gxhi') +`r8'
	local Ax2hi=`r7'*(`Gx2hi')+`r8'
	local Axmhi=`r7'*(`Gxmhi')+`r8'
	gph line `r6' `Axlo'  `r6' `Axhi'
	if "`wt'"=="" {
	   if "`stats'"!="" {local Ax2hi=`Axmhi'}
	   gph text 1700 `Ax2hi' 0  1 % Weight
	}
	if "`stats'"==""  {
	   gph text 700 `Axhi' 0 -1 `sscale'
	   gph text 1700 `Axhi' 0 -1 ($IND% CI)
	}
	gen `Ghsqrwt'=0.5*sqrt(`weight')/2
	local flag=0
	while `flag'<1 {
	   cap assert `Ghsqrwt'<0.5
	   if _rc!=0 { replace `Ghsqrwt'=0.9*`Ghsqrwt' }
	    else { local flag=10}
	}
	replace `Ghsqrwt'=($MA_FBSC)*`Ghsqrwt'
	local len=length(`label')
local Aytexs=($MA_FTSI)*max(200, min(600, (500-20*(`ymax'-15)) ) )
local Axtexs=($MA_FTSI)*(min(1,10/`len'))*max(130, min(360,(0.6*`Aytexs')) )
	gph font `Aytexs' `Axtexs'
	local flag2=0
	local flag3=0
	local i=1
	while `i'<=`ymax' {
	 local Aycen= `r5'*(`id'[`i'])+`r6'
	 if `use'[`i']==1 {
	   gph pen 2
	   if `lci'[`i']==. | `uci'[`i']==. { local flag2=10}
	    else {
* Define lower/upper points on x-line, and centre on y-axis 
		local Axlpt= `r7'*(`log'( `lci'[`i'] ))+`r8'
		local Axupt= `r7'*(`log'( `uci'[`i'] ))+`r8'
		if (`Axupt' < `Axlo') | (`Axlpt' > `Axhi') {  
* If CI is totally off scale draw (triangular) arrow 
		  local Ayco1=`r5'*(`id'[`i']-0.2)+`r6'
		  local Ayco2=`r5'*(`id'[`i']+0.2)+`r6'
		  if `Axupt'<=`Axlo' {
			local Axlpt =`Axlo'
			local Axco1=`r7'*(`Gxlo')+`r8'
			local Axco2=`r7'*(`Gxlo')+`r8'+450
		  }
		  if `Axlpt'>=`Axhi' {  
			local Axupt =`Axhi'
			local Axco1=`r7'*(`Gxhi')+`r8'
			local Axco2=`r7'*(`Gxhi')+`r8'-450
		  }
		  gph line `Aycen' `Axco1' `Ayco2' `Axco2'
		  gph line `Ayco2' `Axco2' `Ayco1' `Axco2'
		  gph line `Ayco1' `Axco2' `Aycen' `Axco1'
		 }
		 else {
* Define box size
		  local Axcen  =`r7'*`log'(`effect'[`i'])+`r8'
		  local Ahboxl =abs(`r5'*( `Ghsqrwt'[`i'] ))
		  local Ay1cord=`Aycen'+`Ahboxl' 
		  local Ax1cord=`Axcen'-`Ahboxl' 
		  local Ay2cord=`Aycen'-`Ahboxl' 
		  local Ax2cord=`Axcen'+`Ahboxl' 
		  if (`Axlpt' < `Axlo') | (`Axupt' > `Axhi')  {
* CI is on but not totaly on scale
			local Ayco1=`r5'*(`id'[`i']-0.1)+`r6'
			local Ayco2=`r5'*(`id'[`i']+0.1)+`r6'
			if `Axlpt' < `Axlo' {
			    local Axlpt =`Axlo'
			    local Axco1=`r7'*(`Gxlo')+`r8'
			    local Axco2=`r7'*(`Gxlo')+`r8'+350
			    gph line `Aycen' `Axco1' `Ayco1' `Axco2'
			    gph line `Aycen' `Axco1' `Ayco2' `Axco2'
			}
			if `Axupt' > `Axhi'  {
			    local Axupt =`Axhi'
			    local Axco1=`r7'*(`Gxhi')+`r8'
			    local Axco2=`r7'*(`Gxhi')+`r8'-350
			    gph line `Aycen' `Axco1' `Ayco1' `Axco2'
			    gph line `Aycen' `Axco1' `Ayco2' `Axco2'
			}
		  }
		  gph line `Aycen' `Axlpt' `Aycen' `Axupt'
		  if (`Ax1cord' >=`Axlo') & (`Ax2cord'<=`Axhi') {
		     gph box `Ay1cord' `Ax1cord' `Ay2cord' `Ax2cord' $MA_FBSH
		   }
		   else {local flag2=10}
		}
	   }
	   gph pen 1
	   if "`stats'"=="" {
		local e1=`effect'[`i']
		local e2=`lci'[`i']
		local e3=`uci'[`i']
		if (`e1'<1e-8) & "`log'"!="" {local e1 "<10^-8"}
		 else if (`e1'>1e8) & (`e1'!=.) & "`log'"!="" {local e1 ">10^8"}
		 else { local e1: displ %4.2f `e1' }
		if (`e2'<1e-8) & "`log'"!="" {local e2 "<10^-8"}
		 else if (`e2'>1e8) & (`e2'!=.) & "`log'"!=""  {local e2 ">10^8"}
		 else { local e2: displ %4.2f `e2' }
		if (`e3'<1e-8) & "`log'"!="" {local e3 "<10^-8"}
		 else if (`e3'>1e8) & (`e3'!=.) & "`log'"!="" {local e3 ">10^8"}
		 else { local e3: displ %4.2f `e3' }
		local esize "`e1' (`e2',`e3')"
		gph text `Aycen' `Axhi'  0 -1 `esize'
	   }
	 }
	 local tx = `label'[`i']
	 gph text `Aycen' 20 0 -1 `tx'
	 if "`wt'"=="" {
	   local weit: displ %4.1f `weight'[`i']
	   gph text `Aycen' `Ax2hi' 0 1 `weit'
	 }
	 if `use'[`i']==2 & "`stats'"=="" {
	   gph text `Aycen' `Axhi'  0 -1 (Excluded)
	 }
	 local i=`i'+1
	}
	if "`overall'"=="" { 
	   local Aycol=0.8*`r5'+`r6'
	   local Aycen=`r5'+`r6'
	   local Aycoh=1.2*`r5'+`r6'
	   local Aycenl1=`Aycen'
	   local Aycenl2=`Aycen'
	   local Aycenh1=`Aycen'
	   local Aycenh2=`Aycen'
	   local Axcol=`r7'*(`log'($S_3))+`r8'
	   local Axcen=`r7'*(`log'($S_1))+`r8'
	   local Axcoh=`r7'*(`log'($S_4))+`r8'
	   gph pen 3
	   if "`stats'"=="" {
		local e1: displ %4.2f $S_1
		local e2: displ %4.2f $S_3
		local e3: displ %4.2f $S_4
		local esize "`e1' (`e2',`e3')"
		gph text `Aycen' `Axhi'  0 -1 `esize'
	   }
	   gph text `Aycen' 20 0 -1 Overall ($OVE% CI)
	   if (`Axcen'<`Axlo') | (`Axcen'>`Axhi') { local flag3=10 }
	    else {
* phi is angle between diamond and y=1 in right angle triangle; use this
* fact to get y where diamond is chopped off at
		if `Axcol'<`Axlo' { 
		  local flag3=10
		  local tanphi=(0.2*`r5')/(`Axcen'-`Axcol')
		  local Aydiff=(`Axlo'-`Axcol')*`tanphi'
		  local Aycenl1=`Aycen'-`Aydiff'
		  local Aycenl2=`Aycen'+`Aydiff'
		  local Axcol=`Axlo'
		  gph line `Aycenl1' `Axcol' `Aycenl2' `Axcol'
		}
		if `Axcoh'>`Axhi' {
		  local flag3=10
		  local tanphi=(0.2*`r5')/(`Axcoh'-`Axcen')
		  local Aydiff=(`Axcoh'-`Axhi')*`tanphi'
		  local Aycenh1=`Aycen'-`Aydiff'
		  local Aycenh2=`Aycen'+`Aydiff'
		  local Axcoh=`Axhi'
		  gph line `Aycenh1' `Axcoh' `Aycenh2' `Axcoh'
		}
		gph line `Aycoh' `Axcen' `Aycenh2' `Axcoh' 
		gph line `Aycenh1' `Axcoh' `Aycol' `Axcen'
		gph line `Aycol' `Axcen' `Aycenl1' `Axcol' 
		gph line `Aycenl2' `Axcol' `Aycoh' `Axcen'
		gph pen 9
		local j =`r5'+`r6'
		local Adashl=`r5'*(`Gyhi'-1)/100
		local Ayhi =`r5'*`Gyhi'+`r6' 
		while `j'>`Ayhi' {
			local Aycol=`j'
			local Aycoh=`j'+`Adashl'
			gph line `Aycol' `Axcen' `Aycoh' `Axcen'
			local j=`j'+2*`Adashl'
		}
	    }
	}
	gph close
    }  /* end of qui section*/
    #delimit ;
    if `flag1'>1 { di in bl _n "Note: invalid xlabel(); graph has been 
rescaled"};
    if `flag2'>1 { di in bl _n "Warning: Some trials cannot be
represented graphically." _n "Consider using xlabel()"};
    if `flag3'>1 { di in bl _n "Warning: Overall effect size not fully 
represented graphically." _n "Consider using xlabel()"};
    #delimit cr
end

