/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***


-- Purpose:
-----------   
	
	The purpose of this script is to gather all the cutom tools developped in production on one single toolbar.
	The script also set the projects environment and the paths to the assets.
	
	Features:
		- checks if a user has access to a project and allows its use only if so
	
	A WerwacKScripts script
	3dsMax Supported Versions:	2010 and more
	Contact: -
	Website: -
	Copyright: WerwacKScripts
	
-- Install:
-----------

	--- Template: Add your code here ---
	Drag and drop WkProjectToolbar.mzp inside 3dsMax.
	You can create a macroscript button or launch the script by a script command call.
	
	To create a macroscript button:
	-------------------------------
	
	Launch 3DSMax. In the menu toolbar, choose "Customize", then "Customize User Interface". Choose
	"WerwacKScripts" in the "Category" dropdownlist, then select the script you want to install and
	drag and drop the associated icon on the desired toolbar. If no toolbar exist, you can create
	one by clicking on the button "new" at the right of the "Category" dropdownlist. 

	If the script name appears several times in the list, one or more previous verions are still
	installed on your system. 

	To run the script, just click on the button you just added. 
	
	
	To launch the script by a script command call:
	----------------------------------------------
	
	Use either:
		filein ((getdir #maxroot) + "Scripts\\WerwacKScripts\\WkProjectToolbar\\_ScriptLauncher.ms")
	Or:
		gtWkProjectToolbar = filein ((getdir #maxroot) + "Scripts\\WerwacKScripts\\WkProjectToolbar\\WkProjectToolbar.ms")
		gtWkProjectToolbar.mfLaunchGui()

	
-- Use:
-------
   --- Template: Add your code here ---

    
-- Package files:
-----------------
	The following files are included in the script package:
	
		- [3DsMax]/Scripts/WerwacKScripts/WkProjectToolbar/ (all files)
		- [3DsMax]/UI/Macroscripts/WkProjectToolbar/WkProjectToolbar_Macroscript.mcr
   	
    
-- Notes:
---------
	- Script based on template file compatible with WkDevTool (copyright WerwacK)
	
-- to do:
---------

   - voir comment les infos de scripts installés sont en place
	
-- Known troubles:
------------------  


-- Version history:
-------------------


-- V1.0: (2010/mm/dd)
		- basic version



*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/

--format "WkProjectToolbar - Loading...\n   "

global gbUseWkDevMode									-- global variable used by WkDevTool for scripts developments
global gbWkVerbose = if undefined == gbWkVerbose then false else gbWkVerbose	-- global debug variable. When set to true, it can provide to get more debug information (use WkDevTool to control it)

global gtWkProjectToolbar
global gWkProjectToolbarDialogWin							-- global variable for mDialogWin. Use mDialogWin in the code
global gtWkProjectToolbarOptionsMenu = undefined			-- variable used to store the option menu

struct tWkProjectToolbar
(
	-- libraries
	mptStdLib = undefined,								-- StdLib instance (may not be required)
	mptToolsLib = undefined,							-- StdLib instance (may not be required)

	-- constants
	mVERSION = 1.0,										-- *** mandatory member *** - version of the script. Note: this version number is also used to set the value of the version
														-- in the init file (done in mfInit)
	mPROJECTNAME = "WerwacKScripts",					-- Name (string) of the projet to which this script belongs to (can be the name of the company or the project this script has been developped for)
														-- This name is also used:
														-- 		- as the name of the folder in which this script is stored (first folder below "scripts")
														--		- as the name of the category to which the macroscript belongs
	-- pathes
	mMAXROOTDIR = undefined,							-- set in mfInit according to the status of WkDevTool
														-- must be used allover in the script to get 3dsMax root dir, ends with \
	mSCRIPTROOTDIR = undefined,							-- set in mfInit according to the status of WkDevTool
														-- must be used allover in the script to get this script root dir, ends with \ (should have the value: #maxroot\scripts\WerwacKScripts\WkProjectToolbar\)
	mINITFILE,											-- init file full path corresponding to \scripts\mProjectName\WkProjectToolbar\WkProjectToolbar.ini
														
	-- members
	mDialogWindowPos = point2 -100 -100,				-- x, y ; values are at undefined so that the scripts opens in the middle of the screen at fisrt launch (usefull when woring on 2 screens)-- 250 300
	mDialogWindowSize = point2 170 60,					-- width of the window, height of THE TOP PART of the window (ie height of the window minus height of the sub rollouts)
														-- Those dimensions need only to be stored in the init file if the script window is dynamically resizable
	mbUndockResizing = false,							-- Short time flag - used by the Resize callback when the dialog is BEING docked or undocked to keep the dialog dimensions at the right size
		
	-- rollouts
	mDialogWin,											-- main rollout used as the GUI dialog boox
	mSubRollouts,										-- array containing the loaded subrollouts. After the call to mfLaunchGui, this array shoud have the same content as the subrollout array of mDialogWin (WkProjectToolbar.mDialogWin.subroll.rollouts)
	
	
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
		
			if true == gbUseWkDevMode and undefined != WkDevTool and "WkProjectToolbar" == wkdevtool.mfGetCurrentScriptName() then
				 mMAXROOTDIR = wkdevtool.mfGetDevDir(#maxroot)
			else mMAXROOTDIR = getDir #maxroot
			mSCRIPTROOTDIR = mMAXROOTDIR + "scripts\\" + mPROJECTNAME + "\\WkProjectToolbar\\"
		
			------------------------------------------------------------------------------------------
			-- libraries instanciation - delete or comment this block if libraries are not used
			-- ***** <libraries> ******
				local lScriptLibsPath = mSCRIPTROOTDIR + "Libraries\\"
				
				-- getting libraries, they can be encrypted
				local lFileToLoadArr, lStdLibPath, lToolsLibPath

			-- WkStdLib			
				lFileToLoadArr = getFiles (lScriptLibsPath + "WkStdLibV*.ms")
				if 0 == lFileToLoadArr.count do					-- .ms lib not found
				(
					lFileToLoadArr = getFiles (lScriptLibsPath + "WkStdLibV*.mse")
					if 0 != lFileToLoadArr.count then
						if gbWkVerbose do format "Using encrypted library for gtWkProjectToolbar.mptStdLib\n"
					else messagebox "*** Warning: WkProjectToolbar : WkStdLib Library not found ***\n"
				)
				if 0 != lFileToLoadArr.count do
				(
					if gbWkVerbose do format "lStdLibPath: %, lScriptLibsPath: %\n" lStdLibPath lScriptLibsPath
					lStdLibPath = lFileToLoadArr[1]
					mptStdLib = filein lStdLibPath					-- StdLib instance (may not be useful for the scripts specification but is required by the gui  - increment the version of the lib if you modify it)
				)
				
			-- WkToolsLib
				lFileToLoadArr = getFiles (lScriptLibsPath + "WkToolsLibV*.ms")
				if 0 == lFileToLoadArr.count do
				(
					lFileToLoadArr = getFiles (lScriptLibsPath + "WkToolsLibV*.mse")
					if 0 != lFileToLoadArr.count then
						if gbWkVerbose do format "Using encrypted library for gtWkProjectToolbar.mptToolsLib\n"
					--else messagebox "*** Warning: WkProjectToolbar : WkToolsLib Library not found ***\n"
				)
				if 0 != lFileToLoadArr.count then
				(
					lToolsLibPath = lFileToLoadArr[1]
					mptToolsLib = filein lToolsLibPath				-- ToolsLib instance (may not be required at all - increment the version of the lib if you modify it)
					mptToolsLib.mfSetStdLib mptStdLib				-- we use the same standard library for the script instance and the Tools library
				)
			-- ***** </libraries> ******
			------------------------------------------------------------------------------------------
			
			-- ***** <init_file> ******
				-- init file is mandatory and cannot be deleted from the script folder
				mINITFILE = mSCRIPTROOTDIR + "WkProjectToolbar.ini"
				local lbInitFileExists = doesfileexist mINITFILE
				if not lbInitFileExists then
					messageBox ("*** WkProjectToolbar: Init File not found ***\n\n        Requested file: " + mINITFILE + "\n\nCannot create a fully functionnal new init file\nIt is recommanded to re-install the script or to contact your TD") title:"WkProjectToolbar"
				
				-- get the init values and fill the init file with default values if they don't exist
				if lbInitFileExists do
				(
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
		global gSettingsToResetArr = if unsupplied == rSettingsToResetArr then #(#GUI) else copy rSettingsToResestArr
		try( DestroyDialog gtWkProjectToolbar_ResetUserSettingsDialog ) catch()
		local lbResetUserInitSettings = false
		
		if rbAskForResetOfUserInitSettings do
		(
			rollout gtWkProjectToolbar_ResetUserSettingsDialog " WkProjectToolbar: Reset User Init Settings"
			(
				label reinstanceLab "*** Script has been reinstanciated ***" align:#left offset:[-200,0]
				label resetGUISettingsLab "Which User Init Settings do you want to reset?" align:#left offset:[16,8]
				checkbox resetGUISettingsChkbx "GUI: Window position, checkbox settings..." align:#left offset:[110,10] checked:true
				
				button resetBut "Reset" align:#center width:60 height:24 offset:[-40,26] 
				button cancelBut "Cancel" align:#center width:60 height:24 offset:[40,-29]
				
				on resetBut pressed do
				(
					gSettingsToResetArr = #()
					if resetGUISettingsChkbx.checked do append gSettingsToResetArr #GUI
					try( DestroyDialog gtWkProjectToolbar_ResetUserSettingsDialog ) catch()
				)
				on cancelBut pressed do
				(
					gSettingsToResetArr = #()
					try( DestroyDialog gtWkProjectToolbar_ResetUserSettingsDialog ) catch()
				)
			)
			
			CreateDialog gtWkProjectToolbar_ResetUserSettingsDialog width:500 height:184 style:#( #style_minimizebox, #style_titlebar, #style_sysmenu, #style_toolwindow) modal:true
			if rbDisplayMessageForNewScriptInstance and false do gtWkProjectToolbar_ResetUserSettingsDialog.reinstanceLab.pos.x = 20
		)
		
		if 0 != gSettingsToResetArr.count do
			if querybox "Are you sure you want to reset the User Init Settings?\n\nThis cannot be undone" title:"WkProjectToolbar" do
			(
				gtWkProjectToolbar.mfCloseGui()
				
				if not doesFileExist lInitFileToReset then
					messageBox ("Following Init File not found:\n\n    " + lInitFileToReset + "\n\nReset of User Init Settings aborted") title:"WkProjectToolbar"
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
	),
	
	-- compute the size of the sub rollouts, according to there state (rolled up or not)
	-- wkip prendre la somme des rollouts ouverts?
	fn mfGetRolloutsHeight =
	(
		return mDialogWin.Subroll.height
	),
	
	-- side can be #left or #right
	fn mfDockDialog rSide =
	(
		mbUndockResizing = true
		if not mDialogWin.dialogBar do
			cui.RegisterDialogBar mDialogWin minSize:[mDialogWindowSize.x,400] maxSize:[mDialogWindowSize.x,1200] style:#(#cui_dock_all, #cui_floatable)
		--	cui.RegisterDialogBar mDialogWin style:#(#cui_dock_all, #cui_floatable, #cui_handles)
		if #left == rSide then
			 cui.DockDialogBar mDialogWin #cui_dock_left
		else cui.DockDialogBar mDialogWin #cui_dock_right
		
	--	format "mfDockDialog picked do 01\n"
		gtWkProjectToolbar.mfUpdateGui()
	--	format "mfDockDialog picked do 02\n"
		mbUndockResizing = false
	),

	fn mfUndockDialog =
	(
		mbUndockResizing = true
		if mDialogWin.dialogBar do
		(
		--	format "on miUndock picked do 01\n"
			cui.FloatDialogBar mDialogWin
			cui.UnRegisterDialogBar mDialogWin
		)
		gtWkProjectToolbar.mfUpdateGui()
	--	format "on miUndock picked do 02\n"
		mbUndockResizing = false
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
			mptStdLib.mfUpdateGuiForceComponentTooltips mDialogWin							-- update the tooltips of the dialog components
			mDialogWin.Subroll.height = if 1 == mDialogWin.Subroll.rollouts.count then 6 else 0 --2 * mDialogWin.Subroll.rollouts.count
			for i = 1 to mDialogWin.Subroll.rollouts.count do
			(
				if mDialogWin.Subroll.rollouts[i].open then
					mDialogWin.Subroll.height += (mDialogWin.Subroll.rollouts[i].height + 30)
				else mDialogWin.Subroll.height += 27
				mptStdLib.mfUpdateGuiForceComponentTooltips mDialogWin.Subroll.rollouts[i]	-- update the tooltips of the subrollouts components
			)
		--	removed when docking is used
		--	mDialogWin.Subroll.height -= ((mDialogWin.Subroll.rollouts.count - 1) * 4.5) as integer
			if not mDialogWin.dialogBar do
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
		RCMenu gtWkProjectToolbarOptionsMenu
		(
			seperator sepDock
			menuItem miDockLeft "Dock on the left"
			menuItem miDockRight "Dock on the right"
			menuItem miUndock "Undock"
			
			seperator sepHelp
			MenuItem miOpenHelp "Open Documentation"
			MenuItem miResetUserInitSettings "Reset User Settings in Init File"
		--	MenuItem miUninstall "Uninstall Script"
			Seperator sepAbout
			MenuItem miAbout "About / Feedback / Bug repport" 
			
			on miOpenHelp picked do
				try( if not (ShellLaunch ((gtWkProjectToolbar.mMAXROOTDIR) + "Help\\" + gtWkProjectToolbar.mPROJECTNAME + "\\WkProjectToolbar\\WkProjectToolbar_Reference.doc") "") do
						 messagebox ("Cannot open documentation file in 3dsMax directory\n") title:"Warning"
					)
				catch( messagebox ("Documentation file not found in 3dsMax directory\n") title:"Warning" ) 

			on miResetUserInitSettings picked do
				if (gtWkProjectToolbar.mfResetUserInitSettings rbAskForResetOfUserInitSettings:true rbDisplayMessageForNewScriptInstance:true) do
				(
					-- dialog window is closed into the reset function
					gtWkProjectToolbar = undefined
					messagebox "User Settings have been reset in the Init file,\n\nPlease relaunch the script to use the default settings" title:"gtWkProjectToolbar"
				)

			on miDockLeft picked do
			(
				gtWkProjectToolbar.mfDockDialog #left
				setINISetting gtWkProjectToolbar.mINITFILE "UserSettings_GUI" "WindowDocking" "left"
			)
			on miDockRight picked do
			(
				gtWkProjectToolbar.mfDockDialog #right
				setINISetting gtWkProjectToolbar.mINITFILE "UserSettings_GUI" "WindowDocking" "right"
			)
			on miUndock picked do
			(
				gtWkProjectToolbar.mfUndockDialog()
				setINISetting gtWkProjectToolbar.mINITFILE "UserSettings_GUI" "WindowDocking" "undocked"
			)
			
		/*	on miUninstall picked do
			(
				if (querybox "Do you really want to uninstall this script?" title:"WkProjectToolbar") do
				(
					gtWkProjectToolbar.mfCloseGui()
					if doesFileExist ((gtWkProjectToolbar.mSCRIPTROOTDIR) + "UninstallScriptInfo.txt") then
					(
						gtWkProjectToolbar.mptStdLib.deleteFilesFromListFile ((gtWkProjectToolbar.mSCRIPTROOTDIR) + "UninstallScriptInfo.txt")
						gtWkProjectToolbar = undefined
					)
				else messagebox ("Uninstall file info not found in script folder\nUninstall aborted...") title:"Warning"
				)	
			)
		*/	
			on miAbout picked do
			(
				local lAboutStr = "A script for " + gtWkProjectToolbar.mProjectName
				lAboutStr += "\nVersion " + gtWkProjectToolbar.mVERSION as string
				
				-- description of the script and its versions
				--- Template: Add your code here ---
				
				lAboutStr += "\n\nContact and feedback:"
				lAboutStr += "\n   For questions, feedback and to repport a bug, please send an e-mail at:"
				lAboutStr += "\n<hyperlink>hyperLink contactlnk \"" + gtWkProjectToolbar.mProjectName + " Maxscript Support\" address:\"mailto:werwack@werwackfx.com?subject=WerwackScripts Support - WkProjectToolbar V" + gtWkProjectToolbar.mVERSION as string + " : &body=Hello,\" color:(color 10 10 240) hoverColor:(color 200 20 20) visitedColor:(color 10 10 240) align:#center offset:[0,0]</hyperlink>"
				
				gtWkProjectToolbar.mptStdLib.mfMessageBox lAboutStr rTitleStr:"About / Feedback"
			)
		)
		
		PopupMenu gtWkProjectToolbarOptionsMenu rollout:gWkProjectToolbarDialogWin
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
		
		lSubRolloutFilesArr = getFiles (mSCRIPTROOTDIR + "*subrollout*.ms*")
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
		try( DestroyDialog gWkProjectToolbarDialogWin ) catch()
		
		mDialogWin = rollout gWkProjectToolbarDialogWin "WkProjectToolbar"
		(
			button optionsBut "Options"	tooltip:"Options"
						images:#(	((gtWkProjectToolbar.mSCRIPTROOTDIR) + "Icons\\GeneralPurpose_24i.bmp"), \
									((gtWkProjectToolbar.mSCRIPTROOTDIR) + "Icons\\GeneralPurpose_24a.bmp"), \
						32, 13, 13, 14, 14) width:14 height:26 align:#right offset:[10,-2]
			label optionlab align:#left offset:[0,-46]

			on optionsBut pressed do gtWkProjectToolbar.mfOpenOptionsMenu()
	
		----------------------
		--	custom buttons
		----------------------
		--- Template: Add your code here ---
		
			label prodlab "WkProjectToolbar" align:#center offset:[0,10]
			label linklab "a Script for 3dsMax" align:#center offset:[0,5]
			
			button quickHelpBut "QuickHelp" tooltip:"Quick Help"
						images:#(	(gtWkProjectToolbar.mSCRIPTROOTDIR + "Icons\\GeneralPurpose_24i.bmp"), \
									(gtWkProjectToolbar.mSCRIPTROOTDIR + "Icons\\GeneralPurpose_24a.bmp"), \
						32, 11, 11, 12, 12) width:12 height:24 align:#center offset:[-10,0] 
			on quickHelpBut pressed do
			(
				local lStr = ""
				lStr += "Messagebox for quick help"
				gtWkProjectToolbar.mptStdLib.mfMessageBox lStr rWidth:600 rTitleStr:"Info"
			)

			button docBut "Documentation"	tooltip:"Documentation"
						images:#(	(gtWkProjectToolbar.mSCRIPTROOTDIR + "Icons\\GeneralPurpose_24i.bmp"), \
									(gtWkProjectToolbar.mSCRIPTROOTDIR + "Icons\\GeneralPurpose_24a.bmp"), \
						32, 9, 9, 10, 10) width:22 height:24 align:#center offset:[15,-29] 

			on docBut pressed do
				try( if not (ShellLaunch ((gtWkProjectToolbar.mMAXROOTDIR) + "Help\\" + gtWkProjectToolbar.mProjectName + "\\WkProjectToolbar\\WkProjectToolbar_Reference.doc") "") do
						 messagebox ("Cannot open documentation file in 3dsMax directory\n") title:"Warning"
					)
				catch( messagebox ("Documentation file not found in 3dsMax directory\n") title:"Warning" ) 
		
			button openDirBut "Open Dir" tooltip:"Open directory"
						images:#(	(gtWkProjectToolbar.mSCRIPTROOTDIR + "Icons\\NewDelExplore_24i.bmp"), \
									(gtWkProjectToolbar.mSCRIPTROOTDIR + "Icons\\NewDelExplore_24a.bmp"), \
						46, 13, 13, 14, 14) width:22 height:24 align:#left offset:[128,-27]
			on openDirBut pressed do
				shellLaunch "explorer" ("/e, /root,c: /select," + (getDir #maxroot))
			
		----------------------
		--	end of custom buttons
		----------------------
			
			label headerButtonslab align:#left pos:[0,mDialogWindowSize.y - 18]
			subRollout subroll "SubRoll" width:(mDialogWindowSize.x + 15) height:0 align:#center offset:[0,10]
					
			on gWkProjectToolbarDialogWin resized sizeval do
			(
				gtWkProjectToolbar.mDialogWindowSize.x = sizeval.x
				gtWkProjectToolbar.mDialogWindowSize.y = sizeval.y - gtWkProjectToolbar.mfGetRolloutsHeight()
				gtWkProjectToolbar.mfUpdateGui()
			)
		
			on gWkProjectToolbarDialogWin open do
				gtWkProjectToolbar.mfUpdateGui()

			on gWkProjectToolbarDialogWin moved moveval do
				gtWkProjectToolbar.mDialogWindowPos = moveval
			
			on gWkProjectToolbarDialogWin close do
				gtWkProjectToolbar.mfSaveGuiToIniFile()
		)
		
		return mDialogWin
	),


	-------------------------------------------------------------------------------
	-- *** mandatory function ***
	fn mfCloseGui =
	(
		try( mfUndockDialog() ) catch()
		try( DestroyDialog mDialogWin ) catch()
	),
	
	-------------------------------------------------------------------------------
	-- *** mandatory function ***
	fn mfLaunchGui rbDisplayDialog: =
	(
	--	format "WkProjectToolbar: mfLaunchGui\n"
		mfCloseGui()

		-- check the docking and set it if needed
		local lDockingState = getINISetting mINITFILE "UserSettings_GUI" "WindowDocking"
		if "" == lDockingState then
			 lDockingState = #undocked
		else lDockingState = lDockingState as name
		
		-- toolbox window type; add #style_toolwindow for a smaller window titlebar
		-- add #style_toolwindow for a smaller window titlebar
		local lWindowStyleArr = #( #style_minimizebox, #style_toolwindow, #style_sysmenu )

		if -100 == mDialogWindowPos.x then
			CreateDialog mDialogWin mDialogWindowSize.x mDialogWindowSize.y style:lWindowStyleArr
		else CreateDialog mDialogWin mDialogWindowSize.x mDialogWindowSize.y mDialogWindowPos.x mDialogWindowPos.y style:lWindowStyleArr
		mDialogWin.title = " WkProjectToolbar - V." + mVERSION as string
		
		if #undocked != lDockingState do
			mfDockDialog lDockingState
			
		-- subrollouts are ordered according to their name, inside mfLoadSubRollouts
		-- by default they are all rolled up. The rolled up state is saved into the init file when the main dialog is closed
		for lSubRoll in mSubRollouts do
			addSubRollout mDialogWin.Subroll lSubRoll rolledup: (getIniSetting mINITFILE "UserSettings_GUI" (lSubRoll.name + "_RolledUp") as booleanClass) -- (not lSubRoll.open)
		
		mfUpdateGui()
	)
)
	

-------------------------------------------------------------------------------
-- load of the script
try( gtWkProjectToolbar.mfUndockDialog() ) catch()
try( DestroyDialog gWkProjectToolbarDialogWin ) catch()
try( DestroyDialog gtWkProjectToolbar_ResetUserSettingsDialog ) catch()

global lbTmpWasShiftKeyPressed = keyboard.shiftPressed		-- a variable is required here because a messagebox is displayed in mfResetUserInitSettings() and the user may release the shift key

-- when pressing shift, the structure instance is recreated
-- not recreating the instance allow the user to keep his settings during a Max session
if undefined == gtWkProjectToolbar or lbTmpWasShiftKeyPressed or \
	(undefined != WkDevTool and "WkProjectToolbar" == wkdevtool.mfGetCurrentScriptName() and true == WkDevTool.mbReinstanciateScript) do
(
	gtWkProjectToolbar = tWkProjectToolbar()
	gtWkProjectToolbar.mfInit()
)

-- delete init user settings?
if undefined != gtWkProjectToolbar and (lbTmpWasShiftKeyPressed or (undefined != WkDevTool and true == WkDevTool.mbResetUserInitSettings)) do
(
	try ( gtWkProjectToolbar.mfResetUserInitSettings rbAskForResetOfUserInitSettings:true rbDisplayMessageForNewScriptInstance:true )
	catch ( messagebox "*** WkProjectToolbar startup: Cannot launch function mfResetUserInitSettings" title:"WkProjectToolbar" )
	gtWkProjectToolbar = tWkProjectToolbar()
	gtWkProjectToolbar.mfInit()
)

gtWkProjectToolbar.mfLoadDialogWin()
gtWkProjectToolbar.mfLoadSubRollouts()
gtWkProjectToolbar.mfUpdateGui()		-- wkip utile?


-- *** enable line for debug only *** The launch (ie the opening of the dialog window) is done in _ScriptLauncher.ms
--gtWkProjectToolbar.mfLaunchGui()

-- Begining of the sentence may be activated at the begining of the script
if gbWkVerbose do
	format "\nWkProjectToolbar V%: gtWkProjectToolbar loaded\n" gtWkProjectToolbar.mVERSION

-- *** THIS LINE MUST BE THE LAST LINE OF THE SCRIPT ***
-- otherwise the structure variable is not correctly returned
gtWkProjectToolbar



