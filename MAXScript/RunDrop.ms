/*
    https://notepad-plus-plus.org/community/topic/13443/need-help-to-make-maxscript-functions-recognized-by-function-list

    Expected Function List tree:
        RunDrop.ms
        \-- OpenPackageDialog

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

global gbWkScriptsPackageBeingInstalled						-- used by WkToolsUpdater when scripts are automatically installed through the network
global gPackageDialog
global gbUseWkDevMode
global gBannerBitmap

(
	-- create a dialog to inform the user that installation was ok and the help is in help dir
	fn OpenPackageDialog rScriptName rScriptVersion rMacroGroup rMacroCategory rScriptFolder rbBannerIsLinkable rBannerLink =
	(
		-- we turn dev mode off to avoid possible side effects
		if true == gbUseWkDevMode do
		(
			gbUseWkDevMode = false
			try( WkDevTool.mfUpdateGui() )
			catch()
		)

		-- update the .ini file of the AutoUpdater file
		local lAutoUpdateInitFilefullPath = (getDir #maxroot) + "scripts\\" + rScriptFolder + "\\" + "InstalledScripts.ini"
		setINISetting lAutoUpdateInitFilefullPath rScriptName "Version" (rScriptVersion as string)
		setINISetting lAutoUpdateInitFilefullPath rScriptName "LastUpdate" localTime

		gBannerBitmap = openBitMap ((getDir #maxroot) + "Scripts\\" + rScriptFolder + "\\" + rScriptName + "\\Icons\\" + rMacroCategory + "_banner.bmp")


		if not true == gbWkScriptsPackageBeingInstalled do
		(
			global lRolloutStr = ""

			try( DestroyDialog gPackageDialog )
			catch()
			format ((getDir #maxroot) + "Scripts\\" + rScriptFolder + "\\" + rScriptName + "\\Icons\\WerwackScripts_banner.bmp\n")
			lRolloutStr += "rollout gPackageDialog \"Package successfully installed\" \n"
			lRolloutStr += "( \n"
			lRolloutStr += "	imgTag bannerImgtg bitmap:gBannerBitmap key:#bmp_center "
			if rbBannerIsLinkable do
				lRolloutStr += "tooltip:\"Open webpage\" "
			lRolloutStr += "align:#center offset:[0,-6] \n"

			lRolloutStr += "	label helpdirlab01 \"Package successfully installed :)\" align:#left offset:[10,4] \n"

			lRolloutStr += "	label versonlab \"Version installed: " + rScriptVersion as string + "\" align:#left offset:[80,10] \n"

			lRolloutStr += "	label Customlab \"The macroscript can be found in the Customize dialog window:\" align:#left offset:[80,10] \n"
			lRolloutStr += "	label MacroGrouplab \"         Group:     " + rMacroGroup as string + "\" align:#left offset:[80,0] \n"
			lRolloutStr += "	label MacroCategorylab \"         Caterory:  " + rMacroCategory as string + "\" align:#left offset:[80,0] \n"
			lRolloutStr += "	label MacroNamelab \"         Name:     " + rScriptName as string + "\" align:#left offset:[80,0] \n"


			lRolloutStr += "	label infolab01 \"To run this script again, you can either:\" align:#left offset:[10,28] \n"
			lRolloutStr += "	label infolab02 \"- Click on the menu item MAXScript->Run Script... and launch the script named WkOldStyleLook.ms\" align:#left offset:[80,6] \n"
			lRolloutStr += "	label infolab02b \"and located in <3dsMax>\\scripts\\WerwackScripts\\WkOldStyleLook\\ \" align:#left offset:[86,-2] \n"
			lRolloutStr += "	label infolab03 \"- Create a button for the macroscript \" align:#left offset:[80,0] \n"
			lRolloutStr += "	label infolab04 \"- Drag and drop this MZP package once again into one of the viewports of 3dsMax\" align:#left offset:[80,0] \n"


		--	lRolloutStr += "	label helpdirlab02 \"You can access to the package help file here:\" align:#left offset:[10,4] \n"
			--lRolloutStr += "	label helpdirlab03 \"" + ((getdir #maxroot) + "Help\\" + rScriptFolder + "\\" + rScriptName + "\\_index.htm") + "\" align:#left offset:[50,5] \n"
		--	lRolloutStr += "	hyperLink helplnk \"[3dsMax]\\Help\\" + rScriptFolder + "\\" + rScriptName + "\\" + rScriptName + "_Reference.doc\" address:\"" + (getdir #maxroot) + "Help\\" + rScriptFolder + "\\" + rScriptName + "\\" + rScriptName + "_Reference.doc\" color:(color 10 10 240) hoverColor:(color 200 20 20) visitedColor:(color 10 10 240) align:#center offset:[0,5] \n"

		--	lRolloutStr += "	label helpdirlab04 \"Tip:\" align:#left offset:[10,4] \n"
		--	lRolloutStr += "	hyperLink howtolnk \"How to create a macroscript shortcut\" address:\"" + (getdir #maxroot) + "Help\\" + rScriptFolder + "\\" + rScriptName + "\\WerwackScripts-macroscriptsinstallation.htm" + "\" color:(color 10 10 240) hoverColor:(color 200 20 20) visitedColor:(color 10 10 240) align:#left offset:[40,-18] \n"

			lRolloutStr += "	checkbox RunMacroscriptAfterCloseBut \"Run the macroscript after closing this window\" tooltip:\"Run the installed macroscript after this window gets closed\" checked:true align:#left offset:[80,30] \n"

			lRolloutStr += "	button CloseBut \"Close\" tooltip:\"Close Dialog Window\" height:18 width:60 align:#center offset:[0,24] \n"

			if rbBannerIsLinkable do
			(
				lRolloutStr += "	on bannerImgtg click do \n"
				lRolloutStr += "		ShellLaunch \"" + rBannerLink + "\" \"\" \n"
			)

			lRolloutStr += "	on CloseBut pressed do \n"
			lRolloutStr += "	( \n"
			lRolloutStr += "		DestroyDialog gPackageDialog \n"
			lRolloutStr += "		if RunMacroscriptAfterCloseBut.checked do \n"
			lRolloutStr += "			try macros.run \"" + rMacroCategory + "\" " + "\"" + rScriptName + "_Macroscript\" \n"
			lRolloutStr += "			catch( \n"
			lRolloutStr += "				format \"*** Macro run failed:\\n     macros.run " + rMacroCategory + " " + rScriptName + "_Macroscript\\n\" \n"
			lRolloutStr += "				messagebox (\"Macroscript not found:\n\n   " + rScriptName + "_Macroscript\") title:\"Error: Macroscript cannot be launched\" \n"
			lRolloutStr += "			) \n"
			lRolloutStr += "	) \n"

			lRolloutStr += ") \n"

		--	format "%\n" lRolloutStr

			-- wkip verifier s'il faut ouvrir la boite de dial
			global gPackageDialog
			execute lRolloutStr
			CreateDialog gPackageDialog 640 460 style:#( #style_minimizebox, #style_titlebar, #style_sysmenu, #style_toolwindow ) modal:true
		)
	)

	local lScriptName = "WkOldStyleLook"
	local lScriptVersion = 1.0
	local lMacroGroup = "Main UI"
	local lMacroCategory = "WerwackScripts"
	local lScriptFolder = "WerwackScripts"
	local lbBannerIsLinkable = true
	local lBannerLink = "http://www.werwackfx.com"

	try	fileIn (getdir #ui + "\\macroscripts\\" + lScriptName + "_Macroscript.mcr")
	catch messagebox ("Cannot launch following macriscript:\n\n    " + (getdir #ui + "\\macroscripts\\" + lScriptName + "_Macroscript.mcr") + "\n\nPlease check the existence of this file") title:"Error: Macroscript cannot be launched"

	--shelllaunch ((getdir #maxroot) + "\\help\\WerwackScripts\\WerwackScripts-macroscriptsinstallation.htm") ""
	OpenPackageDialog lScriptName lScriptVersion lMacroGroup lMacroCategory lScriptFolder lbBannerIsLinkable lBannerLink

	format ("Script " + lScriptName + " V" + lScriptVersion as string + " correctly installed\n")
)

