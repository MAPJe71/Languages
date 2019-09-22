
# PowerShell

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
[PowerShell] -------------------------------------------------------------------
@=PowerShell

_WWW_=http://microsoft.com/powershell

_Wiki_=https://en.wikipedia.org/wiki/Windows_PowerShell



    .ps1 (Script)
    .ps1xml (XML Document)
    .psc1 (Console File)
    .psd1 (Data File)
    .psm1 (Script Module)
    .pssc (Session Configuration File)
    .cdxml (Cmdlet Definition XML Document)



Keywords=

   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=

StringLiterals=

   https://en.wikipedia.org/wiki/Here_document

Comment=

   Single Line Comment
       # comment

   Mutli Line Comment (works with PowerShell v2)
       <#                          # Opening comment tag
           First line comment
           Additional comment lines
       #>                          # Closing comment tag

       <# First line comment
          Additional line comment #>

       <# MLC used as SLC #>

Classes_and_Methods=

Function=

   Function or Filter definition:

       function [scope_type:]name
       {
           [ param(param_list) ]
           script_block
       }

       filter [scope_type:]name
       {
           [ param(param_list) ]
           script_block
       }

   The most basic variant of function definition would be the kind which uses
   positional parameters and therefore doesn't need to declare much:

       function multiply {
           return $args[0] * $args[1]
       }

   Also, the return statement can be omitted in many cases in PowerShell, since
   every value that "drops" out of a function can be used as a "return value":

       function multiply {
           $args[0] * $args[1]
       }

   Furthermore, the function arguments can be stated and named explicitly:

       function multiply ($a, $b) {
           return $a * $b
       }

   There is also an alternative style for declaring parameters. The choice is
   mostly a matter of personal preference:

       function multiply {
           param ($a, $b)
           return $a * $b
       }

   And the arguments can have an explicit type:

       function multiply ([int] $a, [int] $b) {
           return $a * $b
       }

Grammar=

