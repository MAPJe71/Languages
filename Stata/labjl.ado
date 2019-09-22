*! version 1.1 29nov2000
*! utility to change value labels such that value and label are combined
*!    or to remove the value again, once added 
*! author Jens M. Lauritsen  

program define labjl
	version 6
	syntax varlist(min=1) [, Remove Add N(int 26) ALign]

local type = "add"
if "`remove'" != "" {local type = "remove" }
local done = "-"        /* string to note which labels were changed */

tokenize `varlist'
while "`1'" != "" {
*   look at next variable and label name
 		local vallab: value label `1' 
		if "`vallab'" == "" | index("`done'","`vallab'") > 0 { 
            mac shift       }   /* move to next value label */
       else {
        /*start the conversion*/ 
   	   if "`type'" == "add" {         
            local ln : label `vallab' maxlength
		    local i = 0
		    while `i' < `n' {
	        	local labx: label `vallab' `i'
                if "`labx'" != "`i'" {
                    if substr("`labx'",1,index("`labx'"," ")-1) != "`i'" {
                    if "`align'" != "" {         /* then fill in blanks to align labels in tabulate*/
                    local b = `ln'-length("`labx'")
                    local out1 = "."+substr("                              ",1,`b')
                    local out = "`i' `out1'`labx'"
                    local out = substr("`out'",1,index("`out'"," "))+substr("`out'",index("`out'",".")+1,80)}
                    else {local out = "`i' `labx'"}
                    label def `vallab' `i' "`out'", modify 
                    }
			    }
            local i = `i' + 1 } 
        di in yel "Numerical codes " in wh "added" in yel " to Label: `vallab'"

            }
         else if "`type'" == "remove"  {    /* remove the first "word" from label set */
		    local i = 0
    		    while `i' < `n' {
            	local labx: label `vallab' `i'
                if "`labx'" != "`i'" {
                    if substr("`labx'",1,index("`labx'"," ")-1) == "`i'" {
                    local out = substr("`labx'", index("`labx'"," ")+1,100)
                    label def `vallab' `i' "`out'", modify }
			    }
                local i = `i' + 1 } 
        di in yel "Numerical codes " in wh "removed" in yel " from Label: " in wh "`vallab'"
         }
        local done = "`done'  `vallab'"
      }      
	macro shift        /* next variable */
}

end
