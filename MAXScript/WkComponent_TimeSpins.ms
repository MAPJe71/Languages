-- wkip ajouter un bouton get current range, et pouvoir bouger les 2 spinns en mm tmps
-- wkip attention: setcurrenttime explose le redraw
-- wkip attention: les 2 spinners peuvent avoir la meme valeur
-- wkip SetAnimationSpinnersVal ne mets pas les ranges parfaitement, en tenant compte de WKANIMLIMIT
-- mettre les valeurs par defaut au tone range

global WKANIMLIMIT = 2
global WkComponentRoll

try( DestroyDialog WkComponentRoll )
catch()

-------------------------------------------------------------------------------

global lmIntervTime = 1

fn SetAnimationSpinnersVal rStart rEnd =
(
	local lStartRange = [0,0,rStart]
	local lEndRange = [0,0,rEnd]
	
	if rStart > rEnd do
	(
		lStartRange[3] = rEnd
		lEndRange[3] = rStart
	)
	
	if WkComponentRoll.startframeSpin.range[1] > lStartRange[3] then
		 lStartRange[1] = lStartRange[3]
	else lStartRange[1] = WkComponentRoll.startframeSpin.range[1]
	
	if WkComponentRoll.startframeSpin.range[2] < lStartRange[3] then
		 lStartRange[2] = lStartRange[3]
	else lStartRange[2] = WkComponentRoll.startframeSpin.range[2]
	
	if WkComponentRoll.endframeSpin.range[1] > lEndRange[3] then
		 lEndRange[1] = lEndRange[3]
	else lEndRange[1] = WkComponentRoll.endframeSpin.range[1]
	
	if WkComponentRoll.endframeSpin.range[2] < lEndRange[3] then
		 lEndRange[2] = lEndRange[3]
	else lEndRange[2] = WkComponentRoll.endframeSpin.range[2]
	
	WkComponentRoll.startframeSpin.range = lStartRange
	WkComponentRoll.endframeSpin.range = lEndRange
)

rollout WkComponentRoll "WkComponentRoll"
(
	group "Animation"
	(
		label startframeLab "From:" align:#left offset:[-4,-2]
		spinner startframeSpin "" type:#integer range:[animationrange.start - WKANIMLIMIT*(animationrange.end - animationrange.start), animationrange.end, animationrange.start] align:#left width:48 offset:[24,-19]
		label endframeLab "To:" align:#left offset:[75,-20]
		spinner endframeSpin "" type:#integer range:[animationrange.start, animationrange.end + WKANIMLIMIT*(animationrange.end - animationrange.start), animationrange.end] align:#left width:48 offset:[94,-19]
		label intervframeLab "Every:" align:#left offset:[145,-20]
		spinner intervframeSpin "" type:#integer range:[1,5000,lmIntervTime] width:48 align:#left offset:[178,-19]
		label intervframefrLab "Frame" align:#left offset:[234,-19]
		button getTimeRangeBut "G" tooltip:"Get Current Time Range" width:18 height:17 align:#left offset:[270,-20]
		button setTimeRangeBut "S" tooltip:"Set Time Range To Defined Values" width:18 height:17 align:#left offset:[290,-22]
		label emptyintervLab "" offset:[-40,-14]
	)
	-- events
	
	on startframeSpin changed val do
		endframeSpin.range = [val, animationrange.end + WKANIMLIMIT*(animationrange.end - animationrange.start), endframeSpin.value]

	on endframeSpin changed val do
		startframeSpin.range = [animationrange.start - WKANIMLIMIT*(animationrange.end - animationrange.start), val, startframeSpin.value]

	on intervframeSpin changed stat do
		lmIntervTime = stat


	on getTimeRangeBut pressed do
	(
		startframeSpin.range = [animationrange.start - WKANIMLIMIT*(animationrange.end - animationrange.start), animationrange.end, animationrange.start]
		endframeSpin.range = [animationrange.start, animationrange.end + WKANIMLIMIT*(animationrange.end - animationrange.start), animationrange.end]
	)

	on setTimeRangeBut pressed do
	(
		if startframeSpin.value == endframeSpin.value then
			 animationRange = interval startframeSpin.value (endframeSpin.value + 1)
		else animationRange = interval startframeSpin.value endframeSpin.value
		
		startframeSpin.range = [animationrange.start - WKANIMLIMIT*(animationrange.end - animationrange.start), animationrange.end, animationrange.start]
		endframeSpin.range = [animationrange.start, animationrange.end + WKANIMLIMIT*(animationrange.end - animationrange.start), animationrange.end]
	)
)

-------------------------------------------------------------------------------

CreateDialog WkComponentRoll 350 130 style:#( #style_minimizebox, #style_titlebar, #style_sysmenu )