/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***

	
	View header of the following file for all the informations about this script:
		- C:/Users/[Username]/AppData/Local/Autodesk/3dsMax/[3ds Max Version]/ENU/Scripts/TemplateProject/TemplateScript/TemplateScript.ms
	
	
*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/

-- ***	Warning: The name of the subrollouts MUST ALWAYS start with the name of the main script
-- 		to avoid side effects with other script rollouts	***

global gTemplateScript_AboutSubRollout

-- Replace every occurence of "AboutSubRollout" by <name of the new rollout>"SubRollout"
rollout gTemplateScript_AboutSubRollout "About..."
(
	label prodlab "TemplateScript" align:#center offset:[0,0]
	label verslab "Version 1.0" align:#center offset:[0,0]
	label datelab "Date:-.-.2017" align:#center offset:[0,0]
	label rellab "Released: -.-.2017" align:#center offset:[0,0]

	on gTemplateScript_AboutSubRollout rolledUp bIsOpen do
	(
	--	format "gTemplateScript_AboutSubRollout roll state has changed and is now: %\n" (not bIsOpen)
		setINISetting gtTemplateScript.mINITFILE "UserSettings_GUI" (gTemplateScript_AboutSubRollout.name + "_RolledUp") ((not bIsOpen) as string)
		gtTemplateScript.mfUpdateGui()
	)
	
	on gTemplateScript_AboutSubRollout open do
	(
	--	format "gTemplateScript_AboutSubRollout opened\n"
	)

	on gTemplateScript_AboutSubRollout close do
	(
	--	format "gTemplateScript_AboutSubRollout closed\n"
	)

)

gTemplateScript_AboutSubRollout

	