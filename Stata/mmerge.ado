*! 2.3.3  10jan2000  Jeroen Weesie/ICS
program define mmerge, rclass
	version 6.0

	syntax varlist using/ [, SImple TAble Type(str) UNMatched(str) /*
		*/ Missing(str) noSHow noLabel REPLACE UPDATE _MERGE(str)   /*
		*/ UKeep(str) UDrop(str) UIF(str) UMatch(str) URename(str)  /*
		*/ UName(str) ULabel(str) ]

	if "`simple'" != "" {
		OptionNo "`table'"        "table not allowed with simple"
		OptionNo `"`type'"'       "type() not allowed with simple"
		OptionNo `"`unmatched'"'  "unmatched() not allowed with simple"
		local type 1:1
		local unmatch both
	}
	else if "`table'" != "" {
		OptionNo `"`type'"'       "type() not allowed with table"
		OptionNo `"`unmatched'"'  "unmatched() not allowed with table"
		local type n:1
		local unmatch master
	}
	else {
		enumopt `"`type'"'  "Auto 1:1 1:n n:1 n:n SPread"  "type"
		local type `r(option)'

		enumopt `"`unmatch'"'  "Both Master Using None"    "unmatch"
		local unmatch `r(option)'
	}

	enumopt `"`missing'"'  "None Value Nomatch"  "missing"
	local missing `r(option)'


	if `"`ukeep'"' != "" & `"`udrop'"' != "" {
		di in re "options udrop() and ukeep() may not be combined"
		exit 198
	}
	if "`replace'" != "" & "`update'" == "" {
		di in re /*
		*/ "-replace- can only be specified in combination with -update-"
		exit 198
	}
	if `"`uname'"' != "" & `"`urename'"' != "" {
		di in re "options uname() and urename() may not be combined"
		exit 198
	}

	if `"`_merge'"' == "" {
		local _merge _merge
	}

	/* ------------------------------------------------------------------
	   prepare master
	   ------------------------------------------------------------------
	*/

	capture drop `_merge'
	quietly compress
	unab mmatch : `varlist'
	local nmmatch : word count `mmatch'

	* IsKey verifies that the key in the master is proper
	* as a side-effect, IsKey sorts on the match vars

	IsKey "`mmatch'" "`missing'"
	local mkey   `r(iskey)'
	local merror `r(error)'

	if ("`type'"=="1:1" | "`type'"=="simple" | "`type'"=="1:n") & /*
		*/ `mkey' == 0 {
		di in re "match-var in master should form a key"
		if "`merror'" == "dup" {
			di in re "error: duplicate values in match-var(s)"
			ShowDup "`mmatch'"
			exit 4002
		}
		else {
			di in re "error: missing values in match-var(s)"
			exit 4001
		}
	}

	quietly descr, short
	local m_obs = r(N)
	local m_var = r(k)

	unab mvar : _all
	DropList "`mvar'" "`mmatch'
	local mvar `r(list)' /* variables in master, excluding match vars */

	if "`missing'" == "nomatch" {
		/* algorithm note:
		   to avoid matching on missing values, I generate an extra
		   match variable _MISSNG that is 0 if non-missing, 1 if
		   missing in the master data and -1 in the using data
		*/
		confirm new var __MISSNG
		gen byte __MISSNG = 1
		markout __MISSNG `mmatch', strok
		qui replace __MISSNG = 1 - __MISSNG
		local missvar __MISSNG
		sort `mmatch' __MISSNG
	}
	else sort `mmatch'

	preserve

	/* ------------------------------------------------------------------
	   prepare -using- file, store it as tempfile UseOk
	   ------------------------------------------------------------------
	*/

	* name for match vars in using data
	local Umatch = cond(`"`umatch'"' != "", `"`umatch'"', "`mmatch'")

	if `"`uif'"' != "" {
		local Uif `"if `uif'"'
	}

	if `"`udrop'"' == "" & `"`ukeep'"' == "" {
		* ensure that Ukey is in using
		quietly use `Umatch' _all `Uif' using `"`using'"', replace
	}
	else if "`ukeep'" != "" {
		* only load Umatch and ukeep
		quietly use `Umatch' `ukeep' `Uif' using `"`using'"', replace
	}
	else {
		* process -udrop-, without loading full using dataset
		GetVars using `"`using'"'
		local varuse  `r(varlist)'
		capt unab udrop : `udrop'
		DropList "`varuse'" `"`udrop'"'
		quietly use `Umatch' `r(list)' `Uif' using `"`using'"', replace
	}

	quietly compress
	capt drop `_merge'

	/* verify whether umatch exist and is key in using data
	*/

	if `"`umatch'"' ~= "" {
		unab umatch : `umatch'
		local numatch : word count `umatch'
		if `nmmatch' != `numatch' {
			di in re /*
			*/ "#match-variables in master and using data should be equal"
			exit 4003
		}
		local Umatch `umatch'
	}
	else {
		unab tmp : `mmatch'
		if "`tmp'" ~= "`mmatch'" {
			di in re "`mmatch' do not occur -as such- in using data"
			exit 4007
		}
	}

	IsKey `"`Umatch'"'  "`missing'"
	local ukey   `r(iskey)'
	local uerror `r(error)'

	if ("`type'"=="1:1" | "`type'"=="simple" | "`type'"=="n:1") & /*
		*/ `ukey' == 0 {
		di in re "match-var in using data should form a key"
		if "`uerror'" == "dup" {
			di in re "error: duplicate values in match-var(s)"
			if "`type'" == "n:1" {
				di in re "Did you mix up match types n:1 and 1:n?"
			}
			ShowDup `"`Umatch'"'
			exit 4002
		}
		else {
			di in re "error: missing values in match-var(s)"
			exit 4001
		}
	}

	/* rename key variables in -using- to -mmatch-
	*/

	if `"`umatch'"' != "" {
		local i 1
		while `i' <= `nmmatch' {
			local v : word `i' of `mmatch'
			local u : word `i' of `umatch'
			if "`u'" != "`v'" {
				capt rename `u' `v'
				if _rc {
					di in re "impossible to rename `u' to `v' in using data"
					exit 4004
				}
			}
			local i = `i'+1
		}
		sort `mmatch'
	}

	/* rename non-match variables and modify labels in using data
	   note that, at this point, the match-vars are in -mmatch-
	*/

	if `"`uname'"' != "" {
		PrefName `"`uname'"' "`mmatch'"
	}

	if `"`urename'"' != "" {
		Rename `"`urename'"'
	}

	if "`ulabel'" ~= "" {
		PrefLab `"`ulabel'"' "_all"
	}

	/* some statistics on using data
	*/

	local fusing `"$S_FN"'
	quietly descr, short
	local u_obs = r(N)
	local u_var = r(k)

	unab uvar : _all
	DropList "`uvar'" `"`mvar' `mmatch'"'
	local uvar `r(list)'

	if "`missing'" == "nomatch" {
		confirm new var __MISSNG
		gen byte __MISSNG = 1
		markout __MISSNG `mmatch', strok
		qui replace __MISSNG = -1 + __MISSNG
		sort `mmatch' __MISSNG
	}

	tempfile UseOk
	quietly save `"`UseOk'"'

	/* ------------------------------------------------------------------
	   header describing files
	   ------------------------------------------------------------------
	*/

	restore

	* verify consistency type() and (mkey,ukey)
	if "`type'" == "spread" & `mkey'+`ukey' == 0 {
		di in re "matchvars should be key in master or using data"
		exit 4006
	}
	if "`type'" == "auto" & `mkey'+`ukey' == 0 {
		local type n:n
	}

	if "`show'" == "" {
		di
		DispSep
		di in gr "     matching type | " in ye "`type'"
		di in gr "mv's on match vars | " in ye "`missing'"
		di in gr "unmatched obs from | " in ye "`unmatch'"
		DispSep

		local fmaster `"$S_FN"'
		if `"`fmaster'"' =="" {
			local fmaster "<data in memory not named>"
		}
		di in gr "master        file | " in ye `"`fmaster'"'
		di in gr "               obs | " in ye %5.0f `m_obs'
		di in gr "              vars | " in ye %5.0f `m_var'
		di in gr "        match vars | " in ye "`mmatch'  " /*
			*/ in gr =cond(`mkey',"(key)", "(not a key)")
		DispSep

		if `"`uif'"' != "" {
			local iftxt `"  (selection: `uif')"'
		}
		if `"`udrop'`ukeep'"' != "" {
			local vartxt `"  (selection via udrop/ukeep)"'
		}
		di in gr "using         file | " in ye `"`fusing'"'
		di in gr "               obs | " in ye %5.0f `u_obs' /*
					*/ in gr `"`iftxt'"'
		di in gr "              vars | " in ye %5.0f `u_var' /*
					*/ in gr `"`vartxt'"'
		di in gr "        match vars | " in ye "`Umatch'  " /*
			*/ in gr =cond(`ukey',"(key)", "(not a key)")

		DispSep
		Common "`uvar'"
		DispSep
	}

	/* ------------------------------------------------------------------
	   actually merge master and using
	   ------------------------------------------------------------------
	*/

	if "`type'" != "n:n" {
		if "`unmatch'" == "none" | "`unmatch'" == "master" {
			local keep nokeep
		}
		* uncaptured, to show merge's error messages
		merge `mmatch' `missvar' using `"`UseOk'"' , /*
		*/ `label' `keep' `replace' `update' _merge(`_merge')
	}
	else {
		joinby `mmatch' `missvar' using `"`UseOk'"' , /*
		*/ `label' `keep' `replace' `update' _merge(`_merge') /*
		*/ unmatched(`unmatch')
	}

	capt drop __MISSNG
	DefLabel `_merge' `update'

	if "`type'" == "simple" {
		capt assert `_merge' == 3
		if _rc {
			di in re "unmatched obs not permitted with type==simple"
			tabv `_merge'
			exit 4005
		}
	}

	if "`unmatch'" == "none" | "`unmatch'" == "using" {
		capt drop if `_merge' == 1
	}

	if "`show'" == "" {
		quietly descr
		di in gr "result        file | " in ye `"`fmaster'"'
		di in gr "               obs | " in ye %5.0f r(N)
		di in gr "              vars | " in ye %5.0f r(k) /*
			*/ in gr "  (including `_merge')"
		DispSep
	}

	/* ------------------------------------------------------------------
	   handling of _merge
	   ------------------------------------------------------------------
	*/

	if "`missing'" != "value" {
		tempvar notmiss
		gen byte `notmiss' = 1
		markout `notmiss' `mmatch', strok
		qui replace `_merge' = - `_merge' /*
			*/ if (`_merge'==1 | `_merge'==2) & `notmiss'==0
	}

	* report _merge content with informative labels
	if "`simple'" != "" {
		di _n in gr "simple match merge successful"
	}
	else {
		capt assert `_merge'==3
		if !_rc {
			di _n in gr /*
			*/ "all observations come from master and using data (`_merge'==3)"
		}
		else tabl `_merge'
	}

	/* ------------------------------------------------------------------
	   returned values
	   ------------------------------------------------------------------
	*/

	return local  mfile  `fmaster'
	return local  mmatch `mmatch'
	return scalar mvar   = `m_var'
	return scalar mobs   = `m_obs'
	return scalar mkey   = `mkey'

	return local  ufile  `fusing'
	return local  umatch `Umatch'
	return scalar uvar   = `u_var'
	return scalar uobs   = `u_obs'
	return scalar ukey   = `ukey'

	return local  common `uvar'
end


/* ==========================================================================
   subroutines
   ==========================================================================
*/

/* OptionNo value text
   displays errror message -text- if value is defined
*/
program define OptionNo
	args value text
	if `"`value'"' != "" {
		di in re `"`text'"'
		exit 198
	}
end


/* DispSep
   displays seperation line in header table
*/
program define DispSep
	di in gr _dup(19) "-" "+" _dup(59) "-"
end


/* Common "usevar"
   displays the variables common to the master and using data
*/
program define Common
	args usevar

	tokenize "`usevar'"
	local i 1
	while "``i''" != "" {
		capt confirm var ``i''
		if !_rc {
			local common "`common' ``i''"
		}
		local i = `i'+1
	}

	if "`common'" == "" {
		di in gr "  common variables | none"
	}
	else {
		local lpiece : piece 1 58 of "`common'"
		di in gr "  common variables | " in ye "`lpiece'"
		local p 2
		local lpiece : piece `p' 58 of "`common'"
		while "`lpiece'" != "" {
			di _col(20) in gr "| " in ye "`lpiece'"
			local p = `p'+1
			local lpiece: piece `p' 58 of "`common'"
		}
	}
end


/* PrefName str skiplst
   prefixes str to the names of all variables in the data,
   expect those in skiplst
*/
program define PrefName
	args str skiplst

	unab vlist : _all
	tokenize "`vlist'"
	local i 1
	while "``i''" != "" {
		local tmp : subinstr local skiplst "``i''" "", /*
			*/ word count(local nch)
		if `nch' == 0 {
			local nname = substr(`"`str'``i''"', 1, 8)
			capt rename ``i'' `nname'
			if _rc {
				di in re "failure to rename ``i'' to `nname' in using data"
				exit 4004
			}
		}
		local i = `i'+1
	}
end


/* Rename speclst
   renames variables according to a specification
     oldname newname \ oldname newname ...
*/
program define Rename
	args speclst
	gettoken r rest : speclst, parse("\")
	while `"`r'"' != "" {
		if `"`r'"' != "\" {
			capt rename `r'
			if _rc {
				local r1 : word 1 of `r'
				local r2 : word 2 of `r'
				di in re `"failure to rename `r1' to `r2' in using data"'
				exit 4004
			}
		}
		gettoken r rest : rest, parse("\")
	}
end


/* DropList list droplst
   returns in r(list) the input list, without the words in droplst
*/
program define DropList, rclass
	args list droplst

	tokenize "`droplst'"
	local i 1
	while "``i''" != "" & `"`list'"' != "" {
		local list : subinstr local list "``i''" "" , word all
		local i = `i'+1
	}
	return local list `list'
end


/* PrefLab name varlist
   prefixes "name: " to the variable labels of the vars in varlist
*/
program define PrefLab
	args name varlist

	unab varlist : `varlist'
	tokenize "`varlist'"
	local i 1
	while "``i''" != "" {
		local vl : var label ``i''
		label var ``i'' `"`name': `vl'"'
		local i = `i'+1
	}
end


/* ShowDup key
   list obs with duplicate key values
*/
program define ShowDup
	args key

	tempvar X
	sort `key'
	qui by `key' : gen `X' = cond(_N==1, 0, _n==1)
	qui by `key' : gen __FREQ = _N
	di _n in gr "Non-unique key values"
	list `key' __FREQ if `X', noobs
end


/* IsKey varlist missing
   returns in r(iskey) whether varlist is a key
   if missing is -none-, it is verified that the varlist is never missing

   As a side-effect, the data are sorted on the varlist
*/
program define IsKey, rclass
	args varlist missing

	if "`missing'" == "none" {
		tempvar M
		gen byte `M' = 1
		markout `M' `varlist', strok
		capt assert `M'==1
		if _rc {
			return local iskey 0
			return local error missing
			exit
		}
	}

	sort `varlist'
	capt by `varlist' : assert _N==1
	if _rc {
		return local iskey 0
		return local error dup
	}
	else 	return local iskey 1
end


/* GetVars using filename
   returns in r(varlist) the varlist of filename
*/
program define GetVars, rclass
	syntax using/
	use `"`using'"' in 1, replace
	unab v : _all
	return local varlist `v'
end


/* DefLabel _merge update
   defines value labels for _merge, depending whether update-merging was
   specified. DefLabel takes care to ensure that the value label __MERGE
   does not exist, or was actually generated by mmerge, and hence may be
   overwritten (I used a signature method).
*/
program define DefLabel
	args _merge update

	capt label list __MERGE
	if !_rc {
		local l : label __MERGE 9999
		if "`l'" == "signature" {
			label drop __MERGE
		}
		else {
			di in bl "value label __MERGE for `_merge' already exists"
			exit
		}
	}

	if "`update'" == "" {
		#del ;
		label def __MERGE
			  -1  "matchvar==missing in master data"
			   1  "only in master data"
			  -2  "matchvar==missing in using data"
			   2  "only in using data"
			   3  "both in master and using data"
 			9999  "signature mmerge" ;
		#del cr
	}
	else {
		#del ;
		label def __MERGE
			  -1  "matchvar==missing in master data"
			   1  "only in master data"
			  -2  "matchvar==missing in using data"
			   2  "only in using data"
			   3  "in both, master agrees with using data"
			   4  "in both, missing in master data updated"
			   5  "in both, master disagrees with using data"
			9999  "signature" ;
		#del cr
	}
	label val `_merge' __MERGE
end
exit

error messages

  4001  improper key : missing values
  4002  improper key : duplicate values
  4003  number of key variables in master and using are not equal
  4004  impossible to rename in using data
  4005  unmatched obs not permiited with type==simple
  4006  matchvars should be key in master or using data
  4007  keyvars should be specified unabbreviately

Alternative Header

---------------------+-----------------------------------------------------------
       matching type | n:1
  mv's on match vars | none
  unmatched obs from | master
---------------------+-----------------------------------------------------------
  master        file | \mystata\doc\hn95data.dta
                 obs |  1534
                vars |    23
          match vars | city religion  (not a key)
  -------------------+-----------------------------------------------------------
  using         file | \mystata\doc\cityregi.dta
                 obs |  6400
                vars |     3  (selection via udrop/ukeep)
          match vars | idcity idrelig  (key)
  -------------------+-----------------------------------------------------------
    common variables | none
---------------------+-----------------------------------------------------------
  result        file | \mystata\doc\hn95data.dta
                 obs |  1534
                vars |    25  (including _merge)
            ---------+-----------------------------------------------------------
              _merge |     76 obs in master with matchvar==missing (code -1)
					      |    257 obs only in master data              (code  1)
					      |   1201 obs both in master and using data    (code  3)
---------------------+-----------------------------------------------------------

Todo list
  * #vars should be number of non-match vars
  * improve readability of output
  * check what I do/should do if vars become -common- by rename.
