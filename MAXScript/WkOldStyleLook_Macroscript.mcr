/*
    https://notepad-plus-plus.org/community/topic/13443/need-help-to-make-maxscript-functions-recognized-by-function-list

    Expected Function List tree:
        WkOldStyleLook_MacroScript.ms
        \-- WkOldStyleLook_Macroscript

    macroScript     ThisShouldNotBeVisibleInFunctionListTree ()
    macroScript     ThisShouldNotBeVisibleInFunctionListTree
    (
        fn          ThisShouldNotBeVisibleInFunctionListTree = ()
        function    ThisShouldNotBeVisibleInFunctionListTree = ()
    )
    fn              ThisShouldNotBeVisibleInFunctionListTree = ()
    function        ThisShouldNotBeVisibleInFunctionListTree = ()
    struct          ThisShouldNotBeVisibleInFunctionListTree
    (
        fn          ThisShouldNotBeVisibleInFunctionListTree = ()
        function    ThisShouldNotBeVisibleInFunctionListTree = ()
    )
*/

/*/--------------------------------------------------------------------------------------------------------//
*** Header Used For Versionning ** Do Not Change ** Header Used For Versionning ** Do Not Change ************

	A script by WerwacK
	3dsMax Supported Versions:	2011.x, 2010.x
	Contact: j.blervaque@werwackfx.com
	Website: www.werwackfx.com

	View header of the following file for all the informations about this script:
		- [3DsMax]/Scripts/WerwacKScripts/WkOldStyleLook/WkOldStyleLook.ms


*** Header Used For Versionning ** Do Not Change ** Header Used For Versionning ** Do Not Change ************
//--------------------------------------------------------------------------------------------------------/*/

/*/--------------------------------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------------------------------/*/

macroScript WkOldStyleLook_Macroscript category:"WerwacKScripts" tooltip: "WkOldStyleLook" buttonText:"WkOldStyleLook" --Icon:#("IconName",1)
(
	local lLauncherFile = (getdir #maxroot) + "scripts\\WerwacKScripts\\WkOldStyleLook\\_ScriptLauncher.ms"
	if not doesFileExist lLauncherFile do
		lLauncherFile += "e"

	if doesFileExist lLauncherFile then
		filein lLauncherFile
	else messagebox ("File \"" + filenameFromPath lLauncherFile + "\" not found in script directory\n\nIf the script has been uninstalled, shortcuts must be removed manually") title:"Warning"
)

