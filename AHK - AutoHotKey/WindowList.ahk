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


^#L::

Gui,+AlwaysOnTop
Gui, Font, s12, Arial
Gui, Add, DropDownList, w275 vWindowMove gPosChoice,Pick a Window||

WinGet, OpenWindow, List 

Loop, %OpenWindow% 
{ 
WinGetTitle, Title, % "ahk_id " OpenWindow%A_Index% 
WinGetClass, Class, % "ahk_id " OpenWindow%A_Index% 
;   MsgBox %Title%
;   MsgBox %Class%
 If (Title != "" and Class != "BasicWindow" and Title != "Start" 
                 and Title != "Program Manager")
   {
    GuiControl,,WindowMove, %Title%
   }
} 
Gui, Show, W300 H40 , Move Window
Return

PosChoice:
Gui, Submit, NoHide
WinActivate, %WindowMove%
WinMove, %WindowMove%,, 20, 20
Return

GuiClose:
Gui, Destroy
Return

