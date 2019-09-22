/*/--------------------------------------------------------------------------------------------------------//
*** Header Used For Versionning ** Do Not Change ** Header Used For Versionning ** Do Not Change ************

	A WerwacK Script
	
	Contact: werwack@werwackfx.com
	Website: www.werwackfx.com
	
*** Header Used For Versionning ** Do Not Change ** Header Used For Versionning ** Do Not Change ************
//--------------------------------------------------------------------------------------------------------/*/


	-- last modifications: 2009/07/19
	fn WkDisplayInspectorProperties rObj rClassLevel rPropsArr rbDisplayValues =
	(
		local lLenghtOfLine = 28
		local lDisplayTabs = "		"
		
	--	try(
			if rbDisplayValues then
				for p in rPropsArr do
				(
					local lPropVal = getProperty rObj p
					if Array == classof lPropVal or ArrayParameter == classof lPropVal then
					(
						if 0 == lPropVal.count then
							format (lDisplayTabs + (WkDevTool.mptStdLib.mfFillStringWithChar (p as string) lLenghtOfLine " ") + " = Array: #()\n")
						else
						(
							format (lDisplayTabs + (WkDevTool.mptStdLib.mfFillStringWithChar (p as string) lLenghtOfLine " ") + " = Array: count = " + lPropVal.count as string + " \n")
							for i=1 to lPropVal.count do
								format (lDisplayTabs + (WkDevTool.mptStdLib.mfFillStringWithChar "" lLenghtOfLine " ") + "   [" + i as string + "] = " + (lPropVal[i] as string) + "\n")
						)
					)
					else
					(
						local lTmpStr = getProperty  rObj p
						if String == classof lTmpStr then
							lTmpStr = "\"" + lTmpStr as string + "\""
						else lTmpStr = lTmpStr as string
						format (lDisplayTabs + (WkDevTool.mptStdLib.mfFillStringWithChar (p as string) lLenghtOfLine " ") + " = " + lTmpStr + "\n")
					)
				)
			else
				for p in rPropsArr do
				(
					if Array == classof p then
						format "%   %\n" lDisplayTabs (p as string)
					else format "%   %\n" lDisplayTabs p
				)
	--	)Catch( format"\nNo getPropNames for %\n" rObj as string)
		
	)

	fn WkShowAllMembersAndPropertiesClassLevel rObj rClassLevel rbDisplayValues =
	(
		local lCurrentInspectorName = undefined
		local lbDisplayValues = rbDisplayValues
		local lTabs = "	"
		local lMembersArr = undefined
		
		format "------------- \n"
		format "  Level:	%\n" rClassLevel
		format "------------- \n"
		
	-- properties
		format "	\n"
		lCanDisplayProps = true
		lCurrentInspectorName = "getPropNames"
		try( lMembersArr = getPropNames rClassLevel ) catch( lCanDisplayProps = false )
		if lCanDisplayProps then
		(
			lMembersArr = getPropNames rClassLevel showHidden:lbShowHidden
			if Array == classof lMembersArr or ArrayParameter == classof lMembersArr then
			(
				lMembersArr = sort lMembersArr
				format "%getPropNames %:\n\n" lTabs rClassLevel as string
				WkDisplayInspectorProperties rObj rClassLevel lMembersArr lbDisplayValues
			)
			else format "\n%getPropNames %:\n            %\n" lTabs (rObj as string) (lMembersArr as string)
		)
		else format "\n%No getPropNames available\n" lTabs
		
		
	--	lCanDisplayProps = true
	--	lCurrentInspectorName = "showProperties"
	--	try( lMembersArr = showProperties rObj ) catch( lCanDisplayProps = false )
	--	if lCanDisplayProps then
	--	(
	--		lMembersArr = showProperties rObj showHidden:lbShowHidden
	--		if Array == classof lMembersArr or ArrayParameter == classof lMembersArr then
	--		(
	--			lMembersArr = sort lMembersArr
	--			format " showProperties %:\n\n" rObj as string
	--			WkDisplayInspectorProperties rObj rClassLevel lMembersArr lbDisplayValues
	--		)
	--		else format "\n showProperties %:\n            %\n" (rObj as string) (lMembersArr as string)
	--	)
	--	else format "\n  No showProperties available\n"
		
		
		lCanDisplayProps = true
		lCurrentInspectorName = "showinterfaces"
		format "\n"
		try( lMembersArr = showinterfaces rObj ) catch( lCanDisplayProps = false )
		format "\n"
	/*	if lCanDisplayProps then
		(
			format "\n	-------- \n"
			lMembersArr = showinterfaces rObj
			if Array == classof lMembersArr or ArrayParameter == classof lMembersArr then
			(
				lMembersArr = sort lMembersArr
				format "\n%showinterfaces %:\n" lTabs rObj as string
				WkDisplayInspectorProperties rObj rClassLevel lMembersArr lbDisplayValues
			)
			else format "\n%showinterfaces %:\n            %\n" lTabs (rObj as string) (lMembersArr as string)
		)
		else format "%No showinterfaces available\n" lTabs
	*/
		
		lCanDisplayProps = true
		lCurrentInspectorName = "showConstructors"
		try( lMembersArr = showConstructors rObj ) catch( lCanDisplayProps = false )
		if lCanDisplayProps then
		(
			format "\n	-------- \n"
			lMembersArr = showConstructors rObj
			if Array == classof lMembersArr or ArrayParameter == classof lMembersArr then
			(
				lMembersArr = sort lMembersArr
				format "\n%showConstructors %:\n\n" lTabs rObj as string
				WkDisplayInspectorProperties rObj rClassLevel lMembersArr lbDisplayValues
			)
			else format "\n%showConstructors %:\n            %\n" lTabs (rObj as string) (lMembersArr as string)
		)
		else format "%No showConstructors available\n" lTabs


		format "   ActiveX and DotNet:\n"	-- lTabs
		lCanDisplayProps = true
		lCurrentInspectorName = "showMethods"
		try( lMembersArr = showMethods rObj ) catch( lCanDisplayProps = false )
		if lCanDisplayProps then
		(
			format "\n	-------- \n"
			lMembersArr = showMethods rObj showHidden:lbShowHidden
			if Array == classof lMembersArr or ArrayParameter == classof lMembersArr then
			(
				lMembersArr = sort lMembersArr
				format "\n%showMethods %:\n\n" lTabs rObj as string
				WkDisplayInspectorProperties rObj rClassLevel lMembersArr lbDisplayValues
			)
			else format "\n%showMethods %:\n            %\n" lTabs (rObj as string) (lMembersArr as string)
		)
		else format "%No showMethods available\n" lTabs
		
		
		lCanDisplayProps = true
		lCurrentInspectorName = "showEvents"
		try( lMembersArr = showEvents rObj ) catch( lCanDisplayProps = false )
		if lCanDisplayProps then
		(
			format "\n	-------- \n"
			lMembersArr = showEvents rObj
			if Array == classof lMembersArr or ArrayParameter == classof lMembersArr then
			(
				lMembersArr = sort lMembersArr
				format "\n%showEvents %:\n\n" lTabs rObj as string
				WkDisplayInspectorProperties rObj rClassLevel lMembersArr lbDisplayValues
			)
			else format "\n%showEvents %:\n            %\n" lTabs (rObj as string) (lMembersArr as string)
		)
		else format "%No showEvents available\n" lTabs
		

		format "\n"
	)
	
	-- rbShowByClassLevel:		if true: displays properties by class level, else all the properties are displayed by categ (props, members...)
	-- rbShowCurrentClassOnly:	if true: displays only the properties of the current class level, else displays all the parent classes properties
	fn WkShowAllMembersAndProperties rObj rbDisplayValues: rbShowHidden: rbShowByClassLevel:true rbShowCurrentClassOnly:false =
	(
		local lbDisplayValues = if unsupplied == rbDisplayValues then false else rbDisplayValues
		local lbShowHidden = if unsupplied == rbShowHidden then false else rbShowHidden
		local lMembersArr
		local lCanDisplayProps = true
		
		format "---------------------\n\n"
		format "  Object:			%\n" rObj as string
		format "  Class:			%\n" (classof rObj)
		
	-- class hierarchy
		local lParentClassesStr = (classOf rObj) as string
		local lCurrentClass = classOf rObj
		local lParentClass = classOf lCurrentClass
		
		while lParentClass != lCurrentClass do
		(
		--	format "lCurrentClass: %, lParentClass: %\n" lCurrentClass lParentClass
			lCurrentClass = lParentClass
			lParentClass = classof lCurrentClass
			lParentClassesStr += " -|>- " + lCurrentClass as string
		)
		format "  Parent classes:	%\n\n" lParentClassesStr
		format "---------------------\n\n"
		
		
	-- get properties at each class level
		if rbShowByClassLevel then
		(
			-- current class  level
			-- note: there is some differences in the results when doing getPropNames obj and getPropNames (classof obj) (test it with a sphere instance)
			WkShowAllMembersAndPropertiesClassLevel rObj rObj lbDisplayValues
			
			if not rbShowCurrentClassOnly do
			(
				lCurrentClass = superclassOf rObj
				lParentClass = classOf lCurrentClass
				while lParentClass != lCurrentClass do
				(
				--	format "lCurrentClass: %, lParentClass: %\n" lCurrentClass lParentClass
					WkShowAllMembersAndPropertiesClassLevel rObj lCurrentClass lbDisplayValues
					lCurrentClass = lParentClass
					lParentClass = classof lCurrentClass
				)
			)
		)
		else	-- we collect and sort all the attributes
		(
			lMembersArr = getPropNames rObj
			if not rbShowCurrentClassOnly do
			(
				lCurrentClass = superclassOf rObj
				lParentClass = classOf lCurrentClass
				while lParentClass != lCurrentClass do
				(
					local lTmpsArr = getPropNames lCurrentClass
					for lItem in lTmpsArr do
						append lMembersArr lItem
					lCurrentClass = lParentClass
					lParentClass = classof lCurrentClass
				)
			)
			lMembersArr = sort lMembersArr
			WkDisplayInspectorProperties rObj rObj lMembersArr lbDisplayValues
		)
		
		return "----------"
	)
	

--format "WkInspectors.ms loaded\n"


