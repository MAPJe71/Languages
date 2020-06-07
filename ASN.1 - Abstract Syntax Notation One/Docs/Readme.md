
# ASN.1 - Abstract Syntax Notation One

## Description

.asn1
.asn
.mib


## Links

_WWW_

http://www.itu.int/en/ITU-T/asn1/Pages/asn1_project.aspx

_Wiki_

https://en.wikipedia.org/wiki/Abstract_Syntax_Notation_One#Exemple


## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~

BEGIN
DEFINITIONS
DESCRIPTION
DISPLAY-HINT
END
FROM
IDENTIFIER
IMPORTS
INDEX
MAX-ACCESS
MODULE-IDENTITY
NOTIFICATION-TYPE
OBJECT
OBJECT-TYPE
OF
SEQUENCE
SIZE
STATUS
SYNTAX
TEXTUAL-CONVENTION

## Identifiers

IgnoreCase = No
InitKeyWordChars = A-Za-z_
KeyWordChars = A-Za-z0-9_-

('a'..'z'|'A'..'Z') ('0'..'9'|'a'..'z'|'A'..'Z')*


## String Literals

StringAlt = !
StringEsc = \


### Single quoted

### Double quoted

StringStart = "
StringEnd = "


### Document String - Double or Single Triple-Quoted

### Backslash quoted


## Comment

### Single line comment

SingleComment = --
'--' ~('\n'|'\r')* '\r'? '\n' {$channel=HIDDEN;}


### Multi line comment

### Block comment

CommentStartAlt = "
CommentEndAlt = "


### Java Doc

### Here Doc

### Now Doc


## Classes & Methods


## Function


## Grammar

BNF | ABNF | EBNF | XBNF

