

; Define your application name
!define APPNAME "easyHttp"
!define APPNAMEANDVERSION "easyHttp"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$INSTDIR"
OutFile "./trunk/easyHttpInstaller.exe"

; Include LogicLibrary
!include "LogicLib.nsh"

; Modern interface settings
!include "MUI2.nsh"

!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_WELCOME

!define MUI_DIRECTORYPAGE_VARIABLE $INSTDIR
!define MUI_DIRECTORYPAGE_TEXT_TOP "Where would you like to install easyHttp? I suggest you put it into ~\My Documents\Wavemetrics\Igor Pro 6 User Files\Igor Extensions\ but it's up to you."
!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_RESERVEFILE_LANGDLL

Section "easyHttp" Section1

; Set Section properties
SetOverwrite on

ReadRegStr $1 HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Igor.exe" "Path"
StrLen $0 $1
${If} $0 = 0
Abort "You don't appear to have IGOR installed"
${EndIf}

SetOutPath "$INSTDIR\Igor Extensions"
File "./trunk/win/easyHttp.xop"
File "./trunk/win/easyHttp Help.ihf"

SectionEnd

Function .onInit
ReadRegStr $1 HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Igor.exe" "Path"
StrLen $0 $1
${If} $0 = 0
Abort "You don't appear to have IGOR installed"
${EndIf}
StrCpy $INSTDIR "$DOCUMENTS\Wavemetrics\Igor Pro 6 User Files\"
FunctionEnd

; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${Section1} ""
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; eof