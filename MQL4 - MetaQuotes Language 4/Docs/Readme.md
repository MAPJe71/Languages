
# MQL4

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
[MQL4] -------------------------------------------------------------------------
@=MetaQuotes Language 4

_WWW_=https://www.mql4.com/

_Wiki_=

Keywords=https://docs.mql4.com/basis/syntax/reserved

   The following identifiers are recorded as reserved words, each of them
   corresponds to a certain action, and cannot be used in another meaning:

   Data Types

       bool        enum    struct
       char        float   uchar
       class       int     uint
       color       long    ulong
       datetime    short   ushort
       double      string  void

   Access Specificators

       const   private     protected
       public  virtual

   Memory Classes

       extern  input   static

   Operators

       break       dynamic_cast    return
       case        else            sizeof
       continue    for             switch
       default     if              while
       delete      new
       do          operator

   Other

       false   #define     #property
       this    #import     template
       true    #include    typename
       strict


   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=https://docs.mql4.com/basis/syntax/identifiers

   Identifiers are used as names of variables and functions. The length of
   the identifier can not exceed 63 characters.

   Characters allowed to be written in an identifier: figures 0-9, the Latin
   uppercase and lowercase letters a-z and A-Z, recognized as different
   characters, the underscore character (_).The first character can not be
   a digit.

   The identifier must not coincide with reserved word.

StringLiterals=

Comment=https://docs.mql4.com/basis/syntax/commentaries

   Multi-line comments start with the /* pair of symbols and end with
   the */ one. Such kind of comments cannot be nested. Single-line comments
   begin with the // pair of symbols and end with the newline character, they
   can be nested in other multi-line comments. Comments are allowed everywhere
   where the spaces are allowed, they can have any number of spaces in them.

   Examples:
       //--- Single-line comment
       /*  Multi-
           line         // Nested single-line comment
           comment
       */

Classes_and_Methods=

Function=https://docs.mql4.com/basis/function

Grammar=

