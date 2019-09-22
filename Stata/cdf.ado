*! version 1.0.1 dgc Oct-95    STB-49 gr37
cap program drop cdf
program define cdf
    version 3.1
    local varlist "req ex min(1) max(1)"
    local weight "aweight fweight iweight pweight"
    local if "opt"
    local in "opt"
    local options "BY(string) L1(string) B2(string) NORMal SAMEsd XLOG * "
    parse "`*'"
    parse "`varlist'", parse(" ")
    local yv `1'
    if "`b2'"=="" {local b2 "`yv'"}
    if "`l1'"=="" {local l1 "Cumulative Probability"}

    preserve


    quietly {
	tempvar yvar w touse
	if "`xlog'"=="" {
	    gen `yvar' = `yv'
	}
	else {
	    gen `yvar' = log(`yv')
	}
	if "`weight'"=="" {
	    gen `w' = 1
	}
	else {
	    gen `w' `exp'
	}
	egen int `touse' = rmiss(`varlist' `w') `if' `in' 
	drop if `touse'>0 
	replace `touse'= 0
	replace `touse'=1 `if' `in'
	keep if `touse'
	keep `yv' `yvar' `w' `by'
	tempvar cw ccw grp sy ssy

	if "`by'"=="" {
	    sort `yvar'
	    gen `cw' = sum(`w')
	    if "`normal'"!="" {
		gen `sy' = sum(`w'*`yvar')
		replace `sy' = `yvar' - `sy'[_N]/`cw'[_N]
		gen `ssy' = sum(`w'*(`sy'^2))
		if "`weight'"=="" | "`weight'"=="`fweight'" {
		    replace `sy' = `sy'/sqrt(`ssy'[_N]/(`cw'[_N]-1))
		}
		else {
		    replace `sy' = `sy'/sqrt(`ssy'[_N]/`cw'[_N])
		}
		replace `sy' = normprob(`sy')
		replace `cw' = `cw'/`cw'[_N]
		local vlist "`cw' `sy'"
		local syms "ii"
		local connect "Js"
		local pen "21"
	    }
	    else {
		replace `cw' = `cw'/`cw'[_N]
		local vlist "`cw'"
		local syms "i"
		local connect "J"
		local pen "2"
	    }
	}
	else {
	    sort `by' `yvar'
	    by `by': gen `cw' = sum(`w')
	    by `by': gen int `grp' = (_n==1)
	    replace `grp' = sum(`grp')
	    if "`normal'"!="" {
		by `by': gen `sy' = sum(`w'*`yvar')
		by `by': replace `sy' = `yvar' - `sy'[_N]/`cw'[_N]
		if "`samesd'"=="" {
		    by `by': gen `ssy' = sum(`w'*(`sy'^2))
		    if "`weight'"=="`fweight'"|"`weight'"=="" {
			by `by':replace `sy'=`sy'/sqrt(`ssy'[_N]/(`cw'[_N]-1))
		    }
		    else {
			by `by':replace `sy'=`sy'/sqrt(`ssy'[_N]/`cw'[_N])
		    }
		}
		else {
		    gen `ccw' = sum(`w')
		    gen `ssy' = sum(`w'*(`sy'^2))
		    if "`weight'"=="`fweight'"|"`weight'"=="" {
			replace `sy'=`sy'/sqrt(`ssy'[_N]/(`ccw'[_N]-`grp'[_N]))
		    }
		    else {
			replace `sy'=`sy'/sqrt(`ssy'[_N]/`ccw'[_N])
		    }
		}
	    }
	    by `by': replace `cw' = `cw'/`cw'[_N]	
	    local group 1
	    while `group' <= `grp'[_N] {
		tempvar gsc
		gen `gsc' = `cw' if `group'==`grp'
		if "`normal'"=="" {		
		    local vlist "`vlist' `gsc'"
		    local syms "`syms'i"
		    local connect "`connect'J"
		    local group = `group'+1
		    local pen "`pen'`group'"
		}
		else {
		    tempvar gsd 
		    gen `gsd' = normprob(`sy') if `group'==`grp'
		    local vlist "`vlist' `gsc' `gsd'"
		    local syms "`syms'ii"
		    local connect "`connect'Js"
		    local group = `group'+1
		    local pen "`pen'`group'1"
		}
	    }
	    tempvar gsc
	    by `by': gen `gsc' = `cw' if _n==_N
	    local vlist "`vlist' `gsc'"
	    local syms "`syms'[`by']"
	    local connect "`connect'."
	    local pen "`pen'1"
	}
	replace `yv' = .  if _n<_N & `yvar'[_n]==`yvar'[_n+1]
    }
    graph `vlist' `yv', symbol(`syms') connect(`connect') pen(`pen') /*
	*/ b2(`b2') l1(`l1') `xlog' `options'
    end

