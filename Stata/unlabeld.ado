*! 1.1.0 (Dec 20, 1996) Jeroen Weesie/ICS STB-37 dm47
*  -- added option -incomp--
*  1.0.0 (Oct 28, 1996) Jeroen Weesie/ICS

* reports whether all values of variables are completely labeled
capture program drop unlabeld
program define unlabeld
    version 5.0

    local varlist "opt"
    local if      "opt"
    local in      "opt"
    local options "Any Incompl"    
    parse "`*'"
    parse "`varlist'", p(" ")
    
    tempvar first touse
    mark `touse' `if' `in'    

    di _n in gr "Variable | Label    | #val   unlabeled values"
    di    in gr "---------+----------+" _dup(58) "-"

    local ninc 0
    while "`1'" != "" {
        local vtype : type `1'
        if substr("`vt'",1,3) != "str" {        /* numeric variable */
            local vlabel: value label `1'
            if "`vlabel'" != "" | "`any'" != "" { 

              * count distinct values  

                sort `1' `touse'
                quiet by `1' `touse' : gen byte `first' = -(_n==1)
                quiet replace `first' = . if `1'==. | `touse'==0
                quiet count if `first' == -1
                local N = _result(1)

                if "`vlabel'" == "" {
                    di in gr "`1'" _col(10) "|          | " in ye %4.0f `N' 
                } 
                else {
    
                  * loop over all distinct values of `1', collecting unlabeled
                  * values in the macro -nolab-

                    sort `first' `1'
                    local i 1
                    while `first'[`i'] == -1 {
                        local v = `1'[`i'] 
                        local vl : label `vlabel' `v'
                        if "`vl'" == "`v'" { local nolab "`nolab' `v'" }
                        local i =`i'+1
                    }

                  * display results

                    local N2 : word count `nolab'
                    if `N2' > 0 | "`incompl'" == "" {
                        di in gr "`1'" _col(10) "| `vlabel'" _col(21) "|"/* 
                           */ _col(23) in ye %4.0f `N' _c
                        if "`nolab'" != "" { 
                            showlist "`nolab'" 
                            local ninc = `ninc' + 1 
                        }    
                        else display
                    }
                }
                drop `first'
                local nolab
            }
        }
        mac shift
    }        
    global S_1 `ninc'    
end

* used to display the words of the macro nolab, wrapping if necessary
program define showlist
    version 5.0
    local list "`1'"    
    parse "`list'", p(" ")
    local c 4    
    local L    
    while "`1'" != "" {
        if length("`L'`1' ") < 80-30 { 
            local L "`L'`1' " 
        }
        else {
            di _col(`c') in wh "`L'"
            local L
            local c 30
        }
        mac shift
    }
    if "`L'"!="" {  di _col(`c') in wh "`L'" }
end
exit
