
# RAPID

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
[RAPID] ---------------------------------------------------------------------
@=ABB RAPID

_WWW_=http://new.abb.com/products/robotics

_Wiki_=

Keywords=

   ALIAS  AND
   BACKWARD
   CASE  CONNECT  CONST
   DEFAULT  DIV  DO
   ELSE  ELSEIF  ENDFOR  ENDFUNC  ENDIF  ENDMODULE  ENDPROC  ENDRECORD  ENDTEST  ENDTRAP  ENDWHILE  ERROR  EXIT
   FALSE  FOR  FROM  FUNC
   GOTO
   IF  INOUT
   LOCAL
   MOD  MODULE
   NOSTEPIN  NOT  NOVIEW
   OR
   PERS  PROC
   RAISE  READONLY  RECORD  RETRY  RETURN
   STEP  SYSMODULE
   TEST  THEN  TO  TRAP  TRUE  TRYNEXT
   UNDO
   VAR  VIEWONLY
   WHILE WITH
   XOR

   A RegEx to find them all:

       \b(?!(?-i:
           A(?:LIAS|ND)
       |   BACKWARD
       |   C(?:ASE|ON(?:NECT|ST))
       |   D(?:EFAULT|IV|O)
       |   E(?:LSE(?:IF)?|ND(?:F(?:OR|UNC)|IF|MODULE|PROC|RECORD|T(?:EST|RAP)|WHILE)|RROR|XIT)
       |   F(?:ALSE|OR|ROM|UNC)
       |   GOTO
       |   I(?:F|NOUT)
       |   LOCAL
       |   MOD(?:ULE)?
       |   NO(?:STEPIN|T|VIEW)
       |   X?OR
       |   P(?:ERS|ROC)
       |   R(?:AISE|E(?:ADONLY|CORD|T(?:RY|URN)))
       |   S(?:TEP|YSMODULE)
       |   T(?:EST|HEN|O|R(?:AP|UE|YNEXT))
       |   UNDO
       |   V(?:AR|IEWONLY)
       |   W(?:HILE|ITH)
       )\b)

CharacterSet=

   Sentences of the RAPID language are constructed using the standard
   ISO 8859-1 (Latin-1) character set. In addition newline, tab and formfeed
   control characters are recognized.

   <character>         ::= -- ISO 8859-1 (Latin-1) --
   <newline>           ::= -- newline control character --
   <tab>               ::= -- tab control character --
   <digit>             ::= 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
   <hex digit>         ::= <digit> | A | B | C | D | E | F | a | b | c | d | e | f
   <letter>            ::= <upper case letter> | <lower case letter>
   <upper case letter> ::= A | B | C | D | E | F | G | H | I | J | K | L | M
                         | N | O | P | Q | R | S | T | U | V | W | X | Y | Z
                         | À | Á | Â | Ã | Ä | Å | Æ | Ç | È | É | Ê | Ë | Ì
                         | Í | Î | Ï | 1)| Ñ | Ò | Ó | Ô | Õ | Ö | Ø | Ù | Ú
                         | Û | Ü | 2)| 3)| ß
   <lower case letter> ::= a | b | c | d | e | f | g | h | i | j | k | l | m
                         | n | o | p | q | r | s | t | u | v | w | x | y | z
                         | à | á | â | ã | ä | å | æ | ç | è | é | ê | ë | ì
                         | í | î | ï | 1)| ñ | ò | ó | ô | õ | ö | ø | ù | ú
                         | û | ü | 2)| 3)| ß | ÿ

   1) Icelandic letter eth.
   2) Letter Y with acute accent.
   3) Icelandic letter thorn.

Identifiers=

   Identifiers are used for naming objects.

       <identifier> ::= <ident> | <ID>
       <ident>      ::= <letter> { <letter> | <digit> | ’_’ }
                     ::= [A-Z\xC0-\xD6\xD8-\xDFa-z\xE0-\xF6\xF8-FF][A-Z\xC0-\xD6\xD8-\xDFa-z\xE0-\xF6\xF8-FF\d_]{0,31}

   The maximum length of an identifier is 32 characters. All characters of an
   identifier are significant. Identifiers differing only in the use of
   corresponding upper and lower case letters are considered the same.
   The placeholder <ID> (see  Placeholders on page 5 and 2.9 Placeholders on
   page 13) can be used to represent an identifier.

StringLiterals=

   A string literal is a sequence of zero or more characters enclosed by the
   double quote (") character.

       <string literal> ::= ’"’ { <character> | <character code> } ’"’
       <character code> ::= ’\’ <hex digit> <hex digit>

   The possibility to use character codes provides a means to include non
   printable characters (binary data) in string literals. If a back slash or
   double quote character should be included in a string literal it must be
   written twice.
   e.g.
       "A string literal"
       "Contains a "" character"
       "Ends with BEL control character\07"
       "Contains a \\ character"

Comment=

   A comment starts with an exclamation point and is terminated by a newline
   character. A comment can never include a newline character.

       <comment> ::= ’!’ { <character> | <tab> } <newline>

   Comments have no effect on the meaning of an RAPID code sequence, their sole
   purpose is the enlightenment of the reader. Each RAPID comment occupies an
   entire source line and may occur either as:
   - an element of a type definition list (see 3),
   - an element of a record component list,
   - an element of a data declaration list (see 5.3 Procedure declarations on page 54),
   - an element of a routine declaration list (see 9.1 Module declarations on page 80) or
   - an element of a statement list (see 4.2 Statement lists on page 40).

   e.g.
       ! Increase length
       length := length + 5;
       IF
           length < 1000
       OR
           length > 14000
       THEN
          ! Out of bounds
       EXIT
       ;
       ENDIF
       ...

   Comments located between the last data declaration (see 2.18 Data
   declarations on page 22) and the first routine declaration (see 5 Routine
   declarations on page 51) of a module are regarded to be a part of the
   routine declaration list. Comments located between the last data declaration
   and the first statement of a routine are regarded to be a part of the
   statement list (see 4.2 Statement lists on page 40).

Classes_and_Methods=

   A module declaration specifies the name, attributes and body of a module.
   A module name hides any predefined object with the same name. Two different
   modules may not share the same name. A module and a global module object
   (type, data object or routine) may not share the same name. Module
   attributes provide a means to modify some aspects of the systems treatment
   of a module when it is loaded to the task buffer. The body of a module
   declaration contains a sequence of data declarations followed by a sequence
   of routine declarations.

       <module declaration>    ::= MODULE <module name> [ <module attribute list> ]
                                   <type definition list>
                                   <data declaration list>
                                   <routine declaration list>
                                   ENDMODULE
       <module name> ::= <identifier>
       <module attribute list> ::= ’(’ <module attribute> { ’,’ <module attribute> } ’)’
       <module attribute>      ::= SYSMODULE
                                 | NOVIEW
                                 | NOSTEPIN
                                 | VIEWONLY
                                 | READONLY
       <routine declaration list>
                               ::= { <routine declaration> }
       <type definition list>  ::= { <type definition> }
       <data declaration list> ::= { <data declaration> }


   The module attributes have the following meaning:

       attribute   if specified, the module ..
       --------------------------------------------------------------------
       SYSMODULE   .. is a system module, otherwise a task module
       NOVIEW      .. (it’s source code) cannot be viewed (only executed)
       NOSTEPIN    .. cannot be entered during stepwise execution
       VIEWONLY    .. cannot be modified.
       READONLY    .. cannot be modified, but the attribute can be removed.

   An attribute may not be specified more than once. If present, attributes must be
   specified in table order (see above). The specification of noview excludes nostepin,
   viewonly and readonly (and vice versa). The specification of viewonly excludes
   readonly (and vice versa).

   (?-i:
       SYSMODULE
   |                       (?: NOVIEW | NOSTEPIN (?: \h* , \h* (?: VIEWONLY | READONLY ) )? )
   |   SYSMODULE \h* , \h* (?: NOVIEW | NOSTEPIN (?: \h* , \h* (?: VIEWONLY | READONLY ) )? )
   )

   (?-i:
       (?'ATTR_FIRST' SYSMODULE )
   |                               (?'ATTR_NOTFIRST' NOVIEW | NOSTEPIN (?: (?'ATTR_SEP' \h* , \h* ) (?: VIEWONLY | READONLY ) )? )
   |   (?&ATTR_FIRST) (?&ATTR_SEP) (?&ATTR_NOTFIRST)
   )

Labels=

   Labels are "no operation" statements used to define named program positions.
   The goto statement (see 4.6 Goto statement on page 44) causes the execution
   to continue at the position of a label.

       <label> ::= <identifier> ’:’

   e.g.
       next:
           ..
       GOTO next;

   The following scope rules are valid for labels:
   - The scope of a label comprises the routine in which it is contained.
   - Within its scope a label hides any predefined or user defined object with
       the same name.
   - Two labels declared in the same routine may not have the same name.
   - A label may not have the same name as a routine data object declared in
       the same routine.

Function=http://fs.gongkong.com/files/technicalData/201309/2013090913353800001.pdf#G7.48445.003

   A procedure declaration binds an identifier to a procedure definition.

       <procedure declaration> ::= PROC <procedure name>
                                       ’(’ [ <parameter list> ] ’)’
                                   <data declaration list>
                                   <statement list>
                                   [ BACKWARD <statement list> ]
                                   [ ERROR [ <error number list> ] <statement list> ]
                                   [ UNDO <statement list> ]
                                   ENDPROC
       <procedure name>        ::= <identifier>
       <data declaration list> ::= { <data declaration> }

   Note that a data declaration list can include comments (see 2.10 Comments on page 13).


   A function declaration binds an identifier to a function definition.

       <function declaration>  ::= FUNC <data type> <function name>
                                       ’(’ [ <parameter list> ] ’)’
                                   <data declaration list>
                                   <statement list>
                                   [ ERROR [ <error number list> ] <statement list> ]
                                   [ UNDO <statement list> ]
                                   ENDFUNC
       <function name>         ::= <identifier>

   Functions can have (return) any value data type (including any available
   installed type). A function cannot be dimensioned, i.e. a function cannot
   return an array value.

   The evaluation of a function must be terminated by a return statement (see
   4.7 Return statement on page 44).


   A trap declaration binds an identifier to a trap definition. A trap routine
   can be associated with an interrupt (number) by using the connect statement
   (see 4.12 Connect statement on page 47). Note that one trap routine may be
   associated with many (or no) interrupts.

       <trap declaration>      ::= TRAP <trap name>
                                   <data declaration list>
                                   <statement list>
                                   [ ERROR [ <error number list> ] <statement list> ]
                                   [ UNDO <statement list> ]
                                   ENDTRAP
       <trap name>             ::= <identifier>

   The evaluation of the trap routine is explicitly terminated using the return
   statement (see 4.7 Return statement on page 44) or implicitly terminated by
   reaching the end (endtrap, error or undo) of the trap routine. The execution
   continues at the point of the interrupt.

Grammar=

   Each rule or group of rules are prefixed by a reference to the section
   where the rule is introduced.

   2.1:
       <character>         ::= -- ISO 8859-1 (Latin-1)--
       <newline>           ::= -- newline control character --
       <tab>               ::= -- tab control character --
       <digit>             ::= 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
       <hex digit>         ::= <digit>
                             | A | B | C | D | E | F
                             | a | b | c | d | e | f
       <letter>            ::= <upper case letter> | <lower case letters>
       <upper case letter> ::= A | B | C | D | E | F | G | H | I | J | K | L | M
                             | N | O | P | Q | R | S | T | U | V | W | X | Y | Z
                             | À | Á | Â | Ã | Ä | Å | Æ | Ç | È | É | Ê | Ë | Ì
                             | Í | Î | Ï | 1)| Ñ | Ò | Ó | Ô | Õ | Ö | Ø | Ù | Ú
                             | Û | Ü | 2)| 3)| ß
       <lower case letter> ::= a | b | c | d | e | f | g | h | i | j | k | l | m
                             | n | o | p | q | r | s | t | u | v | w | x | y | z
                             | à | á | â | ã | ä | å | æ | ç | è | é | ê | ë | ì
                             | í | î | ï | 1)| ñ | ò | ó | ô | õ | ö | ø | ù | ú
                             | û | ü | 2)| 3)| ß | ÿ

       1) Icelandic letter eth.
       2) Letter Y with acute accent.
       3) Icelandic letter thorn

   2.3:
       <identifier>        ::= <ident> | <ID>
       <ident>             ::= <letter> {<letter> | <digit> | ’_’}

   2.5:
       <num literal>       ::= <integer> [ <exponent> ]
                             | <integer> ’.’ [ <integer> ] [ <exponent> ]
                             | [ <integer> ] ’.’ <integer> [ <exponent> ]
       <integer>           ::= <digit> {<digit>}
       <exponent>          ::= (’E’ | ’e’) [’+’ | ’-’] <integer>

   2.6:
       <bool literal>      ::= TRUE | FALSE

   2.7
       <string literal>    ::= ’"’ { <character> | <character code> } ’"’
       <character code>    ::= ’\’ <hex digit> <hex digit>

   2.10:
       <comment>           ::= ’!’ { <character> | <tab> } <newline>

   2.11:
       <type definition>   ::= [ LOCAL ] ( <record definition>
                             | <alias defnition> )
                             | <comment>
                             | <DN>
       <record definition> ::= RECORD <identifier>
                               <record component list>
                               ENDRECORD
       <record component list>
                           ::= <record component definition>
                             | <record component definition>
                                   <record component list>
       <record component definition>
                           ::= <data type> <record component name> ’;’
       <alias  definition> ::= ALIAS <data type> <identifier> ’;’
       <data type>         ::= <identifier>

   2.18:
       <data declaration>  ::= [ LOCAL ] (<variable declaration>
                             | <persistent declaration>
                             | <constant declaration>)
                             | TASK (<variable declaration>
                             | <persistent declaration>
                             | <comment>
                             | <DDN>

   2.22:
       <variable declaration>
                           ::= VAR <data type> <variable definition> ’;’
       <variable definition>
                           ::= <identifier>
                                   [ ’{’ <dim> { ’,’ <dim> } ’}’ ]
                                   [ ’:=’ <constant expression> ]
       <dim>               ::= <constant expression>

   2.23:
       <persistent declaration>
                           ::= PERS <data type> <persistent definition> ’;’
       <persistent definition>
                           ::= <identifier> [ ’{’ <dim> { ’,’ <dim> } ’}’ ]
                                   [ ’:=’ <literal expression> ]

       Note!
           The literal expression may only be omitted for system global persistents.

   2.24:
       <constant declaration>
                           ::= CONST <data type> <constant definition> ’;’
       <constant definition>
                           ::= <identifier> [ ’{’ <dim> { ’,’ <dim> } ’}’ ]
                                   ’:=’ <constant expression>
       <dim>               ::= <constant expression>

   3:
       <expression>        ::= <expr> | <EXP>
       <expr>              ::= [ NOT ] <logical term> { ( OR | XOR ) <logical term> }
       <logical term>      ::= <relation> { AND <relation> }
       <relation>          ::= <simple expr> [ <relop> <simple expr> ]
       <simple expr>       ::= [ <addop> ] <term> { <addop> <term> }
       <term>              ::= <primary> { <mulop> <primary> }
       <primary>           ::= <literal>
                             | <variable>
                             | <persistent>
                             | <constant>
                             | <parameter>
                             | <function call>
                             | <aggregate>
                             | ’(’ <expr> ’)’
       <relop>             ::= ’<’ | ’<=’ | ’=’ | ’>’ | ’>=’ | ’<>’
       <addop>             ::= ’+’ | ’-’
       <mulop>             ::= ’*’ | ’/’ | DIV | MOD

   3.1:
       <constant expression>
                           ::= <expression>
       <literal expression>
                           ::= <expression>
       <conditional expression>
                           ::= <expression>

   3.4:
       <literal>           ::= <num literal>
                             | <string literal>
                             | <bool literal>

   3.5:
       <variable>          ::=
                             | <entire variable>
                             | <variable element>
                             | <variable component>
       <entire variable>   ::= <ident>
       <variable element>  ::= <entire variable> ’{’ <index list> ’}’
       <index list>        ::= <expr> { ’,’ <expr> }
       <variable component>
                           ::= <variable> ’.’ <component name>
       <component name>    ::= <ident>

   3.6
       <persistent>        ::= <entire persistent>
                             | <persistent element>
                             | <persistent component>

   3.6
       <constant>          ::= <entire constant>
                             | <constant element>
                             | <constant component>

   3.8
       <parameter>         ::= <entire parameter>
                             | <parameter element>
                             | <parameter component>

   3.9:
       <aggregate>         ::= ’[’ <expr> { ’,’ <expr> } ’]’

   3.10:
       <function call>     ::= <function> ’(’ [ <function argument list> ] ’)’
       <function>          ::= <identifier>
       <function argument list>
                           ::= <first function argument> { <function argument>
       <first function argument>
                           ::= <required function argument>
                             | <optional function argument>
                             | <conditional function argument>

       <function argument> ::= ’,’ <required function argument>
                             | <optional function argument>
                             | ’,’ <optional function argument>
                             | <conditional function argument>
                             | ’,’ <conditional function argument>
       <required function argument>
                           ::= [ <ident> ’:=’ ] <expr>
       <optional function argument>
                           ::= ’\’ <ident> [ ’:=’ <expr> ]
       <conditional function argument>
                           ::=’\’ <ident> ’?’ <parameter>

   4:
       <statement>         ::= <simple statement>
                             | <compound statement>
                             | <label>
                             | <comment>
                             | <SMT>
       <simple statement>  ::= <assignment statement>
                             | <procedure call>
                             | <goto statement>
                             | <return statement>
                             | <raise statement>
                             | <exit statement>
                             | <retry statement>
                             | <trynext statement>
                             | <connect statement>
       <compound statement>
                           ::= <if statement>
                             | <compact if statement>
                             | <for statement>
                             | <while statement>
                             | <test statement>

   4.2:
       <statement list>    ::= { <statement> }

   4.3:
       <label>             ::= <identifier> ’:’

   4.4:
       <assignment statement>
                           ::= <assignment target> ’:=’ <expression> ’;’
       <assignment target> ::= <variable>
                             | <persistent>
                             | <parameter>
                             | <VAR>

   4.5:
       <procedure call>    ::= <procedure> [ <procedure argument list> ] ’;’
       <procedure>         ::= <identifier> | ’%’ <expression> ’%’
       <procedure argument list>
                           ::= <first procedure argument>
                                   { <procedure argu-ment> }
       <first procedure argument>
                           ::= <required procedure argument>
                             | <optional procedure argument>
                             | <conditional procedure argument>
                             | <ARG>
       <procedure argument>
                           ::= ’,’ <required procedure argument>
                             |     <optional procedure argument>
                             | ’,’ <optional procedure argument>
                             |     <conditional procedure argument>
                             | ’,’ <conditional procedure argument>
                             | ’,’ <ARG>
       <required procedure argument>
                           ::= [ <identifier> ’:=’ ] <expression>
       <optional procedure argument>
                           ::= ’\’ <identifier> [ ’:=’ <expression> ]
       <conditional procedure argument>
                           ::=’\’ <identifier> ’?’ ( <parameter> | <VAR> )

   4.6:
       <goto statement>    ::= GOTO <identifier> ’;’

   4.7:
       <return statement>  ::= RETURN [ <expression> ] ’;’

   4.8:
       <raise statement>   ::= RAISE [ <error number> ] ’;’
       <error number>      ::= <expression>

   4.9
       <exit statement>    ::= EXIT ’;’

   4.10
       <retry statement>   ::= RETRY ’;’

   4.11
       <trynext statement> ::= TRYNEXT ’;’

   4.12
       <connect statement> ::= CONNECT <connect target> WITH <trap> ’;’
       <connect target>    ::= <variable>
                             | <parameter>
                             | <VAR>
       <trap>              ::= <identifier>

   4.13:
       <if statement>      ::= IF <conditional expression> THEN
                                   <statement list>
                               { ELSEIF <conditional expression> THEN
                                       <statement list> | <EXIT> }
                               [ ELSE <statement list> ]
                               ENDIF

   4.13:
       <compact if statement>
                           ::= IF <conditional expression> ( <simple statement> | <SMT> )

   4.15:
       <for statement>     ::= FOR <loop variable> FROM <expression>
                               TO <expression> [ STEP <expression> ]
                               DO <statement list>
                               ENDFOR
       <loop variable>     ::= <identifier>

   4.16:
       <while statement>   ::= WHILE <conditional expression> DO
                                   <statement list>
                               ENDWHILE

   4.17:
       <test statement>    ::= TEST <expression>
                               { CASE <test value> { ’,’ <test value> } ’:’
                                    <statement list> ) | <CSE> }
                               [ DEFAULT ’:’<statement list> ]
                               ENDTEST
       <test value>        ::= <constant expression>

   5:
       <routine declaration>
                           ::= [ LOCAL] ( <procedure declaration>
                                        | <function declaration>
                                        | <trap declaration> )
                             | <comment>
                             | <RDN>

   5.1
       <parameter list>    ::= <first parameter declaration>
                                   { <next parameter declaration> }
       <first parameter declaration>
                           ::= <parameter declaration>
                             | <optional parameter declaration>
                             | <PAR>
       <next parameter declaration>
                           ::= ’,’ <parameter declaration>
                             |     <optional parameter declaration>
                             | ’,’ <optional parameter declaration>
                             | ’,’ <PAR>
       <optional parameter declaration>
                           ::=   ’\’ ( <parameter declaration> | <ALT> )
                               { ’|’ ( <parameter declaration> | <ALT> ) }
       <parameter declaration>
                           ::= [ VAR | PERS | INOUT ]
                                   <data type>
                                   <identifier>
                                   [ ’{’ ( ’*’ { ’,’ ’*’ } ) | <DIM> ’}’ ]
                             | ’switch’ <identifier>

   5.3
       <procedure declaration>
                           ::= PROC <procedure name>’(’ [ <parameter list> ] ’)’
                                   <data declaration list>
                                   <statement list>
                                   [ BACKWARD <statement list> ]
                                   [ ERROR [ <error number list> ]
                                       <statement list> ]
                                   [ UNDO <statement list> ]
                               ENDPROC
       <procedure name>    ::= <identifier>
       <data declaration list>
                           ::= { <data declaration> }

   5.4:
       <function declaration>
                           ::= FUNC <data type> <function name>
                                       ’(’ [ <parameter list> ] ’)’
                                   <data declaration list>
                                   <statement list>
                                   [ ERROR [ <error number list> ]
                                       <statement list> ]
                                   [ UNDO <statement list> ]
                               ENDFUNC
       <function name>     ::= <identifier>

   5.5
       <trap declaration>  ::= TRAP <trap name>
                                   <data declaration list>
                                   <statement list>
                                   [ ERROR [ <error number list> ]
                                       <statement list> ]
                                   [ UNDO <statement list> ]
                               ENDTRAP
       <trap name>         ::= <identifier>
       <error number list> ::= '(' <error number>
                                   { ',' <error number>} ')'
       <error number>      ::= <num literal>
                             | <entire constant>
                             | <entire variable>
                             | <entire persistent>

   9.1:
       <module declaration>
                           ::= MODULE <module name> [ <module attriutelist> ]
                                   <type definition list>
                                   <data declaration list>
                                   <routine declaration list>
                               ENDMODULE
       <module name>       ::= <identifier>
       <module attribute list>
                           ::= ’(’ <module attribute>
                                   { ’,’ <module attribute> } ’)’
       <module attribute>  ::= SYSMODULE
                             | NOVIEW
                             | NOSTEPIN
                             | VIEWONLY
                             | READONLY
       <type definition list>
                           ::= { <type definition> }
       <routine declaration list>
                           ::= { <routine declaration> }


