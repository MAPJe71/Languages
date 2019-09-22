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

^u::                           ; Convert text to upper
 OldClipboard:= Clipboard
 Clipboard:= ""
 Send, ^c ;copies selected text
 ClipWait
 StringUpper Clipboard, Clipboard
 Send %Clipboard%
 Sleep 1000
 Clipboard:= OldClipboard
return

^l::                           ; Convert text to lower
 OldClipboard:= Clipboard
 Clipboard:= ""
 Send, ^c ;copies selected text
 ClipWait
 StringLower Clipboard, Clipboard
 Send %Clipboard%
 Sleep 1000
 Clipboard:= OldClipboard
return

+^k::                           ; Convert text to capitalized
 OldClipboard:= Clipboard
 Clipboard:= ""
 Send, ^c ;copies selected text
 ClipWait
 StringUpper Clipboard, Clipboard, T
 Send %Clipboard%
 Sleep 1000
 Clipboard:= OldClipboard
return

