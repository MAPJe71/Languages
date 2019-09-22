
# FreeBasic

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
[FreeBASIC / QuickBASIC] -------------------------------------------------------
@=FreeBASIC / QuickBASIC

   FreeBASIC is a high-level programming language supporting procedural,
   object-orientated and meta-programming paradigms, with a syntax compatible
   to Microsoft QuickBASIC. In fact, the FreeBASIC project originally began as
   an attempt to create a code-compatible, free alternative to Microsoft
   QuickBASIC, but it has since grown into a powerful development tool.
   FreeBASIC can be seen to extend the capabilities of Microsoft QuickBASIC in
   a number of ways, supporting more data types, language constructs,
   programming styles, and modern platforms and APIs.

_WWW_=http://www.freebasic.net/

_Wiki_=

Keywords=http://www.freebasic.net/wiki/wikka.php?wakka=CatPgFullIndex

   #ASSERT
   #DEFINE
   #ELSE(?:IF)?
   #END(?:IF|MACRO)
   #ERROR
   #IF(?:N?DEF)?
   #INC(?:LIB|LUDE)
   #LANG
   #LIBPATH
   #LINE
   #MACRO
   #PR(?:AGMA|INT)
   #UNDEF

   $DYNAMIC    $INCLUDE    $LANG    $STATIC

   ABS(?:TRACT)?
   AC(?:CES|O)S
   ADD
   AL(?:IAS|LOCATE|PHA)
   AND(?:ALSO)?
   ANY
   APPEND
   AS(?:C|IN|M|SERT(?:WARN)?)?
   AT(?:AN2|N)

   BASE
   BEEP
   BOOLEAN
   BIN(?:ARY)?
   BIT(?:(?:RE)?SET)?
   B(?:LOAD|SAVE)
   BY(?:REF|TE|VAL)

   CALL(?:OCATE)?
   CAS[ET]
   C(?:BOOL|U?BYTE|DBL|U?INT|U?LNG(?:INT)|U?SHORT|U?SNG)
   CDECL
   CSIGN    CSRLIN
   CH(?:AIN|DIR|R)
   CIRCLE
   CL(?:ASS|EAR|OSE|S)
   COLOR
   COM(?:MAND|MON)?
   CON(?:D(?:BROADCAST|CREATE|DESTROY|SIGNAL|WAIT)|S(?:T(?:RUCTOR)?|INUE))
   COS
   CPTR
   CURDIR    CUSTOM
   CV(?:[DI]|L(?:ONGINT)?|S(?:HORT)?)

   DA(?:T(?:A|E(?:ADD|DIFF|PART|SERIAL|VALUE)?)|Y)
   DE(?:ALLOCATE|CLARE|LETE|STRUCTOR)
   DEF(?:U?(?:BYTE|(?:LONG)?INT|SHORT)|DBL|LNG|SNG|STR|INED)
   DI[MR]
   DO(?:UBLE)?
   DRAW
   DYLIB(?:FREE|LOAD|SYMBOL)
   DYNAMIC

   ELSE(?:IF)?
   EN(?:CODING|D|UM|VIRON)
   EOF
   EQV
   ER(?:ASE|FN|L|MN|R(?:OR)?)
   ESCAPE
   EVENT
   EXE(?:C|PATH)
   EXIT
   EXP(?:LICIT|ORT)?
   EXTE(?:NDS|RN)

   FALSE
   FIELD
   FILE(?:ATTR|COPY|DATETIME|EXISTS|LEN)
   FIX
   FLIP
   FOR(?:MAT)?
   FRAC
   FRE(?:EFILE)?
   FUNCTION

   GET(?:JOYSTICK|KEY|MOUSE)?
   GO(?:SUB|TO)

   HEX
   HI(?:BYTE|WORD)
   HOUR

   I?IF
   IMAGE(?:CONVERTROW|CREATE|DESTROY|INFO)
   IMP(?:LEMENTS|ORT)?
   IN(?:KEY|P(?:UT)?|STR(?:REV)?|T(?:EGER)?)
   IS(?:DATE|REDIRECTED)?

   KILL

   LBOUND    LCASE
   LEFT    LEN    LET
   LIB    LINE
   LOBYTE
   LOC    LOCAL    LOCATE    LOCK
   LOF    LOG
   LONG    LONGINT
   LOOP
   LOWORD
   LPOS    LPRINT    LPT
   LSET
   LTRIM

   MID
   MINUTE
   MKD    MKDIR    MKI    MKL    MKLONGINT    MKS    MKSHORT
   MOD
   MONTH    MONTHNAME
   MULTIKEY
   MUTEXCREATE    MUTEXDESTROY    MUTEXLOCK    MUTEXUNLOCK

   NAKED
   NAME    NAMESPACE
   NEW    NEXT
   NOGOSUB    NOKEYWORD    NOT    NOW

   OBJECT    OCT    OFFSETOF
   ON     ONCE
   OPEN     OPERATOR    OPTION
   OR    ORELSE
   OUT    OUTPUT
   OVERLOAD    OVERRIDE

   PAINT    PALETTE    PASCAL
   PCOPY    PEEK    PIPE    PMAP
   POINT    POINTCOORD    POINTER
   POKE    POS
   PRESERVE    PRESET
   PRINT    PRIVATE
   PROCPTR    PROPERTY
   PSET
   PTR
   PUBLIC    PUT

   RANDOM    RANDOMIZE
   READ    REALLOCATE
   REDIM    REM    RESET    RESTORE    RESUME    RETURN
   RGB    RGBA
   RIGHT    RMDIR    RND    RSET    RTRIM    RUN

   SADD
   SCOPE
   SCR(?:EEN(?:CONTROL|COPY|EVENT|GLPROC|INFO|LIST|(?:UN)?LOCK|PTR|RES|SET|SYNC)?|N)
   SECOND
   SEEK
   SELECT
   SET(?:DATE|ENVIRON|MOUSE|TIME)
   SGN
   SH(?:ARED|ELL|[LR]|ORT)
   SIN(?:GLE)?
   SIZEOF
   SLEEP
   SPACE
   SPC
   SQR
   ST(?:ATIC|DCALL|[EO]P|ICK)
   STR(?:IN?G|PTR)?
   SUB
   SWAP
   SYSTEM

   TA[BN]
   TH(?:(?:EN|IS)|READ(?:CALL|CREATE|DETACH|WAIT))
   TIME(?:R|SERIAL|VALUE)?
   TO
   TR(?:ANS|IM|UE)
   TYPE(?:OF)?

   UBOUND
   UCASE
   UBYTE    UINTEGER    ULONG(?:INT)?
   UNION    UNLOCK    UNSIGNED    UNTIL
   USHORT   USING

   VAL(?:U?INT|U?LNG)?
   VAR(?:PTR)?
   VA_(?:ARG|FIRST|NEXT)
   VIEW
   VIRTUAL

   WAIT    WBIN    WCHR
   WEEKDAY(?:NAME)?
   WEND
   WHEX    WHILE
   WID?TH
   WINDOW    WINDOWTITLE    WINPUT
   WOCT    WRITE
   WSPACE
   WSTR(?:ING)?

   XOR

   YEAR

   ZSTRING

   __(?:
         DATE(?:_ISO)?
     |   FB_
         (?:
             64BIT
         |   ARG[CV]
         |   B(?:ACKEND|IGENDIAN|UILD_DATE)
         |   DEBUG
         |   ERR
         |   FP(?:MODE|U)
         |   LANG
         |   M(?:AIN|T)
         |   PCOS
         |   SIGNATURE
         |   SSE
         |   VECTORIZE
         |   A[RS]M|(?:FREE|NET|OPEN)BSD|CYGWIN|DARWIN|DOS|GCC|(?:LI|U)NUX|WIN32|XBOX
         |   (?:MIN_)?VERSION
         |   OPTION_(?:BYVAL|DYNAMIC|ESCAPE|EXPLICIT|GOSUB|PRIVATE)
         |   OUT_(?:DLL|EXE|LIB|OBJ)
         |   VER_(?:MAJOR|MINOR|PATCH)
         )
     |   F(?:ILE|UNCTION)(?:_NQ)?
     |   LINE|PATH|TIME
     )__


   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=http://www.freebasic.net/wiki/wikka.php?wakka=ProPgIdentifierRules

StringLiterals=http://www.freebasic.net/wiki/wikka.php?wakka=ProPgLiterals

Comment=http://www.freebasic.net/wiki/wikka.php?wakka=ProPgComments

Classes_and_Methods=

Function=

   http://www.freebasic.net/wiki/wikka.php?wakka=KeyPgSub
   http://www.freebasic.net/wiki/wikka.php?wakka=KeyPgFunction

Grammar=

