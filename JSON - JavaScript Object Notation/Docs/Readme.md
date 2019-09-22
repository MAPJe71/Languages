
# JSON

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
[JSON] ---------------------------------------------------------------------
@=JSON - JavaScript Object Notation

_WWW_=http://json.org/

_Wiki_=

Description=

   An object is an unordered set of name/value pairs. An object begins with
   { (left brace) and ends with } (right brace). Each name is followed by :
   (colon) and the name/value pairs are separated by , (comma).

   An array is an ordered collection of values. An array begins with [ (left
   bracket) and ends with ] (right bracket). Values are separated by , (comma).

   A value can be a string in double quotes, or a number, or true or false or
   null, or an object or an array. These structures can be nested.

   A string is a sequence of zero or more Unicode characters, wrapped in double
   quotes, using backslash escapes. A character is represented as a single
   character string. A string is very much like a C or Java string.

   A number is very much like a C or Java number, except that the octal and
   hexadecimal formats are not used.

   Whitespace can be inserted between any pair of tokens. Excepting a few
   encoding details, that completely describes the language.

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

   object
       {}
       { members }
   members
       pair
       pair , members
   pair
       string : value
   array
       []
       [ elements ]
   elements
       value
       value , elements
   value
       string
       number
       object
       array
       true
       false
       null

   string
       ""
       " chars "
   chars
       char
       char chars
   char
       any-Unicode-character-except-"-or-\-or-control-character
       \"
       \\
       \/
       \b
       \f
       \n
       \r
       \t
       \u four-hex-digits
   number
       int
       int frac
       int exp
       int frac exp
   int
       digit
       digit1-9 digits
       - digit
       - digit1-9 digits
   frac
       . digits
   exp
       e digits
   digits
       digit
       digit digits
   e
       e
       e+
       e-
       E
       E+
       E-


This is the JSON grammar in McKeeman Form.

    json
       element

    value
       object
       array
       string
       number
       "true"
       "false"
       "null"

    object
        '{' ws '}'
        '{' members '}'

    members
        member
        member ',' members

    member
        ws string ws ':' element

    array
        '[' ws ']'
        '[' elements ']'

    elements
        element
        element ',' elements

    element
        ws value ws

    string
    '"' characters '"'

    characters
        ""
        character characters

    character
        '0020' . '10FFFF' - '"' - '\'
    '\' escape

    escape
        '"'
        '\'
        '/'
        'b'
        'f'
        'n'
        'r'
        't'
        'u' hex hex hex hex

    hex
        digit
        'A' . 'F'
        'a' . 'f'

    number
        int frac exp

    int
        digit
        onenine digits
        '-' digit
        '-' onenine digits

    digits
        digit
        digit digits

    digit
        '0'
        onenine

    onenine
        '1' . '9'

    frac
        ""
        '.' digits

    exp
        ""
        'E' sign digits
        'e' sign digits

    sign
        ""
        '+'
        '-'

    ws
        ""
        '0009' ws
        '000A' ws
        '000D' ws
        '0020' ws
