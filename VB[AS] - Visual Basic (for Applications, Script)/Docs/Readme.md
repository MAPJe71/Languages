
# Visual Basic (.Net | for Applications | Script)

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
[Visual Basic (.NET|Script|for Applications)] ----------------------------------
@=Visual Basic (?:\.NET|Script|for Applications)

_WWW_=

_Wiki_=

Keywords=

       #Const #Else #ElseIf #End #If
       & &= * *= + += - -= / /= << <<= = >> >>= \ \= ^ ^=
       AddHandler AddressOf Alias And AndAlso As
       Boolean ByRef ByVal Byte
       CBool CByte CChar CDate CDbl CDec CInt CLng CObj CSByte CShort CSng CStr CType CUInt CULng CUShort Call Case Catch Char Class Const Continue
       Date Decimal Declare Default Delegate Dim DirectCast Do Double
       Each Else ElseIf End EndIf Enum Erase Error Event Exit
       False Finally For Friend Function
       Get GetType GetXMLNamespace Global GoSub GoTo
       Handles
       If If() Implements Imports In Inherits Integer Interface Is IsNot
       Let Lib Like Long Loop
       Me Mod Module MustInherit MustOverride MyBase MyClass
       Namespace Narrowing New Next Not NotInheritable NotOverridable Nothing
       Object Of On Operator Option Optional Or OrElse Overloads Overridable Overrides
       ParamArray Partial Private Property Protected Public
       REM RaiseEvent ReDim ReadOnly RemoveHandler Resume Return
       SByte Select Set Shadows Shared Short Single Static Step Stop String Structure Sub SyncLock Then Throw To True Try TryCast TypeOf
       UInteger ULong UShort Using
       Variant
       Wend When While Widening With WithEvents WriteOnly
       Xor

   Note:

       EndIf, GoSub, Variant, and Wend are retained as reserved keywords, although
       they are no longer used in Visual Basic. The meaning of the Let keyword has
       changed. Let is now used in LINQ queries. For more information, see Let
       Clause (Visual Basic).

   #ExternalSource  #Region
   Aggregate  Ansi  Assembly  Auto
   Binary
   Compare  Custom
   Distinct
   Equals  Explicit
   From
   Group By  Group Join
   Into  IsFalse  IsTrue
   Join
   Key
   Mid
   Off  Order By
   Preserve
   Skip  Skip While  Strict
   Take  Take While  Text
   Unicode  Until
   Where

       #Const  #Else  #ElseIf  #End  #If
       &  &=  *  *=  +  +=  -  -=  /  /=  <<  <<=  =  >>  >>=  \  \=  ^  ^=
       AddHandler  AddressOf  Alias  And  AndAlso  As
       Boolean  ByRef  ByVal  Byte
       CBool  CByte  CChar  CDate  CDbl  CDec  CInt  CLng  CObj  CSByte  CShort  CSng  CStr  CType  CUInt  CULng  CUShort  Call  Case  Catch  Char  Class Constraint  Class Statement  Const  Continue
       Date  Decimal  Declare  Default  Delegate  Dim  DirectCast  Do  Double
       Each  Else  ElseIf  End <keyword>  End Statement  EndIf  Enum  Erase  Error  Event  Exit
       False  Finally  For (in For…Next)  For Each…Next  Friend  Function
       Get  GetType  GetXMLNamespace  Global  GoSub  GoTo
       Handles
       If  If()  Implements  Implements Statement  Imports  In  Inherits  Integer  Interface  Is  IsNot
       Let  Lib  Like  Long  Loop
       Me  Mod  Module  Module Statement  MustInherit  MustOverride  MyBase  MyClass
       Namespace  Narrowing  New Constraint  New Operator  Next  Not  NotInheritable  NotOverridable  Nothing
       Object  Of  On  Operator  Option  Optional  Or  OrElse  Out  Overloads  Overridable  Overrides
       ParamArray  Partial  Private  Property  Protected  Public
       REM  RaiseEvent  ReDim  ReadOnly  RemoveHandler  Resume  Return
       SByte  Select  Set  Shadows  Shared  Short  Single  Static  Step  Stop  String  Structure Constraint  Structure Statement  Sub  SyncLock
       Then  Throw  To  True  Try  TryCast  TypeOf…Is
       UInteger  ULong  UShort  Using
       Variant
       Wend  When  While  Widening  With  WithEvents  WriteOnly
       Xor

   Note:

       EndIf, GoSub, Variant, and Wend are retained as reserved keywords, although
       they are no longer used in Visual Basic. The meaning of the Let keyword has
       changed. Let is now used in LINQ queries. For more information, see Let
       Clause (Visual Basic).

   VBScript Functions
       https://msdn.microsoft.com/en-us/library/3ca8tfek(v=vs.84).aspx

       Abs  Array  Asc  Atn
       CBool  CByte  CCur  CDate  CDbl  CInt  CLng  CSng  CStr  Chr  Conversions  Cos  CreateObject
       Date  DateAdd  DateDiff  DatePart  DateSerial  DateValue  Day
       Escape  Eval  Exp
       Filter  FormatCurrency  FormatDateTime  FormatNumber  FormatPercent
       GetLocale  GetObject  GetRef
       Hex  Hour
       InStr  InStrRev  InputBox  Int, Fix  IsArray  IsDate  IsEmpty  IsNull  IsNumeric  IsObject
       Join
       LBound  LCase  LTrim  Left  Len  LoadPicture  Log
       Maths  Mid  Minute  Month  MonthName  MsgBox
       Now
       Oct
       RGB  Replace  Right  Rnd  Round  RTrim
       ScriptEngine  ScriptEngineBuildVersion  ScriptEngineMajorVersion  ScriptEngineMinorVersion  Second  SetLocale  Sgn  Sin  Space  Split  Sqr  StrComp  StrReverse  String
       Tan  Time  TimeSerial  TimeValue  Timer  Trim  TypeName
       UBound  UCase  Unescape
       VarType
       Weekday  WeekdayName
       Year

   VBScript Keywords
       https://msdn.microsoft.com/en-us/library/f8tbc79x(v=vs.84).aspx

       Empty
       False
       Nothing
       Null
       True

   VBScript Methods
       https://msdn.microsoft.com/en-us/library/hkc375ea(v=vs.84).aspx

       Clear Method  Execute Method  Raise Method  Replace Method  Test Method  Write Method  WriteLine Method


   A RegEx to find them all:

       \b(?!(?-i:
       )\b)


   Sub Procedures

       A Sub procedure is a series of VBScript statements (enclosed by Sub and End
       Sub statements) that perform actions but don't return a value. A Sub
       procedure can take arguments (constants, variables, or expressions that are
       passed by a calling procedure).

       The following Sub procedure uses two intrinsic, or built-in, VBScript
       functions, MsgBox and InputBox, to prompt a user for information. It then
       displays the results of a calculation based on that information. The
       calculation is performed in a Function procedure created using VBScript.
       The Function procedure is shown after the following discussion.

           Sub ConvertTemp
              temp = InputBox("Please enter the temperature in degrees F.", 1)
              MsgBox "The temperature is " & Celsius(temp) & " degrees C."
           End Sub


   Function Procedures

       A Function procedure is a series of VBScript statements enclosed by the
       Function and End Function statements. A Function procedure is similar to a
       Sub procedure, but can also return a value. A Function procedure can take
       arguments (constants, variables, or expressions that are passed to it by a
       calling procedure). If a Function procedure has no arguments, its Function
       statement must include an empty set of parentheses. A Function returns a
       value by assigning a value to its name in one or more statements of the
       procedure. The return type of a Function is always a Variant.

       In the following example, the Celsius function calculates degrees Celsius
       from degrees Fahrenheit. When the function is called from the ConvertTemp
       Sub procedure, a variable containing the argument value is passed to the
       function. The result of the calculation is returned to the calling procedure
       and displayed in a message box.

           Sub ConvertTemp
              temp = InputBox("Please enter the temperature in degrees F.", 1)
              MsgBox "The temperature is " & Celsius(temp) & " degrees C."
           End Sub

           Function Celsius(fDegrees)
              Celsius = (fDegrees - 32) * 5 / 9
           End Function

       To call a Sub procedure from another procedure, type the name of the
       procedure along with values for any required arguments, each separated by a
       comma. The Call statement is not required, but if you do use it, you must
       enclose any arguments in parentheses.

       The following example shows two calls to the MyProc procedure. One uses the
       Call statement in the code; the other doesn't. Both do exactly the same
       thing.

           Call MyProc(firstarg, secondarg)
           MyProc firstarg, secondarg

       Notice that the parentheses are omitted in the call when the Call statement
       isn't used.


Identifiers=

StringLiterals=

Comment=

   The only truly standard method of marking a comment in BASIC is using the REM
   keyword. This dates back to (at least) the late 1970's, and should work with
   most BASICs available today:

       100 ' Standard BASIC comments begin with "REM" (remark) and extend to the end of the line
       110 PRINT "this is code": REM comment after statement


   Visual Basic .NET uses the "'" symbol or "REM" to mark it's comments. After
   placing a "'", or "REM", everything in that line will be ignored.

       ' This is a comment
       REM This is also a comment
       Dim comment as string ' You can also append comments to statements
       Dim comment2 as string REM You can append comments to statements

   VBScript Rem Statement

       Includes explanatory remarks in a program.

       Syntax

           Rem comment
           ' or
           ' comment

       Arguments

       The comment argument is the text of any comment you want to include. After
       the Rem keyword, a space is required before comment.

       Remarks

       As shown in the syntax section, you can use an apostrophe (') instead of
       the Rem keyword. If the Rem keyword follows other statements on a line, it
       must be separated from the statements by a colon. However, when you use an
       apostrophe, the colon is not required after other statements.

       The following example illustrates the use of the Rem statement.

           Dim MyStr1, MyStr2
           MyStr1 = "Hello" : Rem Comment after a statement separated by a colon.
           MyStr2 = "Goodbye" ' This is also a comment; no colon is needed.
           Rem Comment on a line with no code; no colon is needed.

Classes_and_Methods=

Function=

   VBA

       Defining a class

       In Visual Basic for Applications a class is defined in a separate Class Module.
       The name of the class module is the name of the class.

       For each property you must supply a "Property Let" routine to set the property
       (or "Property Set" if the property refers to an object), and a "Property Get"
       function to get the property. Methods are represented by Functions in the class
       module. A class module can have a constructor - a sub with the special name
       Class_Initialize - and a destructor with the special name Class_Terminate.

       This is the contents of a class module "Foo" (like in the Visual Basic .NET
       example below):

           Private Const m_default = 10
           Private m_bar As Integer

           Private Sub Class_Initialize()
             'constructor, can be used to set default values
             m_bar = m_default
           End Sub

           Private Sub Class_Terminate()
             'destructor, can be used to do some cleaning up
             'here we just print a message
             Debug.Print "---object destroyed---"
           End Sub
           Property Let Bar(value As Integer)
             m_bar = value
           End Property

           Property Get Bar() As Integer
             Bar = m_bar
           End Property

           Function DoubleBar()
             m_bar = m_bar * 2
           End Function

           Function MultiplyBar(x As Integer)
             'another method
             MultiplyBar = m_bar * x
             'Note: instead of using the instance variable m_bar we could refer to the Bar property of this object using the special word "Me":
             '  MultiplyBar = Me.Bar * x
           End Function


   VBScript

           function multiply( multiplicand, multiplier )
               multiply = multiplicand * multiplier
           end function

       Usage:

           dim twosquared
           twosquared = multiply(2, 2)



   Visual Basic .NET

           Function Multiply(ByVal a As Integer, ByVal b As Integer) As Integer
               Return a * b
           End Function

       Call the function

           Multiply(1, 1)

       Defining a class

           Class Foo
              Private m_Bar As Integer

              Public Sub New()

              End Sub

              Public Sub New(ByVal bar As Integer)
                  m_Bar = bar
              End Sub

              Public Property Bar() As Integer
                  Get
                      Return m_Bar
                  End Get
                  Set(ByVal value As Integer)
                      m_Bar = value
                  End Set
              End Property

              Public Sub DoubleBar()
                  m_Bar *= 2
              End Sub

              Public Function MultiplyBar(ByVal x As Integer) As Integer
                  Return x * Bar
              End Function

           End Class

Grammar=

