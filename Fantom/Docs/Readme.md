
# Language Template

## Description


## Links

WWW

https://fantom.org/

Wiki



## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~

abstract       foreach        return
as             if             static
assert         internal       super
break          is             switch
case           isnot          this
catch          it             throw
class          mixin          true
const          native         try
continue       new            using
default        null           virtual
do             once           volatile
else           override       void
false          private        while
final          protected
finally        public
for            readonly


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

<funcType>       :=  "|" [formals] ["->" <type>] "|"
<formals>        :=  [<formal> ("," <formal>)*]
<formal>         :=  <formalFull> | <formalInferred> | <formalTypeOnly>
<formalFull>     :=  <type> <id>
<formalInferred> :=  <id>
<formalTypeOnly> :=  <type>


## Grammar

BNF | ABNF | EBNF | XBNF

https://fantom.org/doc/docLang/Grammar

