/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***

	
	View header of the following file for all the informations about this script:
		- C:/Users/[Username]/AppData/Local/Autodesk/3dsMax/[3ds Max Version]/ENU/Scripts/TemplateProject/TemplateScript/TemplateScript.ms
	
	
*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/

-- ***	Warning: The name of the subrollouts MUST ALWAYS start with the name of the main script
-- 		to avoid side effects with other script rollouts	***
rollout gTemplateScript_SamplesSubRollout "Rollout Sample"
(
	label prodlab "Rollout Sample" align:#left offset:[0,0]
	
	on gTemplateScript_SamplesSubRollout rolledUp bIsOpen do
	(
		--gtTemplateScript.mbSubRolloutRolledUp = not bIsOpen
		
		setINISetting gtTemplateScript.mINITFILE "GUISettings" (gTemplateScript_SamplesSubRollout.name + "_RolledUp") ((not bIsOpen) as string)
		gtTemplateScript.mfUpdateGui()
		format "gTemplateScript_SamplesSubRollout roll state has changed and is now: %\n" (not bIsOpen)
	)
	
	on gTemplateScript_SamplesSubRollout open do
	(
		format "gTemplateScript_SamplesSubRollout opened\n"
	)

	on gTemplateScript_SamplesSubRollout close do
	(
		format "gTemplateScript_SamplesSubRollout closed\n"
	)

)

gTemplateScript_SamplesSubRollout

	