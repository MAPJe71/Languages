/*
 *  Licensed to the Apache Software Foundation (ASF) under one
 *  or more contributor license agreements.  See the NOTICE file
 *  distributed with this work for additional information
 *  regarding copyright ownership.  The ASF licenses this file
 *  to you under the Apache License, Version 2.0 (the
 *  "License"); you may not use this file except in compliance
 *  with the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
parser grammar GroovyParser;

options { tokenVocab = GroovyLexer; }

@header {
    import java.util.Arrays;
    import java.util.Set;
    import java.util.HashSet;
}

@members {

    private boolean ellipsisEnabled = false;

    private boolean isEllipsisEnabled() {
        return ellipsisEnabled;
    }
    private void enableEllipsis() {
        ellipsisEnabled = true;
    }
    private void disableEllipsis() {
        ellipsisEnabled = false;
    }

    private static String createErrorMessageForStrictCheck(Set<String> s, String keyword) {
        if (VISIBILITY_MODIFIER_SET.contains(keyword)) {
            StringBuilder sb = new StringBuilder();
            for (String m : s) {
                if (VISIBILITY_MODIFIER_SET.contains(m)) {
                    sb.append(m + ", ");
                }
            }

            return sb.append(keyword) + " are not allowed to duplicate or define in the same time.";
        } else {
            return "duplicated " + keyword + " is not allowed.";
        }
    }

    private static final Set<String> VISIBILITY_MODIFIER_SET = new HashSet<String>(Arrays.asList("public", "protected", "private"));
    private static final String VISIBILITY_MODIFIER_STR = "VISIBILITY_MODIFIER";
    private static void collectModifier(Set<String> s, String modifier) {
        s.add(modifier);
    }
    private static boolean checkModifierDuplication(Set<String> s, String modifier) {
        if (VISIBILITY_MODIFIER_SET.contains(modifier)) {
            modifier = VISIBILITY_MODIFIER_STR;

            for (String m : s) {
                m = VISIBILITY_MODIFIER_SET.contains(m) ? VISIBILITY_MODIFIER_STR : m;

                if (m.equals(modifier)) {
                    return true;
                }
            }

            return false;
        } else {
            return s.contains(modifier);
        }
    }

}

compilationUnit: SHEBANG_COMMENT? (NL*)
                 packageDefinition? (NL | SEMICOLON)*
                 (importStatement (NL | SEMICOLON) | classDeclaration | scriptPart (NL | SEMICOLON) | (NL | SEMICOLON))* (NL | SEMICOLON)*
                 (scriptPart)? (NL | SEMICOLON)*
                 EOF;

scriptPart: { !GrammarPredicates.isInvalidMethodDeclaration(_input) }? methodDeclaration[null]
          | statement
;

packageDefinition:
    (annotationClause (NL | annotationClause)*)? KW_PACKAGE (IDENTIFIER (DOT IDENTIFIER)*);
importStatement:
    (annotationClause (NL | annotationClause)*)? KW_IMPORT KW_STATIC? (IDENTIFIER (DOT IDENTIFIER)* (DOT MULT)?) (KW_AS IDENTIFIER)?;

classDeclaration
locals [Set<String> modifierSet = new HashSet<String>(), boolean isEnum = false, boolean isInterface = false, String className = null]
:
    (
        (     annotationClause | classModifier {!checkModifierDuplication($modifierSet, $classModifier.text)}?<fail={createErrorMessageForStrictCheck($modifierSet, $classModifier.text)}> {collectModifier($modifierSet, $classModifier.text);})
        (NL | annotationClause | classModifier {!checkModifierDuplication($modifierSet, $classModifier.text)}?<fail={createErrorMessageForStrictCheck($modifierSet, $classModifier.text)}> {collectModifier($modifierSet, $classModifier.text);})*
    )? (AT KW_INTERFACE | KW_CLASS | KW_INTERFACE {$isInterface=true;} | KW_TRAIT | KW_ENUM {$isEnum=true;}) IDENTIFIER { $className = $IDENTIFIER.text; }
    ({!$isEnum}? genericDeclarationList? NL* (extendsClause[$isInterface])? NL*
    |
    )
    implementsClause? NL*
    classBody[$isEnum, $className];

classMember[String className]:
    methodDeclaration[$className] | fieldDeclaration | objectInitializer | classInitializer | classDeclaration ;

enumConstant: IDENTIFIER (LPAREN argumentList RPAREN)?;

classBody[boolean isEnum, String className]
    : LCURVE NL*
      ({$isEnum}? (enumConstant NL* COMMA NL*)* enumConstant NL* COMMA?
      |
      )
      (classMember[$className] (NL | SEMICOLON) | NL | SEMICOLON)* (classMember[$className] (NL | SEMICOLON)*)?
      RCURVE;

implementsClause:  KW_IMPLEMENTS NL* genericClassNameExpression (COMMA NL* genericClassNameExpression)* ;
extendsClause[boolean isInterface]
    :  KW_EXTENDS NL* genericClassNameExpression (COMMA NL* {$isInterface}?<fail={"Only interface allows multi-inheritance"}> genericClassNameExpression)* ;

// Members
methodDeclaration[String classNameParam]
locals [Set<String> modifierAndDefSet = new HashSet<String>(), String className = null]
@init {
    $className = $classNameParam;
}
:
    (
        (memberModifier {!checkModifierDuplication($modifierAndDefSet, $memberModifier.text)}?<fail={createErrorMessageForStrictCheck($modifierAndDefSet, $memberModifier.text)}> {collectModifier($modifierAndDefSet, $memberModifier.text);} | annotationClause | KW_DEF {!$modifierAndDefSet.contains($KW_DEF.text)}?<fail={createErrorMessageForStrictCheck($modifierAndDefSet, $KW_DEF.text)}> {$modifierAndDefSet.add($KW_DEF.text);})
        (memberModifier {!checkModifierDuplication($modifierAndDefSet, $memberModifier.text)}?<fail={createErrorMessageForStrictCheck($modifierAndDefSet, $memberModifier.text)}> {collectModifier($modifierAndDefSet, $memberModifier.text);} | annotationClause | KW_DEF {!$modifierAndDefSet.contains($KW_DEF.text)}?<fail={createErrorMessageForStrictCheck($modifierAndDefSet, $KW_DEF.text)}> {$modifierAndDefSet.add($KW_DEF.text);} | NL)* (
            (genericDeclarationList genericClassNameExpression) | typeDeclaration
        )?
    |
        genericClassNameExpression
    )?
    (IDENTIFIER | STRING) LPAREN NL* argumentDeclarationList NL* RPAREN throwsClause? (KW_DEFAULT annotationParameter | blockStatementWithCurve)?
;

fieldDeclaration
locals [Set<String> modifierAndDefSet = new HashSet<String>()]
:
    (
        (memberModifier {!checkModifierDuplication($modifierAndDefSet, $memberModifier.text)}?<fail={createErrorMessageForStrictCheck($modifierAndDefSet, $memberModifier.text)}> {collectModifier($modifierAndDefSet, $memberModifier.text);} | annotationClause | KW_DEF {!$modifierAndDefSet.contains($KW_DEF.text)}?<fail={createErrorMessageForStrictCheck($modifierAndDefSet, $KW_DEF.text)}> {$modifierAndDefSet.add($KW_DEF.text);})
        (memberModifier {!checkModifierDuplication($modifierAndDefSet, $memberModifier.text)}?<fail={createErrorMessageForStrictCheck($modifierAndDefSet, $memberModifier.text)}> {collectModifier($modifierAndDefSet, $memberModifier.text);} | annotationClause | KW_DEF {!$modifierAndDefSet.contains($KW_DEF.text)}?<fail={createErrorMessageForStrictCheck($modifierAndDefSet, $KW_DEF.text)}> {$modifierAndDefSet.add($KW_DEF.text);} | NL)* genericClassNameExpression?
        | genericClassNameExpression)
    singleDeclaration ( COMMA NL* singleDeclaration)*
;

declarationRule:  ( fieldDeclaration
                  | (annotationClause NL*)* KW_FINAL? KW_DEF tupleDeclaration
                  );

objectInitializer: blockStatementWithCurve ;
classInitializer: KW_STATIC blockStatementWithCurve ;

typeDeclaration:
    (genericClassNameExpression | KW_DEF)
;

annotationClause:
    AT genericClassNameExpression ( LPAREN ((annotationElementPair (COMMA annotationElementPair)*) | annotationElement)? RPAREN )?
;
annotationElementPair: IDENTIFIER ASSIGN NL* annotationElement ;
annotationElement: annotationParameter | annotationClause ;

genericDeclarationList:
    LT genericsDeclarationElement (COMMA genericsDeclarationElement)* GT
;

genericsDeclarationElement: genericClassNameExpression (KW_EXTENDS genericClassNameExpression (BAND genericClassNameExpression)* )? ;

throwsClause: KW_THROWS classNameExpression (COMMA classNameExpression)*;

argumentDeclarationList:
     (argumentDeclaration COMMA NL* )* { enableEllipsis(); } argumentDeclaration { disableEllipsis(); } | /* EMPTY ARGUMENT LIST */
     ;

argumentDeclaration:
    annotationClause* KW_FINAL? typeDeclaration? IDENTIFIER (ASSIGN NL* expression)? ;

blockStatement:
    (NL | SEMICOLON)+ (statement (NL | SEMICOLON)+)* statement? (NL | SEMICOLON)*
    | statement ((NL | SEMICOLON)+ statement)* (NL | SEMICOLON)*;


singleDeclaration: IDENTIFIER (ASSIGN NL* expression)?;
tupleDeclaration: LPAREN tupleVariableDeclaration (COMMA tupleVariableDeclaration)* RPAREN (ASSIGN NL* expression)?;
tupleVariableDeclaration: genericClassNameExpression? IDENTIFIER;
newInstanceRule: KW_NEW (classNameExpression (LT GT)? | genericClassNameExpression) (LPAREN NL* argumentList? NL* RPAREN) (classBody[false, null])?;
newArrayRule: KW_NEW classNameExpression (LBRACK expression RBRACK)+ ;

statement:
      declarationRule #declarationStatement
    | newArrayRule #newArrayStatement
    | newInstanceRule #newInstanceStatement
    | KW_FOR LPAREN (declarationRule | expression)? SEMICOLON expression? SEMICOLON expression? RPAREN NL* statementBlock #classicForStatement
    | KW_FOR LPAREN typeDeclaration? IDENTIFIER KW_IN expression RPAREN NL* statementBlock #forInStatement
    | KW_FOR LPAREN typeDeclaration  IDENTIFIER COLON expression RPAREN NL* statementBlock #forColonStatement
    | KW_IF LPAREN expression RPAREN NL* statementBlock NL* (KW_ELSE NL* statementBlock)? #ifStatement
    | KW_WHILE LPAREN expression RPAREN NL* statementBlock #whileStatement
    | KW_SWITCH LPAREN expression RPAREN NL* LCURVE
        (
          (caseStatement | NL)*
          (KW_DEFAULT COLON (statement (SEMICOLON | NL) | SEMICOLON | NL)+)?
        )
      RCURVE #switchStatement
    |  tryBlock ((catchBlock+ finallyBlock?) | finallyBlock) #tryCatchFinallyStatement
    | (KW_CONTINUE | KW_BREAK) IDENTIFIER? #controlStatement
    | KW_RETURN expression? #returnStatement
    | KW_THROW expression #throwStatement
    | KW_ASSERT expression ((COLON|COMMA) NL* expression)? #assertStatement
    | KW_SYNCHRONIZED LPAREN expression RPAREN NL* statementBlock # synchronizedStatement
    | IDENTIFIER COLON NL* statementBlock #labeledStatement
    | expression #expressionStatement
    ;

blockStatementWithCurve : LCURVE blockStatement? RCURVE;

statementBlock:
    blockStatementWithCurve
    | statement ;

tryBlock: KW_TRY NL* blockStatementWithCurve NL*;
catchBlock: KW_CATCH NL* LPAREN ((classNameExpression (BOR classNameExpression)* IDENTIFIER) | IDENTIFIER) RPAREN NL* blockStatementWithCurve NL*;
finallyBlock: KW_FINALLY NL* blockStatementWithCurve;

caseStatement: (KW_CASE expression COLON (statement (SEMICOLON | NL) | SEMICOLON | NL)* );

pathExpression: (IDENTIFIER DOT)* IDENTIFIER;
gstringPathExpression: IDENTIFIER (GSTRING_PATH_PART)* ;

closureExpressionRule: LCURVE NL* (argumentDeclarationList NL* CLOSURE_ARG_SEPARATOR NL*)? blockStatement? RCURVE ;
gstringExpressionBody:( gstringPathExpression
                      | LCURVE expression? RCURVE
                      | closureExpressionRule
                      );
gstring:  GSTRING_START gstringExpressionBody (GSTRING_PART  gstringExpressionBody)* GSTRING_END ;

// Special cases.
// 1. Command expression(parenthesis-less expressions)
// 2. Annotation paramenthers.. (inline constant)
// 3. Constant expressions.
// 4. class ones, for instanceof and as (type specifier)

annotationParameter:
    LBRACK (annotationParameter (COMMA annotationParameter)*)? RBRACK #annotationParamArrayExpression
    | classConstantRule #annotationParamClassConstantExpression //class constant
    | pathExpression #annotationParamPathExpression //constant field
    | genericClassNameExpression #annotationParamClassExpression //class
    | STRING #annotationParamStringExpression //primitive
    | DECIMAL #annotationParamDecimalExpression //primitive
    | INTEGER #annotationParamIntegerExpression //primitive
    | KW_NULL #annotationParamNullExpression //primitive
    | (KW_TRUE | KW_FALSE) #annotationParamBoolExpression //primitive
    | closureExpressionRule # annotationParamClosureExpression
;

// (!!! OUTDATED !!!)Reference: https://github.com/apache/groovy/blob/master/src/main/org/codehaus/groovy/antlr/groovy.g#L2276
// The operators have the following precedences:
//      lowest  ( 15)  = **= *= /= %= += -= <<= >>= >>>= &= ^= |= (assignments)
//              ( 14)  ?: (conditional expression and elvis)
//              ( 13)  || (logical or)
//              ( 12)  && (logical and)
//              ( 11)  | ()binary or
//              ( 10)  ^ (binary xor)
//              (  9)  & (binary and)
//              (8.5)  =~ ==~ (regex find/match)
//              (  8)  == != <=> === !== (equals, not equals, compareTo)
//              (  7)  < <= > >= instanceof as in (relational, in, instanceof, type coercion)
//              (  6)  << >> >>> .. ..< (shift, range)
//              (  5)  + - (addition, subtraction)
//              (  4)  * / % (multiply div modulo)
//              (  3)  ++ -- + - (pre dec/increment, unary signs)
//              (  2)  ** (power)
//              (  1)  ~ ! $ (type) (negate, not, typecast)
//                     ?. * *. *: (safe dereference, spread, spread-dot, spread-map)
//                     . .& .@ (member access, method closure, field/attribute access)
//                     [] ++ -- (list/map/array index, post inc/decrement)
//                     () {} [] (method call, closableBlock, list/map literal)
//                     new () (object creation, explicit parenthesis)
expression:
      atomExpressionRule #atomExpression
    | KW_THIS #thisExpression
    | KW_SUPER #superExpression
    | (KW_THIS | KW_SUPER) LPAREN argumentList? RPAREN  #constructorCallExpression
    | e=expression NL* op=(DOT | SAFE_DOT | STAR_DOT | ATTR_DOT | MEMBER_POINTER) (selectorName | STRING | gstring | LPAREN mne=expression RPAREN) #fieldAccessExpression

    | MULT expression #spreadExpression
    | expression (DECREMENT | INCREMENT)  #postfixExpression


    | expression LBRACK (expression (COMMA expression)*)? RBRACK #indexExpression

    | expression NL* op=(DOT | SAFE_DOT | STAR_DOT) NL* genericDeclarationList? c=callExpressionRule      (nonKwCallExpressionRule)* (IDENTIFIER | STRING | gstring)?   # cmdExpression
    |                                                                           n=nonKwCallExpressionRule (nonKwCallExpressionRule)* (IDENTIFIER | STRING | gstring)?   # cmdExpression

    | callRule                                                                    #callExpression

    | LPAREN genericClassNameExpression RPAREN expression #castExpression
    | LPAREN expression RPAREN #parenthesisExpression

    | (NOT | BNOT) expression #unaryExpression

    | expression POWER NL* expression #binaryExpression

    | (PLUS | MINUS) expression #unaryExpression
    | (DECREMENT | INCREMENT) expression #prefixExpression

    | expression (MULT | DIV | MOD) NL* expression #binaryExpression
    | expression (PLUS | MINUS) NL* expression #binaryExpression

    | expression (RANGE | ORANGE) NL* expression #binaryExpression
    | expression (LSHIFT | GT GT | GT GT GT) NL* expression #binaryExpression

    | expression KW_IN NL* expression #binaryExpression
    | expression (KW_AS | KW_INSTANCEOF) NL* genericClassNameExpression #binaryExpression
    | expression (LT | LTE | GT | GTE) NL* expression #binaryExpression

    | expression (EQUAL | UNEQUAL | SPACESHIP) NL* expression #binaryExpression

    | expression (FIND | MATCH) NL* expression #binaryExpression

    | expression BAND NL* expression #binaryExpression
    | expression XOR NL* expression #binaryExpression
    | expression BOR NL* expression #binaryExpression

    | expression NL* AND NL* expression #binaryExpression
    | expression NL* OR NL* expression #binaryExpression

    |<assoc=right> expression NL* (QUESTION NL* expression NL* COLON | ELVIS) NL* expression #ternaryExpression

    |<assoc=right> expression (ASSIGN | PLUS_ASSIGN | MINUS_ASSIGN | MULT_ASSIGN | DIV_ASSIGN | MOD_ASSIGN | BAND_ASSIGN | XOR_ASSIGN | BOR_ASSIGN | LSHIFT_ASSIGN | RSHIFT_ASSIGN | RUSHIFT_ASSIGN) NL* expression #assignmentExpression
    |<assoc=right> LPAREN IDENTIFIER (COMMA IDENTIFIER)* RPAREN ASSIGN NL* expression #assignmentExpression
;

atomExpressionRule:
      STRING  #constantExpression
    | gstring #gstringExpression
    | DECIMAL #constantDecimalExpression
    | INTEGER #constantIntegerExpression
    | KW_NULL #nullExpression
    | (KW_TRUE | KW_FALSE) #boolExpression
    | IDENTIFIER #variableExpression
    | classConstantRule #classConstantExpression
    | closureExpressionRule #closureExpression
    | LBRACK NL* (expression (NL* COMMA NL* expression NL*)* COMMA?)?  NL* RBRACK #listConstructor
    | LBRACK NL* (COLON NL*| (mapEntry (NL* COMMA NL* mapEntry NL*)*) COMMA?) NL* RBRACK #mapConstructor
    | newArrayRule #newArrayExpression
    | newInstanceRule #newInstanceExpression
;

classConstantRule: classNameExpression (DOT KW_CLASS)?;

argumentListRule:
    LPAREN NL* argumentList? NL* RPAREN closureExpressionRule*;

callExpressionRule:
                    (selectorName | STRING | gstring | LPAREN mne=expression RPAREN) argumentListRule+
                  | { !GrammarPredicates.isFollowedByLPAREN(_input) }? (selectorName | STRING | gstring | LPAREN mne=expression RPAREN) argumentList
                  ;
nonKwCallExpressionRule:
// @baseContext{callExpressionRule} does not work in antlr4.5.3
                    (IDENTIFIER   | STRING | gstring) argumentListRule+
                  | { !GrammarPredicates.isFollowedByLPAREN(_input) }? (IDENTIFIER   | STRING | gstring) argumentList
                  ;
callRule
                  : a=atomExpressionRule argumentListRule+
                  | { !GrammarPredicates.isFollowedByLPAREN(_input) }? (c=closureExpressionRule                                       ) argumentList
                  | { !GrammarPredicates.isClassName(_input, 2)     }? LPAREN mne=expression RPAREN argumentListRule+
                  ;

classNameExpression: { GrammarPredicates.isClassName(_input) }? (BUILT_IN_TYPE | pathExpression);


genericClassNameExpression: classNameExpression genericList? (LBRACK RBRACK)* (ELLIPSIS { isEllipsisEnabled() }?<fail={ "The var-arg only be allowed to appear as the last parameter" }>)?;

genericList:
    LT genericListElement (COMMA genericListElement)* GT
;

genericListElement:
    genericClassNameExpression #genericsConcreteElement
    | QUESTION (KW_EXTENDS genericClassNameExpression | KW_SUPER genericClassNameExpression)? #genericsWildcardElement
;

mapEntry:
    STRING COLON expression
    | gstring COLON expression
    | selectorName COLON expression
    | LPAREN expression RPAREN COLON expression
    | MULT COLON expression
    | DECIMAL COLON expression
    | INTEGER COLON expression
;

classModifier:
VISIBILITY_MODIFIER | KW_STATIC | (KW_ABSTRACT | KW_FINAL) | KW_STRICTFP ;

memberModifier:
    VISIBILITY_MODIFIER | KW_STATIC | (KW_ABSTRACT | KW_FINAL) | KW_NATIVE | KW_SYNCHRONIZED | KW_TRANSIENT | KW_VOLATILE ;

argumentList: ( (closureExpressionRule)+ | argument (NL* COMMA NL* argument)*) ;

argument
        : mapEntry
        | expression
        ;

selectorName
        : IDENTIFIER
        | kwSelectorName
        ;

kwSelectorName: KW_ABSTRACT | KW_AS | KW_ASSERT | KW_BREAK | KW_CASE | KW_CATCH | KW_CLASS | KW_CONST | KW_CONTINUE
                     | KW_DEF | KW_DEFAULT | KW_DO | KW_ELSE | KW_ENUM | KW_EXTENDS | KW_FALSE | KW_FINAL | KW_FINALLY
                     | KW_FOR | KW_GOTO | KW_IF | KW_IMPLEMENTS | KW_IMPORT | KW_IN | KW_INSTANCEOF | KW_INTERFACE
                     | KW_NATIVE | KW_NEW | KW_NULL | KW_PACKAGE
                     | KW_RETURN | KW_STATIC | KW_STRICTFP | KW_SUPER | KW_SWITCH | KW_SYNCHRONIZED | KW_THIS | KW_THREADSAFE | KW_THROW
                     | KW_THROWS | KW_TRANSIENT | KW_TRAIT | KW_TRUE | KW_TRY | KW_VOLATILE | KW_WHILE
                     | BUILT_IN_TYPE | VISIBILITY_MODIFIER /* in place of KW_PRIVATE | KW_PROTECTED | KW_PUBLIC */
;