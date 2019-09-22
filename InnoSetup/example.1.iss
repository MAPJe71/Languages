;-------------------------------------------------------------------------------
;    UninsHs - Example script
;    $Rev: 226 $   $Id: example.iss 226 2006-08-31 06:47:46Z hanjy $
;    Copyright(C) 2001, 2006 Han-soft Software. All rights reserved.
;-------------------------------------------------------------------------------

[Setup]
AppID = My_App
AppName = My Application
UninstallDisplayIcon = {app}\App.exe,0
UninstallDisplayName = Uninstall My Application

; For modify button in control panel
AppModifyPath ="{app}\UninsHs.exe" /m0=My_App

[Languages]
; Add these lines for multi-languages support
Name: en; MessagesFile: English.isl
Name: fr; MessagesFile: French.isl

[Components]
Name: main; Description: "Main"; Types: full compact custom; Flags: fixed

; For non-fixed components, Add DisableNoUninstallWarning flag
Name: extension; Description: "Extension"; Types: full compact; 
  Flags: DisableNoUninstallWarning
Name: help; Description: "Help"; Types: full; Flags: DisableNoUninstallWarning \

[Files]
Source: "F:\APP\App.exe"; DestDir: "{app}"; Components: main;
Source: "F:\APP\App.dll"; DestDir: "{app}"; Components: main;
Source: "F:\APP\AppExt.dll"; DestDir: "{app}"; Components: extension;
Source: "F:\APP\App.hlp"; DestDir: "{app}"; Components: help;
Source: "F:\APP\App.cnt"; DestDir: "{app}"; Components: help;
; Add the UninsHs.exe file
Source: "F:\APP\UninsHs.exe"; DestDir: "{app}"; Flags: restartreplace; \
  Components: main

[Dirs]
; Create folder for saving installation package
Name: "{userappdata}\$Inst$"; \
  Attribs: hidden; Flags: uninsalwaysuninstall

[Icons]
Name: {group}\My Application; Filename: "{app}\App.exe"; WorkingDir: "{app}"
Name: {group}\Help; Filename: "{app}\App.hlp"

; Add the line for uninstall menu item
Name: {group}\Uninstall My Application; \
  Filename: "{app}\UninsHs.exe"; WorkingDir: "{app}"; \
  Parameters: /u0=My_App

[InstallDelete]
; Delete all non-fixed component before repair
Type: filesandordirs; Name: "{app}\App.hlp"
Type: files; Name: "{app}\AppExt.dll"

[Run]
; Register UninsHs to control panel
Filename: "{app}\UninsHs.exe"; \
  Parameters: "/r0=My_App,{language},{srcexe},{userappdata}\$Inst$\Setup.exe"; \
  WorkingDir: "{app}"; Flags: runhidden runminimized skipifdoesntexist

[UninstallDelete]
; Delete the installation file
Type: files; Name: "{userappdata}\$Inst$\Setup.exe"
; Delete the installation folder
Type: dirifempty; Name: "{userappdata}\$Inst$"

[Code]
{For UninsHs; Skip some wizard page when repair}
function ShouldSkipPage(CurPage: Integer): Boolean;
begin
  if Pos('/SP-', UpperCase(GetCmdTail)) > 0 then
    case CurPage of
      wpLicense, wpPassword, wpInfoBefore,
      UserPage.Id,
      wpUserInfo, wpSelectDir, wpSelectProgramGroup, wpInfoAfter:
        Result := True;
    end;
end;

