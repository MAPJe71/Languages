
# YAML

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
[YAML] -------------------------------------------------------------------------
@=YAML Ain't Markup Language

_WWW_=http://yaml.org/

_Wiki_=https://en.wikipedia.org/wiki/YAML

Keywords=

   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=

StringLiterals=

Comment=

   # \x23

Classes_and_Methods=

Function=

Grammar=

   [1]     c-printable         ::=   #x9 | #xA | #xD | [#x20-#x7E]          /* 8 bit */
                                   | #x85 | [#xA0-#xD7FF] | [#xE000-#xFFFD] /* 16 bit */
                                   | [#x10000-#x10FFFF]                     /* 32 bit */

   [2]     nb-json             ::= #x9 | [#x20-#x10FFFF]

   [3]     c-byte-order-mark   ::= #xFEFF

   [4]     c-sequence-entry    ::= “-”
   [5]     c-mapping-key       ::= “?”
   [6]     c-mapping-value     ::= “:”
   [7]     c-collect-entry     ::= “,”
   [8]     c-sequence-start    ::= “[”
   [9]     c-sequence-end      ::= “]”
   [10]    c-mapping-start     ::= “{”
   [11]    c-mapping-end       ::= “}”
   [12]    c-comment           ::= “#”
   [13]    c-anchor            ::= “&”
   [14]    c-alias             ::= “*”
   [15]    c-tag               ::= “!”
   [16]    c-literal           ::= “|”
   [17]    c-folded            ::= “>”
   [18]    c-single-quote      ::= “'”
   [19]    c-double-quote      ::= “"”
   [20]    c-directive         ::= “%”
   [21]    c-reserved          ::= “@” | “`”
   [22]    c-indicator         ::=   “-” | “?” | “:” | “,” | “[” | “]” | “{” | “}”
                                   | “#” | “&” | “*” | “!” | “|” | “>” | “'” | “"”
                                   | “%” | “@” | “`”
   [23]    c-flow-indicator    ::= “,” | “[” | “]” | “{” | “}”
   [24]    b-line-feed         ::= #xA    /* LF */
   [25]    b-carriage-return   ::= #xD    /* CR */
   [26]    b-char              ::= b-line-feed | b-carriage-return
   [27]    nb-char             ::= c-printable - b-char - c-byte-order-mark
   [28]    b-break             ::= ( b-carriage-return b-line-feed )   /* DOS, Windows */
                                   | b-carriage-return                 /* MacOS upto 9.x */
                                   | b-line-feed                       /* UNIX, MacOS X */
   [29]    b-as-line-feed      ::= b-break
   [30]    b-non-content       ::= b-break
   [31]    s-space             ::= #x20 /* SP */
   [32]    s-tab               ::= #x9  /* TAB */
   [33]    s-white             ::= s-space | s-tab
   [34]    ns-char             ::= nb-char - s-white
   [35]    ns-dec-digit        ::= [#x30-#x39] /* 0-9 */
   [36]    ns-hex-digit        ::= ns-dec-digit
                                   | [#x41-#x46] /* A-F */ | [#x61-#x66] /* a-f */


