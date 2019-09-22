/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***

	A WerwacK Script
	
	Contact: werwack@werwackfx.com
	Website: www.werwackfx.com

//---------------------------------------------------------------------------------------------------------//

-- Purpose:
  ---------
   
   This script creates an installer to deploy custom script packages;
   
-- 3dsMax Supported versions:
  ---------------------------
	3dsMax 2013 and higher
	
	
-- Install:
  ---------

	Drag and drop WkDevTool.mzp inside 3dsMax.
	You can create a macroscript button or launch the script by a script command call.
	
	To create a macroscript button:
	-------------------------------
	
	Launch 3DSMax. In the menu toolbar, choose "Customize", then "Customize User Interface". Choose
	"WerwackScripts" in the "Category" dropdownlist, then select the script you want to install and
	drag and drop the associated icon on the desired toolbar. If no toolbar exist, you can create
	one by clicking on the button "new" at the right of the "Category" dropdownlist. 

	If the script name appears several times in the list, one or more previous verions are still
	installed on your system. 

	To run the script, just click on the button you just added. 
	

-- Notes:
  -------
	Compatible with 3dsmax 2013 and higher
  
  
-- Use:
-------
	- by changing mbAllowInstallInCustomDirectory you can allow the user to choose, or not, a directory to install the script
		

-- Known troubles:
------------------  

-- todo:
--------
	- séparer run de drop
	- renommer le path dans le fichier macro d'origine, pas le nouveau
	- devrait pas poser la question pour nouvelles nstalles
	- barre de progression
	
	- mettre les liens en membres
	- remplir la liste des fichiers installés
	
-- Version history:
-------------------

-- V1.3: (24/03/2016)
		- hide the installer version when debug mode is false
		
-- V1.2: (18/06/2015)
		- It is now possible to display or hide the components allowing the user to choose a custom install directory

-- V1.1: (20/01/2015)
		- This file is automatically modified by WkDevTool when a package is created to fill the value of mTEMPINSTALLDIRNAME
		- The installer now fully respects the structure of Max 2013
		- Data to be installed are now at the root of the package
		
		
-- V1.0: (09/06/2014)


*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/



global gbWkScriptsPackageBeingInstalled			-- used by WkToolsUpdater when scripts are automatically installed through the network
global gPackageDialog
global gbUseWkDevMode
global gBannerBitmap

global gtWkInstaller
global gInstallerDialogWin
global gUninstallerQueryDialogWin

global gLastDirUsedForInstallStr

struct tWkInstaller
(
	mbDebugMode = false,								-- Activate the debug mode to work on the GUI of the installer
														-- The debug mode:
														--		- keeps the mode gbUseWkDevMode active
														--		- allows the use of a local library
														--		- turns off the deletion of the temp files
														--		- still use the temp files folders

--	mDebugRootDirStr = "D:\\WkDev\\Maxscript\\DefScripts\\WkInstaller\\WkInstallerV1\\",
	mDebugRootDirStr = "Z:\\Projets\\Dev Maxscript\\_WkDevTool\\WkDevToolV3\\",
														-- local dev directory, used to find the library and the init files
	
	------------------

-- libraries
	mptStdLib = undefined,								-- StdLib instance (may not be required)

-- constants
	mVERSION = 1.3,

	------------------
	
	mTEMPINSTALLDIRNAME = "WkDevToolV3.53",				-- *** If WkDevTool is used for packaging the scripts this value is automatically set, so DO NOT MODIFY THIS LINE ***
														-- Otherwise if WkInstaller is used as a standalone tool:
														--		- set mTEMPINSTALLDIRNAME to the name of the folder in which the package will be unpacked in the $temp directory.
														--		  This name is usually made by the script name plus its version (eg:"mTEMPINSTALLDIRNAME = "MyScriptV1.0",)
														--		- you must also set this exact name in run.mzp tof the subfolder in $temp (eg:treecopy * to $temp\MyScriptV1.0\)
	
	------------------
	
	mDialogWindowSize = point2 640 400,					-- width of the window, height of THE TOP PART of the window (ie height of the window minus height of the sub rollouts)


--	mInstallTempDirectory = undefined,					-- temp directory in which the script has been unpacked. eg: "MyScriptV1.0"
														-- Value found in the script package init file
	mSourcePackageDir = undefined,						-- temp path in which the script has been unpacked. mSourcePackageDir is (getdir #temp) + "\\" + mTEMPINSTALLDIRNAME + "\\"
	mDestPackageRootDir = undefined,
	mbDeployInUserFolders = true,						-- if true the installation will be done in the standard max user folders (in %appdata%)
														-- else all will be installed in the specified folder (better for development)
	
	mbPackageIsValid = false,							-- must be true for the dialog box to open. It is true if the installer info init file is found and the path is valid
	
-- control over pages content
	mbShowDeploymentModeUI = false,
	
	mbInstallWentRight = false,
	mbDisplayInfosFromScriptInitFile = true,			-- if true, display the script infos found in the script init file, if not it will display the infos found in the installer init

	mbAllowInstallInCustomDirectory = false,			-- if true, display the components to pick an installation directory
	
	
-- package information	
	mScriptNameFromInstaller = "WkDevTool",				-- read in the script package init file or, if not found, in the installer init file 
	mProjectNameFromInstaller = "WerwackScripts",		-- read in the script package init file or, if not found, in the installer init file 
	mScriptVersionFromInstaller = undefined,			-- found in TemplateScript.ini
	mMacroGroupFromInstaller = undefined,				-- found in TemplateScript.ini
	
	mProjectName = "WerwackScripts",					-- found in the script package init file or, if not found, in the installer init file 
	mScriptName = "WkDevTool",							-- found in the script package init file or, if not found, in the installer init file 
	mScriptVersion = undefined,							-- found in the script init file
	mMacroGroup = undefined,							-- found in the script package init file or, if not found, in the installer init file 

--	mBannerLink = undefined, 							-- found in TemplateScript.ini	-- eg: "http://www.werwackfx.com"
	mBannerLink = "http://www.werwackfx.com", 			-- found in TemplateScript.ini	-- eg: "http://www.werwackfx.com"
	mbBannerIsLinkable = false,							-- found in TemplateScript.ini

	mDEFAULTINSTALLDIRSTR = "<User Script Folder>",
	mOFFSETVALUE = 700,
	
	mLinkColor = (color 52 157 255),
	mLinkHoverColor = (color 255 116 116),
	mLinkVisitedColor = (color 52 157 255),
	
	mCurrentPage = undefined,
	mVisiblePagesArr = #(),								-- store the visibility of the pages to avoid multiple offsets of the controls
	mErrorPageInd = undefined,
	
	------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------
	
					-- miscellaneous functions
					
	------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------
	-- *** mandatory function ***
	fn mfInit =
	(
		-- we turn dev mode off to avoid possible side effects
		if true == gbUseWkDevMode and not mbDebugMode do
		(
			gbUseWkDevMode = false
			if undefined != WkDevTool do
				try( WkDevTool.mfUpdateGui() )
				catch(messagebox "Warning : WkDevTool may not have been correctly set to false")
		)
		
		-- *** Important note: mTEMPINSTALLDIRNAME is filled by WkDevTool at packaging time	***
		if undefined != mTEMPINSTALLDIRNAME then
			mSourcePackageDir = (getdir #temp) + "\\" + mTEMPINSTALLDIRNAME + "\\"
		else messageBox "Installer - mTEMPINSTALLDIRNAME is undefined"

		if not mbDebugMode then
			if doesFileExist (mSourcePackageDir + "InstallerData\\WkStdLibV3.ms") then
				mptStdLib = filein (mSourcePackageDir + "InstallerData\\WkStdLibV3.ms")
			else messageBox "Installer - Library not found"
		else
		(
			-- use your own local library path here
			format "*** WkInstaller - Warning: hardcoded path here\n"
			mptStdLib = filein (mDebugRootDirStr + "InstallerData\\WkStdLibV3.ms")
		)
		
		-- get the installer init file specific for this package
		local lInitScriptInstallationInfoFullPath = undefined

		if not mbDebugMode then
			lInitScriptInstallationInfoFullPath = mSourcePackageDir + "InstallerData\\ScriptInstallationInfo.ini"
		else lInitScriptInstallationInfoFullPath = mDebugRootDirStr + "InstallerData\\ScriptInstallationInfo.ini"
		if not doesFileExist lInitScriptInstallationInfoFullPath then
		(
			local lStr = "Incomplete script package:\n\n"
			lStr += "Cannot find the installation info file ScriptInstallationInfo.ini in \n" + "    " + mSourcePackageDir + "\n\n"
			lStr += "Package cannot be installed"
			Messagebox lStr title:"WkInstaller: Incomplete Package"
			mbPackageIsValid = false
		)
		else
		(
			-- get the script infos from the INSTALLER init file
			mScriptNameFromInstaller =		getIniSetting lInitScriptInstallationInfoFullPath "InstallSettings" "Name"
			mProjectNameFromInstaller = 	getIniSetting lInitScriptInstallationInfoFullPath "InstallSettings" "MacroCategory"
			mScriptVersionFromInstaller =  (getIniSetting lInitScriptInstallationInfoFullPath "InstallSettings" "Version") as float
			mMacroGroupFromInstaller =		getIniSetting lInitScriptInstallationInfoFullPath "InstallSettings" "MacroGroup"
			
			mbPackageIsValid = true
		)
		
		if (true == mbPackageIsValid) do
		(
			-- get the script infos from the SCRIPT init file
			local lInitSettingsFileFullPath = mSourcePackageDir + "Scripts\\" + mProjectNameFromInstaller + "\\" + mScriptNameFromInstaller + "\\" + mScriptNameFromInstaller + ".ini"
			if not doesFileExist lInitSettingsFileFullPath then
			(
				format "*** Script Init File not found. Using Installer Init file infos instead *** \n"
				mbDisplayInfosFromScriptInitFile = false
				
				mScriptName = 		mScriptNameFromInstaller
				mProjectName = 		mProjectNameFromInstaller
				mScriptVersion =	mScriptVersionFromInstaller
				mMacroGroup =		mMacroGroupFromInstaller
			)
			else
			(
				mScriptName = 		getIniSetting lInitSettingsFileFullPath "ScriptSettings" "Name"
				mProjectName = 		getIniSetting lInitSettingsFileFullPath "ScriptSettings" "MacroCategory"
				mScriptVersion =   (getIniSetting lInitSettingsFileFullPath "ScriptSettings" "Version") as float
				mMacroGroup =		getIniSetting lInitSettingsFileFullPath "ScriptSettings" "MacroGroup"
			)
			
			mCurrentPage = 1
			mVisiblePagesArr = #(true, true, true)
			mErrorPageInd = mVisiblePagesArr.count
		)
	),
	
	-- return rVersion (float) as a formatted string so as to ends with '.0' for round numbers
	fn mfGetFormattedVersion rVersion =
	(
		local lVersionStr = rVersion as string
		if (integer == classof rVersion) do lVersionStr += ".0"
		
		return lVersionStr
	),
	
	fn mfCleanTempFolder =
	(
		local lbRes = false
		if not mbDebugMode then
			lbRes = mptStdLib.mfDeleteFolder mSourcePackageDir
		else messagebox "Debug Mode: Temp files will not be deleted" title:"mfCleanTempFolder"
		
		return lbRes
	),
	
	fn mfUpdateGui =
	(
		if not mbDebugMode do
			gInstallerDialogWin.installerVersionLabPage01.pos.x += -1 * mOFFSETVALUE
	),
	
	fn mpfGetPageNewOffset rPage rNewCurrentPage =
	(
		local lComponentOffset
		if (rNewCurrentPage != rPage and mVisiblePagesArr[rPage]) then
		(
			lComponentOffset = -1 * mOFFSETVALUE	-- hide considered page
			mVisiblePagesArr[rPage] = false			-- new page visibility status
		)
		else if (rNewCurrentPage == rPage and not mVisiblePagesArr[rPage]) then
		(
			lComponentOffset = mOFFSETVALUE			-- show considered page
			mVisiblePagesArr[rPage] = true			-- new page visibility status
		)
		else lComponentOffset = 0					-- do nothing so as to avoid multiple offset
			
		return lComponentOffset
	),
	
	fn mfSetCurrentPage rNewCurrentPage =
	(
		local lComponentOffset
		
		if 1 <= rNewCurrentPage and mVisiblePagesArr.count >= rNewCurrentPage do
		(
			-- page 1
			lComponentOffset = mpfGetPageNewOffset 1 rNewCurrentPage
			
			gInstallerDialogWin.InstallFolderGpBx.pos.x += lComponentOffset
			gInstallerDialogWin.installFolderLab.pos.x += lComponentOffset

			local lAllowedComponentOffset
			if mbAllowInstallInCustomDirectory then
				 lAllowedComponentOffset = 0
			else lAllowedComponentOffset = -1 * mOFFSETVALUE
			
			local lMinComponentOffset = -1 * mOFFSETVALUE
			if lComponentOffset < lMinComponentOffset do lMinComponentOffset = lComponentOffset
				
			-- we take the offset if there is one (offset is negative and we do a min to avoid having double offset)
			if 1!= rNewCurrentPage or mbAllowInstallInCustomDirectory do
			(
				-- hide unwanted components
				gInstallerDialogWin.forceDefaultInstallDirLabPage01.pos.x += lMinComponentOffset
				gInstallerDialogWin.defaultUSerDirLabPage01.pos.x += lMinComponentOffset
			)
			if 1!= rNewCurrentPage or not mbAllowInstallInCustomDirectory do
			(
				-- hide unwanted components
				gInstallerDialogWin.defaultScriptPathBut.pos.x += lMinComponentOffset
				gInstallerDialogWin.scriptPathBut.pos.x += lMinComponentOffset
				gInstallerDialogWin.scriptPathEdittxt.pos.x += lMinComponentOffset
				gInstallerDialogWin.defaultUSerDirTitleLabPage01.pos.x += lMinComponentOffset
			)
			
			gInstallerDialogWin.installBut.pos.x += lComponentOffset
			gInstallerDialogWin.cancelBut.pos.x += lComponentOffset
			
			-- page 2 - Specific to WkDevTool
			lComponentOffset = mpfGetPageNewOffset 2 rNewCurrentPage
			
			gInstallerDialogWin.installOkLab.pos.x += lComponentOffset
			gInstallerDialogWin.Scriptlab.pos.x += lComponentOffset
			gInstallerDialogWin.Versonlab.pos.x += lComponentOffset
			gInstallerDialogWin.Customlab.pos.x += lComponentOffset
			gInstallerDialogWin.MacroGrouplab.pos.x += lComponentOffset
			gInstallerDialogWin.MacroCategorylab.pos.x += lComponentOffset
			gInstallerDialogWin.MacroNamelab.pos.x += lComponentOffset
			
			gInstallerDialogWin.closeBut.pos.x += lComponentOffset
			
			-- page 3
		/*	lComponentOffset = mpfGetPageNewOffset 3 rNewCurrentPage
			
			gInstallerDialogWin.installOkLab.pos.x += lComponentOffset
			gInstallerDialogWin.Scriptlab.pos.x += lComponentOffset
			gInstallerDialogWin.Versonlab.pos.x += lComponentOffset
			gInstallerDialogWin.Customlab.pos.x += lComponentOffset
			gInstallerDialogWin.MacroGrouplab.pos.x += lComponentOffset
			gInstallerDialogWin.MacroCategorylab.pos.x += lComponentOffset
			gInstallerDialogWin.MacroNamelab.pos.x += lComponentOffset
			
			gInstallerDialogWin.closeBut.pos.x += lComponentOffset
			*/
			-- error page
			lComponentOffset = mpfGetPageNewOffset mErrorPageInd rNewCurrentPage
			
			gInstallerDialogWin.installErrorLab.pos.x += lComponentOffset
			gInstallerDialogWin.installErrorLab02.pos.x += lComponentOffset
			gInstallerDialogWin.installErrorLab03.pos.x += lComponentOffset
			gInstallerDialogWin.installErrorLab04.pos.x += lComponentOffset
			gInstallerDialogWin.typesOfInstallLnk.pos.x += lComponentOffset
			gInstallerDialogWin.installErrorLab05.pos.x += lComponentOffset
			gInstallerDialogWin.contactErrorlnk.pos.x += lComponentOffset
			gInstallerDialogWin.emptyLabNavPageError.pos.x += lComponentOffset
			
			gInstallerDialogWin.closeErrorBut.pos.x += lComponentOffset
			
			
			mCurrentPage = rNewCurrentPage
		)
	),

	fn mfSetSuccessulInfos =
	(
		--mProjectName = "WerwackScripts",		-- *** to change manually ***
		--mScriptName = "WkInstaller",			-- *** to change manually ***
	--	local lInitSettingsFileFullPath = mSourcePackageDir + "Scripts\\" + mProjectName + "\\" + mScriptName + "\\" + mScriptName + ".ini"
		local lInitSettingsFileFullPath = mDestPackageRootDir + "Scripts\\" + mProjectName + "\\" + mScriptName + "\\" + mScriptName + ".ini"
		if doesFileExist lInitSettingsFileFullPath then
		(
			local lSettingValueStr = ""
			
			
		--	lSettingValueStr = getIniSetting lInitSettingsFileFullPath "ScriptSettings" "MainWebsiteLink"
		--	if ("" != lSettingValueStr) do
		--		mBannerLink = copy lSettingValueStr

		--	lSettingValueStr = getIniSetting lInitSettingsFileFullPath "ScriptSettings" "bInstallWindowBannerIsLinkable"
		--	if ("" != lSettingValueStr and false != lSettingValueStr as BooleanClass) do
		--		mbBannerIsLinkable = true
		
			gInstallerDialogWin.MacroCategorylab.caption += mProjectName as string
			gInstallerDialogWin.Scriptlab.caption += mScriptName as string
			gInstallerDialogWin.Versonlab.caption += mScriptVersion as string
			gInstallerDialogWin.MacroGrouplab.caption += mMacroGroup as string
			gInstallerDialogWin.MacroNamelab.caption += mScriptName as string

			gtWkInstaller.mfShowHowToInstallAMacroButton()
		)
		else messagebox ("init file not found: " + lInitSettingsFileFullPath)
		
	),
	-- returns true if the previous package has been deleted or will be overwritten, false if cancel or pb in the uninstallation
	fn mfUninstallPreviousPackage =
	(
		global gUninstallRes = undefined
		global gbUninstallRes_KeepPrefs = false
		local lbOkWithPreviousPackage = false
		
		try( DestroyDialog gUninstallerQueryDialogWin ) catch()
		
		rollout gUninstallerQueryDialogWin " WkInstaller"
		(
			label Lab01 "Destination folder is not empty and will be modified by the installation." align:#left offset:[12,20]
			label Lab02 "In any case user settings (.ini files) will be preserved." align:#left offset:[12,4]
			
			label emptylab03 "EmptyLab03"  align:#left offset:[-100,12]

			button uninstallBut "Uninstall" tooltip:"Delete all the script files already in the specified folder" width:80 height:26 align:#center offset:[-484,00] enabled:false
			button overwriteBut "Overwrite" tooltip:"Delete nothing and overwrite previous script package already in the specified folder" width:80 height:26 align:#center offset:[-84,-31] --offset:[0,-31]
			button cancelBut "Cancel" tooltip:"Do nothing and cancel the current installation" width:80 height:26 align:#center offset:[84,-31]

			checkbox overwriteInitFilesChkbx "Preserve local user preference settings" tooltip:"If checked, the .ini files used to store the user preference settings will be kept" align:#left offset:[84,20] checked:true
			
			
			on uninstallBut pressed do
			(
				gUninstallRes = #uninstall
				gbUninstallRes_KeepPrefs = overwriteInitFilesChkbx.checked
				try( DestroyDialog gUninstallerQueryDialogWin ) catch()
				--wkip to do clean temp
			)

			on overwriteBut pressed do
			(
				gUninstallRes = #overwrite
				gbUninstallRes_KeepPrefs = overwriteInitFilesChkbx.checked
				try( DestroyDialog gUninstallerQueryDialogWin ) catch()
				--wkip to do clean temp
			)
			
			on cancelBut pressed do
			(
				gUninstallRes = #cancel
				gbUninstallRes_KeepPrefs = overwriteInitFilesChkbx.checked
				try( DestroyDialog gUninstallerQueryDialogWin ) catch()
				
				--wkip to do clean temp
			)

		)
		
		CreateDialog gUninstallerQueryDialogWin 400 200 style:#(#style_titlebar, #style_sysmenu) modal:true --style:#( #style_titlebar, #style_toolwindow, #style_sysmenu)
		
		
		if #unistall == gUninstallRes then
		(
			-- uninstall here
			--wkip
			--lbOkWithPreviousPackage = false if unisntall went wrong, true otherwise
			lbOkWithPreviousPackage = false
		
		)
		else if #overwrite == gUninstallRes then
		(
			lbOkWithPreviousPackage = true
		)
		else if #cancel == gUninstallRes do
		(
			lbOkWithPreviousPackage = false
		)
		
		return lbOkWithPreviousPackage
	),
	
	fn mfShowHowToInstallAMacroButton =
	(
		max customize UI
		local lInstallPage = mDestPackageRootDir + "Help\\" + mScriptName + "_Help\\macroscriptsinstallation.htm"
		ShellLaunch lInstallPage ""
	),
	
	-------------------------------------------------------------------------------
	-- main rollout 
	fn pmfCreateDialogWin =
	(
		try( DestroyDialog gInstallerDialogWin ) catch()
		
		local lBannerBitmapFullPath = undefined
		if not mbDebugMode then
			lBannerBitmapFullPath = (mSourcePackageDir + "InstallerData\\InstallerBanner.bmp")
		else lBannerBitmapFullPath = (mDebugRootDirStr + "InstallerData\\InstallerBanner.bmp")
		if doesFileExist lBannerBitmapFullPath do
			gBannerBitmap = openBitMap lBannerBitmapFullPath
			
		mDialogWin = rollout gInstallerDialogWin " WkInstaller"
		(
			imgTag bannerImgtg bitmap:gBannerBitmap key:#bmp_center opacity:1 transparent:(color 255 0 0) align:#center offset:[0,-6] 
			--wkip mettrre link
			
			
		-------------------
		-- Page 1  -- wknote: most of these components are kept hidden for WkDevTool because the default script directory is always used
		-------------------
			label installerVersionLabPage01 "WkInstaller V-" align:#left pos:[10,92]
			
			label installedScriptLabPage01 "Installation of  " align:#center offset:[0,-6]
			
			groupBox InstallFolderGpBx " Install Folder " pos:[10,130] width:(gtWkInstaller.mDialogWindowSize.x - 20) height:10			-- height is specified in the Open function
				label emptyLabPage01 "EmptyLabPage01" align:#left offset:[-100,-InstallFolderGpBx.height]
				label installFolderLab "Package installation:" align:#left offset:[12,8]
				
				button defaultScriptPathBut "D" tooltip:"Use default script installation folder" width:20 height:20 align:#left offset:[120,-21]
				button scriptPathBut "..." tooltip:"Install the package in the specified folder" width:20 height:20 align:#left offset:[144,-25]
				edittext scriptPathEdittxt text:"" width:436 align:#left offset:[164,-23] readonly:true

				label forceDefaultInstallDirLabPage01 "The script will be installed in the default user directory"align:#left offset:[120,-20]

				label defaultUSerDirTitleLabPage01 "Default User Script Folder:" align:#left offset:[12,6]
				label defaultUSerDirLabPage01 "<User Folder>" align:#left offset:[40,-18]
				
			label emptylab05 "EmptyLab05" pos:[-200,320]
			button installBut "Install" tooltip:"Install script package in the specified folder" width:80 height:26 align:#center offset:[-60,00]
			button cancelBut "Cancel" tooltip:"Cancel installation" width:80 height:26 align:#center offset:[60,-31]

			--wkip to remove
			radiobuttons scriptPathRadbut labels:#("3dsMax User Folders (recommanded)", "Unique Folder (Advanced - for dev only") align:#left offset:[1140,10]
			
			
			on scriptPathRadbut changed stat do
				mbDeployInUserFolders = 1 == stat
			
			on defaultScriptPathBut pressed do
			(
				scriptPathEdittxt.text = gtWkInstaller.mDEFAULTINSTALLDIRSTR
				gtWkInstaller.mfUpdateGui()
			)
			
			on scriptPathBut pressed do
			(
				-- we only accept paths below the dev path
				
			--	local lDir = (getdir #userScripts) + "\\"
				local lDir = gLastDirUsedForInstallStr
				
				if undefined == lDir or not doesfileexist lDir do
				lDir = ""
				local lFileOutStr = getSavePath caption:"Install Directory..." initialDir:lDir

				if lFileOutStr != undefined then
				(
				--	format "lFileOutStr: %\n lDir:%\n" lFileOutStr lDir
					lFileOutStr += "\\"
					scriptPathEdittxt.text = lFileOutStr
					gLastDirUsedForInstallStr = lFileOutStr
				)
				
				gtWkInstaller.mfUpdateGui()
			)
			
			
			on installBut pressed do
			(
				local lbInstallScript = true
				local lbInstallScript_KeepPrefs = false
				local lPackageRootDir =  scriptPathEdittxt.text
				local lbVerbose = true
				
			--	format "  installBut.lPackageRootDir: %\n" lPackageRootDir
			--	if gtWkInstaller.mbDeployInUserFolders

				if lbVerbose do
				(
					local lStr = "\n-----------------------------------\n"
					lStr += "  -- WkInstaller V" + (gtWkInstaller.mfGetFormattedVersion gtWkInstaller.mVERSION) + " -- " --\n"
				--	lStr += "Installing " + wkip package name		-- at this step we don't know yet the name of the script to install
					lStr += "-----------------------------------\n\n"
					format lStr
				)			

				if gtWkInstaller.mDEFAULTINSTALLDIRSTR == scriptPathEdittxt.text then
					lPackageRootDir = getDir #maxData
				else
				(
					if "" == scriptPathEdittxt.text do
					(
						lbInstallScript = false
						messagebox "Script Path not defined\n\nPlease specify a path for the script"
					)

					if lbInstallScript and not doesFileExist scriptPathEdittxt.text do
					(
						lbInstallScript = false
						messagebox "Invalid Script Folder\n\nPlease choose an existing folder for the script"
					)
				)
				
			/*	if lbInstallScript and not doesFileExist lPackageRootDir do
				(
					local lbScriptPathCreated = gtWkInstaller.mptStdLib.mfCreatePath lPackageRootDir
					if not lbScriptPathCreated do
					(
						lbInstallScript = false
						messagebox ("Specifed script folder cannot be created:\n" + lPackageRootDir + "\n\nPlease choose another path for the script")
					)
				)
			*/
			
				-- uninstall previous package to avoid conflicts
				if lbInstallScript do
				(
					if lbVerbose do format "  Checking for installed previous versions\n"
					
					local lScriptDir = lPackageRootDir + "scripts\\" + gtWkInstaller.mProjectName + "\\" + gtWkInstaller.mScriptName
					
					if doesFileExist lScriptDir \
						and (0 != (getFiles (lScriptDir + "*.*")).count or 0 != (getDirectories (lScriptDir + "*")).count) do
					(
						if lbVerbose do format "    Uninstall previous versions\n"
						lbInstallScript = gtWkInstaller.mfUninstallPreviousPackage()
						lbInstallScript_KeepPrefs = gbUninstallRes_KeepPrefs
					)
				)
				
				if lbInstallScript do
				(
					-- do the install here
					setWaitCursor() 		

					-- move the data from temp dir to specified folder
					local lSourcePattern =  gtWkInstaller.mSourcePackageDir + "*.*"
					gtWkInstaller.mDestPackageRootDir = lPackageRootDir
					
				--	format "lSourcePattern: %\n, dest: %\n\n" lSourcePattern lPackageRootDir
					
					
					local lSourceFilesToExcludeArr = #()
					-- we get the list of the .init files
					if true == lbInstallScript_KeepPrefs do
					(
						-- wkip no recursive search with mfGetFiles because we know in which init files are located
					--	local lInitFilesWildcardStr = gtWkInstaller.mDestPackageRootDir + "\\*.ini"			-- wrong: these are DEST files!!
						local lInitFilesWildcardStr = gtWkInstaller.mSourcePackageDir + "scripts\\" + gtWkInstaller.mProjectName + "\\" + gtWkInstaller.mScriptName + "\\*.ini"
						format "lInitFilesWildcardStr: %\n" lInitFilesWildcardStr
						lSourceFilesToExcludeArr = getFiles lInitFilesWildcardStr
						
						format "lSourceFilesToExcludeArr: %\n" lSourceFilesToExcludeArr
					)
					
					
					if lbVerbose do format "  Coping files from temp directory to the installation folder\n"
					
					gtWkInstaller.mptStdLib.mfCopyFiles lSourcePattern gtWkInstaller.mDestPackageRootDir rIgnoredSourceFilesArr:lSourceFilesToExcludeArr

					if not gtWkInstaller.mfCleanTempFolder() do
						--messagebox "Temp folder has not been clean completely;\n\nThis has no consequences on future installations" title:"WkInstaller Warning"
						format "Temp folder has not been clean completely;\nThis has no consequences on future installations\n\n"

					-- run post install scripts
					--wkip to do

					-- reload the ui icon folder
					if lbVerbose do format "  ReInitializing Icons\n"
					--if lbIconsDirsCopied do
						colorman.reInitIcons()
					
				/*	if lbVerbose do format "  Modifying script files:\n"
					-- modify the _ScriptLauncher file for it to be able to launch the script package even if it has not been installed in the user script folder
					if lbVerbose do format "    Modifying _ScriptLauncher.ms\n"
					local lFileDst = gtWkInstaller.mDestPackageRootDir + "scripts\\" + gtWkInstaller.mProjectName + "\\" + gtWkInstaller.mScriptName + "\\_ScriptLauncher.ms"
					local lOldLinesArr = #("lScriptRootDir = getdir #userScripts + \"\\\\\"")
					local lNewLinesArr = #("lScriptRootDir = \"" + (gtWkInstaller.mptStdLib.mfConvertPathToStringPath gtWkInstaller.mDestPackageRootDir) + "scripts\\\\\"")
					local lErrorStr = ""
					if not gtWkInstaller.mptStdLib.mfReplaceInTextFile lFileDst lOldLinesArr lNewLinesArr rpErrorStr:&lErrorStr then
					(
						local lStr = "Error while replacing script path in launcher file\nError message:\n"
						lStr += "   " + lErrorStr + " \n"
						lStr += "  Launcher file will not be able to launch the script\n"
						format (" *** " + lStr + "\n")
						MessageBox lStr title:"Installer"
					)
				*/
				
				/*
					-- modify the main script file to set the install dir
					if lbVerbose do format ("    Modifying " + gtWkInstaller.mScriptName + ".ms\n")
					-- wkip faire un test pour voir si le chemin par défaut a été changé et utiliser #maxdata sinon
					local lFileDst = gtWkInstaller.mDestPackageRootDir + "scripts\\" + gtWkInstaller.mProjectName + "\\" + gtWkInstaller.mScriptName + "\\" + gtWkInstaller.mScriptName + ".ms "
					local lOldLinesArr = #("mINSTALLFULLPATH = undefined")
					local lNewLinesArr = #("mINSTALLFULLPATH = \"" + (gtWkInstaller.mptStdLib.mfConvertPathToStringPath gtWkInstaller.mDestPackageRootDir) + "\"")
					local lErrorStr = ""
					if not gtWkInstaller.mptStdLib.mfReplaceInTextFile lFileDst lOldLinesArr lNewLinesArr rpErrorStr:&lErrorStr then
					(
						local lStr = "Error while replacing mINSTALLFULLPATH default value in main script file\nError message:\n"
						lStr += "   " + lErrorStr + " \n"
						lStr += "  Launcher file will not be able to launch the script\n"
						format (" *** " + lStr + "\n")
						MessageBox lStr title:"Installer"
					)
				*/
				
				/*
					-- modify the macroscript file for it to be able to launch the script package even if it has not been installed in the user script folder
					if lbVerbose do format ("    Modifying " + gtWkInstaller.mScriptName + "_Macroscript.mcr\n")
					local lMacroFileDst = gtWkInstaller.mDestPackageRootDir + "userMacros\\" + gtWkInstaller.mScriptName + "_Macroscript.mcr"
					lOldLinesArr = #("lScriptRootDir = getdir #userScripts + \"\\\\\"")
					lNewLinesArr = #("lScriptRootDir = \"" + (gtWkInstaller.mptStdLib.mfConvertPathToStringPath gtWkInstaller.mDestPackageRootDir) + "scripts\\\\\"")
					lErrorStr = ""
					if not gtWkInstaller.mptStdLib.mfReplaceInTextFile lMacroFileDst lOldLinesArr lNewLinesArr rpErrorStr:&lErrorStr then
					(
						local lStr = "Error while replacing script path in macro file\nError message:\n"
						lStr += "   " + lErrorStr + " \n"
						lStr += "  Macro file will not be launched\n"
						format (" *** " + lStr + "\n")
						MessageBox lStr title:"Installer"
					)
					else try		--run the macro
						(
							if lbVerbose do format "  Running the macroscript\n"
							fileIn lMacroFileDst
							gtWkInstaller.mbInstallWentRight = true
						)
						catch
						(
							messagebox ("Cannot launch following macroscript:\n\n    " + lMacroFileDst + "\n\nPlease check the existence of this file") title:"Error: Macroscript cannot be launched"
							gtWkInstaller.mbInstallWentRight = false
						)
				*/
				
					local lMacroFileDst = gtWkInstaller.mDestPackageRootDir + "userMacros\\" + gtWkInstaller.mScriptName + "_Macroscript.mcr"
					try		--run the macro
						(
							if lbVerbose do format "  Running the macroscript\n"
							fileIn lMacroFileDst
							gtWkInstaller.mbInstallWentRight = true
						)
						catch
						(
							messagebox ("Cannot launch following macroscript:\n\n    " + lMacroFileDst + "\n\nPlease check the existence of this file") title:"Error: Macroscript cannot be launched"
							gtWkInstaller.mbInstallWentRight = false
						)
					
					setArrowCursor()

					if gtWkInstaller.mbInstallWentRight then
					(
						if true == gtWkInstaller.mbDebugMode do format "wkdebug: mbInstallWentRight - before page 2\n"
						gtWkInstaller.mfSetSuccessulInfos()
						gtWkInstaller.mfSetCurrentPage 2
						if true == gtWkInstaller.mbDebugMode do format "wkdebug: mbInstallWentRight - after page 2\n"
						
						-- open the Create Button html page
						ShellLaunch ((getdir #maxData) + "Help\\" + gtWkInstaller.mScriptName + "\\macroscriptsinstallation.htm") ""
						
					-- utiliser ca?	ShellLaunch ("\"" + (getdir #maxData) + "Help\\" + gtWkInstaller.mScriptName + "\\macroscriptsinstallation.htm") ""					
					-- wkip launch the app (en mode recompile)
					)
					else gtWkInstaller.mfSetCurrentPage gtWkInstaller.mErrorPageInd		-- error page
					
					if lbVerbose do
					(
						local lStr = "\n-----------------------------------\n"
						lStr += "  -- End of Installation --\n"
						lStr += "-----------------------------------\n\n"
						format lStr
					)
				)
			)

			on cancelBut pressed do
			(
				local lbCancel = queryBox "Do you really want to cancel the installation?"
				
				if lbCancel do
				(
					if not gtWkInstaller.mfCleanTempFolder() do
					--	messagebox "Temp folder has not been clean completely;\n\nThis has no consequences on future installations" title:"WkInstaller Warning"
						format "Cancel: Temp folder has not been clean completely;\nThis has no consequences on future installations\n"
					
					try( DestroyDialog gInstallerDialogWin ) catch()
				)
			)
			
		-------------------
		-- Page 3 (page 2 in the standard installer)
		-------------------

			label emptyLabPage02 "EmptyLabPage02" pos:[-200,130]
			label installOkLab "Package successfully installed :)" align:#left offset:[20,0]
			
			label Scriptlab "Script name: " align:#left offset:[80,20]
			label Versonlab "Version installed: " align:#left offset:[80,6]

			label Customlab "The macroscript is now accessible in the Customize User Interface dialog window:" align:#left offset:[80,10]
			label MacroGrouplab "         Group:         " align:#left offset:[80,0]
			label MacroCategorylab "         Caterory:    " align:#left offset:[80,0]
			label MacroNamelab "         Name:         " align:#left offset:[80,0]

			-- open the Help folder
			-- wkip to finish
		--	label helpdirlab02 "You can access to the package help file here:" align:#left offset:[80,8]
		--	lRolloutStr += "		ShellLaunch \"explorer\" (\"/e, /root,c: /select,\" + ((getdir #maxdata) + \"Help\\\" + rScriptFolder + "\\" + rScriptName)) \n"

			-- clic on this link to know how to create the macro button
			-- wkip to finish
		--	label helpdirlab04 "Tip:" align:#left offset:[30,4]
		--	hyperLink howtolnk "How to create a macroscript shortcut" address:"" + (getdir #maxData) + "Help\\" + rScriptFolder + "\\" + rScriptName + "\\macroscriptsinstallation.htm" + "\" color:(color 10 10 240) hoverColor:(color 200 20 20) visitedColor:(color 10 10 240) align:#left offset:[40,-18]
			
			label emptyLabNavPage02 "EmptyLabNavPage02" pos:[-200,320]
			button closeBut "Close" tooltip:"Close the installer" width:80 height:26 align:#center offset:[0,0]
			
			on closeBut pressed do
			(
				try( DestroyDialog gInstallerDialogWin ) catch()
				--wkip to do clean temp
			)
			
		-------------------
		-- Error Page (always last)
		-------------------

			label emptyLabPageError "EmptyLabPageError" pos:[-200,130]
			label installErrorLab "Something went wrong during and the package has not been correctly installed." align:#left offset:[20,0]
			label installErrorLab02 "You can:" align:#left offset:[20,8]
			label installErrorLab03 "- Launch again the installation" align:#left offset:[34,3]
			label installErrorLab04 "- Try " align:#left offset:[34,3]
			hyperlink typesOfInstallLnk "another type of installation" adress:"http://www.werwackscript.com" \
								color:gtWkInstaller.mLinkColor hoverColor:gtWkInstaller.mLinkHoverColor visitedColor:gtWkInstaller.mLinkVisitedColor align:#left offset:[90,-18]
			label installErrorLab05 "- Contact the support at " align:#left offset:[34,3]
			hyperLink contactErrorlnk "werwack@werwackfx.com" address:("mailto:werwack@werwackfx.com?subject=WerwacK Scripts Support - " + gtWkInstaller.mScriptName as string + " V." + gtWkInstaller.mScriptVersion as string + " : &body=Hello,") \
								color:gtWkInstaller.mLinkColor hoverColor:gtWkInstaller.mLinkHoverColor visitedColor:gtWkInstaller.mLinkVisitedColor align:#left offset:[150,-18]

			label emptyLabNavPageError "EmptyLabNavPageError" pos:[-200,330]
			button closeErrorBut "Close" tooltip:"Close the installer" width:80 height:26 align:#center offset:[0,0]
			
			on closeErrorBut pressed do
			(
				try( DestroyDialog gInstallerDialogWin ) catch()
				--wkip to do clean temp
			)
			
			
		-------------------
		-- Navigation components for all pages
		-------------------
			
/*			label emptyLabNav01 "EmptyLabNav01" pos:[-200,320]
			button closeBut "Close" tooltip:"Install script package in the specified folder" width:80 height:26 align:#center offset:[0,0]
			
			on closeBut pressed do
			(
				try( DestroyDialog gInstallerDialogWin ) catch()
				--wkip to do clean temp
			)
	*/		

			on gInstallerDialogWin open do 
			(

				if not gtWkInstaller.mbShowDeploymentModeUI do
				(
					InstallFolderGpBx.height = 90
					installerVersionLabPage01.text = "WkInstaller V. " + (gtWkInstaller.mfGetFormattedVersion gtWkInstaller.mVERSION) + " for WkDevTool"
					
					installedScriptLabPage01.text += gtWkInstaller.mScriptName + " V. " + (gtWkInstaller.mfGetFormattedVersion gtWkInstaller.mScriptVersion)
					
					defaultUSerDirLabPage01.text = getDir #maxData + "scripts\\"
				)
				
				gtWkInstaller.mfUpdateGui()
			-- wkip to uncomment on release version
				scriptPathEdittxt.text = gtWkInstaller.mDEFAULTINSTALLDIRSTR
				
				if undefined != gLastDirUsedForInstallStr and doesFileExist gLastDirUsedForInstallStr then
					scriptPathEdittxt.text = gLastDirUsedForInstallStr
			--	else scriptPathEdittxt.text = ""
				
				if true == gtWkInstaller.mbDebugMode do format "wkdebug: before page 1\n"
				gtWkInstaller.mfSetCurrentPage 1
				if true == gtWkInstaller.mbDebugMode do format "wkdebug: after page 1\n"
			)
			
			on gInstallerDialogWin moved moveval do
			(
			)

			on gInstallerDialogWin close do 
			(
				
			)
		)
		
		return mDialogWin
	),

	
	fn mfLaunchGUI =
	(
		try( DestroyDialog gInstallerDialogWin ) catch()
		try( DestroyDialog gUninstallerQueryDialogWin ) catch()
		
		--gtWkInstaller.pmfCreateMainRollout()
		
		-- add #style_toolwindow for a smaller window titlebar
		local lbDialogIsModal = false -- not gtWkInstaller.mbDebugMode
			 CreateDialog gInstallerDialogWin gtWkInstaller.mDialogWindowSize.x gtWkInstaller.mDialogWindowSize.y style:#( #style_sysmenu, #style_titlebar, #style_toolwindow ) modal:lbDialogIsModal --style:#( #style_titlebar, #style_toolwindow, #style_sysmenu)
		gInstallerDialogWin.title = ("wkInstaller - " + gtWkInstaller.mScriptNameFromInstaller)

		gtWkInstaller.mfUpdateGui()
	)

	-- the macro is not run, just evaluated to become accessible in the Customization panel
/*	local lMacroFile = getdir #macroScripts + mScriptName + "_Macroscript.mcr"
	if not doesFileExist lMacroFile then
		messagebox ("Macroscript not found:\n\n    " + lMacroFile + "\n\nPlease check the existence of this file") title:"Error: Macroscript cannot be launched"
	else
		try	fileIn lMacroFile
		catch messagebox ("Cannot launch following macroscript:\n\n    " + lMacroFile + "\n\nPlease check the existence of this file") title:"Error: Macroscript cannot be launched"
	*/
	--shelllaunch ((getdir #maxroot) + "\\help\\" + mProjectName + "\\" + mProjectName + "-macroscriptsinstallation.htm") ""
	
	

)

try( DestroyDialog gInstallerDialogWin ) catch()
gtWkInstaller = tWkInstaller()
gtWkInstaller.mfInit()

if (true == gtWkInstaller.mbPackageIsValid) then
(
	gtWkInstaller.pmfCreateDialogWin()
	gtWkInstaller.mfLaunchGUI()
)


--	format ("Script " + mScriptName + " V" + mScriptVersion as string + " correctly installed\n")
