
# CAML

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
[CAML] -------------------------------------------------------------------------
@=Categorical Abstract Machine Language

_WWW_=https://caml.inria.fr/

_Wiki_=https://en.wikipedia.org/wiki/Caml

Keywords=

    and         as          assert      asr         begin       class
    constraint  do          done        downto      else        end
    exception   external    false       for         fun         function
    functor     if          in          include     inherit     initializer
    land        lazy        let         lor         lsl         lsr
    lxor        match       method      mod         module      mutable
    new         nonrec      object      of          open        or
    private     rec         sig         struct      then        to
    true        try         type        val         virtual     when
    while       with
    
The following character sequences are also keywords:

    !=    #     &     &&    '     (     )     *     +     ,     -
    -.    ->    .     ..    :     ::    :=    :>    ;     ;;    <
    <-    =     >     >]    >}    ?     [     [<    [>    [|    ]
    _     `     {     {<    |     |]    ||    }     ~

   A RegEx to find them all:

       \b(?!(?-i:
            a(?:nd|s(?:r|sert)?)
        |   begin
        |   c(?:lass|onstraint)
        |   do(?:ne|wnto)?
        |   e(?:lse|nd|x(?:ception|ternal)?)
        |   f(?:alse|or|un(?:ct(?:ion|or))?)
        |   i(?:f|n(?:clude|herit|itializer)?)
        |   l(?:a(?:nd|zy)|et|or|s[lr]|xor)
        |   m(?:atch|ethod|od(?:ule)?|utable)
        |   n(?:ew|onrec)
        |   o(?:bject|[fr]|pen)
        |   private
        |   rec
        |   s(?:ig|truct)
        |   t(?:hen|o|r(?:ue|y)|ype)
        |   v(?:al|irtual)
        |   w(?:h(?:en|ile)|ith)
       )\b)

Identifiers=

    ident               ::= ( letter | _ ) { letter | 0…9 | _ | ' }

    capitalized-ident   ::= (A…Z) { letter | 0…9 | _ | ' }

    lowercase-ident     ::= (a…z | _) { letter |  0…9 | _ | ' }

    letter              ::= A…Z | a…z

Identifiers are sequences of letters, digits, _ (the underscore character), and 
' (the single quote), starting with a letter or an underscore. Letters contain 
at least the 52 lowercase and uppercase letters from the ASCII set. The current 
implementation also recognizes as letters some characters from the ISO 8859-1 
set (characters 192–214 and 216–222 as uppercase letters; characters 223–246 and 
248–255 as lowercase letters). This feature is deprecated and should be avoided 
for future compatibility.

All characters in an identifier are meaningful. The current implementation 
accepts identifiers up to 16000000 characters in length.

In many places, OCaml makes a distinction between capitalized identifiers and 
identifiers that begin with a lowercase letter. The underscore character is 
considered a lowercase letter for this purpose.

CharacterLiterals=

    char-literal        ::= ' regular-char '  
                          | ' escape-sequence '

    escape-sequence     ::= \ ( \ | " | ' | n | t | b | r | space )
                          | \  (0…9) (0…9) (0…9)
                          | \x (0…9 | A…F | a…f) (0…9 | A…F | a…f)
                          | \o (0…3) (0…7) (0…7)

Character literals are delimited by ' (single quote) characters. The two single 
quotes enclose either one character different from ' and \, or one of 
the escape sequences below:
    Sequence    Character denoted
    \\          backslash (\)
    \"          double quote (")
    \'          single quote (')
    \n          linefeed (LF)
    \r          carriage return (CR)
    \t          horizontal tabulation (TAB)
    \b          backspace (BS)
    \space      space (SPC)
    \ddd        the character with ASCII code ddd in decimal
    \xhh        the character with ASCII code hh  in hexadecimal
    \oooo       the character with ASCII code ooo in octal 

StringLiterals=

    string-literal      ::= " { string-character } "

    string-character    ::= regular-string-char
                          | escape-sequence
                          | \u{ { 0…9 | A…F | a…f }+ }
                          | \ newline { space | tab }

String literals are delimited by " (double quote) characters. The two double 
quotes enclose a sequence of either characters different from " and \, or escape 
sequences from the table given above for character literals, or a Unicode 
character escape sequence.

A Unicode character escape sequence is substituted by the UTF-8 encoding of the 
specified Unicode scalar value. The Unicode scalar value, an integer in the 
ranges 0x0000...0xD7FF or 0xE000...0x10FFFF, is defined using 1 to 6 hexadecimal 
digits; leading zeros are allowed.

To allow splitting long string literals across lines, the sequence \newline 
spaces-or-tabs (a backslash at the end of a line followed by any number of spaces 
and horizontal tabulations at the beginning of the next line) is ignored inside 
string literals.

The current implementation places practically no restrictions on the length of 
string literals.

Comment=

Comments are introduced by the two characters (*, with no intervening blanks, and 
terminated by the characters *), with no intervening blanks. Comments are treated 
as blank characters. Comments do not occur inside string or character literals. 
Nested comments are handled correctly.

Classes_and_Methods=

Function=

Grammar=

implementation ::=          
             { impl-phrase ;;}

impl-phrase ::=
              expression | value-definition 
            | type-definition  |  exception-definition  |  directive

value-definition ::= 
          let [ rec ] let-binding { and let-binding } 

let-binding ::=
    pattern = expression |  variable pattern-list =  expression

interface  ::=  
          { intf-phrase ;; } 

value-declaration  ::=  
        value ident : type-expression {  and ident : type-expression }

expression  ::= 
       primary-expression
     | construction-expression
     | nary-expression
     | sequencing-expression

primary-expression  ::=  
       ident
    |  variable
    |  constant
    |  ( expression )
    |  begin expression end
    |  ( expression : type-expression )

construction-expression  ::= 
       ncconstr expression
    |  expression , expression { , expression } 
    |  expression :: expression
    |  [ expression { ;  expression }  ]
    |  [| expression { ; expression }  |]
    |  { label = expression { ; label = expression } }
    |  function simple-matching
    |  fun multiple-matching

nary-expression  ::=  
        expression expression
     |  prefix-op expression     |  expression infix-op expression
     |  expression && expression  |  expression || expression
     |  expression . label       |  expression . label <- expression
     |  expression .( expression )  |  expression .( expression ) <- expression
     |  expression .[ expression ]  |  expression .[ expression ] <- expression

sequencing-expression  ::=  
        expression ; expression
     |  if expression then expression [  else expression ]
     |  match expression with simple-matching
     |  try expression with simple-matching
     |  while expression do expression done
     |  for ident = expression (  to |  downto ) expression do expression done
     |  let [ rec ]  let-binding  { and let-binding }  in expression

simple-matching  ::=  
    pattern -> expression { | pattern -> expression } 

multiple-matching  ::=  
    pattern-list -> expression { | pattern-list -> expression } 

pattern-list  ::=  
    pattern {  pattern } 

prefix-op  ::=  
     - | -. | !

infix-op  ::=  
    + | -  | * | / |  mod | +. | -. | *. | /. | @ | ^ | !  |  := |  
  | = | <> | == | != | < | <= | > | <= | <. | <=. | >. | <=.

pattern  ::=  
        ident
     |  constant
     |  ( pattern )
     |  ( pattern : type-expression )
     |  ncconstr pattern
     |  pattern , pattern { , pattern } 
     |  pattern :: pattern
     |  [ pattern { ; pattern }  ]
     |  { label = pattern { ; label = pattern } }
     |  pattern | pattern
     |  _
     |  pattern as ident

exception-definition  ::=  
        exception constr-decl {  and constr-decl } 

type-definition  ::=  
        type typedef {  and typedef } 

typedef  ::=  
        type-params ident = constr-decl {| constr-decl } 
     |  type-params ident = { label-decl { ; label-decl } }
     |  type-params ident == type-expression
     |  type-params ident

type-params  ::=  
        nothing
     |  ' ident
     |  ( ' ident { , ' ident } )

constr-decl  ::=  
        ident
     |  ident of type-expression

label-decl  ::=  
        ident : type-expression
     |  mutable ident : type-expression

type-expression  ::=  
       ' ident
     |  ( type-expression )
     |  type-expression -> type-expression
     |  type-expression {* type-expression }
     |  typeconstr
     |  type-expression typeconstr
     |  ( type-expression { , type-expression } ) typeconstr

constant  ::=  
       integer-literal
     |  float-literal
     |  char-literal
     |  string-literal
     |  cconstr

global-name  ::=  
        ident
     |  ident__ident

variable  ::=  
        global-name
     |  prefix operator-name

operator-name  ::=  
       + | -  | * | / |  mod | +. | -. | *. | /. 
     | @ | ^ | ! | := | = | <> | == | != 
     | < | <= | > | <. | <=. | >. | <=.

cconstr  ::=  
        global-name
     |  []
     |  ()

ncconstr  ::=  
        global-name
      |  prefix ::

typeconstr  ::=  
        global-name

label  ::=  
        global-name

directive  ::=  
          # open string
        | # close string
        | # ident string




