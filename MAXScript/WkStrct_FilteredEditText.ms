
global gtComponent
global gComponentRoll
global gmComponentPos

try( DestroyDialog gComponentRoll )
catch()

-------------------------------------------------------------------------------
struct tComponentRoll
(						

	-- constants
	mpVERSION = 1.0,
	mpWINDWIDTH = 250,

	-- members
	mDialogWin,
	mDialogWindPosX = 100,
	mDialogWindPosY = 188,
	
	fn mfInit =
	(

		-- wkip init file
	--	gtComponent.pmfCreateDialogWin()
	),
	
	
	-------------------------------------------------------------------------------
	fn mfUpdateGui =
	(
	
	),
	
	-- autorize only numerical values in edit text components
	-- Use:
	--		on myComponentEdittxt changed text do gtComponent.mfCheckText text
	--		on myComponentEdittxt entered val do gtComponent.mfKeepValues()
	fn mfCheckText rText =
	(
		local lValidCharsStr = "-,.0123456789"
		local lNewTextStr = ""
		local lTmpInd
		local lbTextIsValid = true
		local lNumPtChar = 0
		
		for i=1 to rText.count do
		(
			lTmpInd = findString lValidCharsStr rText[i]
			if undefined != lTmpInd then
			(
				if "-" == rText[i] then
					if 1 == i then
						append lNewTextStr rText[i]
					else lbTextIsValid = false
				else if "." == rText[i] or "," == rText[i] then
				(
					lNumPtChar += 1
					if 1 != i and 1 == lNumPtChar then
						append lNewTextStr "."
					else lbTextIsValid = false
				)
				else
				(
					append lNewTextStr rText[i]
				--format "lNewTextStr : %, i: %\n" lNewTextStr i
				)
			)
			else lbTextIsValid = false
		)
		
--		format "mfCheckText lNewTextStr: %\n" lNewTextStr
		return lNewTextStr
	),
	
	fn mfKeepValues =
	(
		-- store your values here
	),
	
	-------------------------------------------------------------------------------
	
	fn pmfCreateDialogWin =
	(
		mDialogWin = rollout gComponentRoll "gComponentRoll"
		(
			edittext myComponentEdittxt "Enter numerical value invalid characters:" fieldwidth:80 align:#left offset:[0,0]
			
			on myComponentEdittxt changed text do
				myComponentEdittxt.text = gtComponent.mfCheckText text
			on myComponentEdittxt entered val do
				gtComponent.mfKeepValues()

						
			on gComponentRoll open do
			(
			--	messagebox "Dialog open"
			
			)
		)
	)
)

-------------------------------------------------------------------------------

gtComponent = tComponentRoll()
gtComponent.mfInit()
gtComponent.pmfCreateDialogWin()
gtComponent.mfUpdateGui()

CreateDialog gComponentRoll 300 130 style:#( #style_minimizebox, #style_titlebar, #style_sysmenu )

