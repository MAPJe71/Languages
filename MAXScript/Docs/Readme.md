
# MAXScript

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
MAXScript
=========

[WWW](http://docs.autodesk.com/3DSMAX/14/ENU/MAXScript%20Help%202012/)


## FileExtensions

```
.ms
.mcr
```

## Keywords

```
    about and animate as at
    by
    case catch collect continue coordsys
    do
    else exit
    fn for from function
    global
    if in
    local
    macroscript mapped max
    not
    of off on or
    parameters persistent plugin
    rcmenu return rollout
    set struct
    then throw to tool try
    undo utility
    when where while with
```

    A RegEx to find them all:
```
    \b(?!(?-i:
        a(?:bout|n(?:d|imate)|[st])
    |   by
    |   c(?:a(?:se|tch)|o(?:llect|ntinue|ordsys))
    |   do
    |   e(?:lse|xit)
    |   f(?:n|or|rom|unction)
    |   global
    |   i[fn]
    |   local
    |   ma(?:croscript|pped|x)
    |   not
    |   o(?:ff?|[nr])
    |   p(?:arameters|ersistent|lugin)
    |   r(?:cmenu|eturn|ollout)
    |   s(?:et|truct)
    |   t(?:hen|hrow|o(?:ol)?|ry)
    |   u(?:ndo|tility)
    |   w(?:h(?:e(?:n|re)|ile)|ith)
    )\b)
```

## Identifiers

Names start with an alphabetic character or "_" (underscore),
and can contain any number of alphanumeric characters or "_".

VALID NAMES:
    foo
    bar123
    this_is_a_very_long_identifier
    _heresOneWithStudlyCaps

INVALID Names:
    1object                 First character not an alphabetic character
    pressed?                ? is not a valid alphanumeric character
    a big number            spaces not allowed in names
    seven(7)                ( and ) are not valid alphanumeric characters

In contrast to most general purpose programming languages, MAXScript names
are not case-sensitive. For example,the names in the following list refer
to the same variable in MAXScript:

    BitMapTexture
    bitmaptexture
    BITMAPtexture

```
<var_name>          ::= { <alphanumeric> | '_' }
                        ''' { <any_char_except_quote> } '''
```

## StringLiterals


" ... "
@" ... "

```
<string>            ::= '"' { <any_char_except_quote> | '\"' | '\n' | '\r' | '\t' | '\*' | '\?' | '\\' | '\%' | '\x' {<hex_digit>}+ } '"'
```

## Comment

```
    -- Line comment
    /* block comment */
```

## Classes and Methods

```
<struct_def>        ::= 'struct' <var_name> '(' <member> { ',' <member> } ')'

<macroscript_def>   ::= 'macroscript' <var_name> <string> { <var_name> ':' <operand> } '(' <expr_seq> ')'


<var_name>          ::= { <alphanumeric> | '_' }
                        ''' { <any_char_except_quote> } '''

<member>            ::= <name> [ '=' <expr> ]                                   -- name and optional initial value
                        <function_def>

<string>            ::= '"' { <any_char_except_quote> | '\"' | '\n' | '\r' | '\t' | '\*' | '\?' | '\\' | '\%' | '\x' {<hex_digit>}+ } '"'

<operand>           ::= <factor>
                        <property>
                        <index>

<expr_seq>          ::= '(' <expr> { ( ';' | <eol> ) <expr> } ')'
```

## Functions

```
<function_def>      ::= [ 'mapped' ] ( 'function' | 'fn' ) <var_name> { <arg> } '=' <expr>

<var_name>          ::= { <alphanumeric> | '_' }
                        ''' { <any_char_except_quote> } '''

<arg>               ::= <var_name>
                        <var_name> ':' [ <operand> ]
```

## Grammar

see file 'MAXScript.EBNF.txt'

```
(?'program'(?&expr)+)

(?'expr'
    (?&simple_expr)
|   (?&struct_def)
|   (?&function_def)
|   (?&utility_def)
|   (?&rollout_def)
|   (?&rcmenu_def)
|   (?&macroscript_def)
|   (?&plugin_def)
)

(?'decl'
    (?&var_name)
    (?:
        \s*
        =
        \s*
        (?&expr)
    )?
)

(?'struct_def'
    struct
    \s+
    (?&var_name)
    \s*
    \(
        (?&member)
        (?:
            \s*
            ,
            \s*
            (?&member)
    )*
    \)
)

(?'member'
    (?&decl)
|   (?&function_def)
)

(?'function_def'
    (?:
        mapped
        \s+
    )?
    (?:function|fn)
    \s+
    (?&var_name)
    \s+
    (?:
        (?'arg'
            (?&var_name)
            (?:
                \s*
                :
                \s*
                (?&operand)?
            )?
        )
    )*
    \s*
    =
    \s*
    (?&expr)
)

(?'utility_def'
    utility
    \s+
    (?&var_name)
    \s+
    (?&string)
    (?:
        \s+
        (?&var_name)
        \s*
        :
        \s*
        (?&operand)
    )*
    \s*
    \(
    (?&utility_clause)+
    \)
)

(?'utility_clause'
    (?&rollout)
|   (?&rollout_clause)
)

(?'rollout_def'
    rollout
    \s+
    (?&var_name)
    \s+
    (?&string)
    (?:
        \s+
        (?&var_name)
        \s*
        :
        \s*
        (?&operand)
    )*
    \s*
    \(
    (?&rollout_clause)+
    \)
)

(?'rollout_clause'
    local\s+(?&decl)(?:\s*,\s*(?&decl))*
|   (?&function_def) 
|   (?&struct_def)
|   (?&mousetool)
|   (?'item_group'
        group
        \s+
        (?&string)
        \s*
        \(
        (?&rollout_item)*
        \)
    )
|   (?&rollout_item) 
|   (?&rollout_handler)
)

(?'rollout_handler'
    on
    \s+
    (?&var_name)
    \s+
    (?&var_name)
    (?:
        \s
        (?&var_name)
    )*
    \s+
    do
    \s+
    (?&expr)
)

(?'rollout_item'
    (?'item_type'
        label
    |   button
    |   edittext
    |   combobox
    |   dropdownList
    |   listbox
    |   spinner
    |   slider
    |   pickbutton
    |   radiobuttons
    |   checkbox
    |   checkbutton
    |   colorPicker
    |   mapbutton
    |   materialbutton
    |   progressbar
    |   timer
    |   bitmap
    )
    \s+
    (?&var_name)
    (?:
        \s+
        (?&string)
    )?
    (?:
        \s+
        (?&var_name)
        \s*
        :
        \s*
        (?&operand)
    )*
)

(?'rcmenu_def'
    rcmenu
    \s+
    (?&var_name)
    \s*
    \(
    (?:
        (?'rcmenu_clause'
            local\s+(?&decl)(?:\s*,\s*(?&decl))*
        |   (?&function_def) 
        |   (?&struct_def)
        |   (?'rcmenu_item'(?'rcmenu_item_type'menuitem|separator|submenu)\s+(?&var_name)\s+(?&string)(?:\s+(?&var_name)\s*:\s*(?&operand))*) 
        |   (?'rcmenu_handler'on\s+(?&var_name)\s+(?&var_name)\s+do\s+(?&expr))
        )
    )+
    \)
)


(?'macroscript_def'
    macroscript
    \s+
    (?&var_name)
    \s+
    (?&string)
    (?:
        \s+
        (?&var_name)
        \s*
        :
        \s*
        (?&operand)
    )*
    \s*
    \(
    \s*
    (?&expr_seq)
    \s*
    \)
)

(?'mousetool_def'
    tool
    \s+
    (?&var_name)
    (?:
        \s+
        (?&var_name)
        \s*
        :
        \s*
        (?&operand)
    )*
    \s*
    \(
    \s*
    (?:
        (?'tool_clause'
            local\s+(?&decl)(?:\s*,\s*(?&decl))*
        |   (?&function_def) 
        |   (?&struct_def)
        |   (?'tool_handler'
                on
                \s+
                (?&var_name)
                \s+
                (?&var_name)
                (?:
                    \s+
                    (?&var_name)
                )*
                \s+
                do
                \s+
                (?&expr)
            )
        )
    )+
    \s*
    \)
)


(?'plugin_def'
    plugin
    \s+
    (?&var_name)
    \s+
    (?&var_name)
    (?:
        \s+
        (?&var_name)
        \s*
        :
        \s*
        (?&operand)
    )*
    \s*
    \(
    (?:
        (?'plugin_clause'
            local\s+(?&decl)(?:\s*,\s*(?&decl))*
        |   (?&function_def)
        |   (?&struct_def)
        |   (?&mousetool_def)
        |   (?&rollout_def)
        |   (?&parameters)
        |   (?'plugin_handler'on\s+(?&var_name)\s+do\s+(?&expr))
        )
    )+
    \)
)

(?'parameters'
    parameters
    \s+
    (?&var_name)
    (?:
        \s+
        (?&var_name)
        \s*
        :
        \s*
        (?&operand)
    )*
    \s*
    \(
    (?:
        (?'param_clause'
            (?:
                (?'param_defs'
                    (?&var_name)
                    (?:
                        \s+
                        (?&var_name)
                        \s*
                        :
                        \s*
                        (?&operand)
                    )*
                )
            )+
        |   (?:
                (?'param_handler'
                    on
                    \s+
                    (?&var_name)
                    \s+
                    (?&var_name)
                    (?:
                        \s+
                        (?&var_name)
                    )*
                    \s+
                    do
                    \s+
                    (?&expr)
                )
            )*
        )
    )+
    \)
)



(?'simple_expr'
    (?&operand)
|   (?&math_expr)
|   (?&compare_expr)
|   (?&logical_expr)
|   (?&function_call)
|   (?&expr_seq)
)

(?'math_expr'
    (?&math_operand)
    \s+
    (?:
        [+\-*/\^]
        \s+
        (?&math_operand)
    |   as
        \s+
        (?&class)
    )
)

(?'math_operand'
    (?&operand)
|   (?&function_call)
|   (?&math_expr)
)

(?'logical_expr'
    (?:
        (?&logical_operand)
        \s+
        (?:
            or
        |   and
        )
    |   not
    )
    \s+
    (?&logical_operand)
)

(?'logical_operand'
    (?&operand)
|   (?&compare_expr)
|   (?&function_call)
|   (?&logical_expr)
)

(?'compare_expr'
    (?&compare_operand)
    \s*
    (?:
        [=!]
        =
    |   >
        =?
    |   <
        =?
    )
    \s+
    (?&compare_operand)
)

(?'compare_operand'
    (?&math_expr)
|   (?&operand)
|   (?&function_call)
)

(?'function_call'
    (?&operand)
    (?:
        \(
        \x20
        \)
    |   (?&operand)
        (?&parameter)*
    )
)

(?'parameter'
    (?:
        (?&name)
        \s*
        :
        \s*
    )?
    (?&operand)
)

(?'operand'
    (?&factor)
|   (?&property)
|   (?&index)
)

(?'property'
    (?&operand)
    \.
    (?&var_name)
)

(?'index'
    (?&operand)
    (?&expr)?
)

(?'factor'
    (?&number)
|   (?&string)
|   (?'path_name'\$(?'path'(?&objectset)?/?(?'levels'(?&level_name)(?:/(?&level_name))*)?(?&level_name))?)
|   \#?(?&var_name)
|   (?'array'\#\((?:(?&expr)(?:,(?&expr))*)?\))
|   (?'bitarray'\#\{(?:(?:(?&expr)|(?&expr)\.\x20\.(?&expr))?(?:,(?:(?&expr)|(?&expr)\.\x20\.(?&expr))?)*)?\})
|   (?'box2'\[(?&expr),(?&expr),(?&expr),(?&expr)\])
|   (?'point3'\[(?&expr),(?&expr),(?&expr)\])
|   (?'point2'\[(?&expr),(?&expr)\])
|   (?:true|false|on|off|ok|undefined|unsupplied|\?)
|   -(?&expr)
|   (?&expr_seq)
)

(?'expr_seq'
    \(
    (?&expr)
    (?:
        (?:
            ;
        |   \R
        )
        (?&expr)
    )*
    \)
)

(?'number'
    -?
    (?&digit)*
    (?:
        \.
        (?&digit)*
        (?:
            [eE]
            [+-]?
        )?
        (?&digit)+
    )?
|   0x
    (?&hex_digit)+
)

(?'string'
    \x22
    (?:
        (?&any_char_except_quote)
    |   \\
        (?:
            [\x22nrt*?\\%]
        |   x
            (?&hex_digit)+
        )
    )*
    \x22
)

(?'time'
    -?(?:(?&decimal_number)[msft]?)+
|   -?(?&digit)*:(?&digit)*(?:\.(?&digit)*)?
|   -?(?&decimal_number)n
)





(?'level_name'(?:(?&alphanumeric)|_|\*|\?|\\)*|\x27(?:(?&any_char_except_single_quote)|\\[*?\\])\x27)

(?'alphanumeric'[A-Za-z0-9])

(?'any_char_except_single_quote'[^\x27]*)

(?'digit'[0-9])

(?'hexdigit'[A-Fa-f0-9])

(?'var_name'\w*|'[^']*')

```