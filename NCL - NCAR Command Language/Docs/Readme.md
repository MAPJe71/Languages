
# NCL

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

_WWW_         http://www.ncl.ucar.edu/overview.shtml
_Wiki_        https://en.wikipedia.org/wiki/National_Center_for_Atmospheric_Research#Tools_and_technologies

NCAR        National Center for Atmospheric Research.
NCL         NCAR Command Language, a programming language designed for use with climate and model data.




Symbol set

Any printing ACSII character is a legal character in NCL:

    uppercase letters: A B C... Z
    lowercase letters: a b c... z
    digits: 0 1 2... 9
    special characters: + = _ - ( ) * & % # ! | < > . , ; : " / { } ~ \ [ ] ^ @

Also, the three non-printing characters space, newline, and tab are legal NCL characters.


Separators

White space is used to separate tokens. The valid NCL separators are space and tab.


Identifiers

Identifiers are used to give unique names to various syntactic objects (variables,
function names, and so forth) in a program. NCL identifiers must begin with an
uppercase or lowercase letter or the underscore '_' character. The rest of the
identifier name can contain any mix of these characters and any digits. The
maximum identifier name length is 256 characters.

Examples of valid identifiers:

    _A_very_long_variable_name_
    _
    temperature
    avg_temp_1988

Examples of invalid identifiers:

    temp.june
    var$8
    a variable name with spaces instead of underscores
    7june


Comments

The semicolon ';' character is used to produce comments in an NCL statement.
Comments must begin with a semicolon, and anything after the semicolon and
before the next newline character is ignored by the NCL interpreter. Comments
may appear alone in an NCL statement or after an NCL command. Comments cannot
appear on the same line before a statement because everything after the comment
character is ignored.

For example, the following are valid NCL comments:

 A comment can appear alone on a line. Everything after
 the semicolon is ignored by the interpreter.
temperature = 77.6  ; Comments can also appear with a command.


Strings

NCL character strings can be up to 256 characters long, and they may contain any
of the characters listed above in the NCL symbol set.

Strings must be enclosed in double quotes, '"'. For example, the following
statements create string variables and assign character strings to them.

string_var_1 = "This is the contents of the string variable"
string_var_2 = "Special chars (@#$%^&*_+~`;') are valid"

The maximum length of a string is 256 characters.


Keywords

NCL keywords are reserved words that have specific meaning to the NCL interpreter.
Consequently, keywords cannot be used in other contexts i.e. they cannot be used
as names for variables or functions. All keywords in NCL are case sensitive and
must appear exactly as they are listed here.

        begin
        break
        byte
        character
        continue
        create
        defaultapp
        do
        double
        else
        end
        external
        False
        file
        float
        function
        getvalues
        graphic
        if
        integer
        load
        local
        logical
        long
        new
        noparent
        numeric
        procedure
        quit
        QUIT
        Quit
        record
        return
        setvalues
        short
        stop
        string
        then
        True
        while


Functions and procedures

In NCL, a function or procedure is a name followed by arguments in parentheses
with the arguments separated by commas. A function or procedure is invoked by
referencing its name and supplying an argument list. A function returns a value,
a procedure does not. Arguments can be of any type, but facilities exist in
defining a function for imposing restrictions on the arguments, such as numbers
of dimensions and dimension sizes. For arguments that must be a certain type,
the NCL coercion rules apply. All arguments are passed by reference in NCL;
this means that a change in the value of an argument within a function or
procedure will change the value of the argument in the call. If a parameter is
coerced before a function is called, changes within the function will not be
reflected in the parameter.

Writing your own function or procedure

NCL allows you to define your own functions and procedures. NCL functions and
procedures are similar to functions and procedures in most programming languages,
but there are some distinct differences. For details on procedures in general,
see NCL procedure overview. For specifics on the syntax of defining your own
functions and procedures, see NCL functions and procedures definitions.

Procedures

NCL procedures, in many ways, are the same as in most programming languages, but
NCL procedures also have some distinct differences. The key differences are in
how the types and dimension sizes for parameters are specified and handled by
NCL. In NCL, parameters can be specified to be very constrained and require a
specific type, number of dimensions, and a dimension size for each dimension, or
parameters can have no type or dimension constraints. Parameters in NCL are
always passed by reference, meaning changes to their values, attributes,
dimension names, and coordinate variables within functions change their values
outside of the functions. There is one very important exception that does
generate a WARNING message: when a parameter must be coerced to the correct type,
the variable is not affected by changes to the parameter. Even parameters that
are subsections of variables are passed by reference. When the procedure
finishes, the values of the subsection are mapped back into their original
locations in the referenced variable.

Function and procedure definitions

Functions and procedures are defined using a similar syntax; the only difference
is that the keyword "procedure" is used instead of the keyword "function". To
define a new function, the proper keyword is entered, followed by the name to
assign the function to, followed by a list of declarations that can optionally
be followed by a list of local variable names. Finally, a block of statements
follows.

    function function_name ( declaration_list )
    local local_identifier_list
    begin
        statement list
        return(return_value) end

It is very important to note that if a variable is intended to be local to the
function or procedure does not occur in the local list that the function may
find that variable name outside of the scope of the function or procedure. It is
very important to note the consequences of not putting a local variable into the
local list. There are two possibilities. First, if the variable is defined at
the time of function definition and is in the function's scope, the variable
will be referenced. If the variable is not defined at the time of definition, it
will be an undefined variable local to the function. Placing the local
variable's name in the local list assures that the variable truly is local only
to the current function. The scope rules for NCL are identical to Pascal. The
main NCL prompt is the bottom level of NCL's scope. Function and procedure
blocks are the next level. When a variable is referenced in a function, NCL
first looks within the scope of the function for that variable. If it doesn't
exist, NCL looks in the scope containing the function and continues to search
outward until either the bottom level is reached or a variable of the correct
name is found. If it is not found, then an undefined variable reference error
message is generated.

As mentioned previously, parameters can be constrained or unconstrained. The
following shows the syntax of the variable declaration. The square brackets
( '[' and ']' ) are used to denote optional parts of the declaration syntax and
are not part of the structure of the declaration list. Each declaration in the
declaration list is separated by a comma.

Declaration list element syntax:

    variable_name [ dimension_size_list ] [ : data_type ]

Unlike the preceding example syntax, the characters '[' and ']' are part of the
syntax for the dimension size list. They are used to separate dimension sizes.
Each pair of brackets can contain an integer representing the size of the
dimension or a star to indicate that the dimension may be any size. The number
of pairs of brackets is the number of dimensions the parameter will be
constrained to.

Dimension size list syntax:

    [ dimension_size ]
    or
    [ * ]

Local variable list syntax:

    identifier_name , identifier_name , . . .

The local variable list is very important. If a local variable name is not in
the local list and the same identifier is defined in a lower scope level, then
the variable reference in the function or procedure will refer to that variable.
Sometimes this may be the desired effect. However, if the variable is to be
local, it should be referenced in the local list.

