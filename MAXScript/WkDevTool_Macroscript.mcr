/*/--------------------------------------------------------------------------------------------------------//
*** Header Used For Versionning ** Do Not Change ** Header Used For Versionning ** Do Not Change ************

	A WerwacK Script
	Visit www.werwackfx.com
	
	Contact: werwack@werwackfx.com
	
	View header of the following file for all the informations about this script:
		- [3DsMax]/Scripts/WerwacKScripts/WkDevTools/_ScriptLauncher.ms
	
	
*** Header Used For Versionning ** Do Not Change ** Header Used For Versionning ** Do Not Change ************
//--------------------------------------------------------------------------------------------------------/*/


macroScript WkDevTool category:"WerwacKScripts" tooltip:"WkDevTool       <Shift + Click>: Open the Reset dialog box     <Esc + Click>: Force reload the script" Icon:#("WkDevTool",1) buttonText:"DevTool"
(
	-- !!! Do not change this line directly in the template !!! It may be automatically replaced by the installer
	local lScriptRootDir = getdir #maxdata
	
	global gWkDevToolPath = lScriptRootDir
	local lLauncherFile = gWkDevToolPath + "scripts\\WerwacKScripts\\WkDevTool\\_ScriptLauncher.ms"
	
	if doesfileexist lLauncherFile then
		filein lLauncherFile
	else if doesfileexist (lLauncherFile + "e") then
		filein (lLauncherFile + "e")
	else messagebox ("File \"WkDevTool\\_ScriptLauncher.mse\" not found.\n\nPlease check the installation of WkDevTool or contact werwack@werwackfx.com") Title:"_ScriptLauncher: File Not Found"
)



