/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***

	-- Template note:
	
	This script is a simple dialog window. It can be used as a standalone or as an extention of a script
	based on TemplateScript.ms	
		- C:/Users/[Username]/AppData/Local/Autodesk/3dsMax/[3ds Max Version]/ENU/Scripts/TemplateProject/TemplateScript/TemplateScript.ms

	
	
*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/


global gtTemplateSimpleDialog, gtTemplateSimpleDialogWin

struct tTemplateSimpleDialog
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
	

	mpDNET_ColorClass = dotNetClass "System.Drawing.Color",	-- equivalent to (dotNetClass "System.Drawing.Color") Eg: mpDNET_ColorClass.<colorName>
	mWarningOffset = 68,

	
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
	),
	
	fn mfConvertFloatColor2DotNetColor rFloatColor =
	(
		local lIntPoint3Color = ((rFloatColor * 255) as color) as Point3
		
	--	return (dotNetClass "System.Drawing.Color").FromARGB lIntPoint3Color.x lIntPoint3Color.y lIntPoint3Color.z		-- equivalent to next line
		return mpDNET_ColorClass.FromARGB lIntPoint3Color.x lIntPoint3Color.y lIntPoint3Color.z
	),

	fn mfUpdateGUI =
	(
	--	format "mfUpdateGUI\n"

		if "" == gtTemplateSimpleDialogWin.DevFolderEditbx.text or not DoesFileExist gtTemplateSimpleDialogWin.DevFolderEditbx.text then
			gtTemplateSimpleDialogWin.DNET_DevPathNotValidLab.pos.x = mWarningOffset
		else gtTemplateSimpleDialogWin.DNET_DevPathNotValidLab.pos.x = -200		
	),

	fn mfCreateDialog =
	(
		rollout gtTemplateSimpleDialogWin "Template Simple Dialog - Set Paths Dialog Example"
		(
			imgTag bannerImgtg bitmap:gBannerBitmap key:#bmp_center align:#center offset:[0,-6] 

		--	label TitleLab "gtTemplateScript Paths Configuration:" align:#left offset:[20,20] 
			groupBox mainGrpBx "Paths Configuration " width:622 height:230 align:#left offset:[-4,5]
			label emptyLab "emtpy" align:#left offset:[-100,-235] 
			
			dotNetControl DNET_DevPathLab "System.Windows.Forms.Label" text:"Dev Path:" width:60 align:#left offset:[20,20]
			label devFolderDescrLab "Path of the directory holding all the scripts projects" align:#left offset:[116,-19] 
			label devFolderEgLab "Eg: D:\\Code\\Maxscript\\ScriptsInDevelopment\\" align:#left offset:[116,-1] 
			button devFolderBut "..." tooltip:"Set the path of the Dev Directory" width:30 height:20 align:#left offset:[20,4]
			edittext devFolderEditbx text:"" width:540 align:#left offset:[50,-23] readOnly:true
			dotNetControl DNET_DevPathNotValidLab  "System.Windows.Forms.Label" width:180 text:"*** Invalid path ***" align:#left offset:[mWarningOffset,0]
			
			button okBut "OK" tooltip:"Apply settings and close the dialog window" height:22 width:60 align:#center offset:[-45,45] 
			button cancelBut "Cancel" tooltip:"Cancel changes and close the window" height:22 width:60 align:#center offset:[45,-26] 

			on DevFolderBut pressed do
			(
				local lDir = undefined
				if doesfileexist DevFolderEditbx.text do
					lDir = DevFolderEditbx.text
				lNewDir = getSavePath caption:"Set Working Path..." initialDir:lDir

				if lNewDir != undefined then
					DevFolderEditbx.text = lNewDir + "\\"
			
				mfUpdateGUI()
			)
			
			
			on OkBut pressed do 
			(
				if not doesFileExist gtTemplateScript.mINITFILE then
					messageBox ("gtTemplateScript Init File not found:\n\n    " + gtTemplateScript.mINITFILE + "\n\nSettings aborted") title:"gtTemplateScript Warning"
				else
				(
				--	setINISetting gtTemplateScript.mINITFILE "UserSettings_Paths" "ScriptsRootFullPath" devFolderEditbx.text
				)
				
				DestroyDialog gtTemplateSimpleDialogWin 
			) 
			on CancelBut pressed do 
			( 
				DestroyDialog gtTemplateSimpleDialogWin
				gtTemplateSimpleDialogWin = undefined
			) 
			
			on gtTemplateSimpleDialogWin open do
			(
			--	wkip
			--	DevFolderEditbx.text = ...
				
				-- pour que le bg soit transparent, il faut linker le label au parent (il n'est transparent que p/ parent)
			-- du coup c'est plus simple de réccupérer la couleur de bg
				local lBgColor = mfConvertFloatColor2DotNetColor (colorMan.getColor #Background)
				DNET_DevPathLab.BackColor = DNET_DevPathNotValidLab.BackColor = lBgColor
				
			-- fonts
				local lDNETcl_FontStyle = dotNetClass "System.Drawing.FontStyle"
				local mDNET_FontStyle = dotnet.combineenums lDNETcl_FontStyle.bold --lDNETcl_FontStyle.italic		-- Warning: retourne un dotNetObject, pas class!!
			--	local lDNET_BoldFont = dotNetObject "System.Drawing.Font" "Times New Roman" 12 mDNET_FontStyle
				local lDNET_BoldFont = dotNetObject "System.Drawing.Font" DNET_DevPathLab.font mDNET_FontStyle

				DNET_DevPathLab.Font = lDNET_BoldFont
				DNET_DevPathNotValidLab.Font = lDNET_BoldFont
				DNET_DevPathNotValidLab.ForeColor = (dotNetClass "System.Drawing.Color").Red
				
				gtTemplateSimpleDialog.mfUpdateGUI()		-- remember this dialog is modal
	
			--	format "gtTemplateSimpleDialogWin opened\n"
			)

			on gtTemplateSimpleDialogWin close do
			(
			--	format "gtTemplateSimpleDialogWin closed\n"
			)

		)
		
		CreateDialog gtTemplateSimpleDialogWin 640 375 style:#( #style_minimizebox, #style_titlebar, #style_sysmenu, #style_toolwindow ) --modal:true
	)
)

try( DestroyDialog gtTemplateSimpleDialogWin ) catch()
gtTemplateSimpleDialog = tTemplateSimpleDialog()
if gtTemplateSimpleDialog.mfInit() do
	gtTemplateSimpleDialog.mfCreateDialog()

