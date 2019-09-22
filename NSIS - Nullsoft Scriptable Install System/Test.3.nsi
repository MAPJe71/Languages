
SectionGroup SimpleSectionGroup
	Section "SimpleSection1"
	SectionEnd
	Section "SimpleSection2"
	SectionEnd
SectionGroupEnd

;-------------------------------------------

SectionGroup "Complex-Component Files" complexComponent1
	Section "ComplexSection1.1"
	SectionEnd
	Section "ComplexSection1.2"
	SectionEnd
SectionGroupEnd

;-------------------------------------------

SectionGroup "Complex-Component Files 2" complexComponent2
	Section "ComplexSection2.1"
	SectionEnd
	${MementoSection} "ComplexSection2.2" ComplexSection2.2
		SetOutPath "$INSTDIR\plugins\APIs"
		File ".\APIs\c.xml"
	${MementoSectionEnd}
SectionGroupEnd

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

