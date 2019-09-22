/*
    https://notepad-plus-plus.org/community/topic/13443/need-help-to-make-maxscript-functions-recognized-by-function-list

    Expected Function List tree:
        CodeSample1_Macroscript.mcr
        \-- Wk3DTexturer_Macroscript
            +-- myFunction02
            \-- myFunction03

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

macroScript Wk3DTexturer_Macroscript category:"WerwacKScripts" internalCategory:"WerwacKScripts" tooltip:"Wk3DTexturer" buttonText:"Wk3DTexturer" --Icon:#("Wk3DTexturer",1)
(
	-- !!! Do not change this line directly in the template !!! It may be automatically replaced by the installer
	local lScriptRootDir = getdir #userScripts + "\\"

	local lLauncherFile = lScriptRootDir + "WerwacKScripts\\Wk3DTexturer\\_ScriptLauncher.ms"
	if doesFileExist lLauncherFile then
		filein lLauncherFile
	else if doesFileExist (lLauncherFile + "e") then
		filein (lLauncherFile + "e")
	else messagebox ("File \"" + filenameFromPath lLauncherFile + "\" not found in script directory\n\nIf the script has been uninstalled, shortcuts must be removed manually") title:"Warning"

	function myFunction02 myParam =
	(
		messagebox ("myParam: " + myParam as string)
	)

	function myFunction03 myOptionalParam: myOptionalParam02:"my default value" = -- optional parameters ends with : and may be followed by an initisalization value
	(
		messagebox ("myOptionalParam02: " + myOptionalParam02 as string)
	)

)

