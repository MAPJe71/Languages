
[Setup]
AppName=My Program
AppVersion=1.0

[Types]
Name: "full"; Description: "Full installation"
Name: "compact"; Description: "Compact installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: "main"; Description: "Main Files"; Types: full compact custom; Flags: fixed
Name: "help"; Description: "Help Files"; Types: full
Name: "help\english"; Description: "English"; Types: full
Name: "help\dutch"; Description: "Dutch"; Types: full

[Tasks]
Name: desktopicon; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; Components: main
Name: desktopicon\common; Description: "For all users"; GroupDescription: "Additional icons:"; Components: main; Flags: exclusive
Name: desktopicon\user; Description: "For the current user only"; GroupDescription: "Additional icons:"; Components: main; Flags: exclusive unchecked
Name: quicklaunchicon; Description: "Create a &Quick Launch icon"; GroupDescription: "Additional icons:"; Components: main; Flags: unchecked
Name: associate; Description: "&Associate files"; GroupDescription: "Other tasks:"; Flags: unchecked

Name: desktopicon; Description: "{cm:CreateDesktopIcon}"

[Dirs]
Name: "{app}\data"
Name: "{app}\bin"

[Files]
Source: "CTL3DV2.DLL"; DestDir: "{sys}"; Flags: onlyifdoesntexist uninsneveruninstall
Source: "MYPROG.EXE"; DestDir: "{app}"
Source: "MYPROG.CHM"; DestDir: "{app}"
Source: "README.TXT"; DestDir: "{app}"; Flags: isreadme

Source: "MYPROG.EXE"; DestDir: "{app}"; BeforeInstall: MyBeforeInstall
Source: "A\MYFILE.TXT"; DestDir: "{app}"; BeforeInstall: MyBeforeInstall2('{app}\A\MYFILE.TXT')
Source: "B\MYFILE.TXT"; DestDir: "{app}"; BeforeInstall: MyBeforeInstall2('{app}\B\MYFILE.TXT')
Source: "MYPROG.CHM"; DestDir: "{app}"; BeforeInstall: Log('Before MYPROG.CHM Install')

Source: "MYPROG.EXE"; DestDir: "{app}"; AfterInstall: MyAfterInstall
Source: "A\MYFILE.TXT"; DestDir: "{app}"; AfterInstall: MyAfterInstall2('{app}\A\MYFILE.TXT')
Source: "B\MYFILE.TXT"; DestDir: "{app}"; AfterInstall: MyAfterInstall2('{app}\B\MYFILE.TXT')
Source: "MYPROG.CHM"; DestDir: "{app}"; AfterInstall: Log('After MYPROG.CHM Install')

[Icons]
Name: "{group}\My Program"; Filename: "{app}\MYPROG.EXE"; WorkingDir: "{app}"
Name: "{group}\Uninstall My Program"; Filename: "{uninstallexe}"

[INI]
Filename: "MyProg.ini"; Section: "InstallSettings"; Flags: uninsdeletesection
Filename: "MyProg.ini"; Section: "InstallSettings"; Key: "InstallPath"; String: "{app}"

[InstallDelete]

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"

[Messages]
ButtonNext=&Forward >

[CustomMessages]
CreateDesktopIcon=Create a &desktop icon
nl.CreateDesktopIcon=Maak een snelkoppeling op het &bureaublad

[LangOptions]
LanguageName=English
LanguageID=$0409
LanguageCodePage=0
DialogFontName=
DialogFontSize=8
WelcomeFontName=Verdana
WelcomeFontSize=12
TitleFontName=Arial
TitleFontSize=29
CopyrightFontName=Arial
CopyrightFontSize=8
RightToLeft=no

[Registry]
Root: HKCU; Subkey: "Software\My Company"; Flags: uninsdeletekeyifempty
Root: HKCU; Subkey: "Software\My Company\My Program"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\My Company"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\My Company\My Program"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\My Company\My Program\Settings"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"

[Run]
Filename: "{app}\INIT.EXE"; Parameters: "/x"
Filename: "{app}\README.TXT"; Description: "View the README file"; Flags: postinstall shellexec skipifsilent
Filename: "{app}\MYPROG.EXE"; Description: "Launch application"; Flags: postinstall nowait skipifsilent unchecked

[UninstallDelete]
Type: files; Name: "{win}\MYPROG.INI"

[UninstallRun]

[Code]

; Setup event functions
function InitializeSetup(): Boolean;
procedure InitializeWizard();
procedure DeinitializeSetup();
procedure CurStepChanged(CurStep: TSetupStep);
procedure CurInstallProgressChanged(CurProgress, MaxProgress: Integer);
function NextButtonClick(CurPageID: Integer): Boolean;
function BackButtonClick(CurPageID: Integer): Boolean;
procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
function ShouldSkipPage(PageID: Integer): Boolean;
procedure CurPageChanged(CurPageID: Integer);
function CheckPassword(Password: String): Boolean;
function NeedRestart(): Boolean;
function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo, MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
procedure RegisterPreviousData(PreviousDataKey: Integer);
function CheckSerial(Serial: String): Boolean;
function GetCustomSetupExitCode: Integer;
function PrepareToInstall(var NeedsRestart: Boolean): String;
procedure RegisterExtraCloseApplicationsResources;

; Uninstall event functions
function InitializeUninstall(): Boolean;
procedure InitializeUninstallProgressForm();
procedure DeinitializeUninstall();
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
function UninstallNeedRestart(): Boolean;


procedure MyBeforeInstall();
begin
  MsgBox('About to install MyProg.exe as ' + CurrentFileName + '.', mbInformation, MB_OK);
end;

procedure MyBeforeInstall2(FileName: String);
begin
  MsgBox('About to install ' + FileName + ' as ' + CurrentFileName + '.', mbInformation, MB_OK);
end;

procedure MyAfterInstall();
begin
  MsgBox('Just installed MyProg.exe as ' + CurrentFileName + '.', mbInformation, MB_OK);
end;

procedure MyAfterInstall2(FileName: String);
begin
  MsgBox('Just installed ' + FileName + ' as ' + CurrentFileName + '.', mbInformation, MB_OK);
end;


function A(B: Integer): Integer;
external '<dllfunctionname>@<dllfilename>';

function A(B: Integer): Integer;
external '<dllfunctionname>@<dllfilename> <callingconvention>';

function A(B: Integer): Integer;
external '<dllfunctionname>@<dllfilename> <callingconvention> <options>';


function MessageBox(hWnd: Integer; lpText, lpCaption: String; uType: Cardinal): Integer;
#ifdef UNICODE
external 'MessageBoxW@user32.dll stdcall';
#else
external 'MessageBoxA@user32.dll stdcall';
#endif

