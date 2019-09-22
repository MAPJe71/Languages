; Easy Access to Favorite Folders -- by Savage
; http://www.autohotkey.com

; Tested with version 1.0.23 on Win/XP

; When you click the middle mouse button while certain types of
; windows are active, this script displays a menu of your favorite
; folders.  Upon selecting a favorite, the script will instantly
; switch to that folder within the active window.  The following
; window types are supported: 1) Standard file-open or file-save
; dialogs; 2) Explorer windows; 3) Console (command prompt)
; windows; 4) Microsoft Office file Open and Save As dialogs.           ;jh0105
; The menu can also be optionally shown for unsupported window
; types, in which case the chosen favorite will be opened as a new
; Explorer window.

; Note: In Windows Explorer, if "View > Toolbars > Address Bar" is
; not enabled, the menu will not be shown if the hotkey chosen below
; has a tilde.  If it does have a tilde, the menu will be shown
; but the favorite will be opened in a new Explorer window rather
; than switching the active Explorer window to that folder.

; Revisions - by JHoward                                                ;jh0105
; Added support for Microsoft Office Open and Save As dialog boxes.     ;jh0105
;
; Revisions - by Sandeep
; Menu items now point to folder shortcuts ( link files ) in the
; directory of your choice. The name of the shortcut is what appears
; in the popup menu. The shortcut's target is used to switch the
; active window.
;
; Revisions - by ChrisM
; Two menu items always appear at the bottom:
;  - Add to Favorites - allows the user to add new menu items and
; make new link files. Valid paths can be extracted from any window
; title or from the clipboard.
;  - Edit Favorites Folder - conveniently opens an explorer window
; to the link files.
; Adding numbers to the start of link file names will sort the
; menu in that order. The menu is alphabetically sorted.
;
; Added the default shortcut name as the found path with the ':' and '\' ;cm0205
; replaced with spaces to make a legal link file name.                   ;cm0205


; CONFIG: CHOOSE DIRECTORY TO HOLD SHORTCUTS
; Set the following variable to the folder name which holds all your
; folder shortcuts. The suggested place is
; %HOMEPATH%\My Documents\Favorites for easy access from other apps.
f_shortcuts_folder = C:\Users\%A_UserName%\Links


; CONFIG: CHOOSE RELOADING
; Set the following variable to 1 to always reload the menu and 0 to
; disable automatic reloading. Keep this 1 unless you have a really
; long list, because it harldy takes any time to load. But if you
; don't change your list very often, then you may want to keep it 0.
f_AlwaysReload = 1


; CONFIG: CHOOSE YOUR HOTKEY
; If your mouse has more than 3 buttons, you could try using
; XButton1 (the 4th) or XButton2 (the 5th) instead of MButton.
; You could also use a modified mouse button (such as ^MButton) or
; a keyboard hotkey.  In the case of MButton, the tilde (~) prefix
; is used so that MButton's normal functionality is not lost when
; you click in other window types, such as a browser.  The presence
; of a tilde tells the script to avoid showing the menu for
; unsupported window types.  In other words, if there is no tilde,
; the hotkey will always display the menu; and upon selecting a
; favorite while an unsupported window type is active, a new
; Explorer window will be opened to display the contents of that
; folder.
f_Hotkey = ~^!E


; END OF CONFIGURATION SECTION
; Do not make changes below this point unless you want to change
; the basic functionality of the script.

#SingleInstance  ; Needed since the hotkey is dynamically created.

Hotkey, %f_Hotkey%, f_DisplayMenu
StringLeft, f_HotkeyFirstChar, f_Hotkey, 1
If f_HotkeyFirstChar = ~  ; Show menu only for certain window types.
  f_AlwaysShowMenu = n
else
  f_AlwaysShowMenu = y


;----Build the menu from link files found in f_shortcuts_folder.
f_CreateMenu:
  If f_AlwaysReload = 1
  {
     If f_NotFirstTime = true
        Menu, Favorites, DeleteAll
  }
  else
  {
     If f_NotFirstTime = true
        return
  }
  f_NotFirstTime = true
 
  ; Retrieve file names in sorted order:
  f_FileList =  ; Initialize to be blank.
  Loop, %f_shortcuts_folder%\*.lnk
    f_FileList = %f_FileList%`n%A_LoopFileName%
  Sort, f_FileList

  f_MenuItemCount = 0
  Loop, parse, f_FileList, `n
  {
    If A_LoopField =  ; Ignore the blank item at the end of the list.
      continue
    StringLen, f_LenFileName, A_LoopField
    f_LenFileName -= 4
    StringLeft, f_MenuItemName, A_LoopField, %f_LenFileName% ;To cut off .lnk
    f_MenuItemCount++
    ; Build an array of menu names to check for duplicates in f_AddToFavorites.
    Transform, f_menuName%f_MenuItemCount%, deref, %f_MenuItemName%
    Menu, Favorites, add, %f_MenuItemName%, f_OpenFavorite
  }
 
  ; Add a separator line.
  Menu, Favorites, Add
  ; Add a command to capture the current folder address.
  Menu, Favorites, Add, Add to Favorites, f_FindPath
  ; Add a command to allow the user to edit the shortcuts.
  Menu, Favorites, Add, Edit Favorites Folder, f_EditFavorites
  ; Show Reload menu only if not set to reload on every popup.
  If f_AlwaysReload = 0
    Menu,Favorites,add,Reload,Reload
return


Reload:
   Reload
return


;----Open the selected favorite
f_OpenFavorite:
  ; Fetch the shortcut's target that corresponds to the selected menu item:
  FileGetShortcut, %f_shortcuts_folder%\%A_ThisMenuItem%.lnk, f_path
  If f_path =
    return
  If f_class = #32770    ; It's a dialog.
  {
    If f_Edit1Pos <>   ; And it has an Edit1 control.
    {
      ; Activate the window so that if the user is middle-clicking
      ; outside the dialog, subsequent clicks will also work:
      WinActivate ahk_id %f_window_id%
      ; Retrieve any filename that might already be in the field so
      ; that it can be restored after the switch to the new folder:
      ControlGetText, f_text, Edit1, ahk_id %f_window_id%
      ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
      ControlSend, Edit1, {Enter}, ahk_id %f_window_id%
      Sleep, 100  ; It needs extra time on some dialogs or in some cases.
      ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
      return
    }
    ; else fall through to the bottom of the subroutine to take standard action.
  }
  else If f_class in ExploreWClass,CabinetWClass  ; In Explorer, switch folders.
  {
    If f_Edit1Pos <>   ; And it has an Edit1 control.
    {
      ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
      ; Tekl reported the following: "If I want to change to Folder L:\folder
      ; then the addressbar shows http://www.L:\folder.com. To solve this,
      ; I added a {right} before {Enter}":
      ControlSend, Edit1, {Right}{Enter}, ahk_id %f_window_id%
      return
    }
    ; else fall through to the bottom of the subroutine to take standard action.
  }
  else IfInString, f_class, bosa_sdm_  ; Microsoft Office application   ;jh0105
  {                                                                     ;jh0105
    ; Activate the window so that if the user is middle-clicking        ;jh0105
    ; outside the dialog, subsequent clicks will also work:             ;jh0105
    WinActivate ahk_id %f_window_id%                                    ;jh0105
    ; Retrieve any file name that might already be in the File name     ;jh0105
    ; control, so that it can be restored after the switch to the new   ;jh0105
    ; folder.                                                           ;jh0105
    ControlGetText, f_text, RichEdit20W2, ahk_id %f_window_id%          ;jh0105
    ControlClick, RichEdit20W2, ahk_id %f_window_id%                    ;jh0105
    ControlSetText, RichEdit20W2, %f_path%, ahk_id %f_window_id%        ;jh0105
    ControlSend, RichEdit20W2, {Enter}, ahk_id %f_window_id%            ;jh0105
    Sleep, 100  ; It needs extra time on some dialogs or in some case   ;jh0105
    ControlSetText, RichEdit20W2, %f_text%, ahk_id %f_window_id%        ;jh0105
    return                                                              ;jh0105
  }                                                                     ;jh0105
  else If f_class = ConsoleWindowClass ; In a console window, CD to that directory
  {
    WinActivate, ahk_id %f_window_id% ; Because sometimes the mclick deactivates it.
    SetKeyDelay, 0  ; This will be in effect only for the duration of this thread.
    IfInString, f_path, :  ; It contains a drive letter
    {
      StringLeft, f_path_drive, f_path, 1
      Send %f_path_drive%:{enter}
    }
    Send, cd %f_path%{Enter}
    return
  }
  ; Since the above didn't return, one of the following is true:
  ; 1) It's an unsupported window type but f_AlwaysShowMenu is y (yes).
  ; 2) It's a supported type but it lacks an Edit1 control to facilitate the custom
  ;    action, so instead do the default action below.
  ;Run, Explorer %f_path%  ; Might work on more systems without double quotes.
  f_command = Explorer /e, %f_path%
  Run, %f_command%
return


;----Display the menu
f_DisplayMenu:
  ; This next variable is used to record the title of the ative window when popup menu
  ; was called. This variable is then used in f_AddToFavorites: if user wants to save it.
  WinGetActiveTitle, f_addFavorite

  ; These first few variables are set here and used by f_OpenFavorite:
  WinGet, f_window_id, ID, A
  WinGetClass, f_class, ahk_id %f_window_id%
  If f_class in #32770,ExploreWClass,CabinetWClass  ; Dialog or Explorer.
    ControlGetPos, f_Edit1Pos,,,, Edit1, ahk_id %f_window_id%
  If f_AlwaysShowMenu = n  ; The menu should be shown only selectively.
  {
    If f_class in #32770,ExploreWClass,CabinetWClass  ; Dialog or Explorer.
    {
      If f_Edit1Pos =  ; The control doesn't exist, so don't display the menu
        return
    }
    else
    {                                                                   ;jh0105
      If f_class <> ConsoleWindowClass
      {                                                                 ;jh0105
         IfNotInString, f_class, bosa_sdm_  ; Microsoft Office application ;jh0105
            return  ; Since it's some other window type, don't display menu.
      }                                                                 ;jh0105
    }                                                                   ;jh0105
  }
  ; Otherwise, the menu should be presented for this type of window:
  gosub f_CreateMenu
  Menu, Favorites, show
return


;----Try to find a valid path from the active window title or the clipboard.
f_FindPath:
  ; First, test whole active window title as valid path.
  IfExist, %f_addFavorite%
  {
    GoSub, f_AddToFavorites
    return
  }

  ; Second, test clipboard contents for valid path.
  f_clipboard = %clipboard%
  IfExist, %f_clipboard%
  {
    f_addFavorite = %clipboard%
    GoSub, f_AddToFavorites
    return
  }

  ; Third, parse the Active window title for a valid path.
  f_index = 0
  f_goodPath = ; Initialize to blank
  ; Loop one character at a time. This is like "Loop, Count". It ensures
  ; we loop once for every character without having to find the string length.
  Loop, Parse, f_addFavorite
  {
    f_index++
    ; Keep adding characters from the right.
    StringRight, f_newPath, f_addFavorite, %f_index%
    ; Get rid of everything to the right of the last "\".
    SplitPath, f_newPath, , f_OutDir
    ; Only keep a path that is valid.
    IfExist, %f_OutDir%
      f_goodPath = %f_OutDir%
  }
  IfExist, %f_goodPath%
  {
    f_addFavorite = %f_goodPath%
    GoSub, f_AddToFavorites
    return
  }

  ; Report to user that no valid path was found.
  MsgBox, No valid path was found. The folder path to be added must be in the active window title or on the clipboard.  ;jh0105
return


;----Save found valid path to a new link file in f_shortcuts_folder.
f_AddToFavorites:
   ; Make a default shortcut name from the path.                         ;cm0205
   ; Replace ':' and '/' with spaces to make a legal filename.           ;cm0205
   StringReplace, f_shortName, f_addFavorite, :, %A_Space%, All          ;cm0205 
   StringReplace, f_shortName, f_shortName, \, %A_Space%, All            ;cm0205 
   ; Resize and display inputbox.
  StringLen, f_length, f_addFavorite
  f_length *= 8 
  If f_length < 340
    f_length = 340
  f_msg = Found: %f_addFavorite%`nWhat name would you like to give the Favorite shortcut
  InputBox, f_shortName, Favorite Name, %f_msg%, ,%f_length%, 140, , , , , %f_shortName% ;cm0205
  ; If OK was pressed, try to add menu item.
  If ErrorLevel = 0
  { 
    f_shortName = %f_shortName%  ; Trim leading and trailing spaces.
    If f_shortName =
    {
      MsgBox, You must supply a name for the shortcut.
      return
    }
    StringLower, f_test, f_shortName
    ; Loop thru existing menu items to check for duplicates.
    f_index = 0
    Loop, %f_MenuItemCount%
    {
      f_index++
      StringLower, f_nextMenu, f_MenuName%f_index%
      IfEqual f_nextMenu, %f_test%
      {
        MsgBox, The name %f_shortName% is already in the menu.`nTry again.
        return
      }
    }

    ; Here's where we save the menu item to file.
    FileCreateShortcut, %f_addFavorite%, %f_shortcuts_folder%\%f_shortName%.lnk
      ; If errorlevel is not 0 it's most likely %f_shortName%.lnk is not ;cm0205
      ; a legal filename.                                                ;cm0205
      ; Other possible problems are no write permissions, etc.           ;cm0205 
      if ErrorLevel <> 0                                                 ;cm0205
        MsgBox, The name %f_shortName% is not a legal filename.`nTry again. ;cm0205
      else                                                               ;cm0205
         MsgBox, The path %f_addFavorite% has been added to favorites.   ;cm0205
  }
return


;----Open explorer window to f_shortcuts_folder to allow user to edit the shortcuts.
f_EditFavorites:
  ; We always open explorer window to f_shortcuts_folder to allow editing.
  Run, Explorer %f_shortcuts_folder%
  Reload
return