/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***

	
	
*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/

-- ***	Warning: The name of the subrollouts MUST ALWAYS start with the name of the main script
-- 		to avoid side effects with other script rollouts	***

global gWkDevSceneToolsRoll

-- Replace every occurence of "AboutSubRollout" by <name of the new rollout>"SubRollout"
rollout gWkDevSceneToolsRoll "Scene Tools"
(
	button setColorToSelectionBut "Random Color" tooltip:"Set a random color to all the items of the selection" height:24 width:110 align:#left offset:[-2,2]
	
	on setColorToSelectionBut pressed do
	(
		local lWirecolorsArr = #()
		lWirecolorsArr[1] = (color 177 27 88)
		lWirecolorsArr[2] = (color 177 28 149)
		lWirecolorsArr[3] = (color 145 28 177)
		lWirecolorsArr[4] = (color 85 28 177)
		lWirecolorsArr[5] = (color 28 28 177)
		lWirecolorsArr[6] = (color 28 89 177)
		lWirecolorsArr[7] = (color 28 149 177)
		lWirecolorsArr[8] = (color 27 177 148)
		lWirecolorsArr[9] = (color 27 177 88)
		lWirecolorsArr[10] = (color 88 177 27)
		lWirecolorsArr[11] = (color 148 177 27)
		lWirecolorsArr[12] = (color 177 148 27)
		lWirecolorsArr[13] = (color 177 88 27)
		lWirecolorsArr[14] = (color 176 26 26)
		lWirecolorsArr[15] = (color 214 229 166)

		for obj in selection do
			obj.wirecolor = lWirecolorsArr[random 1 lWirecolorsArr.count]
	)

	on gWkDevSceneToolsRoll rolledUp bIsOpen do
	(
		WkDevTool.mbAdditionalToolsRollRolledUp = not bIsOpen
		setINISetting WkDevTool.mINITFILE "UserSettings_GUI" "bSceneToolsRollRolledUp" (WkDevTool.mbSceneToolsRollRolledUp as string)
		WkDevTool.mfUpdateGui()
	)
	
	on gWkDevSceneToolsRoll open do
	(
	--	format "gWkDevSceneToolsRoll opened\n"
	)

	on gWkDevSceneToolsRoll close do
	(
	--	format "gWkDevSceneToolsRoll closed\n"
	)

)

gWkDevSceneToolsRoll

	
