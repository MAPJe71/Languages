REM ----------------------------------------------------------------------------

' ######################## problematic test start

'sub 1precedingDigit_NOTVISIBLE_1()
'
'end sub
'
'sub 222precedingDigit_NOTVISIBLE_2()
'
'end sub

    REM ' should be visible:
    Declare Function DeclareTest_5 Lib "user32" Alias "DrawStateA" _
        (ByVal hdc As Long, _
        ByVal fuFlags As Long) As Long
    REM ' 3 not should be visible, at least not as empty nodes in list:
    Declare Function DeclareTest_APINOTVISIBLE_1 'Lib "KGB" Alias "SWR" (ByVal hdc As Long) As Long ' Declare Function DeclareTest_APINOTVISIBLE_3 Lib "gdi32" (ByVal hdc As Long) As Long
    Declare Function DeclareTest_APINOTVISIBLE_2 Lib "'JointSituationCenter" Alias "EU" (ByVal h1 As Long, ByVal h2 As Long, l3 As Any) As Long
    Private Declare Function DeclareTest_APINOTVISIBLE_3 Lib "BND" Alias "REM Noob" (ByVal h1 As Long, ByVal h2 As Long, l3 As Any) As Long

Public Property Get a() As b
    Attribute a.VB_Description = "Returns/sets the background color of the grid."
    a = c.a
End Property

Public Property Let a(ByVal c As b)
    a() = c
    PropertyChanged "a"
End Property

Public Property Let aa()
    Dim bb As Long
    bb = cc("dd", ByVal 0&, ByVal 0&, ByVal 0&)
End Property

Public Property Get "SystemColorDepth_3_NOTVISIBLE " ()
    Dim a As Long
    a = b("v", ByVal 0&, ByVal 0&, ByVal 0&)
    d = e(f, g)
End Property

Public Function a(
        ByVal b As String,
        ByVal c As d,
        Optional ByVal e As String,
        Optional ByVal f As Boolean = False,
        Optional ByVal g As Variant,
        Optional ByVal h As Long _
    ) As Long

    PropertyChanged "Images"
    PropertyChanged "Size"
    PropertyChanged "Keys"
End Function

public sub subtest_2_ _
    (byval subarray) as sometypearray()

end sub

' ######################## problematic test end

REM ----------------------------------------------------------------------------

Class MyClass

Sub mySubOfMyClass()

End Sub

Private Function myPrivateFunctionOfMyClass () as Long

End Function

End Class

Class HowToShowTheClass ' Class Declaration

    Public Sub HowToShowThisSubWithinTheClass_1         (213 as as) as aaaaaaa

    End Sub
    
    Public Function HowToShowThisFunctionWithinTheClass_2 (213 as as) as aaaaaaa

    End Function
End Class

Type HowToShowTheType 'which is a struct, no sub or function allowed
   lOne As Long
   lTwo As Long
   lArr() As Long
   'notthisone As Long
End Type

REM -- Additonal Test cases --

Class Class2' Trailing line comment

    Property Class2_Property_1 ()
    End Property

    Property Get Class2_PropertyGet_2()
    End Property

    Property Set Class2_PropertySet_3()
    End Property

' Class2_Sub1 header
Sub Class2_Sub1()' Trailing line comment

End Sub ' End of Class2_Sub1

    ' Class2_Sub2 header
    Sub Class2_Sub2() ' Trailing line comment

    End Sub ' End of Class2_Sub2

' Class2_Sub3 header
Sub Class2_Sub3()

End Sub ' End of Class2_Sub3

    ' Class2_Sub4 header
    Sub Class2_Sub4()

    End Sub ' End of Class2_Sub4

' Class2_Sub5 header
Sub Class2_Sub5(
    arg1,
    arg2,
    arg3 )

End Sub ' End of Class2_Sub5

    ' Class2_Sub6 header
    Sub Class2_Sub6(
        arg1,
        arg2,
        arg3 )

    End Sub ' End of Class2_Sub6

' Class2_PrivateFunction1 header
Private Function Class2_PrivateFunction1 () as Long' Trailing line comment

End Function ' End of Class2_PrivateFunction1

    ' Class2_PrivateFunction2 header
    Private Function Class2_PrivateFunction2 () as Long ' Trailing line comment

    End Function ' End of Class2_PrivateFunction2

End Class ' End of Class2

REM - Comment lines begin with an apostrophe (') or with Rem followed by a space, 
REM - and can be added anywhere in a procedure. To add a comment to the same line 
REM - as a statement, insert an apostrophe after the statement, followed by 
REM - the comment.

REM Remark uppercase
 REM Remark uppercase after 1 space
  REM Remark uppercase after 2 spaces
   REM Remark uppercase after 3 spaces
    REM Remark uppercase after 4 spaces
	REM Remark uppercase after 1 tab
		REM Remark uppercase after 2 tabs
			REM Remark uppercase after 3 tabs
				REM Remark uppercase after 4 tabs

rem Remark lowercase lowercase
 rem Remark lowercase after 1 space
  rem Remark lowercase after 2 spaces
   rem Remark lowercase after 3 spaces
    rem Remark lowercase after 4 spaces
	rem Remark lowercase after 1 tab
		rem Remark lowercase after 2 tabs
			rem Remark lowercase after 3 tabs
				rem Remark lowercase after 4 tabs

'Comment
' Comment
 ' Comment after 1 space
  ' Comment after 2 spaces
   ' Comment after 3 spaces
    ' Comment after 4 spaces
	' Comment after 1 tab
		' Comment after 2 tabs
			' Ccomment after 3 tabs
				' Ccomment after 4 tabs

REM Lines w/ a comment indicator w/o comment
REM
 REM
  REM
   REM
    REM
	REM
		REM
			REM
				REM
rem
 rem
  rem
   rem
    rem
	rem
		rem
			rem
				rem
'
 '
  '
   '
    '
	'
		'
			'
				'

REM ----------------------------------------------- Sub Procedure declaration --
rem -
rem - Sub subname_ ( [ arguments ] )
rem -   statements
rem - End Sub
Sub SubProcedureName_NoArgs ()
    ' statements
End Sub

rem
Sub SubProcedureName ( Argument As Object )
    ' statements
End Sub

REM ---------------------------------------------------- Function declaration --
rem - 
rem - Function functionname ( [ arguments ] ) As Type
rem -   statements
rem - End Function
rem -----
Function FunctionName_NoArgs () As Type
    ' statements
End Function

rem
Function FunctionName ( Argument As Object ) As Type
    ' statements
End Function

REM ---------------------------------------------------- Property declaration --
rem -
rem - [Public | Private] [Static] Property {Get | Let | Set} propertyname_ [(arguments)] [As type]
rem -   statements
rem - End Property 
rem -----
Property Let PropertyName_Let_NoArgs ()
    ' statements
End Property

rem
Static Property Let StaticPropertyName_Let_NoArgs ()
    ' statements
End Property

rem
Property Let PropertyName_Let ( Arguments As Object )
    ' statements
End Property

rem
Static Property Let StaticPropertyName_Let ( Arguments As Object )
    ' statements
End Property

rem
Public Property Let PublicPropertyName_Let ( Arguments As Object )
    ' statements
End Property

rem
Public Static Property Let PublicStaticPropertyName_Let ( Arguments As Object )
    ' statements
End Property

rem
Private Property Let PrivatePropertyName_Let ( Arguments As Object )
    ' statements
End Property

rem
Private Static Property Let PrivateStaticPropertyName_Let ( Arguments As Object )
    ' statements
End Property

rem -----
Property Get PropertyName_Get_NoArgs ()
    ' statements
End Property

rem
Static Property Get StaticPropertyName_Get_NoArgs ()
    ' statements
End Property

rem
Property Get PropertyName_Get ( Arguments As Object )
    ' statements
End Property

rem
Static Property Get StaticPropertyName_Get ( Arguments As Object )
    ' statements
End Property

rem
Public Property Get PublicPropertyName_Get ( Arguments As Object )
    ' statements
End Property

rem
Public Static Property Get PublicStaticPropertyName_Get ( Arguments As Object )
    ' statements
End Property

rem
Private Property Get PrivatePropertyName_Get ( Arguments As Object )
    ' statements
End Property

rem
Private Static Property Get PrivateStaticPropertyName_Get ( Arguments As Object )
    ' statements
End Property

rem -----
Property Set PropertyName_Set_NoArgs ()
    ' statements
End Property

rem
Static Property Set StaticPropertyName_Set_NoArgs ()
    ' statements
End Property

rem
Property Set PropertyName_Set ( Arguments As Object )
    ' statements
End Property

rem
Static Property Set StaticPropertyName_Set ( Arguments As Object )
    ' statements
End Property

rem
Public Property Set PublicPropertyName_Set ( Arguments As Object )
    ' statements
End Property

rem
Public Static Property Set PublicStaticPropertyName_Set ( Arguments As Object )
    ' statements
End Property

rem
Private Property Set PrivatePropertyName_Set ( Arguments As Object )
    ' statements
End Property

rem
Private Static Property Set PrivateStaticPropertyName_Set ( Arguments As Object )
    ' statements
End Property

REM ----------------------------------------------------------------------------
REM -- End of File --