
# Batch / Windows Command Shell Script

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
Each label must be defined on a line by itself, beginning with
a colon and ending with either a space, a colon or a CR/LF.


The Guidelines for using labels in MS DOS batch files are as follows -:

   The label must begin with a colon character, ':'.
   There must be at least one or more characters after the colon.
   The label can not be longer than 8 characters.
   The label must not contain -:
       whitespace (space, tab, newline)
       Any of the following punctuation : % * + | \ [ ] " < > / . , : ; =

As a general rule, label names should be meaningful and should not be the same
name as a batch file command or an internal or external MS DOS command.

Example label names -:

   :START - used to specify the start of a section
   :LOOP - used to specify the start of a loop
   :END - used to specify the end of a batch file
   :ERROR - used to specify the location of error handling code


## String Literals

### Single quoted

### Double quoted

### Document String - Double or Single Triple-Quoted

### Backslash quoted


## Comment

### Single line comment
REM
::

### Multi line comment

### Block comment

### Java Doc

### Here Doc

### Now Doc


## Classes & Methods


## Function


## Grammar

BNF | ABNF | EBNF | XBNF
