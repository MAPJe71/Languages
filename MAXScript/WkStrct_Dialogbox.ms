
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
	mDialogWindowPos = point2 250 300,					-- x, y

	-- rollouts	
	mDialogWin,

	fn mfInit =
	(
	
		-- wkip init file
		--gtComponent.pmfCreateDialogWin()
	),
	
	
	-------------------------------------------------------------------------------
	fn mfUpdateGui =
	(

	),
	
	-------------------------------------------------------------------------------
	
	fn pmfCreateDialogWin =
	(
		mDialogWin = rollout gComponentRoll "gComponentRoll"
		(
			
			on gComponentRoll open do
			(
				messagebox "Dialog open"
			)

			on gComponentRoll moved rNewPos do
			(
				messagebox "Dialog Moved"
				gtComponent.mDialogWindowPos = rNewPos
			)
			
			on gComponentRoll close do
			(
				messagebox "Dialog Closed"
				gtComponent.mDialogWindowPos = GetDialogPos gComponentRoll
			)
		)
	)
)

-------------------------------------------------------------------------------

gtComponent = tComponentRoll()
gtComponent.mfInit()
gtComponent.pmfCreateDialogWin()
gtComponent.mfUpdateGui()

-- #style_toolwindow
CreateDialog gComponentRoll 300 130 gtComponent.mDialogWindowPos.x gtComponent.mDialogWindowPos.y style:#( #style_minimizebox, #style_titlebar, #style_sysmenu )

