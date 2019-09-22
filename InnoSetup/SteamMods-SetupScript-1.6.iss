
[##########################################################]
[###                                                    ###]
[###   LOGAN's STEAM APPS, MODS & MAPS INSTALLER v1.6   ###]
[###                                                    ###]
[##########################################################]

[ DESCRIPTION ] - READ ONLY
;; This script was created to make setup for Valve's Steam Apps, Mods and Maps.

[ FEATURES ] - READ ONLY
;; Many Installer Languages
;; Automatic check if Valve's Steam.exe is installed.
;; Automatic SteamApps Folder Check
;; Launch game option (only for SourceMods)
;; Startmenu entry with uninstall option
;; optional desktop icon and quicklaunch icon (only for SourceMods)
;; Skips select dir and programgroup pages
;; Adds beveled label: <ModName> (c) <Year> <ModPublisher>


[ START MOD SETUP ] - Change the details according to your own MOD or MAP-Pack

;//; MOD or map pack Name used by Setup
#define ModName "SourceForts"

;//; OPTIONAL: MOD Subfolder name ;; Defaults to ModName
#define ModSubDir "sourceforts"

;//; MOD Version number
#define ModVersion "1.4.2"

;//; MOD Publisher name
#define ModPublisher "SourceForts Mod Team"

;//; MOD Website URL
#define ModURL "http://www.sourcefortsmod.com/"

;//; Folder that contains all the files that should be installed in the MOD or maps subfolder ;//; For example: "C:\MyFolder\MyMod"
#define ModFilesPath ModName+"-"+ModVersion

;//; OPTIONAL: Type of install ;; Valid Entries: "SourceMod"(Default),"SourceModMap","CS:SourceMap","HL2:DeathMatchMap","HalfLifeMod","HalfLifeModMap"
;#define ModInstallType "SourceMod"

;//; OPTIONAL: Defaults to ModName
;#define ModID "SourceForts"

;//; REQUIRED: ISSI folder location
#define ISSI_IncludePath "C:\ISSI"



[ ISSI WIZARD IMAGES ] - Customize your setup with images
#define ISSI_BackgroundImage "screen11.bmp"
#define ISSI_WizardImageFile "164x314.bmp"
#define ISSI_WizardImageFile_x 164
#define ISSI_WizardSmallImageFile "112x58.bmp"
#define ISSI_WizardSmallImageFile_x 112

[ ISSI LANGUAGES ] - Select which languages should be added to the compiled setup.exe
#define ISSI_Bosnian
#define ISSI_Catalan
#define ISSI_Czech
#define ISSI_Danish
#define ISSI_Dutch
#define ISSI_English
#define ISSI_French
#define ISSI_German
#define ISSI_Hungarian
#define ISSI_Italian
#define ISSI_Norwegian
#define ISSI_Polish
#define ISSI_Russian
#define ISSI_Slovenian
#define ISSI_Swedish
#define ISSI_BrazilianPortuguese

[##########################################################]

[ REVISION HISTORY ] - READ ONLY
[v1.6] - Added documentation and information
[v1.5] - Added if file exists check for Source.exe (else "Steam is not installed" error)
[v1.4] - Added Launch Source Mod option at end of setup
[v1.3] - Added Optional Desktop Icon and QuickLaunch Icons to Launch Source Mod
[v1.2] - Added Launch Source Mod option in Start Menu
[v1.1] - Added folder autodetection for Mods and Maps
[v1.0] - Added folder autodetection of SourceMod
[v0.0] - Initial Release

[ CREDITS ] - READ ONLY
;; Concept & Initial scripting : Jan 'LOGAN' Albartus ( albartus [AT] home [DOT] nl )

[ SYSTEM REQUIREMENTS ] - READ ONLY
;; Inno Setup Quick Start Pack                ;; http://files.jrsoftware.org/ispack/
;; LOGAN's Inno Setup Script Includes (ISSI)  ;; http://www.albartus.com/issi/

[ RELATED LINKS ] - READ ONLY
;; Valve's Steam, HalfLife & Source           ;; http://www.steampowered.com/
;; Map Central Network                        ;; http://www.mapcentralnetwork.com/

[ TO DO ] - READ ONLY
;; Launch HalfLife Mod (Details needed)

[##########################################################]

[ ISSI ] - READ ONLY
#ifdef ModUrl
  #define ISSI_URL ModURL
  #define ISSI_UrlText "{cm:ProgramOnTheWeb,"+ModName+"}"
#endif

#define ISSI_Compression
#include ISSI_IncludePath+"\_issi.isi"

[Messages]
BeveledLabel={#ModName} © {#ISSI_LongYear} {#ModPublisher}


[ MOD SECTION ] - READ ONLY
#ifdef ModName

  #ifndef ModId
    #define ModId ModName
  #endif

  #ifndef ModSubDir
    #define ModSubDir ModName
  #endif

  #ifndef ModInstallType
    #define ModInstallType "SourceMod"
  #endif

[Files]
  Source: "{#ModFilesPath}\*.*"; DestDir: "{app}"; Flags: ignoreVersion recursesubdirs

[Setup]
  AppID={#ModId}
  AppName={#ModName}
  AppVerName={cm:NameAndVersion,{#ModName},{#ModVersion}}
  AppPublisher={#ModPublisher}
  AppCopyright={#ModPublisher}
  VersionInfoCompany={#ModPublisher}
  VersionInfoVersion={#ModVersion}
  VersionInfoTextVersion={#ModVersion}
  AppVersion={#ModVersion}
  AppPublisherURL={#ModURL}
  AppSupportURL={#ModURL}
  AppUpdatesURL={#ModURL}
  OutputBaseFileName={#ModName}-{#ModVersion}-Setup
  VersionInfoDescription={#ModName} v{#ModVersion} Setup
  DefaultGroupName={#ModName}
  OutputDir={#SourcePath}
  DirExistsWarning=no
  DisableDirPage=yes
  DisableProgramGroupPage=yes
  DisableReadyMemo=yes
  DisableReadyPage=yes

  #if ModInstallType == "SourceMod"
    DefaultDirName={reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}
  #endif

  #if ModInstallType == "SourceModMap"
    DefaultDirName={reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}\maps
  #endif

  #if ModInstallType == "CS:SourceMap"
    DefaultDirName={reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\..\counter-strike source\cstrike\maps
  #endif

  #if ModInstallType == "HL2:DeathMatchMap"
    DefaultDirName={reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\..\half-life 2 deathmatch\hl2mp\maps
  #endif

  #if ModInstallType == "HalfLifeMod"
    DefaultDirName={reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\{#ModSubDir}
  #endif

  #if ModInstallType == "HalfLifeModMap"
    DefaultDirName={reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\{#ModSubDir}\maps
  #endif


[Tasks]
  #if ModInstallType == "SourceMod"
    Name: desktopicon; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
    Name: quicklaunchicon; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
  #endif
[Icons]
  #if ModInstallType == "SourceMod"
    Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#ModName}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch 320 -game ""{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}"""; Tasks: quicklaunchicon
    Name: "{userdesktop}\{#ModName}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch 320 -game ""{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}"""; Tasks: desktopicon
    Name: "{group}\{cm:LaunchProgram,{#ModName}}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch 320 -game ""{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}""";
  #endif

  Name: "{group}\{cm:ProgramOnTheWeb,{#ModName}}"; Filename: "{#ModURL}"
  Name: "{group}\{cm:UninstallProgram,{#ModName}}"; Filename: "{uninstallexe}"

[Run]
  #if ModInstallType == "SourceMod"
    Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch 320 -game ""{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}"""; Description: "{cm:LaunchProgram,{#ModName}}"; Flags: postinstall nowait skipifsilent unchecked
  #endif

[Code]
  function InitializeSetup(): Boolean;
  var
  mySteamExe          : String;
  begin
      Result := True;
      RegQueryStringValue( HKCU,'Software\Valve\Steam','SteamExe',mySteamExe );
    if not fileexists(mySteamExe) then
      begin
        MsgBox( ExpandConstant('{cm:IssiTxtProdNotInstalled,Steam}'), mbInformation, MB_OK );
        Result := False;
     end;
  end;

#endif ;; ModName

