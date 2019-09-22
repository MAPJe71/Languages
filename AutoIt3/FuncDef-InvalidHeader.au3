;------------------------------
; Invalid function header

; Requires a parameter list which can be empty i.e. missing parentheses
func ShouldNotList_InvalidHeader_1
    Return 0
endfunc

; First character of function identifier can not be a digit
func 2ShouldNotList_InvalidHeader_2()
    Return 0
endfunc

; Hyphen not a valid function identifier character
func ShouldNotList-InvalidHeader_3()
    Return 0
endfunc
