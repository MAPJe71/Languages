;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:        Jack Dunning, Jack's AutoHotkey Blog (https://jacksautohotkeyblog.wordpress.com/)
;
; Script Function:
;	The CopyRef.ahk script copies any selected text to an Untitled - Notepad window.
;       This uses the standard Windows Clipboard manipulation routine discussed in detail at:
;          https://jacksautohotkeyblog.wordpress.com/2016/03/23/autohotkey-windows-clipboard-techniques-for-swapping-letters-beginning-hotkeys-part-9/
;       Be sure to save the Notepad file after copying references.
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

  ; Copying text to Notepad for future reference
  ^!c::
    OldClipboard := ClipboardAll
    Clipboard = ;clears the Clipboard
    Send, ^c
    ClipWait 0 ;pause for Clipboard data
    If ErrorLevel
    {
      MsgBox, No text selected!
    }

    IfWinNotExist, Untitled - Notepad
      {
         Run, Notepad
         WinWaitActive, Untitled - Notepad
      }

; Control, EditPaste used rather than ControlSend for much greater speed of execution

   Control, EditPaste, % Clipboard . chr(13) . chr(10)  . chr(13) . chr(10) , , Untitled - Notepad
   Clipboard := OldClipboard
  Return

