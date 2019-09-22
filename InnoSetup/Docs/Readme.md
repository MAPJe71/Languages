
# InnoSetup

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
[Inno Setup] -------------------------------------------------------------------
@=Inno Setup

_WWW_=http://www.jrsoftware.org/

_Wiki_=

Keywords=

   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=

StringLiterals=

Comment=

   Comments may be embedded in expression by using a slash and an asterisk.
   For example:

       #emit Var1 /* this is a comment */ + Var2 /* this is a comment */

   Also one line comments are supported. Those comments must begin with a
   semicolon. Whole text after the semicolon up to the end of a line is
   considered comment.

       #emit Var1 + Var2 ; this is a comment

   Please note that line spanning feature is triggered before any further
   processing, thus a comment may occupy more than one line:

       #emit Var1 + Var2 ; this is \
           a comment

Classes_and_Methods=

   Section 'Code'  --> Class
   Function        --> Method
   Procedure       --> Method

   [Code]
   const
       ConstName = ConstValue;
   type
       TypeName = [ record | interface(IUnknown) ]
       end;
   var
       VarName : VarType;

   function FunctionName( FunctionArgs ) : ReturnType;
   var
       VarName : VarType;
   begin
   end;

   procedure ProcedureName( ProcedureArgs );
   var
       VarName : VarType;
   begin
   end;

Function=

   Section not named 'Code'    --> Function
   Macro                       --> Function


   #define MacroName( MacroArgs )

   [-]---  ParserTest.iss
        +----  MacroName
        +----  Components
        +----  CustomMessages
        +----  Dirs
        +----  Files
        +----  Icons
        +----  InstallDelete
        +----  Languages
        +----  Messages
        +----  Registry
        +----  Run
        +----  Setup
        +----  Tasks
        +----  Types
        +----  UninstallDelete
        +----  UninstallRun
       [-]---  Code
            +----  FunctionName( FunctionArgs ) : ReturnType
            \----  ProcedureName( ProcedureArgs )

   [Components] | [CustomMessages] | [Dirs] | [Files] | [Icons] | [InstallDelete]
                | [Languages] | [Messages] | [Registry] | [Run] | [Setup] | [Tasks]
                | [Types] | [UninstallDelete] | [UninstallRun] |

   (?-i:Co(?:mponents|de)|(?:Custom)?Messages|Dirs|Files|I(?:cons|nstallDelete)|Languages|R(?:egistry|un)|Setup|T(?:asks|ypes)|Uninstall(?:Delete|Run))

Grammar=

