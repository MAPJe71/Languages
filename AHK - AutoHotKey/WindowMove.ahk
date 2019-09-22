;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^#M::

WinGetTitle, WinName, A

Gui, Font, s12, Arial
Gui, Add, DropDownList, AltSubmit w275 vPosition gPosChoice, Select Position on the Screen||Right Half of Screen|Left Half of Screen|Top Half of Screen|Bottom Half of Screen|Center of Screen|Top Right Corner|Bottom Right Corner|Top Left Corner|Bottom Left Corner|
Gui, Show, W300 H40 , Move Window
Return

PosChoice:
Gui, Submit, NoHide

    WinGetPos,TX1,TY1,TW1,TH1,ahk_class Shell_TrayWnd

    WinGetPos,X1,Y1,W1,H1,Program Manager
	X2 := W1/2
	Y2 := (H1-TH1)/2
	Y3 := H1-TH1
	X4 := W1/4
	Y4 := H1/4

If Position = 2
  {
        WinMove,%WinName%,,%X2%,0,%X2%,%Y3%
  }
If Position = 3
  {
        WinMove,%WinName%,,0,0,%X2%,%Y3%
  }
If Position = 4
  {
        WinMove,%WinName%,,0,0,%W1%,%Y2%
  }
If Position = 5
  {
        WinMove,%WinName%,,0,%Y2%,%W1%,%Y2%
  }
If Position = 6
  {
        WinMove,%WinName%,,%X4%,%Y4%,%X2%,%Y2%
  }
If Position = 7
  {
        WinMove,%WinName%,,%X2%,0,%X2%,%Y2%
  }
If Position = 8
  {
        WinMove,%WinName%,,%X2%,%Y2%,%X2%,%Y2%
  }
If Position = 9
  {
        WinMove,%WinName%,,0,0,%X2%,%Y2%
  }
If Position = 10
  {
        WinMove,%WinName%,,0,%Y2%,%X2%,%Y2%
  }

return


GuiClose:
Gui, Destroy
Return

;	ResizeWin(0,0,X2,Y2,,WinName) 


 ResizeWin(Row,Col,Width,Height,LastWin = "A")
  {
    WinGetPos,X,Y,W,H,%WinName%
;	MsgBox, Value Is: %LastWin% 

    WinGetPos,X1,Y1,W1,H1,Program Manager
    X2 := (W1 - Width)/2
    Y2 := (H1 - Height)/2

    If (Width >= W1){
	   X2 := 1
	   Width := W1
	}

    If (Height >= H1){
	   Y2 := 1
	   Height := H1
	}  

     If (X2 = 1 and Y2 = 1)
       {
         WinMaximize, %LastWin%
       }
     Else
       {
         WinMove,%LastWin%,,%X2%,%Y2%,%Width%,%Height%
       }


  }


^#!T::
    WinShow ahk_class Shell_TrayWnd
;    WinShow ahk_class DV2ControlHost
Return
^#!H::
    WinHide ahk_class Shell_TrayWnd
;    WinHide ahk_class DV2ControlHost
Return
