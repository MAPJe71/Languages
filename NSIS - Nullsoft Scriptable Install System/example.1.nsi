; Define the application name
!define APPNAME "Notepad++"
!define APPNAMEANDVERSION "Notepad++ v3.3"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\Notepad++"
InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "npp.3.3.Installer.exe"


; Modern interface settings
!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN "$INSTDIR\notepad++.exe"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\license.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Set languages (first is default language)
;!insertmacro MUI_LANGUAGE "English"

;Languages

  !insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "TradChinese"
  !insertmacro MUI_LANGUAGE "Spanish"
  !insertmacro MUI_LANGUAGE "Hungarian"
  !insertmacro MUI_LANGUAGE "Russian"
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "Dutch"
  !insertmacro MUI_LANGUAGE "SimpChinese"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Danish"
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Czech"
  !insertmacro MUI_LANGUAGE "Slovenian"
  !insertmacro MUI_LANGUAGE "Slovak"
  !insertmacro MUI_LANGUAGE "Swedish"
  !insertmacro MUI_LANGUAGE "Norwegian"
  !insertmacro MUI_LANGUAGE "PortugueseBR"
  !insertmacro MUI_LANGUAGE "Ukrainian"
  !insertmacro MUI_LANGUAGE "Turkish"
  !insertmacro MUI_LANGUAGE "Catalan"
  !insertmacro MUI_LANGUAGE "Arabic"
  !insertmacro MUI_LANGUAGE "Lithuanian"
  !insertmacro MUI_LANGUAGE "Finnish"
  !insertmacro MUI_LANGUAGE "Greek"
  !insertmacro MUI_LANGUAGE "Romanian"
  !insertmacro MUI_LANGUAGE "Korean"
  !insertmacro MUI_LANGUAGE "Hebrew"
  !insertmacro MUI_LANGUAGE "Portuguese"
  !insertmacro MUI_LANGUAGE "Farsi"
  !insertmacro MUI_LANGUAGE "Bulgarian"
  !insertmacro MUI_LANGUAGE "Indonesian"
  !insertmacro MUI_LANGUAGE "Japanese"
  !insertmacro MUI_LANGUAGE "Croatian"

  ;!insertmacro MUI_LANGUAGE "Thai"
  ;!insertmacro MUI_LANGUAGE "Latvian"
  ;!insertmacro MUI_LANGUAGE "Macedonian"
  ;!insertmacro MUI_LANGUAGE "Estonian"
  ;!insertmacro MUI_LANGUAGE "Serbian"
  ;

!insertmacro MUI_RESERVEFILE_LANGDLL

;Installer Functions


Function .onInit

  !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

LangString langFileName ${LANG_ENGLISH} "english.xml"
LangString langFileName ${LANG_FRENCH} "french.xml"
LangString langFileName ${LANG_TRADCHINESE} "chinese.xml"
LangString langFileName ${LANG_GERMAN} "german.xml"
LangString langFileName ${LANG_SPANISH} "spanish.xml"
LangString langFileName ${LANG_HUNGARIAN} "hungarian.xml"
LangString langFileName ${LANG_RUSSIAN} "russian.xml"
LangString langFileName ${LANG_DUTCH} "dutch.xml"
LangString langFileName ${LANG_SIMPCHINESE} "chineseSimplified.xml"
LangString langFileName ${LANG_ITALIAN} "italian.xml"
LangString langFileName ${LANG_DANISH} "danish.xml"
LangString langFileName ${LANG_POLISH} "polish.xml"
LangString langFileName ${LANG_CZECH} "czech.xml"
LangString langFileName ${LANG_SLOVENIAN} "slovenian.xml"
LangString langFileName ${LANG_SLOVAK} "slovak.xml"
LangString langFileName ${LANG_SWEDISH} "swedish.xml"
LangString langFileName ${LANG_NORWEGIAN} "norwegian.xml"
LangString langFileName ${LANG_PORTUGUESEBR} "brazilian_portuguese.xml"
LangString langFileName ${LANG_UKRAINIAN} "ukrainian.xml"
LangString langFileName ${LANG_TURKISH} "turkish.xml"
LangString langFileName ${LANG_CATALAN} "catalan.xml"
LangString langFileName ${LANG_ARABIC} "arabic.xml"
LangString langFileName ${LANG_LITHUANIAN} "lithuanian.xml"
LangString langFileName ${LANG_FINNISH} "finnish.xml"
LangString langFileName ${LANG_GREEK} "greek.xml"
LangString langFileName ${LANG_ROMANIAN} "romanian.xml"
LangString langFileName ${LANG_KOREAN} "korean.xml"
LangString langFileName ${LANG_HEBREW} "hebrew.xml"
LangString langFileName ${LANG_PORTUGUESE} "portuguese.xml"
LangString langFileName ${LANG_FARSI} "farsi.xml"
LangString langFileName ${LANG_BULGARIAN} "bulgarian.xml"
LangString langFileName ${LANG_INDONESIAN} "indonesian.xml"
LangString langFileName ${LANG_JAPANESE} "japanese.xml"
LangString langFileName ${LANG_CROATIAN} "croatian.xml"

;--------------------------------
;Variables
  Var IS_LOCAL
;--------------------------------

Section /o "Don't use %APPDATA%" makeLocal
    StrCpy $IS_LOCAL "1"
SectionEnd

Var UPDATE_PATH

Section -"Notepad++" mainSection

    ; Set Section properties
    SetOverwrite on

    StrCpy $UPDATE_PATH $INSTDIR

    SetOutPath "$TEMP\"
    File "xmlUpdater.exe"

    SetOutPath "$INSTDIR\"

    ; if isLocal -> copy file "doLocalConf.xml"
    StrCmp $IS_LOCAL "1" 0 IS_NOT_LOCAL
        File "doLocalConf.xml"
        goto LANGS_XML

IS_NOT_LOCAL:
    IfFileExists $INSTDIR\doLocalConf.xml 0 +2
        Delete $INSTDIR\doLocalConf.xml

    StrCpy $UPDATE_PATH "$APPDATA\Notepad++"

LANGS_XML:
    IfFileExists $INSTDIR\langs.xml 0 COPY_LANGS_XML
        SetOutPath "$TEMP\"
        File "langsModel.xml"
        File "langs.xml"
        ;UPGRATE $INSTDIR\langs.xml
        ExecWait '"$TEMP\xmlUpdater.exe" "-silent" "$TEMP\langsModel.xml" "$TEMP\langs.xml" "$INSTDIR\langs.xml"' $0
        StrCmp $0 "0" 0 COPY_LANGS_XML

        goto CONFIG_XML
COPY_LANGS_XML:
    SetOutPath "$INSTDIR\"
    File "langs.xml"

CONFIG_XML:
    IfFileExists $UPDATE_PATH\config.xml 0 COPY_CONFIG_XML
        SetOutPath "$TEMP\"
        File "configModel.xml"
        File "config.xml"
        ExecWait '"$TEMP\xmlUpdater.exe" "-silent" "$TEMP\configModel.xml" "$TEMP\config.xml" "$UPDATE_PATH\config.xml"' $0
        StrCmp $0 "0" 0 COPY_CONFIG_XML
        goto STYLES_XML
COPY_CONFIG_XML:
    SetOutPath "$INSTDIR\"
    File "config.xml"

STYLES_XML:
    IfFileExists $UPDATE_PATH\stylers.xml 0 COPY_STYLERS_XML
        SetOutPath "$TEMP\"
        File "stylesLexerModel.xml"
        File "stylesGlobalModel.xml"
        File "stylers.xml"
        ExecWait '"$TEMP\xmlUpdater.exe" "-silent" "$TEMP\stylesLexerModel.xml" "$TEMP\stylers.xml" "$UPDATE_PATH\stylers.xml"'
        StrCmp $0 "0" 0 COPY_STYLERS_XML
        ExecWait '"$TEMP\xmlUpdater.exe" "-silent" "$TEMP\stylesGlobalModel.xml" "$TEMP\stylers.xml" "$UPDATE_PATH\stylers.xml"'
        StrCmp $0 "0" 0 COPY_STYLERS_XML
        goto ALL_XML
COPY_STYLERS_XML:
    SetOutPath "$INSTDIR\"
    File "stylers.xml"

ALL_XML:
    ; Set Section Files and Shortcuts
    SetOutPath "$INSTDIR\"
    SetOverwrite on
    File "..\license.txt"
    File "LINEDRAW.TTF"
    File "SciLexer.dll"
    File "change.log"
    File "notepad++.exe"
    File "readme.txt"

    SetOutPath "$UPDATE_PATH\"
    SetOverwrite off
    File "contextMenu.xml"
    File "shortcuts.xml"

    SetOverwrite on

    StrCmp $LANGUAGE ${LANG_ENGLISH} noLang 0
    StrCmp $LANGUAGE ${LANG_FRENCH} 0 +3
        File ".\nativeLang\french.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_TRADCHINESE} 0 +3
        File ".\nativeLang\chinese.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_SPANISH} 0 +3
        File ".\nativeLang\spanish.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_HUNGARIAN} 0 +3
        File ".\nativeLang\hungarian.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_RUSSIAN} 0 +3
        File ".\nativeLang\russian.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_GERMAN} 0 +3
        File ".\nativeLang\german.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_DUTCH} 0 +3
        File ".\nativeLang\dutch.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_SIMPCHINESE} 0 +3
        File ".\nativeLang\chineseSimplified.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_ITALIAN} 0 +3
        File ".\nativeLang\italian.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_DANISH} 0 +3
        File ".\nativeLang\danish.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_POLISH} 0 +3
        File ".\nativeLang\polish.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_CZECH} 0 +3
        File ".\nativeLang\czech.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_SLOVENIAN} 0 +3
        File ".\nativeLang\slovenian.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_SLOVAK} 0 +3
        File ".\nativeLang\slovak.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_SWEDISH} 0 +3
        File ".\nativeLang\swedish.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_NORWEGIAN} 0 +3
        File ".\nativeLang\norwegian.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_PORTUGUESEBR} 0 +3
        File ".\nativeLang\brazilian_portuguese.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_UKRAINIAN} 0 +3
        File ".\nativeLang\ukrainian.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_TURKISH} 0 +3
        File ".\nativeLang\turkish.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_CATALAN} 0 +3
        File ".\nativeLang\catalan.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_ARABIC} 0 +3
        File ".\nativeLang\arabic.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_LITHUANIAN} 0 +3
        File ".\nativeLang\lithuanian.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_FINNISH} 0 +3
        File ".\nativeLang\finnish.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_GREEK} 0 +3
        File ".\nativeLang\greek.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_ROMANIAN} 0 +3
        File ".\nativeLang\romanian.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_KOREAN} 0 +3
        File ".\nativeLang\korean.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_HEBREW} 0 +3
        File ".\nativeLang\hebrew.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_PORTUGUESE} 0 +3
        File ".\nativeLang\portuguese.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_FARSI} 0 +3
        File ".\nativeLang\farsi.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_BULGARIAN} 0 +3
        File ".\nativeLang\bulgarian.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_INDONESIAN} 0 +3
        File ".\nativeLang\indonesian.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_JAPANESE} 0 +3
        File ".\nativeLang\japanese.xml"
        Goto finLang
    StrCmp $LANGUAGE ${LANG_CROATIAN} 0 +3
        File ".\nativeLang\croatian.xml"
        Goto finLang
    finLang:

    ; for v3.2 -> v3.3
    IfFileExists "$INSTDIR\plugins\NppInsertPlugin.dll" 0 +2
        Delete "$INSTDIR\plugins\NppInsertPlugin.dll"

    IfFileExists "$UPDATE_PATH\nativeLang.xml" 0 +2
        Delete "$UPDATE_PATH\nativeLang.xml"

    Rename "$UPDATE_PATH\$(langFileName)" "$UPDATE_PATH\nativeLang.xml"
    Goto commun

    noLang:
    IfFileExists "$UPDATE_PATH\nativeLang.xml" 0 +2
        Delete "$UPDATE_PATH\nativeLang.xml"

    commun:
    CreateShortCut "$DESKTOP\Notepad++.lnk" "$INSTDIR\notepad++.exe"
    CreateDirectory "$SMPROGRAMS\Notepad++"
    CreateShortCut "$SMPROGRAMS\Notepad++\Notepad++.lnk" "$INSTDIR\notepad++.exe"
    CreateShortCut "$SMPROGRAMS\Notepad++\Uninstall.lnk" "$INSTDIR\uninstall.exe"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\notepad++.exe" "" "$INSTDIR\notepad++.exe"

SectionEnd

Section "As default html viewer" htmlViewer
    SetOutPath "$INSTDIR\"
    File "nppIExplorerShell.exe"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Internet Explorer\View Source Editor\Editor Name" "" "$INSTDIR\nppIExplorerShell.exe"
SectionEnd


;--------------------------------
;Descriptions

  ;Language strings

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${makeLocal} 'Enable this option to make Notepad++ load/write the configuration files from/to its install directory. Check it if you use Notepad++ in an USB device.'
    !insertmacro MUI_DESCRIPTION_TEXT ${autoCompletionComponent} 'Install the API files you need for the auto-completion feature (Ctrl+Space).'
    !insertmacro MUI_DESCRIPTION_TEXT ${Plugins} 'You may need those plugins to extend the capacity of Notepad++.'
    !insertmacro MUI_DESCRIPTION_TEXT ${htmlViewer} 'Open the html file in Notepad++ while you choose <view source> from IE.'
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------

Section -FinishSection

    WriteRegStr HKLM "Software\${APPNAME}" "" "$INSTDIR"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$INSTDIR\uninstall.exe"
    WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd


;Uninstall section

Section Uninstall

    ;Remove from registry...
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
    DeleteRegKey HKLM "SOFTWARE\${APPNAME}"
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\notepad++.exe"

    ; Delete self
    Delete "$INSTDIR\uninstall.exe"

    ; Delete Shortcuts
    Delete "$DESKTOP\Notepad++.lnk"
    Delete "$SMPROGRAMS\Notepad++\Notepad++.lnk"
    Delete "$SMPROGRAMS\Notepad++\Uninstall.lnk"

    ; Clean up Notepad++
    Delete "$INSTDIR\LINEDRAW.TTF"
    Delete "$INSTDIR\SciLexer.dll"
    Delete "$INSTDIR\change.log"
    Delete "$INSTDIR\license.txt"

    Delete "$INSTDIR\notepad++.exe"
    Delete "$INSTDIR\readme.txt"
    Delete "$INSTDIR\nppIExplorerShell.xml"

    ;Delete "$INSTDIR\config.xml"
    ;Delete "$INSTDIR\langs.xml"
    ;Delete "$INSTDIR\stylers.xml"

    ;Delete "$APPDATA\Notepad++\stylers.xml"
    ;Delete "$APPDATA\Notepad++\config.xml"
    ;Delete "$APPDATA\contextMenu.xml"
    ;Delete "$APPDATA\shortcuts.xml"

    Delete "$APPDATA\Notepad++\nativeLang.xml"
    Delete "$INSTDIR\nativeLang.xml"

    ; Remove remaining directories
    RMDir "$SMPROGRAMS\Notepad++"
    RMDir "$INSTDIR\"
    RMDir "$APPDATA\Notepad++"

SectionEnd
;--------------------------------
;Uninstaller Functions
Section un.htmlViewer
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Internet Explorer\View Source Editor"
SectionEnd

;Section un.contextMenu
;   DeleteRegKey HKCR "*\shell\Notepad++"
;SectionEnd


Function un.onInit

  !insertmacro MUI_UNGETLANGUAGE

FunctionEnd

Function "1 onInit"

  !insertmacro MUI_UNGETLANGUAGE

FunctionEnd

Section "3 onInit"

  !insertmacro MUI_UNGETLANGUAGE

SectionEnd


BrandingText "Don HO"

; eof
