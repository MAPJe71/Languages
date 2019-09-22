'VB (.NET|Script|for Applictions) Parser-Test File

Public Class HowToShowTheClass
	Public Sub HowToShowThisSubWithinTheClass_1 		(213 as as) as aaaaaaa

	end sub
	Public Sub HowToShowThisFunctionWithinTheClass_2 (213 as as) as aaaaaaa

	end sub
end class


Type ShowThisAsStructAsSoonAsFunctionListIsAwareofThem 'which is a struct, no sub or function allowd
	
   lOne As Long
   lTwo As Long
   lArr() As Long
   'notthisone As Long
End Type

' REM ' Sub not fucntion visible
' ************* SUB AND FUNCTION TEST
sub _precedingUScore_1()
end sub

sub _1precedingUSscore_2()
end sub

sub 1precedingDigit_NOTVISIBLE_1()
end sub

sub 222precedingDigit_NOTVISIBLE_2()
end sub

sub testsub_1(byaval subarray)

end sub

public sub subtest_2(byaval subarray) as sometypearry()

end sub
	sub 	testsub_3(byaval subarray)

	end sub

	sub subtest_sub_4(byaval subarray)

	end sub

function testfunction_5(byaval functionarray)

end function

function functiontest_6(byaval functionarray)

end function
	private   function 				testfunction_7 	 	 	           (byaval functionarray)

	end function

	function functiontest_function_8(byaval functionarray) as sometypearry()

	end function

	private function TestFunction_9()  as sometypearry() 'sub testNOTVISIBLE_3()
	
private function TestFunction_10(ByWhatever Varname as Whocares)  as sometypearry() ' sub testNOTVISIBLE_4()

	private function TestFunction_11()  as sometypearry() REMsub testNOTVISIBLE_5()
	
	private function TestFunction_12(ByWhatever Varname as Whocares)  as sometypearry() REM sub testNOTVISIBLE_6()
	
	private function remTestFunction_13(ByWhatever Varname as Whocares, _
			ByWhatever Varname as Whocares _
		)  as sometypearry() REMrem	 sub testNOTVISIBLEbutNoComment_7()
	
	
' ************* SUB AND FUNCTION TEST 2

	Public Sub Test2_No1 (ByVal TextValue As String)
        'will append to file specified by filename property.
        'if that file is invalid, will write to a default file
        Dim sFileName As String
        Dim objWriter As StreamWriter
        const test123 as integer
		
    End Sub

Public Sub Test2_No2 (ByVal TextValue As String)
'some comment rem ' some comment rem ' some comment rem ' 
Dim sFileName As String
Dim objWriter As StreamWriter

End Sub

'some comment rem ' 
Public Sub Test2_No3 (ByVal TextValue As String)
'some comment rem ' some comment rem ' some comment rem ' 'some comment rem ' 
'some comment rem ' 
Dim sFileName As String
Dim objWriter As StreamWriter

End Sub

Public Sub Test2_No4 (ByVal TextValue As String)
Dim sFileName As String
Dim objWriter As StreamWriter

End Sub


Public Property Get PropTest3_No1() As whatever ' 123
Attribute aaa.bbb = "xxxxxxxxxxxxxxxxxxremxxxxxxxx"
'123
 Dim lR As Long 
End Property

			Rem rem
			Property Let PropTest3_No1() REM HU-HA
			rem ' remm
			Attribute aaa.bbb = "xxxxxxxxxxxx ' xxxxxxxxxxxxxx"
			Dim lR As Long 
			End Property


	Public Property Get PropTest3_No2() As whatever ' 123
						'123
								Dim lR As Long 
														   End Property

	Rem rem
	Private Property Let PropTest3_No2() REM HU-HA
	rem ' remm
	Attribute aaa.bbb = "xxxxxxxxxxxx ' xxxxxxxxxxxxxx"
	Dim lR As Long 
	End Property

ReadOnly Property PropTest3_No4() As Integer 
        Get 
            Return p_CustomerID
        End Get 
    End Property 

' TEST declare object functions:
Declare Function DeclareTest_1 Lib "NSA_CIA" (ByVal h1 As Long, ByVal h2 As Long) As Long
Public Declare Function DeclareTest_2 Lib "MI6.dll" (ByVal h1 As Long) As 'comment
Public Declare Function DeclareTest_3 Lib "qwerty" ALiaS "asdfgh" (ByVal h1 As Long) As 'comment
		       Public Declare UNICODE Function DeclareTest_4 Lib "qwerty" ALiaS "asdfgh" (ByVal h1 As Long) As dontcare		'	REM		comment
		REM ' should be visible:
		Declare Function DeclareTest_5 Lib "user32" Alias "DrawStateA" _
			(ByVal hdc As Long, _
			ByVal fuFlags As Long) As Long
		REM ' 3 not should be visible, at least not as empty nodes in list:
		Declare Function DeclareTest_APINOTVISIBLE_1 'Lib "KGB" Alias "SWR" (ByVal hdc As Long) As Long ' Declare Function DeclareTest_APINOTVISIBLE_3 Lib "gdi32" (ByVal hdc As Long) As Long
		Declare Function DeclareTest_APINOTVISIBLE_2 Lib "'JointSituationCenter" Alias "EU" (ByVal h1 As Long, ByVal h2 As Long, l3 As Any) As Long
		Private Declare Function DeclareTest_APINOTVISIBLE_3 Lib "BND" Alias "REM Noob" (ByVal h1 As Long, ByVal h2 As Long, l3 As Any) As Long
rem 


	
REM -- Additonal Test cases --

' http://support.microsoft.com/kb/307222/de
Public Class overrideMeClass
Private Name As String       ' Only accessible in base class
Protected Balance As Double  ' Accessible in base class and derived class
Public MustOverride Function CalculateBankCharge() As Double

Public Sub New1of4(ByVal Nm As String, ByVal Bal As Double)
   Name = Nm
   Balance = Bal
End Sub 

Public Overridable Sub Credit2of4(ByVal Amount As Double)
   Balance += Amount
End Sub
Public Overridable Sub Debit3of4(ByVal Amount As Double)
   Balance -= Amount
End Sub

Public Overridable Sub Display4of4()
   Console.WriteLine("Name=" & Name & ", " & "Balance=" & Balance)
End Sub
End Class

Public Class overridingClass 
   Inherits Account
   Private MinBalance As Double
   Public Sub New1of4(ByVal Nm  As String, _
               ByVal Bal As Double, _
               ByVal Min As Double)
   MyBase.New(Nm, Bal)        ' Call base-class constructor first
   MinBalance = Min           ' Then initialize fields in this class
End Sub
Public Overrides Sub Debit2of4(Amount As Double)
   If Amount <= Balance Then  ' Use balance, inherited from base class
      MyBase.Debit(Amount)    ' Call Debit, inherited from base class
   End If
End Sub

Public Overrides Sub Display3of4()
   MyBase.Display()           ' Call Display, inherited from base class
   Console.WriteLine("$5 charge if balance goes below $" & MinBalance)
End Sub
Public Overrides Function CalculateBankCharge4of4() As Double
   If Balance < MinBalance Then
      Return 5.0
   Else
      Return 0.0
   End If
End Function

End Class



'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=iGrid,iGrid,-1,BackColor
Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_Description = "Returns/sets the background color of the grid."
    BackColor = iGrid.BackColor
End Property

Public Property Let BackColor(ByVal New_BackColor As OLE_COLOR)
    iGrid.BackColor() = New_BackColor
    PropertyChanged "BackColor"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=iGrid,iGrid,-1,ForeColor
Public Property Get ForeColor() As OLE_COLOR
Attribute ForeColor.VB_Description = "Returns/sets the default color used to draw iGrid cell text."
    ForeColor = iGrid.ForeColor
End Property

Public Property Let ForeColor(ByVal New_ForeColor As OLE_COLOR)
    iGrid.ForeColor() = New_ForeColor
    PropertyChanged "ForeColor"
End Property

Public Property Let SystemColorDepth_2()
Dim lHDC As Long
   lHDC = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
End Property

Public Property Get "SystemColorDepth_3" ()
Dim lHDC As Long
   lHDC = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
   lR = GetDeviceCaps(lHDC, BITSPIXEL)
End Property

' http://msdn.microsoft.com/en-us/library/10kws135.aspx
Public class shadowBaseClass
   Public readonly Sub displayOnly1()
        MsgBox("This is thirdClass")
    End Sub
End Class
Public Class shadowDerivedClass
    Inherits shadowBaseClass
       Public Shadows Sub displayOnly1()
        MsgBox("This is thirdClass")
    End Sub
End Class
Friend Class friendlySharerClass
    Private Shared Function GetParentUserControl1_of2(ByVal ctl As Control) As UserControl
		'blah	
    End Function
    Friend Shared Sub WireUpHandlers_2of2(ByVal ctl As Control, ByVal ValidationHandler As EventHandler)
		'blah	
    End Sub
end class

' http://msdn.microsoft.com/en-us/library/08w05ey2.aspx
Class CustomerInfo

    Public ReadOnly Property CustomerInfo_1() As Integer 
        Get 
            Return p_CustomerID
        End Get 
    End Property 
    ' Allow friend access to the empty constructor. 
    Friend Sub NewCustomerInfo_2()

    End Sub 
    ' Require that a customer identifier be specified for the public constructor. 
    Public Sub NewCustomerInfo_3(ByVal customerID As Integer)
        p_CustomerID = customerID
    End Sub 
    ' Allow friend programming elements to set the customer identifier. 
    Friend Sub CustomerInfo_4(ByVal customerID As Integer) ' REM
        p_CustomerID = customerID
    End Sub 
    Shared Function CustomerInfo_5of5(ByVal tm As tm) As Boolean
        Dim i As Integer
    End Function
End Class


Class Class2 ' Trailing line comment
    public Shared Function Shared3Func(ByVal tm As tm) As Boolean
        Dim i As Integer       
    End Function
	

' Class2Sub1NOTVISIBLE header
Sub Class2Sub1() ' Trailing line comment

End Sub ' End of Class2Sub1NOTVISIBLE

    ' Class2Sub2NOTVISIBLEsub header
    Sub Class2Sub2() ' Trailing line comment

    End Sub ' End of Class2Sub2

' Class2Sub3 header
Sub Class2Sub3()

End Sub ' End of Class2Sub3

    ' Class2Sub4 header
    Sub Class2Sub4()

    End Sub ' End of Class2Sub4

' Class2PrivateFunction1 header
Private Function Class2PrivateFunction1 () as Long' Trailing line comment

End Function ' End of Class2PrivateFunction1

    ' Class2PrivateFunction2 header
    Private Function Class2PrivateFunction2 () as Long ' Trailing line comment

    End Function ' End Function :  Class2PrivateFunction2
	Private Property Let PropTest3_No2() REM HU-HA
	rem ' remm
	Attribute aaa.bbb = "xxxxxxxxxxxx ' xxxxxxxxxxxxxx"
	Dim lR As Long 
	End Property

    Property Class2_Property_1 ()
    End Property

    Property READONLY Get Class2_PropertyGet_2()
    End Property

	    Property Set Class2_PropertySet_3()
    End Property

	    Public ReadOnly Property Class2_PropertySet_4() As Integer 
        Get 
            Return p_CustomerID
        End Get 
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
Sub Class2_Sub5 _
	(
    arg1,
    arg2,
    arg3 )

End Sub ' End of Class2_Sub5

    ' Class2_Sub6 header
    Sub Class2_Sub6  (
        arg1,
        arg2,
        arg3 )

    End Sub ' End of Class2_Sub6

	
		
	Private Declare Function AUTO DeclareTest_0 Lib "LibName" (ByVal h1 As Long) As 'comment

	
	
End Class ' End of Class2



Public MustInherit Class Class_3
    Inherits OtherClass
  
    Sub New(ByVal a As b)
        MyBase.New(a)
    End Sub

    Public Overrides Function OvFunc_1() As Boolean
        Dim result As Boolean = True
		' public override REM funcion
	 Debug.Trace(" test test test")
    End Function
  
    Friend Overrides Function OvFunc_2(ByVal a As b) As Boolean
        Dim result As Boolean = True
        Debug.Assert(() () ())

        If Me.GeneratedCode = False Then
            'Lorem ipsum dolor sit amet
            'Lorem ipsum dolor sit amet
            'Lorem ipsum dolor sit amet
            'Lorem ipsum dolor sit amet
            a = b(a) AndAlso a
        End If

        Return result
    End Function

    Protected MustOverride Sub MusOvSub_1(ByVal a As b)
    Protected MustOverride Sub MusOvSub_2(ByVal a As b)

End Class

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

REM -- End of File --


