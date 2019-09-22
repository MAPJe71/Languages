!macro define_detectVersionToInstall threadid
	Var common_15
	Function detectVersionToInstall
		Pop $common_15
	FunctionEnd
	Function detectVersionToInstall_${threadid}
		${If} $VER != "noVersion"
			return
		${EndIf}
	FunctionEnd
!macroend

