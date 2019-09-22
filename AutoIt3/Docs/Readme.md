
# AutoIt3

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

The semicolon (;) is the comment character. Unless the semicolon is within a
string, all text following it is ignored by the script interpreter/compiler.

   ; The next line contains a meaningful, end-of-line comment
   Sleep(5000) ; Pause for 5 seconds

You can combine underscore and semicolon to put comments on lines and still
have a long statement span on next line.

   Local $aArray_1_ ; This _ is not a continuation character, nor is the next one
   Local $aArray_2_
   Local $aArray_3[8][2] = [ _
           ["Word", 4], _ ; Comment 1
           ["Test", 3], _
           ["pi", 3.14159], _ ; Associate the name with the value
           ["e", 2.718281828465], _ ; Same here
           ["test;1;2;3", 123], _
           [';', Asc(';')], _ ; This comment is removed, but the strings remain.
           ["", 0]]

It is also possible to comment out large blocks of script by using the #cs and
#ce directives.

Specify that an entire section of script should be commented out.

   #comments-start
   ...
   ...
   #comments-end

Parameters
   None.

Remarks
   The #comments-start and #comments-end directives can be nested.
   You can also use the abbreviated keywords #cs and #ce.
   Additionally, the directives themselves can be commented out!

Example

   #include <MsgBoxConstants.au3>

   #comments-start
       MsgBox($MB_SYSTEMMODAL, "", "This won't display ")
       MsgBox($MB_SYSTEMMODAL, "", "nor will this.")
   #comments-end

   ; #cs
   MsgBox($MB_SYSTEMMODAL, "", "This will display if '#cs/#ce' are commented out.")
   ; #ce

### Single line comment

### Multi line comment

### Block comment

### Java Doc

### Here Doc

### Now Doc


## Classes & Methods


## Function

Note that all function names are case insensitive.
User functions are declared using the Func...EndFunc statements.
Functions can accept parameters and return values as required.

Function names must start with either a letter or an underscore, and the
remainder of the name can contain any combination of letters and numbers and
underscores. Some valid function names are:

   MyFunc
   Func1
   _My_Func1


## Grammar

BNF | ABNF | EBNF | XBNF
