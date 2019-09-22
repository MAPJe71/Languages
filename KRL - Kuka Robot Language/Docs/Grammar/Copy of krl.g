/*
    This file is the grammar for the KUKA Robot Language.
    Copyright (C) 2010-2011  Jan Schlößin
*/

(?'LINE_COMMENT';[^\r\n]*)

(?'module'
  (?:
    (?'moduleData'
      (?i:DEFDAT)
      (?'IDENTIFIER'                                                            # moduleName
        \b(?!(?i:
            AN(?:D|IN|OUT)
          | B(?:OOL|RAKE|_(?:AND|EXOR|NOT|OR))
          | C(?:ASE|AST_(?:FROM|TO)|HAR|IRC(?:_REL)?|ON(?:ST|TINUE)|_(?:DIS|ORI|PTP|VEL))
          | D(?:ECL|EF(?:AULT|DAT|FCT)|ELAY|O)
          | E(?:LSE|ND(?:DAT|FCT|FOR|IF|LOOP|SWITCH|WHILE)?|NUM|X(?:IT|OR|T(?:FCT)?))
          | F(?:ALSE|OR)
          | G(?:LOBAL|OTO)
          | HALT
          | I(?:[FS]|MPORT|NT(?:ERRUPT)?)
          | L(?:IN(?:_REL)?|OOP)
          | M(?:AXI|INI)MUM
          | NOT
          | OR
          | P(?:RIO|TP(?:_REL)?|UBLIC)
          | RE(?:AL|PEAT|SUME|TURN)
          | S(?:EC|IGNAL|TRUC|WITCH)
          | T(?:HEN|O|RIGGER|RUE)
          | UNTIL
          | W(?:AIT|HEN|HILE)
        )\b)
        [$A-Z_a-z\x7F-\xFF][$\w\x7F-\xFF]*
      )
      (?i:PUBLIC)?
      (?'NEWLINE'\r?\n|\r)
      (?s:.*?)                                                                  # dataList
      (?i:ENDDAT)
      (?&NEWLINE)*
    )
  |
    (?'moduleRoutines'
      (?:
        (?'procedureDefinition'
          (?i:GLOBAL)?
          #-----
          (?i:DEF)
          #-----
          (?&IDENTIFIER)                                                        # procedureName
          (?'formalParameters'
            \(
            (?:
              (?'parameter'
                (?'variableName'
                  (?&IDENTIFIER)
                  (?'arrayVariableSuffix'                                       # expression in arrays are optional: a string literal can be assigned to a char array as a whole
                    \[
                    (?:
                      (?'expression'
                        (?'conditionalOrExpression'
                          (?'exclusiveOrExpression'
                            (?'conditionalAndExpression'
                              (?'additiveExpression'
                                (?'multiplicativeExpression'
                                  (?'geometricExpression'
                                    (?'unaryNotExpression'
                                      (?:B_)?NOT
                                      (?&unaryNotExpression)
                                    |
                                      (?'unaryPlusMinuxExpression'
                                        [+-]
                                        (?&unaryPlusMinuxExpression)
                                      |
                                        (?'primary'
                                          \(                                    # parExpression
                                          (?&assignmentExpression)
                                          \)      
                                        |
                                          (?&variableName)
                                          (?:
                                            \.
                                            (?&variableName)
                                          )*
                                          (?'arguments'
                                            \(
                                            (?'expressionList'
                                              (?'assignmentExpression'
                                                (?&expression)
                                                (?:
                                                  =
                                                  (?&expression)
                                                )*
                                              )
                                              (?:
                                                ,
                                                (?&assignmentExpression)
                                              )*
                                            )?
                                            \)
                                          )?
                                        |
                                          (?'literal'
                                            (?'INTLITERAL'
                                              \d+
                                            | \x27
                                              (?:
                                                H[0-9A-Fa-f]+
                                              | B[01]+
                                              )
                                              \x27
                                            )
                                          |
                                            (?'FLOATLITERAL'
                                              (?:
                                                \d+(?:\.\d*)?
                                              |       \.\d+  
                                              )
                                              (?:E[+-]?\d+)?
                                            )
                                          |
                                            (?'CHARLITERAL'
                                              \x27
                                              (?:
                                                (?'EscapeSequence'
                                                  \x5C
                                                  (?:
                                                    [\x22\x27\x5Cbfnrt]
                                                  | [0-3]?[0-7]{1,2}
                                                  )
                                                )
                                              | [^\r\n\x27\x5C]
                                              ) 
                                              \x27
                                            )
                                          |
                                            (?'STRINGLITERAL'
                                              \x22
                                              (?:
                                                (?&EscapeSequence)
                                              | [^\r\n\x22\x5C]
                                              )*
                                              \x22
                                            )
                                          |
                                            (?:                                 # structLiteral
                                              \{
                                              (?:
                                                (?&IDENTIFIER)                  # typeName
                                                :
                                              )?
                                              (?:                               # structElementList
                                                (?'structElement'
                                                  (?&variableName)
                                                  (?&unaryPlusMinuxExpression)
                                                )
                                                (?:
                                                  ,
                                                  (?&structElement)
                                                )*
                                              )
                                              \}
                                            )
                                          |
                                            TRUE
                                          |
                                            FALSE
                                          |
                                            \#(?&IDENTIFIER)                    # enumElement
                                          )
                                        )
                                      )
                                    )
                                    (?:
                                      :
                                      (?&unaryNotExpression)
                                    )*
                                  )
                                  (?:
                                    [*/]
                                    (?&geometricExpression)
                                  )*
                                )
                                (?:
                                  [+-]
                                  (?&multiplicativeExpression)
                                )*
                              )
                              (?:
                                (?:B_)?AND
                                (?&additiveExpression)
                              )*
                            )
                            (?:
                              (?:B_)?EXOR
                              (?&conditionalAndExpression)
                            )*
                          )
                          (?:
                            (?:B_)?OR
                            (?&exclusiveOrExpression)
                          )*
                        )
                        (?:
                          (?:==|<>|[<>]=?)
                          (?&conditionalOrExpression)
                        )*
                      )
                      (?:
                        ,
                        (?:
                          (?&expression)
                          (?:
                            ,
                            (?&expression)?
                          )?
                        )?
                      )?
                    )?
                    \]
                  )?
                )
                (?'parameterCallType'
                  :
                  (?i:IN|OUT)?
                  (?&IDENTIFIER)
                )?
              )
              (?:,(?&parameter))*
            )?
            \)
          )
          (?&NEWLINE)
          (?s:.*?)                                                              # routineBody
          #-----
          END
        )
      |
        (?'functionDefinition'
          (?i:GLOBAL)?
          #-----
          (?i:DEFFCT)
          (?'type'
            (?:
              (?-i:BOOL|CHAR|INT|REAL)                                          # primitiveType
            |
              (?&IDENTIFIER)                                                    # typeName
            )
            (?:
              \[
              (?&INTLITERAL)?
              \]
            )?
          )
          #-----
          (?&IDENTIFIER)                                                        # functionName
          (?&formalParameters)
          (?&NEWLINE)
          (?s:.*?)                                                              # routineBody
          #-----
          ENDFCT
        )
      )
      (?:
        (?&procedureDefinition)
      |
        (?&functionDefinition)
      |
        (?&NEWLINE)
      )*
    )
  )
  \Z                                                                            # EOF
)

    



