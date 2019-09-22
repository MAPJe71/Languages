
Function Valid1		; Comment1
    !echo "Body of Function Invalid1"
FunctionEnd

;-------------------------------------------

Function Valid2		; Function Invalid21
    !echo "Body of Function Invalid22"
FunctionEnd

;-------------------------------------------

Function Valid3		/* Comment3 */
    !echo "Body of Function Invalid3"
FunctionEnd

;-------------------------------------------

Function Valid4		/*
Function Invalid41
*/
    !echo "Body of Function Invalid42"
FunctionEnd

;-------------------------------------------

Function Valid5		/*
Function Invalid51
    !echo "Body of Function Invalid52"
FunctionEnd
*/
    !echo "Body of Function Invalid53"
FunctionEnd

;-------------------------------------------

/**/Function Valid6
    !echo "Body of Function Invalid6"
FunctionEnd

;-------------------------------------------

/*
Function Invalid71
    !echo "Body of Function Invalid72"
FunctionEnd
*/

;-------------------------------------------

Section -
    !echo "Body of Section (hidden)"
SectionEnd

;-------------------------------------------

Function .onInit
    !echo "Body of Function .onInit"
FunctionEnd

;-------------------------------------------

Section -.onInit
    !echo "Body of Function -.onInit"
SectionEnd

;-------------------------------------------

Function un.onInit
    !echo "Body of Function un.onInit"
FunctionEnd

;-------------------------------------------

Section -un.onInit
    !echo "Body of Function -un.onInit"
SectionEnd

;-------------------------------------------

!macro CheckIfRunning un
	Function ${un}CheckIfRunning
		!echo "Body of Function ${un}CheckIfRunning"
	FunctionEnd
!macroend

;-------------------------------------------

Section /o -"Notepad++" mainSection
    !echo "Body of Section $\"Notepad++$\" (hidden)"
SectionEnd

;-------------------------------------------

SectionGroup "Auto-completion Files" autoCompletionComponent
	${MementoSection} "C" C
		SetOutPath "$INSTDIR\plugins\APIs"
		File ".\APIs\c.xml"
	${MementoSectionEnd}

	${MementoSection} "C++" C++
		SetOutPath "$INSTDIR\plugins\APIs"
		File ".\APIs\cpp.xml"
	${MementoSectionEnd}
SectionGroupEnd

;-------------------------------------------

SectionGroup un.autoCompletionComponent

	Section un.PHP
		Delete "$INSTDIR\plugins\APIs\php.xml"
	SectionEnd
	Section un.CSS
		Delete "$INSTDIR\plugins\APIs\css.xml"
	SectionEnd
    
SectionGroupEnd

;-------------------------------------------
