/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***


	View header of the following file for all the informations about this script:
		- C:/Users/[Username]/AppData/Local/Autodesk/3dsMax/[3ds Max Version]/ENU/Scripts/TemplateProject/TemplateScript/TemplateScript.ms
	
	
*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/


macroScript TemplateScript_Macroscript
category:"TemplateProject"
internalCategory:"TemplateProject"
tooltip: "TemplateScript"
buttonText:"TemplateScript"
--Icon:#("TemplateScript",1)
(
	-- !!! Do not change this line directly in the template !!! It may be automatically replaced by the installer
	local lScriptRootDir = getdir #userScripts + "\\"
	
	local lLauncherFile = lScriptRootDir + "TemplateProject\\TemplateScript\\_ScriptLauncher.ms"
	if doesFileExist lLauncherFile then
		filein lLauncherFile
	else if doesFileExist (lLauncherFile + "e") then
		filein (lLauncherFile + "e")
	else messagebox ("File \"" + filenameFromPath lLauncherFile + "\" not found in script directory\n\nIf the script has been uninstalled, shortcuts must be removed manually") title:"Warning"
)

