! This is a demonstration for
! Zemax ZPL macro syntax-highlighting and code management
! AND auto-completion for functions and keywords
! AND calltip function hints

! Developed on Notepad++
! Nice eye-easy color theme ported from Solarized

250.00		! Numbers are red
NFLD()		! Numeric functions are blue
$COMMENT(5)	! String functions are green
RAYTRACE	! Keywords are yellow
GOTO 1		! GOTO and LABEL are magenta

! Openblock	@folding

! IF and FOR statments are foldable
FOR i, 1, nfield, 1					! For folding
        PRINT "Field number ", i
		IF (i == 3)					! IF folding
			PRINT "X-field angle : ", FLDX(i)," Y-field angle : ", FLDY(i)
		ENDIF
NEXT

! Comments are foldable
! Create codeblocks with openblock, midblock, and closeblock.
! With region tag @regiontag

! closeBlock

! Demonstration of autocomplete feature
! try RAYTRACE, $LEFTSTRING
RAYTRACE
$LEFTSTRING

! Demonstration of calltip function hints
! $GETSTRING, GETT
$GETSTRING(A$,n)
GETT(1,1,1)

! Do you like this? Try it!
! Download from Github: https://github.com/huxinda/
! also available for CodeV macros
! Contact: Xinda xhu@optics.arizona.edu