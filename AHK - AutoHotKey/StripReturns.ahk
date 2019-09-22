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


Menu, Tray, Add, Strip Selected Returns, StripReturns
Return

StripReturns:
  SendInput, !{tab}
  Sleep 200
  SendInput, ^+!S
Return


^+!S::
 
previous := % ClipboardAll
Sleep 200
clipboard := ""
SendInput ^c
Sleep 500

   StringReplace, clipboard, clipboard, `r, , all
   StringReplace, clipboard, clipboard, `n `n, |, all
   StringReplace, clipboard, clipboard, `n`n, |, all
   StringReplace, clipboard, clipboard, `n, %A_Space%, all
   StringReplace, clipboard, clipboard,  |,`r`n`r`n, all

SendInput ^v
Sleep 500
clipboard := % previous
Return

