@echo off
rem --- (hopefully) avoid race condition happening sometimes
timeout >NUL 1

rem --- set QB64 installation folder (environment variables allowed, no trailing backslash)
set qb64folder="%userprofile%\qb64"

rem --- format of the batch file call from Notepad++ (for argument reference)
rem --- "$(NPP_DIRECTORY)\QB64Starter.bat" "OpMode" "$(CURRENT_DIRECTORY)" "$(FILE_NAME)" "$(NAME_PART)"

rem --- name arguments and strip quotation marks
set opmode=%1%
set opmode=%opmode:~1,-1%
set srcdir=%2%
set srcdir=%srcdir:~1,-1%
set srcfile=%3%
set srcfile=%srcfile:~1,-1%
set srcbase=%4%
set srcbase=%srcbase:~1,-1%
set qb64folder=%qb64folder:~1,-1%

rem --- check QB64 config for "Output EXE to source folder" option (QB64-GL only)
set cfgfile="%qb64folder%\internal\config.txt"
set cfgopt=false
if exist %cfgfile% (
  find >NUL /c /i "SaveExeWithSource = TRUE" %cfgfile%
  if not errorlevel 1 set cfgopt=true
)

rem --- build full basic source and executable file names (EXE path according to config check)
set basfile="%srcdir%\%srcfile%"
if %cfgopt%==true (
  set exefile="%srcdir%\%srcbase%.exe"
) else (
  set exefile="%qb64folder%\%srcbase%.exe"
)

rem --- execute commands according to operation mode
cd /d "%qb64folder%"
if %opmode%==OI (
  rem --- OpenIDE
  qb64.exe %basfile%
) else (
  if %opmode%==CO (
    rem --- Compile
    if exist %exefile% del %exefile%
    qb64.exe -c %basfile%
  ) else (
    if %opmode%==CR (
      rem --- CompileRun
      if exist %exefile% del %exefile%
      qb64.exe -c %basfile%
      if exist %exefile% %exefile%
    ) else (
      if %opmode%==RA (
        rem --- Run
        if exist %exefile% (%exefile%) else (
          echo.
          echo Sorry, program seems not yet successfully be compiled...
          echo.
          echo.
          pause
        )
      ) else (
        echo.
        echo Sorry, unknown operation mode...
        echo.
        echo.
        pause
      )
    )
  )
)
