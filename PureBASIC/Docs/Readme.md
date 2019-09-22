
# PureBASIC

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
[PureBasic] --------------------------------------------------------------------
@=PureBasic

_WWW_=https://www.purebasic.com/

_Wiki_=

   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Keywords=
   Break  | Case  | Continue | Default | Else    | End | EndIf | EndSelect | 
   ElseIf | Else  | For      | ForEach | ForEver | If  | Next  | Repeat    | 
   Select | To    | Until    | Wend    | While
   
       \b(?!(?-i:
           Break
       |   C(?:ase|ontinue)
       |   Default
       |   E(?:lse|nd(?:If|Select)?|lse(?:If)?)
       |   For(?:E(?:ach|ver))?
       |   If
       |   Next
       |   Repeat
       |   Select
       |   To
       |   Until
       |   W(?:end|hile)
       )\b)

Identifiers=

StringLiterals=

Comment=

Classes_and_Methods=

Function=

Grammar=

