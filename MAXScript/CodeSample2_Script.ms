/*
    https://notepad-plus-plus.org/community/topic/13443/need-help-to-make-maxscript-functions-recognized-by-function-list

    Expected Function List tree:
        CodeSample2_Script.ms
        +-- tWkSubstanceObjectBoundaries
        |   +-- mfDisplayInfos
        |   \-- mfInit
        +-- tMySecondStructure
        |   +-- mfDisplayInfos02
        |   \-- mfInit
        +-- MyMacroscript
        +-- MyMacroscriptWithLessParameters
        +-- myFunction01
        +-- myFunction02
        \-- myFunction03

    macroScript     ThisShouldNotBeVisibleInFunctionListTree ()
    macroScript     ThisShouldNotBeVisibleInFunctionListTree (
        fn          ThisShouldNotBeVisibleInFunctionListTree = ()
        function    ThisShouldNotBeVisibleInFunctionListTree = ()
    )
    fn              ThisShouldNotBeVisibleInFunctionListTree = ()
    function        ThisShouldNotBeVisibleInFunctionListTree = ()
    struct          ThisShouldNotBeVisibleInFunctionListTree (
        fn          ThisShouldNotBeVisibleInFunctionListTree = ()
        function    ThisShouldNotBeVisibleInFunctionListTree = ()
    )
*/

global myGlobalVariable

macroScript MyMacroscript category:"MyMacroscript" internalCategory:"MyMacroscript" tooltip: "MyMacroscript" buttonText:"MyMacroscript" Icon:#("MyMacroscript",1)
(
	-- blabla
	local lScriptRootDir = getdir #userScripts + "\\"

	local lLauncherFile = lScriptRootDir + "_ScriptLauncher.ms"
	if doesFileExist lLauncherFile then
		filein lLauncherFile
	else if doesFileExist (lLauncherFile + "e") then
		filein (lLauncherFile + "e")
	else messagebox ("File \"" + filenameFromPath lLauncherFile + "\" not found in script directory\n\nIf the script has been uninstalled, shortcuts must be removed manually") title:"Warning"
)

macroScript MyMacroscriptWithLessParameters buttonText:"MyMacroscriptWithLessParameters" Icon:#("MyMacroscript",1)
(
	-- blabla
	messagebox "toto"
)

-- functions can be identified by the term "fn" or by "function", this with the same behavior
-- return value is not mandatory
-- indentations are not madatory
fn myFunction01 =
(
	local lMyVar = "toto"		-- the use of "local" is not mandatory
	return lMyVar
)

function myFunction02 myParam =
(
	messagebox ("myParam: " + myParam as string)
)

function myFunction03 myOptionalParam: myOptionalParam02:"my default value" =			-- optional parameters ends with : and may be followed by an initisalization value
(
	messagebox ("myOptionalParam02: " + myOptionalParam02 as string)
)

struct tWkSubstanceObjectBoundaries
(
	myVariable,							-- initialization of the variables is not mandatory
	myOtherVariable = undefined,

	fn mfDisplayInfos =
	(
		format "\myVariable: %\n" (if undefined != myVariable then myVariable.name else "undefined")
	),

	fn mfInit rScriptRootDir: =
	(
		if unsupplied != rScriptRootDir do
			mSCRIPTROOTDIR = rScriptRootDir
	)

	-- note that there is no coma at the end of the last variable or function of the structure
)

struct tMySecondStructure
(
	myVariable,							-- initialization of the variables is not mandatory
	myOtherVariable = undefined,

	fn mfDisplayInfos02 =
	(
		format "\myVariable: %\n" (if undefined != myVariable then myVariable.name else "undefined")
	),

	fn mfInit rScriptRootDir: =
	(
		if unsupplied != rScriptRootDir do
			mSCRIPTROOTDIR = rScriptRootDir
	)

	-- note that there is no coma at the end of the last variable or function of the structure
)
