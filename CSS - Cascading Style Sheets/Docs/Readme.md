
# CSS

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
[CSS] --------------------------------------------------------------------------
@=Cascading Style Sheets

_WWW_=

_Wiki_=

Keywords=

   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=

StringLiterals=

Comment=

Classes_and_Methods=

Function=

Grammar=

In CSS, identifiers may begin with '-' (dash) or '_' (underscore). Keywords and property names beginning with -' or '_' are reserved for vendor-specific extensions. Such vendor-specific extensions should have one of the following formats:

    '-' + vendor identifier + '-' + meaningful name
    '_' + vendor identifier + '-' + meaningful name

For example, if XYZ organization added a property to describe the color of the border on the East side of the display, they might call it -xyz-border-east-color.

Other known examples:

    -moz-box-sizing
    -moz-border-radius
    -wap-accesskey


prefix          organization
-ms-, mso-      Microsoft
-moz-           Mozilla
-o-, -xv-       Opera Software
-atsc-          Advanced Television Standards Committee
-wap-           The WAP Forum
-khtml-         KDE
-webkit-        Apple
prince-         YesLogic
-ah-            Antenna House
-hp-            Hewlett Packard
-ro-            Real Objects
-rim-           Research In Motion
-tc-            TallComponents



```
    *: 0 or more
    +: 1 or more
    ?: 0 or 1
    |: separates alternatives
    [ ]: grouping

The productions are:

stylesheet
  : [ CHARSET_SYM STRING ';' ]?
    [S|CDO|CDC]* [ import [ CDO S* | CDC S* ]* ]*
    [ [ ruleset | media | page ] [ CDO S* | CDC S* ]* ]*
  ;
import
  : IMPORT_SYM S*
    [STRING|URI] S* media_list? ';' S*
  ;
media
  : MEDIA_SYM S* media_list '{' S* ruleset* '}' S*
  ;
media_list
  : medium [ COMMA S* medium]*
  ;
medium
  : IDENT S*
  ;
page
  : PAGE_SYM S* pseudo_page?
    '{' S* declaration? [ ';' S* declaration? ]* '}' S*
  ;
pseudo_page
  : ':' IDENT S*
  ;
operator
  : '/' S* | ',' S*
  ;
combinator
  : '+' S*
  | '>' S*
  ;
unary_operator
  : '-' | '+'
  ;
property
  : IDENT S*
  ;
ruleset
  : selector [ ',' S* selector ]*
    '{' S* declaration? [ ';' S* declaration? ]* '}' S*
  ;
selector
  : simple_selector [ combinator selector | S+ [ combinator? selector ]? ]?
  ;
simple_selector
  : element_name [ HASH | class | attrib | pseudo ]*
  | [ HASH | class | attrib | pseudo ]+
  ;
class
  : '.' IDENT
  ;
element_name
  : IDENT | '*'
  ;
attrib
  : '[' S* IDENT S* [ [ '=' | INCLUDES | DASHMATCH ] S*
    [ IDENT | STRING ] S* ]? ']'
  ;
pseudo
  : ':' [ IDENT | FUNCTION S* [IDENT S*]? ')' ]
  ;
declaration
  : property ':' S* expr prio?
  ;
prio
  : IMPORTANT_SYM S*
  ;
expr
  : term [ operator? term ]*
  ;
term
  : unary_operator?
    [ NUMBER S* | PERCENTAGE S* | LENGTH S* | EMS S* | EXS S* | ANGLE S* |
      TIME S* | FREQ S* ]
  | STRING S* | IDENT S* | URI S* | hexcolor | function
  ;
function
  : FUNCTION S* expr ')' S*
  ;
/*
 * There is a constraint on the color that it must
 * have either 3 or 6 hex-digits (i.e., [0-9a-fA-F])
 * after the "#"; e.g., "#000" is OK, but "#abcd" is not.
 */
hexcolor
  : HASH S*
  ;
```

Lexical scanner

```
    %option case-insensitive

    h                       [0-9a-f]
    nonascii                [\240-\377]
    unicode                 \\{h}{1,6}(\r\n|[ \t\r\n\f])?
    escape                  {unicode}|\\[^\r\n\f0-9a-f]
    nmstart                 [_a-z]|{nonascii}|{escape}
    nmchar                  [_a-z0-9-]|{nonascii}|{escape}
    string1                 \"([^\n\r\f\\"]|\\{nl}|{escape})*\"
    string2                 \'([^\n\r\f\\']|\\{nl}|{escape})*\'
    badstring1              \"([^\n\r\f\\"]|\\{nl}|{escape})*\\?
    badstring2              \'([^\n\r\f\\']|\\{nl}|{escape})*\\?
    badcomment1             \/\*[^*]*\*+([^/*][^*]*\*+)*
    badcomment2             \/\*[^*]*(\*+[^/*][^*]*)*
    baduri1                 url\({w}([!#$%&*-\[\]-~]|{nonascii}|{escape})*{w}
    baduri2                 url\({w}{string}{w}
    baduri3                 url\({w}{badstring}
    comment                 \/\*[^*]*\*+([^/*][^*]*\*+)*\/
    ident                   -?{nmstart}{nmchar}*
    name                    {nmchar}+
    num                     [0-9]+|[0-9]*"."[0-9]+
    string                  {string1}|{string2}
    badstring               {badstring1}|{badstring2}
    badcomment              {badcomment1}|{badcomment2}
    baduri                  {baduri1}|{baduri2}|{baduri3}
    url                     ([!#$%&*-~]|{nonascii}|{escape})*
    s                       [ \t\r\n\f]+
    w                       {s}?
    nl                      \n|\r\n|\r|\f

    A                       a|\\0{0,4}(41|61)(\r\n|[ \t\r\n\f])?
    C                       c|\\0{0,4}(43|63)(\r\n|[ \t\r\n\f])?
    D                       d|\\0{0,4}(44|64)(\r\n|[ \t\r\n\f])?
    E                       e|\\0{0,4}(45|65)(\r\n|[ \t\r\n\f])?
    G                       g|\\0{0,4}(47|67)(\r\n|[ \t\r\n\f])?|\\g
    H                       h|\\0{0,4}(48|68)(\r\n|[ \t\r\n\f])?|\\h
    I                       i|\\0{0,4}(49|69)(\r\n|[ \t\r\n\f])?|\\i
    K                       k|\\0{0,4}(4b|6b)(\r\n|[ \t\r\n\f])?|\\k
    L                       l|\\0{0,4}(4c|6c)(\r\n|[ \t\r\n\f])?|\\l
    M                       m|\\0{0,4}(4d|6d)(\r\n|[ \t\r\n\f])?|\\m
    N                       n|\\0{0,4}(4e|6e)(\r\n|[ \t\r\n\f])?|\\n
    O                       o|\\0{0,4}(4f|6f)(\r\n|[ \t\r\n\f])?|\\o
    P                       p|\\0{0,4}(50|70)(\r\n|[ \t\r\n\f])?|\\p
    R                       r|\\0{0,4}(52|72)(\r\n|[ \t\r\n\f])?|\\r
    S                       s|\\0{0,4}(53|73)(\r\n|[ \t\r\n\f])?|\\s
    T                       t|\\0{0,4}(54|74)(\r\n|[ \t\r\n\f])?|\\t
    U                       u|\\0{0,4}(55|75)(\r\n|[ \t\r\n\f])?|\\u
    X                       x|\\0{0,4}(58|78)(\r\n|[ \t\r\n\f])?|\\x
    Z                       z|\\0{0,4}(5a|7a)(\r\n|[ \t\r\n\f])?|\\z

    %%

    {s}                     {return S;}

    \/\*[^*]*\*+([^/*][^*]*\*+)*\/                      /* ignore comments */
    {badcomment}                                        /* unclosed comment at EOF */

    "<!--"                  {return CDO;}
    "-->"                   {return CDC;}
    "~="                    {return INCLUDES;}
    "|="                    {return DASHMATCH;}

    {string}                {return STRING;}
    {badstring}             {return BAD_STRING;}

    {ident}                 {return IDENT;}

    "#"{name}               {return HASH;}

    @{I}{M}{P}{O}{R}{T}     {return IMPORT_SYM;}
    @{P}{A}{G}{E}           {return PAGE_SYM;}
    @{M}{E}{D}{I}{A}        {return MEDIA_SYM;}
    "@charset "             {return CHARSET_SYM;}

    "!"({w}|{comment})*{I}{M}{P}{O}{R}{T}{A}{N}{T}      {return IMPORTANT_SYM;}

    {num}{E}{M}             {return EMS;}
    {num}{E}{X}             {return EXS;}
    {num}{P}{X}             {return LENGTH;}
    {num}{C}{M}             {return LENGTH;}
    {num}{M}{M}             {return LENGTH;}
    {num}{I}{N}             {return LENGTH;}
    {num}{P}{T}             {return LENGTH;}
    {num}{P}{C}             {return LENGTH;}
    {num}{D}{E}{G}          {return ANGLE;}
    {num}{R}{A}{D}          {return ANGLE;}
    {num}{G}{R}{A}{D}       {return ANGLE;}
    {num}{M}{S}             {return TIME;}
    {num}{S}                {return TIME;}
    {num}{H}{Z}             {return FREQ;}
    {num}{K}{H}{Z}          {return FREQ;}
    {num}{ident}            {return DIMENSION;}

    {num}%                  {return PERCENTAGE;}
    {num}                   {return NUMBER;}

    "url("{w}{string}{w}")" {return URI;}
    "url("{w}{url}{w}")"    {return URI;}
    {baduri}                {return BAD_URI;}

    {ident}"("              {return FUNCTION;}

    .                       {return *yytext;}
```