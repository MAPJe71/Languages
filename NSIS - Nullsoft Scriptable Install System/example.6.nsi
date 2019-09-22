; Example.nsi  
;  
; Very simple example: all optional settings left as default.   
; Installer asks user where to install, and drops copy of "Program.exe" there.  
  
; Name the installer  
Name "Example"  
  
; Set the installer output file name  
OutFile "ExampleInstaller.exe"  
  
; Set the default installation directory  
InstallDir $PROGRAMFILES\Arrayjet\Sprint  
  
; Set the text to prompt user to enter a directory  
DirText "This will install My Cool Program on your computer. Choose a directory"  
  
; Specify all files needed for installation  
Section "MainSection" SEC01  
  
   ; Set output path to the installation directory,   
   ; where INSTDIR = C:\Program Files\Arrayjet\Sprint  
   SetOutPath $INSTDIR  
     
   ;Create the installation directory  
   CreateDirectory $INSTDIR  
  
   ; Put file there  
   File Program.exe  
   File Text.txt  
  
SectionEnd
