/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***

//---------------------------------------------------------------------------------------------------------//
*** Delete this block when the convertion from the template to the script is finished ***********************

-- Use of the template:
  ---------------------
  
	- look for the following words in the code and add your own code there:
		--- Template: Add your code here ---

*** Delete this block when the convertion from the template to the script is finished ***********************
//---------------------------------------------------------------------------------------------------------//
   

-- Purpose:
-----------   
	--- Template: Add your code here ---
	The purpose of this script is to...
	
	A script for TemplateProject
	3dsMax Supported Versions:	x.x
	Online Documentation:		
	
	Author: 	-
	Contact:	-
	Website:	-
	Copyright:	TemplateProject
	
	
-- Install:
-----------

	--- Template: Add your code here ---
	Drag and drop TemplateScript.mzp inside 3dsMax.
	You can create a macroscript button or launch the script by a script command call.
	
	To create a macroscript button:
	-------------------------------
	
	Launch 3DSMax. In the menu toolbar, choose "Customize", then "Customize User Interface". Choose
	"TemplateProject" in the "Category" dropdownlist, then select the script you want to install and
	drag and drop the associated icon on the desired toolbar. If no toolbar exist, you can create
	one by clicking on the button "new" at the right of the "Category" dropdownlist. 

	If the script name appears several times in the list, one or more previous verions are still
	installed on your system. 

	To run the script, just click on the button you just added. 
	
	
	To launch the script by a script command call:
	----------------------------------------------
	
	Use either:
		filein ((getdir #maxroot) + "Scripts\\TemplateProject\\TemplateScript\\_ScriptLauncher.ms")
	Or:
		gtTemplateScript = filein ((getdir #maxroot) + "Scripts\\TemplateProject\\TemplateScript\\TemplateScript.ms")
		gtTemplateScript.mfLaunchGui()

	
-- Use:
-------
   --- Template: Add your code here ---

    
-- Package files:
-----------------
	The following files are included in the script package:
	
		- [3DsMax]/Scripts/TemplateProject/TemplateScript/ (all files)
		- [3DsMax]/UI/Macroscripts/TemplateScript/TemplateScript_Macroscript.mcr
   	
    
-- Notes:
---------
	- Script based on template file compatible with WkDevTool (copyright WerwacK)
	
-- to do:
---------
	- replace hardcoded script name by mSCRIPTNAME
	
-- Known troubles:
------------------  


-- Version history:
-------------------


-- V1.0: (2016/mm/dd)
		- basic version

-- Based on Template Script Version 2.0 (10/09/2016)
		*** Keep the reference to the template script version for tracking ***


*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/

--format "TemplateScript - Loading...\n   "

global gbUseWkDevMode									-- global variable used by WkDevTool for scripts developments
global gbWkVerbose = if undefined == gbWkVerbose then false else gbWkVerbose	-- global debug variable. When set to true, it can provide to get more debug information (use WkDevTool to control it)

global gtTemplateScript
global gTemplateScriptDialogWin							-- global variable for mDialogWin. Use mDialogWin in the code
global gtTemplateScriptOptionsMenu = undefined			-- variable used to store the option menu

struct tTemplateScript
(
	-- libraries
	mptStdLib = undefined,								-- Lib instance (may not be required)
	mptToolsLib = undefined,							-- Lib instance (may not be required)

	-- constants
	mSCRIPTNAME = "TemplateScript",						-- Name of the script
	mVERSION = 1.0,										-- *** mandatory member *** - version of the script. Note: this version number is also used to set the value of the version
														-- in the init file (done in mfInit)
	mPROJECTNAME = "TemplateProject",						-- Name (string) of the projet to which this script belongs to (can be the name of the company or the project this script has been developped for)
														-- This name is also used:
														-- 		- as the name of the folder in which this script is stored (first folder below "scripts")
														--		- as the name of the category to which the macroscript belongs
	
	mINSTALLFULLPATH = undefined,						-- *** Do not modify - May be changed by the installer if the user specifies a custom path at installation time
														-- Can be: #maxData (default - the script package is installed at getDir #maxData ("C:\Users\<UserName>\AppData\Local\Autodesk\3dsMax\<ReleaseNumber> - 64bit\ENU\")
														-- or a full absolute path if the user has set a custom path
														-- *** if WkDevTool is not used to pack the package, set this value to #maxData
														
	-- pathes
	mPACKAGEROOTDIR = undefined,						-- set in mfInit according to the status of WkDevTool
														-- must be used allover in the script to get 3dsMax root dir, ends with \
	mSCRIPTROOTDIR = undefined,							-- set in mfInit according to the status of WkDevTool
														-- must be used allover in the script to get this script root dir, ends with \ (should have the value: #maxdata\scripts\TemplateProject\TemplateScript\)
	mINITFILE,											-- init file full path corresponding to \scripts\mProjectName\TemplateScript\TemplateScript.ini
														
	-- members
	mDialogWindowPos = point2 -100 -100,				-- x, y ; values are at undefined so that the scripts opens in the middle of the screen at fisrt launch (usefull when woring on 2 screens)-- 250 300
	mDialogWindowSize = point2 200 180,					-- width of the window, height of THE TOP PART of the window (ie height of the window minus height of the sub rollouts)
														-- Those dimensions need only to be stored in the init file if the script window is dynamically resizable
	
	-- rollouts
	mDialogWin,											-- main rollout used as the GUI dialog boox
	mSubRollouts,										-- array containing the loaded subrollouts. After the call to mfLaunchGui, this array shoud have the same content as the subrollout array of mDialogWin (TemplateScript.mDialogWin.subroll.rollouts)
	
	
	-- custom attributes								-- attributes added to specialize the script
	--- Template: Add your code here ---
	

	------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------
	
					-- miscellaneous functions
					
	------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------
	-- *** mandatory function ***
	fn mfInit =
	(
		-- mandatory block
		-- ***********************************
		
			if true == gbUseWkDevMode and undefined != WkDevTool and "TemplateScript" == wkdevtool.mfGetCurrentScriptName() then
			(
				 mPACKAGEROOTDIR = wkdevtool.mfGetDevDir(#packageroot)
				 if undefined != mINSTALLFULLPATH do
					messagebox "Warning: Launching local installation with WkDevTool Mode On\n\nThis can lead to unpredictable results"
			)
			else
			(-- wkip faire plus précis comme feedbacks
				local lbInstallPathIsOk = false
				if undefined == mINSTALLFULLPATH then
				(
				--	messagebox "mINSTALLFULLPATH is undefined\n\nScript cannot be launched"
					-- case when simple installer is used
					mINSTALLFULLPATH = getDir #maxData
					mPACKAGEROOTDIR = getDir #maxData
					lbInstallPathIsOk = true
				)
				else if #maxData != mINSTALLFULLPATH and not doesFileExist mINSTALLFULLPATH then
					messagebox "mINSTALLFULLPATH is defined but not found - Check the ini file\n\nScript cannot be launched"
			--	else if not doesFileExist (mPACKAGEROOTDIR + "scripts\\" + mPROJECTNAME + "\\TemplateScript\\") then
			--		messagebox "Installed script directory is invalid. Please check the value of mINSTALLFULLPATH"
				else
				(
					if #maxData == mINSTALLFULLPATH then
						mPACKAGEROOTDIR = getDir #maxData
					else mPACKAGEROOTDIR = mINSTALLFULLPATH
					lbInstallPathIsOk = true
				)
				
				if not lbInstallPathIsOk do return()
			)
			
			mSCRIPTROOTDIR = mPACKAGEROOTDIR + "scripts\\" + mPROJECTNAME + "\\" + mSCRIPTNAME + "\\"
		
			------------------------------------------------------------------------------------------
			-- libraries instanciation - delete or comment this block if libraries are not used
			-- ***** <libraries> ******
			-- getting libraries, they can be encrypted
				local lScriptLibsPath = mSCRIPTROOTDIR + "Libraries\\"
				local lFileToLoadArr

			-- WkStdLib			
				lFileToLoadArr = getFiles (lScriptLibsPath + "WkStdLibV*.ms")
				if 0 == lFileToLoadArr.count do					-- .ms lib not found
				(
					lFileToLoadArr = getFiles (lScriptLibsPath + "WkStdLibV*.mse")
					if 0 != lFileToLoadArr.count then
						if gbWkVerbose do format "Using encrypted library for gtTemplateScript.mptStdLib\n"
					else messagebox "*** Warning: TemplateScript : WkStdLib Library not found ***\n"
				)
				if 0 != lFileToLoadArr.count do
				(
					local lStdLibPath = lFileToLoadArr[1]
					if gbWkVerbose do format "lStdLibPath: %, lScriptLibsPath: %\n" lStdLibPath lScriptLibsPath
					mptStdLib = filein lStdLibPath					-- StdLib instance (may not be useful for the scripts specification but is required by the gui  - increment the version of the lib if you modify it)
				)
				
			-- WkToolsLib
				lFileToLoadArr = getFiles (lScriptLibsPath + "WkToolsLibV*.ms")
				if 0 == lFileToLoadArr.count do
				(
					lFileToLoadArr = getFiles (lScriptLibsPath + "WkToolsLibV*.mse")
					if 0 != lFileToLoadArr.count then
						if gbWkVerbose do format "Using encrypted library for gtTemplateScript.mptToolsLib\n"
					--else messagebox "*** Warning: TemplateScript : WkToolsLib Library not found ***\n"
				)
				if 0 != lFileToLoadArr.count then
				(
					mptToolsLib = filein (lFileToLoadArr[1])		-- ToolsLib instance (may not be required at all - increment the version of the lib if you modify it)
					mptToolsLib.mfSetStdLib mptStdLib				-- we use the same standard library for the script instance and the Tools library
				)
				
			-- ***** </libraries> ******
			------------------------------------------------------------------------------------------
			
			-- ***** <init_file> ******
				-- init file is mandatory and cannot be deleted from the script folder
				mINITFILE = mSCRIPTROOTDIR + mSCRIPTNAME + ".ini"
				local lbInitFileExists = doesfileexist mINITFILE
				if not lbInitFileExists then
					messageBox ("*** TemplateScript: Init File not found ***\n\n        Requested file: " + mINITFILE + "\n\nCannot create a fully functionnal new init file\nIt is recommanded to re-install the script or to contact your TD") title:"TemplateScript"
				
				-- get the init values and fill the init file with default values if they don't exist
				if lbInitFileExists do
				(
					setINISetting mINITFILE "ScriptSettings" "Name" mSCRIPTNAME
					setINISetting mINITFILE "ScriptSettings" "Version" (mVERSION as string)
					setINISetting mINITFILE "ScriptSettings" "MacroGroup" "Main UI"
					setINISetting mINITFILE "ScriptSettings" "MacroCategory" mPROJECTNAME

					mDialogWindowPos.x	= (mptStdLib.mfGetINISetting mINITFILE "UserSettings_GUI" "WindowPosX" rDefaultKeyValueStr:(mDialogWindowPos.x as string)) as integer
					mDialogWindowPos.y	= (mptStdLib.mfGetINISetting mINITFILE "UserSettings_GUI" "WindowPosY" rDefaultKeyValueStr:(mDialogWindowPos.y as string)) as integer
				--	mDialogWindowSize.x	= (mptStdLib.mfGetINISetting mINITFILE "UserSettings_GUI" "WindowSizeW" rDefaultKeyValueStr:(mDialogWindowSize.x as string)) as integer
				--	mDialogWindowSize.y	= (mptStdLib.mfGetINISetting mINITFILE "UserSettings_GUI" "WindowSizeH" rDefaultKeyValueStr:(mDialogWindowSize.y as string)) as integer
				
				-- ***********************************
				--- Template: Add your code here ---
				)

			-- ***** </init_file> ******
			------------------------------------------------------------------------------------------
			
		-- ***********************************
		--- Template: Add your code here ---
		
	),

	-- set the user init settings to the default values
	-- rSettingsToResetArr:				specify which group of settings has to be reset - not required if rbAskForResetOfUserInitSettings is set to true
	-- rbAskForResetOfUserInitSettings:	ask the user for a reset. If set to false, you need to give an array for rSettingsToResetArr
	-- rbDisplayMessageForNewScriptInstance: just add a line in the window to say that the script has been reset
	-- rInitFileToReset:				the file to be reset. In most cases it will be mINITFILE. This is used when a package is created with WkDevTool
	fn mfResetUserInitSettings rSettingsToResetArr: rbAskForResetOfUserInitSettings:true rbDisplayMessageForNewScriptInstance:false rInitFileToReset: =
	(
		local lInitFileToReset = if unsupplied == rInitFileToReset then mINITFILE else rInitFileToReset
		local lbResetUserInitSettings = false
		
		global gSettingsToResetArr = if unsupplied == rSettingsToResetArr then #(#GUI) else copy rSettingsToResestArr
		try( DestroyDialog gtTemplateScript_ResetUserSettingsDialog ) catch()
		global gInitFileToReset = copy lInitFileToReset
		global gReinstanceLabPos = if rbDisplayMessageForNewScriptInstance then 20 else -200

		if rbAskForResetOfUserInitSettings do
		(
			rollout gtTemplateScript_ResetUserSettingsDialog " TemplateScript: Reset User Init Settings"
			(
				label reinstanceLab "*** Script has been reinstanciated ***" align:#left offset:[-200,0]
				label initFileNameLab "Init file: -" align:#left offset:[16,8]
				label resetGUISettingsLab "Which User Init Settings do you want to reset?" align:#left offset:[16,8]
				checkbox resetGUISettingsChkbx "GUI: Window position, checkbox settings..." align:#left offset:[110,10] checked:true
				
				button resetBut "Reset" align:#center width:60 height:24 offset:[-40,26] 
				button cancelBut "Cancel" align:#center width:60 height:24 offset:[40,-29]
				
				on resetBut pressed do
				(
					gSettingsToResetArr = #()
					if resetGUISettingsChkbx.checked do append gSettingsToResetArr #GUI
					try( DestroyDialog gtTemplateScript_ResetUserSettingsDialog ) catch()
				)
				on cancelBut pressed do
				(
					gSettingsToResetArr = #()
					try( DestroyDialog gtTemplateScript_ResetUserSettingsDialog ) catch()
				)

				on gtTemplateScript_ResetUserSettingsDialog open do
				(
					initFileNameLab.text = "Init file: " + filenameFromPath gInitFileToReset
					reinstanceLab.pos.x = gReinstanceLabPos
				)
			)
			
			CreateDialog gtTemplateScript_ResetUserSettingsDialog width:500 height:184 style:#( #style_minimizebox, #style_titlebar, #style_sysmenu, #style_toolwindow) modal:true
		)
		
		if 0 != gSettingsToResetArr.count do
			if querybox "Are you sure you want to reset the User Init Settings?\n\nThis cannot be undone" title:"TemplateScript" do
			(
				gtTemplateScript.mfCloseGui()
				
				if not doesFileExist lInitFileToReset then
					messageBox ("Following Init File not found:\n\n    " + lInitFileToReset + "\n\nReset of User Init Settings aborted") title:"TemplateScript"
				else
				(
					if 0 != findItem gSettingsToResetArr #GUI do		-- reset main user settings
					(
						local lKeysArr = getINISetting lInitFileToReset "UserSettings_GUI"
						for lKey in lKeysArr do
							setINISetting lInitFileToReset "UserSettings_GUI" lKey ""
						
						-- force window position to a specific value so that the window will open at the center of the screen next time
						setINISetting mINITFILE "UserSettings_GUI" "WindowPosX" "-100"
						setINISetting mINITFILE "UserSettings_GUI" "WindowPosY" "-100"
						
						lbResetUserInitSettings = true					-- always add this for the returned value
					)
					
					-- ***********************************
					--- Template: Add your code here for specific treatment of the init file ---
				)
			)
		
		return lbResetUserInitSettings
	),

	fn mfSaveGuiToIniFile =
	(
		setINISetting mINITFILE "UserSettings_GUI" "WindowPosX" (mDialogWindowPos.x as string)
		setINISetting mINITFILE "UserSettings_GUI" "WindowPosY" (mDialogWindowPos.y as string)
		-- enable the following lines only if the script has a resizable dialog window
	--	setINISetting mINITFILE "UserSettings_GUI" "WindowSizeW" (mDialogWindowSize.x as string)
	--	setINISetting mINITFILE "UserSettings_GUI" "WindowSizeH" (mDialogWindowSize.y as string)

		-- auto save state of controls with a name ending by "_AS" (for Auto Save)
		mptStdLib.mfAutoSaveGuiToIniFile mDialogWin mINITFILE
	
		-- ***********************************
		--- Template: Add your code here ---
		-- add the name of the graphic components to save
		-- eg:	setINISetting mINITFILE "EFBX_UserSettings_GUI" "DestFolderhMode" (mDialogWin.exportToModeRadbut.state as string)
	),
	
	fn mfRestoreGuiFromIniFile =
	(
		-- auto restore state of controls with a name ending by "_AS" (for Auto Save)
		mptStdLib.mfAutoRestoreGuiFromIniFile mDialogWin mINITFILE
	
		-- ***********************************
		--- Template: Add your code here ---
		-- add the name of the graphic components to save
		-- eg:	mDialogWin.exportToModeRadbut.state = (mptStdLib.mfGetINISetting mINITFILE "EFBX_UserSettings_GUI" "DestFolderhMode" rDefaultKeyValueStr:(mDialogWin.exportToModeRadbut.state as string)) as integer
	),
	
	-- compute the size of the sub rollouts, according to there state (rolled up or not)
	-- wkip prendre la somme des rollouts ouverts?
	fn mfGetRolloutsHeight =
	(
		return mDialogWin.Subroll.height
	),
	
	-- return rVersion (float) as a formatted string so as to ends with '.0' for round numbers
	fn mfGetFormattedVersion rVersion =
	(
		local lVersionStr = rVersion as string
		if (integer == classof rVersion) do lVersionStr += ".0"
		
		return lVersionStr
	),
	
	-------------------------------------------------------------------------------
	-- *** mandatory function ***
	-- function used to update the dialog window settings, and more generally the GUI, according to the member values
	-- *** Do never change member values in this function!! ***
	fn mfUpdateGui =
	(
		if undefined != mDialogWin and mDialogWin.open do
		(
		--	format "mfUpdateGui\n"
			-- update dialog height according to rollouts state, also update tooltips
			mDialogWin.Subroll.height = if 1 == mDialogWin.Subroll.rollouts.count then 6 else 0 --2 * mDialogWin.Subroll.rollouts.count
			for i = 1 to mDialogWin.Subroll.rollouts.count do
			(
				if mDialogWin.Subroll.rollouts[i].open then
					mDialogWin.Subroll.height += (mDialogWin.Subroll.rollouts[i].height + 32)	-- 30
				else mDialogWin.Subroll.height += 30		--27
			)
			mDialogWin.Subroll.height -= ((mDialogWin.Subroll.rollouts.count - 1) * 4.5) as integer
			mDialogWin.height = mDialogWindowSize.y + mfGetRolloutsHeight()
			
		-- ***********************************
		--- Template: Add your code here ---
		-- add the update of your GUI here

		)
	),
	
	
	-- ***********************************
	--- Template: Add your code here ---
	-- add your functions here
	
	
	-------------------------------------------------------------------------------
	
	fn mfOpenOptionsMenu =
	(
		RCMenu gtTemplateScriptOptionsMenu
		(
			MenuItem openHelpMI "Open Documentation"
			Seperator initSep
			MenuItem openResetInitFileMI "Open Script Init File / + Shift: Reset User Settings in Init File"
			MenuItem openScriptFolderMI "Open Script Folder"
		--	MenuItem uninstallMI "Uninstall Script"
			Seperator aboutSep
			MenuItem aboutMI "About / Feedback / Bug repport" 
			
			on openHelpMI picked do
				try( if not (ShellLaunch ((gtTemplateScript.mPACKAGEROOTDIR) + "Help\\" + gtTemplateScript.mPROJECTNAME + "\\TemplateScript\\TemplateScript_Reference.doc") "") do
						 messagebox ("Cannot open documentation file in 3dsMax directory\n") title:"Warning"
					)
				catch( messagebox ("Documentation file not found in 3dsMax directory\n") title:"Warning" ) 

			on openResetInitFileMI picked do
			(
				if keyboard.shiftPressed then	-- reset init settings
					if (gtTemplateScript.mfResetUserInitSettings rbAskForResetOfUserInitSettings:true rbDisplayMessageForNewScriptInstance:true) do
					(
						-- dialog window is closed into the reset function
						gtTemplateScript = undefined
						messagebox "User Settings have been reset in the Init file,\n\nPlease relaunch the script to use the default settings" title:"gtTemplateScript"
					)
				else		-- open init settings file
				(
					if doesFileExist gtTemplateScript.mINITFILE then
						shellLaunch gtTemplateScript.mINITFILE ""
					else
					(
						messagebox ("Script Init not found:\n\n" + gtTemplateScript.mINITFILE)
						local lDir = getFilenamePath gtTemplateScript.mINITFILE
						if not gtTemplateScript.mptStdLib.mfOpenInExplorer lDir rbDisplayMessages:false do
							messagebox ("Script Init file folder not found either:\n\n" + lDir)
					)
				)
			)
			
			on openScriptFolderMI picked do
				gtTemplateScript.mptStdLib.mfOpenInExplorer gtTemplateScript.mSCRIPTROOTDIR

			
		/*	on uninstallMI picked do
			(
				if (querybox "Do you really want to uninstall this script?" title:"TemplateScript") do
				(
					gtTemplateScript.mfCloseGui()
					if doesFileExist ((gtTemplateScript.mSCRIPTROOTDIR) + "UninstallScriptInfo.txt") then
					(
						gtTemplateScript.mptStdLib.deleteFilesFromListFile ((gtTemplateScript.mSCRIPTROOTDIR) + "UninstallScriptInfo.txt")
						gtTemplateScript = undefined
					)
				else messagebox ("Uninstall file info not found in script folder\nUninstall aborted...") title:"Warning"
				)	
			)
		*/	
			on aboutMI picked do
			(
				local lAboutStr = "A script for " + gtTemplateScript.mProjectName
				lAboutStr += "\nVersion " + gtTemplateScript.mVERSION as string
				
				-- description of the script and its versions
				--- Template: Add your code here ---
				
				lAboutStr += "\n\nContact and feedback:"
				lAboutStr += "\n   For questions, feedback and to repport a bug, please send an e-mail at:"
				lAboutStr += "\n<hyperlink>hyperLink contactlnk \"" + gtTemplateScript.mProjectName + " Maxscript Support\" address:\"mailto:werwack@werwackfx.com?subject=WerwackScripts Support - TemplateScript V" + gtTemplateScript.mVERSION as string + " : &body=Hello,\" color:(color 10 10 240) hoverColor:(color 200 20 20) visitedColor:(color 10 10 240) align:#center offset:[0,0]</hyperlink>"
				
				gtTemplateScript.mptStdLib.mfMessageBox lAboutStr rTitleStr:"About / Feedback"
			)
		)
		
		PopupMenu gtTemplateScriptOptionsMenu rollout:gTemplateScriptDialogWin
	),

	-------------------------------------------------------------------------------

	-- ***********************************
	--- Template: Add your code here ---
	-- add new sub rollouts here
	
	-- Check if some subrollouts are available (files named *subrollout.ms located in the script folder)
	-- and load them. Subrollouts are ordered according to the first 2 letters of their filename
	fn mfLoadSubRollouts =
	(
		-- sub function used to localy sort rollouts according to their name
		function lSortRolloutsByName rIndRollA rIndRollB rFileNamesArr: =
		(
			local lRollAPos = (rFileNamesArr[rIndRollA][1] + rFileNamesArr[rIndRollA][2]) as integer
			local lRollBPos = (rFileNamesArr[rIndRollB][1] + rFileNamesArr[rIndRollB][2]) as integer
			
			case of
			(
				(undefined == lRollAPos and undefined == lRollBPos): 0
				(undefined == lRollAPos and undefined != lRollBPos): 1
				(undefined != lRollAPos and undefined == lRollBPos): -1
				(lRollAPos > lRollBPos): 1
				(lRollAPos < lRollBPos): -1
				default: 0
			)
		)

		local lSubRolloutFilesArr = #()
		local lSubRolloutFileNamesArr = #()
		mSubRollouts = #()
		
		lSubRolloutFilesArr = getFiles (mSCRIPTROOTDIR + "*subrollout*.ms?")
		if 0 != lSubRolloutFilesArr.count do
		(
			for lSubRollFile in lSubRolloutFilesArr do
			(
				append lSubRolloutFileNamesArr (getFileNameFile lSubRollFile)
				append mSubRollouts (fileIn lSubRollFile)
			
				-- add the rolledup state of the rollout to the init file
				local lbRolledUp = (mptStdLib.mfGetINISetting mINITFILE "UserSettings_GUI" (mSubRollouts[mSubRollouts.count].name + "_RolledUp") rDefaultKeyValueStr:(true as string)) as booleanClass
			)
		
			-- collected rollouts are re-ordered according to their filename
			local lIndexArr = for i=1 to lSubRolloutFileNamesArr.count collect i
			qsort lIndexArr lSortRolloutsByName rFileNamesArr:lSubRolloutFileNamesArr
			local lTmpArr = for i=1 to mSubRollouts.count collect mSubRollouts[i]
			for i=1 to lIndexArr.count do
				mSubRollouts[i] = lTmpArr[lIndexArr[i]]
		)
	),
	
	
	-------------------------------------------------------------------------------
	-- main rollout 
	fn mfLoadDialogWin =
	(
		try( DestroyDialog gTemplateScriptDialogWin ) catch()
		
		mDialogWin = rollout gTemplateScriptDialogWin "TemplateScript"
		(
			button optionsBut "Options"	tooltip:"Options"
						images:#(	((gtTemplateScript.mSCRIPTROOTDIR) + "Icons\\Signs_22i.bmp"), ((gtTemplateScript.mSCRIPTROOTDIR) + "Icons\\Signs_22a.bmp"), \
						10, 3, 3, 4, 4) border:false width:14 height:26 align:#right offset:[10,0]
			label optionlab align:#left offset:[0,-46]

			on optionsBut pressed do gtTemplateScript.mfOpenOptionsMenu()
	
		----------------------
		--	custom buttons
		----------------------
		--- Template: Add your code here ---
		
			label prodlab "TemplateScript" align:#left offset:[0,4]

		----------------------
		--- samples block start --
		
			label sampleslab "Sample Components:" align:#left offset:[0,14]

			checkbutton sampleChkbut "Checkbutton" tooltip:"Sample Checkbutton" width:160 align:#left offset:[5,6] 
			on sampleChkbut changed stat do
				messageBox ("Checked: " + stat as string)
			
			button sampleChkbutQuickHelpBut "QuickHelp" tooltip:"Quick Help"
						images:#(	(gtTemplateScript.mSCRIPTROOTDIR + "Icons\\Signs_22i.bmp"), (gtTemplateScript.mSCRIPTROOTDIR + "Icons\\Signs_22a.bmp"), \
						10, 1, 1, 2, 2) border:false width:12 height:24 align:#right offset:[8,-27]
			on sampleChkbutQuickHelpBut pressed do
			(
				local lStr = "Standard checkbutton"
				gtTemplateScript.mptStdLib.mfMessageBox lStr rTitleStr:"Quick Help" -- rWidth:600 rHeight:110
			)

			
			checkbutton sampleChkbut_AS "Checkbutton with saved state" tooltip:"Sample Checkbutton with automatic save and restore of its state" width:160 align:#left offset:[5,4] 
			on sampleChkbut_AS changed stat do
				messageBox ("Checked: " + stat as string)
			
			button sampleChkbutASQuickHelpBut "QuickHelp" tooltip:"Quick Help"
						images:#(	(gtTemplateScript.mSCRIPTROOTDIR + "Icons\\Signs_22i.bmp"), (gtTemplateScript.mSCRIPTROOTDIR + "Icons\\Signs_22a.bmp"), \
						10, 1, 1, 2, 2) border:false width:12 height:24 align:#right offset:[8,-27]
			on sampleChkbutASQuickHelpBut pressed do
			(
				local lStr = "When a control name ends with \\\"_AS\\\" then its state is automatically saved \nand will be restored when the script is instanciated again."
				gtTemplateScript.mptStdLib.mfMessageBox lStr rTitleStr:"Quick Help" -- rWidth:600 rHeight:110
			)

		--- samples block end --
		----------------------


		
		----------------------
		--	end of custom buttons
		----------------------
			
			label headerButtonslab align:#left pos:[0,mDialogWindowSize.y - 18]
			subRollout subroll "SubRoll" width:(mDialogWindowSize.x + 15) height:0 align:#center offset:[0,10]
					
			on gTemplateScriptDialogWin resized sizeval do
			(
				gtTemplateScript.mDialogWindowSize.x = sizeval.x
				gtTemplateScript.mDialogWindowSize.y = sizeval.y - gtTemplateScript.mfGetRolloutsHeight()
				gtTemplateScript.mfUpdateGui()
			)
		
			on gTemplateScriptDialogWin open do
			(
				gtTemplateScript.mfRestoreGuiFromIniFile()
				gtTemplateScript.mfUpdateGui()
			)

			on gTemplateScriptDialogWin moved moveval do
				gtTemplateScript.mDialogWindowPos = moveval
			
			on gTemplateScriptDialogWin close do
				gtTemplateScript.mfSaveGuiToIniFile()
		)
		
		return mDialogWin
	),


	-------------------------------------------------------------------------------
	-- *** mandatory function ***
	fn mfCloseGui =
	(
		try( DestroyDialog mDialogWin ) catch()
	),
	
	-------------------------------------------------------------------------------
	-- *** mandatory function ***
	fn mfLaunchGui rbDisplayDialog: =
	(
	--	format "TemplateScript: mfLaunchGui\n"
		mfCloseGui()

		-- toolbox window type; add #style_toolwindow for a smaller window titlebar
		local lWindowStyleArr = #( #style_minimizebox, #style_toolwindow, #style_sysmenu )

		if -100 == mDialogWindowPos.x then
			CreateDialog mDialogWin mDialogWindowSize.x mDialogWindowSize.y style:lWindowStyleArr
		else CreateDialog mDialogWin mDialogWindowSize.x mDialogWindowSize.y mDialogWindowPos.x mDialogWindowPos.y style:lWindowStyleArr
		mDialogWin.title = " TemplateScript - V." + (mfGetFormattedVersion mVERSION)
		
		-- subrollouts are ordered according to their name, inside mfLoadSubRollouts
		-- by default they are all rolled up. The rolled up state is saved into the init file when the main dialog is closed
		for lSubRoll in mSubRollouts do
			addSubRollout mDialogWin.Subroll lSubRoll rolledup:((mptStdLib.mfGetINISetting mINITFILE "UserSettings_GUI" (lSubRoll.name + "_RolledUp") rDefaultKeyValueStr:(false as string)) as booleanClass)
		
		mfUpdateGui()
	)
)
	

-------------------------------------------------------------------------------
-- load of the script

try( DestroyDialog gTemplateScriptDialogWin ) catch()
try( DestroyDialog gtTemplateScript_ResetUserSettingsDialog ) catch()

global lbTmpWasShiftKeyPressed = keyboard.shiftPressed		-- a variable is required here because a messagebox is displayed in mfResetUserInitSettings() and the user may release the shift key

-- when pressing shift, the structure instance is recreated
-- not recreating the instance allow the user to keep his settings during a Max session
if undefined == gtTemplateScript or lbTmpWasShiftKeyPressed or \
	(undefined != WkDevTool and "TemplateScript" == wkdevtool.mfGetCurrentScriptName() and true == WkDevTool.mbReinstanciateScript) do
(
	gtTemplateScript = tTemplateScript()
	gtTemplateScript.mfInit()
)

-- delete init user settings?
if undefined != gtTemplateScript and (lbTmpWasShiftKeyPressed or (undefined != WkDevTool and true == WkDevTool.mbResetUserInitSettings)) do
(
	try ( gtTemplateScript.mfResetUserInitSettings rbAskForResetOfUserInitSettings:true rbDisplayMessageForNewScriptInstance:true )
	catch ( messagebox "*** TemplateScript startup: Cannot launch function mfResetUserInitSettings" title:"TemplateScript" )
	gtTemplateScript = tTemplateScript()
	gtTemplateScript.mfInit()
)

gtTemplateScript.mfLoadDialogWin()
gtTemplateScript.mfLoadSubRollouts()
gtTemplateScript.mfUpdateGui()		-- wkip utile?


-- *** enable line for debug only *** The launch (ie the opening of the dialog window) is done in _ScriptLauncher.ms
--gtTemplateScript.mfLaunchGui()

-- Begining of the sentence may be activated at the begining of the script
--if gbWkVerbose do
	format "\nTemplateScript V% loaded. Instance: gtTemplateScript\n" gtTemplateScript.mVERSION

-- *** THIS LINE MUST BE THE LAST LINE OF THE SCRIPT ***
-- otherwise the structure variable is not correctly returned
gtTemplateScript



