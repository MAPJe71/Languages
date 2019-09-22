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

^#F1::      ; Add date/time stamp
Send, %A_Now%
return

^#F2::      ; Add today's date formatted
FormatTime, TimeString, %A_NOW%, MMMM d, yyyy
Send, %TimeString%
return

^#F3::      ; Add today's date formatted
Send, %A_DDD%, %A_MMM% %A_D%, %A_YYYY%
return


; This next example is a little more advanced form which opens
; a calendar for selecion. The AddDate: name is added to avoid GUI
; conflicts and the IfWinNotExist condition is used to avoid errors
; while maintaining the last selected data as a default.

^#!d::
DetectHiddenWindows, On

IfWinNotExist, Select Date
 {
  Gui AddDate:Add, MonthCal, vDayPick
  Gui AddDate:Add, Button, Default, Submit
 }
Gui AddDate:Show,, Select Date

DetectHiddenWindows, Off
return

AddDateButtonSubmit:   ; Label for the above hotkey (^#D)
  Gui AddDate:Submit
  FormatTime, DayPick, %DayPick%, MMMM d, yyyy
  Send, %DayPick%
Return

:c*:Adate:: ; Hotstring to pick date from calendar. Capital A required.
send, ^#!d
Return


:c*:Anow::  ; Hotstring to immediately add today's date formatted. Capital A required.
FormatTime, CurrentDateTime,, MMMM d, yyyy  
SendInput %CurrentDateTime%
return

