

global gtComponent



-------------------------------------------------------------------------------

--ComponentStructure

struct tComponent
(
	mDialogWin = undefined,

	mPickedObj = undefined,
	
	-- filter for objects
	fn mfObjectsFilter rObj =
	(
		local lbObjectIsValid = true
	--	if GeometryClass == superclassof rObj then
	--		lbObjectIsValid = true
	--	else lbObjectIsValid = false
		
		return lbObjectIsValid
	),

	fn mfUpdateGui =
	(
		if undefined != mPickedObj and not isValidNode mPickedObj do
		(
			mPickedObj = undefined
			mDialogWin.ObjEdittxt.text = ""
			messagebox "Invalid or Deleted Object"
		)
		if undefined != mPickedObj then
			mDialogWin.ObjEdittxt.text = mPickedObj.name
		else
		(
			mDialogWin.ObjEdittxt.text = ""
		)
	),
	
	
	fn mfCreateDialogWin =
	(
		mDialogWin = rollout ComponentRoll "ComponentRoll"
		(
			-- *** Copy from here ***
			group "Reference Object "
			(
				pickbutton ObjPickbut "P" message:"Pick an Object" tooltip:"Pick an Object" filter:gtComponent.mfObjectsFilter height:18 width:12 align:#left offset:[-4,0]
				button ObjfromSelBut "$" tooltip:"Get Object From Selection" height:18 width:16 align:#left offset:[10,-23]
				button SelObjBut "S" tooltip:"Select Object" height:18 width:12 align:#left offset:[28,-23]
				edittext ObjEdittxt "" text:"" align:#left height:18 width:188 offset:[38,-23]
			)
			
			on ObjPickbut picked obj do
			(
				gtComponent.mPickedObj = obj
				gtComponent.mfUpdateGui()
			)
			
			on ObjfromSelBut pressed do
			(
				if 0 == selection.count then
					 messagebox "Please Select an Object"
				else if 1 < selection.count then
					 messagebox "Please Select Only 1 Object"
				else if gtComponent.mfObjectsFilter $ do
					gtComponent.mPickedObj = $
				gtComponent.mfUpdateGui()
			)
			
			on SelObjBut pressed do
			(
				if undefined != gtComponent.mPickedObj do
				(
					if (IsValidNode gtComponent.mPickedObj) then
					(
						if gtComponent.mPickedObj.isfrozen or gtComponent.mPickedObj.ishidden then
							if querybox ("Object is Hidden or Frozen \nMake it selectable?") do
							(
								gtComponent.mPickedObj.isfrozen = false
								gtComponent.mPickedObj.ishidden = false
								select gtComponent.mPickedObj
							)
						else select gtComponent.mPickedObj
					)
					else
					(
						gtComponent.mPickedObj = undefined
						gtComponent.mfUpdateGui()
					)
				)
			)
			

		)
		
		try( DestroyDialog ComponentRoll )
		catch()
		CreateDialog ComponentRoll 300 130 style:#( #style_minimizebox, #style_titlebar, #style_sysmenu )
		
	)
)

gtComponent = tComponent()
gtComponent.mfCreateDialogWin()
