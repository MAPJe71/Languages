
# C

## Description


## Links

_WWW_

_Wiki_
https://en.wikipedia.org/wiki/C_(programming_language)

C89 / C90

   In 1990, the ANSI C standard (with formatting changes) was adopted by
   the International Organization for Standardization (ISO) as ISO/IEC
   9899:1990, which is sometimes called C90. Therefore, the terms "C89"
   and "C90" refer to the same programming language.

   ...
   The standards committee also included several additional features such
   as function prototypes (borrowed from C++), void pointers, support for
   international character sets and locales, and preprocessor enhancements.
   Although the syntax for parameter declarations was augmented to include
   the style used in C++, the K&R interface continued to be permitted, for
   compatibility with existing source code.

C99

   C99 introduced several new features, including inline functions, several
   new data types (including long long int and a complex type to represent
   complex numbers), variable-length arrays and flexible array members,
   improved support for IEEE 754 floating point, support for variadic
   macros (macros of variable arity), and support for one-line comments
   beginning with //, as in BCPL or C++. Many of these had already been
   implemented as extensions in several C compilers.

   C99 is for the most part backward compatible with C90, but is stricter
   in some ways; in particular, a declaration that lacks a type specifier
   no longer has int implicitly assumed. A standard macro __STDC_VERSION__
   is defined with value 199901L to indicate that C99 support is available.
   GCC, Solaris Studio, and other C compilers now support many or all of
   the new features of C99. The C compiler in Microsoft Visual C++,
   however, implements the C89 standard and those parts of C99 that are
   required for compatibility with C++11.

C11

   The C11 standard adds numerous new features to C and the library,
   including type generic macros, anonymous structures, improved Unicode
   support, atomic operations, multi-threading, and bounds-checked
   functions. It also makes some portions of the existing C99 library
   optional, and improves compatibility with C++.


## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~
https://en.wikipedia.org/wiki/C_(programming_language)#Reserved_words

C89 reserved 32 words, and may not be used as identifiers:

   auto
   break
   case        char        const    continue
   default     do          double
   else        enum        extern
   float       for
   goto
   if          int
   long
   register    return
   short       signed      sizeof    static    struct    switch
   typedef
   union       unsigned
   void        volatile
   while

C99 reserved five more words:

   _Bool  _Complex  _Imaginary  inline  restrict

C11 reserved seven more words:

   _Alignas  _Alignof  _Atomic  _Generic  _Noreturn  _Static_assert  _Thread_local


A RegEx to find them all:

   \b(?!(?-i:
       (auto|break|goto|long|typedef|while)
   |   (c(ase|har|on(st|ntinue)))
   |   (d(efault|o(uble)?))
   |   (e(lse|num|xtern))
   |   (f(loat|or))
   |   (i(f|n(t|line)))
   |   (re(gister|strict|turn))
   |   (s(hort|i(gned|zeof)|t(atic|ruct)|witch))
   |   (un(ion|signed))
   |   (vo(id|latile))
   |   (_(A(lignas|lignof|tomic)|Bool|Complex|Generic|Imaginary|Noreturn|Static_assert|Thread_local))
   )\b)



## Identifiers
C identifiers are case sensitive (e.g., foo, FOO, and Foo are the names of different objects).

   [A-Za-z_]\w*



## String Literals

https://en.wikipedia.org/wiki/C_syntax#Strings

In C, string constants (literals) are surrounded by double quotes ("),
e.g. "Hello world!" and are compiled to an array of the specified char
values with an additional null terminating character (0-valued) code to
mark the end of the string.

String literals may not contain embedded newlines; this proscription
somewhat simplifies parsing of the language. To include a newline in
a string, the backslash escape \n may be used, as below.


Backslash escapes

If you wish to include a double quote inside the string, that can be done
by escaping it with a backslash (\), for example, "This string contains
\"double quotes\".". To insert a literal backslash, one must double it,
e.g. "A backslash looks like this: \\".

Backslashes may be used to enter control characters, etc., into a string:

   |Escape      |Meaning|
   |:---|:---|
   |\\          | Literal backslash                                           |
   |\"          | Double quote                                                |
   |\'          | Single quote                                                |
   |\n          | Newline (line feed)                                         |
   |\r          | Carriage return                                             |
   |\b          | Backspace                                                   |
   |\t          | Horizontal tab                                              |
   |\f          | Form feed                                                   |
   |\a          | Alert (bell)                                                |
   |\v          | Vertical tab                                                |
   |\?          | Question mark (used to escape trigraphs)                    |
   |%%          | Percentage mark, printf format strings only (Note \% is     |
   |            |     non standard and is not always recognised)              |
   |\ooo        | Character with octal value ooo                              |
   |\xhh        | Character with hexadecimal value hh                         |

The use of other backslash escapes is not defined by the C standard,
although compiler vendors often provide additional escape codes as language
extensions.


String literal concatenation

C has string literal concatenation, meaning that adjacent string literals
are concatenated at compile time; this allows long strings to be split over
multiple lines, and also allows string literals resulting from
C preprocessor defines and macros to be appended to strings at compile time:

   printf(__FILE__ ": %d: Hello "
          "world\n", __LINE__);

will expand to

   printf("helloworld.c" ": %d: Hello "
          "world\n", 10);

which is syntactically equivalent to

   printf("helloworld.c: %d: Hello world\n", 10);

### Single quoted

### Double quoted

### Document String - Double or Single Triple-Quoted

### Backslash quoted


## Comment

https://en.wikipedia.org/wiki/C_syntax#Comments

Text starting with the token /* is treated as a comment and ignored.
The comment ends at the next */; it can occur within expressions, and
can span multiple lines.

   /* */

C++ style line comments start with // and extend to the end of the line.
This style of comment originated in BCPL and became valid C syntax in C99;
it is not available in the original K&R C nor in ANSI C.

### Single line comment

### Multi line comment

### Block comment

### Java Doc

### Here Doc

### Now Doc


## Classes & Methods


## Function

https://en.wikipedia.org/wiki/C_syntax#Functions

A C function definition consists of a return type (void if no value is
returned), a unique name, a list of parameters in parentheses, and
various statements:

   <return-type> functionName( <parameter-list> )
   {
       <statements>
       return <expression of type return-type>;
   }

A function with non-void return type should include at least one return
statement. The parameters are given by the <parameter-list>,
a comma-separated list of parameter declarations, each item in the list
being a data type followed by an identifier:
   <data-type> <variable-identifier>, <data-type> <variable-identifier>, ....

If there are no parameters, the <parameter-list> may be left empty or
optionally be specified with the single word void.

It is possible to define a function as taking a variable number of
parameters by providing the ... keyword as the last parameter instead of
a data type and variable identifier. A commonly used function that does
this is the standard library function printf, which has the declaration:

   int printf (const char*, ...);

A pointer to a function can be declared as follows:

   <return-type> (*<function-name>)(<parameter-list>);

A declaration consists of a combination of
   type qualifier             (const, volatile)
   storage class specifier    (auto, register, extern or static) and
   type specifiers            (unsigned, signed, char, short, int, long,
                               float, double, structs, union's, enum's,
                               typedef's).

The order in which they are used may vary:

   int long unsigned extern AuthorName  /* this way?        */
   extern long unsigned int AuthorName  /* ..or this way??  */

The clearest, most portable and most common way is to start with
   storage class specifiers, follow with
   type qualifiers (if any) and then
   type specifiers.

Within type specifiers, saying int long is equivalent to saying 'man tall'.
It is proper English to put the adjectives before the noun: 'tall man'.
The C equivalent is long int. It is also common to put signed or
unsigned first. Thus:

    extern unsigned long int AuthorName  /* this way!!       */

```

   (?m)
   ^\h*
   (?'DECLARATION_SPECIFIER'
       [A-Za-z_]\w*\b
       \s*
       (?'COMMENT'(?:(?:/\*.*?\*/|/{2}[^\r\n]*\R)\s*)*)
   )+
   (?'DECLARATOR'
       (?'POINTER'(?:
           \*
           \s*
           (?&COMMENT)
           (?:
               \b
               (?-i:const|volatile)
               \b
               (?:
                   \s+
               |
                   (?&COMMENT)
               )
           )*
       )*)
       (?'DIRECT_DECLARATOR'
           (?'IDENTIFIER'
               \b(?!(?-i:
                   if|while|for|switch
               )\b)
               [A-Za-z_]\w*\b
               \s*
               (?&COMMENT)
           )
           (?'ARGUMENTS'
               \(
               [^()]*
               \)
           )
           (?'SUFFIX'
               \s*
               (?&COMMENT)
           )
       )
   )
   (?'COMPOUND_STATEMENT'
       \{
   )
```

```
#1: (?:^|(?&lt;=[\r\n]))[\t ]*(?'declaration_specifier'(?:(?'storage_class_specifier'\b(?-i:static|extern)\b)|(?'type_qualifier'\b(?-i:const|volatile)\b)|(?'type_specifier'\b(?-i:void|char|short|int|long|float|double|signed|unsigned|[A-Za-z_]\w*)\b))(?'ds_comment'\s+|(?:\s*(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r)))+))*(?'declarator'(?'pointer'[*]\s*(?'ptr_comment'(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*(?'type_qualifier2'\b(?-i:const|volatile)\b)*(?:\s+|(?:\s*(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r)))+))*(?'direct_declarator'(?'identifier'\b(?!(?-i:(?:if|while|for|switch))\b)\b[A-Za-z_]\w*\b)(?'arguments'(?:\s*(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r)))*\s*[(][^()]*[)])(?'suffix'\s*(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r)))*))(?'compound_statement'\s*[{])
#2: (?:^|(?&lt;=[\r\n]))[\t ]*(?'declaration_specifier'\b(?:(?'storage_class_specifier'(?-i:static|extern))|(?'type_qualifier'(?-i:const|volatile))|(?'type_specifier'(?-i:void|char|short|int|long|float|double|signed|unsigned|[A-Za-z_]\w*)))\b(?:\s+|\s*(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)+))*(?'declarator'(?'pointer'[*]\s*(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*(?'type_qualifier'\b(?-i:const|volatile)\b(?:\s+|(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*))*)*(?'direct_declarator'(?'identifier'\b(?!(?-i:(?:if|while|for|switch))\b)\b[A-Za-z_]\w*\b\s*(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*)(?'arguments'[(][^()]*[)])(?'suffix'\s*(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*)))(?'compound_statement'[{])
#3: (?:^|(?&lt;=[\r\n]))[\t ]*(?'declaration_specifier'\b(?:(?'storage_class_specifier'(?-i:static|extern))|(?'type_qualifier'(?-i:const|volatile))|(?'type_specifier'(?-i:void|char|short|int|long|float|double|signed|unsigned|[A-Za-z_]\w*)))\b\s*(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*)+(?'declarator'(?'pointer'[*&]\s*(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*(?'type_qualifier2'\b(?-i:const|volatile)\b(?:\s+|(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*))*)*(?'direct_declarator'(?'identifier'\b(?!(?-i:(?:if|while|for|switch))\b)\b[A-Za-z_]\w*\b\s*(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*)(?'arguments'[(][^()]*[)])(?'suffix'\s*(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*)))(?'compound_statement'[{])
#4: (?:^|(?&lt;=[\r\n]))[\t ]*(?'declaration_specifier'\b(?:(?-i:static|extern|const|volatile|void|char|short|int|long|float|double|signed|unsigned)|[A-Za-z_]\w*)\b\s*(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*)+(?'declarator'(?'pointer'[*&amp;]\s*(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*(?'type_qualifier'\b(?-i:const|volatile)\b(?:\s+|(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*))*)*(?'direct_declarator'(?'identifier'\b(?!(?-i:(?:if|while|for|switch))\b)\b[A-Za-z_]\w*\b\s*(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*)(?'arguments'[(][^()]*[)])(?'suffix'\s*(?:(?:/[*].*?[*]/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*)))(?'compound_statement'[{])
#5: (?:^|(?&lt;=[\r\n]))[\t ]*(?:\b(?:(?-i:static|extern|const|volatile|void|char|short|int|long|float|double|signed|unsigned)|[A-Za-z_]\w*)\b\s*(?:(?:/\*.*?\*/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*)+(?:[*&amp;]\s*(?:(?:/\*.*?\*/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*(?:\b(?-i:const|volatile)\b(?:\s+|(?:(?:/\*.*?\*/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*))*)*\b(?!(?-i:(?:if|while|for|switch))\b)\b[A-Za-z_]\w*\b\s*(?:(?:/\*.*?\*/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*\([^()]*\)\s*(?:(?:/\*.*?\*/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*\{
#6: (?:^|(?&lt;=[\r\n]))[\t ]*(?:\b[A-Za-z_]\w*\b\s*(?:(?:/\*.*?\*/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*)+(?:[*&amp;]\s*(?:(?:/\*.*?\*/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*(?:\b(?-i:const|volatile)\b(?:\s+|(?:(?:/\*.*?\*/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*))*)*\b(?!(?-i:(?:if|while|for|switch))\b)\b[A-Za-z_]\w*\b\s*(?:(?:/\*.*?\*/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*\([^()]*\)\s*(?:(?:/\*.*?\*/|/{2}[^\r\n]*(?:\r?\n|\r))\s*)*\{
```

## Grammar

BNF | ABNF | EBNF | XBNF

http://www.cs.man.ac.uk/~pjj/bnf/c_syntax.bnf
```
%token int_const char_const float_const id string enumeration_const
%%

translation_unit        : external_decl
                       | translation_unit external_decl
                       ;
external_decl           : function_definition
                       | decl
                       ;
function_definition     : decl_specs declarator decl_list compound_stat
                       |            declarator decl_list compound_stat
                       | decl_specs declarator           compound_stat
                       |            declarator           compound_stat
                       ;
decl                    : decl_specs init_declarator_list ';'
                       | decl_specs                      ';'
                       ;
decl_list               : decl
                       | decl_list decl
                       ;
decl_specs              : storage_class_spec decl_specs
                       | storage_class_spec
                       | type_spec          decl_specs
                       | type_spec
                       | type_qualifier     decl_specs
                       | type_qualifier
                       ;
storage_class_spec      : 'auto' | 'register' | 'static' | 'extern' | 'typedef'
                       ;
type_spec               : 'void' | 'char' | 'short' | 'int' | 'long' | 'float'
                       | 'double' | 'signed' | 'unsigned'
                       | struct_or_union_spec
                       | enum_spec
                       | typedef_name
                       ;
type_qualifier          : 'const' | 'volatile'
                       ;
struct_or_union_spec    : struct_or_union id '{' struct_decl_list '}'
                       | struct_or_union    '{' struct_decl_list '}'
                       | struct_or_union id
                       ;
struct_or_union         : 'struct' | 'union'
                       ;
struct_decl_list        :                  struct_decl
                       | struct_decl_list struct_decl
                       ;
init_declarator_list    :                          init_declarator
                       | init_declarator_list ',' init_declarator
                       ;
init_declarator         : declarator
                       | declarator '=' initializer
                       ;
struct_decl             : spec_qualifier_list struct_declarator_list ';'
                       ;
spec_qualifier_list     : type_spec      spec_qualifier_list
                       | type_spec
                       | type_qualifier spec_qualifier_list
                       | type_qualifier
                       ;
struct_declarator_list  :                            struct_declarator
                       | struct_declarator_list ',' struct_declarator
                       ;
struct_declarator       : declarator
                       | declarator ':' const_exp
                       |            ':' const_exp
                       ;
enum_spec               : 'enum' id '{' enumerator_list '}'
                       | 'enum'    '{' enumerator_list '}'
                       | 'enum' id
                       ;
enumerator_list         :                     enumerator
                       | enumerator_list ',' enumerator
                       ;
enumerator              : id
                       | id '=' const_exp
                       ;
declarator              : pointer direct_declarator
                       |         direct_declarator
                       ;
direct_declarator       : id
                       | '(' declarator ')'
                       | direct_declarator '[' const_exp       ']'
                       | direct_declarator '['                 ']'
                       | direct_declarator '(' param_type_list ')'
                       | direct_declarator '(' id_list         ')'
                       | direct_declarator '('                 ')'
                       ;
pointer                 : '*' type_qualifier_list
                       | '*'
                       | '*' type_qualifier_list pointer
                       | '*'                     pointer
                       ;
type_qualifier_list     :                     type_qualifier
                       | type_qualifier_list type_qualifier
                       ;
param_type_list         : param_list
                       | param_list ',' '...'
                       ;
param_list              :                param_decl
                       | param_list ',' param_decl
                       ;
param_decl              : decl_specs declarator
                       | decl_specs abstract_declarator
                       | decl_specs
                       ;
id_list                 :             id
                       | id_list ',' id
                       ;
initializer             : assignment_exp
                       | '{' initializer_list     '}'
                       | '{' initializer_list ',' '}'
                       ;
initializer_list        :                      initializer
                       | initializer_list ',' initializer
                       ;
type_name               : spec_qualifier_list abstract_declarator
                       | spec_qualifier_list
                       ;
abstract_declarator     : pointer
                       | pointer direct_abstract_declarator
                       |         direct_abstract_declarator
                       ;
direct_abstract_declarator: '(' abstract_declarator ')'
                       | direct_abstract_declarator '[' const_exp       ']'
                       |                            '[' const_exp       ']'
                       | direct_abstract_declarator '['                 ']'
                       |                            '['                 ']'
                       | direct_abstract_declarator '(' param_type_list ')'
                       |                            '(' param_type_list ')'
                       | direct_abstract_declarator '('                 ')'
                       |                            '('                 ')'
                       ;
typedef_name            : id
                       ;
stat                    : labeled_stat
                       | exp_stat
                       | compound_stat
                       | selection_stat
                       | iteration_stat
                       | jump_stat
                       ;
labeled_stat            : id               ':' stat
                       | 'case' const_exp ':' stat
                       | 'default'        ':' stat
                       ;
exp_stat                : exp ';'
                       |     ';'
                       ;
compound_stat           : '{' decl_list stat_list '}'
                       | '{'           stat_list '}'
                       | '{' decl_list           '}'
                       | '{'                     '}'
                       ;
stat_list               :           stat
                       | stat_list stat
                       ;
selection_stat          : 'if'     '(' exp ')' stat
                       | 'if'     '(' exp ')' stat 'else' stat
                       | 'switch' '(' exp ')' stat
                       ;
iteration_stat          :           'while' '(' exp                 ')' stat
                       | 'do' stat 'while' '(' exp                 ')' ';'
                       | 'for'             '(' exp ';' exp ';' exp ')' stat
                       | 'for'             '(' exp ';' exp ';'     ')' stat
                       | 'for'             '(' exp ';'     ';' exp ')' stat
                       | 'for'             '(' exp ';'     ';'     ')' stat
                       | 'for'             '('     ';' exp ';' exp ')' stat
                       | 'for'             '('     ';' exp ';'     ')' stat
                       | 'for'             '('     ';'     ';' exp ')' stat
                       | 'for'             '('     ';'     ';'     ')' stat
                       ;
jump_stat               : 'goto' id    ';'
                       | 'continue'   ';'
                       | 'break'      ';'
                       | 'return' exp ';'
                       | 'return'     ';'
                       ;
exp                     :         assignment_exp
                       | exp ',' assignment_exp
                       ;
assignment_exp          : conditional_exp
                       | unary_exp assignment_operator assignment_exp
                       ;
assignment_operator     : '=' | '*=' | '/=' | '%=' | '+=' | '-=' | '<<='
                       | '>>=' | '&=' | '^=' | '|='
                       ;
conditional_exp         : logical_or_exp
                       | logical_or_exp '?' exp ':' conditional_exp
                       ;
const_exp               : conditional_exp
                       ;
logical_or_exp          :                     logical_and_exp
                       | logical_or_exp '||' logical_and_exp
                       ;
logical_and_exp         :                      inclusive_or_exp
                       | logical_and_exp '&&' inclusive_or_exp
                       ;
inclusive_or_exp        :                      exclusive_or_exp
                       | inclusive_or_exp '|' exclusive_or_exp
                       ;
exclusive_or_exp        :                      and_exp
                       | exclusive_or_exp '^' and_exp
                       ;
and_exp                 :             equality_exp
                       | and_exp '&' equality_exp
                       ;
equality_exp            :                   relational_exp
                       | equality_exp '==' relational_exp
                       | equality_exp '!=' relational_exp
                       ;
relational_exp          :                     shift_expression
                       | relational_exp '<'  shift_expression
                       | relational_exp '>'  shift_expression
                       | relational_exp '<=' shift_expression
                       | relational_exp '>=' shift_expression
                       ;
shift_expression        :                       additive_exp
                       | shift_expression '<<' additive_exp
                       | shift_expression '>>' additive_exp
                       ;
additive_exp            :                  mult_exp
                       | additive_exp '+' mult_exp
                       | additive_exp '-' mult_exp
                       ;
mult_exp                :              cast_exp
                       | mult_exp '*' cast_exp
                       | mult_exp '/' cast_exp
                       | mult_exp '%' cast_exp
                       ;
cast_exp                : unary_exp
                       | '(' type_name ')' cast_exp
                       ;
unary_exp               : postfix_exp
                       | '++'           unary_exp
                       | '--'           unary_exp
                       | unary_operator cast_exp
                       | 'sizeof'       unary_exp
                       | 'sizeof' '(' type_name ')'
                       ;
unary_operator          : '&' | '*' | '+' | '-' | '~' | '!'
                       ;
postfix_exp             : primary_exp
                       | postfix_exp '[' exp               ']'
                       | postfix_exp '(' argument_exp_list ')'
                       | postfix_exp '('                   ')'
                       | postfix_exp '.'  id
                       | postfix_exp '->' id
                       | postfix_exp '++'
                       | postfix_exp '--'
                       ;
primary_exp             : id
                       | const
                       | string
                       | '(' exp ')'
                       ;
argument_exp_list       :                       assignment_exp
                       | argument_exp_list ',' assignment_exp
                       ;
const                   : int_const
                       | char_const
                       | float_const
                       | enumeration_const
                       ;

```