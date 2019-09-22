
# Go

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
[Go] ---------------------------------------------------------------------------
@=Go / GoLang

_WWW_=https://golang.org/

_Wiki_=https://en.wikipedia.org/wiki/Go_(programming_language)

Keywords=

   The following keywords are reserved and may not be used as identifiers.

       break        default      func         interface    select
       case         defer        go           map          struct
       chan         else         goto         package      switch
       const        fallthrough  if           range        type
       continue     for          import       return       var

   A RegEx to find them all:

       \b(?!(?-i:
           break
       |   c(?:ase|han|on(?:st|tinue))
       |   def(?:ault|er)
       |   else
       |   f(?:allthrough|or|unc)
       |   g(?:to)?
       |   i(?:f|mport|nterface)
       |   map
       |   package
       |   r(?:ange|eturn)
       |   s(?:elect|truct|witch)
       |   type
       |   var
       )\b)

Identifiers=

   Identifiers name program entities such as variables and types. An identifier
   is a sequence of one or more letters and digits. The first character in an
   identifier must be a letter.

       identifier = letter { letter | unicode_digit } .

       a
       _x9
       ThisVariableIsExported
       aß

   Some identifiers are predeclared.

StringLiterals=

   A string literal represents a string constant obtained from concatenating a
   sequence of characters. There are two forms: raw string literals and
   interpreted string literals.

   Raw string literals are character sequences between back quotes, as in
   `foo`. Within the quotes, any character may appear except back quote. The
   value of a raw string literal is the string composed of the uninterpreted
   (implicitly UTF-8-encoded) characters between the quotes; in particular,
   backslashes have no special meaning and the string may contain newlines.
   Carriage return characters ('\r') inside raw string literals are discarded
   from the raw string value.

   Interpreted string literals are character sequences between double quotes,
   as in "bar". Within the quotes, any character may appear except newline and
   unescaped double quote. The text between the quotes forms the value of the
   literal, with backslash escapes interpreted as they are in rune literals
   (except that \' is illegal and \" is legal), with the same restrictions.
   The three-digit octal (\nnn) and two-digit hexadecimal (\xnn) escapes
   represent individual bytes of the resulting string; all other escapes
   represent the (possibly multi-byte) UTF-8 encoding of individual characters.
   Thus inside a string literal \377 and \xFF represent a single byte of
   value 0xFF=255, while ÿ, \u00FF, \U000000FF and \xc3\xbf represent the two
   bytes 0xc3 0xbf of the UTF-8 encoding of character U+00FF.

       string_lit             = raw_string_lit | interpreted_string_lit .
       raw_string_lit         = "`" { unicode_char | newline } "`" .
       interpreted_string_lit = `"` { unicode_value | byte_value } `"` .

       `abc`                // same as "abc"
       `\n
       \n`                  // same as "\\n\n\\n"
       "\n"
       "\""                 // same as `"`
       "Hello, world!\n"
       "???"
       "\u65e5?\U00008a9e"
       "\xff\u00FF"
       "\uD800"             // illegal: surrogate half
       "\U00110000"         // illegal: invalid Unicode code point

   These examples all represent the same string:

       "???"                                   // UTF-8 input text
       `???`                                   // UTF-8 input text as a raw literal
       "\u65e5\u672c\u8a9e"                    // the explicit Unicode code points
       "\U000065e5\U0000672c\U00008a9e"        // the explicit Unicode code points
       "\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e"  // the explicit UTF-8 bytes

   If the source code represents a character as two code points, such as a
   combining form involving an accent and a letter, the result will be an error
   if placed in a rune literal (it is not a single code point), and will appear
   as two code points if placed in a string literal.

Comment=

   Comments serve as program documentation. There are two forms:

   1. Line comments start with the character sequence // and stop at the end of
      the line.
   2. General comments start with the character sequence /* and stop with the
      first subsequent character sequence */.

   A comment cannot start inside a rune or string literal, or inside a comment.
   A general comment containing no newlines acts like a space. Any other
   comment acts like a newline.

Classes_and_Methods=

Function=

Grammar=

