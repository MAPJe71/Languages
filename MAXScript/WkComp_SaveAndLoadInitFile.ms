
try( DestroyDialog gComponentRoll )
catch()

-------------------------------------------------------------------------------
(
global gComponentRoll
local gmSaveAsFileFullPathStr

rollout gComponentRoll "gComponentRoll"
(
	group "Save As..."
	(	
		button SaveBut "Save As..." tooltip:"Save As..." width:77 height:20 align:#left offset:[0,0]
		edittext SaveFileEditbx "" text:"" width:200 align:#left offset:[77,-24] enabled:false
		button SaveParamsbut "Save" tooltip:"Save Settings to File" height:18 width:67 align:#left offset:[0,4]
		button LoadParamsbut "Load" tooltip:"Load Presets from File" height:18 width:67 align:#right offset:[0,-23]

	)	
	
	on SaveBut pressed do
	(
		local lFileOutStr = getSavePath caption:"Save As..." initialDir:"$scripts"
--		local lFileOutStr = getSaveFileName caption:"Save As..." filename:SaveFileEditbx.text types:"Excel(*.xls)|*.xls|Excel(*.csv)|*.csv|Texte(*.txt)|*.txt|All|*.*|"
		format "lFileOutStr : %\n" lFileOutStr 

		if lFileOutStr != undefined then
		(
	--		if( InSeqExtEditbx.text != "" ) then
	--			 lFileOutStr = (substring lFileOutStr 1 (lFileOutStr.count - InSeqExtEditbx.text.count)) + InSeqExtEditbx.text
	--		else RenderSeqExtEditbx.text = getFilenameType lFileOutStr

			SaveFileEditbx.text = lFileOutStr--getFilenamePath lFileOutStr
			gmSaveAsFileFullPathStr = lFileOutStr
		--	bSaveInit = setINISetting GMINITFILE "Files" "Devis" lFileOutStr
		--	if not bSaveInit do messagebox "Le fichier .init ne peut être ouvert" title:"Echec"
		)
	)
	
	on gComponentRoll open do
	(
		if undefined != gmSaveAsFileFullPathStr do
			SaveFileEditbx.text = SaveFileEditbx
	)

)

-------------------------------------------------------------------------------

CreateDialog gComponentRoll 300 130 style:#( #style_minimizebox, #style_titlebar, #style_sysmenu )


)