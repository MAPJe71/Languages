#AutoIt3Wrapper_Run_AU3Check=y
#AutoIt3Wrapper_AU3Check_Parameters=-w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7 -d

#include <Misc.au3>
#include <Array.au3>
#include <Constants.au3>

_Singleton(@ScriptName)

main()

#region ; UserCallTips Generator

Func main()
  Local $au3_api = AU3APItoArray(@ProgramFilesDir & "\AutoIt3\SciTE\api\au3.api")
 
  Switch @error
    Case False
      Write("'au3.api' exists and is within its proper directory.")
      
    Case True
      Return SetError(1, 0, False)
  EndSwitch

  $au3_api = DeleteNonFunctions($au3_api)
  $au3_api = ReplaceXMLKeyWords($au3_api)

  Local Const $func_names = GetFunctionNames($au3_api)
  Local Const $func_params = GetFunctionParams($au3_api)
  Local Const $func_descrs = GetFunctionDescr($au3_api)
  Local Const $FileOutPath = @ProgramFilesDir & "\Notepad++\plugins\APIs\autoit.xml" ; Change this to suit your needs.
  Local Const $file_write = FileOpen($FileOutPath, ($FO_OVERWRITE + $FO_CREATEPATH))

  Switch $file_write
    Case -1
      Write("There was an error opening: " & @CRLF & $FileOutPath)
      Return SetError(2, 0, False)
      
    Case Else
      Write($FileOutPath & ": was opened successfully." & @CRLF)
      FileWrite($file_write, OutputXMLDocument($func_names, $func_params, $func_descrs))
      FileClose($file_write)
  EndSwitch

  Return True
EndFunc

Func AU3APItoArray(Const $path)
  Local $FileInPath = $path

  Switch FileExists($FileInPath)
    Case 0
      Switch MsgBox($MB_YESNO, "Alert:", "'au3.api' does not seem to be within its default directory." & @LF & "Would you like to specify the current 'au3.api' directory?")
        Case $IDYES
          Local Const $result = FileOpenDialog("Browse to 'au3.api'", @DesktopDir, "API (*.api;)", 1 + 2)

          Switch $result
            Case ''
              Return SetError(1, 0, False)

            Case Else
              $FileInPath = $result
          EndSwitch

        Case $IDNO
          Return SetError(2, 0, False)
      EndSwitch
  EndSwitch

  Return FileReadToArray($FileInPath)
EndFunc

Func DeleteNonFunctions(Const $au3_api)
  Local $au3 = $au3_api
  Local Const $upBound = UBound($au3) - 1

  For $i = $upBound To 0 Step -1
    If Not StringInStr($au3[$i], '(') Then
      _ArrayDelete($AU3, $i)
    EndIf
  Next

  Return $au3
EndFunc

Func ReplaceXMLKeyWords(Const $au3_api) ; Replace reserved XML keywords with character entity references  
  Local Const $find[]    = [Chr(39)  , Chr(34)  , "<a id=" , "</a>" , '>' , '<'    , '>'   ]
  Local Const $replace[] = ["&apos;" , "&quot;" , ''       , ' '    , ''  , "&lt;" , "&gt;"]
  Local Const $keyword_count = UBound($find) - 1
  Local Const $upBound = UBound($au3_api) - 1
  Local $au3 = $au3_api

  For $i = 0 To $upBound
    For $j = 0 To $keyword_count
      $au3[$i] = StringRegExpReplace($au3[$i], '<a href="\w+.htm">', '')
      $au3[$i] = StringReplace($au3[$i], $find[$j], $replace[$j], 0, $STR_NOCASESENSEBASIC)
    Next
  Next

  Return $au3
EndFunc

Func GetFunctionNames(Const $au3_api)
  Local Const $upBound = UBound($au3_api) - 1
  Local $names[$upBound + 1]

  For $i = 0 To $upBound
    ; extract the name of the function
    ; EX: "Abs ( expression ) Calculates the absolute value of a number."
    $names[$i] = StringTrimRight($au3_api[$i], StringLen($au3_api[$i]) - ((StringInStr($au3_api[$i], ' ') - 1)))
    ; ==> "Abs"
  Next

  Return $names
EndFunc

Func GetFunctionParams(Const $au3_api)
  Local Const $upBound = UBound($au3_api) - 1
  Local $params[$upBound + 1]
  Local $lhs

  For $i = 0 To $upBound
    ; extract the function parameters
    ; EX: "Abs ( expression ) Calculates the absolute value of a number."
    $lhs = StringTrimRight($au3_api[$i], StringLen($au3_api[$i]) - StringInStr($au3_api[$i], ')') + 1)
    $params[$i] = StringTrimLeft($lhs, StringInStr($lhs, '(') + 1)
    ;ConsoleWrite('$params[$i] = ' & $params[$i] & @CRLF)
    ; ==> "expression"
  Next
 
  Return $params
EndFunc

Func GetFunctionDescr(Const $au3_api)
  Local Const $upBound = UBound($au3_api) - 1
  Local $descr[$upBound + 1]

  For $i = 0 To $upBound
    ; extract the function description
    ; EX: "Abs ( expression ) Calculates the absolute value of a number."
    $descr[$i] = StringTrimLeft($au3_api[$i],(StringInStr($au3_api[$i], ')') + 1))
    ; ==> "Calculates the absolute value of a number."
  Next

  Return $descr
EndFunc

Func OutputXMLDocument(Const $name, Const $param, Const $descr)
  Local Const $upBound = UBound($name) - 1
  Local $description = ''
  Local $last_name = ''
  Local $parameters[] = ['']

  ; header
  Local $xml_document  = AddTab(0, "<?xml version='1.0' encoding='Windows-1252' ?>")
        $xml_document &= AddTab(0, "<NotepadPlus>")
        $xml_document &= AddTab(1, "<AutoComplete language='AutoIt'>")
        $xml_document &= AddTab(2, "<Environment ignoreCase='yes' startFunc='(' stopFunc=')' paramSeparator=',' terminal='' />")

    #cs
        To add:
        <KeyWord name='And' />
        <KeyWord name='ByRef' />
        <KeyWord name='Case' />
        <KeyWord name='Const' />
        <KeyWord name='ContinueCase' />
        <KeyWord name='ContinueLoop' />
        <KeyWord name='Default' />
        <KeyWord name='Dim' />
        <KeyWord name='Do' />
        <KeyWord name='Else' />
        <KeyWord name='ElseIf' />
        <KeyWord name='EndFunc' />
        <KeyWord name='EndIf' />
        <KeyWord name='EndSelect' />
        <KeyWord name='EndSwitch' />
        <KeyWord name='EndWith' />
        <KeyWord name='Enum' />
        <KeyWord name='Exit' />
        <KeyWord name='ExitLoop' />
        <KeyWord name='False' />
        <KeyWord name='For' />
        <KeyWord name='Func' />
        <KeyWord name='Global' />
        <KeyWord name='If' />
        <KeyWord name='In' />
        <KeyWord name='Local' />
        <KeyWord name='Next' />
        <KeyWord name='Not' />
        <KeyWord name='Null' />
        <KeyWord name='Or' />
        <KeyWord name='ReDim' />
        <KeyWord name='Return' />
        <KeyWord name='Select' />
        <KeyWord name='Static' />
        <KeyWord name='Step' />
        <KeyWord name='Switch' />
        <KeyWord name='Then' />
        <KeyWord name='To' />
        <KeyWord name='True' />
        <KeyWord name='Until' />
        <KeyWord name='Volatile' />
        <KeyWord name='WEnd' />
        <KeyWord name='While' />
        <KeyWord name='With' />
        <KeyWord name='#ce' />
        <KeyWord name='#comments-end' />
        <KeyWord name='#comments-start' />
        <KeyWord name='#cs' />
        <KeyWord name='#include' />
        <KeyWord name='#include-once' />
        <KeyWord name='#NoTrayIcon' />
        <KeyWord name='#OnAutoItStartRegister' />
        <KeyWord name='#RequireAdmin' />
        <KeyWord name='#EndRegion' />
        <KeyWord name='#forcedef' />
        <KeyWord name='#forceref' />
        <KeyWord name='#ignorefunc' />
        <KeyWord name='#pragma' />
        <KeyWord name='#Region' />
        <KeyWord name='@AppDataCommonDir' />
        <KeyWord name='@AppDataDir' />
        <KeyWord name='@AutoItExe' />
        <KeyWord name='@AutoItPID' />
        <KeyWord name='@AutoItVersion' />
        <KeyWord name='@AutoItX64' />
        <KeyWord name='@COM_EventObj' />
        <KeyWord name='@CommonFilesDir' />
        <KeyWord name='@Compiled' />
        <KeyWord name='@ComputerName' />
        <KeyWord name='@ComSpec' />
        <KeyWord name='@CPUArch' />
        <KeyWord name='@CR' />
        <KeyWord name='@CRLF' />
        <KeyWord name='@DesktopCommonDir' />
        <KeyWord name='@DesktopDepth' />
        <KeyWord name='@DesktopDir' />
        <KeyWord name='@DesktopHeight' />
        <KeyWord name='@DesktopRefresh' />
        <KeyWord name='@DesktopWidth' />
        <KeyWord name='@DocumentsCommonDir' />
        <KeyWord name='@error' />
        <KeyWord name='@exitCode' />
        <KeyWord name='@exitMethod' />
        <KeyWord name='@extended' />
        <KeyWord name='@FavoritesCommonDir' />
        <KeyWord name='@FavoritesDir' />
        <KeyWord name='@GUI_CtrlHandle' />
        <KeyWord name='@GUI_CtrlId' />
        <KeyWord name='@GUI_DragFile' />
        <KeyWord name='@GUI_DragId' />
        <KeyWord name='@GUI_DropId' />
        <KeyWord name='@GUI_WinHandle' />
        <KeyWord name='@HomeDrive' />
        <KeyWord name='@HomePath' />
        <KeyWord name='@HomeShare' />
        <KeyWord name='@HotKeyPressed' />
        <KeyWord name='@HOUR' />
        <KeyWord name='@IPAddress1' />
        <KeyWord name='@IPAddress2' />
        <KeyWord name='@IPAddress3' />
        <KeyWord name='@IPAddress4' />
        <KeyWord name='@KBLayout' />
        <KeyWord name='@LF' />
        <KeyWord name='@LocalAppDataDir' />
        <KeyWord name='@LogonDNSDomain' />
        <KeyWord name='@LogonDomain' />
        <KeyWord name='@LogonServer' />
        <KeyWord name='@MDAY' />
        <KeyWord name='@MIN' />
        <KeyWord name='@MON' />
        <KeyWord name='@MSEC' />
        <KeyWord name='@MUILang' />
        <KeyWord name='@MyDocumentsDir' />
        <KeyWord name='@NumParams' />
        <KeyWord name='@OSArch' />
        <KeyWord name='@OSBuild' />
        <KeyWord name='@OSLang' />
        <KeyWord name='@OSServicePack' />
        <KeyWord name='@OSType' />
        <KeyWord name='@OSVersion' />
        <KeyWord name='@ProgramFilesDir' />
        <KeyWord name='@ProgramsCommonDir' />
        <KeyWord name='@ProgramsDir' />
        <KeyWord name='@ScriptDir' />
        <KeyWord name='@ScriptFullPath' />
        <KeyWord name='@ScriptLineNumber' />
        <KeyWord name='@ScriptName' />
        <KeyWord name='@SEC' />
        <KeyWord name='@StartMenuCommonDir' />
        <KeyWord name='@StartMenuDir' />
        <KeyWord name='@StartupCommonDir' />
        <KeyWord name='@StartupDir' />
        <KeyWord name='@SW_DISABLE' />
        <KeyWord name='@SW_ENABLE' />
        <KeyWord name='@SW_HIDE' />
        <KeyWord name='@SW_LOCK' />
        <KeyWord name='@SW_MAXIMIZE' />
        <KeyWord name='@SW_MINIMIZE' />
        <KeyWord name='@SW_RESTORE' />
        <KeyWord name='@SW_SHOW' />
        <KeyWord name='@SW_SHOWDEFAULT' />
        <KeyWord name='@SW_SHOWMAXIMIZED' />
        <KeyWord name='@SW_SHOWMINIMIZED' />
        <KeyWord name='@SW_SHOWMINNOACTIVE' />
        <KeyWord name='@SW_SHOWNA' />
        <KeyWord name='@SW_SHOWNOACTIVATE' />
        <KeyWord name='@SW_SHOWNORMAL' />
        <KeyWord name='@SW_UNLOCK' />
        <KeyWord name='@SystemDir' />
        <KeyWord name='@TAB' />
        <KeyWord name='@TempDir' />
        <KeyWord name='@TRAY_ID' />
        <KeyWord name='@TrayIconFlashing' />
        <KeyWord name='@TrayIconVisible' />
        <KeyWord name='@UserName' />
        <KeyWord name='@UserProfileDir' />
        <KeyWord name='@WDAY' />
        <KeyWord name='@WindowsDir' />
        <KeyWord name='@WorkingDir' />
        <KeyWord name='@YDAY' />
        <KeyWord name='@YEAR' />
    #ce
        
  ; body
  For $i = 0 To $upBound
    If $name[$i] = '' Then ContinueLoop

    If $name[$i] <> $last_name Then
      $last_name = $name[$i]
      
      $xml_document &= AddTab(2, "<KeyWord name='" & $name[$i] & "' func='yes' >")
    EndIf

    $description = InsertLineBreaks($descr[$i])

    ; load the function parameters individually into an array
    Switch StringInStr($param[$i], ',') >= 1
      Case True
        $parameters = StringSplit($param[$i], ',', $STR_NOCOUNT)
      
      Case False
        Redim $parameters[1]
        $parameters[0] = $param[$i]
    EndSwitch
 
    Switch UBound($parameters) > 1
      Case True
        $xml_document &= AddTab(3, "<Overload retVal='' descr='" & $description & "' >")

        For $parameter in $parameters
          $xml_document &= AddTab(4, "<Param name='" & StringStripWS(StringReplace($parameter, ',', ''), ($STR_STRIPLEADING + $STR_STRIPTRAILING)) & "' />")
        Next

        $xml_document &= AddTab(3, "</Overload>")

      Case False
        Switch StringStripWS($parameters[0], $STR_STRIPALL) = ''
          Case True
            $xml_document &= AddTab(3, "<Overload retVal='' descr='" & $description & "' />")
          
          Case False
            $xml_document &= AddTab(3, "<Overload retVal='' descr='" & $description & "' >")
            $xml_document &= AddTab(4, "<Param name='" & StringStripWS(StringReplace($parameters[0], ',', ''), ($STR_STRIPLEADING + $STR_STRIPTRAILING)) & "' />")
            $xml_document &= AddTab(3, "</Overload>")
        EndSwitch
    EndSwitch

    If $i + 1 > $upBound Then ExitLoop

    If $name[$i + 1] <> $last_name Then
      $xml_document &= AddTab(2, "</KeyWord>")
    EndIf
  Next

  $xml_document &= AddTab(2, "</KeyWord>")

  ; footer
  $xml_document &= AddTab(1, "</AutoComplete>")
  $xml_document &= AddTab(0, "</NotepadPlus>")

  Return $xml_document
EndFunc

Func InsertLineBreaks($description)
  $description = StringStripWS($description, $STR_STRIPSPACES)  
 
  Local Const $descr_length = StringLen($description)
  Local Const $break_point = 100 ; this is approx. how many chars wide a calltip window would be.

  Switch $descr_length >= ($break_point + 20)
    Case True
      Local Const $newline = "&#x0a;"
      Local $linebreak = $break_point
      Local $line = ''
      Local $token = ''
      Local $token2 = ''

      For $i = 1 To $descr_length
        $token = StringMid($description, $i, 1)

        Switch $i
          Case $linebreak
            Switch $token
              Case ' ' ; If the 100th char is a space then just insert a line break.
                $line &= $newline & $token

              ; If the 100th char falls on a non-space then walk
              ; over to the next closest space and insert a line break there.
              Case Else
                $line &= $token

                For $j = ($i + 1) To $descr_length
                  $i = $j
                  $token2 = StringMid($description, $j, 1)

                  Switch $token2
                    Case ' '
                      $line &= $newline
                      $linebreak += $break_point
                      ExitLoop

                    Case Else
                      $line &= $token2
                  EndSwitch
                Next
            EndSwitch

          Case Else
            $line &= $token
        EndSwitch
      Next

      Return $line

    Case Else
      Return $description
  EndSwitch
EndFunc

Func InsertLineBreakEx($sData) ; Add escape breaks. Idea by jaberwocky6669 and guinness.
    Local Const $iBreak_Point = 100
    Local Const $iLength = StringLen($sData)
    If $iLength < $iBreak_Point Then Return $sData

    Local $fIsBreakPoint = False, _
          $iStart = $iBreak_Point, _
          $sChr = '', $sLine = ''
    Local Const $NP_NL = "&#x0a; ", _
                $STR_SPACE = Chr(32)
    For $i = 1 To $iLength
        $sChr = StringMid($sData, $i, 1)

        If $i = $iStart Or $fIsBreakPoint Then
            If $sChr = $STR_SPACE Then
                $fIsBreakPoint = False
                $iStart += $iBreak_Point
                $sChr &= $NP_NL
            Else
                $fIsBreakPoint = True
                $iStart += 1
            EndIf
        EndIf
        $sLine &= $sChr
    Next
    Return $sLine
EndFunc   ;==>InsertLineBreakEx

Func AddTab(Const $tabs, Const $data)
  Local $tabString = ''

  For $i = 1 To $tabs
    $tabString &= @TAB
  Next

  Return $tabString & $data & @CRLF
EndFunc

Func Write(Const $message)
  Switch @Compiled
    Case True
      MsgBox($MB_OK, "Notepad++ With AutoIt User Calltips", $message)

    Case False
      ConsoleWrite($message & @CRLF)
  EndSwitch

  Return True
EndFunc

Func __FileReadToArray(Const $sFilePath)
  #cs
    #FUNCTION# ====================================================================================================================
    Name...........: _FileReadToArray
    Description ...: Reads the specified file into an array.
    Syntax.........: _FileReadToArray($sFilePath)
    Parameters ....: $sFilePath - Path and filename of the file to be read.
    Return values .: Success - Returns an array.
                     Failure - Returns False.
                               @Error  - 0 = No error.
                                        |1 = Error opening specified file
                                        |2 = Unable to split the file
    Author ........: Jonathan Bennett <jon at hiddensoft dot com>, Valik - Support Windows Unix and Mac line separator
    Modified.......: Jpm - fixed empty line at the end, Gary Fixed file contains only 1 line.
                     Jaber - Modified to return an array rather than modify an array ByRef.
    Remarks .......: $aArray[0] will contain the number of records read into the array.
    Related .......: _FileWriteFromArray
    Link ..........:
    Example .......: Yes.
    ===============================================================================================================================
  #ce

  Local Const $file_read = FileOpen($sFilePath, $FO_READ)

  Switch $file_read
    Case -1
      Return SetError(1, 0, False) ; unable to open the file

    Case Else
      ; Read the file and remove any trailing white spaces
      Local $aFile = FileRead($file_read)

      FileClose($file_read)

      ; remove last line separator if any at the end of the file
      Switch StringRight($aFile, 1)
        Case @LF, @CR
          $aFile = StringTrimRight($aFile, 1)
      EndSwitch

      Select
        Case StringInStr($aFile, @LF)
          Return StringSplit(StringStripCR($aFile), @LF)

        Case StringInStr($aFile, @CR) ; @LF does not exist so split on the @CR
          Return StringSplit($aFile, @CR)

        Case Else ; unable to split the file
          Switch StringLen($aFile)
            Case True
              Local Const $new_array[2] = [1, $aFile]
              
              Return $new_array
              
            Case False
              Return SetError(2, 0, False)
          EndSwitch
      EndSelect
  EndSwitch
 
  Return True
EndFunc

#endregion