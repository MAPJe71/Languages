
try( DestroyDialog gComponentRoll )
catch()

-------------------------------------------------------------------------------
(
global gComponentRoll
local gmSaveAsFileFullPathStr
local gmOpenFileFullPathStr


rollout gComponentRoll "gComponentRoll"
(
	group "Save As..."
	(	
		button SaveBut "Save As..." tooltip:"Set the path of the file to save" width:77 height:20 align:#left offset:[0,0]
		edittext SaveFileEditbx "" text:"" width:200 align:#left offset:[77,-24] readOnly:true
	)	
	
	on SaveBut pressed do
	(
		local lFileOutStr = getSaveFileName caption:"Save As..." filename:SaveFileEditbx.text types:"Excel(*.xls)|*.xls|Excel(*.csv)|*.csv|Texte(*.txt)|*.txt|All|*.*|"
	--	getSavePath caption:"Save path..." initialDir:(getFilenamePath SaveFileEditbx.text)

		if lFileOutStr != undefined then
		(
	--		if( InSeqExtEditbx.text != "" ) then
	--			 lFileOutStr = (substring lFileOutStr 1 (lFileOutStr.count - InSeqExtEditbx.text.count)) + InSeqExtEditbx.text
	--		else RenderSeqExtEditbx.text = getFilenameType lFileOutStr

			SaveFileEditbx.text = lFileOutStr	-- or getFilenamePath lFileOutStr
			SaveBut.tooltip = "Save file as: " + lFileOutStr
			gmSaveAsFileFullPathStr = lFileOutStr
			
	--		bSaveInit = setINISetting GMINITFILE "Files" "SavePath" lFileOutStr			-- save path in an init file
	--		if not bSaveInit do messagebox ".init file cannot be open" title:"Storing the save path failed"
		)
	)
	

	-------------------------------------------------------------------------------

	group "Open..."
	(	
		button OpenBut "..." tooltip:"Set the path of the file to open" width:16 height:20 align:#left offset:[0,0]
		edittext OpenFileEditbx "" text:"" width:260 align:#left offset:[17,-23] readOnly:true
	)	
	
	on OpenBut pressed do
	(
		local lFileOutStr = getOpenFileName caption:"Open..." filename:SaveFileEditbx.text types:"Excel(*.xls)|*.xls|Excel(*.csv)|*.csv|Texte(*.txt)|*.txt|All|*.*|"

		if lFileOutStr != undefined then
		(
	--		if( InSeqExtEditbx.text != "" ) then
	--			 lFileOutStr = (substring lFileOutStr 1 (lFileOutStr.count - InSeqExtEditbx.text.count)) + InSeqExtEditbx.text
	--		else RenderSeqExtEditbx.text = getFilenameType lFileOutStr

			OpenFileEditbx.text = lFileOutStr	-- or getFilenamePath lFileOutStr
			OpenBut.tooltip = "Open file: " + lFileOutStr
			gmOpenFileFullPathStr = lFileOutStr
			
	--		bOpenInit = setINISetting GMINITFILE "Files" "OpenPath" lFileOutStr			-- save path in an init file
	--		if not bSaveInit do messagebox ".init file cannot be open" title:"Storing the open path failed"
		)
	)
	

	-------------------------------------------------------------------------------

	on gComponentRoll open do
	(
		if undefined != gmSaveAsFileFullPathStr do
			SaveFileEditbx.text = gmSaveAsFileFullPathStr
		if undefined != gmOpenFileFullPathStr do
			OpenFileEditbx.text = gmOpenFileFullPathStr
	)
)

-------------------------------------------------------------------------------

CreateDialog gComponentRoll 300 130 style:#( #style_minimizebox, #style_titlebar, #style_sysmenu )


)