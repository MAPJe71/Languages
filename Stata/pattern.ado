*! version 1.1.0 (STB-33: sed2.1)
program define pattern
    version 4.0
    local varlist "req ex max(55)"
    local if "opt"
    local in "opt"
    local options "Detail"
    parse "`*'"
    parse "`varlist'", parse(" ")
    preserve
    tempvar touse
    mark `touse' `if' `in'
    qui keep if `touse'
    qui {
         keep `varlist'
         gen str1 PATTERN=""
         while "`1'" ~= "" {
              local type : type `1'
              if substr("`type'",1,1)=="s" {
                   replace PATTERN=PATTERN+"X" if `1'!=""
                   replace PATTERN=PATTERN+"." if `1'==""
                   if "`detail'" != "" {
                        count if `1'==""
                        noi di %5.0f _result(1) _skip(2) "missing values for variable " "`1'"
                   }
              }
              else {
                   replace PATTERN=PATTERN+"X" if `1'!=.
                   replace PATTERN=PATTERN+"." if `1'==.
                   if "`detail'" != "" {
                        count if `1'==.
                        noi di %5.0f _result(1) _skip(2) "missing values for variable " "`1'"
                   }
              }
              mac shift
         }
         sort PATTERN
         by PATTERN: gen COUNT=_N
         by PATTERN: keep if _n==_N
         egen SUM=sum(COUNT)
         gen PCT=(COUNT/SUM)*100
    }
    format PCT %5.2f
    format COUNT %5.0f
    list COUNT PCT PATTERN
    di ""
    di "Total: " SUM[_N]
end
