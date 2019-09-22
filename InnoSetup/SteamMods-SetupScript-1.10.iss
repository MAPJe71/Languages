
[#####################################################]
[###                                               ###]
[###   LOGAN's STEAM MODS & MAPS INSTALLER v1.10   ###]
[###                                               ###]
[#####################################################]

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

[ NOTES ]
;; SourceMods (often) equals HL2:DeathMatch Mod
;; Some Mod's also use the root folder and the named subfolder. This script is not configured to deal with that.

[ START MOD SETUP ] - Change the details according to your own MOD or MAP-Pack
;#define Setup "SourceForts"
#define Setup "PongSource"

#if Setup = "SourceForts"

  #define ModName "SourceForts"
  ;; ModID is also Folder Name
  #define ModID "SourceForts"
  #define ModVersion "1.4.2"
  #define ModPublisher "SourceForts Mod Team"
  #define ModURL "http://www.sourcefortsmod.com/"
  #define ModSubDir "sourceforts"
  ;; Type of install ;; Valid Entries: "HL2Mod" (Default),"HL2ModMap"(SteamAppId 220)
  ;; "HL2:DeathMatchMap", "HL2:DeathMatchMod", "HL2:DeathMatchModMap" (SteamAppId 320)
  ;; "CS:SourceMod", "CS:SourceModMap", "CS:SourceMap"(SteamAppId 240)
  #define ModInstallType "HL2:DeathMatchMod"

  ;; Define an ICON that will be used to create desktop icon (also through steam)
  ;; If not #defined it will default to the {#ModFilesPath}\resource\game.ico if present
  ;#define ModIconFile "C:\folder\myicon.ico"

  ;; Defaults to ModName
  ;#define ModID "SourceForts"

  #define ModProgramGroup

#endif

#if Setup = "PongSource"

  #define ModName "PongSource"
  #define ModSubDir "PongSource"
  #define ModID "PongSource"
  #define ModVersion "0.8"
  #define ModPublisher "Clan-Server.co.uk"
  #define ModURL "http://www.clan-server.co.uk/pongsource/"

  ;; Type of install ;; Valid Entries: "HL2Mod" (Default),"HL2ModMap"(SteamAppId 220)
  ;; "HL2:DeathMatchMap", "HL2:DeathMatchMod", "HL2:DeathMatchModMap" (SteamAppId 320)
  ;; "CS:SourceMod", "CS:SourceModMap", "CS:SourceMap"(SteamAppId 240)
  #define ModInstallType "HL2:DeathMatchMod"

  ;; Define an ICON that will be used to create desktop icon (also through steam)
  ;; If not #defined it will default to the {#ModFilesPath}\resource\game.ico if present
  ;#define ModIconFile "C:\folder\myicon.ico"

  ;; Defaults to ModName
  ;#define ModID "SourceForts"

  #define ModProgramGroup

#endif

;; Because the previous installation dir when using update is reverted to previous install, the appDir of MapPacks is the root of the Mod:
;; The \maps is appended in the files DestDir
;; set update Name (Uses ISSI_Update)
;//; undefined  --> Setup does not check existing installation
;//; #define ModUpdateName --> "ModName" as default
;#define ModUpdateName "SourceForts"

;; set update ID (Uses ISSI_Update)
;//; undefined  --> "ModID or ModName" as default
;//; #define ModUpdateID --> "ModID" as default
;#define ModUpdateID "SourceForts"

#define ModFilesPath "E:\_Setup_Projects\Mods&Maps\"+ModName+"-"+ModVersion

[REQUIRED]
;; ISSI folder location
#define ISSI_IncludePath "C:\ISSI"

[ ISSI ] - Customize your setup with images
;;#define ISSI_BackgroundImage "E:\_Setup_Projects\"+ModName+"\screen11.bmp"
;;#define ISSI_WizardImageFile "E:\_Setup_Projects\"+ModName+"\164x314.bmp"
;;#define ISSI_WizardImageFile_x 164
;;#define ISSI_WizardSmallImageFile "E:\_Setup_Projects\"+ModName+"\112x58.bmp"
;;#define ISSI_WizardSmallImageFile_x 112

[ ISSI ]
#define ISSI_English
;#define ISSI_Languages
;#define ISSI_Compression

[##########################################################]

[ REVISION HISTORY ] - READ ONLY

[v1.9]
[o]

[v1.8]
[o] Added seperate support for HL2Mod (220), CS:SourceMod (240) and HL2DeathMatchMod (320) Steam Start ID's
[o] HalfLife Mod Launch realized (additional AppLaunch numbers found)
[o] Create Desktop Icon from steam Start Menu now shows game icon (if available in resource\game.ico or defined through #ModIconFile)

[v1.7]
[o] Show Program Group and ready to install pages to avoid confusion
[o] Added optional ModProgramGroup
[o] Added uninstallDelete to remove all extra files and folders (downloaded) inside Mod Subfolder after uninstall (Only for mod installers)
[o] Added ModUpdate feature, that checks for previous version installed

[v1.6]
[o] Added documentation and information

[v1.5]
[o] Added if file exists check for Source.exe (else "Steam is not installed" error)

[v1.4]
[o] Added Launch Source Mod option at end of setup

[v1.3]
[o] Added Optional Desktop Icon and QuickLaunch Icons to Launch Source Mod

[v1.2]
[o] Added Launch Source Mod option in Start Menu

[v1.1]
[o] folder autodetection for Mods and Maps

[v1.0]
[o] Added folder autodetection of SourceMod

[v0.0]
[o] Initial Release

[ CREDITS ] - READ ONLY
;; Concept & Initial scripting : Jan 'LOGAN' Albartus ( albartus [AT] home [DOT] nl )

[ SYSTEM REQUIREMENTS ] - READ ONLY
;; Inno Setup Quick Start Pack                ;; http://files.jrsoftware.org/ispack/
;; LOGAN's Inno Setup Script Includes (ISSI)  ;; http://www.albartus.com/issi/

[ RELATED LINKS ] - READ ONLY
;; Valve's Steam, HalfLife & Source           ;; http://www.steampowered.com/
;; Map Central Network                        ;; http://www.mapcentralnetwork.com/

[ TO DO ] - READ ONLY
;; Read "gameinfo.txt", "GameInfo.txt" or "GAMEINFO.TXT" from root of MOD to auto set
;; Game title and the SteamAppId for starting the game when installing Mod's.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;"GameInfo"
;{
;	game "Plan of Attack"
;	type "multiplayer_only"
;	nomodels	"1"
;	nohimodel	"1"
;	nocrosshair	"1"
;	FileSystem
;	{
;		SteamAppId				220		// This will mount all the GCFs we need (240=CS:S, 220=HL2).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[##########################################################]

[ MOD SECTION ] - READ ONLY
#ifdef ModName

  #ifndef ModIconFile
    #if fileExists(ModFilesPath+"\resource\game.ico")
      #define ModIconFile ModFilesPath+"\resource\game.ico"
    #endif
  #endif

  #ifdef ModProgramGroup
    #if ModProgramGroup == "valve" || ModProgramGroup == "Valve" || ModProgramGroup == "VALVE"
      #defineModProgramGroup "Valve\Steam\Steam Mods\"
    #else
      #if ModProgramGroup != ""
        #define ModProgramGroup ModProgramGroup+"\"
      #else
        #define ModProgramGroup "Steam Mods\"
      #endif
    #endif
  #else
    #define ModProgramGroup ""
  #endif

  #ifndef ModId
    #define ModId ModName
  #endif

  #ifndef ModSubDir
    #define ModSubDir ModName
  #endif

  #ifndef ModInstallType
    #define ModInstallType "HL2Mod"
  #endif

  #ifdef ModUpdateName

    #if ModUpdateName == ""
      #define ModUpdateName ModName
    #endif

    #ifndef ModUpdateID
      #define ModUpdateID ModID
    #endif

    #define ISSI_Update ModUpdateID
    #define ISSI_UpdateTitle ModUpdateName

  #endif

[Files]
  #if ModInstallType == "HL2Mod" || ModInstallType == "HalfLifeMod" || ModInstallType == "HL2:DeathMatchMod" || ModInstallType == "CS:SourceMod"

    #ifdef ModIconFile
      ;;Create an icon in the folder Steam uses for desktop icons (not in Play Games menu)
      Source: "{#ModIconFile}"; DestDir: "{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\..\..\steam\games"; DestName: "{#ModName}.ico"; Flags: ignoreVersion
    #endif

    ;; If a Mod is being installed the files are put in the AppDir
    Source: "{#ModFilesPath}\*.*"; DestDir: "{app}"; Flags: ignoreVersion recursesubdirs
  #else
    ;; If a map-pack is being installed it adds \maps sub-folder where to copy the files
    Source: "{#ModFilesPath}\*.*"; DestDir: "{app}\maps"; Flags: ignoreVersion recursesubdirs
  #endif

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
  DefaultGroupName={#ModProgramGroup}{#ModName}
  OutputDir={#SourcePath}
  DirExistsWarning=no
  #ifndef ISSI_Update
  DisableDirPage=yes
  #endif
  AlwaysShowDirOnReadyPage=yes

  ;;deactivated these to avoid confusion
  ;DisableProgramGroupPage=yes
  ;DisableReadyMemo=yes
  ;DisableReadyPage=yes

  ;; SOURCE MODS & MAPS
  #if ModInstallType == "HL2Mod" || ModInstallType == "HL2ModMap"
    #ifndef ModAppLaunch
      #define ModAppLaunch 220
    #endif
    DefaultDirName={reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}
  #endif

  #if ModInstallType == "HL2:DeathMatchMod" || ModInstallType == "HL2:DeathMatchModMap"
    #ifndef ModAppLaunch
      #define ModAppLaunch 320
    #endif
    DefaultDirName={reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}
  #endif

  #if ModInstallType == "CS:SourceMod" || ModInstallType == "CS:SourceModMap"
    #ifndef ModAppLaunch
      #define ModAppLaunch 240
    #endif
    DefaultDirName={reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}
  #endif

  ;; MAP PACKS FOR VALVE MODS
  #if ModInstallType == "CS:SourceMap"
    #ifndef ModAppLaunch
      #define ModAppLaunch 240
    #endif
    DefaultDirName={reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\..\counter-strike source\cstrike
  #endif

  #if ModInstallType == "HL2:DeathMatchMap"
    #ifndef ModAppLaunch
      #define ModAppLaunch 320
    #endif
    DefaultDirName={reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\..\half-life 2 deathmatch\hl2mp
  #endif

  ;; HALFLIFE MOD
  #if ModInstallType == "HalfLifeMod" || ModInstallType == "HalfLifeModMap"
    #ifndef ModAppLaunch
      #define ModAppLaunch 70
    #endif
    DefaultDirName={reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\{#ModSubDir}
  #endif

[Tasks]
  #if ModInstallType == "HL2Mod"  || ModInstallType == "HalfLifeMod" || ModInstallType == "CS:SourceMod" || ModInstallType == "HL2:DeathMatchMod"
    Name: desktopicon; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
    Name: quicklaunchicon; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
  #endif

[Icons]
  #if ModInstallType == "HL2Mod" || ModInstallType == "CS:SourceMod" || ModInstallType == "HL2:DeathMatchMod"
    #ifdef ModIconFile
      Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#ModName}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}"""; Tasks: quicklaunchicon; IconFileName: "{#ModIconFile}"
      Name: "{userdesktop}\{#ModName}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}"""; Tasks: desktopicon; IconFileName: "{#ModIconFile}"
      Name: "{group}\{cm:LaunchProgram,{#ModName}}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}"""; IconFileName: "{#ModIconFile}"
    #else
      Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#ModName}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}"""; Tasks: quicklaunchicon
      Name: "{userdesktop}\{#ModName}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}"""; Tasks: desktopicon
      Name: "{group}\{cm:LaunchProgram,{#ModName}}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}""";
    #endif
  #endif

  #if ModInstallType == "HalfLifeMod"
    #ifdef ModIconFile
      Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#ModName}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\{#ModSubDir}"""; Tasks: quicklaunchicon; IconFileName: "{#ModIconFile}"
      Name: "{userdesktop}\{#ModName}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\{#ModSubDir}"""; Tasks: desktopicon; IconFileName: "{#ModIconFile}"
      Name: "{group}\{cm:LaunchProgram,{#ModName}}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\{#ModSubDir}"""; IconFileName: "{#ModIconFile}"
    #else
      Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#ModName}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\{#ModSubDir}"""; Tasks: quicklaunchicon
      Name: "{userdesktop}\{#ModName}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\{#ModSubDir}"""; Tasks: desktopicon
      Name: "{group}\{cm:LaunchProgram,{#ModName}}"; Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\{#ModSubDir}""";
    #endif
  #endif

  Name: "{group}\{cm:ProgramOnTheWeb,{#ModName}}"; Filename: "{#ModURL}"
  Name: "{group}\{cm:UninstallProgram,{#ModName}}"; Filename: "{uninstallexe}"

[UninstallDelete]

  #if ModInstallType == "HL2Mod" || ModInstallType == "CS:SourceMod" || ModInstallType == "HL2:DeathMatchMod"
  ;; Dont use for MapInstall Packs
    Type: filesandordirs; Name: """{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}\*.*"""
    Type: dirifempty; Name: """{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}"""
  #endif

  #if ModInstallType == "HalfLifeMod"
  ;; Dont use for MapInstall Packs
    Type: filesandordirs; Name: """{reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\{#ModSubDir}\*.*"""
    Type: dirifempty; Name: """{reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\{#ModSubDir}"""
  #endif

[Run]
  #if ModInstallType == "HL2Mod" || ModInstallType == "CS:SourceMod" || ModInstallType == "HL2:DeathMatchMod"
    Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,SourceModInstallPath|{pf}\valve\steam\SteamApps\SourceMods}\{#ModSubDir}"""; Description: "{cm:LaunchProgram,{#ModName}}"; Flags: postinstall nowait skipifsilent unchecked
  #endif

  #if ModInstallType == "HalfLifeMod"
    Filename: "{reg:HKCU\Software\Valve\Steam,SteamExe|{pf}\valve\steam\steam.exe}"; Parameters: "-applaunch {#ModAppLaunch} -game ""{reg:HKCU\Software\Valve\Steam,ModInstallPath|{pf}\Steam\SteamApps\YOUREMAIL\half-life}\{#ModSubDir}"""; Description: "{cm:LaunchProgram,{#ModName}}"; Flags: postinstall nowait skipifsilent unchecked
  #endif

  #if !defined ISSI_Update && !defined ModUpdateName

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
  #endif

#endif ;; ModName

[ ISSI ] - READ ONLY
#ifdef ModUrl
  #define ISSI_URL ModURL
  #define ISSI_UrlText "{cm:ProgramOnTheWeb,"+ModName+"}"
#endif


#include ISSI_IncludePath+"\_issi.isi"

[Messages]
BeveledLabel={#ModName} © {#ISSI_LongYear} {#ModPublisher}

[HalfLife AppLaunch Reference Table] - READ ONLY
; Client Dedicated Server HLDS (applaunch 5)
; Counter-Strike 1.6 (applaunch 10)
; Team Fortress Classic (applaunch 20)
; Day of Defeat (applaunch 30)
; Death Match Classic (applaunch 40) click here
; Opposing Force (applaunch 50) click here
; Ricochet (applaunch 60) click here
; Half-Life (applaunch 70) click here
; Condition Zero (applaunch 80) click here
; Codename Gordon (applaunch 92) click here
; CZ: Deleted Scenes (applaunch 100) click here

[Half-Life 2 (Source) AppLaunch Reference Table] - READ ONLY
; Client Source Dedicated Server Files (applaunch 205)
; Client Source SDK Files (applaunch 211)
; Half-Life 2 (applaunch 220)
; Counter-Strike: Source (applaunch 240)
; Half-Life: Source (applaunch 280)
; Half-Life 2 Death Match (applaunch 320)


