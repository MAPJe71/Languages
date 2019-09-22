
# Java

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
[Java] -------------------------------------------------------------------------
@=Java

_WWW_=

_Wiki_=https://en.wikipedia.org/wiki/Java_(programming_language)

Keywords=http://docs.oracle.com/javase/specs/jls/se8/html/jls-3.html#jls-3.9

   abstract   continue   for          new         switch
   assert     default    if           package     synchronized
   boolean    do         goto         private     this
   break      double     implements   protected   throw
   byte       else       import       public      throws
   case       enum       instanceof   return      transient
   catch      extends    int          short       try
   char       final      interface    static      void
   class      finally    long         strictfp    volatile
   const      float      native       super       while

   A RegEx to find them all:

       \b(?!(?:
           a(?:bstract|ssert)
       |   b(?:oolean|reak|yte)
       |   c(?:ase|atch|har|lass|on(?:st|tinue))
       |   d(?:efault|o(?:uble)?)
       |   e(?:lse|num|xtends)
       |   f(?:inal(?:ly)?|loat|or)
       |   goto
       |   i(?:f|mp(?:lements|ort)|nstanceof|nt(?:erface)?)
       |   long
       |   n(?:ative|ew)
       |   p(?:ackage|rivate|rotected|ublic)
       |   return
       |   s(?:hort|tatic|trictfp|uper|witch|ynchronized)
       |   th(?:is|rows?)|tr(?:ansient|y)
       |   vo(?:id|latile)
       |   while
       )\b)

Identifiers=http://docs.oracle.com/javase/specs/jls/se8/html/jls-3.html#jls-3.8

StringLiterals=http://docs.oracle.com/javase/specs/jls/se8/html/jls-3.html#jls-3.10.5


   StringLiteral:                                                              \x22(?:[^\r\n\x22\x5C]|\x5C(?-i:u[A-Za-z0-9]{4}|[btnfr\x22\x27\x5C]|[0-7]{1,2}|[0-3][0-7]{2}))*\x22
       " {StringCharacter} "

   StringCharacter:
       InputCharacter but not " or \
       EscapeSequence

   InputCharacter:
       UnicodeInputCharacter but not CR or LF

   UnicodeInputCharacter:
       UnicodeEscape
       RawInputCharacter

   UnicodeEscape:                                                              \\u[A-Za-z0-9]{4}
       \ UnicodeMarker HexDigit HexDigit HexDigit HexDigit

   UnicodeMarker:
       u {u}

   HexDigit:                                                                   [A-Za-z0-9]
       (one of)
       0 1 2 3 4 5 6 7 8 9 a b c d e f A B C D E F

   RawInputCharacter:
       any Unicode character

   EscapeSequence:                                                             \\([btnfr"'\\]|[0-7]{1,2}|[0-3][0-7]{2})
       \ b         (backspace BS       , Unicode \u0008)
       \ t         (horizontal tab HT  , Unicode \u0009)
       \ n         (linefeed LF        , Unicode \u000a)
       \ f         (form feed FF       , Unicode \u000c)
       \ r         (carriage return CR , Unicode \u000d)
       \ "         (double quote "     , Unicode \u0022)
       \ '         (single quote '     , Unicode \u0027)
       \ \         (backslash \        , Unicode \u005c)
       OctalEscape (octal value        , Unicode \u0000 to \u00ff)

   OctalEscape:                                                                \\([0-7]{1,2}|[0-3][0-7]{2})
       \ OctalDigit                                                            \\[0-7]
       \ OctalDigit OctalDigit                                                 \\[0-7]{2}
       \ ZeroToThree OctalDigit OctalDigit                                     \\[0-3][0-7]{2}

   OctalDigit:                                                                 [0-7]
       (one of)
       0 1 2 3 4 5 6 7

   ZeroToThree:                                                                [0-3]
       (one of)
       0 1 2 3


Comment=http://docs.oracle.com/javase/specs/jls/se8/html/jls-3.html#jls-3.7

   C-style
       /* This is comment */
       /*
        * This is
        * a multiple
        * line comment
        */

   C++-style
       // This is a comment

   Java Documentation (Javadoc)
       /** This is a JavaDoc comment */

       /**
       * This also is a JavaDoc comment
       */

Classes_and_Methods=

Function=

   There are no global functions in Java. The equivalent is to define static
   methods in a class (here invoked as "Math.multiply(a,b)"). Overloading allows
   us to define the method for multiple types.

       public class Math
       {
           public static    int multiply(   int a,    int b) { return a*b; }
           public static double multiply(double a, double b) { return a*b; }
       }

Grammar=

   The grammar below uses the following BNF-style conventions:

       [x] denotes zero or one occurrences of x.

       {x} denotes zero or more occurrences of x.

       (x | y) means one of either x or y.


   Identifier:
       IDENTIFIER

   QualifiedIdentifier:
       Identifier { . Identifier }

   QualifiedIdentifierList:
       QualifiedIdentifier { , QualifiedIdentifier }

   CompilationUnit:
       [[Annotations] package QualifiedIdentifier ;]
                                   {ImportDeclaration} {TypeDeclaration}

   ImportDeclaration:
       import [static] Identifier { . Identifier } [. *] ;

   TypeDeclaration:
       ClassOrInterfaceDeclaration
       ;

   ClassOrInterfaceDeclaration:
       {Modifier} (ClassDeclaration | InterfaceDeclaration)

   ClassDeclaration:
       NormalClassDeclaration
       EnumDeclaration

   InterfaceDeclaration:
       NormalInterfaceDeclaration
       AnnotationTypeDeclaration

   NormalClassDeclaration:
       class Identifier [TypeParameters]
                                   [extends Type] [implements TypeList] ClassBody

   EnumDeclaration:
       enum Identifier [implements TypeList] EnumBody

   NormalInterfaceDeclaration:
       interface Identifier [TypeParameters] [extends TypeList] InterfaceBody

   AnnotationTypeDeclaration:
       @ interface Identifier AnnotationTypeBody

   Type:
       BasicType {[]}
       ReferenceType  {[]}

   BasicType:
       byte
       short
       char
       int
       long
       float
       double
       boolean

   ReferenceType:
       Identifier [TypeArguments] { . Identifier [TypeArguments] }

   TypeArguments:
       < TypeArgument { , TypeArgument } >

   TypeArgument:
       ReferenceType
       ? [ (extends | super) ReferenceType ]

   NonWildcardTypeArguments:
       < TypeList >

   TypeList:
       ReferenceType { , ReferenceType }

   TypeArgumentsOrDiamond:
       < >
       TypeArguments

   NonWildcardTypeArgumentsOrDiamond:
       < >
       NonWildcardTypeArguments

   TypeParameters:
       < TypeParameter { , TypeParameter } >

   TypeParameter:
       Identifier [extends Bound]

   Bound:
       ReferenceType { & ReferenceType }

   Modifier:
       Annotation
       public
       protected
       private
       static
       abstract
       final
       native
       synchronized
       transient
       volatile
       strictfp

   Annotations:
       Annotation {Annotation}

   Annotation:
       @ QualifiedIdentifier [ ( [AnnotationElement] ) ]

   AnnotationElement:
       ElementValuePairs
       ElementValue

   ElementValuePairs:
       ElementValuePair { , ElementValuePair }

   ElementValuePair:
       Identifier = ElementValue

   ElementValue:
       Annotation
       Expression1
       ElementValueArrayInitializer

   ElementValueArrayInitializer:
       { [ElementValues] [,] }

   ElementValues:
       ElementValue { , ElementValue }

   ClassBody:
       { { ClassBodyDeclaration } }

   ClassBodyDeclaration:
       ;
       {Modifier} MemberDecl
       [static] Block

   MemberDecl:
       MethodOrFieldDecl
       void Identifier VoidMethodDeclaratorRest
       Identifier ConstructorDeclaratorRest
       GenericMethodOrConstructorDecl
       ClassDeclaration
       InterfaceDeclaration

   MethodOrFieldDecl:
       Type Identifier MethodOrFieldRest

   MethodOrFieldRest:
       FieldDeclaratorsRest ;
       MethodDeclaratorRest

   FieldDeclaratorsRest:
       VariableDeclaratorRest { , VariableDeclarator }

   MethodDeclaratorRest:
       FormalParameters {[]} [throws QualifiedIdentifierList] (Block | ;)

   VoidMethodDeclaratorRest:
       FormalParameters [throws QualifiedIdentifierList] (Block | ;)

   ConstructorDeclaratorRest:
       FormalParameters [throws QualifiedIdentifierList] Block

   GenericMethodOrConstructorDecl:
       TypeParameters GenericMethodOrConstructorRest

   GenericMethodOrConstructorRest:
       (Type | void) Identifier MethodDeclaratorRest
       Identifier ConstructorDeclaratorRest

   InterfaceBody:
       { { InterfaceBodyDeclaration } }

   InterfaceBodyDeclaration:
       ;
       {Modifier} InterfaceMemberDecl

   InterfaceMemberDecl:
       InterfaceMethodOrFieldDecl
       void Identifier VoidInterfaceMethodDeclaratorRest
       InterfaceGenericMethodDecl
       ClassDeclaration
       InterfaceDeclaration

   InterfaceMethodOrFieldDecl:
       Type Identifier InterfaceMethodOrFieldRest

   InterfaceMethodOrFieldRest:
       ConstantDeclaratorsRest ;
       InterfaceMethodDeclaratorRest

   ConstantDeclaratorsRest:
       ConstantDeclaratorRest { , ConstantDeclarator }

   ConstantDeclaratorRest:
       {[]} = VariableInitializer

   ConstantDeclarator:
       Identifier ConstantDeclaratorRest

   InterfaceMethodDeclaratorRest:
       FormalParameters {[]} [throws QualifiedIdentifierList] ;

   VoidInterfaceMethodDeclaratorRest:
       FormalParameters [throws QualifiedIdentifierList] ;

   InterfaceGenericMethodDecl:
       TypeParameters (Type | void) Identifier InterfaceMethodDeclaratorRest

   FormalParameters:
       ( [FormalParameterDecls] )

   FormalParameterDecls:
       {VariableModifier}  Type FormalParameterDeclsRest

   VariableModifier:
       final
       Annotation

   FormalParameterDeclsRest:
       VariableDeclaratorId [, FormalParameterDecls]
       ... VariableDeclaratorId

   VariableDeclaratorId:
       Identifier {[]}

   VariableDeclarators:
       VariableDeclarator { , VariableDeclarator }

   VariableDeclarator:
       Identifier VariableDeclaratorRest

   VariableDeclaratorRest:
       {[]} [ = VariableInitializer ]

   VariableInitializer:
       ArrayInitializer
       Expression

   ArrayInitializer:
       { [ VariableInitializer { , VariableInitializer } [,] ] }

   Block:
       { BlockStatements }

   BlockStatements:
       { BlockStatement }

   BlockStatement:
       LocalVariableDeclarationStatement
       ClassOrInterfaceDeclaration
       [Identifier :] Statement

   LocalVariableDeclarationStatement:
       { VariableModifier }  Type VariableDeclarators ;

   Statement:
       Block
       ;
       Identifier : Statement
       StatementExpression ;
       if ParExpression Statement [else Statement]
       assert Expression [: Expression] ;
       switch ParExpression { SwitchBlockStatementGroups }
       while ParExpression Statement
       do Statement while ParExpression ;
       for ( ForControl ) Statement
       break [Identifier] ;
       continue [Identifier] ;
       return [Expression] ;
       throw Expression ;
       synchronized ParExpression Block
       try Block (Catches | [Catches] Finally)
       try ResourceSpecification Block [Catches] [Finally]

   StatementExpression:
       Expression

   Catches:
       CatchClause { CatchClause }

   CatchClause:
       catch ( {VariableModifier} CatchType Identifier ) Block

   CatchType:
       QualifiedIdentifier { | QualifiedIdentifier }

   Finally:
       finally Block

   ResourceSpecification:
       ( Resources [;] )

   Resources:
       Resource { ; Resource }

   Resource:
       {VariableModifier} ReferenceType VariableDeclaratorId = Expression

   SwitchBlockStatementGroups:
       { SwitchBlockStatementGroup }

   SwitchBlockStatementGroup:
       SwitchLabels BlockStatements

   SwitchLabels:
       SwitchLabel { SwitchLabel }

   SwitchLabel:
       case Expression :
       case EnumConstantName :
       default :

   EnumConstantName:
       Identifier

   ForControl:
       ForVarControl
       ForInit ; [Expression] ; [ForUpdate]

   ForVarControl:
       {VariableModifier} Type VariableDeclaratorId  ForVarControlRest

   ForVarControlRest:
       ForVariableDeclaratorsRest ; [Expression] ; [ForUpdate]
       : Expression

   ForVariableDeclaratorsRest:
       [= VariableInitializer] { , VariableDeclarator }

   ForInit:
   ForUpdate:
       StatementExpression { , StatementExpression }

   Expression:
       Expression1 [AssignmentOperator Expression1]

   AssignmentOperator:
       =
       +=
       -=
       *=
       /=
       &=
       |=
       ^=
       %=
       <<=
       >>=
       >>>=

   Expression1:
       Expression2 [Expression1Rest]

   Expression1Rest:
       ? Expression : Expression1

   Expression2:
       Expression3 [Expression2Rest]

   Expression2Rest:
       { InfixOp Expression3 }
       instanceof Type

   InfixOp:
       ||
       &&
       |
       ^
       &
       ==
       !=
       <
       >
       <=
       >=
       <<
       >>
       >>>
       +
       -
       *
       /
       %

   Expression3:
       PrefixOp Expression3
       ( (Expression | Type) ) Expression3
       Primary { Selector } { PostfixOp }

   PrefixOp:
       ++
       --
       !
       ~
       +
       -

   PostfixOp:
       ++
       --

   Primary:
       Literal
       ParExpression
       this [Arguments]
       super SuperSuffix
       new Creator
       NonWildcardTypeArguments (ExplicitGenericInvocationSuffix | this Arguments)
       Identifier { . Identifier } [IdentifierSuffix]
       BasicType {[]} . class
       void . class

   Literal:
       IntegerLiteral
       FloatingPointLiteral
       CharacterLiteral
       StringLiteral
       BooleanLiteral
       NullLiteral

   ParExpression:
       ( Expression )

   Arguments:
       ( [ Expression { , Expression } ] )

   SuperSuffix:
       Arguments
       . Identifier [Arguments]

   ExplicitGenericInvocationSuffix:
       super SuperSuffix
       Identifier Arguments

   Creator:
       NonWildcardTypeArguments CreatedName ClassCreatorRest
       CreatedName (ClassCreatorRest | ArrayCreatorRest)

   CreatedName:
       Identifier [TypeArgumentsOrDiamond] { . Identifier [TypeArgumentsOrDiamond] }

   ClassCreatorRest:
       Arguments [ClassBody]

   ArrayCreatorRest:
       [ (] {[]} ArrayInitializer  |  Expression ] {[ Expression ]} {[]})

   IdentifierSuffix:
       [ ({[]} . class | Expression) ]
       Arguments
       . (class | ExplicitGenericInvocation | this | super Arguments |
                                   new [NonWildcardTypeArguments] InnerCreator)

   ExplicitGenericInvocation:
       NonWildcardTypeArguments ExplicitGenericInvocationSuffix

   InnerCreator:
       Identifier [NonWildcardTypeArgumentsOrDiamond] ClassCreatorRest

   Selector:
       . Identifier [Arguments]
       . ExplicitGenericInvocation
       . this
       . super SuperSuffix
       . new [NonWildcardTypeArguments] InnerCreator
       [ Expression ]

   EnumBody:
       { [EnumConstants] [,] [EnumBodyDeclarations] }

   EnumConstants:
       EnumConstant
       EnumConstants , EnumConstant

   EnumConstant:
       [Annotations] Identifier [Arguments] [ClassBody]

   EnumBodyDeclarations:
       ; {ClassBodyDeclaration}

   AnnotationTypeBody:
       { [AnnotationTypeElementDeclarations] }

   AnnotationTypeElementDeclarations:
       AnnotationTypeElementDeclaration
       AnnotationTypeElementDeclarations AnnotationTypeElementDeclaration

   AnnotationTypeElementDeclaration:
       {Modifier} AnnotationTypeElementRest

   AnnotationTypeElementRest:
       Type Identifier AnnotationMethodOrConstantRest ;
       ClassDeclaration
       InterfaceDeclaration
       EnumDeclaration
       AnnotationTypeDeclaration

   AnnotationMethodOrConstantRest:
       AnnotationMethodRest
       ConstantDeclaratorsRest

   AnnotationMethodRest:
       ( ) [[]] [default ElementValue]


