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

Gui, Font, s20 cBlue, Arial

Gui, Add, Picture, w30 h-1 section gLaunchGoogle Icon1
     , C:\Users\%A_UserName%\AppData\Local\Google\Chrome\Application\chrome.exe
Gui, Add, Text, ys gLaunchGoogle, Google Chrome

Gui, Add, Picture, w30 h-1 section xs gLaunchFirefox Icon3
     , %ProgramFiles%\Mozilla Firefox\firefox.exe
Gui, Add, Text, ys gLaunchFirefox, Firefox

Gui, Add, Picture, w30 h-1 section xs gLaunchExplorer Icon3
     , C:\Program Files\Internet Explorer\iexplore.exe
Gui, Add, Text, ys gLaunchExplorer, Internet Explorer

Gui, Add, Picture, w30 h-1 section xs gLaunchDropBox Icon6
      , C:\Users\%A_UserName%\AppData\Roaming\Dropbox\bin\Dropbox.exe
Gui, Add, Text, ys gLaunchDropBox, DropBox

Gui, Show, , Launch Program
Return

LaunchGoogle:
Run C:\Users\%A_UserName%\AppData\Local\Google\Chrome\Application\chrome.exe
WinClose
return

LaunchFirefox:
Run "C:\Program Files\Mozilla Firefox\firefox.exe" www.facebook.com
WinClose
return

LaunchExplorer:
Run "C:\Program Files\Internet Explorer\iexplore.exe"
WinClose
return

LaunchDropBox:
Run C:\Users\%A_UserName%\Dropbox
WinClose
return


