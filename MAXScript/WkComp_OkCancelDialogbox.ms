/*
-- Purpose:
  ---------
   Open an Ok Cancel dialog box

	
-- Notes:
  -------
	
	
*/

global gComponentRoll
global gbOKCalled

try( DestroyDialog gComponentRoll )
catch()

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------



fn OpenOkCancelDialog =
(
	try( DestroyDialog gComponentRoll )
	catch()

	rollout gComponentRoll "Ok Cancel"
	(
		label textLab "Add your components here:" align:#left offset:[3,0]

	--	button ApplyBut "Apply" tooltip:"Apply Settings" height:18 width:60 align:#left offset:[2,15]
		button OKBut "OK" tooltip:"Validate and close tool" height:18 width:60 align:#left offset:[76,0]
		button CancelBut "Cancel" tooltip:"Cancel" height:18 width:60 align:#left offset:[150,-23]


		on ApplyBut pressed do
		(
			with redraw off
			(
			--	do what you have to do
			)
		)
		
		on OKBut pressed do
		(
			with redraw off
			(
			--	do what you have to do
			)
			gbOKCalled = true
			DestroyDialog gComponentRoll
		)

		on CancelBut pressed do
		(
			gbOKCalled = false
			DestroyDialog gComponentRoll
		)

		on gComponentRoll close do
		(
			if true != gbOKCalled do
			(
				with redraw off
				(
				--	do what you have to do
				)
			)
		)	
	)
	

	CreateDialog gComponentRoll 240 130 style:#( #style_minimizebox, #style_titlebar, #style_sysmenu ) modal:false
	(
	--	do what you have to do
	)
)


OpenOkCancelDialog()
