; The 8051/8052 Microcontroller
; ISBN: 1-58112-459-7
; Author: Craig Steiner
; Paragraph 11.1:
;   Comment must always start with a semicolon.
;   A label may start at the beginning of the line or after any number of blank
;   spaces or tabs. Likewise, an instruction may start in any column of the line
;   as long as it follows any label that may also be on that line.
;   Labels are case sensitive, may generally include uppercase and lowercase
;   alphabetic characters, numbers, the underscore character, and the dollar sign.
;   Labels must never start with a digit, nor may they contain spaces.

; label w/o instruction and comment
VALID1:

; line w/ label and instruction
VALID2: MOV A,#25h

; line w/ instruction and comment
        MOV A,#25h ;This is a comment

; Line w/ label and a comment
Valid3:;This is a comment
Valid3_1spc: ;This is a comment
Valid3_2spc:  ;This is a comment
Valid3_3spc:   ;This is a comment
Valid3_1tab:	;This is a comment
Valid3_2tab:		;This is a comment
Valid3_3tab:			;This is a comment

; Lines w/ just a comment
 ;This is a comment
  ;This is a comment
   ;This is a comment
    ;This is a comment
        ;This is a comment
	;This is a comment
		;This is a comment
			;This is a comment
				;This is a comment

; Line w/ a comment indicator w/o comment
;
 ;
  ;
   ;
    ;
        ;


Valid4:
Valid_5:

$Valid6:
Valid$7:
_Valid8:
Valid9_:
_Valid10_:

Valid20:
 Valid20_1spc:
  Valid20_2spc:
   Valid20_3spc:
    Valid20_4spc:
	Valid20_1tab:
		Valid20_2tab:
			Valid20_3tab:
				Valid20_4tab:

50_Invalid:         ;INVALID! Labels can not start with a digit.
Invalid Label51:    ;INVALID! Labels can not contain spaces.
Invalid-52:         ;INVALID! Labels can not contain hyphens.

; End of File
