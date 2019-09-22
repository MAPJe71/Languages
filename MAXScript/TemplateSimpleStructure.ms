/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***

	-- Template note:
	
	This script is a simple dialog window. It can be used as a standalone or as an extention of a script
	based on TemplateScript.ms	
		- C:/Users/[Username]/AppData/Local/Autodesk/3dsMax/[3ds Max Version]/ENU/Scripts/TemplateProject/TemplateScript/TemplateScript.ms

	
	
*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/


global gtTemplateSimpleStructure

struct tTemplateSimpleStructure
(
	-- Template: Add your code here ---
	-- Remove the following members if they are not required
	-- Add other members based on external values (libraries...) the same way
	
	-- pathes
	mMAXROOTDIR = undefined,							-- set in mfInit according to the status of gtTemplateScript
														-- must be used allover in the script to get 3dsMax root dir, ends with \
	mSCRIPTROOTDIR = undefined,							-- set in mfInit according to the status of gtTemplateScript
														-- must be used allover in the script to get this script root dir, ends with \ (should have the value: #maxroot\scripts\TemplateProject\TemplateScript\)
	mINITFILE,											-- init file full path corresponding to \scripts\mProjectName\TemplateScript\TemplateScript.ini
	

	
	fn mfInit =
	(
	--	format "mfInit\n"
		local lbInitOk = false
		
		-- init paths
		if not doesFileExist gtTemplateScript.mINITFILE then
			messageBox ("gtTemplateScript Init File not found:\n\n    " + gtTemplateScript.mINITFILE + "\n\nSettings aborted") title:"gtTemplateScript Warning"
		else
		(
			mMAXROOTDIR		= gtTemplateScript.mMAXROOTDIR
			mSCRIPTROOTDIR	= gtTemplateScript.mSCRIPTROOTDIR
			mINITFILE		= gtTemplateScript.mINITFILE
			
			lbInitOk = true
		)
		
		return lbInitOk
	)
	
	
	-- Template: Add your code here ---
	
)

gtTemplateSimpleStructure = tTemplateSimpleStructure()
gtTemplateSimpleStructure.mfInit()

gtTemplateSimpleStructure

