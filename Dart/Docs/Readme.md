
# DART

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
[Dart] -------------------------------------------------------------------------
@=Dart

Extensions=
    .dart

_WWW_=https://www.dartlang.org/

_Wiki_=https://en.wikipedia.org/wiki/Dart_(programming_language)

Keywords=

    assert,
    break,
    case,catch,class,const,continue,
    default,do,
    else,enum,extends,
    false,final,finally,for,
    if,in,is,
    new,null,
    rethrow,return,
    super,switch,
    this,throw,true,try,
    var,void,
    while,with

   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=

StringLiterals=

Comment=

〈SINGLE_LINE_COMMENT〉   ::= ‘//’  ̃(〈NEWLINE〉)* (〈NEWLINE〉)?

〈MULTI_LINE_COMMENT〉    ::= ‘/*’ (〈MULTI_LINE_COMMENT〉| ̃ ‘*/’)* ‘*/’

Dart supports both single-line and multi-line comments. A single line comment
begins with the token //.  Everything between // and the end of line must be
ignored by the Dart compiler unless the comment is a documentation comment.
A multi-line comment begins with the token /* and ends with the token */.
Everything between /* and */ must be ignored by the Dart compiler unless the
comment is a documentation comment. Comments may nest. Documentation comments
are comments that begin with the tokens /// or /**. Documentation comments are
intended to be processed by a tool that produces human readable documentation.
The scope of a documentation comment immediately preceding the declaration of
a class C is the instance scope of C. The scope of a documentation comment
immediately preceding the declaration of a function f is the scope in force at
the very beginning of the body of f.
the very beginning of the body of f.

Classes_and_Methods=


Function=


Grammar=
```

〈variableDeclaration〉 ::=
    〈declaredIdentifier〉 ( ‘,’ 〈identifier〉 )*

〈declaredIdentifier〉 ::=
    〈metadata〉 covariant? 〈finalConstVarOrType〉 〈identifier〉

〈finalConstVarOrType〉 ::=
        final 〈type〉?
    |   const 〈type〉?
    |   〈varOrType〉

〈varOrType〉 ::=
        var
    |   〈type〉

〈initializedVariableDeclaration〉 ::=
    〈declaredIdentifier〉 ( ‘=’ 〈expression〉 )? ( ‘,’ 〈initializedIdentifier〉 )*

〈initializedIdentifier〉 ::=
    〈identifier〉 ( ‘=’ 〈expression〉 )?

〈initializedIdentifierList〉 ::=
    〈initializedIdentifier〉 ( ‘,’ 〈initializedIdentifier〉 )*

〈functionSignature〉 ::=
    〈metadata〉 〈type〉? 〈identifier〉 〈formalParameterPart〉

〈formalParameterPart〉 ::=
    〈typeParameters〉? 〈formalParameterList〉

〈functionBody〉 ::=
        async? ‘=>’ 〈expression〉 ‘;’
    |   ( async | async ‘*’ | sync ‘*’ )? 〈block〉

〈block〉 ::=
    ‘{’ 〈statements〉 ‘}’

〈formalParameterList〉 ::=
        ‘(’ ‘)’
    |   ‘(’ 〈normalFormalParameters〉 ‘,’? ‘)’
    |   ‘(’ 〈normalFormalParameters〉 ‘,’ 〈optionalFormalParameters〉 ‘)’
    |   ‘(’ 〈optionalFormalParameters〉 ‘)’

〈normalFormalParameters〉 ::=
    〈normalFormalParameter〉 ( ‘,’ 〈normalFormalParameter〉 )*

〈optionalFormalParameters〉 ::=
        〈optionalPositionalFormalParameters〉
    |   〈namedFormalParameters〉

〈optionalPositionalFormalParameters〉 ::=
    ‘[’ 〈defaultFormalParameter〉 ( ‘,’ 〈defaultFormalParameter〉 )* ‘,’? ‘]’

〈namedFormalParameters〉 ::=
    ‘{’ 〈defaultNamedParameter〉 ( ‘,’ 〈defaultNamedParameter〉 )* ‘,’? ‘}’

〈normalFormalParameter〉 ::=
        〈functionFormalParameter〉
    |   〈fieldFormalParameter〉
    |   〈simpleFormalParameter〉

〈functionFormalParameter〉 ::=
    〈metadata〉 covariant? 〈type〉? 〈identifier〉 〈formalParameterPart〉

〈simpleFormalParameter〉 ::=
        〈declaredIdentifier〉
    |   〈metadata〉 covariant? 〈identifier〉

〈fieldFormalParameter〉 ::=
    〈metadata〉 〈finalConstVarOrType〉? this ‘.’ 〈identifier〉 〈formalParameterPart〉

〈defaultFormalParameter〉 ::=
    〈normalFormalParameter〉 ( ‘=’ 〈expression〉 )?

〈defaultNamedParameter〉 ::=
        〈normalFormalParameter〉 ( ‘=’ 〈expression〉 )?
    |   〈normalFormalParameter〉 ( ‘:’ 〈expression〉 )?

〈classDefinition〉 ::=
        〈metadata〉 abstract? class 〈identifier〉 〈typeParameters〉? 〈superclass〉? 〈interfaces〉?
            ‘{’ ( 〈metadata〉 〈classMemberDefinition〉 )* ‘}’
    |   〈metadata〉 abstract? class 〈mixinApplicationClass〉

〈typeNotVoidList〉 ::=
    〈typeNotVoid〉 ( ‘,’ 〈typeNotVoid〉 )*

〈classMemberDefinition〉 ::=
        〈declaration〉 ‘;’
    |   〈methodSignature〉 〈functionBody〉

〈methodSignature〉 ::=
        〈constructorSignature〉 〈initializers〉?
    |   〈factoryConstructorSignature〉
    |   static? 〈functionSignature〉
    |   static? 〈getterSignature〉
    |   static? 〈setterSignature〉
    |   〈operatorSignature〉

〈declaration〉 ::=
        〈constantConstructorSignature〉 ( 〈redirection〉 | 〈initializers〉 )?
    |   〈constructorSignature〉 ( 〈redirection〉 | 〈initializers〉 )?
    |   external 〈constantConstructorSignature〉
    |   external 〈constructorSignature〉
    |   (external static?)? 〈getterSignature〉
    |   (external static?)? 〈setterSignature〉
    |   external? 〈operatorSignature〉
    |   (external static?)? 〈functionSignature〉
    |   static ( final | const ) 〈type〉? 〈staticFinalDeclarationList〉
    |   final 〈type〉? 〈initializedIdentifierList〉
    |   ( static | covariant )? ( var | 〈type〉 ) 〈initializedIdentifierList〉

〈staticFinalDeclarationList〉 ::=
    〈staticFinalDeclaration〉 ( ‘,’ 〈staticFinalDeclaration〉 )*

〈staticFinalDeclaration〉 ::=
    〈identifier〉 ‘=’ 〈expression〉

〈operatorSignature〉 ::=
    〈type〉? operator 〈operator〉 〈formalParameterList〉

〈operator〉 ::=
        ‘~’
    |   〈binaryOperator〉
    |   ‘[]’
    |   ‘[]=’

〈binaryOperator〉 ::=
        〈multiplicativeOperator〉
    |   〈additiveOperator〉
    |   〈shiftOperator〉
    |   〈relationalOperator〉
    |   ‘==’
    |   〈bitwiseOperator〉

〈getterSignature〉 ::=
    〈type〉? get 〈identifier〉

〈setterSignature〉 ::=
    〈type〉? set 〈identifier〉 〈formalParameterList〉

〈constructorSignature〉 ::=
    〈identifier〉 ( ‘.’ 〈identifier〉 )? 〈formalParameterList〉

〈redirection〉 ::=
    ‘:’ this ( ‘.’ 〈identifier〉 )? 〈arguments〉

〈initializers〉 ::=
    ‘:’ 〈initializerListEntry〉 ( ‘,’ 〈initializerListEntry〉 )*

〈initializerListEntry〉 ::=
        super 〈arguments〉
    |   super ‘.’ 〈identifier〉 〈arguments〉
    |   〈fieldInitializer〉
    |   〈assertion〉

〈fieldInitializer〉 ::=
    ( this ‘.’ )? 〈identifier〉 ‘=’ 〈conditionalExpression〉 〈cascadeSection〉*

〈factoryConstructorSignature〉 ::=
    factory 〈identifier〉 ( ‘.’ 〈identifier〉 )? 〈formalParameterList〉

〈constantConstructorSignature〉 ::=
    const 〈qualified〉 〈formalParameterList〉

〈superclass〉 ::=
        extends 〈typeNotVoid〉 〈mixins〉?
    |   〈mixins〉

〈mixins〉 ::=
    with 〈typeNotVoidList〉

〈interfaces〉 ::=
    implements 〈typeNotVoidList〉

〈mixinApplicationClass〉 ::=
    〈identifier〉 〈typeParameters〉? ‘=’ 〈mixinApplication〉‘;’

〈mixinApplication〉 ::=
    〈typeNotVoid〉 〈mixins〉 〈interfaces〉?

〈mixinDeclaration〉 ::=
    〈metadata〉 mixin 〈identifier〉 〈typeParameters〉? 
        ( on 〈typeNotVoidList〉 )? 
        〈interfaces〉? 
        ‘{’ ( 〈metadata〉 〈classMemberDefinition〉 )* ‘}

〈enumType〉 ::=
    〈metadata〉 enum 〈identifier〉 ‘{’ 〈enumEntry〉 ( ‘,’ 〈enumEntry〉 )* ( ‘,’ )? ‘}’

〈enumEntry〉 ::=
    〈metadata〉 〈identifier〉

〈typeParameter〉 ::=
    〈metadata〉 〈identifier〉 ( extends 〈typeNotVoid〉)?

〈typeParameters〉 ::=
    ‘<’ 〈typeParameter〉 ( ‘,’ 〈typeParameter〉 )* ‘>’

〈metadata〉 ::=
    ( ‘@’ 〈qualified〉 ( ‘.’ 〈identifier〉 )? 〈arguments〉? )*

〈expression〉 ::=
        〈assignableExpression〉 〈assignmentOperator〉 〈expression〉
    |   〈conditionalExpression〉 〈cascadeSection〉*
    |   〈throwExpression〉

〈expressionWithoutCascade〉 ::=
        〈assignableExpression〉 〈assignmentOperator〉 〈expressionWithoutCascade〉
    |   〈conditionalExpression〉
    |   〈throwExpressionWithoutCascade〉

〈expressionList〉 ::=
    〈expression〉 ( ‘,’ 〈expression〉 )*

〈primary〉 ::=
        〈thisExpression〉
    |   super 〈unconditionalAssignableSelector〉
    |   〈functionExpression〉
    |   〈literal〉
    |   〈identifier〉
    |   〈newExpression〉
    |   〈constObjectExpression〉
    |   ‘(’ 〈expression〉 ‘)’

〈literal〉 ::=
        〈nullLiteral〉
    |   〈booleanLiteral〉
    |   〈numericLiteral〉
    |   〈stringLiteral〉
    |   〈symbolLiteral〉
    |   〈mapLiteral〉
    |   〈setLiteral〉
    |   〈setOrMapLiteral〉
    |   〈listLiteral〉

〈nullLiteral〉 ::=
    null

〈numericLiteral〉 ::=
        〈NUMBER〉
    |   〈HEX_NUMBER〉

〈NUMBER〉 ::=
        〈DIGIT〉+ ( ‘.’ 〈DIGIT〉+ )? 〈EXPONENT〉?
    |   ‘.’ 〈DIGIT〉+ 〈EXPONENT〉?

〈EXPONENT〉 ::=
    ( ‘e’ | ‘E’ ) ( ‘+’ | ‘-’ )? 〈DIGIT〉+

〈HEX_NUMBER〉 ::=
        ‘0x’ 〈HEX_DIGIT〉+
    |   ‘0X’ 〈HEX_DIGIT〉+

〈HEX_DIGIT〉 ::=
        ‘a’ .. ‘f’
    |   ‘A’ .. ‘F’
    |   〈DIGIT〉

〈booleanLiteral〉 ::=
        true
    |   false

〈stringLiteral〉 ::=
    ( 〈multilineString〉 | 〈singleLineString〉 )+

〈singleLineString〉 ::=
        ‘"’ 〈stringContentDQ〉* ‘"’
    |   ‘’’ 〈stringContentSQ〉* ‘’’
    |   ‘r’’ ( ( ̃  ‘’’ | 〈NEWLINE〉 ) )* ‘’’
    |   ‘r"’ ( ( ̃  ( ‘"’ | 〈NEWLINE〉 ) )* ‘"’

〈multilineString〉 ::=
        ‘"""’ 〈stringContentTDQ〉* ‘"""’
    |   ‘’’’’ 〈stringContentTSQ〉* ‘’’’’
    |   ‘r"""’ ( ̃  ‘"""’ )* ‘"""’
    |   ‘r’’’’ ( ̃  ‘’’’’ )* ‘’’’’

〈ESCAPE_SEQUENCE〉 ::=
        ‘\n’
    |   ‘\r’
    |   ‘\f’
    |   ‘\b’
    |   ‘\t’
    |   ‘\v’
    |   ‘\x’ 〈HEX_DIGIT〉 〈HEX_DIGIT〉
    |   ‘\u’ 〈HEX_DIGIT〉 〈HEX_DIGIT〉 〈HEX_DIGIT〉 〈HEX_DIGIT〉
    |   ‘\u{’ 〈HEX_DIGIT_SEQUENCE〉 ‘}’

〈HEX_DIGIT_SEQUENCE〉 ::=
    〈HEX_DIGIT〉 〈HEX_DIGIT〉? 〈HEX_DIGIT〉? 〈HEX_DIGIT〉? 〈HEX_DIGIT〉? 〈HEX_DIGIT〉?

〈stringContentDQ〉 ::=
        ( ̃  ‘\’ | ‘"’ | ‘$’ | 〈NEWLINE〉 )
    |   ‘\’ ( ̃  ( 〈NEWLINE〉 )
    |   〈stringInterpolation〉

〈stringContentSQ〉 ::=
        ( ̃  ‘\’ | ‘’’ | ‘$’ | 〈NEWLINE〉 )
     |  ‘\’ ( ̃  ( 〈NEWLINE〉 )
     |  〈stringInterpolation〉

〈stringContentTDQ〉 ::=
        ( ̃  ‘\’ | ‘"""’ | ‘$’)
    |   ‘\’ ( ̃  〈NEWLINE〉 )
    |   〈stringInterpolation〉

〈stringContentTSQ〉 ::=
        ( ̃  ‘\’ | ‘”’’ | ‘$’ )
    |   ‘\’ ( ̃  ( 〈NEWLINE〉 ) 
    |   〈stringInterpolation〉

〈NEWLINE〉 ::=
        ‘\n’
    |   ‘\r’
    |   ‘\r\n’

〈stringInterpolation〉 ::=
        ‘$’ 〈IDENTIFIER_NO_DOLLAR〉
    |   ‘${’ 〈expression〉 ‘}’

〈symbolLiteral〉 ::=
    ‘#’ (   〈operator〉 
        |   ( 〈identifier〉 ( ‘.’ 〈identifier〉 )* ) 
        )

〈listLiteral〉 ::=
    const? 〈typeArguments〉? ‘[’ ( 〈expressionList〉 ‘,’? )? ‘]’

〈mapLiteral〉 ::=
    const? 〈typeArguments〉? ‘{’ 〈mapLiteralEntry〉 ( ‘,’ 〈mapLiteralEntry〉 )* ‘,’? ‘}’

〈mapLiteralEntry〉 ::=
    〈expression〉 ‘:’ 〈expression〉

〈setOrMapLiteral〉 ::=
    const? 〈typeArguments〉? ‘{’ ‘}’

〈setLiteral〉 ::=
    const? 〈typeArguments〉? ‘{’ 〈expression〉 ( ‘,’ 〈expression〉 )* ‘,’? ‘}’

〈throwExpression〉 ::=
    throw 〈expression〉

〈throwExpressionWithoutCascade〉 ::=
    throw 〈expressionWithoutCascade〉

〈functionExpression〉 ::=
    〈formalParameterPart〉 〈functionBody〉

〈thisExpression〉 ::=
    this

〈newExpression〉 ::=
    new 〈typeNotVoid〉 ( ‘.’ 〈identifier〉 )? 〈arguments〉

〈constObjectExpression〉 ::=
    const 〈typeNotVoid〉 ( ‘.’ 〈identifier〉 )? 〈arguments〉

〈arguments〉 ::=
    ‘(’ ( 〈argumentList〉 ‘,’? )? ‘)’

〈argumentList〉 ::=
        〈namedArgument〉 ( ‘,’ 〈namedArgument〉 )*
    |   〈expressionList〉 ( ‘,’ 〈namedArgument〉 )*

〈namedArgument〉 ::=
    〈label〉 〈expression〉

〈cascadeSection〉 ::=
    ‘..’ ( 〈cascadeSelector〉 〈argumentPart〉* ) 
         ( 〈assignableSelector〉 〈argumentPart〉* )* 
         ( 〈assignmentOperator〉 〈expressionWithoutCascade〉 )?

〈cascadeSelector〉 ::=
        ‘[’ 〈expression〉 ‘]’ 
    |   〈identifier〉

〈argumentPart〉 ::=
    〈typeArguments〉? 〈arguments〉

〈assignmentOperator〉 ::=
        ‘=’
    |   〈compoundAssignmentOperator〉

〈compoundAssignmentOperator〉 ::=
        ‘*=’
    |   ‘/=’
    |   ‘~/=’
    |   ‘%=’
    |   ‘+=’
    |   ‘-=’
    |   ‘<<=’
    |   ‘>>=’
    |   ‘>>>=’
    |   ‘&=’
    |   ‘^=’
    |   ‘|=’
    |   ‘??=’

〈conditionalExpression〉 ::=
    〈ifNullExpression〉 ( ‘?’ 〈expressionWithoutCascade〉 ‘:’ 〈expressionWithoutCascade〉 )?

〈ifNullExpression〉 ::=
    〈logicalOrExpression〉 ( ‘??’ 〈logicalOrExpression〉 )*

〈logicalOrExpression〉 ::=
    〈logicalAndExpression〉 ( ‘||’ 〈logicalAndExpression〉 )*

〈logicalAndExpression〉 ::=
    〈equalityExpression〉 ( ‘&&’ 〈equalityExpression〉 )*

〈equalityExpression〉 ::=
        〈relationalExpression〉 ( 〈equalityOperator〉 〈relationalExpression〉 )?
    |   super 〈equalityOperator〉 〈relationalExpression〉

〈equalityOperator〉 ::=
        ‘==’
    |   ‘!=’

〈relationalExpression〉 ::=
        〈bitwiseOrExpression〉 ( 〈typeTest〉 | 〈typeCast〉 | 〈relationalOperator〉 〈bitwiseOrExpression〉 )?
    |   super 〈relationalOperator〉 〈bitwiseOrExpression〉

〈relationalOperator〉 ::=
        ‘>=’
    |   ‘>’
    |   ‘<=’
    |   ‘<’

〈bitwiseOrExpression〉 ::=
        〈bitwiseXorExpression〉 ( ‘|’ 〈bitwiseXorExpression〉 )*
    |   super ( ‘|’ 〈bitwiseXorExpression〉 )+

〈bitwiseXorExpression〉 ::=
        〈bitwiseAndExpression〉 ( ‘^’ 〈bitwiseAndExpression〉 )*
    |   super ( ‘^’ 〈bitwiseAndExpression〉 )+

〈bitwiseAndExpression〉 ::=
        〈shiftExpression〉 ( ‘&’ 〈shiftExpression〉 )*
    |   super ( ‘&’ 〈shiftExpression〉 )+

〈bitwiseOperator〉 ::=
        ‘&’
    |   ‘^’
    |   ‘|’

〈shiftExpression〉 ::=
        〈additiveExpression〉 ( 〈shiftOperator〉 〈additiveExpression〉)*
    |   super ( 〈shiftOperator〉 〈additiveExpression〉 )+

〈shiftOperator〉 ::=
        ‘<<’
    |   ‘>>’
    |   ‘>>>’

〈additiveExpression〉 ::=
        〈multiplicativeExpression〉 ( 〈additiveOperator〉 〈multiplicativeExpression〉 )*
    |   super ( 〈additiveOperator〉 〈multiplicativeExpression〉 )+

〈additiveOperator〉 ::=
        ‘+’
    |   ‘-’

〈multiplicativeExpression〉 ::=
        〈unaryExpression〉 ( 〈multiplicativeOperator〉 〈unaryExpression〉 )*
    |   super ( 〈multiplicativeOperator〉 〈unaryExpression〉 )+

〈multiplicativeOperator〉 ::=
        ‘*’
    |   ‘/’
    |   ‘%’
    |   ‘~/’

〈unaryExpression〉 ::=
        〈prefixOperator〉 〈unaryExpression〉
    |   〈awaitExpression〉
    |   〈postfixExpression〉
    |   ( 〈minusOperator〉 | 〈tildeOperator〉 ) super
    |   〈incrementOperator〉 〈assignableExpression〉

〈prefixOperator〉 ::=
        〈minusOperator〉
    |   〈negationOperator〉
    |   〈tildeOperator〉

〈minusOperator〉 ::=
    ‘-’

〈negationOperator〉 ::=
    ‘!’

〈tildeOperator〉 ::=
    ‘~’

〈awaitExpression〉 ::=
    await 〈unaryExpression〉

〈postfixExpression〉 ::=
        〈assignableExpression〉 〈postfixOperator〉
    |   〈constructorInvocation〉 〈selector〉*
    |   〈primary〉 〈selector〉

〈postfixOperator〉 ::=
    〈incrementOperator〉

〈constructorInvocation〉 ::=
    〈typeName〉 〈typeArguments〉 ‘.’ 〈identifier〉 〈arguments〉

〈selector〉 ::=
        〈assignableSelector〉
    |   〈argumentPart〉

〈incrementOperator〉 ::=
        ‘++’
    |   ‘--’

〈assignableExpression〉 ::=
        〈primary〉 〈assignableSelectorPart〉+
    |   super 〈unconditionalAssignableSelector〉
    |   〈constructorInvocation〉 〈assignableSelectorPart〉+ 〈identifier〉

〈assignableSelectorPart〉 ::=
    〈argumentPart〉* 〈assignableSelector〉

〈unconditionalAssignableSelector〉 ::=
        ‘[’ 〈expression〉 ‘]’
    |   ‘.’ 〈identifier〉

〈assignableSelector〉 ::=
        〈unconditionalAssignableSelector〉
    |   ‘?.’ 〈identifier〉

〈identifier〉 ::=
    〈IDENTIFIER〉

〈IDENTIFIER_NO_DOLLAR〉 ::=
    〈IDENTIFIER_START_NO_DOLLAR〉 〈IDENTIFIER_PART_NO_DOLLAR〉

〈IDENTIFIER〉 ::=
    〈IDENTIFIER_START〉 〈IDENTIFIER_PART〉*

〈BUILT_IN_IDENTIFIER〉 ::=
        abstract
    |   as
    |   covariant
    |   deferred
    |   dynamic
    |   export
    |   external
    |   factory
    |   Function
    |   get
    |   implements
    |   import
    |   interface
    |   library
    |   operator
    |   mixin
    |   part
    |   set
    |   static
    |   typedef

〈IDENTIFIER_START〉 ::=
        〈IDENTIFIER_START_NO_DOLLAR〉
    |   ‘$’

〈IDENTIFIER_START_NO_DOLLAR〉 ::=
        〈LETTER〉
    |   ‘_’

〈IDENTIFIER_PART_NO_DOLLAR〉 ::=
        〈IDENTIFIER_START_NO_DOLLAR〉
    |   〈DIGIT〉

〈IDENTIFIER_PART〉 ::=
        〈IDENTIFIER_START〉
    |   〈DIGIT〉

〈qualified〉 ::=
    〈identifier〉 ( ‘.’ 〈identifier〉 )?

〈typeTest〉 ::=
    〈isOperator〉 〈typeNotVoid〉

〈isOperator〉 ::=
    is ‘!’?

〈typeCast〉 ::=
    〈asOperator〉 〈typeNotVoid〉

〈asOperator〉 ::=
    as

〈statements〉 ::=
    〈statement〉*

〈statement〉 ::=
    〈label〉* 〈nonLabelledStatement〉

〈nonLabelledStatement〉 ::=
        〈block〉
    |   〈localVariableDeclaration〉
    |   〈forStatement〉
    |   〈whileStatement〉
    |   〈doStatement〉
    |   〈switchStatement〉
    |   〈ifStatement〉
    |   〈rethrowStatement〉
    |   〈tryStatement〉
    |   〈breakStatement〉
    |   〈continueStatement〉
    |   〈returnStatement〉
    |   〈yieldStatement〉
    |   〈yieldEachStatement〉
    |   〈expressionStatement〉
    |   〈assertStatement〉
    |   〈localFunctionDeclaration〉

〈expressionStatement〉 ::=
    〈expression〉? ‘;’

〈localVariableDeclaration〉 ::=
    〈initializedVariableDeclaration〉 ‘;’

〈localFunctionDeclaration〉 ::=
    〈functionSignature〉 〈functionBody〉

〈ifStatement〉 ::=
    if ‘(’ 〈expression〉 ‘)’ 〈statement〉 ( else 〈statement〉 )?

〈forStatement〉 ::=
    await? for ‘(’ 〈forLoopParts〉 ‘)’ 〈statement〉

〈forLoopParts〉 ::=
        〈forInitializerStatement〉 〈expression〉? ‘;’ 〈expressionList〉?
    |   〈declaredIdentifier〉 in 〈expression〉
    |   〈identifier〉 in 〈expression〉

〈forInitializerStatement〉 ::=
        〈localVariableDeclaration〉
    |   〈expression〉? ‘;’

〈whileStatement〉 ::=
    while ‘(’ 〈expression〉 ‘)’ 〈statement〉

〈doStatement〉 ::=
    do 〈statement〉 while ‘(’ 〈expression〉 ‘)’ ‘;’

〈switchStatement〉 ::=
    switch ‘(’ 〈expression〉 ‘)’ ‘{’ 〈switchCase〉* 〈defaultCase〉? ‘}’

〈switchCase〉 ::=
    〈label〉* case 〈expression〉 ‘:’ 〈statements〉

〈defaultCase〉 ::=
    〈label〉* default ‘:’ 〈statements〉

〈rethrowStatement〉 ::=
    rethrow ‘;’

〈tryStatement〉 ::=
    try 〈block〉 ( 〈onPart〉+ 〈finallyPart〉? | 〈finallyPart〉 )

〈onPart〉 ::=
        〈catchPart〉 〈block〉
    |   on 〈typeNotVoid〉 〈catchPart〉? 〈block〉

〈catchPart〉 ::=
    catch ‘(’ 〈identifier〉 ( ‘,’ 〈identifier〉 )? ‘)’

〈finallyPart〉 ::=
    finally 〈block〉

〈returnStatement〉 ::=
    return 〈expression〉? ‘;’

〈label〉 ::=
    〈identifier〉 ‘:’

〈breakStatement〉 ::=
    break 〈identifier〉? ‘;’

〈continueStatement〉 ::=
    continue 〈identifier〉? ‘;’

〈yieldStatement〉 ::=
    yield 〈expression〉 ‘;’

〈yieldEachStatement〉 ::=
    yield ‘*’ 〈expression〉 ‘;’

〈assertStatement〉 ::=
    〈assertion〉 ‘;’

〈assertion〉 ::=
    assert ‘(’ 〈expression〉 ( ‘,’ 〈expression〉 )? ‘,’? ‘)’

〈topLevelDefinition〉 ::=
        〈classDefinition〉
    |   〈enumType〉
    |   〈typeAlias〉
    |   external? 〈functionSignature〉 ‘;’
    |   external? 〈getterSignature〉 ‘;’
    |   external? 〈setterSignature〉 ‘;’
    |   〈functionSignature〉 〈functionBody〉
    |   〈type〉? get 〈identifier〉 〈functionBody〉
    |   〈type〉? set 〈identifier〉 〈formalParameterList〉 〈functionBody〉
    |   ( final | const ) 〈type〉 〈staticFinalDeclarationList〉 ‘;’
    |   〈variableDeclaration〉 ‘;’

〈getOrSet〉 ::=
        get
    |   set

〈libraryDefinition〉 ::=
    〈scriptTag〉? 〈libraryName〉? 〈importOrExport〉* 〈partDirective〉* 〈topLevelDefinition〉*

〈scriptTag〉 ::=
    ‘#!’ ( ̃  〈NEWLINE〉 )* 〈NEWLINE〉

〈libraryName〉 ::=
    〈metadata〉 library 〈dottedIdentifierList〉 ‘;’

〈importOrExport〉 ::=
        〈libraryImport〉
    |   〈libraryExport〉

〈dottedIdentifierList〉 ::=
    〈identifier〉 (‘.’ 〈identifier〉 )*

〈libraryImport〉 ::=
    〈metadata〉 〈importSpecification〉

〈importSpecification〉 ::=
        import 〈configurableUri〉 ( as 〈identifier〉 )? 〈combinator〉* ‘;’
    |   import 〈uri〉 deferred as 〈identifier〉 〈combinator〉* ‘;’

〈combinator〉 ::=
        show 〈identifierList〉
    |   hide 〈identifierList〉

〈identifierList〉 ::=
    〈identifier〉 ( ‘,’ 〈identifier〉 )*

〈libraryExport〉 ::=
    〈metadata〉 export 〈configurableUri〉 〈combinator〉* ‘;’

〈partDirective〉 ::=
    〈metadata〉 part 〈uri〉 ‘;’

〈partHeader〉 ::=
    〈metadata〉 part of 〈identifier〉 ( ‘.’ 〈identifier〉 )* ‘;’

〈partDeclaration〉 ::=
    〈partHeader〉 〈topLevelDefinition〉* 〈EOF〉

〈uri〉 ::=
    〈stringLiteral〉

〈configurableUri〉 ::=
    〈uri〉 〈configurationUri〉*

〈configurationUri〉 ::=
    if ‘(’ 〈uriTest〉 ‘)’ 〈uri〉

〈uriTest〉 ::=
    〈dottedIdentifierList〉 ( ‘==’ 〈stringLiteral〉 )?

〈type〉 ::=
        〈functionTypeTails〉
    |   〈typeNotFunction〉 〈functionTypeTails〉
    |   〈typeNotFunction〉

〈typeNotFunction〉 ::=
        〈typeNotVoidNotFunction〉
    |   void

〈typeNotVoidNotFunction〉 ::=
        〈typeName〉 〈typeArguments〉?
    |   Function

〈typeName〉 ::=
    〈typeIdentifier〉 ( ‘.’ 〈typeIdentifier〉 )?

〈typeArguments〉 ::=
    ‘<’ 〈typeList〉 ‘>’

〈typeList〉 ::=
    〈type〉 ( ‘,’ 〈type〉 )*

〈typeNotVoidNotFunctionList〉 ::=
    〈typeNotVoidNotFunction〉 ( ‘,’ 〈typeNotVoidNotFunction〉 )*

〈typeNotVoid〉 ::=
        〈functionType〉
    |   〈typeNotVoidNotFunction〉

〈functionType〉 ::=
        〈functionTypeTails〉
    |   〈typeNotFunction〉 〈functionTypeTails〉

〈functionTypeTails〉 ::=
        〈functionTypeTail〉 〈functionTypeTails〉
    |   〈functionTypeTail〉

〈functionTypeTail〉 ::=
    Function 〈typeParameters〉? 〈parameterTypeList〉

〈parameterTypeList〉 ::=
        ‘(’ ‘)’
    |   ‘(’ 〈normalParameterTypes〉 ‘,’ 〈optionalParameterTypes〉 ‘)’
    |   ‘(’ 〈normalParameterTypes〉 ‘,’? ‘)’
    |   ‘(’ 〈optionalParameterTypes〉 ‘)’

〈normalParameterTypes〉 ::=
    〈normalParameterType〉 ( ‘,’ 〈normalParameterType〉 )*

〈normalParameterType〉 ::=
        〈typedIdentifier〉
    |   〈type〉

〈optionalParameterTypes〉 ::=
        〈optionalPositionalParameterTypes〉
    |   〈namedParameterTypes〉

〈optionalPositionalParameterTypes〉 ::=
    ‘[’ 〈normalParameterTypes〉 ‘,’? ‘]’

〈namedParameterTypes〉 ::=
    ‘{’ 〈typedIdentifier〉 ( ‘,’ 〈typedIdentifier〉 )* ‘,’? ‘}’

〈typedIdentifier〉 ::=
    〈type〉 〈identifier〉

〈typeAlias〉 ::=
        〈metadata〉 typedef 〈typeIdentifier〉 〈typeParameters〉? ‘=’ 〈functionType〉 ‘;’
    |   〈metadata〉 typedef 〈functionTypeAlias〉

〈functionTypeAlias〉 ::=
    〈functionPrefix〉 〈formalParameterPart〉 ‘;’

〈functionPrefix〉 ::=
    〈type〉? 〈identifier〉

〈LETTER〉 ::=
        ‘a’ .. ‘z’
    |   ‘A’ .. ‘Z’

〈DIGIT〉 ::=
    ‘0’ .. ‘9’

〈WHITESPACE〉 ::=
    ( ‘\t’ | ‘ ’ | 〈NEWLINE〉 )+

〈SINGLE_LINE_COMMENT〉 ::=
    ‘//’ ( ̃  〈NEWLINE〉 )* ( 〈NEWLINE〉 )?

〈MULTI_LINE_COMMENT〉 ::=
    ‘/*’ ( 〈MULTI_LINE_COMMENT〉 | ̃  ‘*/’ )* ‘*/’

```