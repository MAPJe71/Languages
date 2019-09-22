@echo off
setlocal EnableExtensions EnableDelayedExpansion

for %%L in (
    "A" "a"
    "1"
    "-" "_" "#"
    "test0"
    "test 1"
    "test_2"
    "_test3"
    "test.4"
    "test___5" "test____6"
    "test-7"
    "-test.8"
    ".test9"
) do (
    call :%%~L
)
endlocal
goto :EOF

:Dump
    (set /P "_=Called subroutine `%~1`") <NUL
    set "_args=%*"
    set "_args=!_args:%~1=!"
    if "!_args:~0,1!" EQU " "  set "_args=!_args:~1!"
    if defined _args (
        (set /P "_= w/ arguments `%_args%`") <NUL
    ) else (
        (set /P "_= w/o arguments") <NUL
    )
    echo.
    goto :EOF

:A
    call :Dump %0 %* 
    goto :EOF

:a
    call :Dump %0 %* 
    goto :EOF

:1
    call :Dump %0 %* 
    goto :EOF

:-
    call :Dump %0 %* 
    goto :EOF

:_
    call :Dump %0 %* 
    goto :EOF

:#
    call :Dump %0 %* 
    goto :EOF
    
REM :test0 - deliberately set as comment

:test 1
    call :Dump %0 %* 
    goto :EOF

:test_2
    call :Dump %0 %* 
    goto :EOF

:_test3
    call :Dump %0 %* 
    goto :EOF

:test.4
    call :Dump %0 %* 
    goto :EOF

:test___5
    call :Dump %0 %* 
    goto :EOF

:test____6
    call :Dump %0 %* 
    goto :EOF

:test-7
    call :Dump %0 %* 
    goto :EOF

:-test.8
    call :Dump %0 %* 
    goto :EOF

:.test9
    call :Dump %0 %* 
    goto :EOF
