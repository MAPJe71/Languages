
# TAL - Transaction Application Language

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
[TAL] --------------------------------------------------------------------------
@=Transaction Application Language

_WWW_=

_Wiki_=https://en.wikipedia.org/wiki/Transaction_Application_Language

Keywords=

Table 4-1
    AND         DO          FORWARD     MAIN        RETURN          TO
    ASSERT      DOWNTO      GOTO        NOT         RSCAN           UNSIGNED
    BEGIN       DROP        IF          OF          SCAN            UNTIL
    BY          ELSE        INT         OR          STACK           USE
    CALL        END         INTERRUPT   OTHERWISE   STORE           VARIABLE
    CALLABLE    ENTRY       LABEL       PRIV        STRING          WHILE
    CASE        EXTERNAL    LAND        PROC        STRUCT          XOR
    CODE        FIXED       LITERAL     REAL        SUBPROC
    DEFINE      FOR         LOR         RESIDENT    THEN

Table 4-2
    Keyword         Restrictions
    
    AT
    BELOW
    C
    COBOL
    EXT
    EXTENSIBLE
    FORTRAN
    LANGUAGE
    NAME
    PASCAL
    UNSPECIFIED
    BIT_FILLER      Do not use as an identifier within a structure.
    FILLER          Do not use as an identifier within a structure.
    BLOCK           Do not use as an identifier in a source file that contains the NAME declaration.
    PRIVATE         Do not use as an identifier in a source file that contains the NAME declaration.
    BYTES           Do not use as an identifier of a LITERAL or DEFINE.
    ELEMENTS        Do not use as an identifier of a LITERAL or DEFINE.
    WORDS           Do not use as an identifier of a LITERAL or DEFINE.

   A RegEx to find them all:

    (?'VALID_ID'
        \b(?!(?i:
            A(?:ND|SSERT)
        |   B(?:EGIN|Y)
        |   C(?:A(?:LL(?:ABLE)?|SE)?|ODE)
        |   D(?:EFINE|O(?:WNTO)?|ROP)
        |   E(?:LSE|N(?:D|TRY)|XTERNAL)
        |   F(?:IXED|OR(?:WARD)?)
        |   GOTO
        |   I(?:F|NT(?:ERRUPT)?)
        |   L(?:A(?:BEL|ND)|ITERAL|OR)
        |   MAIN
        |   NOT
        |   O(?:[FR]|THERWISE)
        |   PR(?:IV|OC)?
        |   R(?:E(?:AL|SIDENT|TURN)|SCAN)
        |   S(?:CAN|T(?:ACK|ORE|R(?:ING|UCT))|UBPROC)
        |   T(?:HEN|O)
        |   U(?:N(?:SIGNED|TIL)|SE)
        |   VARIABLE
        |   WHILE
        |   XOR
        )\b)
        [A-Za-z_^][\w^]{0,30}
    )

Identifiers=


        [A-Za-z_^][\w^]{0,30}
        [A-Za-z_^][\w^]{0,29}[A-Za-z0-9^]

TAL supports the complete ASCII character set, which includes:
• Uppercase and lowercase alphabetic characters
• Numeric characters (0 through 9)
• Special characters

Identifiers must conform to the following rules:
• They can be up to 31 characters long.
• They can begin with an alphabetic character, an underscore (_), or a circumflex (^).
• They can contain alphabetic characters, numeric characters, underscores, or circumflexes.
• They can contain lowercase and uppercase characters. The compiler treats them all as uppercase.
• They cannot be reserved keywords, which are listed in Table 4-1.
• They can be nonreserved keywords, except as noted in Table 4-2.

To separate words in identifiers, use underscores rather than circumflexes.
International character-set standards allow the character printed for the circumflex to vary with each country.

Do not end identifiers with an underscore. The trailing underscore is reserved for identifiers supplied by the operating system.


The following identifiers are correct:

    a2
    TANDEM
    _23456789012_00
    name_with_exactly_31_characters

The following identifiers are incorrect:

    2abc                                    !Begins with number
    ab%99                                   !% symbol not allowed
    Variable -                              !Reserved word
    This_name_is_too_long_so_it_is_invalid  !Too long

Though allowed as TAL identifiers, avoid identifiers such as:

    Name^Using^Circumflexes
    Name_Using_Trailing_Underscore_


StringLiterals=

is a sequence of one or more ASCII characters enclosed in quotation mark
delimiters. If a quotation mark is a character within the sequence of ASCII
characters, use two quotation marks (in addition to the quotation mark delimiters).
The compiler does not upshift lowercase characters.

							|	(?:\x22(?:[^\x22\r\n]|\x22{2})*\x22)            # String Literal - Double Quoted


This example shows how you can break a constant string that is too long to fit on
one line into smaller constant strings specified as a constant list. The system
stores one character to a byte:
STRING a[0:99] := ["These three constant strings will ",
                   "appear as if they were one constant ",
                   "string continued on multiple lines."];


Comment=

A note that you insert into the source code to describe a construct or operation
in your source code. The compiler ignores comments during compilation. A comment
must either:
• Begin with two hyphens (--) and terminate with the end of the line
• Begin with an exclamation point (!) and terminate with either another
exclamation point or the end of the line

Classes_and_Methods=

Function=

[ type ] PROC identifier [ public-name-spec ]
    [ parameter-list ]
    [ proc-attribute [ , proc-attribute ] ... ] ;
    [ param-spec ; ] ...
    { proc-body } ;
    { EXTERNAL }
    { FORWARD }

EXTERNAL procedure declaration.
    A procedure declaration that includes the EXTERNAL keyword and no procedure
    body; a declaration that enables you to call a procedure that is declared
    in another source file.

FORWARD procedure declaration.
    A procedure declaration that includes the FORWARD keyword but no procedure
    body; a declaration that allows you to call a procedure before you declare
    the procedure body.

type is one of:
    { STRING }
    { { INT | REAL } [ ( width ) ] }
    { UNSIGNED ( width ) }
    { FIXED [ ( fpoint | * ) ] }

STRING.
    A data type that requires a byte or word of storage and that can represent
    an ASCII character or an 8-bit integer.

INT.
    A data type that requires a word of storage and that can represent one or
    two ASCII characters or a 16-bit integer.

INT(16).
    An alias for INT.

INT(32).
    A data type that requires a doubleword of storage and that can represent a
    32-bit integer.

INT(64).
    An alias for FIXED(0).

REAL.
    A data type that requires a doubleword of storage and that can represent a
    32-bit floating-point number.

REAL(32).
    An alias for REAL.

REAL(64).
    A data type that requires a quadrupleword of storage and that can represent
    a 64-bit floating-point number.

UNSIGNED.
    A data type that allocates storage for:
    • Simple variable bit fields that are 1 to 31 bits wide                     (?:31|[1-3]0|[12]?[1-9])
    • Array element bit fields that are 1, 2, 4, or 8 bits wide                 [1248]
    
        1  2  3  4  5  6  7  8  9
    10 11 12 13 14 15 16 17 18 19
    20 21 22 23 24 25 26 27 28 29
    30 31
    
FIXED.
    A data type that requires a quadrupleword of storage and that can represent
    a 64-bit fixed-point number.

fpoint.                                                                         (?:-?1?[0-9]|\x2A)
    An integer in the range –19 through 19 that specifies the implied decimal
    point position in a FIXED value. A positive fpoint denotes the number of
    decimal places to the right of the decimal point. A negative fpoint denotes
    the number of integer places to the left of the decimal point; that is, the
    number of integer digits to replace with zeros leftward from the decimal
    point.
    
    FIXED(-10)  FIXED(-11)  FIXED(-12)  FIXED(-13)  FIXED(-14)  FIXED(-15)  FIXED(-16)  FIXED(-17)  FIXED(-18)  FIXED(-19)
                FIXED(-1)   FIXED(-2)   FIXED(-3)   FIXED(-4)   FIXED(-5)   FIXED(-6)   FIXED(-7)   FIXED(-8)   FIXED(-9)
    FIXED(0)    FIXED(*)
                FIXED(1)    FIXED(2)    FIXED(3)    FIXED(4)    FIXED(5)    FIXED(6)    FIXED(7)    FIXED(8)    FIXED(9)
    FIXED(10)   FIXED(11)   FIXED(12)   FIXED(13)   FIXED(14)   FIXED(15)   FIXED(16)   FIXED(17)   FIXED(18)   FIXED(19)

quadrupleword.
    A 64-bit storage unit for the REAL(64) or FIXED data type.

public-name-spec has the form:
    = " public-name "

public name.
    A specification within a procedure declaration of a procedure name to use in
    Binder, not within the compiler. Only a D-series EXTERNAL procedure
    declaration can include a public name. If you do not specify a public name,
    the procedure identifier becomes the public name.

parameter-list has the form:
    ( { param-name } [ , { param-name } ] ... )
      { param-pair }     { param-pair }

param-pair has the form:
    string : length

proc-attribute is one of:
    { MAIN | INTERRUPT }
    { RESIDENT }
    { CALLABLE | PRIV }
    { VARIABLE | EXTENSIBLE [ ( count ) ] }
    { LANGUAGE { C } }
    { COBOL }
    { FORTRAN }
    { PASCAL }
    { UNSPECIFIED }

MAIN procedure.
    A procedure that you declare using the MAIN keyword; the procedure that
    executes first when you run the program regardless of where the MAIN
    procedure appears in the source code.

INTERRUPT attribute.
    A procedure attribute (used only for operating system procedures) that
    causes the compiler to generate an IXIT (interrupt exit) instruction
    instead of an EXIT instruction at the end of execution.

RESIDENT procedure.
    A procedure you declare using the RESIDENT keyword; a procedure that remains
    in main memory for the duration of program execution. The operating system
    does not swap pages of RESIDENT code.

CALLABLE procedure.
    A procedure you declare using the CALLABLE keyword; a procedure that can
    call a PRIV procedure. (A PRIV procedure can execute privileged
    instructions.)

PRIV procedure.
    A procedure you declare using the PRIV keyword; a procedure that can execute
    privileged instructions. Normally only operating system procedures are PRIV
    procedures.

VARIABLE procedure.
    A procedure that you declare using the VARIABLE keyword; a procedure to
    which you can add formal parameters but then you must recompile all its
    callers; a procedure for which the compiler considers all parameters to be
    optional, even if some are required by your code. Contrast with EXTENSIBLE
    procedure

EXTENSIBLE procedure.
    A procedure that you declare using the EXTENSIBLE keyword; a procedure to
    which you can add formal parameters without recompiling its callers; a
    procedure for which the compiler considers all parameters to be optional,
    even if some are required by your program. Contrast with VARIABLE procedure

LANGUAGE attribute.
    A procedure attribute that lets you specify in which language (C, COBOL,
    FORTRAN, or Pascal) a D-series EXTERNAL procedure is written.

param-spec has the form:
    param-type [ . ] param-name [ ( referral ) ]
    [ .EXT ]
    [ , [ . ] param-name [ ( referral ) ] ] ... ;
    [ .EXT ]

referral structure.
    A declaration that allocates storage for a structure whose layout is the
    same as the layout of a specified structure or structure pointer. Contrast
    with definition structure and template structure
definition structure.
    A declaration that describes a structure layout and allocates storage for
    the structure layout. Contrast with referral structure and template
    structure
template structure.
    A declaration that describes a structure layout but allocates no storage for
    the structure. Contrast with definition structure and referral structure

param-type is one of:
    { STRING }
    { { INT | REAL } [ ( width ) ] }
    { UNSIGNED ( width ) }
    { FIXED [ ( fpoint | * ) ] }
    { STRUCT }
    { [ type ] { PROC | PROC(32) } }

proc-body has the form:
    BEGIN [ local-decl ; ] ...
    [ subproc-decl ; ] ...
    [ statement [ ; statement ] ... ]
    END ;

A subprocedure is a program unit that is callable from anywhere in the procedure.

[ type ] SUBPROC identifier [ parameter-list ] [ VARIABLE ] ;
    [ param-spec ; ] ...
    { subproc-body } ;
    { FORWARD }

subproc-body has the form:
    BEGIN [ sublocal-decl ; ] ...
    [ statement [ ; statement ] ... ]
    END ;






Grammar=

