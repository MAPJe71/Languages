
# NSIS

## Description


## Links

_WWW_

_Wiki_


## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~


## Identifiers


## String Literals

### Single quoted

### Double quoted

### Document String - Double or Single Triple-Quoted

### Backslash quoted


## Comment

### Single line comment

### Multi line comment

### Block comment

### Java Doc

### Here Doc

### Now Doc


## Classes & Methods


## Function


## Grammar

BNF | ABNF | EBNF | XBNF
[NSIS] -------------------------------------------------------------------------
@=Nullsoft Scriptable Install System

_WWW_=

_Wiki_=

Keywords=

   !AddIncludeDir !AddPluginDir !appendfile
   !cd
   !define !delfile
   !echo !else !endif !error !execute
   !finalize
   !getdllversion
   !if !ifdef !ifmacrodef !ifmacrondef !ifndef !include !insertmacro
   !macro !macroend !macroundef
   !packhdr
   !searchparse !searchreplace !system
   !tempfile
   !undef
   !verbose
   !warning
   Abort AddBrandingImage AddSize AllowRootDirInstall AllowSkipFiles AutoCloseWindow
   BGFont BGGradient BrandingText BringToFront
   CRCCheck Call CallInstDLL Caption ChangeUI CheckBitmap ClearErrors CompletedText ComponentText CopyFiles CreateDirectory CreateFont CreateShortCut
   Delete DeleteINISec DeleteINIStr DeleteRegKey DeleteRegValue DetailPrint DetailsButtonText DirText DirVar DirVerify
   EnableWindow EnumRegKey EnumRegValue Exch Exec ExecShell ExecWait ExpandEnvStrings
   File FileBufSize FileClose FileErrorText FileOpen FileRead FileReadByte FileReadUTF16LE FileSeek FileWrite FileWriteByte FileWriteUTF16LE FindClose FindFirst FindNext FindWindow FlushINI Function FunctionEnd
   GetCurInstType GetCurrentAddress GetDLLVersion GetDLLVersionLocal GetDlgItem GetErrorLevel GetExeName GetExePath GetFileTime GetFileTimeLocal GetFullPathName GetFunctionAddress GetInstDirError GetLabelAddress GetTempFileName Goto
   HideWindow
   Icon IfAbort IfErrors IfFileExists IfRebootFlag IfSilent InitPluginsDir InstProgressFlags InstType InstTypeGetText InstTypeSetText InstallButtonText InstallColors InstallDir InstallDirRegKey IntCmp IntCmpU IntFmt IntOp IsWindow
   LangString LangStringUP LicenseBkColor LicenseData LicenseForceSelection LicenseLangString LicenseText LoadLanguageFile LockWindow LogSet LogText
   ManifestDPIAware ManifestSupportedOS MessageBox MiscButtonText
   Name Nop
   OutFile
   Page PageEx PageExEnd PluginDir Pop Push
   Quit
   RMDir ReadEnvStr ReadINIStr ReadRegDWORD ReadRegStr Reboot RegDLL Rename RequestExecutionLevel ReserveFile Return
   SearchPath
   Section SectionEnd SectionGetFlags SectionGetInstTypes SectionGetSize SectionGetText SectionGroup SectionGroupEnd SectionIn SectionSetFlags SectionSetInstTypes SectionSetSize SectionSetText
   SendMessage
   SetAutoClose SetBrandingImage SetCompress SetCompressionLevel SetCompressor SetCompressorDictSize SetCtlColors SetCurInstType SetDatablockOptimize SetDateSave SetDetailsPrint SetDetailsView SetErrorLevel SetErrors SetFileAttributes SetFont SetOutPath SetOverwrite SetPluginUnload SetRebootFlag SetRegView SetShellVarContext SetSilent SetStaticBkColor
   ShowInstDetails ShowUninstDetails ShowWindow
   SilentInstall SilentUnInstall
   Sleep SpaceTexts
   StrCmp StrCmpS StrCpy StrLen
   SubSection SubSectionEnd
   UnRegDLL
   Unicode
   UninstPage UninstallButtonText UninstallCaption UninstallIcon UninstallSubCaption UninstallText
   UnsafeStrCpy
   VIAddVersionKey VIFileVersion VIProductVersion Var
   WindowIcon
   WriteINIStr WriteRegBin WriteRegDWORD WriteRegExpandStr WriteRegStr WriteUninstaller
   XPStyle


   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=

   -
   -"Notepad++"
   .onInit
   un.onInit
   "Auto-completion Files"

StringLiterals=

   Strings

   To represent strings that have spaces, use quotes:

       MessageBox MB_OK "Hi there!"

   Quotes only have the property of containing a parameter if they surround the
   rest of the parameter. They can be either single quotes, double quotes, or
   the backward single quote.

   You can escape quotes using $\:

       MessageBox MB_OK "I'll be happy" ; this one puts a ' inside a string
       MessageBox MB_OK 'And he said to me "Hi there!"' ; this one puts a " inside a string
       MessageBox MB_OK `And he said to me "I'll be happy!"` ; this one puts both ' and "s inside a string
       MessageBox MB_OK "$\"A quote from a wise man$\" said the wise man" ; this one shows escaping of quotes

   It is also possible to put newlines, tabs etc. in a string using $\r, $\n,
   $\t etc. More information...

   If you want to use a double-quote in a string you can either use $\" to
   escape the quote or quote the string with a different type of quote such
   as ` or '.

Comment=

       # This is a comment that goes from the # to the end of the line.
       ; This is a comment that goes from the ; to the end of the line.

       /* This is a
       multi-line
       comment */

   Lines beginning with ; or # are comments. You can put comments after
   commands. You can also use C-style comments to comment one or more lines.

       ; Comment
       # Comment

       # Comment \
           Another comment line (see `Long commands` section below)

       /*
       Comment
       Comment
       */

       Name /* comment */ mysetup

       File "myfile" ; Comment

   If you want a parameter to start with ; or # put it in quotes.

Classes_and_Methods=N/A

   Section [/o] [([!]|[-])section_name] [section_index_output]

   Begins and opens a new section. If section_name is empty, omitted, or begins
   with a -, then it is a hidden section and the user will not have the option
   of disabling it. If the section name is 'Uninstall' or is prefixed with
   'un.', then it is a an uninstaller section. If section_index_output is
   specified, the parameter will be !defined with the section index (can be
   used with SectionSetText etc). If the section name begins with a !, the
   section will be displayed as bold. If the /o switch is specified, the
   section will be unselected by default.

       Section "-hidden section"
       SectionEnd

       Section -"hidden section"
       SectionEnd

       Section # hidden section
       SectionEnd

       Section "!bold section"
       SectionEnd

       Section /o "optional section"
       SectionEnd

       Section "index output section" SEC_IDX
       SectionEnd

       Section Uninstall # section
       SectionEnd

       Section un.InstallSection
       SectionEnd


   SectionEnd

       This command closes the current open section.


   SectionGroup [/e] section_group_name [index_output]

   This command inserts a section group. The section group must be closed with
   SectionGroupEnd, and should contain 1 or more sections. If the section group
   name begins with a !, its name will be displayed with a bold font. If /e is
   present, the section group will be expanded by default. If index_output is
   specified, the parameter will be !defined with the section index (can be
   used with SectionSetText etc). If the name is prefixed with 'un.' the
   section group is an uninstaller section group.

       SectionGroup "some stuff"

           Section "a section"
               :
           SectionEnd

           Section "another section"
               :
           SectionEnd

       SectionGroupEnd


   SectionGroupEnd

       Closes a section group opened with SectionGroup.

Function=

   Sections
   Functions
       User functions
       Callback functions

   Begins and opens a new function. Function names beginning with "." (e.g.
   ".Whatever") are generally reserved for callback functions. Function names
   beginning with "un." are functions that will be generated in the Uninstaller.
   Hence, normal install Sections and functions cannot call uninstall functions,
   and the Uninstall Section and uninstall functions cannot call normal functions.

       Function func                       --> FL.Function
         # some commands
       FunctionEnd

       Section                             --> FL.Function
         Call func
       SectionEnd

       SectionGroup                        --> FL.Class
         Section                           --> FL.Method
         SectionEnd
         Section                           --> FL.Method
         SectionEnd
       SectionGroupEnd

~~~~~

   !macro macro_name [parameter][...]      --> FL.Function

   Creates a macro named 'macro_name'. All lines between the !macro and the
   !macroend will be saved. To insert the macro later on, use !insertmacro.
   !macro definitions can have one or more parameters defined. The parameters may
   be accessed the same way a !define would (e.g. ${PARMNAME}) from inside the
   macro.

       !macro SomeMacro parm1 parm2 parm3
         DetailPrint "${parm1}"
         MessageBox MB_OK "${parm2}"
         File "${parm3}"
       !macroend

Grammar=

