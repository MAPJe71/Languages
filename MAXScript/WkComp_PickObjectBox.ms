
try( DestroyDialog ComponentRoll )
catch()

-------------------------------------------------------------------------------
(
local gmPickedObj = undefined

local GM_PICKEDOBJBUTWIDTH = 60

-- filter for geometry
fn object_filt pckobj =
(
--	if ((superclassof pckobj) == GeometryClass)
--	then return true
--	else return false
	
	return true
)


rollout ComponentRoll "ComponentRoll"
(
	pickbutton ObjPickbut "Object" message:"Pick an Object" tooltip:"Pick an Object" filter:object_filt height:18 width:GM_PICKEDOBJBUTWIDTH align:#left offset:[-8,0]
	button ObjfromSelBut "$" tooltip:"Get Object From Selection" height:18 width:10 align:#left offset:[GM_PICKEDOBJBUTWIDTH - 8 + 2,-23]
	button SelObjBut "S" tooltip:"Select Object" height:18 width:10 align:#left offset:[GM_PICKEDOBJBUTWIDTH - 8 + 12,-23]
	
	edittext ObjEdittxt "" text:"" align:#right height:18 width:188 offset:[8,-23]


	on ObjPickbut picked obj do
	(
		gmPickedObj = obj
		ObjEdittxt.text = obj.name
	)
	
	on ObjfromSelBut pressed do
	(
		if 0 == selection.count then
			 messagebox "Please Select an Object"
		else if 1 < selection.count then
			 messagebox "Please Select Only 1 Object"
		else if object_filt $ do
		(
			gmPickedObj = $
			ObjEdittxt.text = gmPickedObj.name
		)
	)
	
	on SelObjBut pressed do
	(
		if undefined != gmPickedObj do
		(
			if (IsValidNode gmPickedObj) then
			(
				if gmPickedObj.isfrozen or gmPickedObj.ishidden then
					if querybox ("Object is Hidden or Frozen \nMake it selectable?") do
					(
						gmPickedObj.isfrozen = false
						gmPickedObj.ishidden = false
						select gmPickedObj
					)
				else select gmPickedObj
			)
			else
			(
				messagebox "Deleted or Invalid Object"
				gmPickedObj = undefined
				ObjEdittxt.text = ""
			)
		)
	)
	

)

-------------------------------------------------------------------------------

CreateDialog ComponentRoll 300 130 style:#( #style_minimizebox, #style_titlebar, #style_sysmenu )

)