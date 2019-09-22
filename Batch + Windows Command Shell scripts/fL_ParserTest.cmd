rem - Valid labels
:1VALID
:valid2
:valid_3
 :valid_4
  :valid_5
   :valid_6
    :valid_7
     :valid_8
      :valid_9
       :valid_10
        :valid_11
	:valid.12
		:valid.13
			:valid.14
				:valid.15
:valid.16.Suffix
:valid-17
:_valid18

rem - ... text upto first whitespace is interpreted as label
:valid some text

rem - Invalid labels
:.Invalid1

::------------------------------------------------------------------------------
::  Function    :
::  Description :
::  Parameters  :
::  Return      :
::  NOTES       :
::------------------------------------------------------------------------------
:SubRoutine ([in] par1, [ref] par2)
    setlocal EnableExtensions EnableDelayedExpansion
    set _ERRORLEVEL=99
    ::-----
    set inPar1=%~1
    if not defined inPar1 (
        set _ERRORLEVEL=1
        goto :SubRoutine.RETURN
    )
    set refPar2=%~2
    if not defined refPar2 (
        set _ERRORLEVEL=2
        goto :SubRoutine.RETURN
    )
:SubRoutine.BEGIN
    ::-----

    ::-----
:SubRoutine.END
    set _ERRORLEVEL=0
:SubRoutine.RETURN
    endlocal & (
        exit /b %_ERRORLEVEL%
        set %refPar2%=ReturnValue
    )
::------------------------------------------------------------------------------

:::::::


REM Remark uppercase
 REM Remark uppercase after 1 space
  REM Remark uppercase after 2 spaces
   REM Remark uppercase after 3 spaces
    REM Remark uppercase after 4 spaces
	REM Remark uppercase after 1 tab
		REM Remark uppercase after 2 tabs
			REM Remark uppercase after 3 tabs
				REM Remark uppercase after 4 tabs

rem Remark lowercase
 rem Remark lowercase after 1 space
  rem Remark lowercase after 2 spaces
   rem Remark lowercase after 3 spaces
    rem Remark lowercase after 4 spaces
	rem Remark lowercase after 1 tab
		rem Remark lowercase after 2 tabs
			rem Remark lowercase after 3 tabs
				rem Remark lowercase after 4 tabs

::Comment
:: Comment
 :: Comment after 1 space
  :: Comment after 2 spaces
   :: Comment after 3 spaces
    :: Comment after 4 spaces
	:: Comment after 1 tab
		:: Comment after 2 tabs
			:: Ccomment after 3 tabs
				:: Ccomment after 4 tabs

REM Lines w/ a comment indicator w/o comment
REM
 REM
  REM
   REM
    REM
	REM
		REM
			REM
				REM
rem
 rem
  rem
   rem
    rem
	rem
		rem
			rem
				rem
::
 ::
  ::
   ::
    ::
	::
		::
			::
				::

REM ----------------------------------------------------------------------------
REM -- End of File --

