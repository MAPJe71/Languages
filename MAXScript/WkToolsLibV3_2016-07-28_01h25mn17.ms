/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***

	A WerwacK Script
	
	Contact: werwack@yahoo.com
	Website: www.werwackscripts.com
	
	Script Name:				MyScript
	3dsMax Supported Versions:	9.x and more

//---------------------------------------------------------------------------------------------------------//

-- Purpose:
-----------
   Library for usefull functions
   
	
-- Use:
-------
    
    Called with a filein:
    	lMyStdLibraryInstance = filein "WkstdLibV1.ms"
        
    Call any library function with:
        lMyStdLibraryInstance.mfFunction()
    
    Require Lost_StdLib_Vx.ms
    *** must call mfSetStdLib when WkToolsLib structure is instanced !! ***
    
-- Notes:
---------

	*** Important notes: ***
		- When modifiing a function, always set the modification date in its description

	Functions:
	
		- _Shape_
		- _Mesh_
		- _Material_
		- _Vertex Channels_
	
-- Known troubles:
------------------  



-- Version history:
-------------------

-- V3.1: (2016/07/23)
		- Added:
			- mfGetCenterOfMass
			- mfCenterObjectPivot

-- V3.0: (2009/07/03)
		- general update
		
-- V1: (2007/01/03)
		- basic version


*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/


--global wkgbVerbose = if undefined == wkgbVerbose then false else wkgbVerbose		-- can be toggled with WkMacroTool_OnOffVerboseToggle.mcr
--global wkgVerboseIndentStr = if undefined == wkgVerboseIndentStr then "" else wkgVerboseIndentStr


-------------------------------------------------------------------------------
-- When renaming this function, also rename all the "tWk_ToolsLibV2" in this file
struct tWkToolsLibV3
(						
	-- library
	-- must be set by a call to mfSetStdLib()
	mptStdLib = undefined,

	-- constants
	mVERSION = 3.0,										-- *** mandatory member ***
	
	------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	
			-- _DevTools_
	
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	
	-- _Shape_
	-- draw a line between the 2 points given as parameters
	fn mfDrawStrippedLine rPointsArr rbCloseShape:false =
	(
	--	format "mfDrawStrippedLine\n"
	--	format "    pointA: %, pointB: %\n" pointA pointB
		local lLine = undefined
		
		if 0 <= rPointsArr.count do
		(
			lLine = SplineShape pos:pointA
			addNewSpline lLine
			
			for lPoint in rPointsArr do
				addKnot lLine 1 #corner #line lPoint
			
			updateShape lLine

			if rbCloseShape do
				close lLine 1
				
			updateShape lLine
		--	lLine.DisplayRenderMesh =true
		--	lLine.UseViewportSettings = false
		--	lLine.DisplayRenderSettings = true
		--	lLine.renderable = true
		--	lLine.baseobject.renderable = true
			
		)
		
		return lLine
	),

	-- _Shape_
	-- draw a line between the 2 points given as parameters
	fn mfDrawLineBetweenTwoPoints pointA pointB =
	(
	--	format "mfDrawLineBetweenTwoPoints\n"
	--	format "    pointA: %, pointB: %\n" pointA pointB
		local lLine = SplineShape pos:pointA
		addNewSpline lLine
		addKnot lLine 1 #corner #line PointA
		addKnot lLine 1 #corner #line PointB
		
	--	lLine.DisplayRenderMesh =true
	--	lLine.UseViewportSettings = false
	--	lLine.DisplayRenderSettings = true
	--	lLine.renderable = true
	--	lLine.baseobject.renderable = true
		
		updateShape lLine
		
		return lLine
	),

	-- draw a line between the origine and point given as parameter
	fn mfDrawVector rVect rColor:blue =
	(
	--	format "mfDrawVector\n"
		local lLine = SplineShape pos:[0,0,0] wirecolor:rColor
		addNewSpline lLine
		addKnot lLine 1 #corner #line [0,0,0]
		addKnot lLine 1 #corner #line rVect
		
		
		updateShape lLine
		
		return lLine
	),

	-- draws and returns a tripod from rMatrix3
	-- a message is displayed in the listener if a vector is not normalized
	fn mfDrawTripodFromMatrix3 rMatrix3 rScale:1.0 =
	(
		format "mfDrawTripodFromMatrix3\n"
		local lEpsilon = 0.0001
		
		lX = mfDrawVector (rScale * rMatrix3.row1) rColor:red
		lY = mfDrawVector (rScale * rMatrix3.row2) rColor:green
		lZ = mfDrawVector (rScale * rMatrix3.row3) rColor:blue
		
		tripodGrp = group #(lX, lY, lZ) name:(uniquename "Tripod")
		tripodGrp.pivot = [0,0,0]
		
		if not isNul (rMatrix3.row1 - (normalize rMatrix3.row1)) do
			format "   Row 1 is not normalized!!\n"

		if not isNul (rMatrix3.row2 - (normalize rMatrix3.row2)) do
			format "   Row 2 is not normalized!!\n"

		if not isNul (rMatrix3.row3 - (normalize rMatrix3.row3)) do
			format "   Row 3 is not normalized!!\n"
		
		return tripodGrp
	),


	fn mfDrawBoudingBox rObj rCoordsys =
	(
		with undo on
		(
			local lMinPt, lMaxPt
			in coordsys rCoordsys
			(
				lMinPt = rObj.min
				lMaxPt = rObj.max
			)
			
			MinPt = point pos:lMinPt
			MaxPt = point pos:lMaxPt
		)	
	),
	
	
	------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	
			-- _Mesh_
	
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------

	-- return the group head of an object belonging to a group
	-- return undefined if the object is not part of a group or has no parent
	-- If rObj is already a group head it will not return itself, the function will
	-- look for the head of the group to which this group belongs to.
	fn mfGetGroupHeadInParents rObj =
	(
		local lGroupHead = undefined
		
		-- we try to find the group head in the parents hierarchy
		local lTmpObj = rObj
		
		-- if rObj is already a group head it will not return itself
		if isGroupHead lTmpObj do
			if undefined != lTmpObj.parent then
				lTmpObj = rObj.parent
			else return undefined
		
		while isGroupMember lTmpObj and undefined != lTmpObj.parent and undefined == lGroupHead do
			if isGroupHead lTmpObj then
				lGroupHead = lTmpObj
			else lTmpObj = lTmpObj.parent
		
		-- case where the group head has no parent
		if undefined == lGroupHead and isGroupHead lTmpObj do
			lGroupHead = lTmpObj
		
		return lGroupHead
	),
	
	fn mfGetCenterOfMass rObj =
	(
		local lCenterOfMassPos = point3 0 0 0
		
		local lNumVertices = polyop.getNumVerts rObj
		
		-- get pos of all vertices
		for i=1 to lNumVertices do
			lCenterOfMassPos = lCenterOfMassPos + polyop.getVert rObj i --node:
		
		lCenterOfMassPos = lCenterOfMassPos / lNumVertices
		
		return lCenterOfMassPos
	),
	
	-- useful to center the pivot on triangle objects
	fn mfCenterObjectPivot rObj =
	(
		local lNewPivotOrigin = mfGetCenterOfMass rObj
		--CenterPivot rObj
		rObj.pivot = lNewPivotOrigin
		--AlignToParent  rObj
		WorldAlignPivot rObj
	),
	
	-- attach all the specifed objects to a new one and if specified delete them afterwards
	-- The pivot of the new object will be world oriented
	fn mfCreateSingleObjectFromList rObjectsArr rbDeleteObjects rNewPivotPositon rNewName =
	(
		local lNewObj = editable_mesh name:(uniquename"EPoly") --create an empty EMesh
		convertTo lNewObj Editable_Poly --convert to Editable_Poly
		lNewObj.position = rNewPivotPositon
		lNewObj.name = rNewName
		
		-- filter objects and sort them to collapse children before parents
	--	lSortedObjectsArr = mptStdLib.mfSort
		
		
		if rbDeleteObjects then
			for i = 1 to lSortedObjectsArr.count do
				polyop.attach lNewObj lSortedObjectsArr[i]
		else
			for i = 1 to lSortedObjectsArr.count do
			(
				local lTmpObj = copy lSortedObjectsArr[i]
				polyop.attach lNewObj lTmpObj
			)
		
		return lNewObj
	),
	
	-- Create a mesh copy of the specified group 
	-- recursive if subgroups are contained in the specified group
	-- Whether the specified group is opened or not has no importance
	-- the collapsed object will receve the transform of the group head and its name plus "_Collapsed"
	-- if rbDeleteGroup then the group and all its members are deleted afterwards
	-- if a child is part of the group a copy of it will be added to the snapshot
	-- if a child is not part of the group then it and its children will not be part of the snapshot
	-- To improve:
	--		- time
	--		- merge materials
	fn mpfSnapshotGroupToSingleObjectRec rGroupMember rGroupHead &rpObjectsInTheGroupArr =
	(
	--	format "  mpfSnapshotGroupToSingleObjectRec rGroupMember:%\n" rGroupMember.name
		
		local lCurrentObjectSnapshot = undefined
		
		if GeometryClass == superclassof rGroupMember do
		(
			lCurrentObjectSnapshot = snapshot rGroupMember
			convertTo lCurrentObjectSnapshot Editable_Poly --convert to Editable_Poly
			lCurrentObjectSnapshot.parent = undefined
		)

		append rpObjectsInTheGroupArr rGroupMember
			
		for i=1 to rGroupMember.children.count do
		(
		--	format "  before call to rec, rGroupMember.children[i]: %\n" rGroupMember.children[i].name
			if rGroupHead == mfGetGroupHeadInParents rGroupMember.children[i] do
			(
			--	format "  before call to rec, rGroupMember.children[i]: %\n" rGroupMember.children[i].name
				local lSnapshotSubGroupObj = mpfSnapshotGroupToSingleObjectRec rGroupMember.children[i] rGroupMember &rpObjectsInTheGroupArr
				if undefined != lSnapshotSubGroupObj do
					if undefined == lCurrentObjectSnapshot then
						lCurrentObjectSnapshot = lSnapshotSubGroupObj
					else polyop.attach lCurrentObjectSnapshot lSnapshotSubGroupObj
			)
		)
		
		return lCurrentObjectSnapshot
	),
	
	fn mfSnapshotGroupToSingleObject rGroupHead rbDeleteGroup:false =
	(
		local lSnapshotObj = undefined
		
		if isGroupHead rGroupHead do
		(
			lSnapshotObj = editable_mesh name:(uniquename"EPoly") --create an empty EMesh
			convertTo lSnapshotObj Editable_Poly --convert to Editable_Poly
			lSnapshotObj.transform = rGroupHead.transform
			lSnapshotObj.name = uniquename (rGroupHead.name + "_Snapshot")
			
			local lObjectsInTheGroupArr = #()		-- objects of the group are collected in order to be deleted if rbDeleteGroup is true
			
			-- note: we suppose the group head is a dummy, not a mesh, so we don't attach it to lSnapshotObj 
			for i=1 to rGroupHead.children.count do
			(
				format "  before init call to rec, rGroupHead.children[i]: %\n" rGroupHead.children[i].name
				local lSnapshotSubGroupObj = mpfSnapshotGroupToSingleObjectRec rGroupHead.children[i] rGroupHead &lObjectsInTheGroupArr
				if undefined != lSnapshotSubGroupObj do
					polyop.attach lSnapshotObj lSnapshotSubGroupObj
			)
			
			if rbDeleteGroup do
				for obj in lObjectsInTheGroupArr do
					delete obj
		)
		
		return lSnapshotObj
	),
	
	------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	
			-- _Material_
	
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	
	-- *** must be called when WkToolsLib structure is instanced !! ***
	fn mfSetStdLib rStdLibInstance =
	(
		mptStdLib = rStdLibInstance
	),
	
	--mFormat
	--mDevFormat

	fn mfRecCollectAllSubMaterialsFromMat rMaterial x = 
	(
		if rMaterial.numsubs != 0 then
		(
			for i = 1 to rMaterial.numsubs do
			(
				if rMaterial[i] != undefined do
				(
					if iskindof rMaterial[i] material == true then 
					(
						if classof rMaterial[i] == SubAnim and superclassof rMaterial[i].object == material do
							if finditem x (rMaterial[i].object) == 0 then append x (rMaterial[i].object)

						if superclassof rMaterial[i] == material do
							if finditem x (rMaterial[i]) == 0 do append x (rMaterial[i])
					)
					mfRecCollectAllSubMaterialsFromMat rMaterial[i] x
				)
			)
		)
	),

	-- returns all the materials belonging to rMaterial AND rMaterial
	--calls mfRecCollectAllSubMaterialsFromMat
	fn mfCollectAllMaterialsFromMat rMaterial = 
	(
		local lResArr = #()
		local lSubMatsArr = #()
		
		append lResArr rMaterial
		mfRecCollectAllSubMaterialsFromMat rMaterial lSubMatsArr
		for i in lSubMatsArr do
			if finditem lResArr i == 0 do append lResArr i
		
	--	for i in lResArr do print i
		
		return lResArr
	),


	-------------------------------------------------------------------------------
	-- 
	fn mfForceMatsVisibility rbTurnVisible rMatType =
	(
		local lbMatEditorOpened = MatEditor.isOpen()
	--	if lbMatEditorOpened do
	--		MatEditor.Close()
		
		
		
		if not globalDxDisplayManager.isDXActive() then
			if "DirectX" == rMatType do
			(
				messagebox "DirectX is not your viewports current display engine" title:"Cannot display DirectX Materials"
				return false
			)
		else globalDxDisplayManager.ForceSoftware = false -- greyed out if false
		
		if "DirectX" == rMatType then
		(
		--	globalDxDisplayManager.ForceSoftware = false -- greyed out if false
	--		globalDxDisplayManager.ForceSoftware = false -- greyed out if false
     	--	globalDxDisplayManager.ForceSelected = true-- checked if true
     	)
     	else
     	(
     	--	globalDxDisplayManager.ForceSoftware = true -- greyed out if false
     	--	globalDxDisplayManager.ForceSelected = true-- checked if true
     	)
     
		for obj in selection where (isproperty obj "material" and undefined != obj.material) do
		with redraw off
		--try
		(
			local lMatsArr = mfCollectAllMaterialsFromMat obj.material
			local lObjStructInst = undefined
			
			if 0 < lMatsArr.count do
				if MatEditor.isOpen() do
					MatEditor.Close()
	
			if rbTurnVisible then
			(
				for lMat in lMatsArr do
				(
					lMat.showInViewport = false
					if isproperty lMat "DirectX_Manager" do
						lMat.DirectX_Manager.dxStdMat = off
					lMat.showInViewport = false
				)
				
				if "DirectX" == rMatType then
					for lMat in lMatsArr do
					(
	--					globalDxDisplayManager.isDxActive()
							format "DxMatName: % \n" lMat.name
						if isproperty lMat "DirectX_Manager" then
						(
							format "DxMatName: % %\n" lMat.name lMat.DirectX_Manager.enabled 
							
							lMat.showInViewport = true
							lMat.DirectX_Manager.dxStdMat = on
							lMat.showInViewport = true
						)
						--else 
					)
				else for lMat in lMatsArr do
					(
						lMat.showInViewport = true
						if isproperty lMat "DirectX_Manager" do
							lMat.DirectX_Manager.dxStdMat = off
						lMat.showInViewport = true
					)
					
			)
			else
			(
				for lMat in lMatsArr do
				(
					lMat.showInViewport = false
					if isproperty lMat "DirectX_Manager" do
						lMat.DirectX_Manager.dxStdMat = off
					lMat.showInViewport = false
				)
			)
		)
		--catch()
		
		if lbMatEditorOpened do
			MatEditor.Open()
		
		return true
	),


	
	------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	
			-- _Vertex Channels_
	
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	
	
	-- rObj can be on object or a modifier (??)
	-- returned value is an integer and can be:
	--	- "Vertex Color": 0, "Vertex Illumination": -1, "Vertex Alpha": -2, "Shaded": -3, "UV Channel 1": 1, "UV Channel 2": 2, "UV Channel 3": 3...
	fn mfGetCurrentVertexChannel rObj =
	(
		lObj = rObj
		lVChannelInd = -3
		if GeometryClass == classof lObj or GeometryClass == superclassof lObj do
		(
			if lObj.showVertexColors then
			(
				case lObj.vertexColorType of
				(
					#color: 		lVChannelInd = 0		-- color
					#illum: 		lVChannelInd = -1		-- illum
					#alpha: 		lVChannelInd = -2		-- alpha
					#map_channel:	lVChannelInd = lObj.vertexColorMapChannel
				)
			)
			else lVChannelInd = -3
		)
		
		return lVChannelInd
	),
	
	-- rObj can be on object or a modifier (??)
	-- rVextexChannelInd can be:
	--	- "Vertex Color": 0, "Vertex Illumination": -1, "Vertex Alpha": -2, "UV Channel 1": 1, "UV Channel 2": 2, "UV Channel 3": 3...
	fn mfHasVertexChannel rObj rVChannelInd =
	(
		lbHasVChannel = false
		lVChannelInd = rVChannelInd
		lObj = rObj.mesh
		
		/*
		if mptStdLib.mfIsMeshOrPoly rObj do
		(
			if Editable_Poly == classof rObj then
			(
				if not polyop.getMapSupport rObj lVChannelInd do
				(
					if "UV Channel 2" == rVertexChannelStr then
					(
						addmodifier rObj (Uvwmap mapChannel:2)
						collapseStack rObj
					)
					else if "UV Channel 3" == rVertexChannelStr do
					(
						addmodifier rObj (Uvwmap mapChannel:3)
						collapseStack rObj
					)
				)
				polyop.setMapSupport rObj lVChannelInd true
				polyop.defaultMapFaces rObj lVChannelInd
				for t = 1 to rObj.numverts do
		    		polyop.setMapVert rObj lVChannelInd t (rColor / 255.0)
		    	
		    	if ChannelInfo.isChecked() do ChannelInfo.update()
			)
			else if Editable_Mesh == classof rObj then
				(
					if not meshop.getMapSupport rObj lVChannelInd do
					(
						if "UV Channel 2" == rVertexChannelStr then
						(
							addmodifier rObj (Uvwmap mapChannel:2)
							collapseStack rObj
						)
						else if "UV Channel 3" == rVertexChannelStr do
						(
							addmodifier rObj (Uvwmap mapChannel:3)
							collapseStack rObj
						)
					)
					meshop.setMapSupport rObj lVChannelInd true
					meshop.defaultMapFaces rObj lVChannelInd
					for t = 1 to rObj.numverts do
			    		meshop.setMapVert rObj lVChannelInd t (rColor / 255.0)
			    	
			    	if ChannelInfo.isChecked() do ChannelInfo.update()
			    )
			)*/
		
		if (meshop.getMapSupport lObj lVChannelInd) and 0 != (meshop.getNumMapVerts lObj lVChannelInd) do
			lbHasVChannel = true
		
		return lbHasVChannel
	),
	
	-- because a standard object doesn t have vertex channel information for several common channels (vc, alpha..)
	-- the function can only work with editable meshes or poly
	--	- "Shaded": -3, "Vertex Color": 0, "Vertex Illumination": -1, "Vertex Alpha": -2, "UV Channel 1": 1, "UV Channel 2": 2, "UV Channel 3": 3...
	fn mfViewVertexChannel rObj rVChannelInd rDefaultColor: =
	(
		lbRes = false
		lDefaultColor = if unsupplied == rDefaultColor then color 0 250 0 else rDefaultColor
		lObj = rObj
		lVChannelInd = rVChannelInd
		
		-- show code - pb: show in white channels that does not exist
	/*	with redraw off
			--	for i=1 to selection.count do
					if GeometryClass == superclassof selection[i] do
					(
						selection[i].showVertexColors = true
						case vertexChannelTypeDrpdwn.selection of
						(
							2: 	selection[i].vertexColorType = 0		-- color
							3: 	selection[i].vertexColorType = 1		-- illum
							4: 	selection[i].vertexColorType = 2		-- alpha
							5: 	(
								selection[i].vertexColorType = 5		-- map 1
								selection[i].vertexColorMapChannel = 1
								)
							6: 	(
								selection[i].vertexColorType = 5		-- map 2
								selection[i].vertexColorMapChannel = 2
								)
							7: 	(
								selection[i].vertexColorType = 5		-- map 3
								selection[i].vertexColorMapChannel = 3
								)
							default: selection[i].showVertexColors = false		-- shaded
						)
					)
			--	completeRedraw()
		*/
		
		format "lObj: %, lVChannelInd: %\n" lObj.name lVChannelInd
	--	if mptStdLib.mfIsMeshOrPoly rObj do
		(
			if -3 == lVChannelInd then					-- Shaded
				lObj.showVertexColors = false
			else
			(
		/*		lVertexColorType = undefined
				lVChannelInd = undefined
			
				case rVertexChannelStr of
				(
					"Vertex Color":(
						 	lVertexColorType = 0		-- vcolor
						 	lVChannelInd = 0
							)
					"Vertex Illumination":(
						 	lVertexColorType = 1		-- villum
						 	lVChannelInd = -1
							)
					"Vertex Alpha":(
						 	lVertexColorType = 2		-- valpha
						 	lVChannelInd = -2
							)
					"UV Channel 1":(
							lVertexColorType = 5		-- MapChannel1
							lVChannelInd = 1
							)
					"UV Channel 2":(
							lVertexColorType = 5		-- MapChannel2
							lVChannelInd = 2
							)
					"UV Channel 3":(
							lVertexColorType = 5		-- MapChannel3
							lVChannelInd = 3
							)
				--	default: rObj.showVertexColors = false		-- shaded
				)

				lbSwitchChannel = true
				
				if Editable_Poly == classof rObj then
				(
					if (not polyop.getMapSupport rObj lVChannelInd) do
						if (lbSwitchChannel = querybox ("Object " + rObj.name + " has no channel for " + rVertexChannelStr + ",\nCreate one?")) do
						(
							if not polyop.getMapSupport rObj lVChannelInd do
							(
								if "UV Channel 2" == rVertexChannelStr then
								(
									addmodifier rObj (Uvwmap mapChannel:2)
									collapseStack rObj
								)
								else if "UV Channel 3" == rVertexChannelStr do
								(
									addmodifier rObj (Uvwmap mapChannel:3)
									collapseStack rObj
								)
							)

							polyop.setMapSupport rObj lVChannelInd true
							polyop.defaultMapFaces rObj lVChannelInd
							for t = 1 to rObj.numverts do
					    		polyop.setMapVert rObj lVChannelInd t (lDefaultColor / 255.0)
					    	
					    	if ChannelInfo.isChecked() do ChannelInfo.update()
					    )
				)
				else if Editable_Mesh == classof rObj then
					if (not meshop.getMapSupport rObj lVChannelInd) do
						if (lbSwitchChannel = querybox ("Object " + rObj.name + " has no channel for " + rVertexChannelStr + ",\nCreate one?")) do
						(
							if not meshop.getMapSupport rObj lVChannelInd do
							(
								if "UV Channel 2" == rVertexChannelStr then
								(
									addmodifier rObj (Uvwmap mapChannel:2)
									collapseStack rObj
								)
								else if "UV Channel 3" == rVertexChannelStr do
								(
									addmodifier rObj (Uvwmap mapChannel:3)
									collapseStack rObj
								)
							)
								
							meshop.setMapSupport rObj lVChannelInd true
							meshop.defaultMapFaces rObj lVChannelInd
							for t = 1 to rObj.numverts do
					    		meshop.setMapVert rObj lVChannelInd t (lDefaultColor / 255.0)
					    	
					    	if ChannelInfo.isChecked() do ChannelInfo.update()
					    )
			
				if lbSwitchChannel do
				(
					rObj.showVertexColors = true
					rObj.vertexColorType = lVertexColorType
					rObj.vertexColorMapChannel = lVChannelInd
					lbRes = true
				)*/
				
				lbSwitchChannel = false
				lVertexColorType = undefined
				lVChannelName = ""
				case lVChannelInd of
				(
					0:	(
					 		lVertexColorType = 0		-- vcolor
					 		lVChannelName = "Vertex Color"
						)
					(-1): (
							lVertexColorType = 1		-- villum
							lVChannelName = "Vertex Illumination"
						)
					(-2): (
							lVertexColorType = 2		-- valpha
							lVChannelName = "Vertex Alpha"
						)
					default: (
						 	lVertexColorType = 5		-- MapChannels
						 	lVChannelName = "UV Channel " + lVChannelInd as string
						)
				)
			
				if (not meshop.getMapSupport lObj.mesh lVChannelInd) then
				(
					format "not meshop\n"
					
					if (lbSwitchChannel = querybox ("Object " + lObj.name + " has no channel for " + lVChannelName + ",\nCreate one?")) do
					(
						if mptStdLib.mfIsMeshOrPoly lObj rbAskForConvertion:true do
						(
							lbSwitchChannel = true
				
							if Editable_Poly == classof lObj then
							(
								format "  Editable_Poly\n"
								if (not polyop.getMapSupport lObj lVChannelInd) do
								--	if (lbSwitchChannel = querybox ("Object " + lObj.name + " has no channel for " + rVertexChannelStr + ",\nCreate one?")) do
									(
										if not polyop.getMapSupport lObj lVChannelInd do
										(
											if 2 == lVChannelInd then		-- "UV Channel 2"
											(
												addmodifier lObj (Uvwmap mapChannel:lVChannelInd)
												collapseStack lObj
											)
											else if 3 == lVChannelInd do	-- "UV Channel 3"
											(
												addmodifier lObj (Uvwmap mapChannel:lVChannelInd)
												collapseStack lObj
											)
										)
			
										polyop.setMapSupport lObj lVChannelInd true
										polyop.defaultMapFaces lObj lVChannelInd
										for t = 1 to lObj.numverts do
								    		polyop.setMapVert lObj lVChannelInd t (lDefaultColor / 255.0)
								    	
								    	if ChannelInfo.isChecked() do ChannelInfo.update()
								    )
							)
							else if Editable_Mesh == classof lObj then
								if (not meshop.getMapSupport lObj lVChannelInd) do
								--	if (lbSwitchChannel = querybox ("Object " + lObj.name + " has no channel for " + rVertexChannelStr + ",\nCreate one?")) do
									(
										format "  Editable_Mesh\n"
										if not meshop.getMapSupport lObj lVChannelInd do
										(
											if 2 == lVChannelInd then		-- "UV Channel 2"
											(
												addmodifier lObj (Uvwmap mapChannel:lVChannelInd)
												collapseStack lObj
											)
											else if 3 == lVChannelInd do	-- "UV Channel 3"
											(
												addmodifier lObj (Uvwmap mapChannel:lVChannelInd)
												collapseStack lObj
											)
										)
											
										meshop.setMapSupport lObj lVChannelInd true
										meshop.defaultMapFaces lObj lVChannelInd
										for t = 1 to lObj.numverts do
								    		meshop.setMapVert lObj lVChannelInd t (lDefaultColor / 255.0)
								    	
								    	if ChannelInfo.isChecked() do ChannelInfo.update()
								    )
						
							if lbSwitchChannel do
							(
								format "  ok\n"
								
								lObj.showVertexColors = true
								lObj.vertexColorType = lVertexColorType
								lObj.vertexColorMapChannel = lVChannelInd
								lbRes = true
							)
						)
					)
				)
				else
				(
						format "meshop\n"
						/*	if not meshop.getMapSupport lObj.mesh lVChannelInd do
							(
								if 2 == lVChannelInd then			-- "UV Channel 2"
								(
									addmodifier lObj (Uvwmap mapChannel:2)
									collapseStack lObj
								)
								else if 3 == lVChannelInd do		-- "UV Channel 3"
								(
									addmodifier lObj (Uvwmap mapChannel:3)
									collapseStack lObj
								)
							)
						*/		
				/*			meshop.setMapSupport lObj.mesh lVChannelInd true
							meshop.defaultMapFaces lObj.mesh lVChannelInd
							for t = 1 to lObj.mesh.numverts do
					    		meshop.setMapVert lObj.mesh lVChannelInd t (lDefaultColor / 255.0)
					    	
					    	
					    	if ChannelInfo.isChecked() do ChannelInfo.update()
				*/
				--	if lbSwitchChannel do
					(
						lObj.showVertexColors = true
						lObj.vertexColorType = lVertexColorType
						lObj.vertexColorMapChannel = lVChannelInd
						lbRes = true
					)

				)
			)

		)
		
		return lbRes
	),

	-- because a standard object doesn t have vertex channel information for several common channels (vc, alpha..)
	-- the function can only work with editable meshes or poly
	-- rVertexChannelStr can be: "Shaded", "Vertex Color", "Vertex Illumination", "Vertex Alpha", "UV Channel 1", "UV Channel 2", "UV Channel 3"
	fn mfFillVertexChannelWithColor rObj rVChannelInd rColor =
	(
		lbRes = false
		lVChannelInd = rVChannelInd
		lObj = rObj
		
	--	if mptStdLib.mfIsMeshOrPoly lObj do
		(
			if -3 != lVChannelInd do
			(
				lVertexColorType = undefined
			--	lVChannelInd = undefined
			
				lVChannelName = ""
				case lVChannelInd of
				(
					0:	(
					 		lVertexColorType = 0		-- vcolor
					 		lVChannelName = "Vertex Color"
						)
					(-1): (
							lVertexColorType = 1		-- villum
							lVChannelName = "Vertex Illumination"
						)
					(-2): (
							lVertexColorType = 2		-- valpha
							lVChannelName = "Vertex Alpha"
						)
					default: (
						 	lVertexColorType = 5		-- MapChannels
						 	lVChannelName = "UV Channel " + lVChannelInd as string
						)
				)
				
				if (not meshop.getMapSupport lObj.mesh lVChannelInd) then
				(
					if (lbSwitchChannel = querybox ("Object " + lObj.name + " has no channel for " + lVChannelName + ",\nCreate one?")) do
					(
						if mptStdLib.mfIsMeshOrPoly lObj rbAskForConvertion:true do
						(
							lbSwitchChannel = true
							
							if Editable_Poly == classof lObj then
							(
								if not polyop.getMapSupport lObj lVChannelInd do
								(
									if 2 == lVChannelInd then		-- "UV Channel 2"
									(
										addmodifier lObj (Uvwmap mapChannel:lVChannelInd)
										collapseStack lObj
									)
									else if 3 == lVChannelInd do	-- "UV Channel 3"
									(
										addmodifier lObj (Uvwmap mapChannel:lVChannelInd)
										collapseStack lObj
									)
								)
								polyop.setMapSupport lObj lVChannelInd true
								polyop.defaultMapFaces lObj lVChannelInd
								for t = 1 to lObj.numverts do
						    		polyop.setMapVert lObj lVChannelInd t (rColor / 255.0)
						    	
						    	if ChannelInfo.isChecked() do ChannelInfo.update()
							)
							else if Editable_Mesh == classof lObj then
								(
									if not meshop.getMapSupport lObj lVChannelInd do
									(
										if 2 == lVChannelInd then		-- "UV Channel 2"
										(
											addmodifier lObj (Uvwmap mapChannel:lVChannelInd)
											collapseStack lObj
										)
										else if 3 == lVChannelInd do	-- "UV Channel 3"
										(
											addmodifier lObj (Uvwmap mapChannel:lVChannelInd)
											collapseStack lObj
										)
									)
									meshop.setMapSupport lObj lVChannelInd true
									meshop.defaultMapFaces lObj lVChannelInd
									for t = 1 to lObj.numverts do
							    		meshop.setMapVert lObj lVChannelInd t (rColor / 255.0)
							    	
							    	if ChannelInfo.isChecked() do ChannelInfo.update()
							    )
						
							if lbSwitchChannel do
							(
						--		lObj.showVertexColors = true
						--		lObj.vertexColorType = lVertexColorType
						--		lObj.vertexColorMapChannel = lVChannelInd
								lbRes = true
							)
						)
					)
				)
				else
				(
						
						/*	if not meshop.getMapSupport lObj.mesh lVChannelInd do
							(
								if 2 == lVChannelInd then			-- "UV Channel 2"
								(
									addmodifier lObj (Uvwmap mapChannel:2)
									collapseStack lObj
								)
								else if 3 == lVChannelInd do		-- "UV Channel 3"
								(
									addmodifier lObj (Uvwmap mapChannel:3)
									collapseStack lObj
								)
							)
						*/		
							meshop.setMapSupport lObj.mesh lVChannelInd true
							meshop.defaultMapFaces lObj.mesh lVChannelInd
							for t = 1 to lObj.mesh.numverts do
					    		meshop.setMapVert lObj.mesh lVChannelInd t (rColor / 255.0)
					    	
					    	
					    	if ChannelInfo.isChecked() do ChannelInfo.update()

				--	if lbSwitchChannel do
					(
					--	lObj.showVertexColors = true
					--	lObj.vertexColorType = lVertexColorType
					--	lObj.vertexColorMapChannel = lVChannelInd
						lbRes = true
					)

				)
			)

		)
		
	--	update rTargetObj??? to add?
		return lbRes
	)
	
	-- select the faces with ID rMaterialID in the world
	-- rNode can be poly or mesh, function returns false otherwise
/*	fn mfSelectFacesByMaterialID rNode rMaterialID =
	(
		lbRes = true
		
		max modify mode
	--	modPanel.setCurrentObject rNode
	--	setSelectionLevel rNode #face
		
		
		if Editable_Poly == classof rNode then
		(
			subobjectLevel = 4
			rNode.selectByMaterial mMaterialSubRollout.IDSpinn.value

		--	(rNode).selectByMaterialID mMaterialSubRollout.IDSpinn.value
		)
		else
		(
			--polyOp.setFaceSelection <Poly poly> <facelist>
			if PolyMeshObject == classof rNode then
			(
				lFacesToSelectBArr = #{}
		
				for i=1 to rNode.faces.count where rMaterialID == getFaceMatID rNode.mesh i do
					lFacesToSelectBArr[i] = true
				
				polyOp.setFaceSelection rNode lFacesToSelectBArr
				
			)
			else if Editable_mesh == classof rNode then
			(
				subobjectLevel = 3
				
			)
		)
		else lbRes = false
		
		return lbRes
	),*/
	
		

)
	
WkToolsLibV3 = tWkToolsLibV3()
format "WkToolsLib V. % loaded...   Instance: WkToolsLibV3\n" (WkToolsLibV3.mVersion)

-- *** THIS LINE MUST BE THE LAST LINE OF THE SCRIPT ***
-- otherwise the structure variable is not correctly returned when the script is loaded with fileIn()
WkToolsLibV3