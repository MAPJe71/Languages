
# Squirrel

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
[Squirrel] ---------------------------------------------------------------------
 .nut      reqular scripts             (official/conventional)
 .cnut     precompiled byte code       (official/conventional)
 .nuc      precompiled byte code       (Valve)
 .sqr      reqular scripts
@=Squirrel

_WWW_=http://squirrel-lang.org/

_Wiki_=https://en.wikipedia.org/wiki/Squirrel_(programming_language)

Keywords=

   base        break  case     catch     class     clone
   continue    const  default  delete    else      enum
   extends     for    foreach  function  if        in
   local       null   resume   return    switch    this
   throw       try    typeof   while     yield     constructor
   instanceof  true   false    static    __LINE__  __FILE__


   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=

   Identifiers start with a alphabetic character or `_` followed by any number
   of alphabetic characters, `_` or digits ([0-9]). Squirrel is a case sensitive
   language, this means that the lowercase and uppercase representation of the
   same alphabetic character are considered different characters. For instance
   “foo”, “Foo” and “fOo” will be treated as 3 distinct identifiers.

Operators=

   !    !=  ||  ==  &&  >=   <=  >
   <=>  +   +=  -   -=  /    /=  *
   *=   %   %=  ++  --  <-   =   &
   ^    |   ~   >>  <<  >>>

Other_Tokens=

   {   }  [  ]  .  :
   ::  '  ;  "  @"

StringLiterals=

Comment=

   The /* (slash, asterisk) characters, followed by any sequence of characters
   (including new lines), followed by the */ characters. This syntax is the
   same as ANSI C.
   The // (two slashes) characters, followed by any sequence of characters. A
   new line not immediately preceded by a backslash terminates this form of
   comment. It is commonly called a “single-line comment.”
   The character # is an alternative syntax for single line comment.

Classes_and_Methods=

   memberdecl  := id '=' exp [';'] | '[' exp ']' '=' exp [';'] | functionstat | 'constructor' functionexp
   stat        := 'class' derefexp ['extends' derefexp] '{' [memberdecl] '}'

Function=

   funcname    := id ['::' id]
   stat        := 'function' id ['::' id]+ '(' args ')' stat

   Functions are declared through the function expression:

   local a = function(a, b, c) { return a + b - c; }

   or with the syntactic sugar:

   function ciao(a,b,c)
   {
       return a+b-c;
   }

   that is equivalent to:

   this.ciao <- function(a,b,c)
   {
       return a+b-c;
   }

   a local function can be declared with this syntactic sugar:

   local function tuna(a,b,c)
   {
       return a+b-c;
   }

   that is equivalent to:

   local tuna = function(a,b,c)
   {
       return a+b-c;
   }

   is also possible to declare something like:

   T <- {}
   function T::ciao(a,b,c)
   {
       return a+b-c;
   }

   //that is equivalent to write

   T.ciao <- function(a,b,c)
   {
       return a+b-c;
   }

   //or

   T <- {
       function ciao(a,b,c)
       {
           return a+b-c;
       }
   }

Grammar=

