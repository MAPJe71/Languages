/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***

	A WerwacK Script
	
	Contact: werwack@yahoo.com
	Website: www.werwackscripts.com

	Script Name:				MyScript
	3dsMax Supported Versions:	2013 and more
	
//---------------------------------------------------------------------------------------------------------//

-- Purpose:
-----------
   Library for usefull functions
   
	
-- Use:
-------
    
    Called with a filein:
    	lMyStdLibraryInstance = filein "WkStdLibV3.ms"
        
    Call any library function with:
        lMyStdLibraryInstance.mfFunction()
    
    
-- _Notes:_
-----------
	
	*** Important notes: ***
		- When modifiing a function, always set the modification date in its description
	
	Functions:
	
		- _DevTools_
		- _Strings_
		- _io_files_
		- _Maths_and_transforms_
		- _Time_
		- _Mesh_
		- _Files_
		- _Units_
		- _Shape_
		- _Modifiers_
		- _UVs_
		- _Scripts_and_GUI_
		- _Various_
			
	
-- Known troubles:
------------------  
	V3.14: mpfGetFilesRec doesn't support wildcards correctly. May be source of troubles


-- Version history:
-------------------
-- V3.16: (2015/12/16)
		- added an exclusion list to mfCopyFiles
		- added mfDisplayFormattedArray
		- added some fixes to mpfGetFilesRec and mfGetFiles
		
-- V3.15: (2015/01/13)
		- fixed a bug in mfCopyFiles
		
-- V3.14: (2014/06/09)
		- added mfCopyFiles
		- added a verbose error parameter for mfReplaceInFile and mfReplaceInString
		- added mfConvertPathToStringPath
		- mfLocalTime has been removed - use built-in getLocalTime() or getUniversalTime() instead
		- added mfGetFormattedLocalTime()
		
-- V3.13: (2010/06/25)
		- added exemples for mfMessageBox

-- V3.12: (2009/10/27)
		- added mfReplaceInTextFile, mfAddToTextFile and mfReplaceInString

-- V3.11: (2009/10/20)
		- added mfReplaceChar and mfFillStringWithChar

-- V3.1: (2009/10/15)
		- added mfRemoveINISetting
		- added mfIsSubClassOf
		- removed mfFilterString, which was bugged

-- V3.0: (2009/07/03)
		- (2009/10/11):
			- added mfDeleteFolder
			- removed mfAddBoxWeight and mfRemoveBoxWeight
		- maj
		- added mfUpdateGuiForceComponentTooltips
		- removed mfSetINISetting (not useful)

-- V2.2: (2008/03/01)
		- maj
		
-- V1: (2007/01/03)
		- basic version


*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/


--global wkgbVerbose = if undefined == wkgbVerbose then false else wkgbVerbose		-- can be toggled with WkMacroTool_OnOffVerboseToggle.mcr
--global wkgVerboseIndentStr = if undefined == wkgVerboseIndentStr then "" else wkgVerboseIndentStr


-- When renaming this function, also rename all the "tWkStdLibV2" in this file
struct tWkStdLibV3
(						
	-- constants
	mVERSION = 3.16,										-- *** mandatory member ***
	

                                                                                    -- __
	------------------------------------------------------------------------------- -- __
	
			-- _strings_
	
	------------------------------------------------------------------------------- -- __
	-------------------------------------------------------------------------------

	-- fills a string with a char
	-- very usefull to format text in columns in the listener
	-- myString = "toto"
	-- ex: mfFillStringWithChar myString 20 " "
	-- returns "toto                      "
	fn mfFillStringWithChar rStr rFinalLength rChar =
	(
		local lStr = if (String == classOf rStr) then copy rStr else rStr as string
		while rFinalLength > lStr.count do
			append lStr rChar
		return lStr
	),

	-- replace a char in a string by an other
	-- very useful to double slashes in a string
	fn mfReplaceChar rStr rChar rNewChar =
	(
		local lStr = ""
		for i=1 to rStr.count do
			if rStr[i] == rChar then
				lStr += rNewChar
			else lStr += rStr[i]
		return lStr
	),
	
/*	str = "arzra bateau poisson Poisson ezraPoisson--nier dqfdsfpoissonrrr sd sd"
	"arzra bateau poisson Poisson ezraPoisson--nier dqfdsfpoissonrrr sd sd"

	mfReplaceInString str "poisson" "test" rbMatchWholeWordOnly:false rbMatchCase:true
	"arzra bateau test Poisson ezraPoisson--nier dqfdsftestrrr sd sd"
	mfReplaceInString str "poisson" "test" rbMatchWholeWordOnly:true rbMatchCase:true
	"arzra bateau test Poisson ezraPoisson--nier dqfdsfpoissonrrr sd sd"
	mfReplaceInString str "poisson" "test" rbMatchWholeWordOnly:false rbMatchCase:false
	"arzra bateau test test ezratest--nier dqfdsftestrrr sd sd"
	mfReplaceInString str "poisson" "test" rbMatchWholeWordOnly:true rbMatchCase:false
	"arzra bateau test test ezraPoisson--nier dqfdsfpoissonrrr sd sd"
*/
	-- replace each string in rStringsToFindArr by its counterpart in rNewStringsArr
	-- returns the newly modified string or undefined if something went wrong
	-- get the error message by adress with &rpErrorStr
	-- eg:	lErrorStr = ""
	--		dev.mfReplaceInTextFile "d:\\temp\\test.ms" ar1 ar2 &lErrorStr
	fn mfReplaceInString rStringToModifyStr rOldStringStr rNewStringStr rbMatchWholeWordOnly:false rbMatchCase:false &rpErrorStr:undefined =
	(
		local lLocalCurrentLineStr = copy rStringToModifyStr
		local lTmpIndex = findString lLocalCurrentLineStr rOldStringStr
	--	format "i:%, lTmpIndex:%, lCurrentLineStr: %\n" i lTmpIndex lCurrentLineStr
		local lCounterInd = 1
		local lNewModifiedStringStr = ""

		local lSpacersStr = " +-\"\\.,:;?!&#~'()-_|/[]{}\n+=*£$<>@"	--"
		
		local lStartIndex = 1
	--	if undefined == lTmpIndex do messagebox "undef"
		while undefined != lTmpIndex and lCounterInd < 50 do
		(
			lNewModifiedStringStr += substring lLocalCurrentLineStr lStartIndex (lTmpIndex - lStartIndex)
			if rbMatchWholeWordOnly then
			(
				local lbWordIsAlone = false
				-- get the whole word only case
				if (1 == lTmpIndex or undefined != findString lSpacersStr lLocalCurrentLineStr[lTmpIndex - 1]) do
					if (lLocalCurrentLineStr.count == (lTmpIndex + rOldStringStr.count) \
							or ((lTmpIndex + rOldStringStr.count) <= lLocalCurrentLineStr.count and undefined != findString lSpacersStr lLocalCurrentLineStr[lTmpIndex + rOldStringStr.count])) do
						lbWordIsAlone = true

				if lbWordIsAlone and (not rbMatchCase or rOldStringStr == substring lLocalCurrentLineStr lTmpIndex rOldStringStr.count) then
				(
				--	format "word alone: lLocalCurrentLineStr: %\n" lLocalCurrentLineStr
					-- get the new word
					lNewModifiedStringStr += rNewStringStr
					lLocalCurrentLineStr = substring lLocalCurrentLineStr (lTmpIndex + rOldStringStr.count) -1
				)
				else
				(
				--	format "word NOT alone: lLocalCurrentLineStr: %, lTmpIndex: %\n" lLocalCurrentLineStr lTmpIndex
					-- keep the old word
					lNewModifiedStringStr += substring lLocalCurrentLineStr lTmpIndex rOldStringStr.count
					lLocalCurrentLineStr = substring lLocalCurrentLineStr (lTmpIndex + rOldStringStr.count) -1
				)
			)
			else
			(
			--	format "rNewStringStr: %, (substring lLocalCurrentLineStr lTmpIndex rOldStringStr.count): %\n" rNewStringStr (substring lLocalCurrentLineStr lTmpIndex rOldStringStr.count)
				if (not rbMatchCase or rOldStringStr == substring lLocalCurrentLineStr lTmpIndex rOldStringStr.count) then
				(
					-- get the new word
					lNewModifiedStringStr += rNewStringStr
					lLocalCurrentLineStr = substring lLocalCurrentLineStr (lTmpIndex + rOldStringStr.count) -1
				)
				else
				(
					-- keep the old word
					lNewModifiedStringStr += substring lLocalCurrentLineStr lTmpIndex rOldStringStr.count
					lLocalCurrentLineStr = substring lLocalCurrentLineStr (lTmpIndex + rOldStringStr.count) -1
				)
			)

			lTmpIndex = findString lLocalCurrentLineStr rOldStringStr
			lStartIndex = 1
			lCounterInd += 1
		)
		lNewModifiedStringStr += lLocalCurrentLineStr

		-- outputs
		if "" == lNewModifiedStringStr and "" != rStringToModifyStr do
		(
		--	lNewModifiedStringStr = undefined		--wkip en fait ca marche pas, il faudrait retourner le nombre d'occurences remplacées
			if undefined != rpErrorStr do
				rpErrorStr = "String to replace has not been found"
		)
		
		return lNewModifiedStringStr
	),
	
	-- returns the string in the opposite order
	-- ex: mfReverseString "123456" -- returns "654321"
	fn mfReverseString rStringToReverseStr =
	(
		local lRevertedStringStr = ""
		for i = rStringToReverseStr.count to 1 by -1 do
			lRevertedStringStr += rStringToReverseStr[i] 
		return lRevertedStringStr
	),

	-- gets the index of the first substring occurence
	-- returns undefined if not found
	-- ex: findString "Thanks for all the fish!" " f" -- returns 7
	fn mfFindFisrtSubstringOccurence rStringToFilterStr rSubstring =
	(
		return findString rStringToFilterStr rSubstring
	),

	-- gets the index of the last substring occurence
	-- returns undefined if not found
	-- ex: findString "Thanks for all the fish!" " f" -- returns 19
	fn mfFindLastSubstringOccurence rStringToFilterStr rSubstring =
	(
		local lRevertedStringToFilterStr = ""
		for i = rStringToFilterStr.count to 1 by -1 do
			lRevertedStringToFilterStr += rStringToFilterStr[i]
			
		local lRevertedSubstring = ""
		for i = rSubstring.count to 1 by -1 do
			lRevertedSubstring += rSubstring[i]
		
		return (rStringToFilterStr.count - (findString lRevertedStringToFilterStr lRevertedSubstring) + lRevertedSubstring.count)	
	),
	
	-- convert a path to a string
	-- useful to replace paths in files with mfReplaceInTextFile
	-- eg:	mfConvertPathToStringPath "c:\\toto\\"	returns c:\\toto\\  (and not c:\toto\)
	fn mfConvertPathToStringPath rPath =
	(
		local lStr = ""
		local i = 1
		
		-- replace / by \
		while rPath.count >= i do
		(
			if "/" == rPath[i] then
				lStr += "\\"
			else lStr += rPath[i]
			i+=1
		)
		
		-- double every \
		lStr = mfReplaceInString lStr "\\" "\\\\"
		
		return lStr
	),


	fn mfDisplayFormattedArray rArrayNameStr rArray =
	(
		format "\nArray: %, Count: %\n" rArrayNameStr rArray.count
		for i=1 to rArray.count do
			format "   %: %\n" i (rArray[i])
	),
	
	
	------------------------------------------------------------------------------- -- __
	------------------------------------------------------------------------------- -- __
	
			-- _io_files_
	
	------------------------------------------------------------------------------- -- __
	-------------------------------------------------------------------------------
	
	
	-- only support #maxroot, #scripts and the name of a custom directory so far
	-- returns a string path ending with \, like: "c:\\3dsmax\\"
	-- eg: 
	fn mfGetDir rDirName =
	(
		local lDir = ""
	
		-- #maxroot path
		if true == gbUseWkDevMode then
			try( lDir = (WkDevTool.mfGetDevDir #maxroot) )
			catch(
				lDir = (getDir #maxroot)
				format " *** WkStdLib.mfGetDir: DevPath Not Found ***"
				)
		else lDir = getDir #maxroot
		
		if #scripts == rDirName then
			lDir += "scripts\\"
		else if string == classof rDirName do		-- case of a script name
		(
			lTmpDir = lDir + "scripts\\WerwacKScripts\\" + rDirName + "\\"
			if (doesFileExist lTmpDir) then
				lDir += "scripts\\WerwacKScripts\\" + rDirName + "\\"
			else
			(
				format " *** WkStdLib.mfGetDir: Path Not Found: % ***" lTmpDir
				messagebox ("Warning: mfGetDir returned an invalid path for \"" + rDirName as string + "\"") title:"Maxscript Warning"
			)
		)
		
		return lDir
	),

	-- create the specifed path and return true if path exists, false othewise
	fn mfCreatePath rPath =
	(
		local lbPathExists = doesFileExist rPath
		
		if not lbPathExists do
		(
			lTokensArr = filterString rPath "\\"
			if 0 == lTokensArr.count do
				return lbPathExists
			
			local i = 0
			local lbSubPathExists = true
			local lExistingSubPath = ""
			while lbSubPathExists and i < lTokensArr.count do
			(
				i += 1
				lExistingSubPath += lTokensArr[i] + "\\"
				
				if not (lbSubPathExists = doesfileexist lExistingSubPath) do
					lbSubPathExists = makeDir lExistingSubPath					-- create dir
			)
			lbPathExists = lbSubPathExists
		)

		return lbPathExists
	),
	
	
	-- delete the content of a folder and, if rbDeleteContentOnly is true, the folder itself
	-- returns true if everything went right, false otherwise
	fn mfDeleteFolder rPath rbDeleteContentOnly:false =
	(
		local lbRes = true
		
		if rbDeleteContentOnly then		-- root folder is not deleted
		(
			local lPath = copy rPath
			if not "\\" == lPath[lPath.count] do
				lPath += "\\"
			lPath += "*"
			
			-- delete all files
			local lContentArr = getFiles lPath
			for lFile in lContentArr do
				if not deleteFile lFile do
					messageBox ("mfDeleteFolder: Cannot delete following file \n\n" + lFile)
					
			lContentArr = getDirectories lPath
			for lDir in lContentArr do
				if not HiddenDOSCommand ("rmDir /S /Q \"" + lDir + "\"") do
				(
					messagebox ("*** mfDeleteFolder: an error occured during the folders deletion\n\nCannot delete following folder \n\n" + lDir)
					lbRes = false
				)
		)
		else							-- root folder and all its content are deleted
			if not HiddenDOSCommand ("rmDir /S /Q \"" + rPath + "\"") do
			(
				messagebox ("*** mfDeleteFolder: an error occured during the folders deletion in the following folder \n\n" + lDir)
				lbRes = false
			)
			
		return lbRes
	),

	fn mfGetTreeRec rCollectedDirsArr rSourcePath =
	(
		--format "\n rSourcePath: %\n" rSourcePath
		local lTmpDirsArr = GetDirectories (rSourcePath + "*")
		--format "lTmpDirsArr:%\n" lTmpDirsArr
		if 0 != lTmpDirsArr.count then
			for i=1 to lTmpDirsArr.count do
				mfGetTreeRec rCollectedDirsArr (lTmpDirsArr[i] + "*")
		else
		(
			local lArr = #()
			append lArr (getFilenamePath rSourcePath)
			join rCollectedDirsArr lArr
		)

		return rCollectedDirsArr
	),

	-- provides all the leaves directories in an array
	--eg: d:\temp\ and d:\temp\toto\ : only d:\temp\toto\ is kept
	fn mfGetTree rSourcePath =
	(
		local lCollectedDirsArr = #()

		if 0 != (GetDirectories (rSourcePath + "*")).count do
			lCollectedDirsArr = mfGetTreeRec lCollectedDirsArr rSourcePath

		return lCollectedDirsArr
	),
	
	-- returns true if the directory rSourcePath has been deleted, false otherwise
	-- rpbRes is set to true if everything went ok, false otherwise
	-- *** always call mfDeleteEmptyDirs, not this function!!!
	fn mpfDeleteEmptyDirsRec rSourcePath rIndentStr &rpbRes =
	(
		rIndentStr += "    "
		local lbDirHasBeenDeleted = false
		local lbAtLeastOneFileInAChildFolder = false
		
	--	format "\n%mfDeleteEmptyDirsRec: Entree - rSourcePath: %\n" rIndentStr rSourcePath
		local lTmpDirsArr = GetDirectories (rSourcePath + "*")
	--	format "%mlTmpDirsArr:%\n" rIndentStr lTmpDirsArr
		local i=1
		while lTmpDirsArr.count>=i do
			if mpfDeleteEmptyDirsRec (lTmpDirsArr[i]) rIndentStr &rpbRes then
				deleteItem lTmpDirsArr i			-- dir is deleted in mfDeleteEmptyDirsRec, we then ave to update the dir array
			else
			(
				lbAtLeastOneFileInAChildFolder = true
				i+=1
			)
	--	format "%updated mlTmpDirsArr:%\n" rIndentStr lTmpDirsArr
		
	--	local lPath = (rSourcePath + "*.*")
		format "%getfiles (here *.*): %\n" rIndentStr (getFiles lPath)
		
		if not lbAtLeastOneFileInAChildFolder and 0 == (getFiles lPath).count do
		(
		--	format "%*** deleting cur dir... rSourcePath: %\n" rIndentStr rSourcePath
			-- delete this dir because it is empty
			local lRes
			-- HiddenDOSCommand returns 0 if everything is ok
			HiddenDOSCommand ("rmDir /S /Q \"" + rSourcePath + "\"") exitCode:&lRes
			if 0 != lRes then
				messagebox ("*** mfDeleteFolder: an error occured during the folders deletion\n\nCannot delete following folder \n\n" + rSourcePath)
			else
			(
				lbDirHasBeenDeleted = true
				rpbRes = false
			)
		)
		
		return lbDirHasBeenDeleted
	),

	-- deletes all the empty branches in a directory structure
	-- returns true if everithing went right, false otherwise
	-- eg: 	"d:\\Temp\\toto"					will also delete toto if toto is empty
	--  	"d:\\Temp\\toto\\"					will NOT delete toto, only empty folders in it
	--		"d:\\Temp\\toto\\*"					doesn't work and is not intended to
	fn mfDeleteEmptyDirs rSourcePath =
	(
		local lbRes = true
		
		-- case "d:\\Temp\\toto\\"   we do NOT delete the root
		if "\\" == rSourcePath[rSourcePath.count] then
		(
			local lTmpDirsArr = GetDirectories (rSourcePath + "*")
			local i=1
			while lTmpDirsArr.count>=i do
				if mpfDeleteEmptyDirsRec (lTmpDirsArr[i]) "" &lbRes then
					deleteItem lTmpDirsArr i			-- dir is deleted in mfDeleteEmptyDirsRec, we then ave to update the dir array
				else i+=1
				
			lbRes = true
		)
		else lbRes = mpfDeleteEmptyDirsRec (rSourcePath + "\\") "" &lbRes
		
		return lbRes
	),
	
	-- *** Do not use directly: use mfGetFiles ***
	-- if rSourcePath doesn't end with "\\" the root files are returned
	-- if rSourcePath ends with "\\" the root files are not returned
	-- rPattern: use "*.*" to get all files
	-- wkip fonction foireuse: faire marcher le wildcard correctement...
	fn mpfGetFilesRec rSourcePath rPattern =
	(
		local lFilesArr = #()
		local lDirsArr = GetDirectories (rSourcePath + "*")
		
		for d in lDirsArr do
		  join lDirsArr (GetDirectories (d + "*"))
		
		for f in lDirsArr do
		  join lFilesArr (getFiles (f + rPattern))
		
		return lFilesArr
	),
	
	-- recursively get files with the given wildcard
	fn mfGetFiles rSourcePath rPattern rbRecursive:true rbIncludeRootFiles:true =
	(
		local lbRecursive = rbRecursive
		local lbIncludeRootFiles = rbIncludeRootFiles
		local lFilesArr = #()

		local lSourcePath = rSourcePath
		if "\\" != lSourcePath[lSourcePath.count] do
			lSourcePath += "\\"
		
		if lbIncludeRootFiles do
			lFilesArr = getFiles (lSourcePath + rPattern)
		
		if lbRecursive do
		(
			lFilesArr += mpfGetFilesRec lSourcePath rPattern
		)
		return lFilesArr
	),
	
	/*
lib = tWkStdLibV3()
cop = lib.mfCopyFiles
src = "d:\\temp\\TempV1\\"
dst = "d:\\temp\\a"
cop scr dst
*/
	-- copy files and/or directories mathing the wildcard given by rSourcePath to rDestPath
	-- rSourcePath can be a file or a directory
	-- *** if rSourcePath is a directory it must end with \ !!!
	-- eg: 	"d:\\Temp\\toto"								will copy all the content of the folder toto inside a new folder named toto
	--  	"d:\\Temp\\toto\\", "d:\\Temp\\toto\\*",		will copy all the content of the folder toto but not toto itself. it will also copy
	--														all the directories, even the empty ones.
	-- 		"d:\\Temp\\toto\\*.*"							will copy the content of the folder toto but not toto itself nor the empty directories.
	
	-- overwrite destination files, if exist, without prompting
	-- if rIgnoredSourceFilesArr is provided files IN THE SOURCE DIRECTORY matching that wildcard will not be affected by the operation
	-- rIgnoredSourceFilesArr is the full path of files to ignore
	fn mfCopyFiles rSourcePath rDestPath rIgnoredSourceFilesArr: =
	(
		local lbRes = true
		
		local lDestPath = copy rDestPath
		if "\\" != lDestPath[lDestPath.count] do lDestPath += "\\"
		--if "\\" == lDestPath[lDestPath.count] do lDestPath = substring lDestPath 1 (lDestPath.count - 1)
		
		local lSourceRootPath = getFilenamePath rSourcePath
		local lSourceRootPathLength = lSourceRootPath.count
		
		local lIgnoredFilesArr = #()
		if unsupplied != rIgnoredSourceFilesArr and undefined != rIgnoredSourceFilesArr and 0 != rIgnoredSourceFilesArr.count do
			lIgnoredFilesArr = copy rIgnoredSourceFilesArr #nomap

		----------------------
		-- directories
		----------------------
		-- collect and copy the directory structure

		local lSourceDirsArr = mfGetTree rSourcePath
		local lDestDirsArr = #()
		for i=1 to lSourceDirsArr.count do
			lDestDirsArr[i] = lDestPath + substring lSourceDirsArr[i] lSourceRootPathLength -1
	
	--	format "mfCopyFiles: lDestDirsArr = %\n" lDestDirsArr
		
		i = 1
		while lDestDirsArr.count>=i and lbRes do
		(
			lbRes = mfCreatePath lDestDirsArr[i]
			i+=1
		)
				
		----------------------
		-- files
		----------------------
		if lbRes do
		(
			local lSourceFilesArr = #()
			
			--*** wkip we do not cover the case were there is a * in the path
			--block pas top parce que mfGetFiles ne supporte pas correctement les wildcards
			
			if "" != getFilenameType rSourcePath then
			(
				local lFileName = filenameFromPath rSourcePath
				if undefined == findString lFileName "*" then
					lSourceFilesArr = #(rSourcePath)											-- if rSourcePath is a file with no wildcard
				else lSourceFilesArr = mfGetFiles (getFilenamePath rSourcePath) lFileName		-- if rSourcePath is a file with widlcard then collect files
			)
			else if ("\\" == substring rSourcePath rSourcePath.count -1) or ("\\*" == substring rSourcePath (rSourcePath.count - 1) -1) then						-- if rSourcePath is a directory, possibly finishing by *
				lSourceFilesArr = mfGetFiles rSourcePath "*.*"
			else
			(
				messageBox ("*** mfCopyFiles : argument with wildcard not supported:\n " + rSourcePath)
				lbRes = false
			)
			
			
			--format "mfCopyFiles: lSourceFilesArr before clean = %\n" lSourceFilesArr			
			
			-- remove all unwanted files of lIgnoredFilesArr that could be in lSourceFilesArr
			-- and build lDestFilesArr
			local lDestFilesArr = #()
			local i=1
			mfDisplayFormattedArray "lIgnoredFilesArr" lIgnoredFilesArr
			while i <= lSourceFilesArr.count do
			(
				local lbAppendFile = true
				
				-- remove ignored files
				if 0 < lIgnoredFilesArr.count do
				(
					local j=1
					while lbAppendFile and j <= lIgnoredFilesArr.count do
					(
						-- if a matching pattern is found the file will be removed from lSourceFilesArr
						-- match pattern uses wildcards (* and ?)
						lbAppendFile = not matchPattern lSourceFilesArr[i] pattern:(lIgnoredFilesArr[j] + "*") ignoreCase:true
						
						-- if a match is found we remove the item
						if not lbAppendFile do
							deleteItem lSourceFilesArr i
						j+=1
					)
				)
				
				if true == lbAppendFile then
				(
					append lDestFilesArr (lDestPath + substring lSourceFilesArr[i] (lSourceRootPathLength + 1) -1)
					i+=1
				)
				-- else no need to increment i because an item in lSourceFilesArr has been removed
			)
			
		--	format "  -- lSourceFilesArr.count: %, lDestFilesArr.count: % \n" lSourceFilesArr.count lDestFilesArr.count
		--	mfDisplayFormattedArray "lSourceFilesArr" lSourceFilesArr
		--	mfDisplayFormattedArray "lDestFilesArr" lDestFilesArr
		--	format "mfCopyFiles: lDestFilesArr = %\n" lDestFilesArr
			
			-- copy files
			i = 1
			while lSourceFilesArr.count>=i and lbRes do
			(
				-- delete existing file on dest
				if doesFileExist lDestFilesArr[i] do
					if not deleteFile lDestFilesArr[i] do
					(
						messageBox ("Cannot delete following file:\n\n" + lDestFilesArr[i] + "\n\nCancel copy") title:"mfCopyFiles : Error during file copy"
						lbRes = false
					)
				
				if lbRes do
					if not copyFile lSourceFilesArr[i] lDestFilesArr[i] do
					(
						messageBox ("Cannot copy following file:\n\n" + lDestFilesArr[i] + "\n\nCancel copy") title:"mfCopyFiles : Error during file copy"
						lbRes = false
					)
				
				i+=1
			)
		)
			
		return lbRes
	),
	
	
	-- return a null string ("") if no value is found or the init file couldn t be created,
	-- the key value otherwhise
	fn mfGetINISetting rInitFilePath rSectionStr rKeyStr rDefaultKeyValueStr: =
	(
		local lKeyValueFoundStr = getINISetting rInitFilePath rSectionStr rKeyStr
		
		if "" == lKeyValueFoundStr and unsupplied != rDefaultKeyValueStr do
			if setINISetting rInitFilePath rSectionStr rKeyStr rDefaultKeyValueStr do
				lKeyValueFoundStr = rDefaultKeyValueStr
	--	format "lKeyValueFoundStr2: %\n" lKeyValueFoundStr
		
		return lKeyValueFoundStr
	),
	
	-- completely remove the line related to the given key in an init file
	-- rSectionStr: must be the same as the section name (if the section name contains rSectionStr, then it is not considered as a valid section)
	-- rKeyStr: must be the same as the key name if rbKeyWordOnly if true. If rbKeyWordOnly is false, any key containing rKeyStr are considered as valid and will be removed
	fn mfRemoveINISetting rInitFilePath rSectionStr rKeyStr rbKeyWordOnly:true =
	(
		local lbTextReplaced = false
		local lFileFullName = rInitFilePath
		local lStream
		local lbLineHasBeenRemoved = false
		
		local lNewTextFileStr = ""
		
		if doesFileExist lFileFullName do
		(
			setFileAttribute lFileFullName #readOnly false
			lStream = openFile lFileFullName mode:"rS"
		)

		if undefined != lStream do
		(
			local lbSectionFound = false
			while not eof lStream do
			(
				local lCurrentLineStr = (readLine lStream) as string
				-- wknote: lCurrentLineStr cannot be modified in the following code for some reason; it is then copied into lLocalCurrentLineStr
				local lNewCurrentLineStr = copy lCurrentLineStr
				
				-- if section is found, then check for the key
				-- wknote: even if the section has been found, we continue to check if another section with the same name exists, just in case
				local lLineWordsArr = filterString lNewCurrentLineStr "[ ]\t"
				if 0 < lLineWordsArr.count \
					and undefined != findString lNewCurrentLineStr "[" \
					and undefined != findString lNewCurrentLineStr "]" \
					and (toLower lLineWordsArr[1]) == (toLower rSectionStr) then
				--	and undefined != findString (toLower lLineWordsArr[1]) (toLower rSectionStr) then
				(
					lbLineHasBeenRemoved = false
					local lbSectionEndReached = false
					lNewTextFileStr += lNewCurrentLineStr + "\n"		-- copy the section line
					
					while not eof lStream and not lbSectionEndReached do
					(
						local lCurrentLineStr = (readLine lStream) as string
						-- wknote: lCurrentLineStr cannot be modified in the following code for some reason; it is then copied into lLocalCurrentLineStr
						local lNewCurrentLineStr = copy lCurrentLineStr
						
						-- check if we are already in another section
						local lIndOpeningBracket = findString lNewCurrentLineStr "[" 
						local lIndClosingBracket = findString lNewCurrentLineStr "]" 
						if undefined != lIndOpeningBracket and undefined != lIndClosingBracket and lIndOpeningBracket < lIndClosingBracket and undefined == findString lNewCurrentLineStr "=" do
							lbSectionEndReached = true
						
						lLineWordsArr = filterString lNewCurrentLineStr " =\t"
						if not lbSectionEndReached and 0 < lLineWordsArr.count \
								and ( (not rbKeyWordOnly and undefined != findString (toLower lLineWordsArr[1]) (toLower rKeyStr)) \
									or (rbKeyWordOnly and (toLower lLineWordsArr[1]) == (toLower rKeyStr)) ) then
						(
							lbLineHasBeenRemoved = true
							-- current line is completely excluded
						--	lNewCurrentLineStr += lLocalCurrentLineStr
						)
						else lNewTextFileStr += lNewCurrentLineStr + "\n"
					)
				)
				else lNewTextFileStr += lNewCurrentLineStr + "\n"
			)
		
			flush lStream
			close lStream
			
			if lbLineHasBeenRemoved do
			(
				lStream = openFile lFileFullName mode:"wt"
				format lNewTextFileStr to:lStream
				close lStream
				lbTextReplaced = lbLineHasBeenRemoved
			)
		)
		
		return lbTextReplaced
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
	
		if doesFileExist lFileFullName do
		(
			setFileAttribute lFileFullName #readOnly false
			deleteFile lFileFullName
		)
		
		local lStream = createFile lFileFullName
		if undefined != lStream do
		(
			format rTextStr to:lStream
			close lStream
			lbFileCreated = true
		)
		return lbFileCreated
	),
	
	-- add rTextStr at the end of the specified text file
	-- returns true if succeded, false otherwise
	-- if file does not exist, it is created
	-- myStruct.mfAddToTextFile "d:\\temp\\test.txt" "mon bazard\ntest\n"
	fn mfAddToTextFile rFileFullName rTextStr =
	(
		local lbTextAdded = false
		local lFileFullName = mfReplaceChar rFileFullName "\\" "/"
		local lStream
	
		if doesFileExist lFileFullName then
		(
			setFileAttribute lFileFullName #readOnly false
			lStream = openFile lFileFullName mode:"a+"
		)
		else lStream = createFile lFileFullName
		
		if undefined != lStream do
		(
			format rTextStr to:lStream
			close lStream
			lbTextAdded = true
		)
		
		return lbTextAdded
	),


	/*
	ar1=#("TemplateScript")
	ar2=#("MyScriptName")
	dev = tWkStdLibDev()
	dev.mfReplaceInTextFile "d:\\temp\\test.ms" ar1 ar2
tester replace lCurrentLineStr lTmpIndex (rStringsToFindArr[i].count) rNewStringsArr[i]
*/
	-- get the error message by adress
	-- eg:	lErrorStr = ""
	--		dev.mfReplaceInTextFile "d:\\temp\\test.ms" ar1 ar2 &lErrorStr
	fn mfReplaceInTextFile rFileFullName rStringsToFindArr rNewStringsArr rbMatchWholeWordOnly:false rbMatchCase:false &rpErrorStr:undefined =
	(
	
	--	break()
		local lbTextReplaced = false
		local lFileFullName = mfReplaceChar rFileFullName "\\" "/"
		local lStream
		local lErrorStr = ""
		
		local lNewTextFileStr = ""
		
		if doesFileExist lFileFullName then
		(
			setFileAttribute lFileFullName #readOnly false
			lStream = openFile lFileFullName mode:"rS"
		)
		else lErrorStr = lFileFullName as string + " : File not found"
	--	else lStream = createFile lFileFullName
		
		if undefined != lStream do
		(
			while not eof lStream do
			(
				local lCurrentLineStr = (readLine lStream) as string
				-- wknote: lCurrentLineStr cannot be modified in the following code for some reason; it is then copied into lLocalCurrentLineStr
				local lNewCurrentLineStr = copy lCurrentLineStr
				for i=1 to rStringsToFindArr.count do
				(
				--	format a + b ici pb d ecrasement de variable...
				--	local lLocalCurrentLineStr = copy lCurrentLineStr
					lNewCurrentLineStr = mfReplaceInString lNewCurrentLineStr rStringsToFindArr[i] rNewStringsArr[i] rbMatchWholeWordOnly:rbMatchWholeWordOnly rbMatchCase:rbMatchCase
				)

			--	format "tt + %\n" lNewCurrentLineStr
				lNewTextFileStr += lNewCurrentLineStr + "\n"
			)

		--	break()
			flush lStream
			close lStream
			
			lStream = openFile lFileFullName mode:"wt"
		--	format  "%\n" lNewTextFileStr
		-- write content to file
			format "%" lNewTextFileStr to:lStream

			close lStream
			lbTextReplaced = true
		)

		-- outputs
		if undefined != rpErrorStr do
			rpErrorStr = copy lErrorStr
		return lbTextReplaced
	),
	
	-- open a text file in the Max default text editor
	-- rFileFullName:	file path and name
	fn mfEditTextFile rFileFullName =
	(
		local lbFileFound = false
		local lFileFullName = mfReplaceChar rFileFullName "\\" "/"
			
		if 0 != (getfiles (lFileFullName)).count then
		(
			edit lFileFullName
			lbFileFound = true
		)
		return lbFileFound
	),
		
	-- Note: folder structure will not be deleted (maxscript limitation)
	fn mfDeleteFilesFromListFile rListFileFullPath =
	(
		local lbRes = true
		local lFilesArr = #()
				
		if doesFileExist rListFileFullPath then
		(
			local lTexStream = openFile rListFileFullPath mode:"rt"
			
			lTmpStr = readLine lTexStream
			while not eof lTexStream do
			(
				if doesFileExist (lTmpStr = (getDir #maxroot) + lTmpStr) do
					append lFilesArr lTmpStr

				lTmpStr = readLine lTexStream
			)
			
			flush lTexStream
			close lTexStream

			for fileStr in lFilesArr do
			(
				--if deleteFile fileStr then
				if "" == filenameFromPath fileStr then							-- directory case
					if 0 == (DOSCommand ("rmdir \"" + fileStr + "\" /s ")) then	--/q for silent mode
						 format "Folder structure deleted: %\n" fileStr
					else
					(
						format "*** Folder structure not deleted: %\n" fileStr
						lbRes = false
					)
				else															-- file case
					if 0 == (DOSCommand ("del \"" + fileStr + "\" /s /f /p ")) then	--/q for silent mode
						 format "File deleted if confirmation from user was positive: %\n" fileStr
					else format "*** File not deleted: %\n" fileStr
			)
		)
		else lbRes = false
		
		return lbRes
	),

                                                                                    -- __
	------------------------------------------------------------------------------- -- __
	
			-- _Maths_and_transforms_
	
	------------------------------------------------------------------------------- -- __
	-------------------------------------------------------------------------------

	-- reste de la division entiere de rNum par rDiv
	-- if rNum and rDiv are integers, returns an integer
	fn mfModulo rNum rDiv =
	(
		--7%3
		--x%y= x-((x/y)*y)
		local lRes
		if (classof rNum) == integer and (classof rDiv) == integer then
			lRes = rNum - ((rNum / rDiv) * rDiv)
		else lRes = mod rNum rDiv
		if 0.0 > lRes do lRes = rDiv + lRes
		
		return lRes
	),


                                                                                    -- __
	------------------------------------------------------------------------------- -- __
	
			-- _Time_
	
	------------------------------------------------------------------------------- -- __
	-------------------------------------------------------------------------------
	
	
	-- based on getLocalTime() it returns an array containing strings that have been formatted
	-- Whereas getLocalTime returns #(2014, 7, 5, 4, 12, 42, 50, 98)
	-- mfGetFormattedLocalTime will return #("2014", "07", "05", "04", "12", "42", "50", "098")
	-- Array elements are: 
	-- 		- 1 Year- Specifies the current year. 
	-- 		- 2 Month- Specifies the current month; January = 1, February = 2, and so on. 
	-- 		- 3 DayOfWeek- Specifies the current day of the week; Sunday = 0, Monday = 1, and so on. 
	-- 		- 4 Day- Specifies the current day of the month. 
	-- 		- 5 Hour- Specifies the current hour. 
	-- 		- 6 Minute- Specifies the current minute. 
	-- 		- 7 Second- Specifies the current second. 
	-- 		- 8 Milliseconds- Specifies the current millisecond. 
	fn mfGetFormattedLocalTime =
	(
		local lTimeArr = getLocalTime()
		
		for i=1 to lTimeArr.count do
			lTimeArr[i] = lTimeArr[i] as string
		
		-- month
		if 1 == lTimeArr[2].count do lTimeArr[2] = "0" + lTimeArr[2]
		-- day
		if 1 == lTimeArr[4].count do lTimeArr[4] = "0" + lTimeArr[4]
		-- hour
		if 1 == lTimeArr[5].count do lTimeArr[5] = "0" + lTimeArr[5]
		-- minute
		if 1 == lTimeArr[6].count do lTimeArr[6] = "0" + lTimeArr[6]
		-- second
		if 1 == lTimeArr[7].count do lTimeArr[7] = "0" + lTimeArr[7]
		-- milliseconde
		if 1 == lTimeArr[8].count then lTimeArr[8] = "00" + lTimeArr[8]
		else if 2 == lTimeArr[8].count then lTimeArr[8] = "0" + lTimeArr[8]
		
		return lTimeArr
	),
	
	                                                                                    -- __
	------------------------------------------------------------------------------- -- __
	
			-- _Mesh_
	
	------------------------------------------------------------------------------- -- __
	-------------------------------------------------------------------------------
	
	-- check if rObj is an editable mesh or editable poly
	-- wkip modifiers for edit are not supported and conversion is asked
	-- ask user for convertion if rbAskForConvertion is true
	-- no undo implemented
	fn mfIsMeshOrPoly rObj rbAskForConvertion: =
	(
		lbAskForConvertion = if unsupplied == rbAskForConvertion then false else rbAskForConvertion
		lbIsObjectMeshOrPoly = false
	--	format "******************************* lbAskForConvertion : %\n" lbAskForConvertion
		
		if GeometryClass == superclassof rObj do
			if not (Editable_Mesh == classof rObj and Editable_Mesh == classof rObj.baseobject) \
				and not (Editable_Poly == classof rObj and Editable_Poly == classof rObj.baseobject) then
			--	and not PolyMeshObject == classof rObj then
				if lbAskForConvertion do
				(
					global gMessageDialog
					global gTmpObj = rObj
					global gbTmpConverted = false
					lTitleStr = "Convert object?"
					
					lRolloutStr = ""
					try( DestroyDialog gMessageDialog )
					catch()
					
					lRolloutStr += "rollout gMessageDialog \"" + lTitleStr + "\" \n"
					lRolloutStr += "( \n"
					lRolloutStr += "	label MessageLab \"Object \\\"" + rObj.name + "\\\" needs to be converted:\" align:#left offset:[60,10] \n"
					lRolloutStr += "	label ConvertMessageLab \"New type:\" align:#left offset:[90,10] \n"
					lRolloutStr += "	radiobuttons convertTypeRadbut labels:#(\"Editable Mesh\", \"Editable Poly\") default:1 align:#left offset:[150,-18] \n"
					lRolloutStr += "	label ConvertQuestionLab \"Convert it?\" align:#left offset:[60,14] \n"
					
					lRolloutStr += "	button YesBut \"Yes\" width:50 height:22 align:#center offset:[-36,10] \n"
					lRolloutStr += "	button NoBut \"No\" width:50 height:22 align:#center offset:[36,-28] \n"
					
					lRolloutStr += "	on YesBut pressed do \n"
					lRolloutStr += "	( \n"
					lRolloutStr += "		if 1 == convertTypeRadbut.state then \n"
					lRolloutStr += "			convertto gTmpObj Editable_Mesh \n"
					lRolloutStr += "		else convertto gTmpObj Editable_Poly \n"
					lRolloutStr += "		gbTmpConverted = true \n"
					lRolloutStr += "		try( DestroyDialog gMessageDialog )	catch() \n"
					lRolloutStr += "	) \n"
					lRolloutStr += "	on NoBut pressed do \n"
					lRolloutStr += "		try( DestroyDialog gMessageDialog )	catch() \n"
					lRolloutStr += ") \n"
					
					execute lRolloutStr
					CreateDialog gMessageDialog 400 140 style:#( #style_titlebar, #style_sysmenu ) modal:true
					
					gTmpObj = undefined
				)
				else lbIsObjectMeshOrPoly = true
				
			if true == gbTmpConverted do
				lbIsObjectMeshOrPoly = true
			gbTmpConverted = undefined
			
		return lbIsObjectMeshOrPoly
	),
	

	------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	
			-- _UVs_
	
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	/*
	wkip in progress
	rTargetChannelInd = -2: alpha
						-1: illum
						0 : VC
						1 : map channel 1...
	
	
	*/
/*	fn mfCopyUVChannel rSourceObj rSourceChannelInd rTargetObj rTargetChannelInd =
	(
		-- if source has channel
		-- if source and target have same nb vertices
		if ((getNumVerts rSourceObj) == (getNumVerts rTargetObj)) then
		(
			-- marche po sur poly if ((getNumFaces FromObject) == (getNumFaces ToMesh)) then(
			/*	if(not meshop.getMapSupport obj src) then
			(
				messagebox "Source type not supported"
				return OK
			)
			*/
			-- delete old vertex channel on target
		/*	if (meshop.getMapSupport rTargetObj.mesh rTargetChannelInd) then
				meshop.setMapSupport rTargetObj.mesh rTargetChannelInd false
				-- update??
			
			--if poly == classof rTargetObj
			
			-- mesh
			--else
			(
				
			--	meshop.SetMapSupport rTargetObj rTargetChannelInd true
				
				--create vertex support
				local lTargetIsEditPoly = false
				if Editable_Poly == classof rTargetObj do
				(
					lTargetIsEditPoly = true
					convertToMesh rTargetObj
				)
				
				if (not meshop.getMapSupport rTargetObj.mesh rTargetChannelInd) then
				(
					if 2 <= rTargetChannelInd do
					(
						--note:  we must add "+1" cause map channel 1 and vc are already 2 channels
						-- and nummaps represents the total number of maps (alpha and illum are not counted)
						meshop.setNumMaps rTargetObj.mesh (rTargetChannelInd + 1) keep:false
						--wkip update?
						
						-- the new channel is created with vertices in it
						meshop.freeMapChannel rTargetObj.mesh rTargetChannelInd
					)
						
					meshop.setMapSupport rTargetObj.mesh rTargetChannelInd true
				)
				
			--	for mapnr = (if (CopyColorCh==true) then 0 else 1) to 99 do(
			--		if ((meshop.GetMapSupport FromObject mapnr)==true) then (
			--			meshop.SetMapSupport ToMesh mapnr (meshop.GetMapSupport FromObject mapnr)

						--
						-- First the vertices:
						--
						nrverts = meshop.getNumMapVerts rSourceObj.mesh rSourceChannelInd
						meshop.setNumMapVerts rTargetObj.mesh rTargetChannelInd nrverts
						for i = 1 to nrverts do
						(
							meshop.setMapVert rTargetObj.mesh rTargetChannelInd i (meshop.getMapVert rSourceObj.mesh rSourceChannelInd i)
						)


						--
						-- Now the faces:
						--

						nrfaces = meshop.getNumMapFaces rSourceObj.mesh rSourceChannelInd

						for i = 1 to nrfaces do
						(
							meshop.setMapFace rTargetObj.mesh rTargetChannelInd i (meshop.getMapFace rSourceObj.mesh rSourceChannelInd i)
						)
					
				
				update rTargetObj -- LAM: added line to force mesh and object update
				
				if lTargetIsEditPoly do
					convertToPoly rTargetObj
				
			--	MessageBox "Finished copying UV coordinates"
				
				
			)
		)
	),*/
	
	
	------------------------------------------------------------------------------
	-------------------------------------------------------------------------------

			-- _Scripts_and_GUI_

	------------------------------------------------------------------------------
	-------------------------------------------------------------------------------

	-- since 3dsMax 2010, buttons tooltip only appears once when the user asks for them
	-- This function forces the content of the tooltips so they can be displayed again
	-- Call this function in mfUpdateGui, for every rollouts of the dialog window
	-- last modifications: 2009/07/19
	fn mfUpdateGuiForceComponentTooltips rRollout =
	(
		for lComponent in rRollout.controls do
			if isProperty lComponent #tooltip do
				lComponent.tooltip = lComponent.tooltip
	),
	
	-- Prompt the user for a path, store it into the init file if specified
	-- Return the new path or undefined if the used canceled the operation
	-- - rCaptionStr:	the caption of the OpenFile window
	-- - rbFile:		if true, open a file window, if false, open a folder window
	-- - rFileNotFoundFullPath: the full path and name of the file that has nob been found. If unsupplied, no messagebox is displayed to the user
	-- - rInitFileFullPath: the init file where the defined path, if valid, will be stored
	-- Use:
	--		if not doesFileExist lMyFile do lMyFile = mfAskUserForMissingPath "My file info" true
	--		if undefined != lMyFile do ...
	fn mfAskUserForMissingPath rCaptionStr rbFile rFileNotFoundFullPath: rInitFileFullPath: rSectionStr: rKeyStr: =
	(
		local lFileFullPath
		
		local lInitFileFullPath = if unsupplied != rInitFileFullPath then rInitFileFullPath else undefined
		if undefined != lInitFileFullPath and not doesFileExist lInitFileFullPath do
		(
			local lTmpStr = "Warning: Specified Init file not found:\n\n"
			lTmpStr += "\"" + lInitFileFullPath + "\"\n\n"
			lTmpStr += "The path you are about to define will not be stored"
			messagebox lTmpStr title:"WkStdLib:mfAskUserForPathProperty"
			lInitFileFullPath = undefined
		)
		
		if unsupplied != rFileNotFoundFullPath do
		(
			local lTmpStr
			if rbFile then
				lTmpStr = "File not found:\n\n"
			else lTmpStr = "Folder not found:\n\n"
			lTmpStr += "\"" + rFileNotFoundFullPath + "\"\n\n"
			lTmpStr += "Please define a new one"
			messagebox lTmpStr title:"Target not found"
		)
		
		if rbFile then		-- file or folder?
			lFileFullPath = getOpenFileName caption:rCaptionStr types:"All|*.*|"	-- filename:lFileFullPath
		else lFileFullPath = getSavePath caption:rCaptionStr						-- initialDir:lFileFullPath

		if undefined != lFileFullPath and undefined != lInitFileFullPath do
			setINISetting lInitFileFullPath rSectionStr rKeyStr lFileFullPath

		return lFileFullPath
	),

	
	
	------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	
			-- _Various_
	
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------

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
		
		local lTitleStr = if unsupplied == rTitleStr then "WerwacKScripts" else rTitleStr
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
		
		print rMessageStr
		
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
	
	
	-- rFilterTypeStr can be: "geometry"
	-- returns an array
	-- wkip to improve
	fn mfGetFilteredObjectsFromArray rElementsArr rFilterClassArr =
	(
		local lFilteredElementsArr = #()
		
		for obj in rElementsArr do
		(
			lbElementIsValid = false
			ind = 1
			while not lbElementIsValid and ind <= rFilterClassArr.count do
				if rFilterClassArr[ind] == (classof obj) or rFilterClassArr[ind] == (superclassof obj) then
				(
					append lFilteredElementsArr obj
					lbElementIsValid = true
				)
				else ind += 1
		)
		
	--	format "lFilteredElementsArr: %\n" lFilteredElementsArr
		return lFilteredElementsArr
	),
	
	-- return true if rObj inherits from rClass
	-- eg: mfIsSubClassOf sphere node
	--	returns: true
	fn mfIsSubClassOf rObj rClass =
	(
		local lCurrentClass = undefined
		local lParentClass = classOf rObj
		local lbIsSubClass = rClass == classOf rObj
		
		while not lbIsSubClass and lParentClass != lCurrentClass do
		(
		--	format "lCurrentClass: %, lParentClass: %\n" lCurrentClass lParentClass
			lCurrentClass = lParentClass
			lParentClass = classof lCurrentClass
			
			if rClass == lCurrentClass do
				lbIsSubClass = true
		)
		
		return lbIsSubClass
	)
)
	

format "tWkStdLibV3 loaded and stored in gtWkStdLibV3...\n"

global gtWkStdLibV3 = tWkStdLibV3()

