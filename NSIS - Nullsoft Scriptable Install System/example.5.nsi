; We are using the Modern User Interface
!include "MUI2.nsh"

; Put you own information here
!define MUI_PRODUCT "Your Product"
!define MUI_VERSION "1.00"
!define MUI_PUBLISHER "Your Company"

; The name of the installer
Name "${MUI_PRODUCT}"

; The filename of the installer
OutFile "${MUI_PRODUCT} installer.exe"

RequestExecutionLevel admin

; The directory where the files will be installed
; The installer let's the user change this
InstallDir "$PROGRAMFILES\${MUI_PRODUCT}"

; Registry key for the install dir
InstallDirRegKey HKLM "Software\${MUI_PRODUCT}" ""

;Interface Settings
!define MUI_ABORTWARNING 

; Installer pages
!insertmacro MUI_PAGE_WELCOME

; The path on line below is relative to nsi-file you have created
!insertmacro MUI_PAGE_LICENSE "doc\License.rtf"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION LaunchApplication
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; Language 
!insertmacro MUI_LANGUAGE "English"
 
Section "${MUI_PRODUCT} (required)" SecProduct

  ; Read only section
  ; This section can't be unchecked from the interface
  SectionIn RO
 
  SetOutPath "$INSTDIR" ; files will be installed here

  
  ; Recursively add all the files from "publish" directory
  ; The path of the "publish" is relative to the path
  ; of the nsi-file you have created
  File /r "publish\*.*"
  
  ; The following creates the uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ; Registry key for the installed product
  WriteRegStr HKLM "Software\${MUI_PRODUCT}" "$INSTDIR" ""

SectionEnd

Section "Start Menu Shortcuts" secStartMenuShortcuts

  ; Install for the current user
  SetShellVarContext all

  CreateDirectory "$SMPROGRAMS\${MUI_PRODUCT}"
  CreateShortCut "$SMPROGRAMS\${MUI_PRODUCT}\${MUI_PRODUCT}.lnk" "$INSTDIR\${MUI_PRODUCT}.exe"
  CreateShortCut "$SMPROGRAMS\${MUI_PRODUCT}\Uninstall.lnk" "$INSTDIR\Uninstall.exe"

SectionEnd

Section "Desktop shortcut" secDesktopShortcut

  SetShellVarContext all

  CreateShortCut "$DESKTOP\${MUI_PRODUCT}.lnk" "$INSTDIR\${MUI_PRODUCT}.exe"

SectionEnd

; Descriptions for installing
  LangString DESC_SecProduct ${LANG_ENGLISH} "${MUI_PRODUCT} files and uninstaller"
  LangString DESC_SecStartMenuShortcuts ${LANG_ENGLISH} "Creates Start Menu Folder"
  LangString DESC_SecDesktopShortcut ${LANG_ENGLISH} "Creates desktop icon"

; Put the descriptions
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecProduct} $(DESC_SecProduct)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenuShortcuts} $(DESC_SecStartMenuShortcuts)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktopShortcut} $(DESC_SecDesktopShortcut)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
  
Section "Uninstall"
  
  SetShellVarContext all

  ; Delete files and directories
  ; An unempty directory cannot be deleted

  Delete "$INSTDIR\*.*"
  RMDir "$INSTDIR"
  
  Delete "$SMPROGRAMS\${MUI_PRODUCT}\*.*"
  RMDir "$SMPROGRAMS\${MUI_PRODUCT}"
 
  Delete "$DESKTOP\${MUI_PRODUCT}.lnk"

  ; If the reg key has no subkeys,
  ; it will be deleted
  DeleteRegKey /ifempty HKLM "Software\${MUI_PRODUCT}"
  DeleteRegKey /ifempty HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}"

SectionEnd

Function .onInstSuccess

  ; Registry key information for the Control Add/Remove Programs of Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "DisplayName" "${MUI_PRODUCT}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "InstallLocation" "$INSTDIR"

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "Publisher" "${MUI_PUBLISHER}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "RegOwner" "${MUI_PUBLISHER}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "DisplayVersion" "${MUI_VERSION}"
  
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "UninstallString" "$INSTDIR\Uninstall.exe"

FunctionEnd

; Function to launch the application,
; when the installing is finished
Function LaunchApplication
  ; If needed, change the filename
  ExecShell "" "$INSTDIR\${MUI_PRODUCT}.exe"
FunctionEnd
