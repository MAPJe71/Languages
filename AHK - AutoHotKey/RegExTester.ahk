;
; AutoHotkey Version: AutoHotkey_L
; Language:       English
; Platform:       Windows
; Author:         See notes below
;
; Original Script can be found at:
; http://www.autohotkey.com/board/topic/81045-regular-expression-tester/
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

/*
    Regex Tester - A front end for testing Perl Compatible Regular Expressions.
                   The results update in realtime and any setting or expression
                   errors are highlighted in red.
                   
                   Alt+C will copy the currently displayed expression to the Clipboard.
    
    Version 1.0
    Last Update 5-29-2012
    By Robert Ryan
*/

; AutoeExecute
    #NoEnv
    #SingleInstance force

    gosub MakeGui
    gosub UpdateMatch
    gosub UpdateReplace
    Gui Show, , RegEx Tester
return

#IfWinActive Regex Tester
!c::
    Gui Submit, NoHide
    ClipBoard := (TabSelection = "RegExMatch") ? mNeedle : rNeedle
    MsgBox, 64, RegEx Copied, %Clipboard% has been copied to the Clipboard, 3
return

GuiEscape:
GuiClose:
    ExitApp
return

; This is called any time any of the edit boxes on the RegExMatch tab are changed.
UpdateMatch:
    Gui Submit, NoHide
    
    if not IsInteger(mStartPos) {
        mStartPos := 1
        Gui Font, cRed 
        GuiControl Font, mStartPos
    }
    else {
        Gui Font, cDefault
        GuiControl Font, mStartPos
    }
    
    ; Set Needle to return an object
    mNeedle := RegExReplace(mNeedle, "^(\w*)\)", "O$1)", cnt)
    if (! cnt) {
        mNeedle := "O)" mNeedle
    }
    
    FoundPos := RegExMatch(mHaystack, mNeedle, Match, mStartPos)
    if (ErrorLevel) {
        Gui Font, cRed 
        GuiControl Font, mNeedle
    }
    else {
        Gui Font, cDefault
        GuiControl Font, mNeedle
    }
    
    ResultText := "FoundPos: " FoundPos "`n"
    ResultText .= "Match: " Match.Value() "`n"
    Loop % Match.Count() {
        ResultText .= "Match["
        ResultText .= (Match.Name[A_Index] = "") 
                    ? A_Index 
                    :  Match.Name[A_Index] 
        ResultText .= "]: " Match[A_Index] "`n"
    }
    GuiControl, , mResult, %ResultText%
return

; This is called any time any of the edit boxes on the RegExReplace tab are changed.
UpdateReplace:
    Gui Submit, NoHide
    
    if not IsInteger(rStartPos) {
        rStartPos := 1
        Gui Font, cRed 
        GuiControl Font, rStartPos
    }
    else {
        Gui Font, cDefault
        GuiControl Font, rStartPos
    }
    
    if not IsInteger(rLimit) {
        rLimit := -1
        Gui Font, cRed 
        GuiControl Font, rLimit
    }
    else {
        Gui Font, cDefault
        GuiControl Font, rLimit
    }
    
    NewStr := RegExReplace(rHaystack, rNeedle, rReplacement, rCount, rLimit, rStartPos)
    if (ErrorLevel) {
        Gui Font, cRed 
        GuiControl Font, rNeedle
    }
    else {
        Gui Font, cDefault
        GuiControl Font, rNeedle
    }
    
    ResultText := "Count: " rCount "`n"
    ResultText .= "NewStr: `n" NewStr "`n"
    
    GuiControl, , rResult, %ResultText%
return

MakeGui:
    Gui Font, s10, Consolas
    Gui Add, Tab2, r25 w400 vTabSelection, RegExMatch|RegExReplace
    
    Gui Tab, RegExMatch
        Gui Add, Text, , Text to be searched:
        Gui Add, Edit, r12 w370 vmHaystack gUpdateMatch
        Gui Add, Text, Section, Regular Expression:
        Gui Add, Edit, r2 w275 vmNeedle gUpdateMatch
        Gui Add, Text, x+15 ys, Start: (1)
        Gui Add, Edit, r1 w75 vmStartPos gUpdateMatch, 1
        Gui Add, Text, xs, Results:
        Gui Add, Edit, r14 w370 +readonly -TabStop vmResult
        
    Gui Tab, RegExReplace
        Gui Add, Text, , Text to be searched:
        Gui Add, Edit, r10 w370 vrHaystack gUpdateReplace
        Gui Add, Text, w275 Section, Regular Expression:
        Gui Add, Edit, r2 w275 vrNeedle gUpdateReplace
        Gui Add, Text, , Replacement Text:
        Gui Add, Edit, r2 w275 vrReplacement gUpdatereplace
        Gui Add, Text, , Results:
        Gui Add, Edit, r12 w370 +readonly -TabStop vrResult
        Gui Add, Text, ys xs+290 Section, Start: (1)
        Gui Add, Edit, r1 w75 vrStartPos gUpdateReplace, 1
        Gui Add, Text, xs y+35 , Limit: (-1)
        Gui Add, Edit, r1 w75 vrLimit gUpdateReplace, -1
return

IsInteger(str) {
    if str is integer
        return true
    else
        return false
}