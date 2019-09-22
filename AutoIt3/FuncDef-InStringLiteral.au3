;------------------------------
; String literal containing function definition

Local $TextDoubleQuoted_1 = "Func ShouldNotList_String_1() Return 0 EndFunc"

Local $TextDoubleQuoted_2 =
    "Func ShouldNotList_String_2()" &
    "    Return 0" &
    "EndFunc"

Local $TextSingleQuoted_1 = 'Func ShouldNotList_String_3() Return 0 EndFunc'

Local $TextSingleQuoted_2 =
    'Func ShouldNotList_String_4()' &
    '    Return 0' &
    'EndFunc'
