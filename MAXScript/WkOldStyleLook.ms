/*
    https://notepad-plus-plus.org/community/topic/13443/need-help-to-make-maxscript-functions-recognized-by-function-list

    Expected Function List tree:
        WkOldStyleLook.ms
        \-- tWkOldStyleLook
            +-- mfInit
            +-- mfReplaceChar
            +-- mfCreateTextFile
            +-- mfMessageBox
            +-- mfCreateOriginalIconsBackupArchive
            +-- mfListObsoleteIcons
            +-- mfCleanObsoleteIcons
            +-- mfUnarchiveIcons
            +-- mfApplyChanges
            +-- mfUpdateGui
            +-- pmfCreateDialogWin
            \-- mfLaunchGUI

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

global gbUseWkDevMode									-- global variable used by WkDevTool for scripts developments
global gbWkVerbose = if undefined == gbWkVerbose then false else gbWkVerbose	-- global debug variable. When set to true, it can provide to get more debug information (use WkDevTool to control it)

global gtWkOldStyleLook
global gWkOldStyleLookDialogWin

struct tWkOldStyleLook
(
	mVersion = 1.0,
	mMAXROOTDIR = undefined,							-- set in mfInit according to the status of WkDevTool
														-- must be used allover in the script to get 3dsMax root dir, ends with \
	mSCRIPTROOTDIR = undefined,							-- set in mfInit according to the status of WkDevTool
														-- must be used allover in the script to get this script root dir, ends with \ (should have the value: #maxroot\scripts\WkerwacKScripts\WkOldStyleLook\)
	mINITFILE,											-- init file full path corresponding to \scripts\mProjectName\TemplateScript\TemplateScript.ini

	-- members
	mDialogWindowSize = point2 640 320,					-- width of the window, height of THE TOP PART of the window (ie height of the window minus height of the sub rollouts)

	mDialogWin,											-- rollout used as the GUI dialog boox
	mBannerBitmap = undefined,
	mCurrentIconsSetName = undefined,					-- can be: #max9, #max20xx

	-- *** mandatory function ***
	fn mfInit =
	(
			if true == gbUseWkDevMode and undefined != WkDevTool and "WkOldStyleLook" == wkdevtool.mfGetCurrentScriptName() then
				 mMAXROOTDIR = wkdevtool.mfGetDevDir(#maxroot)
			else mMAXROOTDIR = getDir #maxroot
			mSCRIPTROOTDIR = mMAXROOTDIR + "scripts\\WerwacKScripts\\WkOldStyleLook\\"

			-- ***** <init_file> ******
				-- init file is mandatory and cannot be deleted from the script folder
				mINITFILE = mSCRIPTROOTDIR + "WkOldStyleLook.ini"

				-- get the init values and fill the init file with default values if they don't exist
				setINISetting mINITFILE "ScriptSettings" "Version" (mVERSION as string)
				setINISetting mINITFILE "ScriptSettings" "MacroGroup" "Main UI"
				setINISetting mINITFILE "ScriptSettings" "MacroCategory" "WerwacKScripts"

				local lDetectedIconSetName = if doesFileExist (getDir #maxroot + "UI\\Icons\\Maintoolbar_24a.bmp") then #max9 else #max20xx
				mCurrentIconsSetName = getINISetting mINITFILE "UserSettings_GUI" "CurrentIconsSetName"
				if "" == mCurrentIconsSetName or lDetectedIconSetName != (mCurrentIconsSetName as name) then
				(
					mCurrentIconsSetName = lDetectedIconSetName
					setINISetting mINITFILE "UserSettings_GUI" "CurrentIconsSetName" mCurrentIconsSetName as string
				)
				else mCurrentIconsSetName = mCurrentIconsSetName as name

			-- ***** </init_file> ******

			mBannerBitmap = openBitMap (mSCRIPTROOTDIR + "\\Icons\\WerwacKScripts_banner.bmp")
	),

	-- replace a char in a string by an other
	fn mfReplaceChar rStr rChar rNewChar =
	(
		local lStr = ""
		for i=1 to rStr.count do
			if rStr[i] == rChar then
				lStr += rNewChar
			else lStr += rStr[i]
		return lStr
	),

	-- creates a text file with rTextStr as content
	-- returns true if succeded, false otherwise
	-- wkip no test to check if directory is ok
	-- rFileFullName:	file path and name
	-- rTextStr:		content to be added to the file
	fn mfCreateTextFile rFileFullName rTextStr =
	(
		local lbFileCreated = false
		local lFileFullName = mfReplaceChar rFileFullName "\\" "/"
		local lStream

		if doesFileExist lFileFullName do
		(
			setFileAttribute lFileFullName #readOnly false
			deleteFile lFileFullName
		)

		lStream = createFile lFileFullName
		if undefined != lStream do
		(
			format rTextStr to:lStream
			close lStream
			lbFileCreated = true
		)
		return lbFileCreated
	),

	-- Creates a custom messagebox to display formated text
	-- - rMessageStr:
	--		- "\n" characters will create a new line
	--		- part of the string between "<hyperlink>" and "</hyperlink>" will create an hyperlink
	--		- use standart maxscript hyperlink component definition for hyperlinks, adding align and offset parameters if you want to control their position
	--		- hyperlink must not contain "\n"
	--		eg: 	lInfoStr += "  <hyperlink>hyperLink hyperl \"test\" align:#center offset:[0,-18] </hyperlink> \n"
	--				lInfoStr += "<hyperlink>hyperLink hyperl \"<3ds Max 20xx>\\scripts\\WerwacKScripts\\WkOldStyleLook\\data\\ \" color:(color 0 0 230) hoverColor:(color 0 0 255) address:\"" + gtWkOldStyleLook.mfReplaceChar (getDir #maxroot) "\\" "/" + "\" align:#center offset:[0,-18] </hyperlink>"
	--		- Use spaces for tabulations
	--		- Put some " " (spaces) before "\n" for the return lines to be taken in account
	--		eg: 	lInfoStr += " \n"
	fn mfMessageBox rMessageStr rTitleStr: rbIsModal: rWidth: rHeight: =
	(
		--local lMessageArr = mfFilterString rMessageStr "\n" rbSplitEmptyTokens:true
		local lMessageArr = filterString rMessageStr "\n" rbSplitEmptyTokens:true
		local lEmptyLineHeight = 10
		--format "lMessageArr: %\n" lMessageArr

		local lTitleStr = if unsupplied == rTitleStr then "WerwacKScript" else rTitleStr
		local lbIsModal = if unsupplied == rbIsModal then true else rbIsModal
		local lWidth = if unsupplied == rWidth then 400 else rWidth
		local lHeight = 0
		if unsupplied == rHeight then
		(
			for i=1 to lMessageArr.count do
				if "\n" == lMessageArr[i] then
					if (1<i and "\n" == lMessageArr[i-1]) or 1 == i do
						lHeight += lEmptyLineHeight + 0
				else lHeight += 18
			lHeight += 70
		)
		else lHeight = rHeight

	--	print rMessageStr

		local lRolloutStr = ""
		global gMessageDialog
		try( DestroyDialog gMessageDialog )
		catch()

		lRolloutStr += "rollout gMessageDialog \"" + lTitleStr + "\" \n"
		lRolloutStr += "( \n"
		lRolloutStr += "	label MessageLab \"\" align:#left offset:[0,-5] \n"


		for i=1 to lMessageArr.count do
			if "\n" == lMessageArr[i] then			-- lines with a simple "\n" are created with a low label heigth
				if (1<i and "\n" == lMessageArr[i-1]) or 1 == i do
				 	lRolloutStr += "	label MessageLab" + i as string + " \"\" align:#left offset:[0," + (0 - lEmptyLineHeight) as string + "] \n"
			else
			(
				-- hyperlink case
				if matchPattern lMessageArr[i] pattern:"*<hyperlink>*" and matchPattern lMessageArr[i] pattern:"*</hyperlink>*"	then
				(
					-- get limits of the hyperlink
					lHyperlinkStartInd = findString lMessageArr[i] "<hyperlink>"
					lHyperlinkEndInd = findString lMessageArr[i] "</hyperlink>" + "</hyperlink>".count

					-- add string before hyperlink
					if 1 < lHyperlinkStartInd do
						lRolloutStr += "	label MessageLabBefLink" + i as string + " \"" + (substring lMessageArr[i] 1 (lHyperlinkStartInd - 1))+ "\" align:#left offset:[0,0] \n"

					-- add hyperlink
						lRolloutStr += "	" + (substring lMessageArr[i] (lHyperlinkStartInd + "<hyperlink>".count) (lHyperlinkEndInd - "</hyperlink>".count - (lHyperlinkStartInd + "<hyperlink>".count)) ) + " \n"

					-- add string after hyperlink
					if lMessageArr[i].count > lHyperlinkEndInd do
						lRolloutStr += "	label MessageLabAftLink" + i as string + " \"" + (substring lMessageArr[i] (lHyperlinkEndInd) (lMessageArr[i].count - lHyperlinkEndInd))+ "\" align:#right offset:[0,-20] \n"
				)
				else lRolloutStr += "	label MessageLab" + i as string + " \"" + lMessageArr[i] + "\" align:#left offset:[0,0] \n"
			)

		lRolloutStr += "	button CloseBut \"Close\" width:80 height:22 align:#center pos:[" + (lWidth/2 - 40) as string + "," + (lHeight - 35) as string + "] \n"

		lRolloutStr += "	on CloseBut pressed do \n"
		lRolloutStr += "		try( DestroyDialog gMessageDialog )	catch() \n"
		lRolloutStr += ") \n"

		execute lRolloutStr
		CreateDialog gMessageDialog lWidth lHeight style:#( #style_titlebar, #style_sysmenu ) \
						modal:lbIsModal
	),

	-- Create icons archive for backup
	-- This function is called everytime user change icons style, but it should create the archive the first time only
	fn mfCreateOriginalIconsBackupArchive rSourceDir rBackupDir rBackupFileName rDataDir =
	(
		local lSourceDir = rSourceDir
	--	local lSourceDir = "d:\\temp\\_oridestIcons\\"

		local lBackupDir = rBackupDir
	--	lBackupDir = "d:\\temp\\backup\\"

		local lbBackupExists = false
		local lArchiveFileFullName = lBackupDir + rBackupFileName

		format "  WkOldStyleLook: Backup archive: %\n" lArchiveFileFullName

		-- check if a backup already exists
	--	if true then		-- for debug only
		if 0 == (getFiles lArchiveFileFullName).count then
		(
			local lbContinue = true
			if 0 == (getDirectories lBackupDir).count do
				if not makeDir lBackupDir then				-- note: backup folder should already exist cause provided with the script
				(
					lbContinue = false
					messagebox "Backup folder cannot be created - Original Icons will not be saved"
				)

			if lbContinue do
			(
				-- list all the files that must be integrated into the archive
				local lFileNamesToArchiveArr = #()
				lFileNamesToArchiveArr = getFiles (lSourceDir + "*")
				for i=1 to lFileNamesToArchiveArr.count do
					lFileNamesToArchiveArr[i] = lFileNamesToArchiveArr[i]

				-- create text file containing file list
				local lFileListStr = ""
				for lFile in lFileNamesToArchiveArr do
					lFileListStr += lFile + "\n"
				mfCreateTextFile (lBackupDir + getFilenameFile rBackupFileName + "_ArchiveFileList.txt") lFileListStr

				local lbSendLogToFile = true
				local lCommandsStr = ""
				lCommandsStr += "\"" + mSCRIPTROOTDIR + "7zipA\\7za.exe\" a \"" + lArchiveFileFullName + "\" @\"" + (lBackupDir + getFilenameFile rBackupFileName + "_ArchiveFileList.txt") + "\" "	-- -r"  end with this for recurse dir
				if lbSendLogToFile then lCommandsStr += " > \"" + rBackupDir + "backupLog.txt\" \n\r" else lCommandsStr += " \n\r"
			--	lCommandsStr += "del \"" + lBackupDir + "archiveFileList.txt" + "\" \n\r"
			--	lCommandsStr += "\n pause\n"
		--		format "mfCreateOriginalIconsBackupArchive: lCommandsStr: %\n" lCommandsStr		-- debug

			-- execute the command to create the archive file
			--	Note: As HiddenDOSCommand is synchronous, the archive can take as long as required without introducing pbs for the next commands
				local lExitCode = undefined
				HiddenDOSCommand lCommandsStr exitCode:&lExitCode prompt:"Creating backup archive for original icons..." --startpath: (getdir #maxroot + "\\UI\\Icons\\")
				lbBackupExists = 0 == lExitCode

			-- An alternate way to HiddenDOSCommand:
			--	mfCreateTextFile (lBackupDir + "Archivecommand.bat") lCommandsStr
			--	shellLaunch (lBackupDir + "Archivecommand.bat") ""
			-- Oddly enough, using the string directly makes 3dsMax crash
			--	shellLaunch mCommandsStr ""		-- crash...

				if lbBackupExists then
					 messagebox ("Original icons have been saved in the following archive:\n\n" + lArchiveFileFullName + "\n") title:"WkOldStyleLook"
				else messagebox ("Original icons could not have been saved;\nSee backupLog.txt in the following directory for more information:\n\n" + rBackupDir + "\n") title:"WkOldStyleLook Warning"
			)
		)
		else
		(
			format "   A backup archive already exists\n"
			lbBackupExists = true
		--	messagebox "A backup archive already exists"
		)

		return lbBackupExists
	),

	-- *** for data build only: this function is used to create the file list named 3dsMax2009Icons_AndOnlyThere_FileList.txt
	-- 3dsMax 2010, 2011 and above icons are 32 bits bmp whereas old icons were 24 bits.
	-- When appliing back new style icons set, some old files used as masks, usually with a filename ending with "a.bmp"
	-- have to be deleted to avoid conflict with those having the alpha channel included.
	fn mfListObsoleteIcons rDataDir rArchiveName rBackupDir rBackupFileName rTargetDir =
	(
		local lMax9FilesArr = #()
		local lMax20xxFilesArr = #()
		local lIconsOnlyFromMax9Arr = #()

		-- get old icons list
		if not doesFileExist (rDataDir + getFilenameFile rArchiveName + "_ArchiveFileList.txt") then
			messagebox ("Old Icons list file not found:\n\n" + rDataDir + getFilenameFile rArchiveName + "_ArchiveFileList.txt")
		else
		(
			local lTextFileStrm = openFile (rDataDir + getFilenameFile rArchiveName + "_ArchiveFileList.txt") mode:"rS"
			local lLineStr = ""
			while not eof lTextFileStrm do
				append lMax9FilesArr ((readLine lTextFileStrm) as name)
			close lTextFileStrm

			format "mfListObsoleteIcons: lMax9FilesArr:\n"
			for lFile in lMax9FilesArr do
				print lFile
		)

		-- get new icons list
		if not doesFileExist (rBackupDir + getFilenameFile rBackupFileName + "_ArchiveFileList.txt") then
			messagebox ("Old Icons list file not found:\n\n" + rBackupDir + getFilenameFile rBackupFileName + "_ArchiveFileList.txt")
		else
		(
			local lTextFileStrm = openFile (rBackupDir + getFilenameFile rBackupFileName + "_ArchiveFileList.txt") mode:"rS"
			local lLineStr = ""
			while not eof lTextFileStrm do
				append lMax20xxFilesArr ((filenameFromPath (readLine lTextFileStrm)) as name)
			close lTextFileStrm

			format "\n mfListObsoleteIcons: lMax20xxFilesArr:\n"
			for lFile in lMax20xxFilesArr do
				print lFile
		)

		-- we know want the list of all files present in the old set and not present in the new one
		-- because file names are in the form of names and not strings, the comparison is not casesensitive
		for lFile in lMax9FilesArr do
			if 0 == findItem lMax20xxFilesArr lFile do
				append lIconsOnlyFromMax9Arr (lFile as string)

		format "\n mfListObsoleteIcons: lIconsOnlyFromMax9Arr:\n"
		for lFile in lIconsOnlyFromMax9Arr do
			format "%\n" lFile
	),

	fn mfCleanObsoleteIcons rDataDir rArchiveName rBackupDir rBackupFileName rTargetDir =
	(
		local lIconsOnlyFromMax9Arr = #()
		local lMax20xxFilesArr = #()
		local lResultFilesArr = #()

		-- get precomputed list of icons only from max9
		if not doesFileExist (rDataDir + "3dsMax2009Icons_AndOnlyThere_FileList.txt") then
			messagebox ("List of the icons coming only form the old versions of3dsMax not found:\n\n" + rDataDir + "3dsMax2009Icons_AndOnlyThere_FileList.txt")
		else
		(
			local lTextFileStrm = openFile (rDataDir + "3dsMax2009Icons_AndOnlyThere_FileList.txt") mode:"rS"
			local lLineStr = ""
			while not eof lTextFileStrm do
				append lIconsOnlyFromMax9Arr ((readLine lTextFileStrm) as name)
			close lTextFileStrm

		--	format "mfCleanObsoleteIcons: lIconsOnlyFromMax9Arr:\n"
		--	for lFile in lIconsOnlyFromMax9Arr do
		--		print lFile
		)

		-- get new icons list - Some old icons may have been added by the user later on and we have to preserve them
		if not doesFileExist (rBackupDir + getFilenameFile rBackupFileName + "_ArchiveFileList.txt") then
			messagebox ("Old Icons list file not found:\n\n" + rBackupDir + getFilenameFile rBackupFileName + "_ArchiveFileList.txt")
		else
		(
			local lTextFileStrm = openFile (rBackupDir + getFilenameFile rBackupFileName + "_ArchiveFileList.txt") mode:"rS"
			local lLineStr = ""
			while not eof lTextFileStrm do
				append lMax20xxFilesArr ((filenameFromPath (readLine lTextFileStrm)) as name)
			close lTextFileStrm

		--	format "\n mfCleanObsoleteIcons: lMax20xxFilesArr:\n"
		--	for lFile in lMax20xxFilesArr do
		--		print lFile
		)

		-- we know want the list of all files present in the old set and not present in the new one
		-- because file names are in the form of names and not strings, the comparison is not casesensitive
		for lFile in lIconsOnlyFromMax9Arr do
			if 0 == findItem lMax20xxFilesArr lFile do
				append lResultFilesArr (lFile as string)

	--	format "\n mfCleanObsoleteIcons: lResultFilesArr (files to delete):\n"
	--	for lFile in lResultFilesArr do
	--		format "%\n" lFile

		-- deleting files
		format "\n mfCleanObsoleteIcons: Files being deleted\n"
		for lFile in lResultFilesArr do
		(
			local lFileFullPath = rTargetDir + lFile
			if doesFileExist lFileFullPath then
				if not deleteFile lFileFullPath do
					format "  *** Cannot delete:  %\n" lFileFullPath
			else 	format "  *** File not found: %\n" lFileFullPath
		)
	),

	fn mfUnarchiveIcons rDataDir rArchiveName rTargetDir =
	(
		local lArchiveFileFullName = rDataDir + rArchiveName
		local lbUnarchivingIsOk = false

		format "mfUnarchiveIcons: lArchiveFileFullName: %\n" lArchiveFileFullName

		local lbSendLogToFile = true
		local lCommandsStr = ""
		lCommandsStr += "\"" + mSCRIPTROOTDIR + "7zipA\\7za.exe\" e \"" + lArchiveFileFullName + "\" -o\"" + rTargetDir + "\" -y"
		if lbSendLogToFile then lCommandsStr += " > \"" + rDataDir + "log.txt\" \n\r" else lCommandsStr += " \n\r"

	-- execute the command to create the archive file
		local lExitCode = undefined
		HiddenDOSCommand lCommandsStr exitCode:&lExitCode prompt:("Applying icons from " + rArchiveName + "...")

		lbUnarchivingIsOk = 0 == lExitCode
		if lbUnarchivingIsOk then
			 messagebox ("Icons set have been successfully applied\n\nYou need to relaunch 3dsMax to see them\n") title:"WkOldStyleLook"
		else messagebox ("A problem occured during the unzipping of the new icons set;\nSee log.txt in the following directory for more information:\n\n" + rDataDir + "\n") title:"WkOldStyleLook Warning"

		return lbUnarchivingIsOk
	),

	-- rNewIconsSetName can be #max9, #max20xx
	fn mfApplyChanges rNewIconsSetName =
	(
		format "mfApplyChanges: mCurrentIconsSetName:%, rNewIconsSetName: %\n" mCurrentIconsSetName rNewIconsSetName

		local lOriginalIconsDir = (getDir #maxroot) + "UI\\Icons\\"
		local lBackupDir = mSCRIPTROOTDIR + "_Backup_OriginalIcons\\"
		local lBackupFileName = "OriginalIcons.zip"
		local lIconsDir = lOriginalIconsDir
		local lDataDir = mSCRIPTROOTDIR + "Data\\"
		local lOldStyleIconsArchiveFileName = "3dsMax2009Icons.zip"

		if mCurrentIconsSetName == rNewIconsSetName then
			messagebox "Chosen icons set is the same as the current one\n\nNo change will occur" title:"WkOldStyleLook"
		else
		(
			-- check if the backup archive exists, creates it otherwise
			mfCreateOriginalIconsBackupArchive lOriginalIconsDir lBackupDir lBackupFileName lDataDir

		--	function used for data creation only - Not For Release !! -
		--	mfListObsoleteIcons lDataDir lOldStyleIconsArchiveFileName lBackupDir lBackupFileName lIconsDir

			local lbUnarchivingIsOk = false
			if #max9 == rNewIconsSetName then
				lbUnarchivingIsOk = mfUnarchiveIcons lDataDir lOldStyleIconsArchiveFileName lIconsDir
			else
			(
				mfCleanObsoleteIcons lDataDir lOldStyleIconsArchiveFileName lBackupDir lBackupFileName lIconsDir
				lbUnarchivingIsOk = mfUnarchiveIcons lBackupDir lBackupFileName lIconsDir
			)

			if lbUnarchivingIsOk do
			(
				mCurrentIconsSetName = rNewIconsSetName
				setINISetting mINITFILE "UserSettings_GUI" "CurrentIconsSetName" mCurrentIconsSetName as string
			)
		)
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
			local lLabelCurrentOffsetVal = 196

		-- Current icons set
			if #max9 == mCurrentIconsSetName then	-- then max 2009 or before
			(
				mDialogWin.iconsVersionMax9CurrentLab.pos.x = lLabelCurrentOffsetVal
				mDialogWin.iconsVersionMax20xxCurrentLab.pos.x = -200
				mDialogWin.iconsVersionRadbuts.state = 2
			)
			else
			(
				mDialogWin.iconsVersionMax9CurrentLab.pos.x = -200
				mDialogWin.iconsVersionMax20xxCurrentLab.pos.x = lLabelCurrentOffsetVal
				mDialogWin.iconsVersionRadbuts.state = 1
			)
		)
	),

	-------------------------------------------------------------------------------
	-- main rollout
	fn pmfCreateDialogWin =
	(
		try( DestroyDialog gWkOldStyleLookDialogWin ) catch()

		mDialogWin = rollout gWkOldStyleLookDialogWin "WkOldStyleLook"
		(
			button ApplyBut "Apply" tooltip:"Apply the new GUI style" width:80 height:26 align:#center offset:[-60,gtWkOldStyleLook.mDialogWindowSize.y - 50]
			button CloseBut "Close" tooltip:"Close the dialog window" width:80 height:26 align:#center offset:[60,-31]
			label emptylab01 "EmptyLab01"  align:#left offset:[-6,-gtWkOldStyleLook.mDialogWindowSize.y]

			imgTag bannerImgtg bitmap:gtWkOldStyleLook.mBannerBitmap key:#bmp_center tooltip:"Open webpage" align:#center offset:[0,-6]

			label prodlab "Define the UI configuration you would like to use and press \"Apply\" to confirm the changes."  align:#left offset:[80,30]
			label prodlab02 "Note: You will need to restart 3dsMax if you change the Icons set."  align:#left offset:[80,2]

		--	label UISchemeLab "UI Scheme:" align:#right offset:[-380,30]
		--	checkbox restoreDefaultUISchemeChkbx "Restore Default UI Scheme (3dsMax2009.ui)" align:#left offset:[280,-18]

			label iconsVersionLab "Icons Look:" align:#right offset:[-456,40]
			radiobuttons iconsVersionRadbuts labels:#("Present Style Icons (3dsMax 2010 and upcoming releases)", "Old Style Icons (3dsMax 2009 and previous releases)") columns:1 align:#left offset:[240,-18]
			label iconsVersionMax20xxCurrentLab "(Current)" align:#left offset:[320,-34]
			label iconsVersionMax9CurrentLab "(Current)" align:#left offset:[320,-3]

			button quickHelpBut "QuickHelp" tooltip:"Quick Help"
						images:#(	(gtWkOldStyleLook.mSCRIPTROOTDIR + "Icons\\GeneralPurpose_24i.bmp"), \
									(gtWkOldStyleLook.mSCRIPTROOTDIR + "Icons\\GeneralPurpose_24a.bmp"), \
						32, 11, 11, 12, 12) width:12 height:24 align:#right offset:[-522,-38]

			on ApplyBut pressed do
			(
				local rNewIconsSetName = if 1 == iconsVersionRadbuts.state then #max20xx else #max9
				gtWkOldStyleLook.mfApplyChanges rNewIconsSetName
				gtWkOldStyleLook.mfUpdateGui()
			)

			on CloseBut pressed do try( DestroyDialog gWkOldStyleLookDialogWin ) catch()

			on quickHelpBut pressed do
			(
				local lInfoStr = " \n      The script creates a backup of the images located at the root of 3dsMax Icons directoy and replaces them \n"
				lInfoStr += "       by those in the archive named \\\"3dsMax2009Icons.zip\\\" and located here: \n"
				lInfoStr += "<hyperlink>hyperLink hyperl01 \"<3ds Max 20xx>\\scripts\\WerwacKScripts\\WkOldStyleLook\\data\\ \" color:(color 0 0 230) hoverColor:(color 0 0 255) address:\"" + gtWkOldStyleLook.mfReplaceChar ((getDir #maxroot) + "scripts\\WerwacKScripts\\WkOldStyleLook\\_Backup_OriginalIcons\\") "\\" "/" + "\" align:#left offset:[80,2] </hyperlink>"
				lInfoStr += " \n \n \n       In case you would like to manually restore the original icons:"
				lInfoStr += " \n            - open the icons folder of 3dsMax:\n"
				lInfoStr += "<hyperlink>hyperLink hyperl03 \"<3ds Max 20xx>\\ui\\icons\\ \" color:(color 0 0 230) hoverColor:(color 0 0 255) address:\"" + gtWkOldStyleLook.mfReplaceChar ((getDir #maxroot) + "ui\\icons\\") "\\" "/" + "\" align:#left offset:[240,-18] </hyperlink>"
				lInfoStr += " \n            - delete all the files with a name ending with \\\"a.bmp\\\" (eg: Maintoolbar_24a.bmp) at the root of this folder"
				lInfoStr += " \n              (AND ONLY THEM, and NOT IN SUB-FOLDERS)"
				lInfoStr += " \n            - pick the backup archive located here:\n"
				lInfoStr += "<hyperlink>hyperLink hyperl02 \"<3ds Max 20xx>\\scripts\\WerwacKScripts\\WkOldStyleLook\\_Backup_OriginalIcons\\ \" color:(color 0 0 230) hoverColor:(color 0 0 255) address:\"" + gtWkOldStyleLook.mfReplaceChar ((getDir #maxroot) + "scripts\\WerwacKScripts\\WkOldStyleLook\\_Backup_OriginalIcons\\") "\\" "/" + "\"  align:#left offset:[80,2] </hyperlink>"
				lInfoStr += " \n            - unzip it directly into the icon folder of 3dsMax. This would overwrite installed icons that can be mismatching"
				lInfoStr += " \n \n       Before doing any manual manipulation, it is strongly advised to try to install the script again"
				gtWkOldStyleLook.mfMessageBox lInfoStr rTitleStr:"WkOldStyleLook" rWidth:600 rHeight:380
			)

			on gWkOldStyleLookDialogWin resized sizeval do
			(
				gtWkOldStyleLook.mDialogWindowSize.x = sizeval.x
				gtWkOldStyleLook.mDialogWindowSize.y = sizeval.y - gtWkOldStyleLook.mfGetRolloutsHeight()
				gtWkOldStyleLook.mfUpdateGui()
			)

			on gWkOldStyleLookDialogWin open do
			(
				gtWkOldStyleLook.mfUpdateGui()
			)

			on gWkOldStyleLookDialogWin close do
			(

			)
		)

		return mDialogWin
	),

	fn mfLaunchGUI =
	(
		try( DestroyDialog gWkOldStyleLookDialogWin ) catch()
		format "mfLaunchGUI\n"

		--pmfCreateMainRollout()

		-- add #style_toolwindow for a smaller window titlebar
		CreateDialog gWkOldStyleLookDialogWin mDialogWindowSize.x mDialogWindowSize.y modal:true style:#( #style_minimizebox, #style_titlebar, #style_sysmenu, #style_toolwindow)
		gWkOldStyleLookDialogWin.title = " WkOldStyleLook V. " + gtWkOldStyleLook.mVersion as string

		gtWkOldStyleLook.mfUpdateGui()
	)
)

gtWkOldStyleLook = tWkOldStyleLook()
gtWkOldStyleLook.mfInit()
gtWkOldStyleLook.pmfCreateDialogWin()
format "before mfLaunchGUI\n"
gtWkOldStyleLook.mfLaunchGUI()

if gbWkVerbose do format "\nWkOldStyleLook V%: gtWkOldStyleLook\n" gtWkOldStyleLook.mVersion

-- *** THIS LINE MUST BE THE LAST LINE OF THE SCRIPT ***
-- otherwise the structure variable is not correctly returned
gtWkOldStyleLook
