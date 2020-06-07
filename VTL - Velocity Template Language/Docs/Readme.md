
# VTL - Velocity Template Language

## Description


## Links

WWW

https://velocity.apache.org/engine/1.7/vtl-reference.html
https://velocity.apache.org/engine/1.7/user-guide.html

Wiki

https://en.wikipedia.org/wiki/Apache_Velocity


## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~


## Identifiers

The shorthand notation of a variable consists of a leading "$" character followed 
by a VTL Identifier. A VTL Identifier must start with an alphabetic character 
(a .. z or A .. Z). The rest of the characters are limited to the following 
types of characters:

    alphabetic (a .. z, A .. Z)
    numeric (0 .. 9)
    hyphen ("-")
    underscore ("_")

Here are some examples of valid variable references in the VTL:

$foo
$mudSlinger
$mud-slinger
$mud_slinger
$mudSlinger1


    (?'VALID_ID'[A-Za-z][\w-]*)


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

Velocimacro Arguments

Velocimacros can take as arguments any of the following VTL elements :

    Reference       : anything that starts with '$'
    String literal  : something like "$foo" or 'hello'
    Number literal  : 1, 2 etc
    IntegerRange    : [1..2] or [$foo .. $bar]
    ObjectArray     : ["a", "b", "c"]
    boolean value true
    boolean value false



## Grammar

BNF | ABNF | EBNF | XBNF

