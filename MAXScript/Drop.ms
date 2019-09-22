/*/--------------------------------------------------------------------------------------------------------//
*** Header Used For Versionning ** Do Not Change ** Header Used For Versionning ** Do Not Change ************

	RunDrop.ms:
		This script is called by mzp.run when a .mzp package is being installed.
		
		To use it for a new script package, just change the name of the local variables at the beginning
		of this script and fill an appropriate .ini file for the package.
		
		The required .init file must be named as follow:
			[#maxroot]\Scripts\<ProjectName>\<TemplateScript>\<TemplateScript>.ini
	
	
*** Header Used For Versionning ** Do Not Change ** Header Used For Versionning ** Do Not Change ************
//--------------------------------------------------------------------------------------------------------/*/

global gbWkScriptsPackageBeingInstalled			-- used by WkToolsUpdater when scripts are automatically installed through the network
global gPackageDialog
global gbUseWkDevMode
global gBannerBitmap

(
	local lProjectName = "ProjectName"			-- *** to change manually ***
	local lScriptName = "TemplateScript"		-- *** to change manually ***
	local lScriptVersion = undefined			-- found in TemplateScript.ini
	local lMacroGroup = undefined				-- found in TemplateScript.ini
	local lMacroCategory = undefined			-- found in TemplateScript.ini
	local lScriptFolder = undefined				-- found in TemplateScript.ini
	local lBannerLink = undefined 				-- found in TemplateScript.ini	-- eg: "http://www.google.com"
	local lbBannerIsLinkable = false			-- found in TemplateScript.ini

	local lInitSettingsFileFullPath = (getdir #maxroot) + "Scripts\\" + lProjectName + "\\" + lScriptName + "\\" + lScriptName + ".ini"
	if doesFileExist lInitSettingsFileFullPath do
	(
		local lSettingValueStr = ""
		
		lScriptVersion = (getIniSetting lInitSettingsFileFullPath "ScriptSettings" "Version") as float
		lMacroGroup = getIniSetting lInitSettingsFileFullPath "ScriptSettings" "MacroGroup"
		lMacroCategory = getIniSetting lInitSettingsFileFullPath "ScriptSettings" "MacroCategory"
		lScriptFolder = lMacroCategory
		
		lSettingValueStr = getIniSetting lInitSettingsFileFullPath "ScriptSettings" "MainWebsiteLink"
		if ("" != lSettingValueStr) do
			lBannerLink = copy lSettingValueStr

		lSettingValueStr = getIniSetting lInitSettingsFileFullPath "ScriptSettings" "bInstallWindowBannerIsLinkable"
		if ("" != lSettingValueStr and false != lSettingValueStr as BooleanClass) do
			lbBannerIsLinkable = true
	)


	-- create a dialog to inform the user that installation was ok and the help is in help dir
	-- rBannerLink can be undefined
	fn OpenPackageDialog rScriptName rScriptVersion rMacroGroup rMacroCategory rScriptFolder rBannerLink rbBannerIsLinkable =
	(
		-- we turn dev mode off to avoid possible side effects
		if true == gbUseWkDevMode do
		(
			gbUseWkDevMode = false
			try( WkDevTool.mfUpdateGui() )
			catch()
		)
		
		-- update the .ini file of the AutoUpdater file
		local lAutoUpdateInitFilefullPath = (getDir #maxData) + "scripts\\" + rScriptFolder as string + "\\" + "InstalledScripts.ini"
		setINISetting lAutoUpdateInitFilefullPath rScriptName "Version" (rScriptVersion as string)
		setINISetting lAutoUpdateInitFilefullPath rScriptName "LastUpdate" localTime

		lBannerBitmapFullPath = (getDir #temp) + "InstallerData\\InstallerBanner.bmp"
		if doesFileExist lBannerBitmapFullPath do
			gBannerBitmap = openBitMap lBannerBitmapFullPath
		
		
		if not true == gbWkScriptsPackageBeingInstalled do
		(
			global lRolloutStr = ""

			try( DestroyDialog gPackageDialog )
			catch()
			
			lRolloutStr += "rollout gPackageDialog \"Package successfully installed\" \n"
			lRolloutStr += "( \n"
			
			if undefined != gBannerBitmap do
			(
				lRolloutStr += "	imgTag bannerImgtg bitmap:gBannerBitmap key:#bmp_center "
				if undefined != rBannerLink and rbBannerIsLinkable do
					lRolloutStr += "tooltip:\"Open webpage\" "
				lRolloutStr += "align:#center offset:[0,-6] \n"
			)
			
			lRolloutStr += "	label helpdirlab01 \"Package successfully installed :)\" align:#left offset:[10,4] \n"

			lRolloutStr += "	label Scriptlab \"Script name: " + rScriptName + "\" align:#left offset:[80,20] \n"
			lRolloutStr += "	label Versonlab \"Version installed: " + rScriptVersion as string + "\" align:#left offset:[80,20] \n"

			lRolloutStr += "	label Customlab \"The macroscript is now accessible in the Customize dialog window:\" align:#left offset:[80,10] \n"
			lRolloutStr += "	label MacroGrouplab \"         Group:          " + rMacroGroup as string + "\" align:#left offset:[80,0] \n"
			lRolloutStr += "	label MacroCategorylab \"         Caterory:  " + rMacroCategory as string + "\" align:#left offset:[80,0] \n"
			lRolloutStr += "	label MacroNamelab \"         Name:         " + rScriptName as string + "\" align:#left offset:[80,0] \n"


		--	lRolloutStr += "	label helpdirlab02 \"You can access to the package help file here:\" align:#left offset:[10,4] \n"
			--lRolloutStr += "	label helpdirlab03 \"" + ((getdir #maxroot) + "Help\\" + rScriptFolder + "\\" + rScriptName + "\\_index.htm") + "\" align:#left offset:[50,5] \n"
		--	lRolloutStr += "	hyperLink helplnk \"[3dsMax]\\Help\\" + rScriptFolder + "\\" + rScriptName + "\\" + rScriptName + "_Reference.doc\" address:\"" + (getdir #maxroot) + "Help\\" + rScriptFolder + "\\" + rScriptName + "\\" + rScriptName + "_Reference.doc\" color:(color 10 10 240) hoverColor:(color 200 20 20) visitedColor:(color 10 10 240) align:#center offset:[0,5] \n"
			
		--	lRolloutStr += "	label helpdirlab04 \"Tip:\" align:#left offset:[10,4] \n"
		--	lRolloutStr += "	hyperLink howtolnk \"How to create a macroscript shortcut\" address:\"" + (getdir #maxroot) + "Help\\" + rScriptFolder + "\\" + rScriptName + "\\WerwackScripts-macroscriptsinstallation.htm" + "\" color:(color 10 10 240) hoverColor:(color 200 20 20) visitedColor:(color 10 10 240) align:#left offset:[40,-18] \n"

			lRolloutStr += "	checkbox RunMacroscriptAfterCloseBut \"Run the macroscript after closing this window\" tooltip:\"Run the installed macroscript after this window gets closed\" checked:true align:#left offset:[80,18] \n"
		
			lRolloutStr += "	button CloseBut \"Close\" tooltip:\"Close Dialog Window\" height:18 width:60 align:#center offset:[0,18] \n"

			if undefined != rBannerLink and rbBannerIsLinkable do
			(
				lRolloutStr += "	on bannerImgtg click do \n"
				lRolloutStr += "		ShellLaunch \"" + rBannerLink + "\" \"\" \n"
			)
			
			lRolloutStr += "	on CloseBut pressed do \n"
			lRolloutStr += "	( \n"
			lRolloutStr += "		DestroyDialog gPackageDialog \n"
			lRolloutStr += "		if RunMacroscriptAfterCloseBut.checked do \n"
			lRolloutStr += "			try macros.run \"" + rMacroCategory as string + "\" " + "\"" + rScriptName + "_Macroscript\" \n"
			lRolloutStr += "			catch messagebox (\"Macroscript not found:\n\n   " + rScriptName + "_Macroscript\") title:\"Error: Macroscript cannot be launched\" \n"
			lRolloutStr += "	) \n"
			
			lRolloutStr += ") \n"
			
			format "%\n" lRolloutStr
			
			-- wkip ckeck if the dialog box shoulb be opened
			global gPackageDialog
			execute lRolloutStr
			CreateDialog gPackageDialog 640 365 style:#( #style_minimizebox, #style_titlebar, #style_sysmenu, #style_toolwindow ) modal:true
		)
	)

	-- the macro is not run, just evaluated to become accessible in the Customization panel
	try	fileIn (getdir #ui + "\\macroscripts\\" + lScriptName + "_Macroscript.mcr")
	catch messagebox ("My Drop - Cannot launch following macroscript:\n\n    " + (getdir #ui + "\\macroscripts\\" + lScriptName + "_Macroscript.mcr") + "\n\nPlease check the existence of this file") title:"Error: Macroscript cannot be launched"
	
	--shelllaunch ((getdir #maxroot) + "\\help\\" + lProjectName + "\\" + lProjectName + "-macroscriptsinstallation.htm") ""
	OpenPackageDialog lScriptName lScriptVersion lMacroGroup lMacroCategory lScriptFolder lBannerLink lbBannerIsLinkable

	format ("Script " + lScriptName + " V" + lScriptVersion as string + " correctly installed\n")
)
