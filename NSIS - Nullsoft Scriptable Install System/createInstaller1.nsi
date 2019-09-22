; Name of our application
Name "NSIS Example Application 1"

; The file to write
OutFile "Setup_NSISExampleApp1.exe"

; Set the default Installation Directory
InstallDir "$PROGRAMFILES\NSIS Example Application 1"

; Set the text which prompts the user to enter the installation directory
DirText "Please choose a directory to which you'd like to install this application."

; ----------------------------------------------------------------------------------
; *************************** SECTION FOR INSTALLING *******************************
; ----------------------------------------------------------------------------------

Section "" ; A "useful" name is not needed as we are not installing separate components

; Set output path to the installation directory. Also sets the working
; directory for shortcuts
SetOutPath $INSTDIR\

File NSISExampleApplication1.class
File NSISExampleApplication1.java
File readme.txt
File createInstaller1.nsi

WriteUninstaller $INSTDIR\Uninstall.exe

; ///////////////// CREATE SHORT CUTS //////////////////////////////////////

CreateDirectory "$SMPROGRAMS\NSIS Example Application 1"


CreateShortCut "$SMPROGRAMS\NSIS Example Application 1\Run NSIS Example Application 1.lnk" "$SYSDIR\javaw.exe" "NSISExampleApplication1"


CreateShortCut "$SMPROGRAMS\NSIS Example Application 1\Uninstall Example Application 1.lnk" "$INSTDIR\Uninstall.exe"

; ///////////////// END CREATING SHORTCUTS ////////////////////////////////// 

; //////// CREATE REGISTRY KEYS FOR ADD/REMOVE PROGRAMS IN CONTROL PANEL /////////

WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSIS Example Application 1" "DisplayName"\
"NSIS Example Application 1 (remove only)"

WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSIS Example Application 1" "UninstallString" \
"$INSTDIR\Uninstall.exe"

; //////////////////////// END CREATING REGISTRY KEYS ////////////////////////////

MessageBox MB_OK "Installation was successful."

SectionEnd

; ----------------------------------------------------------------------------------
; ************************** SECTION FOR UNINSTALLING ******************************
; ---------------------------------------------------------------------------------- 

Section "Uninstall"
; remove all the files and folders
Delete $INSTDIR\Uninstall.exe ; delete self
Delete $INSTDIR\NSISExampleApplication1.class
Delete $INSTDIR\NSISExampleApplication1.java
Delete $INSTDIR\readme.txt
Delete $INSTDIR\createInstaller1.nsi

RMDir $INSTDIR

; now remove all the startmenu links
Delete "$SMPROGRAMS\NSIS Example Application 1\Run NSIS Example Application 1.lnk"
Delete "$SMPROGRAMS\NSIS Example Application 1\Uninstall Example Application 1.lnk"
RMDIR "$SMPROGRAMS\NSIS Example Application 1"

; Now delete registry keys
DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\NSIS Example Application 1"
DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS Example Application 1"

SectionEnd
