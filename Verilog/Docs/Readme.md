
# Verilog

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
[Verilog] ----------------------------------------------------------------------
@=Verilog Hardware Description Langauge

_WWW_=

_Wiki_=

Identifiers=

   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Keywords=

Comment=(?'MLC'(?s-m)/\*.*?\*/)|(?'SLC'(?m-s)/{2}.*$)

   // Single Line Comment

   /*
       Multiple
       Line
       Comment
   */

StringLiterals=

Classes_and_Methods=

Function=

Grammar=

   <parser
       id="verilog_syntax" displayName="Verilog" version="1.0.0.0"
       commentExpr="(?'MLC'(?s-m)/\*.*?\*/)|(?'SLC'(?m-s)/{2}.*$)" >
     <function
         mainExpr="\w+\s*(//.+?[\r\n])*\s*\(\s*(//.+?[\r\n])*\s*\.\w+"
         displayMode="$functionName" >
       <functionName>
         <nameExpr expr="\w+" />
       </functionName>
     </function>
   </parser>

