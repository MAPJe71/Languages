/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***

	View header of the following file for all the informations about this script:
		- C:/Users/[Username]/AppData/Local/Autodesk/3dsMax/[3ds Max Version]/ENU/Scripts/TemplateProject/TemplateScript/TemplateScript.ms
	
	TemplateProject and TemplateScript are replaced by custom info by WkDevTool during the wizzard new script creation
	
*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/


global gtTemplateScript

(
	local lScriptRootDir
	if true == gbUseWkDevMode and "TemplateScript" == wkdevtool.mfGetCurrentScriptName() then
	(
		 lScriptRootDir = wkdevtool.mfGetDevDir(#maxroot) + "scripts\\"
		 format "\n\n---------------------\nTemplateScript_ScriptLauncher: launched by WkDevTool \n\n"
	)
	else lScriptRootDir = getdir #userScripts + "\\"			-- line automatically changed by WkDevTool to respect the real path after installation
		 
	local lScriptFullPath = lScriptRootDir + "TemplateProject\\TemplateScript\\TemplateScript.ms"
	local lbContinue = true
	--format "gtTemplateScript_ScriptLauncher: lScriptFullPath = %\n" lScriptFullPath
	
	
	if not doesFileExist lScriptFullPath do
	(
		lScriptFullPath += "e"				-- check for encrypted file
	
		if not doesFileExist lScriptFullPath then
		(
			messagebox "*** Warning: TemplateScript _ScriptLauncher: TemplateScript script file not found ***\n\nScript cannot be launched" title:"TemplateScript _ScriptLauncher"
			format "\n*** Warning: TemplateScript _ScriptLauncher: TemplateScript script file not found:\n  %\n" lScriptFullPath
			lbContinue = false
		)
		else if true == wkgbVerbose do format "Using encrypted library for gtTemplateScript\n"
	)
	
	if lbContinue do
	(
		gtTemplateScript = filein lScriptFullPath
		gtTemplateScript.mfLaunchGUI()
	)
)	

-- *** THIS LINE MUST BE THE LAST LINE OF THE SCRIPT ***
-- otherwise the structure variable is not correctly returned
gtTemplateScript

