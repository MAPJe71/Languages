*! version 1.0.3 NJC 8 October 1997
* version 1.0.2 NJC 24 June 1997
program define hplotc
    version 5.0
    local if "opt"
    local in "opt"
	local weight "aweight fweight"
    #delimit ;
	local options "LEVel(integer $S_level) Poisson BINomial Exposure(string)
    Symbol(string) BY(string) Total TOTLeg(string) Legend(str) TItle(string)
    *" ;
    #delimit cr
    local varlist "max(1)"
    parse "`*'"
    if "`by'" == "" {
        di in r "by() option required"
        exit 100
    }
    confirm variable `by'

    preserve

    qui {
        if "`if'`in'" != "" { keep `if' `in' }
        * byvar2 == byvar with one fix
        byvar2 `by', macro(S_5 S_3 S_6) generate: /*
         */ ci `varlist' [`weight' `exp'] ,          /*
         */ level(`level') `poisson' `binomia' `exposur'
        tempvar tag
        sort `by'
        by `by' : gen `tag' = _n == 1

        if "`total'" == "total" {
	    	_crcci `varlist' [`weight' `exp'], /*
	    			*/ level(`level') `binomia' `poisson' `exposur'

            capture confirm string variable `by'
            if _rc == 7 {
                tempvar bystr
                capture decode `by', gen(`bystr')
                if _rc {
                    gen str1 `bystr' = ""
                    replace `bystr' = string(`by')
                }
                local by "`bystr'"
            }
            local np1 = _N + 1
            set obs `np1'
            if "`totleg'" == "" { local totleg "Total" }
            replace `by' = "`totleg'" in l
            replace _M_1 = $S_5 in l
            replace _M_2 = $S_3 in l
            replace _M_3 = $S_6 in l
            replace `tag' = 1 in l
        }

        label var _M_2 "mean"
        label var _M_1 "lower limit"
        label var _M_3 "upper limit"

        if "`legend'" == "" { local legend "`by'" }
        else if "`total'" == "total" {
            capture confirm string variable `legend'
            if _rc == 7 {
                tempvar strleg
                capture decode `legend', gen(`strleg')
                if _rc {
                    gen str1 `strleg' = ""
                    replace `strleg' = string(`legend')
                }
                local legend "`strleg'"
            }
            replace `legend' = "`totleg'"  in l
        }
    }

    if "`title'" == "" {
        local title : variable label `varlist'
        if "`title'" == "" { local title "`varlist'" }
    }
    if "`symbol'" == "" { local symbol "|1|" }
    hplot _M_* if `tag', l(`legend') sy(`symbol') ti(`title') `options'
end
