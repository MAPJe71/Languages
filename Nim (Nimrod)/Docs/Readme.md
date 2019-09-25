
# Nim / Nimrod

## Description

Nim a.k.a. Nimrod

## Links

_WWW_

https://nim-lang.org/
https://nim-lang.org/docs/manual.html

_Wiki_


## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~
addr and as asm atomic
bind block break
case cast concept const continue converter
defer discard distinct div do
elif else end enum except export
finally for from func
generic
if import in include interface is isnot iterator
let
macro method mixin mod
nil not notin
object of or out
proc ptr
raise ref return
shl shr static
template try tuple type
using
var
when while with without
xor
yield


## Identifiers

letter ::= 'A'..'Z' | 'a'..'z' | '\x80'..'\xff'
digit ::= '0'..'9'
IDENTIFIER ::= letter ( ['_'] (letter | digit) )*

## String Literals

### Single quoted

### Double quoted

### Document String - Double or Single Triple-Quoted

### Backslash quoted


## Comment

Comments start anywhere outside a string or character literal with the hash character #. Comments consist of a concatenation of comment pieces. A comment piece starts with # and runs until the end of the line. The end of line characters belong to the piece. If the next line only consists of a comment piece with no other tokens between it and the preceding one, it does not start a new comment:

i = 0     # This is a single comment over multiple lines.
  # The scanner merges these two pieces.
  # The comment continues here.

Documentation comments are comments that start with two ##. Documentation comments are tokens; they are only allowed at certain places in the input file as they belong to the syntax tree!
Multiline comments

Starting with version 0.13.0 of the language Nim supports multiline comments. They look like:

#[Comment here.
Multiple lines
are not a problem.]#

Multiline comments support nesting:

#[  #[ Multiline comment in already
   commented out code. ]#
proc p[T](x: T) = discard
]#

Multiline documentation comments also exist and support nesting too:

proc foo =
  ##[Long documentation comment
  here.
  ]##

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

module = stmt ^* (';' / IND{=})
comma = ',' COMMENT?
semicolon = ';' COMMENT?
colon = ':' COMMENT?
colcom = ':' COMMENT?
operator =  OP0 | OP1 | OP2 | OP3 | OP4 | OP5 | OP6 | OP7 | OP8 | OP9
         | 'or' | 'xor' | 'and'
         | 'is' | 'isnot' | 'in' | 'notin' | 'of'
         | 'div' | 'mod' | 'shl' | 'shr' | 'not' | 'static' | '..'
prefixOperator = operator
optInd = COMMENT?
optPar = (IND{>} | IND{=})?
simpleExpr = arrowExpr (OP0 optInd arrowExpr)* pragma?
arrowExpr = assignExpr (OP1 optInd assignExpr)*
assignExpr = orExpr (OP2 optInd orExpr)*
orExpr = andExpr (OP3 optInd andExpr)*
andExpr = cmpExpr (OP4 optInd cmpExpr)*
cmpExpr = sliceExpr (OP5 optInd sliceExpr)*
sliceExpr = ampExpr (OP6 optInd ampExpr)*
ampExpr = plusExpr (OP7 optInd plusExpr)*
plusExpr = mulExpr (OP8 optInd mulExpr)*
mulExpr = dollarExpr (OP9 optInd dollarExpr)*
dollarExpr = primary (OP10 optInd primary)*
symbol = '`' (KEYW|IDENT|literal|(operator|'('|')'|'['|']'|'{'|'}'|'=')+)+ '`'
       | IDENT | 'addr' | 'type'
exprColonEqExpr = expr (':'|'=' expr)?
exprList = expr ^+ comma
dotExpr = expr '.' optInd symbol
qualifiedIdent = symbol ('.' optInd symbol)?
exprColonEqExprList = exprColonEqExpr (comma exprColonEqExpr)* (comma)?
setOrTableConstr = '{' ((exprColonEqExpr comma)* | ':' ) '}'
castExpr = 'cast' '[' optInd typeDesc optPar ']' '(' optInd expr optPar ')'
parKeyw = 'discard' | 'include' | 'if' | 'while' | 'case' | 'try'
        | 'finally' | 'except' | 'for' | 'block' | 'const' | 'let'
        | 'when' | 'var' | 'mixin'
par = '(' optInd
          ( &parKeyw complexOrSimpleStmt ^+ ';'
          | ';' complexOrSimpleStmt ^+ ';'
          | pragmaStmt
          | simpleExpr ( ('=' expr (';' complexOrSimpleStmt ^+ ';' )? )
                       | (':' expr (',' exprColonEqExpr     ^+ ',' )? ) ) )
          optPar ')'
literal = | INT_LIT | INT8_LIT | INT16_LIT | INT32_LIT | INT64_LIT
          | UINT_LIT | UINT8_LIT | UINT16_LIT | UINT32_LIT | UINT64_LIT
          | FLOAT_LIT | FLOAT32_LIT | FLOAT64_LIT
          | STR_LIT | RSTR_LIT | TRIPLESTR_LIT
          | CHAR_LIT
          | NIL
generalizedLit = GENERALIZED_STR_LIT | GENERALIZED_TRIPLESTR_LIT
identOrLiteral = generalizedLit | symbol | literal
               | par | arrayConstr | setOrTableConstr
               | castExpr
tupleConstr = '(' optInd (exprColonEqExpr comma?)* optPar ')'
arrayConstr = '[' optInd (exprColonEqExpr comma?)* optPar ']'
primarySuffix = '(' (exprColonEqExpr comma?)* ')' doBlocks?
      | doBlocks
      | '.' optInd symbol generalizedLit?
      | '[' optInd indexExprList optPar ']'
      | '{' optInd indexExprList optPar '}'
      | &( '`'|IDENT|literal|'cast'|'addr'|'type') expr # command syntax
condExpr = expr colcom expr optInd
        ('elif' expr colcom expr optInd)*
         'else' colcom expr
ifExpr = 'if' condExpr
whenExpr = 'when' condExpr
pragma = '{.' optInd (exprColonExpr comma?)* optPar ('.}' | '}')
identVis = symbol opr?  # postfix position
identVisDot = symbol '.' optInd symbol opr?
identWithPragma = identVis pragma?
identWithPragmaDot = identVisDot pragma?
declColonEquals = identWithPragma (comma identWithPragma)* comma?
                  (':' optInd typeDesc)? ('=' optInd expr)?
identColonEquals = ident (comma ident)* comma?
     (':' optInd typeDesc)? ('=' optInd expr)?)
inlTupleDecl = 'tuple'
    [' optInd  (identColonEquals (comma/semicolon)?)*  optPar ']'
extTupleDecl = 'tuple'
    COMMENT? (IND{>} identColonEquals (IND{=} identColonEquals)*)?
tupleClass = 'tuple'
paramList = '(' declColonEquals ^* (comma/semicolon) ')'
paramListArrow = paramList? ('->' optInd typeDesc)?
paramListColon = paramList? (':' optInd typeDesc)?
doBlock = 'do' paramListArrow pragmas? colcom stmt
doBlocks = doBlock ^* IND{=}
procExpr = 'proc' paramListColon pragmas? ('=' COMMENT? stmt)?
distinct = 'distinct' optInd typeDesc
expr = (ifExpr
      | whenExpr
      | caseExpr
      | tryExpr)
      / simpleExpr
typeKeyw = 'var' | 'out' | 'ref' | 'ptr' | 'shared' | 'tuple'
         | 'proc' | 'iterator' | 'distinct' | 'object' | 'enum'
primary = typeKeyw typeDescK
        /  prefixOperator* identOrLiteral primarySuffix*
        / 'static' primary
        / 'bind' primary
typeDesc = simpleExpr
typeDefAux = simpleExpr
           | 'concept' typeClass
macroColon = ':' stmt? ( IND{=} 'of' exprList ':' stmt
                       | IND{=} 'elif' expr ':' stmt
                       | IND{=} 'except' exprList ':' stmt
                       | IND{=} 'else' ':' stmt )*
exprStmt = simpleExpr
         (( '=' optInd expr colonBody? )
         / ( expr ^+ comma
             doBlocks
              / macroColon
           ))?
importStmt = 'import' optInd expr
              ((comma expr)*
              / 'except' optInd (expr ^+ comma))
includeStmt = 'include' optInd expr ^+ comma
fromStmt = 'from' moduleName 'import' optInd expr (comma expr)*
returnStmt = 'return' optInd expr?
raiseStmt = 'raise' optInd expr?
yieldStmt = 'yield' optInd expr?
discardStmt = 'discard' optInd expr?
breakStmt = 'break' optInd expr?
continueStmt = 'break' optInd expr?
condStmt = expr colcom stmt COMMENT?
           (IND{=} 'elif' expr colcom stmt)*
           (IND{=} 'else' colcom stmt)?
ifStmt = 'if' condStmt
whenStmt = 'when' condStmt
whileStmt = 'while' expr colcom stmt
ofBranch = 'of' exprList colcom stmt
ofBranches = ofBranch (IND{=} ofBranch)*
                      (IND{=} 'elif' expr colcom stmt)*
                      (IND{=} 'else' colcom stmt)?
caseStmt = 'case' expr ':'? COMMENT?
            (IND{>} ofBranches DED
            | IND{=} ofBranches)
tryStmt = 'try' colcom stmt &(IND{=}? 'except'|'finally')
           (IND{=}? 'except' exprList colcom stmt)*
           (IND{=}? 'finally' colcom stmt)?
tryExpr = 'try' colcom stmt &(optInd 'except'|'finally')
           (optInd 'except' exprList colcom stmt)*
           (optInd 'finally' colcom stmt)?
exceptBlock = 'except' colcom stmt
forStmt = 'for' (identWithPragma ^+ comma) 'in' expr colcom stmt
blockStmt = 'block' symbol? colcom stmt
staticStmt = 'static' colcom stmt
deferStmt = 'defer' colcom stmt
asmStmt = 'asm' pragma? (STR_LIT | RSTR_LIT | TRIPLE_STR_LIT)
genericParam = symbol (comma symbol)* (colon expr)? ('=' optInd expr)?
genericParamList = '[' optInd
  genericParam ^* (comma/semicolon) optPar ']'
pattern = '{' stmt '}'
indAndComment = (IND{>} COMMENT)? | COMMENT?
routine = optInd identVis pattern? genericParamList?
  paramListColon pragma? ('=' COMMENT? stmt)? indAndComment
commentStmt = COMMENT
section(p) = COMMENT? p / (IND{>} (p / COMMENT)^+IND{=} DED)
constant = identWithPragma (colon typedesc)? '=' optInd expr indAndComment
enum = 'enum' optInd (symbol optInd ('=' optInd expr COMMENT?)? comma?)+
objectWhen = 'when' expr colcom objectPart COMMENT?
            ('elif' expr colcom objectPart COMMENT?)*
            ('else' colcom objectPart COMMENT?)?
objectBranch = 'of' exprList colcom objectPart
objectBranches = objectBranch (IND{=} objectBranch)*
                      (IND{=} 'elif' expr colcom objectPart)*
                      (IND{=} 'else' colcom objectPart)?
objectCase = 'case' identWithPragma ':' typeDesc ':'? COMMENT?
            (IND{>} objectBranches DED
            | IND{=} objectBranches)
objectPart = IND{>} objectPart^+IND{=} DED
           / objectWhen / objectCase / 'nil' / 'discard' / declColonEquals
object = 'object' pragma? ('of' typeDesc)? COMMENT? objectPart
typeClassParam = ('var' | 'out')? symbol
typeClass = typeClassParam ^* ',' (pragma)? ('of' typeDesc ^* ',')?
              &IND{>} stmt
typeDef = identWithPragmaDot genericParamList? '=' optInd typeDefAux
            indAndComment?
varTuple = '(' optInd identWithPragma ^+ comma optPar ')' '=' optInd expr
colonBody = colcom stmt doBlocks?
variable = (varTuple / identColonEquals) colonBody? indAndComment
bindStmt = 'bind' optInd qualifiedIdent ^+ comma
mixinStmt = 'mixin' optInd qualifiedIdent ^+ comma
pragmaStmt = pragma (':' COMMENT? stmt)?
simpleStmt = ((returnStmt | raiseStmt | yieldStmt | discardStmt | breakStmt
           | continueStmt | pragmaStmt | importStmt | exportStmt | fromStmt
           | includeStmt | commentStmt) / exprStmt) COMMENT?
complexOrSimpleStmt = (ifStmt | whenStmt | whileStmt
                    | tryStmt | forStmt
                    | blockStmt | staticStmt | deferStmt | asmStmt
                    | 'proc' routine
                    | 'method' routine
                    | 'iterator' routine
                    | 'macro' routine
                    | 'template' routine
                    | 'converter' routine
                    | 'type' section(typeDef)
                    | 'const' section(constant)
                    | ('let' | 'var' | 'using') section(variable)
                    | bindStmt | mixinStmt)
                    / simpleStmt
stmt = (IND{>} complexOrSimpleStmt^+(IND{=} / ';') DED)
     / simpleStmt ^+ ';'

