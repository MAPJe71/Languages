
;; The Inno Setup PreProccessor is very usefull to pre-proccess some variables into place
;; avoiding changing several parts of the script for only a version change, for example.
;;
;; This file hopes to give you a practical example how to use the ISPP in your own Setup
;; scripts. We start by defining the base application variables

[ISPP]
#define AppName "PreProcessor Example"
#define AppVersion "1.2"
#define AppPublisher "albartus.com"
#define AppURL "http://www.albartus.com"

;; These variables can now be used with the rest of your script for all those optons setup
;; section seems to offer. Some default to an enty with the same value but I think I noticed
;; how VersionInfoVersion does not default to AppVersion.
;; When using the variable in any native Inno Setup section, it uses {#...} to indicate the ISPP
;; #define AppName => {#AppName}


;; Some default [CustomMessages] provide a range of usefull prefab texts.

; {cm:AssocFileExtension,{#AppName},{#AppExt}}
; {cm:AssocingFileExtension,{#AppName},{#AppExt}}
; {cm:NameAndVersion,{#AppName},{#AppVersion}}
; {cm:UninstallProgram,{#AppName}}
; {cm:ProgramOnTheWeb,{#AppName}}
; {cm:LaunchProgram,{#AppName}}
; {cm:AdditionalIcons}
; {cm:CreateDesktopIcon}
; {cm:CreateQuickLaunchIcon}

[Setup]
AppName={#AppName}
AppVerName={cm:NameAndVersion,{#AppName},{#AppVersion}}
AppPublisher={#AppPublisher}
AppCopyright={#AppPublisher}
VersionInfoCompany={#AppPublisher}
VersionInfoVersion={#AppVersion}
VersionInfoTextVersion={#AppVersion}
AppVersion={#AppVersion}
AppPublisherURL={#AppUrl}
AppSupportURL={#AppUrl}
AppUpdatesURL={#AppUrl}
OutputBaseFileName={#AppName} Setup
VersionInfoDescription={#AppName} v{#AppVersion} Setup
DefaultDirName={pf}\{#AppName}
DefaultGroupName={#AppPublisher}\{#AppName}

[Icons]
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
Name: "{group}\{cm:ProgramOnTheWeb,{#AppName}}"; Filename: "{#AppUrl}"
Name: "{group}\{cm:LaunchProgram,{#AppName}}"; Filename: "{app}\myApp.exe"


[ISSI]
;#define ISSI_English
#define ISSI_Update AppName
#define ISSI_UpdateTitle AppName
#include "C:\ISSI\_issi.isi"


