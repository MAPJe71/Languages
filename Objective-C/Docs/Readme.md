
# Objective-C

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
[Objective-C] ------------------------------------------------------------------
@=Objective-C

_WWW_=

_Wiki_=https://en.wikipedia.org/wiki/Objective-C

Keywords=

   CGFloat NSInteger NSNumber NSObject _Packed auto break case char const
   continue default do double else enum extern float for goto if implementation
   int interface long nonatomic; property protocol readonly readwrite register
   retain return short signed sizeof static strong struct switch typedef union
   unsafe_unretained; unsigned void volatile weak while

   A RegEx to find them all:

       \b(?!(?-i:
           auto
       |   break
       |   c(?:ase|har|on(?:st|tinue))
       |   d(?:efault|o(?:uble)?)
       |   e(?:lse|num|xtern)
       |   f(?:loat|or)
       |   goto
       |   i(?:f|mplementation|nt(?:erface)?)
       |   long
       |   nonatomic
       |   pro(?:perty|tocol)
       |   re(?:ad(?:only|write)|gister|t(?:ain|urn))
       |   s(?:hort|i(?:gned|zeof)|t(?:atic|r(?:ong|uct))|witch)
       |   typedef
       |   un(?:ion|safe_unretained|signed)
       |   vo(?:id|latile))
       |   w(?:eak|hile)
       |   NS(?:Integer|Number|Object)
       |   CGFloat
       |   _Packed
       )\b)

Identifiers=

   An identifier starts with a letter A to Z or a to z or an underscore _ followed
   by zero or more letters, underscores, and digits (0 to 9).

       [A-Za-z_]\w*

StringLiterals=

Comment=

   Single line comments begin with two forward slashes: //.
   Everything on the line after the forward slashes makes up the comment and
   is completely ignored by the program.

   Sometimes we want longer comments that span more than one line. In that case
   we use an opening marker to mark the start of the comment: /*, and a closing
   marker to mark the end of the comment: */.

Classes_and_Methods=

Function=

   The general form of a method definition in Objective-C programming language
   is as follows:

   - (return_type) method_name:( argumentType1 )argumentName1
   joiningArgument2:( argumentType2 )argumentName2 ...
   joiningArgumentn:( argumentTypen )argumentNamen
   {
      body of the function
   }

   A method definition in Objective-C programming language consists of a method
   header and a method body. Here are all the parts of a method:

       Return Type     : A method may return a value. The return_type is
                           the data type of the value the function returns.
                           Some methods perform the desired operations without
                           returning a value. In this case, the return_type is the keyword void.
       Method Name     : This is the actual name of the method. The method
                           name and the parameter list together constitute
                           the method signature.
       Arguments       : A argument is like a placeholder. When a function is
                           invoked, you pass a value to the argument.
                           This value is referred to as actual parameter or
                           argument. The parameter list refers to the type,
                           order, and number of the arguments of a method.
                           Arguments are optional; that is, a method may
                           contain no argument.
       Joining Argument: A joining argument is to make it easier to read and
                           to make it clear while calling it.
       Method Body     : The method body contains a collection of statements
                           that define what the method does.


   Method Declarations:

   A method declaration tells the compiler about a function name and how to
   call the method. The actual body of the function can be defined separately.

   A method declaration has the following parts:

   - (return_type) function_name:( argumentType1 )argumentName1
   joiningArgument2:( argumentType2 )argumentName2 ...
   joiningArgumentn:( argumentTypen )argumentNamen;

   For the above-defined function max(), following is the method declaration:

   -(int) max:(int)num1 andNum2:(int)num2;

   Method declaration is required when you define a method in one source file
   and you call that method in another file. In such case you should declare
   the function at the top of the file calling the function.

Grammar=

