*  version 1.0.0  TJS 24oct97   STB-41 sbe19
*! version 1.1.2  TJS 21apr98   Unweighted Egger analysis only   STB-44 sbe19.1

program define metabias
     version 5.0

if ("`*'" == "") {
  di "Syntax is:"
  di in wh "metabias " in gr "{ theta { se | var } | " _c
  di in gr "exp(theta) | ll ul [cl] } [" _c
  di in wh "if " in gr "exp] [" in wh "in " in gr "range]"
  di in gr "         [ " in wh ", by(" in gr "by_var"_c
  di in wh ") g" in gr "raph" in wh "(" in gr "{ " in wh "b" _c
  di in gr "egg | " in wh "e" in gr "gger }" in wh ") lev" _c
  di in gr "el" in wh "(" in gr "#" in wh ") " in gr "{ " _c
  di in wh "v" in gr "ar | " in wh "ci" in gr " } " _c
  di _n in gr "           graph_options ]"
  di _n in gr "           where { a | b |...} means choose" _c
  di in gr " one and only one of {a, b, ...}"
  exit
  }

* Setup
local varlist "req ex min(2) max(4)"
local if "opt"
local in "opt"
local options "Graph(str) Vari CI BY(str) LEVel(integer $S_level) *"
parse "`*'"
parse "`varlist'", parse(" ,")

tempvar byg touse theta setheta var w sw vt wtheta swtheta
tempvar zz Ts wl swl RRm bylabel
tempname k ks sdks p zu pcc zcc c sks svks sk oe sbv sv

local theta   `1'
local setheta `2'

* input error traps
if "`ci'" != "" & "`vari'" != "" {
     di _n in re "Error: options 'ci' and 'var' cannot " _c
     di in re "be specified together."
     exit
}
if "`ci'" == "ci" & "`3'" != "" {
     di _n in bl "Note: option 'ci' specified."
}
if "`ci'" == "ci" & "`3'" == "" {
     di _n in re "Error: option 'ci' specified but varlist " _c
     di in re "has only 2 variables."
     exit
}
if "`ci'" != "ci" & "`vari'" != "vari" & "`3'" != "" {
     di _n in bl "Warning: varlist has 3 variables but option " _c
     di in bl "'ci' not specified; 'ci' assumed."
     local ci "ci"
     local vari ""
}
if "`vari'" == "vari" & "`3'" != "" {
     di _n in re "Error: option 'var' specified but varlist " _c
     di in re "has more than 2 variables."
     exit
}
if "`vari'" == "vari" & "`3'" == "" {
     di _n in bl "Note: option 'var' specified."
}
if "`vari'" != "vari" & "`3'" == "" {
     di _n in bl "Note: default data input format (theta, " _c
     di in bl "se_theta) assumed."
}

* Select data to analyze
mark `touse' `if' `in'
markout `touse' `theta' `setheta' `3'

preserve                /* Note: data preserved here */

* Generate `by' groups
if "`by'" != "" {
  confirm var `by'
  sort `by'
  qui by `by': gen byte `byg' = _n==1
  qui replace `byg' = sum(`byg')
  local byn = `byg'[_N]
  }
else {
  qui gen byte `byg' = 1
  local byn = 1
  }

* Generate `by' labels -- if required
if ("`by'" != "") {
  capture decode `by', gen(`bylabel')
  if _rc != 0 {
    local type : type `by'
    if substr("`type'",1,3) != "str" { 
      qui gen str8 `bylabel' = string(`by')
      }
    else { qui gen `type' `bylabel' = `by' }
    }
  }

* Do calculations
* initial calculations...
if "`vari'" == "vari" { qui replace `setheta' = sqrt(`setheta')}

if "`ci'" == "ci" {
  capture confirm variable `4'
  if _rc~=0 { qui gen `zz'  = invnorm(.975) }
  else { qui replace `4' = `4' * 100 if `4' < 1
    qui gen `zz' = -1 * invnorm((1- `4' / 100) / 2 )
    qui replace `zz' = invnorm(.025) if `zz'==.
    }
  qui replace `setheta' = ( ln(`3') - ln(`2')) / 2 / `zz'
  qui replace `theta'   = ln(`theta')
  }

if "`if'" != "" { ifexp "`if'" }

if "`by'" != "" {
  scalar `sk'   = 0
  scalar `sks'  = 0
  scalar `svks' = 0
  scalar `sbv'  = 0
  scalar `sv'   = 0
  }

* loop through by-values
local j = 1
while `j' <= `byn' {      /* start of loop for each `by' group */

summ `touse' if `touse' & `byg' == `j', meanonly
local data = _result(1)

* Calculate stats
  qui {
    gen  `var'     = `setheta'^2
    gen  `w'       = 1/`var'
    egen `sw'      = sum(`w') if `touse' & `byg' == `j'
    gen  `vt'      = `var' - 1 / `sw'
    gen  `wtheta'  = `w' * `theta'
    egen `swtheta' = sum(`wtheta') if `touse' & `byg' == `j'
    gen  `Ts'      = (`theta' - `swtheta' / `sw') / sqrt(`vt')
    gen  `wl'      = `w' * `theta'
    egen `swl'     = sum(`wl') if `touse' & `byg' == `j'
    gen  `RRm'     = `swl' / `sw'
    scalar `oe'    = `RRm'
    }

  qui capture ktau2 `var' `Ts' if `touse' & `byg' == `j'
  if _rc == 0 {
    scalar `k'    = $S_1
    scalar `ks'   = $S_4
    scalar `sdks' = $S_5
    scalar `p'    = $S_6
    scalar `zu'   = $S_7
    scalar `pcc'  = $S_8
    scalar `zcc'  = $S_9
    scalar `c'    = $S_10
    }
  else if _rc == 2001 {
    scalar `k'    = `data'
    scalar `ks'   = .
    scalar `sdks' = .
    scalar `p'    = .
    scalar `zu'   = .
    scalar `pcc'  = .
    scalar `zcc'  = .
    scalar `c'    = .
    }
  else { 
    di in re "error " _rc " in call to ktau2" 
    exit 
  }

  if "`by'" != "" & `k' > 1 {
    scalar `sk'   = `sk'   + `k'
    scalar `sks'  = `sks'  + `ks'
    scalar `svks' = `svks' + `sdks'^2
    }

* Egger's bias test
  tempvar prec snd
  qui gen `prec'= 1 / `setheta'
  qui gen `snd' = `theta' / `setheta'
  qui regr `snd' `prec' if `touse' & `byg' == `j'
  capture matrix b = get(_b)
  if _rc == 0 {
    local df = _result(1) - 2
    local bias = b[1,2]
    capture matrix V = get(VCE)
    if _rc == 0 {
      local pb = tprob(`df', b[1,2] / sqrt(V[2,2]))
      if "`by'" != "" {
        scalar `sbv' = `sbv' + `bias' / V[2,2]
        scalar `sv'  = `sv' + 1 / V[2,2]
        }
      }
    }
  else {
    local bias = .
    local pb = .
    }

* Display results

  if "`by'" != "" {
* use this display if a by_var was specified...
* .....display output header
    if `j' == 1 {
      di " "
      di in gr "Tests for Publication Bias"
      di " "
      local sp = 8 - length("`by'")
      #delimit ;
      di in gr "-------------------------------------------------"
	   "------------------------------" ;
      di in gr "         |      |    Begg's           Begg's"
	   "       cont. corr.  |    Egger's " ;
      di in gr _skip(`sp') "`by' |    n | score    s.d.      z"
        "      p        z      p   |  bias     p" ;
      di in gr "---------+------+--------------------------------"
	   "---------------+--------------" ;
      #delimit cr
      local scs " "
      }

    local sp = 8 - length(`bylabel')

    if `c' == 1 {
      local cs  "*"
      local scs "*"
      }
    else {local cs " "}
* .....display results for each by-value
    if `data' > 0 {
      di in gr _skip(`sp') `bylabel' " | " in ye %4.0f `k' _c
      di in gr " |" in ye %4.0f `ks' in gr "`cs'   " _c
      di in ye %6.3f `sdks' "  " %6.2f `zu' "  " %6.3f `p' "  " _c
      di in ye %6.2f `zcc'  "  " %6.3f `pcc' in gr " |" _c
      di in ye %6.2f `bias' "  " %6.3f `pb'
      }
* .....do stratified calculations
    if `j' == `byn' {
      scalar `zu'  = `sks' / sqrt(`svks')
	 scalar `p'   = 2 * (1 - normprob(abs(`zu')))
      scalar `zcc' = sign(`sks')*(abs(`sks') - 1) / sqrt(`svks')
      scalar `pcc' = 2 * (1 - normprob(abs(`zcc')))
      scalar `k'    = `sk'
      scalar `ks'   = `sks'
      scalar `sdks' = sqrt(`svks')
      drop   `sw' `wl' `swl' `RRm'
      qui egen   `sw'   = sum(`w') if `touse'
      qui gen    `wl'   = `w' * `theta'
      qui egen   `swl'  = sum(`wl') if `touse'
      qui gen    `RRm'  = `swl' / `sw'
      scalar `oe'   = `RRm'

      qui regr `snd' `prec' if `touse'
      capture matrix b = get(_b)
      if _rc == 0 {
        matrix V = get(VCE)
        local df = _result(1) - 2
        local bias = b[1,2]
        local pb = tprob(`df', b[1,2]/sqrt(V[2,2]))
        }
      else {
        local bias = .
        local pb = .
        }

      local bias = `sbv' / `sv'
      local pb   = 1 - normprob(`bias' / sqrt(1 / `sv'))

* .....and display overall (stratified) results
      di in gr "---------+------+----------------------------" _c
      di in gr "-------------------+--------------"
      di in gr " overall | " in ye %4.0f `sk' _c
      di in gr " |" in ye %4.0f `sks' in gr "`scs'   " _c
      di in ye %6.3f sqrt(`svks') "  " %6.2f `zu' "  " %6.3f `p' _c
      di in ye "  " %6.2f `zcc'  "  " %6.3f `pcc' in gr " |" _c
      di in ye %6.2f `bias' "  " %6.3f `pb'
      di in gr "---------------------------------------------" _c
      di in gr "----------------------------------"
      if "`scs'" == "*" {
        di in gr _skip(21) "`scs' (corrected for ties)"
        }
      }
    }

  else {

* use this display if no by_var was specified...
* Begg's
    di _n in gr "Tests for Publication Bias"
    di _n in gr "Begg's Test"
    di " "
    di    in gr "  adj. Kendall's Score (P-Q) = " in ye %7.0f `ks'
    di _c in gr "          Std. Dev. of Score = " in ye %7.2f `sdks'
    if `c' == 1 { di in gr " (corrected for ties)" }
    else {di " "}
    di    in gr "           Number of Studies = " in ye %7.0f `k'
    di    in gr "                          z  = " in ye %7.2f `zu'
    di    in gr "                    Pr > |z| = " in ye %7.3f `p'
    di _c in gr "                          z  = " in ye %7.2f `zcc'
    di    in gr " (continuity corrected)"
    di _c in gr "                    Pr > |z| = " in ye %7.3f `pcc'
    di    in gr " (continuity corrected)"

* Egger's
    tempvar prec snd
    qui gen `prec'= 1 / `setheta'
    qui gen `snd' = `theta' / `setheta'
    qui regr `snd' `prec' if `touse'
    capture matrix b = get(_b)
    if _rc == 0 {
      matrix V = get(VCE)
      local obs = _result(1)
      local df = `obs' - 2
      matrix colnames b = slope bias
      matrix rownames V = slope bias
      matrix colnames V = slope bias
      matrix post b V, dep(Std_Eff) dof(`df') obs(`obs')
      di _n in gr "Egger's test"
      matrix mlout, level(`level')
      }
    else { 
      di _n in gr "Egger's Test" _n
      di    in ye "  - undefined for only 1 study"
      }
    }

  cap drop `var' `w' `sw' `vt' `wtheta' `swtheta' 
  cap drop `Ts' `wl' `swl' `RRm'
  local j = `j' + 1

}                            /* end of loop for each `by' group */

* Graph a bias plot
local g = lower(substr("`graph'",1,1))
if "`g'" == "b" { 
  beggph `theta' `setheta' `touse', level(`level') `ci' `options'
  }
if "`g'" == "e" {
  egggph `theta' `setheta' `touse', level(`level') `options'
  }

* Save key values
global S_1 = `k'
global S_2 = `ks'
global S_3 = `sdks'
global S_4 = `p'
global S_5 = `pcc'
global S_6 = `bias'
global S_7 = `pb'
global S_8 = `oe'

exit
end

* ***************************************************

program define beggph
     version 5.0

* creates the Begg funnel plot graph

* Setup
local varlist "req ex min(3) max(3)"
local if "opt"
local in "opt"
#delimit ;
local options "CI L1Title(str) L2Title(str)
  Connect(str) Symbol(str) SOrt Pen(str)
  T2Title(str) B2Title(str) YLAbel(str)
  XLAbel(str) LEVel(integer $S_level) GAp(str)*";
#delimit cr
parse "`*'"
parse "`varlist'", parse(" ,")

tempvar touse theta setheta

local theta    `1'
local setheta  `2'
local touse    `3'

preserve

* Graph options
  if "`connect'" == "" { local connect "lll." }
  else {
    local lll = length("`connect'")
    if      `lll' == 1 { local connect "`connect'll." }
    else if `lll' == 2 { local connect "`connect'l." }
    else if `lll' == 3 { local connect "`connect'." }
    }
  local connect "co(`connect')"

  if "`symbol'" == "" { local symbol "iiio" }
  else {
    local lll = length("`symbol'")
    if      `lll' == 1 { local symbol "`symbol'iio" }
    else if `lll' == 2 { local symbol "`symbol'io" }
    else if `lll' == 3 { local symbol "`symbol'o" }
    }
  local symbol "sy(`symbol')"

  if "`pen'" == "" { local pen "3552" }
  else {
    local lll = length("`pen'")
    if      `lll' == 1 { local pen "`pen'552" }
    else if `lll' == 2 {
      local pen = "`pen'" + substr("`pen'",2,1) + "2"
      }
    else if `lll' == 3 { local pen "`pen'2" }
    }
  local pen "pen(`pen')"

  if "`l2title'" == "" {
    local l2title : variable label `theta'
    if "`l2title'" == "" { local l2title "`theta'" }
    }
  if "`ci'" == "" { local l2title "l2(`l2title')" }
  else            { local l2title "l2(log[`l2title'])" }

  if "`l1title'" == "" { local l1title "" "" }
  local l1title "l1(`l1title')"

  if "`b2title'" == "" {
    local b2title : variable label `theta'
    if "`b2title'" == "" { local b2title "`theta'" }
    }
  if "`ci'" == "" { local b2title = "b2(s.e. of: `b2title')" }
  else            { local b2title = "b2(s.e. of: log[`b2title'])" }

  if "`t2title'" == "" {
    local t2title = "Begg's funnel plot with pseudo"
    local t2title = "`t2title' `level'% confidence limits"
    }
  else if "`t2title'" == "." {     /* "." means blank it out */
    local t2title ""  ""
    }
  local t2title "t2(`t2title')"

  if "`xlabel'" == "" { local xlabel "xla" }
  else { local xlabel "xlabel(`xlabel')" }

  if "`ylabel'" == "" { local ylabel "yla" }
  else { local ylabel "ylabel(`ylabel')" }

  if "`sort'" == "" { local sort "sort" }

  if "`gap'" == "" { local gap "gap(3)" }
  else { local gap "gap(`gap')" }

  tempvar ll2 ul2 z mmm var w sw wl swl RRm 
  tempname oe 

  qui {
    if `level' < 1 { local `level' =`level' * 100 }
    local z  = -1 * invnorm((1 - `level' / 100) / 2)
    local obs1=_N+1
    set obs `obs1'
    replace `setheta'=0 in `obs1'
    replace `theta' = . in `obs1'
    gen     `var' = `setheta'^2
    gen     `w'   = 1/`var'
    egen    `sw'  = sum(`w') if `touse'
    gen     `wl'  = `w' * `theta'
    egen    `swl' = sum(`wl') if `touse'
    gen     `RRm' = `swl' / `sw'
    scalar  `oe'  = `RRm'
    egen    `mmm' = min(`RRm')
    replace `RRm' = `mmm' if `setheta' == 0
    gen     `ll2' = `RRm' - `z' * `setheta'
    gen     `ul2' = `RRm' + `z' * `setheta'
    }

  #delimit ;
  graph `RRm' `ll2' `ul2' `theta' `setheta' if `touse',
    `connect' `symbol' `t2title' `l2title' `b2title'
    `l1title' `xlabel' `ylabel' `sort' `pen' `gap' `options';
  #delimit cr

exit
end

* ***************************************************

program define egggph
     version 5.0

* creates the Egger regression asymmetry plot graph

* Setup
local varlist "req ex min(3) max(3)"
local if "opt"
local in "opt"
#delimit ;
local options "LEVel(integer $S_level) GAp(str)
  Connect(str) Symbol(str) SOrt Pen(str)
  T2Title(str) B2Title(str) YLAbel(str)
  L1Title(str) L2Title(str) XLAbel(str) *";
#delimit cr
parse "`*'"
parse "`varlist'", parse(" ,")

tempvar touse theta setheta

local theta   `1'
local setheta `2'
local touse   `3'

preserve

* Graph options
  if "`connect'" == "" { local connect ".ll" }
  else {
    local lll = length("`connect'")
    if      `lll' == 1 { local connect "`connect'll" }
    else if `lll' == 2 { local connect "`connect'l" }
    }
  local connect "co(`connect')"

  if "`symbol'" == "" { local symbol "oid" }
  else {
    local lll = length("`symbol'")
    if      `lll' == 1 { local symbol "`symbol'id" }
    else if `lll' == 2 { local symbol "`symbol'd" }
    }
  local symbol "sy(`symbol')"

  if "`pen'" == "" { local pen "233" }
  else {
    local lll = length("`pen'")
    if      `lll' == 1 { local pen "`pen'33" }
    else if `lll' == 2 {local pen = "`pen'" + substr("`pen'",2,1)}
    }
  local pen "pen(`pen')"

  if "`l2title'" == "" { local l2title "standardized effect" }
  local l2title "l2(`l2title')"

  if "`l1title'" == "" { local l1title "" "" }
  local l1title "l1(`l1title')"

  if "`b2title'" == "" { local b2title "precision" }
  local b2title = "b2(`b2title')"

  if "`t2title'" == "" {
    local t2title = "Egger's publication bias plot"
    }
  else if "`t2title'" == "." {     /* "." means blank it out */
    local t2title ""  ""
    }
  local t2title "t2(`t2title')"

  if "`xlabel'" == "" { local xlabel "xla" }
  else { local xlabel "xlabel(`xlabel')" }

  if "`ylabel'" == "" { local ylabel "yla" }
  else { local ylabel "ylabel(`ylabel')" }

  if "`sort'" == "" { local sort "sort" }

  if "`gap'" == "" { local gap "gap(3)" }
  else { local gap "gap(`gap')" }

  qui {
    local obs1 = _N + 1
    local obs2 = _N + 2
    local obs3 = _N + 3
    set obs `obs3'
    replace `setheta' = 0 in `obs1'/`obs3'
    replace `theta'   = . in `obs1'/`obs3'
    tempvar prec snd
    gen `prec' = 1 / `setheta' if `setheta' > 0
    gen `snd' = `theta' / `setheta' if `setheta' > 0
    replace `prec' = 0 if `prec' == .
    regr `snd' `prec' if `touse'
    tempvar reg ci
    capture matrix b = get(_b)
    if _rc == 0 {
      matrix V = get(VCE)
      local df = _result(1) - 2
      gen `reg' = b[1,2] + `prec' * b[1,1]
      gen `ci' = .
      #delimit ;
      replace `ci' = b[1,2] - sqrt(V[2,2])
        * invt(`df', `level'/100) in `obs2' ;
      replace `ci' = b[1,2] + sqrt(V[2,2])
        * invt(`df', `level'/100) in `obs3' ;
      #delimit cr
      }
    else {
      gen `reg' = . 
      gen `ci' = .
      }
    } 

  #delimit ;
  graph `snd' `reg' `ci' `prec' if `touse', yli(0) xli(0)
    `connect' `symbol' `t2title' `l2title' `b2title'
    `l1title' `xlabel' `ylabel' `sort' `pen' `gap' `options';
  #delimit cr

exit
end
