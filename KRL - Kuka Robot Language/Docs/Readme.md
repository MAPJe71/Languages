
# KRL - KUKA Robot Language

## Description


## Links

_WWW_

_Wiki_


## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~


## Identifiers


## String Literals

### Single quoted

### Double quoted

### Document String - Double or Single Triple-Quoted

### Backslash quoted


## Comment

### Single line comment

### Multi line comment

### Block comment

### Java Doc

### Here Doc

### Now Doc


## Classes & Methods


## Function


## Grammar

BNF | ABNF | EBNF | XBNF
[KRL] ---------------------------------------------------------------------
@=KRL (KUKA Robot Language) - Robot Programming Language by KUKA

_WWW_=https://www.kuka.com/

_Wiki_=

Keywords=

   AND ANIN ANOUT
   BOOL BRAKE B_AND B_EXOR B_NOT B_OR
   CASE CAST_FROM CAST_TO CCLOSE CHAR CHANNEL CIRC CIRC_REL CONST CONFIRM CONTINUE COPEN CREAD CWRITE C_DIS C_ORI C_PTP C_VEL
   DECL DEF DEFAULT DEFDAT DEFFCT DELAY DIGIN DISTANCE DO
   ELSE END ENDDAT ENDFCT ENDFOR ENDIF ENDLOOP ENDSWITCH ENDWHILE ENUM EXIT EXOR EXT EXTFCT
   FALSE FOR
   GLOBAL GOTO
   HALT
   IF IMPORT INT INTERRUPT IS
   LIN LIN_REL LOOP
   MAXIMUM MINIMUM
   NOT
   OR
   PRIO PTP PTP_REL PUBLIC PULSE
   REAL REPEAT RESUME RETURN
   SEC SIGNAL SREAD STRUC SWITCH SWRITE
   THEN TO TRIGGER TRUE
   UNTIL
   WAIT WHEN WHILE

   A RegEx to find them all:

       \b(?!(?-i:
           AN(?:D|IN|OUT)
       |   B(?:OOL|RAKE|_(?:AND|EXOR|NOT|OR))
       |   C(?:ASE|AST_(?:FROM|TO)|CLOSE|HA(?:R|NNEL)|IRC(?:_REL)?|ON(?:ST|FIRM|TINUE)|OPEN|READ|WRITE|_(?:DIS|ORI|PTP|VEL))
       |   D(?:ECL|EF(?:AULT|DAT|FCT)|ELAY|IGIN|ISTANCE|O)
       |   E(?:LSE|ND(?:DAT|FCT|FOR|IF|LOOP|SWITCH|WHILE)?|NUM|X(?:IT|OR|T(?:FCT)?))
       |   F(?:ALSE|OR)
       |   G(?:LOBAL|OTO)
       |   HALT
       |   I(?:[FS]|MPORT|NT(?:ERRUPT)?)
       |   L(?:IN(?:_REL)?|OOP)
       |   M(?:AXI|INI)MUM
       |   NOT
       |   OR
       |   P(?:RIO|TP(?:_REL)?|UBLIC|ULSE)
       |   RE(?:AL|PEAT|SUME|TURN)
       |   S(?:EC|IGNAL|READ|TRUC|WITCH|WRITE)
       |   T(?:HEN|O|RIGGER|RUE)
       |   UNTIL
       |   W(?:AIT|HEN|HILE)
       )\b)

Identifiers=

   It can have a maximum length of 24 characters.
   It can consist of letters (A-Z), numbers (0-9) and the signs “_” and “$”.
   It must not begin with a number.
   It must not be a keyword.

   \b(?!(?-i: ... )\b)[A-Za-z_$][\w$]{0,23}

StringLiterals=

Comment=

   A comment is text that is ignored by the compiler. It is separated from
   the program code in a program line by means of the “;” character.

   (?'SLC'(?m-s);.*?$)

Classes_and_Methods=

Function=

Grammar=

