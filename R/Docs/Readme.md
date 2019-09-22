
# R

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
[R] ----------------------------------------------------------------------------
@=R

_WWW_=https://www.r-project.org/

_Wiki_=https://en.wikipedia.org/wiki/R_(programming_language)

Keywords=

   The following identifiers have a special meaning and cannot be used for object names

       if else repeat while function for in next break
       TRUE FALSE NULL Inf NaN
       NA NA_integer_ NA_real_ NA_complex_ NA_character_
       ... ..1 ..2 etc.

   A RegEx to find them all:

       \b(?!(?-i:
           FALSE|TRUE|
       |   N(?:aN|A_(?:character|complex|integer|real)_|ULL)
       |   Inf
       |   break
       |   else
       |   f(?:or|unction)
       |   i[fn]
       |   next
       |   repeat
       |   while
       )\b)

Identifiers=(?'ID'(?:[A-Za-z]|\.[A-Za-z_.])[\w.]*)

   Identifiers consist of a sequence of letters, digits, the period (`.`) and
   the underscore. They must not start with a digit or an underscore, or with
   a period followed by a digit.

   The definition of a letter depends on the current locale: the precise set
   of characters allowed is given by the C expression (isalnum(c) || c == `.`
   || c == `_`) and will include accented letters in many Western European
   locales.

   1.  Names must start with a letter or a dot. If you start a name with
       a dot, the second character can`t be a digit.
   2.  Names should contain only letters, numbers, underscore characters (_),
       and dots (.). Although you can force R to accept other characters in
       names, you shouldn`t, because these characters often have a special
       meaning in R.
   3.  You can`t use the following special keywords as names:
           break  else  FALSE  for     function  if    Inf
           NA     NaN   next   repeat  return    TRUE  while

StringLiterals=

Comment=
   Any text from a # character to the end of the line is taken to be a comment,
   unless the # character is inside a quoted string. For example,

   > x <- 1  # This is a comment...
   > y <- "  #... but this is not."

Classes_and_Methods=

Function=
   A function definition is of the form

       function ( arglist ) body

   The function body is an expression, often a compound expression.
   The arglist is a comma-separated list of items each of which can be an
   identifier, or of the form `identifier = default`, or the special token
   `...`. The default can be any valid expression.

   Notice that function arguments unlike list tags, etc., cannot have “strange
   names” given as text strings.

   functionname <- function(arg1, arg2, ... ){ # declare name of function and function arguments
       statements                              # declare statements
       return(object)                          # declare object data type
   }

Grammar=

