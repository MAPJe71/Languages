#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

/*

Check out http://www.computoredgebooks.com/AutoHotkey-E-Books_c19.htm?sourceCode=RefScript
for more AutoHotkey books.

This AutoHotkey script uses the hidden indexing in the AutoHotkey.com
site to look up AutoHotkey commands highlighted within a document.

Highlight an AutoHotkey command, variable, or term, then use the
hotkey combination CTRL+ALT+m. The highlighted term downloads the 
page to the file ahkref then reads the file into the variable RefSource.

To download directly to the variable, move the block comment marks around the 
ComObjCreate() section to encapsulate the UrlDownloadToFile and ReadFile command section.

November 3, 2016 - This version downloads the page source code. If the <pre class="Syntax"> tag
is found the the code, then it is identified as a command page.

The command structure gets parsed with the RegExMatch() function, then a little clean up.
Next the command syntax is displayed in a MsgBox.

A timer is included using the A_TickCount variable.

November 18, 2016 - If a command page is not found, then the script checks for the variable page.
If found it uses the AHKref.ini file to set the clipboard to the proper case for parsing the
the variable page. Found variable references are displayed in a MsgBox.

December 13, 2016 - The order of the script changes to deal with built-in variables first. This
allows better results while speeding up the script. This portion no longer needs Internet access unless
the source code for the "Variables" page does not exist on the drive.

January 23, 2017 - A new section which parses and displays the math functions page has been added.
Eventually, I plan to place functions in a pop-up menu well as GUI Controls.
MsgBox techniques have been used to add extra buttons and create clarity in button purpose.
A new variable ReplaceRef saves the command/function/variable syntax for insertion into any document.

*/

^!m::                                                                
 Global Terminate
 Terminate := 0
 Gui +OwnDialogs
 StartTime := A_TickCount  ; check response time
 WinID := WinExist("A")
 OldClipboard:= ClipboardAll
 Clipboard:= ""
 Send, ^c ;copies selected text to clipboard
 ClipWait 0
 If ErrorLevel
   {
     MsgBox, No Text Selected!
     Clipboard := OldClipboard
     Return
   }
   
; This next section finds built-in variable information without accessing the Internet
   
StringReplace, VarTerm, Clipboard, a_
IfExist AHKref.ini
  IniRead, VarTerm, AHKRef.ini, variables, %VarTerm%,No Value
Else
  {
  MsgBox INI file AHKref.ini missing!`r`rDownload Now?
  IfMsgBox OK
    {
    UrlDownloadToFile, http://www.computoredge.com/AutoHotkey/Downloads/AHKRef.ini, AHKRef.ini
	Sleep 1000
	IniRead, VarTerm, AHKRef.ini, variables, %VarTerm%,No Value
    }
  }

; Okay, if the file does not exist, we download just once
  
IfNotExist AHKVariables
  UrlDownloadToFile, https://autohotkey.com/docs/Variables.htm, AHKVariables


  FileRead, RefSource, AHKVariables
  
     
;	 If InStr(RefSource, "id=""" . VarTerm . """") msgbox
     If (VarTerm != "No Value")
	 {
	   Needle := "i).+?<tr id=""" . VarTerm . """>.<td>(.+?)</td>.<td>(.+?)</td>.+"
       ReplaceRef := RegExReplace(RefSource,Needle,"$1")
       ReplaceRef := RegExReplace(ReplaceRef,"<.+?>")
       CmdRef := RegExReplace(RefSource,Needle,"$1`r`r$2")
       CmdRef := RegExReplace(CmdRef,"<.+?>")
	   StringReplace, CmdRef, CmdRef, &quot;, ", all
       ElapsedTime := A_TickCount - StartTime
       SetTimer, ChangeButtonNamesVar, 50
       OnMessage(0x53, "WM_CANCEL")
       MsgBox, 16387,%Clipboard%, %CmdRef%`r`rClick "Load Page" to open AutoHotkey page  
	                     .`rClick "Insert Code" to add AutoHotkey code
						 .`rClick "Skip to Next" to continue search
	                     .`rClick Cancel to Exit.`r`rTickCount %ElapsedTime% 
	   IfMsgBox Yes
	     {
	      Run https://autohotkey.com/docs/Variables.htm#%VarTerm%
          Clipboard := OldClipboard
		  Exit
		 }
	   IfMsgBox No
	   {
         WinActivate
		 SendInput, %ReplaceRef%
         Clipboard := OldClipboard
	     Exit
	   }
	   IfMsgBox Cancel
	   {
	   }
	   If(Terminate = "Yes")
	   {
	     Exit
	   }
	 }


   UrlDownloadToFile, https://autohotkey.com/docs/%Clipboard%, ahkref
  
; The following code is an alternative approach to the above for
; downloading source code directly to a variable
/* 
   whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")   
   whr.Open("GET", "https://autohotkey.com/docs/" . Clipboard, true)
   whr.Send()
   ; Using 'true' above and the call below allows the script to remain responsive.
   whr.WaitForResponse()
   RefSource := whr.ResponseText
 */

  FileRead, RefSource, ahkref

   ;   The RegExMatch() function on the next line is an alternative to the IfInString command
   ;   If RegExMatch(RefSource,"<pre class=""Syntax"">")    
; i).+?<div class="methodShort" id="Sin">.+?<pre class="Syntax">(.+?)</pre.+

; This next section identifies the math functions page (if downloaded).
; The math functions are parsed and displayed.
; Otherwise the command pages are checked or a site search page gets loaded.

   If (InStr(RefSource, "<title>Math Functions</title>"))  ; IDs a command page
   {
      If (clipboard = "math")
	    {
		  MsgBox, 3, %clipboard%, Math Functions?
		  IfMsgBox Yes
			Run https://autohotkey.com/docs/%Clipboard%
    	 IfMsgBox No
    	   {
             WinActivate
             Clipboard := OldClipboard
	         Exit
    	   }
    	 IfMsgBox Cancel
    	   {
             WinActivate
             Clipboard := OldClipboard
	         Exit
    	   }
		}


     RegNeedle := "i).+?<div class=""methodShort"" id=""" . Clipboard . """>.+?<pre class=""Syntax"">(.+?)</pre>`n<p>(.+?)</p>.+.+"
     ReplaceRef := RegExReplace(RefSource,RegNeedle,"$1")
     ReplaceRef := RegExReplace(ReplaceRef,"<.+?>")
     CmdRef := RegExReplace(RefSource,RegNeedle,"$1`n`n$2")
     CmdRef := RegExReplace(CmdRef,"<.+?>")
	 StringReplace, CmdRef, CmdRef, &quot;, ", all
     ElapsedTime := A_TickCount - StartTime
     SetTimer, ChangeButtonNames, 50
     OnMessage(0x53, "WM_HELP")
     MsgBox, 16387,%Clipboard%, %CmdRef%`r`rClick "Load Page" to open AutoHotkey page.`r`rTickCount %ElapsedTime% 
	 IfMsgBox Yes
	   Run https://autohotkey.com/docs/%Clipboard%
	   
	 IfMsgBox No
	   {
         WinActivate
		 SendInput, %ReplaceRef%
         Clipboard := OldClipboard
	     Exit
	   }
	   IfMsgBox Cancel
	   {
         WinActivate
         Clipboard := OldClipboard
	     Exit
	   }
   }
   Else If (InStr(RefSource, "<pre class=""Syntax"">"))  ; IDs a command page
   {
     ReplaceRef := RegExReplace(RefSource,".+?<pre class=""Syntax"">(.+?)</pre.+","$1")
     ReplaceRef := RegExReplace(ReplaceRef,"<.+?>")
     CmdRef := RegExReplace(RefSource,".+?<pre class=""Syntax"">(.+?)</pre.+","$1")
     CmdRef := RegExReplace(CmdRef,"<.+?>")
	 StringReplace, CmdRef, CmdRef, &quot;, ", all
     ElapsedTime := A_TickCount - StartTime
     SetTimer, ChangeButtonNames, 50
     OnMessage(0x53, "WM_HELP")
     MsgBox, 16387,%Clipboard%, %CmdRef%`r`rClick "Load Page" to open AutoHotkey page.`r`rTickCount %ElapsedTime% 
	 IfMsgBox Yes
	   Run https://autohotkey.com/docs/%Clipboard%
	 IfMsgBox No
	   {
         WinActivate
		 SendInput, %ReplaceRef%
         Clipboard := OldClipboard
	     Exit
	   } 
	 IfMsgBox Cancel
	   {
         WinActivate
         Clipboard := OldClipboard
	     Exit
	   }
	}
/* This section was modified and moved to the beginning of the script December 17, 2016. You can delete it. If remains here for reference only.
   Else If (InStr(RefSource, "<title>Variables and Expressions</title>"))   ; IDs variables page 
   {
     StringReplace, VarTerm, Clipboard, a_
	 
	 ; The INI file sets the term to the proper case for the RegExReplace() function
     IfExist AHKref.ini
       IniRead, VarTerm, AHKRef.ini, variables, %VarTerm%,No Value
	 Else
	   MsgBox INI file AHKref.ini missing!
  
     
	 If InStr(RefSource, "id=""" . VarTerm . """") ; case sensitive  ,true
	 {
	   Needle := "i).+?<tr id=""" . VarTerm . """>.<td>(.+?)</td>.<td>(.+?)</td>.+"
       CmdRef := RegExReplace(RefSource,Needle,"$1`r`r$2")
       CmdRef := RegExReplace(CmdRef,"<.+?>")
	   StringReplace, CmdRef, CmdRef, &quot;, ", all
       ElapsedTime := A_TickCount - StartTime
       SetTimer, ChangeButtonNames2, 50
       MsgBox, 16385,%Clipboard%, %CmdRef%`r`rClick OK to open AutoHotkey page.`r`rTickCount %ElapsedTime% 
	   IfMsgBox OK
	     Run https://autohotkey.com/docs/Variables.htm#%VarTerm%
	   Else
	     Return
	 }
	 Else
	   Run https://autohotkey.com/docs/%Clipboard%
   }   
 */ 
  Else
   {
	   Run https://autohotkey.com/docs/%Clipboard%
	   ;Run https://cse.google.com/cse?cx=010629462602499112316:ywoq_rufgic&q=%Clipboard%
   }
   Clipboard := OldClipboard
Return

; These lines are included only for test purposes
; (.+?)<a.+?>(.+?)</a>(.+) time case a_hour StringSplit upper A_DD day m  A_DDD dddd a_yyyy year A_YWeek test1  a_Space upper settimer  expressions variables stringlower a_ip A_cur system
; continuation array single links dir  sin ! msgbox controlsend gui math

ChangeButtonNamesVar: 
  IfWinNotExist, %clipboard%
    return  ; Keep waiting.
  SetTimer, ChangeButtonNamesVar, off 
  WinActivate 
  ControlSetText, Button1, Load Page, %clipboard%
  ControlSetText, Button2, Insert Code, %clipboard%
  ControlSetText, Button3, Skip to Next, %clipboard%
  ControlSetText, Button4, Cancel, %clipboard%
Return
ChangeButtonNames: 
  IfWinNotExist, %clipboard%
    return  ; Keep waiting.
  SetTimer, ChangeButtonNames, off 
  WinActivate 
  ControlSetText, Button1, Load Page, %clipboard%
  ControlSetText, Button2, Insert Code, %clipboard%
  ControlSetText, Button3, Cancel, %clipboard%
  ControlSetText, Button4, Help, %clipboard%
Return

WM_HELP()
{
   MsgBox,4096, Info!, Click "Load Page" to accesss Web page.`rClick "Insert Code" to copy text to document.`rClick "Cancel" to Exit
}
WM_CANCEL()
{
   Terminate := "Yes"
   WinClose,  %clipboard%
}