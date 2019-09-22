--------------------------------------------------------------------------------
-- MapName: Gareks Rache
--
-- Author: CarlaTheCat
--
function Briefing_ExtraWrapper( _v1, _v2 )
	for i = 1, 2 do
		local theButton = "CinematicMC_Button" .. i;
		XGUIEng.DisableButton( theButton, 1 );
		XGUIEng.DisableButton( theButton, 0 );
	end
	if _v1.action then
		assert( type(_v1.action) == "function" );
		if type(_v1.parameters) == "table" then 
			_v1.action(unpack2(_v1.parameters));
		else
				_v1.action(_v1.parameters);
		end
	end
	Briefing_ExtraOrig( _v1, _v2 );
end

Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function InitDiplomacy()
	SetHostile(1,3)
	SetHostile(3,1)
	SetHostile(1,4)
	SetHostile(4,1)
	SetHostile(1,5)
	SetHostile(5,1)
	SetHostile(1,6)
	SetHostile(6,1)
	SetHostile(1,7)
	SetHostile(7,1)
	SetHostile(1,8)
	SetHostile(8,1)
	SetNeutral(1,2)
	
end
function InitResources()
    AddGold  (99000)
    AddSulfur(99000)
    AddIron  (99000)
    AddWood  (99000)
    AddStone (99000)
    AddClay  (99000)
end
function InitTechnologies()
	ForbidTechnology(Technologies.GT_Mathematics, 1);
	ForbidTechnology(Technologies.T_ChangeWeather, 1);
	ForbidTechnology(Technologies.UP1_Tower, 1);
	ForbidTechnology(Technologies.GT_Metallurgy, 1);
end
function InitWeatherGfxSets()
	SetupNormalWeatherGfxSet()
end
function InitWeather()
	AddPeriodicSummer(10)
end
function InitPlayerColorMapping()
end
function FirstMapAction()
	MapEditor_SetupAI(4, 2, 3000, 2, "HQ_P4", 2, 1800)
	MapEditor_SetupAI(7, 2, 2000, 1, "HQ_P7", 1, 1800)
	CreatePreludeBriefing();
end
function CreatePreludeBriefing()
	PreludeBriefing = {}
	PreludeBriefing.finished = PreludeBriefingFinished
	page = 0
		page = page + 1
		PreludeBriefing[page] 				= 	{}
		PreludeBriefing[page].title			= 	"Kerberos"
		PreludeBriefing[page].text			=	"Lord Garek hat mich hier zurückgelassen, um zu verhindern, das ihr ihm sofort folgt!"
		PreludeBriefing[page].npc			=	{}
		PreludeBriefing[page].npc.id		=	GetEntityId("kerb")
		PreludeBriefing[page].npc.isObserved=	true
		PreludeBriefing[page].dialogCamera	=	true
		PreludeBriefingShowKerb				= 	PreludeBriefing[page]
		page = page + 1
		PreludeBriefing[page] 				= 	{}
		PreludeBriefing[page].title			= 	"Kerberos"
		PreludeBriefing[page].text			= 	"Aber ich werde mich mal zurückziehen. Alleine habe ich auch keine Chance gegen euch."
		PreludeBriefing[page].position 		= 	GetPosition("kerb")
		PreludeBriefing[page].dialogCamera	=	true
		PreludeBriefingShowKerb1 			=	PreludeBriefing[page]
		StartBriefing(PreludeBriefing)
end
function PreludeBriefingFinished()
	CreateRandomGoldChest(GetPosition("chestOne"))
	CreateRandomGoldChest(GetPosition("chestTwo"))
	CreateRandomGoldChest(GetPosition("chestThree"))
	CreateRandomGoldChest(GetPosition("chestFour"))
	CreateChestOpener("dario")
	StartChestQuest()
	ResolveBriefing(PreludeBriefingShowKerb)
	ResolveBriefing(PreludeBriefingShowKerb1)
	Move("kerb","kerbOne")
	Sound.PlayGUISound(Sounds.OnKlick_Select_kerberos, 0)
	Move("ari","ariEnd")
	StartSimpleJob("Kerb")
end
function Kerb()
	if IsNear("kerb","kerbOne",500) then
		DestroyEntity("kerb")
		BriefingAri()
		return true
	end
end
function BriefingAri()
    nbrief                         =   {}
    nbrief.finished                =   BriefingAriFinished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Ari"
    nbrief[page].text          =   "Dario! Hallo. @cr Ich komme grade von der zerstörten Brücke. Dort sind noch ein paar Freunde von mir zurückgeblieben. @cr Kundschafter haben herausgefunden, wo sich Lord Garek aufhält. @cr Sie sagen, sie möchten gern in Deine Dienste treten. Ich hoffe, sie kommen bald."
    nbrief[page].position      =   GetPosition("ariEnd")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Ari"
    nbrief[page].text          =   "Ich konnte westlich von hier mit ein paar Gehilfen Leonardos reden. Sie haben die Kundschafter losgeschickt. @cr Leonardo ist weg. Er ist seit gestern nicht mehr gesehen worden."
    nbrief[page].position      =   GetPosition("leoHilf")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Ari"
    nbrief[page].text          =   "Allerdings haben Banditen das Dorf der Erfinder auch ein wenig gerupft. @cr Sie sollen sich aber noch dort aufhalten. Die Gehilfen haben sich in den Ruinen versteckt. @cr wir sollten mal nachschauen, was da los ist."
    nbrief[page].position      =   GetPosition("ariEnd")
    nbrief[page].dialogCamera  =   true
		nbrief[page].quest			=	{}
		nbrief[page].quest.id		=	1
		nbrief[page].quest.type    =	MAINQUEST_OPEN
		nbrief[page].quest.title	=	"Specht mit Leonardos Gehilfen"
		nbrief[page].quest.text    =	"Leonardos Gehilfen möchten Euch helfen, Leonardo ausfindig zu machen. Sprecht mit Ihnen! @cr Die Kundschafter, die Leonardos Gehilfen losgeschickt haben, möchten Euch auch helfen. Sprecht auch mit Ihnen, sie haben nützliche Hinweise."
		nbriefGehilfe 			=	nbrief[page]
   	local Npc               =   {}
    Npc.name                =   "ari"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Dario." 
    CreateNPC(Npc) 
end
function BriefingAriFinished()
	AriBanditen()
	ChangePlayer("ari",1)
	Move("scout1","ariEnd")
end
function AriBanditen()
	local entity;
		entity = Entities.CU_BanditLeaderSword2; 
		Message("Wir werden Euch folgen.")
		defeatEntity = "HQ1"
		StartSimpleJob("DefeatJob1");
	for i = 1, 4 do 
		CreateMilitaryGroup(1,entity,8,GetPosition("brigdeOne"))
	end
	BanditenOne()
	return true
end
function BanditenOne()
	local entity;
		entity = Entities.CU_BanditLeaderSword2; 
	for i = 1, 3 do 
		CreateMilitaryGroup(7,entity,4,GetPosition("rob1"))
		CreateMilitaryGroup(7,entity,4,GetPosition("rob2"))
	end
	BriefingLeoHilf()
	return true
end
function BriefingLeoHilf()
    nbrief                         =   {}
    nbrief.finished                =   BriefingLeoHilfFinished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Ein Gehilfe"
    nbrief[page].text          =   "Ah, endliche Hilfe! Hallo, ich heisse Gismo. @cr Lord Garek war hier und hat fast unser ganzes Dorf zerstört. @cr Bloss eine Hütte und der Turm blieben stehen. @cr Und er hat Banditen hiergelassen, vor denen wir uns verstecken."
    nbrief[page].position      =   GetPosition("leoHilf")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gismo"
    nbrief[page].text          =   "Wir haben Kundschafter ausgesandt, sie sollen nach Leonardo fahnden, er ist uns abhanden gekommen. @cr Ihr könnt mal schauen, ob schon einer bei Eurer Burg angekommen ist. Wir haben ihnen gesagt, dass sie sich an Ari wenden sollen, wenn sie neues wissen."
    nbrief[page].position      =   GetPosition("ariEnd")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gismo"
    nbrief[page].text          =   " Bitte sucht die Banditen, und verhaut sie ein bisschen, damit sie uns in Ruhe lassen. @cr Als Dank lassen meine beiden Kollegen für Euch bäume wachsen, damit ihr in diesem trockenen Landstrich genug Holz roden könnt. @cr Wir könnten Euch auch noch mehr helfen, wenn ihr uns helft. @cr Lasst Euch überraschen."
    nbrief[page].position      =   GetPosition("leoHilf")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "leoHilf"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Dario." 
    CreateNPC(Npc)
end
function BriefingLeoHilfFinished()
	DarioIsNeargaertner1ID=StartSimpleJob("DarioIsNeargaertner1");
	Startgaertner2();
	CreateEntity(0, Entities.XD_ChestClose, GetPosition("kasten"), "kasten1")
	StartSimpleJob("Kasten")
	Move("leoHilf","leoEnd")
	CreatePlayerEight()
end
function Kasten()
	if IsNear("dario","kasten",500) then
		ReplaceEntity("kasten1",Entities.XD_ChestOpen)
		Sound.PlayGUISound( Sounds.fanfare, 0 ) 
		Sound.PlayGUISound(Sounds.VoicesMentor_CHEST_FoundTreasureChest_rnd_02, 0) 
		Message("Holla! Ihr habt Papiere gefunden. @cr Gehören sie etwa zu Leonardo?")
		BriefingLeoHilf1()
		return true
	end
end
function CreatePlayerEight()
	MapEditor_SetupAI(8, 1, 5000, 2, "player8", 1, 0)
	player8 	= {}
	player8.id 	= 8
    local description = {}
	description.serfLimit = 10
	SetupPlayerAi(player8.id,description)
	local aiID = 8;
	SetupPlayerAi( aiID, { extracting = 1 } );
	SetupPlayerAi( aiID, { repairing = 1 } );
	tBauDings = { { Entities.PB_DarkTower2, "P8DT1" }, { Entities.PB_DarkTower2, "P8DT2" }, { Entities.PB_DarkTower2, "P8DT3" }, { Entities.PB_DarkTower2, "P8DT4" }, { Entities.PB_DarkTower2, "P8DT5" }, { Entities.PB_DarkTower2, "P8DT6" }, { Entities.PB_DarkTower2, "P8DT7" },
	{ Entities.PB_Farm1, "P8F1" }, { Entities.PB_Farm1, "P8F2" }, { Entities.PB_Farm1, "P8F3" }, { Entities.PB_Farm1, "P8F4" }, { Entities.PB_Farm1, "P8F5" }, { Entities.PB_Farm1, "P8F6" }, { Entities.PB_Farm1, "P8F7" }, { Entities.PB_Farm1, "P8F8" }, { Entities.PB_Farm1, "P8F9" }, { Entities.PB_Farm1, "P8F10" }, { Entities.PB_Farm1, "P8F11" }, 
	{ Entities.PB_Residence1, "P8R1" }, { Entities.PB_Residence1, "P8R2" }, { Entities.PB_Residence1, "P8R3" }, { Entities.PB_Residence1, "P8R4" }, { Entities.PB_Residence1, "P8R5" }, { Entities.PB_Residence1, "P8R6" }, { Entities.PB_Residence1, "P8R7" }, { Entities.PB_Residence1, "P8R8" }, { Entities.PB_Residence1, "P8R9" }, { Entities.PB_Residence1, "P8R10" }, { Entities.PB_Residence1, "P8R11" }, { Entities.PB_Residence1, "P8R12" },
		{ Entities.PB_Sawmill1, "P8Sa" }, { Entities.PB_Brickworks1, "P8Bw" }, { Entities.PB_StoneMason1, "P8St" }, { Entities.PB_University1, "P8Un" }, { Entities.PB_Blacksmith1, "P8Bs" }, { Entities.PB_Archery1, "P8Ba" }, { Entities.PB_GunsmithWorkshop1, "P8Gs" }, { Entities.PB_Monastery1, "P8Mo" }}
	for i = 1, table.getn( tBauDings ) do 
		CreateEntityNormal( 8, tBauDings[i][1], GetPosition(tBauDings[i][2]) );
	end
	return true
end
function BriefingLeoHilf1()
    nbrief                         =   {}
    nbrief.finished                =   BriefingLeoHilf1Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gismo"
    nbrief[page].text          =   "Wow, Ihr seid es wirklich wert, das wir Euch helfen. @cr Ihr seid wohl in der Lage, Lord Garek in seine Schranken zu weisen."
    nbrief[page].position      =   GetPosition("leoHilf")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gismo"
    nbrief[page].text          =   "Bei den Papieren sind Unterlagen für Eure Gelehrten. @cr Ich bringe sie mal vorbei."
    nbrief[page].position      =   GetPosition("leoHilf")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "leoHilf"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Dario." 
    CreateNPC(Npc)
end
function BriefingLeoHilf1Finished()
	Move("leoHilf","dorfEnd");
	StartSimpleJob("LeoMathe");
	BriefingScout1();
end
function LeoMathe()
	if IsNear("leoHilf","dorfEnd",500) then
		AllowTechnology( Technologies.GT_Mathematics, 1 );
		Message("Eure Gelehrten sind nun in der Lage, den Brückenbau zu erforschen!");
		Move("leoHilf","leoEnd");
		return true
	end
end
function BriefingScout1()
    nbrief                         =   {}
    nbrief.finished                =   BriefingScout1Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Ihr seid Ari? Ihr seht sehr gut aus, ihr seid mir symphatisch. @cr Ich habe Kunde für Euch. Ein Kamerad von mir steht an der kaputten Brücke und kann nicht hierher. @cr Er hat mir zugerufen, das er etwas Neues von Leonardo weiss."
    nbrief[page].position      =   GetPosition("scout1")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Euer Freund ist in der Lage, Brücken bauen zu lassen? @cr Nagut, ich zeige Euch den Weg."
    nbrief[page].position      =   GetPosition("scout1")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "scout1"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc)
end
function BriefingScout1Finished()
	Move("scout1","brigdeOne")
	BriefingScout2()
end
function BriefingScout2()
    nbrief                         =   {}
    nbrief.finished                =   BriefingScout2Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Hallo. Ich warte hier ja schon lange auf Euch. @cr erec hat mich geschickt."
    nbrief[page].position      =   GetPosition("scout2")
    nbrief[page].dialogCamera  =   true
	page = page + 1
	nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Er hat eine der Maschinen gefunden. @cr Anscheinend können die hier in Ödland nichts damit anfangen."
    nbrief[page].position      =   GetPosition("erec")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Leonardo hat zwar einen seiner Gehilfen zurückgelassen, aber er selbst musste mit einer Karawane mitgehen. @cr es sah aber nicht so aus, als ob ihm das spass gemacht hat. @cr Aber ein paar von seinen Begleitern sind noch hier in der Nähe. Sie konnten gegen Lord garek nichts ausrichten und haben sich versteckt."
    nbrief[page].position      =   GetPosition("scout2")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "scout2"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingScout2Finished()
	ChangePlayer("scout1",1)
	ChangePlayer("scout2",1)
	Move("scout2","steam1")
	BanditenTwo()
	CreatePlayerSix()
	BriefingErec()
	ArmyOne()
end
function ArmyOne()
	armyOne		   = {}
	armyOne.player	= 1
	armyOne.id		= 1
	armyOne.strength  = 8
	armyOne.position   = GetPosition("armyOne")
	SetupArmy(armyOne)
		local troopDescription1 = {}
		troopDescription1.maxNumberOfSoldiers = 8
		troopDescription1.minNumberOfSoldiers = 0
		troopDescription1.experiencePoints = VERYHIGH_EXPERIENCE
		troopDescription1.leaderType = Entities.PU_LeaderSword2 
		local troopDescription2 = {}
		troopDescription2.maxNumberOfSoldiers = 8
		troopDescription2.minNumberOfSoldiers = 0
		troopDescription2.experiencePoints = VERYHIGH_EXPERIENCE
		troopDescription2.leaderType = Entities.PU_LeaderBow2 
 	for i = 1,8,1 do
		EnlargeArmy(armyOne,troopDescription1)
	end
	for i = 1,8,1 do
		EnlargeArmy(armyOne,troopDescription2)
	end
end
function BanditenTwo()
	local entity;
		entity = Entities.CU_BanditLeaderSword2; 
	for i = 1, 3 do 
		CreateMilitaryGroup(7,entity,5,GetPosition("rob3"))
		CreateMilitaryGroup(7,entity,5,GetPosition("rob4"))
		CreateMilitaryGroup(7,entity,5,GetPosition("rob5"))
	end
	return true
end
function CreatePlayerSix()
	MapEditor_SetupAI(6, 2, 5000, 2, "player6", 2, 1800)
	player6 	= {}
	player6.id 	= 6
    local description = {}
	description.serfLimit = 10
	SetupPlayerAi(player6.id,description)
	local aiID = 6;
	SetupPlayerAi( aiID, { extracting = 1 } );
	SetupPlayerAi( aiID, { repairing = 1 } );
	tBauDings = { { Entities.PB_DarkTower2, "P6DT1" }, { Entities.PB_DarkTower2, "P6DT2" }, { Entities.PB_DarkTower2, "P6DT3" }, { Entities.PB_DarkTower2, "P6DT4" }, { Entities.PB_DarkTower2, "P6DT5" }, { Entities.PB_DarkTower2, "P6DT6" }, { Entities.PB_DarkTower2, "P6DT7" }, { Entities.PB_DarkTower2, "P6DT8" }, { Entities.PB_DarkTower2, "P6DT9" }, { Entities.PB_DarkTower2, "P6DT10" }, { Entities.PB_DarkTower2, "P6DT11" }, { Entities.PB_DarkTower2, "P6DT12" }, { Entities.PB_DarkTower2, "P6DT13" }, { Entities.PB_DarkTower2, "P6DT14" }, { Entities.PB_DarkTower2, "P6DT15" }, { Entities.PB_DarkTower2, "P6DT16" }, { Entities.PB_DarkTower2, "P6DT17" }, { Entities.PB_DarkTower2, "P6DT18" }, { Entities.PB_DarkTower2, "P6DT19" }, { Entities.PB_DarkTower2, "P6DT20" }, { Entities.PB_DarkTower2, "P6DT21" }, { Entities.PB_DarkTower2, "P6DT22" },
	{ Entities.PB_Farm1, "P6F1" }, { Entities.PB_Farm1, "P6F2" }, { Entities.PB_Farm1, "P6F3" }, { Entities.PB_Farm1, "P6F4" }, { Entities.PB_Farm1, "P6F5" }, { Entities.PB_Farm1, "P6F6" }, { Entities.PB_Farm1, "P6F7" }, { Entities.PB_Farm1, "P6F8" }, { Entities.PB_Farm1, "P6F9" }, { Entities.PB_Farm1, "P6F10" }, { Entities.PB_Farm1, "P6F11" }, 
	{ Entities.PB_Residence1, "P6R1" }, { Entities.PB_Residence1, "P6R2" }, { Entities.PB_Residence1, "P6R3" }, { Entities.PB_Residence1, "P6R4" }, { Entities.PB_Residence1, "P6R5" }, { Entities.PB_Residence1, "P6R6" }, { Entities.PB_Residence1, "P6R7" }, { Entities.PB_Residence1, "P6R8" }, { Entities.PB_Residence1, "P6R9" }, { Entities.PB_Residence1, "P6R10" }, { Entities.PB_Residence1, "P6R11" }, { Entities.PB_Residence1, "P6R12" },
		{ Entities.PB_VillageCenter2, "village6" }, { Entities.PB_Sawmill1, "P6Sa" }, { Entities.PB_Brickworks1, "P6Bw" }, { Entities.PB_StoneMason1, "P6St" }, { Entities.PB_University1, "P6Un" }, { Entities.PB_Blacksmith1, "P6Bs" }, { Entities.PB_Archery1, "P6Ar" }, { Entities.PB_Barracks1, "P6Ba" }, { Entities.PB_GunsmithWorkshop1, "P6Gs" }, { Entities.PB_Monastery1, "P6Mo" }, { Entities.PB_Alchemist1, "P6Al" }, { Entities.PB_Market1, "P6Ma" }}
	for i = 1, table.getn( tBauDings ) do 
		CreateEntityNormal( 6, tBauDings[i][1], GetPosition(tBauDings[i][2]) );
	end 
	return true
end
function BriefingErec()
    nbrief                         =   {}
    nbrief.finished                =   BriefingErecFinished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Erec"
    nbrief[page].text          =   "Dario! Ich bin Lord Garek bis hierher gefolgt. Er hat hier Pause gemacht und dort hinten eine der Maschinen von Leonardo deponiert. @cr Er hat auch ein paar Banditen dort hinbeordert. @cr Deswegen habe ich auf dich gewartet, das wird mir alleine zuviel."
    nbrief[page].position      =   GetPosition("erec")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Erec"
    nbrief[page].text          =   "Ich habe einen auch Scout getroffen, der unbedingt mit Ari sprechen will. Er muss in der nähe der Brücke dort hinten stehen."
    nbrief[page].position      =   GetPosition("brigde1")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Erec"
    nbrief[page].text          =   "Hast Du eine Ahnung, was hier schon wieder los ist? @cr Lord Garek sieht missmutig aus, Leonardo sah nicht sehr glücklich aus. @cr Und die Leute hier aus dem Dorf spielen verrückt, weil sie mit der Maschine nichts anfangen können."
    nbrief[page].position      =   GetPosition("erec")
    nbrief[page].dialogCamera  =   true
		nbrief[page].quest			=	{}
		nbrief[page].quest.id		=	2
		nbrief[page].quest.type    =	MAINQUEST_OPEN
		nbrief[page].quest.title	=	("Sucht Leonardos Maschinen")
		nbrief[page].quest.text    =	("Lord Garek zwingt Leonardo, die Maschinen umzubauen. Was hat er vor? Bestimmt nicht Gutes! @cr Sucht Leonardo und vernichtet die Maschinen, die ihr auf eurem Weg findet.")
		nbriefMaschine 			=	nbrief[page]
   	local Npc               =   {}
    Npc.name                =   "erec"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Dario." 
    CreateNPC(Npc) 
end
function BriefingErecFinished()
	ResolveBriefing(nbriefGehilfe)
	ChangePlayer("erec",1)
	BriefingScout3()
end
function BriefingScout3()
    nbrief                         =   {}
    nbrief.finished                =   BriefingScout3Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Hi. Wow, ihr seid ari? Ein himmlischer anblick für einen, der lange unterwegs war."
    nbrief[page].position      =   GetPosition("scout3")
    nbrief[page].dialogCamera  =   true
	page = page + 1
	nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Aber...? ich komme hier nicht weiter. Und meine Kumpels sind dort drüben. @cr Irgendjemand hat hier die Brücke gesprengt. Kann Euer Freund nicht eine neue bauen? @cr ich will nicht hoffen, das alle brücken kaputt sind."
    nbrief[page].position      =   GetPosition("scout3")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Ich habe ja Lord Garek deswegen in Verdacht, ich habe ihn belauscht, und gehört, das er sich mit den Schwestern verbünden will. @cr mit den Schwestern!!!! @cr Die sind an Gemeinheiten nicht zu überbieten. @cr Achja, hat Euer Freund schon mit Leonardos Gehilfen an der maschine gesprochen?"
    nbrief[page].position      =   GetPosition("leoHilf1")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "scout3"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingScout3Finished()
	ChangePlayer("scout3",1)
	BriefingLeoHilf2()
	BriefingScout4()
end
function BriefingLeoHilf2()
    nbrief                         =   {}
    nbrief.finished                =   BriefingLeoHilf2Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Hallo, Ihr habt mich vorhin in dem Stress bestimmt übersehen. @cr Aber ich konnte dann wenigstens beobachten, wie ihr kämpft. Nun, Gismo sagte, wenn ich jemanden treffe, der kämpfen kann und uns helfen kann, dem soll ich auch helfen."
    nbrief[page].position      =   GetPosition("leoHilf1")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Ich bin für die Abteilung Kanonen zuständig. Ich werde Euch helfen. @cr Ich gehe in euer dorf und unterrichte eure Gelehrten."
    nbrief[page].position      =   GetPosition("leoHilf1")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "leoHilf1"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Dario." 
    CreateNPC(Npc) 
end
function BriefingLeoHilf2Finished()
	Move("leoHilf1","dorfEnd");
	StartSimpleJob("LeoCan")
end
function LeoCan()
	if IsNear("leoHilf1","dorfEnd",500) then
		AllowTechnology( Technologies.GT_Metallurgy, 1 );
		Message ("Ihr könnt jetzt endlich auch Kanonen bauen.");
		Move("leoHilf1","leoEnd");
		return true
	end
end
function BriefingScout4()
    nbrief                         =   {}
    nbrief.finished                =   BriefingScout4Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Hallo, ihr seid Ari. Hübsch. Nett. Wowww."
    nbrief[page].position      =   GetPosition("scout4")
    nbrief[page].dialogCamera  =   true
	page = page + 1
	nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Aber ich komme ins schwärmen, tschuldigung. @cr Pilgrim sagte, ich solle hier auf euch warten. Er ist Lord Garek soweit wie möglich gefolgt und erwartet euch."
    nbrief[page].position      =   GetPosition("pilgrim")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "wir haben Lord garek verfolgt und wollten herausfinden, was er mit leonardo vorhat. Leonardo sieht nicht glücklich aus. Er muss dauernd an irgendwelchen Maschinen rumbasteln. @cr Aber mit eurer Hilfe wird es möglich sein, ihm zu helfen."
    nbrief[page].position      =   GetPosition("scout4")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "scout4"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingScout4Finished()
	ChangePlayer("scout4",1)
	BriefingPilgrim()
end
function BriefingPilgrim()
    nbrief                         =   {}
    nbrief.finished                =   BriefingPilgrimFinished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Pilgrim"
    nbrief[page].text          =   "Dario, endlich. Ich steh mir hier schon die Beine in den Bauch. Wo bleibst du denn???"
    nbrief[page].position      =   GetPosition("pilgrim")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Pilgrim"
    nbrief[page].text          =   "Irgendwie sind mir meine Scouts verloren gegangen. Einen habe ich zurückgeschickt, um dich zu unterrichten, einer folgt Lord Garek. @cr hoffentlich haben die den nicht erwischt. @cr Aber, nun denn. Wir haben hier ein Problem!"
    nbrief[page].position      =   GetPosition("scout5")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Pilgrim"
    nbrief[page].text          =   "Oben in den Bergen steht ein Gehilfe von Leonardo. Er wird gezwungen, die Wasserqualität zu überwachen. @cr Die machen hier ein Teufelszeug draus, um die Dörfer in der Umgebung zu übernehmen. Die wollen die Bewohner einschläfern und dann in irgendein Ödland verfrachten, um dann die Dörfer und deren Rohstoffe zu übernehmen."
    nbrief[page].position      =   GetPosition("leoHilf2")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Pilgrim"
    nbrief[page].text          =   "Ich weiss sogar schon, wo die Teufelsmaschine steht, aber ... ??? @cr Die haben hier Fallen aufgestellt. Die schlagen mich hier mit meinen eigenen Waffen. Aber schau dir das selbst an. Komm mal mit, ich zeig dir das elend."
    nbrief[page].position      =   GetPosition("pilgrim")
    nbrief[page].dialogCamera  =   true
		nbrief[page].quest			=	{}
		nbrief[page].quest.id		=	3
		nbrief[page].quest.type    =	MAINQUEST_OPEN
		nbrief[page].quest.title	=	"Die Quelle wird missbraucht"
		nbrief[page].quest.text    =	"Eine von Leonardos Maschinen verwandelt das Wasser der Mineralquelle in den Bergen zu einem Sud, der Unglück über das Land bringt. @cr Sprecht mit Leonardos Gehilfen, der die Quelle überwacht. Vielleicht kann er die Maschine wieder umbauen. @cr Aber achtet darauf, die Maschine nicht zu zerstören. Sie wird gut bewacht!"
		nbriefWasser 			=	nbrief[page]
   	local Npc               =   {}
    Npc.name                =   "pilgrim"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Dario." 
    CreateNPC(Npc) 
end
function BriefingPilgrimFinished()
	ResolveBriefing(nbriefMaschine)
	defeatEntity = "steam2"
	BriefingLeoHilf3()
	Move("pilgrim","pilBomb1")
	StartSimpleJob("PilOne")
end
function PilOne()
	if IsNear("pilgrim","pilBomb1",500) then
		PilBombe( "pilgrim", 8, 300 )
		BriefingPilgrim1()
		return true
	end
end
function PilBombe( _pos, _bombs, _radius )
	local pilgrimPos = GetPosition( "pilgrim" );
	for i = 1, _bombs do
		local bombPos = {};
		bombPos.X = pilgrimPos.X + GetRandom( _radius * 2 ) - _radius;
		bombPos.Y = pilgrimPos.Y + GetRandom( _radius * 2 ) - _radius;
		CreateEntity( 6, Entities.XD_Bomb1 , bombPos, "bombe" )
	end
	return true
end
function BriefingPilgrim1()
    nbrief                         =   {}
    nbrief.finished                =   BriefingPilgrim1Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Pilgrim"
    nbrief[page].text          =   "Verstehst du, was ich meine???"
    nbrief[page].position      =   GetPosition("pilBomb1")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Pilgrim"
    nbrief[page].text          =   "Und hier liegen noch mehr von den Dingern! komm mal mit, lass uns das mal anschauen."
    nbrief[page].position      =   GetPosition("pilBomb2")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Pilgrim"
    nbrief[page].text          =   "Hast Du eine Idee, wie wir das Problem lösen? Nein??? @cr Also werde ich mich wohl opfern müssen. Aber ...?????? @cr dorthinten steht mein Freund Varg, bitte ihn, mich zu verbinden, falls die bomben mir weh tun."
    nbrief[page].position      =   GetPosition("varg")
	nbrief[page].explore	= 2000
	nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Pilgrim"
    nbrief[page].text          =   "Nur die Maschine kann uns helfen, die Schwestern zu bezwingen."
    nbrief[page].position      =   GetPosition("pilBomb1")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "pilgrim"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Dario." 
    CreateNPC(Npc) 
end
function BriefingPilgrim1Finished()
	BriefingVarg()
	Move("pilgrim","pilBomb2")
	StartSimpleJob("PilTwo")	
end
function BriefingVarg()
    nbrief                         =   {}
    nbrief.finished                =   BriefingVargFinished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Varg"
    nbrief[page].text          =   "Hallo, ihr seid dario? mein freund pilgrim hat mir von dir berichtet. @cr Er sagte, ich solle auf hier auf dich warten, du wirst mich schon finden. @cr leider geht durch dieses tor gar nix, aber pilgrim weiss sicherlich weiter, er hat kundschafter über all verteilt."
    nbrief[page].position      =   GetPosition("varg")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Dario"
    nbrief[page].text          =   "Pilgrim ist in gefahr, und er sagte mir, das nur du ihm helfen kannst. @cr ich möchte dich bitten, ihm zu helfen."
    nbrief[page].position      =   GetPosition("varg")
	nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Varg"
    nbrief[page].text          =   "Nun denn, kommt, lasst uns gehen und schauen, wie es ihm geht."
    nbrief[page].position      =   GetPosition("varg")
	nbrief[page].dialogCamera  =   true
		
   	local Npc               =   {}
    Npc.name                =   "varg"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Dario!" 
    CreateNPC(Npc) 
end
function BriefingVargFinished()
	ChangePlayer("varg",1)
end
function BriefingPilgrim2()
    nbrief                         =   {}
    nbrief.finished                =   BriefingPilgrim2Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Pilgrim"
    nbrief[page].text          =   "So langsam macht das keinen Spass mehr. @cr Ist aber wahrscheinlich die einzigste Methode, wie wir die Minen wegkriegen."
    nbrief[page].position      =   GetPosition("pilBomb2")
    nbrief[page].dialogCamera  =   true
	nbriefShowBomb 			=	nbrief[page]
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Pilgrim"
    nbrief[page].text          =   "Aber irgendwie müssen wir ja an die Felsen rankommen! @cr Also werde ich mich wohl opfern müssen."
    nbrief[page].position      =   GetPosition("pilBomb9")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
	nbriefShowBomb1 			=	nbrief[page]
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Pilgrim"
    nbrief[page].text          =   "Umsorgt mich gut! @cr Und haltet genug Abstand, sonst ist keiner da, der mir wieder aufhelfen kann."
    nbrief[page].position      =   GetPosition("pilBomb2")
	nbrief[page].dialogCamera  =   true
	nbriefShowBomb2 			=	nbrief[page]
	
   	local Npc               =   {}
    Npc.name                =   "pilgrim"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "varg"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit dem, der mit den Wölfen tanzt!" 
    CreateNPC(Npc) 
end
function BriefingPilgrim2Finished()
	ChangePlayer("pilgrim",1)
	ResolveBriefing(nbriefShowBomb)
	ResolveBriefing(nbriefShowBomb1)
	ResolveBriefing(nbriefShowBomb2)
	StartSimpleJob("PilThree")
	StartSimpleJob("PilFour")
	StartSimpleJob("PilFive")
	StartSimpleJob("PilSix")
	StartSimpleJob("PilSeven")
	StartSimpleJob("PilEight")
end
function PilTwo()
	if IsNear("pilgrim","pilBomb2",500) then
		PilBombe( "pilgrim", 10, 500 )
		BriefingPilgrim2()
		return true
	end
end
function PilThree()
	if IsNear("pilgrim","pilBomb3",500) then
		PilBombe( "pilgrim", 15, 1000 )
		return true
	end
end
function PilFour()
	if IsNear("pilgrim","pilBomb4",500) then
		PilBombe( "pilgrim", 15, 1000 )
		return true
	end
end
function PilFive()
	if IsNear("pilgrim","pilBomb5",500) then
		PilBombe( "pilgrim", 20, 1500 )
		return true
	end
end
function PilSix()
	if IsNear("pilgrim","pilBomb6",500) then
		PilBombe( "pilgrim", 25, 2000 )
		return true
	end
end
function PilSeven()
	if IsNear("pilgrim","pilBomb7",500) then
		PilBombe( "pilgrim", 30, 2000 )
		return true
	end
end
function PilEight()
	if IsNear("pilgrim","pilBomb8",500) then
		PilBombe( "pilgrim", 40, 2500 )
		return true
	end
end
function BriefingLeoHilf3()
    nbrief                         =   {}
    nbrief.finished                =   BriefingLeoHilf3Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Hi, seid ihr hier, um mich wieder zu quälen? @cr Aber ihr seht eigentlich recht freundlich und nicht so aus, als das ihr mir was böses wollt. @cr Ich muss hier für das Wasser wasser kontrollieren, es wird von Leonardos maschine in schlafpulver verwandelt."
    nbrief[page].position      =   GetPosition("leoHilf2")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Die haben Leonardo gezwungen, die maschine umzubauen. Sie ist gut versteckt und wird gut bewacht. @cr Leider komme ich an die Maschine nicht dran, sonst würde ich sie wieder umbauen. Die Felsen kann ich nicht überwinden. @cr könnt ihr mir helfen?"
    nbrief[page].position      =   GetPosition("steam2")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "kommt mal mit, ich zeige euch den weg. Wenn ich an die Maschine komme, dann kann ich euch auch helfen."
    nbrief[page].position      =   GetPosition("leoHilf2")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "leoHilf2"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Dario." 
    CreateNPC(Npc) 
end
function BriefingLeoHilf3Finished()
	Move("leoHilf2","pilBomb9");
	StartSimpleJob("LeoFels")
end
function LeoFels()
	if IsNear("leoHilf2","pilBomb9",500) then
		BriefingLeoHilf4()
		return true
	end
end
function BriefingLeoHilf4()
    nbrief                         =   {}
    nbrief.finished                =   BriefingLeoHilf4Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Sehr ihr? habt ihr eine möglichkeit, die felsen aus dem weg zu schaffen?. @cr und denkt dran, macht mir die maschine nicht kaputt!!! @cr Lasst euch was einfallen, wie ihr die bewacher dort wegbekommt."
    nbrief[page].position      =   GetPosition("leoHilf2")
    nbrief[page].dialogCamera  =   true
    
   	local Npc               =   {}
    Npc.name                =   "leoHilf2"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Dario." 
    CreateNPC(Npc)
end
function BriefingLeoHilf4Finished()
	BanditenThree()
	ChangePlayer("robT3",7)
	ChangePlayer("steam2",6)
	StartSimpleJob("LeoMasch")
end
function BanditenThree()
	local entity;
		entity = Entities.CU_BanditLeaderBow1; 
	for i = 1, 4 do 
		CreateMilitaryGroup(6,entity,8,GetPosition("feind1"))
		CreateMilitaryGroup(6,entity,8,GetPosition("feind2"))
		CreateMilitaryGroup(6,entity,8,GetPosition("feind3"))
		CreateMilitaryGroup(6,entity,8,GetPosition("feind4"))
	end
	return true
end
function LeoMasch()
	if IsDead("fels1") then
		Move("leoHilf2","pilBomb8");
		StartSimpleJob("LeoMasch1")
		return true
	end
end
function LeoMasch1()
	if IsNear("leoHilf2","pilBomb8",500) then
		BriefingLeoHilf5()
		return true
	end
end
function BriefingLeoHilf5()
    nbrief                         =   {}
    nbrief.finished                =   BriefingLeoHilf5Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Sehr gut. jetzt kann ich die maschine dazu verwenden, euch ein pulver herzustellen, das euch die möglichkeit gibt, mit den schwestern fertig zuwerden. Sie sind sehr eitel und das pulver kann ihre wahre hässliche gestalt zeigen."
    nbrief[page].position      =   GetPosition("leoHilf2")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Aber ich glaube, nur yuki kann das pulver anwenden. Sie kann sowieso schon mit feuerwerk rumspielen."
    nbrief[page].position      =   GetPosition("yuki")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Wenn yuki es schafft, in die nähe der schwestern zu kommen, kann sie das pulver so verwenden, das die schwestern verwundbar sind."
    nbrief[page].position      =   GetPosition("leoHilf2")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Naja, ich werde jetzt zu Leonardos hütte gehen. Ich wünsche euch viel erfolg auf eurem weiteren weg."
    nbrief[page].position      =   GetPosition("leoHilf2")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "leoHilf2"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Dario." 
    CreateNPC(Npc) 
end
function BriefingLeoHilf5Finished()
	Move("leoHilf2","leoEnd");
	ChangePlayer("steam2",1)
	BriefingScout5()
end
function BriefingScout5()
    nbrief                         =   {}
    nbrief.finished                =   BriefingScout5Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Hi Ari! Hübsch anzusehen seid ihr."
    nbrief[page].position      =   GetPosition("scout5")
    nbrief[page].dialogCamera  =   true
	page = page + 1
	nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Ich soll euch von yuki ausrichten, das sie drüben auf der anderen seite die schwestern beobachtet."
    nbrief[page].position      =   GetPosition("lady1")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "die beiden können mit magie rumspielen und nutzen dies auch. @cr sagt eurem Freund, das er vorsichtig sein soll und sich nicht von der schönheit der beiden blenden lassen soll."
    nbrief[page].position      =   GetPosition("scout5")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "scout5"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingScout5Finished()
	ChangePlayer("scout5",1)
	defeatEntity = "HQ1"
	BriefingScout6()
end
function BriefingScout6()
    nbrief                         =   {}
    nbrief.finished                =   BriefingScout6Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Hallo! Ihr seid ari? @cr Ihr seid ja noch hübscher als yuki."
    nbrief[page].position      =   GetPosition("scout6")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "nun gut. Yuki sagte, ich soll hier auf euch warten und euch dann zu ihr führen. @cr bitte, folgt mir, wir müssen vorsichtig sein, hier ist nicht alles so, wie es den anschein hat. @cr die beiden Schwestern kennen sich sehr gut mit magie aus. @cr aber das erzählt euch dann yuki."
    nbrief[page].position      =   GetPosition("scout6")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "scout6"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingScout6Finished()
	Move("scout6","yuki1");
	WetterOne()
	BriefingYuki()
end
function WetterOne()
		StartSimpleJob("Regen")
		StartSimpleJob("Schnee")
	return true
end
function Regen()
	for i = 1, 11 do 
		if IsNear( "dario", "regen" .. i, 1000 ) then 
		StartRain( 3 ) 
	end 
	end
end
function Schnee()
	for i = 1, 9 do 
		if IsNear( "dario", "schnee" .. i, 1000 ) then 
		StartWinter( 3 ) 
	end 
	end
end
function BriefingYuki()
    nbrief                         =   {}
    nbrief.finished                =   BriefingYukiFinished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Yuki"
    nbrief[page].text          =   "Ari, endlich. Ich habe schon gedacht, du schaffst es nicht bis hierher."
    nbrief[page].position      =   GetPosition("yuki")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Yuki"
    nbrief[page].text          =   "Es ist gut, das ihr alle den weg gefunden habt. Aber hier ist die hölle los. @cr ich beobachte die schwestern schon die ganze zeit. Lord Garek war hier und hat eine der Maschinen von Leonardo hiergelassen. Zwei Gehilfen von leonardo bauen die gerade um, aber ich weiss noch nicht, was draus werden soll."
    nbrief[page].position      =   GetPosition("steam3")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Yuki"
    nbrief[page].text          =   "Die schwestern führen hier ein hartes regiment. und sie sind in der lage, dinge in menschen zu verwandeln und umgekehrt. sie haben etwas geheimnisvolles an sich. @cr und sie wollen ihre magie noch ausbauen, wer weiss was wird, wenn wir sie nicht bremsen. @cr du hast ein pulver für mich? @cr na, mal schauen, was ich damit anfangen kann."
    nbrief[page].position      =   GetPosition("lady2")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Yuki"
    nbrief[page].text          =   "wir sollten mal versuchen, uns die maschine genauer anzusehen. Achja, meine scouts haben mit berichtet, das hier noch einige verschüttete minen in der gegend sind, vielleicht könnte pilgrim da was machen? @cr kommt, lasst uns los und mal ein bisschen action machen."
    nbrief[page].position      =   GetPosition("yuki")
    nbrief[page].dialogCamera  =   true
		nbrief[page].quest			=	{}
		nbrief[page].quest.id		=	4
		nbrief[page].quest.type    =	MAINQUEST_OPEN
		nbrief[page].quest.title	=	"Sucht die Schwestern"
		nbrief[page].quest.text    =	"Die beiden Schwestern haben sich mit Lord Garek verbündet. Er hat eine Maschine zurückgelassen, mit der die Schwestern das Wetter ändern können! @cr Zerstört die Maschine und lasst Euch nicht von irgendwelchen Personen beeinflussen. Die Schwestern sind sehr kundig in Sachen Magie. @cr Also passt sehr gut auf! @cr Ausserdem läuft hier auch die Nichte der beiden in der Gegend rum. Und die hats auch schon drauf mit Magie."
		nbriefHexen 			=	nbrief[page]
   	local Npc               =   {}
    Npc.name                =   "yuki"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nur von Frau zu Frau." 
    CreateNPC(Npc) 
end
function BriefingYukiFinished()
	ResolveBriefing(nbriefWasser)
	BriefingScout6a()
	BriefingLady1()
	ChangePlayer("yuki",1)
	ReplaceEntity("steam3",Entities.PB_Weathermachine_Activated)
end
function BriefingLady1()
    nbrief                         =   {}
	nbrief.finished                =   BriefingLady1Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary I."
    nbrief[page].text          =   "Hallo, neue gesichter hier? @cr hmh, was tun wir denn da?"
    nbrief[page].position      =   GetPosition("lady1")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary II."
    nbrief[page].text          =   "tja, komm lass uns mal schauen, was unsere bücher so hergeben."
    nbrief[page].position      =   GetPosition("lady2")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "lady1"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingLady1Finished()
	ReplaceEntity("lady1", Entities.XD_Sparkles)
	ReplaceEntity("lady2", Entities.XD_Sparkles)
end
function BriefingScout6a()
    nbrief                         =   {}
    nbrief.finished                =   BriefingScout6aFinished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Ein Freund von mir wartet in der nähe der maschine."
    nbrief[page].position      =   GetPosition("scout6")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "kommt mit, ich zeige euch den weg."
    nbrief[page].position      =   GetPosition("scout6")
	nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "scout6"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingScout6aFinished()
	ChangePlayer("scout7",1)
	Move("scout6","scout7");
	StartSimpleJob("ScoutVer")
end
function ScoutVer()
	if IsNear("scout6","scout7",500) then
		ChangePlayer("scout6",1)
		BriefingScout7()
		return true
	end
end
function BriefingScout7()
    nbrief                         =   {}
    nbrief.finished                =   BriefingScout7Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Hier geht es nicht weiter. Die Felsen sind hier sehr brüchig."
    nbrief[page].position      =   GetPosition("scout7")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Aber es gibt da wohl eine hübsche kleine Lady, die hier rumspaziert. Sie ist die Nichte der beiden Schwestern. @cr Die hat mit den felsbrocken hier was zu tun. Geht sie mal suchen."
	nbrief[page].position      =   GetPosition("scout7")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "scout7"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingScout7Finished()
	ChangePlayer("scout7",1);
	Move("scout7","scoutLady");
	BriefingMelli1();
end
function BriefingMelli1()
    nbrief                         =   {}
    nbrief.finished                =   BriefingMelli1Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mellissa"
    nbrief[page].text          =   "Hallo. Ihr seid neu in der gegend hier? @cr Ihr seht noch recht gut aus, seid ihr meinen tanten noch nicht begegnet?. @cr Ich heisse Mellissa, ich bin hier bei meinen Tanten in der lehre. "
    nbrief[page].position      =   GetPosition("melissa")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mellissa"
    nbrief[page].text          =   "Allerdings möchte ich auch gerne wieder nach Hause. Die Tanten sind recht böse und mein Vater, Lord Garek, sagt, ich solle hier lernen. @cr Ein bisschen kann ich schon zaubern. Wenn ihr mir helft, nach hause zu kommen, dann kann ich euch meine kunst zeigen."
    nbrief[page].position      =   GetPosition("melissa")
    nbrief[page].dialogCamera  =   true
   	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mellissa"
    nbrief[page].text          =   "kommt mal mit, ich möchte euch einem freund vorstellen."
    nbrief[page].position      =   GetPosition("melissa")
    nbrief[page].dialogCamera  =   true
	local Npc               =   {}
    Npc.name                =   "melissa"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingMelli1Finished()
	Move("melissa","john1");
	BriefingJohn1();
end
function BriefingJohn1()
    nbrief                         =   {}
    nbrief.finished                =   BriefingJohn1Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Johannes"
    nbrief[page].text          =   "Guten Tag, ich bin Bruder Johannes. Ihr seid Dario, stimmts. @cr ich habe mit einigen Kundschaftern geredet, die haben euch angekündigt. @cr ihr sucht leonardo?"
    nbrief[page].position      =   GetPosition("john")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Johannes"
    nbrief[page].text          =   "nun, der war wohl hier. Allerdings nicht freiwillig. @cr Lord Garek hat ihn gezwungen, eine wettermaschine zu bauen, damit die schwestern dich aufhalten. Er hat wohl mächtig respekt vor dir."
    nbrief[page].position      =   GetPosition("john")
    nbrief[page].dialogCamera  =   true
   	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Johannes"
    nbrief[page].text          =   "Mellissa hier möchte wohl auch gerne nach Hause. Allerdings wollen die Schwestern sie nicht gehen lassen, bevor auch sie die böse magie erlernt hat. Mellissa ist zu liebenswert, sie hat eigentlich keine lust zu zaubern."
    nbrief[page].position      =   GetPosition("john")
    nbrief[page].dialogCamera  =   true
	local Npc               =   {}
    Npc.name                =   "john"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingJohn1Finished()
	BriefingMelli2()
	
end
function BriefingMelli2()
    nbrief                         =   {}
    nbrief.finished                =   BriefingMelli2Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mellissa"
    nbrief[page].text          =   "Ja, bitte helft mir nach Hause zu kommen. @cr Ich könnte auch ein wenig zaubern für euch. Habt ihr denn ein problem irgendwie. "
    nbrief[page].position      =   GetPosition("melissa")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Dario"
    nbrief[page].text          =   "Allerdings! Wir kommen an die Maschine nicht ran. @cr könnt ihr felsen wegzaubern?"
    nbrief[page].position      =   GetPosition("melissa")
    nbrief[page].dialogCamera  =   true
   	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mellissa"
    nbrief[page].text          =   "klar, ich habe an einigen Felsen geübt. Liegen die Dinger jetzt im Weg? Nagut, ich geh mal hin und schaue, ob ich sie wieder wegkriege."
    nbrief[page].position      =   GetPosition("melissa")
    nbrief[page].dialogCamera  =   true
	local Npc               =   {}
    Npc.name                =   "melissa"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
	CreateNPC(Npc) 
end
function BriefingMelli2Finished()
	Move("melissa","schlag10");
	StartSimpleJob("MelliFels");
end
function MelliFels()
	if IsNear("melissa","felsen1",1000) then
		BriefingMelli3()
		return true
	end
end
function BriefingMelli3()
    nbrief                         =   {}
    nbrief.finished                =   BriefingMelli3Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mellissa"
    nbrief[page].text          =   "Achja, hier habe ich vorhin ein wenig rumgespielt. Die Felsen stören Euch? @cr Also, bringt ihr mich nach Hause?"
    nbrief[page].position      =   GetPosition("felsen1")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Dario"
    nbrief[page].text          =   "Ja, Du kannst mit uns kommen. Geh einfach hinter Ari hinterher, dann kann dir nichts passieren."
    nbrief[page].position      =   GetPosition("felsen1")
    nbrief[page].dialogCamera  =   true
   	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mellissa"
    nbrief[page].text          =   "Okay, also weg mit den Dingern. @cr Allerdings ist mir diese Umgebung zu übel, ich werde schon mal vorgehen und auf euch warten. Gegen mich hat hier ja niemand etwas. @cr also, wir sehen uns. Vielleicht kann ich euch dann auch helfen."
    nbrief[page].position      =   GetPosition("felsen1")
    nbrief[page].dialogCamera  =   true
	local Npc               =   {}
    Npc.name                =   "melissa"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
	CreateNPC(Npc) 
end
function BriefingMelli3Finished()
	ChangePlayer("steam3",3)
	for i = 1, 11 do 
	ReplaceEntity("schlag" .. i, Entities.XD_Sparkles)
	end
	StartSimpleJob("MaschDead")
	Move("melissa","sammel1");
	Move("leoHilf3","sammel1");
	Move("leoHilf4","sammel1");
	return true
end
function MaschDead()
	if IsDead("steam3") then
		for i = 1, 11 do 
			DestroyEntity("schlag" .. i)
		end
		Move("melissa","john1");
		WetterEnd()
		BriefingLeoHilf6()
		return true
	end
end
function WetterEnd()
	RegenEnd()
	SchneeEnd()	
end
function RegenEnd()
	for i = 1, 11 do 
		DestroyEntity("regen" .. i)
	end
	return true
end
function SchneeEnd()
	for i = 1, 9 do 
		DestroyEntity("schnee" .. i)
	end
	return true
end
function BriefingLeoHilf6()
    nbrief                         =   {}
	nbrief.finished                =   BriefingLeoHilf6Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Holla. Ihr habt die Maschine zerstört? Jetzt können wir ja endlich zu unserer Hütte zurück."
    nbrief[page].position      =   GetPosition("leoHilf3")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Wir danken Euch. @cr Mellissa erwähnte einen Bruder Johannes. Sie ist schon vorgegangen. Er hat bestimmt noch etwas für Euch."
    nbrief[page].position      =   GetPosition("leoHilf3")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Wir gehen zurück und ich gebe Euren Gelehrten noch einige Papiere. @cr Tschö!"
    nbrief[page].position      =   GetPosition("leoHilf3")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "leoHilf3"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Dario." 
    CreateNPC(Npc) 
end
function BriefingLeoHilf6Finished()
	Move("leoHilf3","HQ2");
	Move("leoHilf4","HQ2");
	BriefingJohn2();
	ChangePlayer("varg",2);
	Move("varg","vargWolf");
	
end
function BriefingJohn2()
    nbrief                         =   {}
    nbrief.finished                =   BriefingJohn2Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Johannes"
    nbrief[page].text          =   "Hallo nochmal. Ihr habt die Maschine zerstört?"
    nbrief[page].position      =   GetPosition("john")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Johannes"
    nbrief[page].text          =   "Und ihr wollt sogar mellissa helfen, nach hause zu kommen? @cr nagut, dann seid ihr es wert, das wir euch auch helfen. @cr ihr könnt die burg nutzen. dann könnt ihr hier einen zweiten stützpunkt aufbauen."
    nbrief[page].position      =   GetPosition("john")
    nbrief[page].dialogCamera  =   true
   	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Johannes"
    nbrief[page].text          =   "Allerdings gibt es hier auch die beiden schwestern noch. Die ärgern uns immer noch. @cr die streiten sich ewig und wir müssen drunter leiden. Könnt ihr da was tun?"
    nbrief[page].position      =   GetPosition("john")
    nbrief[page].dialogCamera  =   true
	local Npc               =   {}
    Npc.name                =   "john"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingJohn2Finished()
	ChangePlayer("HQ2",1);
	defeatEntity = "HQ2"
	ChangePlayer("player4",4);
	ReplaceEntity("lady1", Entities.CU_Mary_de_Mortfichet)
	ReplaceEntity("lady2", Entities.CU_Mary_de_Mortfichet)
	ChangePlayer("lady1",2)
	ChangePlayer("lady2",2)
	Move("lady1","melli1");
	Move("lady2","melli2");
	BriefingVarg2();
	StartSimpleJob("LeoWetter")
end
function BriefingVarg2()
    nbrief                         =   {}
    nbrief.finished                =   BriefingVarg2Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Varg"
    nbrief[page].text          =   "Pilgrim? Es tut mir leid, aber ich muss Euch verlassen. @cr Ich möchte mich wieder mit meinen Wölfen beschäftigen un ich habe dort hinten ein Gehege gefunden, wo die Schwestern sich Wölfe halten."
    nbrief[page].position      =   GetPosition("john1")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Varg"
    nbrief[page].text          =   "Ich möchte den Tieren helfen und sie ausbilden, damit sie mal aus dem Gefängnis freikommen. @cr Ich hoffe, du verstehst mich. Ich muss gehen, wir sehen uns und wenn du hilfe brauchst, du weisst, wo du mich findest."
    nbrief[page].position      =   GetPosition("john1")
    nbrief[page].dialogCamera  =   true
 	local Npc               =   {}
    Npc.name                =   "varg"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "pilgrim"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Pilgrim." 
    CreateNPC(Npc) 
end
function BriefingVarg2Finished()
	Move("varg","vargEnd");
	BriefingLady2()
end
function LeoWetter()
	if IsNear("leoHilf3","HQ2",1000) then
		AllowTechnology(Technologies.T_ChangeWeather, 1);
		Message("Ihr könnt jetzt das Wetter erforschen.")
		Move("leoHilf3","leoEnd");
		return true
	end
end
function BriefingLady2()
    nbrief                         =   {}
	nbrief.finished                =   BriefingLady2Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary I."
    nbrief[page].text          =   "Ihr habt unser Land in besitz genommen?"
    nbrief[page].position      =   GetPosition("melli1")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary II."
    nbrief[page].text          =   "Was heißt hier Dein land? Es ist auch mein Land."
    nbrief[page].position      =   GetPosition("melli2")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary I."
    nbrief[page].text          =   "Deins, meins. Ist doch egal, es ist futsch. Was machen wir jetzt? @cr Der Knilch damit seinen Soldaten hat einfach alles in besitz genommen."
    nbrief[page].position      =   GetPosition("melli1")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary II."
    nbrief[page].text          =   "Wer? Der da? Das gibt eins aufs Haupt! @cr ist dir schon was eingefallen?"
    nbrief[page].position      =   GetPosition("melli2")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary I."
    nbrief[page].text          =   "Klar, warte. @cr Ja, ich weiss was, hinweg mit ihnen."
    nbrief[page].position      =   GetPosition("melli1")
    nbrief[page].dialogCamera  =   true
    local Npc               =   {}
    Npc.name                =   "lady1"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingLady2Finished()
	flashcount = 0
	StartSimpleJob("Flash")
	Move("lady1","melli3");
	Move("lady2","melli4");
end
function Flash()
	if flashcount < 3 then 
		local fx4pos = GetPosition( "Fx1" );
		local offsetx = math.random( 1000 ) - 500;
		local offsety = math.random( 1000 ) - 500;
		Logic.CreateEffect(GGL_Effects.FXLightning, fx4pos.X + offsetx, fx4pos.Y + offsety, 1 );
		Logic.CreateEffect(GGL_Effects.FXExplosion, fx4pos.X + offsetx, fx4pos.Y + offsety, 1 );
	if flashcount == 1 then 
		MassTeleport( 1, "Teleporter1", 2000, "Prison1", 500 )
		MassTeleport( 1, "Teleporter2", 2000, "Prison2", 500 )
		MassTeleport( 1, "Teleporter3", 2000, "Prison3", 500 )
		MassTeleport( 1, "Teleporter4", 2000, "Prison4", 500 )
		BriefingLady3()
	end 
	else 
	return true
	end 
	flashcount = flashcount + 1
end
function MassTeleport( _playerId, _position, _range, _destination, _rangedst )
    assert( type( _playerId ) == "number" );
    _position = GetPosition( _position );
    assert( type( _position ) == "table" );
    assert( type( _range ) == "number" );
    _destination = GetPosition( _destination );
    assert( type( _destination ) == "table" );
    assert( type( _rangedst ) == "number" );
    local tEntities = { Logic.GetPlayerEntitiesInArea( _playerId, 0, _position.X, _position.Y, _range, 32000, 2 ) };
    local amount = table.remove( tEntities, 1 );
    for i = 1, amount do
        if Logic.IsHero( tEntities[i] ) == 1 then
            local targetPos = {};
            targetPos.X = _destination.X + GetRandom( _rangedst * 2 ) - _rangedst;
            targetPos.Y = _destination.Y + GetRandom( _rangedst * 2 ) - _rangedst;
            SetPosition( tEntities[i], targetPos );
		else
			DestroyEntity( tEntities[i] )
        end
    end
end
function BriefingLady3()
    nbrief                         =   {}
	nbrief.finished                =   BriefingLady3Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary I."
    nbrief[page].text          =   "Wie jetzt? Ihr seid ja schon wieder da!"
    nbrief[page].position      =   GetPosition("melli3")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary II."
    nbrief[page].text          =   "Nun lass ihn doch, er ist doch ein netter Junge."
    nbrief[page].position      =   GetPosition("melli4")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary I."
    nbrief[page].text          =   "Nett? Nett??? @cr Er hat meine Zuhause kaputt gemacht, was ist da nett dran?"
    nbrief[page].position      =   GetPosition("melli3")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary II."
    nbrief[page].text          =   "Aber er ist doch harmlos. Was soll er uns tun? Ich habe keine Lust mehr auf Deine Feindseligkeit. @cr Du hast schon alles unter die Erde gebracht, was uns begegnet, den Jungen hier lässt Du in Ruhe!"
    nbrief[page].position      =   GetPosition("melli4")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary I."
    nbrief[page].text          =   "Was solls. Einer mehr oder weniger? ist doch egal,Also, weg mit ihm! @cr hey, was soll das?"
    nbrief[page].position      =   GetPosition("melli3")
	nbrief[page].dialogCamera  =   true
	nbrief[page].action = function(_hero, _health, _effect) 
	                                   Effect = CreateEffect(1, _effect, _hero);
									   SetHealth(_hero, _health);
									   HealthJob = StartSimpleJob("SetHealthJob");
								   end;
	nbrief[page].parameters = { "melli3", 0, GGL_Effects.FXKalaPoison};
    local Npc               =   {}
    Npc.name                =   "lady1"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc)
end
function BriefingLady3Finished()
	ReplaceEntity("rock1", Entities.XD_Sparkles)
	BriefingLady4()
	DestroyEffect(Effect);
end
function SetHealthJob()
    SetHealth("lady1", 0);
end
function BriefingLady4()
    nbrief                         =   {}
	nbrief.finished                =   BriefingLady4Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary II."
    nbrief[page].text          =   "So, die ist ist erst mal weg, könnt ihr mir einen gefallen tun?!"
    nbrief[page].position      =   GetPosition("melli4")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Dario."
    nbrief[page].text          =   "Hmh, was denn?."
    nbrief[page].position      =   GetPosition("melli4")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary II."
    nbrief[page].text          =   "Ich habe keine Lust mehr auf meine Schwester, die wird immer brutaler mit ihrer magie. @cr könnt ihr mich beschützen? @cr Ich spüre, das yuki ein pulver hat, das die böse magie vernichten kann. Bitte holt sie schnell her."
    nbrief[page].position      =   GetPosition("melli4")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Dario."
    nbrief[page].text          =   "Rein theoretisch ist das möglich, was willst du denn?"
    nbrief[page].position      =   GetPosition("melli4")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary II."
    nbrief[page].text          =   "Bitte, nehmt mich bei Euch auf, ich weiss viel und werde euch helfen, gegen lord garek zu bestehen! @cr geht mit yuki zu meiner schwester. Schnell. Schnell."
    nbrief[page].position      =   GetPosition("melli4")
	nbrief[page].quest			=	{}
		nbrief[page].quest.id		=	5
		nbrief[page].quest.type    =	MAINQUEST_OPEN
		nbrief[page].quest.title	=	"Besiegt Lord Garek"
		nbrief[page].quest.text    =	"Lord Garek hat sich das Land unterworfen. Selbst die Barbaren sind auf seiner Seite. @cr Sucht Lord Garek auf und lasst Euch nicht auf irgendwelche Spielchen ein. Lord Garek watet auf Euch."
		nbriefGarek 			=	nbrief[page]
    nbrief[page].dialogCamera  =   true
    local Npc               =   {}
    Npc.name                =   "lady2"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingLady4Finished()
	ResolveBriefing(nbriefHexen)
	DestroyEntity("rock1")
	EndJob(HealthJob);
	local mary = ReplaceEntity("lady1", Entities.CU_Mary_de_Mortfichet);
	SetEntityName(mary, "lady3");
	ChangePlayer("lady2",1)
	BriefingLady5()
	Move("leoHilf4","leoTurm");
	StartSimpleJob("LeoTurm")
end
function LeoTurm()
	if IsNear("leoHilf4","leoTurm",1000) then
		BriefingLeoHilf7()
		return true
	end
end
function BriefingLeoHilf7()
    nbrief                         =   {}
	nbrief.finished                =   BriefingLeoHilf7Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Holla. Ihr habt ja ne Menge Probleme. @cr Ich glaube, ich kann euch helfen!"
    nbrief[page].position      =   GetPosition("leoTurm")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Gehilfe"
    nbrief[page].text          =   "Ich habe da ein bisschen Ahnung von Turmbau. Ich glaube, ich gehe mal zu Euren Gelehrten und gebe ihnen Anweisungen, damit sie ein bisschen Forschen können."
    nbrief[page].position      =   GetPosition("leoTurm")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "leoHilf4"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nur mit Dario." 
    CreateNPC(Npc) 
end
function BriefingLeoHilf7Finished()
	Move("leoHilf4","HQ2");
	StartSimpleJob("LeoTurm1")
end
function LeoTurm1()
	if IsNear("leoHilf4","HQ2",1000) then
		AllowTechnology(Technologies.UP1_Tower, 1);
		Message("Und jetzt könnt Ihr auch den Turmausbau erforschen.");
		Move("leoHilf4","leoEnd");
		return true
	end
end
function BriefingLady5()
    nbrief                         =   {}
	nbrief.finished                =   BriefingLady5Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary I."
    nbrief[page].text          =   "So! So ist das also, man hat mich weggezaubert, na wartet!"
    nbrief[page].position      =   GetPosition("lady3")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary I."
    nbrief[page].text          =   "Wer bist Du denn? @cr was willst du denn?"
    nbrief[page].position      =   GetPosition("lady3")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Yuki."
    nbrief[page].text          =   "Ich Werde dir zeigen, wer ich bin, hier nimm das."
    nbrief[page].position      =   GetPosition("lady3")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Mary I."
    nbrief[page].text          =   "Na wartet, Euch werde ich zeigen, wer hier das sagen hat."
    nbrief[page].position      =   GetPosition("lady3")
    nbrief[page].dialogCamera  =   true
	local Npc               =   {}
    Npc.name                =   "lady3"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "yuki"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingLady5Finished()
	flashcount1 = 0
	StartSimpleJob("Flash1")
	ReitHot1()
	ReitHot2()
	ReitHot3()
	ReitHot4()
	CreatePlayerThree()
end
function Flash1()
	if flashcount1 == 0 then 
	local fx4pos = GetPosition( "Fx2" );
		local offsetx = math.random( 1000 ) - 500;
		local offsety = math.random( 1000 ) - 500;
		Logic.CreateEffect(GGL_Effects.FXYukiFireworksJoy, fx4pos.X + offsetx, fx4pos.Y + offsety, 1 );
		Logic.CreateEffect(GGL_Effects.FXYukiFireworksJoy, fx4pos.X + offsetx, fx4pos.Y + offsety, 1 ); 	
	elseif flashcount1 == 1 then 
		ReplaceEntity("lady3", Entities.CU_Evil_Queen)
		ChangePlayer("lady3",4) 
	else
	local fx4pos = GetPosition( "Fx2" );	
		local offsetx = math.random( 1000 ) - 500;
		local offsety = math.random( 1000 ) - 500;
		Logic.CreateEffect(GGL_Effects.FXYukiFireworksJoy, fx4pos.X + offsetx, fx4pos.Y + offsety, 1 );
		Logic.CreateEffect(GGL_Effects.FXYukiFireworksJoy, fx4pos.X + offsetx, fx4pos.Y + offsety, 1 );
	return true; 
	end
	
	flashcount1 = flashcount1 + 1
end
function ReitHot1()
	for i = 1, 10 do
	CreateEntity( 4, Entities.PU_LeaderHeavyCavalry2 , GetPosition( "hotte1"), "reitbomb" .. i )
	end
	Reiter1()
	return true
end
function Reiter1()
		for i = 1, 10 do
			local reiter = "reitbomb" .. i;
			local bombe = "bomb" .. math.floor( ( i + 1 ) / 2 );
			Move( reiter, GetPosition( bombe ) );
		end
		StartSimpleJob( "BombCheck1" );
		tArrived = {};
		return true
end
function BombCheck1()
	local bAllArrived = true;
	for i = 1, 10 do
		if not tArrived[i] then
			bAllArrived = false;
			local reiter = "reitbomb" .. i;
			local bombe = "bomb" .. math.floor( ( i + 1 ) / 2 );
			if IsNear( reiter, bombe, 500) then
			    CreateEntity( 0, Entities.XD_Bomb1, GetPosition( bombe ) );
				Attack( reiter, GetPosition("HQ1") );
				tArrived[i] = true;
			end
		end
	end	
	return bAllArrived;	
end
function ReitHot2()
	for i = 1, 10 do
	CreateEntity( 4, Entities.PU_LeaderHeavyCavalry2 , GetPosition( "hotte3"), "reitohne" .. i )
	end
	Reiter2()
	return true
end
function Reiter2()
		for i = 1, 10 do
			local reiter = "reitohne" .. i;
			ChangePlayer( reiter, 4 )
			Attack( reiter, GetPosition( "bomb1" ) );
		end
		tArrived = {};
		return true
	end
function ReitHot3()
	for i = 1, 10 do
	CreateEntity( 4, Entities.PU_LeaderHeavyCavalry2 , GetPosition( "hotte2"), "reitmit" .. i )
	end
	Reiter3()
	return true
end
function Reiter3()
		for i = 1, 10 do
			local reiter = "reitmit" .. i;
			local bombe = "bomg" .. math.floor( ( i + 1 ) / 2 );
			Move( reiter, GetPosition( bombe ) );
		end
		StartSimpleJob( "BombCheck1" );
		tArrived = {};
		return true
end
function BombCheck1()
	local bAllArrived = true;
	for i = 1, 10 do
		if not tArrived[i] then
			bAllArrived = false;
			local reiter = "reitmit" .. i;
			local bombe = "bomg" .. math.floor( ( i + 1 ) / 2 );
			if IsNear( reiter, bombe, 500) then
			    CreateEntity( 0, Entities.XD_Bomb1, GetPosition( bombe ) );
				Attack( reiter, GetPosition("HQ2") );
				tArrived[i] = true;
			end
		end
	end	
	return bAllArrived;	
end
function ReitHot4()
	for i = 1, 10 do
	CreateEntity( 4, Entities.PU_LeaderHeavyCavalry2 , GetPosition( "hotte4"), "reitex" .. i )
	end
	Reiter4()
	BriefingScout8()
	return true
end
function Reiter4()
		for i = 1, 10 do
			local reiter = "reitex" .. i;
			Attack( reiter, GetPosition( "bomg1" ) );
		end
		tArrived = {};
		return true
end
function CreatePlayerThree()
	MapEditor_SetupAI(3, 3, 5000, 3, "player3", 3, 1800)
	player3 	= {}
	player3.id 	= 3
    local description = {}
	description.serfLimit = 50
	SetupPlayerAi(player3.id,description)
	local aiID = 3;
	SetupPlayerAi( aiID, { extracting = 1 } );
	SetupPlayerAi( aiID, { repairing = 1 } );
	tBauDings = { { Entities.PB_DarkTower3, "P3DT1" }, { Entities.PB_DarkTower3, "P3DT2" }, { Entities.PB_DarkTower3, "P3DT3" }, { Entities.PB_DarkTower3, "P3DT4" }, { Entities.PB_DarkTower3, "P3DT5" }, { Entities.PB_DarkTower3, "P3DT6" }, { Entities.PB_DarkTower3, "P3DT7" }, { Entities.PB_DarkTower3, "P3DT8" }, { Entities.PB_DarkTower3, "P3DT9" }, { Entities.PB_DarkTower3, "P3DT10" }, { Entities.PB_DarkTower3, "P3DT11" }, { Entities.PB_DarkTower3, "P3DT12" }, { Entities.PB_DarkTower3, "P3DT13" }, { Entities.PB_DarkTower3, "P3DT14" }, { Entities.PB_DarkTower3, "P3DT15" }, { Entities.PB_DarkTower3, "P3DT16" }, { Entities.PB_DarkTower3, "P3DT17" }, { Entities.PB_DarkTower3, "P3DT18" }, { Entities.PB_DarkTower3, "P3DT19" }, { Entities.PB_DarkTower3, "P3DT20" }, { Entities.PB_DarkTower3, "P3DT21" }, { Entities.PB_DarkTower3, "P3DT22" }, { Entities.PB_DarkTower3, "P3DT23" }, { Entities.PB_DarkTower3, "P3DT24" }, { Entities.PB_DarkTower3, "P3DT25" }, { Entities.PB_DarkTower3, "P3DT26" }, { Entities.PB_DarkTower3, "P3DT27" }, { Entities.PB_DarkTower3, "P3DT28" }, { Entities.PB_DarkTower3, "P3DT29" }, { Entities.PB_DarkTower3, "P3DT30" }, { Entities.PB_DarkTower3, "P3DT31" }, { Entities.PB_DarkTower3, "P3DT32" }, { Entities.PB_DarkTower3, "P3DT33" }, { Entities.PB_DarkTower3, "P3DT34" }, { Entities.PB_DarkTower3, "P3DT35" }, { Entities.PB_DarkTower3, "P3DT36" },
	{ Entities.PB_Farm3, "P3F1" }, { Entities.PB_Farm3, "P3F2" }, { Entities.PB_Farm3, "P3F3" }, { Entities.PB_Farm3, "P3F4" }, { Entities.PB_Farm3, "P3F5" }, { Entities.PB_Farm3, "P3F6" }, { Entities.PB_Farm3, "P3F7" }, { Entities.PB_Farm3, "P3F8" }, { Entities.PB_Farm3, "P3F9" }, { Entities.PB_Farm3, "P3F10" }, { Entities.PB_Farm3, "P3F11" }, { Entities.PB_Farm3, "P3F12" }, { Entities.PB_Farm3, "P3F13" }, { Entities.PB_Farm3, "P3F14" }, { Entities.PB_Farm3, "P3F15" },
	{ Entities.PB_Residence3, "P3R1" }, { Entities.PB_Residence3, "P3R2" }, { Entities.PB_Residence3, "P3R3" }, { Entities.PB_Residence3, "P3R4" }, { Entities.PB_Residence3, "P3R5" }, { Entities.PB_Residence3, "P3R6" }, { Entities.PB_Residence3, "P3R7" }, { Entities.PB_Residence3, "P3R8" }, { Entities.PB_Residence3, "P3R9" }, { Entities.PB_Residence3, "P3R10" }, { Entities.PB_Residence3, "P3R11" }, { Entities.PB_Residence3, "P3R12" }, { Entities.PB_Residence3, "P3R13" }, { Entities.PB_Residence3, "P3R14" }, { Entities.PB_Residence3, "P3R15" }, { Entities.PB_Residence3, "P3R16" },
		{ Entities.PB_VillageCenter3, "village3" }, { Entities.PB_Sawmill2, "P3Sa" }, { Entities.PB_Brickworks2, "P3Bw" }, { Entities.PB_StoneMason2, "P3St" }, { Entities.PB_University2, "P3Un" }, { Entities.PB_Blacksmith3, "P3Bs" }, { Entities.PB_Archery2, "P3Ar" }, { Entities.PB_Barracks2, "P3Ba" }, { Entities.PB_GunsmithWorkshop2, "P3Gs" }, { Entities.PB_Monastery3, "P3Mo" }, { Entities.PB_Alchemist2, "P3Al" }, { Entities.PB_Stable2, "P3Sta" }, { Entities.PB_Market2, "P3Ma" }, { Entities.PB_Foundry2, "P3Fo" }, { Entities.PB_Tavern2, "P3Tav" }, { Entities.PB_Bank2, "P3Bank" }, { Entities.CB_Camp18, "P3Ca1" }, { Entities.CB_Camp20, "P3Ca2" }, { Entities.CB_Camp22, "P3Ca3" }}
	for i = 1, table.getn( tBauDings ) do 
		CreateEntityNormal( 3, tBauDings[i][1], GetPosition(tBauDings[i][2]) );
	end 
	return true
end
function BriefingScout8()
    nbrief                         =   {}
    nbrief.finished                =   BriefingScout8Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Hallo Ari. Das hat ja lange gedauert. Meine Freunde erzählten schon von Eurer Schönheit. Ich bin begeistert. @cr Aber ... ??? Das ist ja eine der bösen Schwestern. Wie das?"
    nbrief[page].position      =   GetPosition("scout8")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Naja, ist nicht mein Problem. Das Problem ist, das ich hier nicht weiterkomme, und auf der anderen Seite wartet ein Kumpel. @cr Aber da drüben sind lauter Barbaren. Sie wollten die Schwestern unterstützen. @cr es sind unmengen an Barbaren, die wollten alle hierher, aber wir haben die Brücke gesprengt. "
    nbrief[page].position      =   GetPosition("scout8")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Allerdings müssen wir da rüber, weil Lord Garek mit Leonardo auch da lang gezogen ist. @cr Und ich weiss, das es nicht mehr weit ist, bis wir Lord gareks schloss erreichen und Leonardo endlich aus seiner mieslichen Situation befreien können. "
    nbrief[page].position      =   GetPosition("scout8")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "scout8"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingScout8Finished()
	ChangePlayer( "scout8", 1 )
	Nebel1()
end
function Nebel1()
	CreateFogAt( "FogA", GetPosition( "nebel1" ), 2000, true, false );
	CreateFogAt( "FogB", GetPosition( "nebel2" ), 2000, true, false );
	CreateFogAt( "FogC", GetPosition( "nebel3" ), 2500, true, true );
	CreateFogAt( "FogD", GetPosition( "nebel4" ), 2000, true, false );
	CreateFogAt( "FogE", GetPosition( "nebel5" ), 2500, true, true );
	CreateFogAt( "FogF", GetPosition( "nebel6" ), 2000, true, false );
	CreateFogAt( "FogG", GetPosition( "nebel7" ), 2500, true, true );
	CreateFogAt( "FogH", GetPosition( "nebel8" ), 2500, true, true );
	CreateFogAt( "FogI", GetPosition( "nebel9" ), 2500, true, true );
	CreateFogAt( "FogJ", GetPosition( "nebel10" ), 2500, true, true );
	CreateFogAt( "FogK", GetPosition( "nebel11" ), 2500, true, true );
	CreateFogAt( "FogL", GetPosition( "nebel12" ), 2500, true, false );
	CreateFogAt( "FogM", GetPosition( "nebel13" ), 2500, true, true );
	CreateFogAt( "FogN", GetPosition( "nebel14" ), 2500, true, true );
	fogAVisible = false;
    fogATimer = false;
	fogBVisible = false;
    fogBTimer = false;
	fogCVisible = true;
    fogCTimer = false;
	fogDVisible = false;
    fogDTimer = false;
	fogEVisible = true;
    fogETimer = false;
	fogFVisible = false;
    fogFTimer = false;
	fogGVisible = true;
    fogGTimer = false;
	fogHVisible = true;
    fogHTimer = false;
	fogIVisible = true;
    fogITimer = false;
	fogJVisible = true;
    fogJTimer = false;	
	fogKVisible = true;
    fogKTimer = false;
	fogLVisible = true;
    fogLTimer = false;
	fogNVisible = true;
    fogNTimer = false;
	fogMVisible = true;
    fogMTimer = false;
	StartSimpleJob( "FogACheck" );
	StartSimpleJob( "FogBCheck" );
	StartSimpleJob( "FogCCheck" );
	StartSimpleJob( "FogDCheck" );
	StartSimpleJob( "FogECheck" );
	StartSimpleJob( "FogFCheck" );
	StartSimpleJob( "FogGCheck" );
	StartSimpleJob( "FogHCheck" );
	StartSimpleJob( "FogICheck" );
	StartSimpleJob( "FogJCheck" );
	StartSimpleJob( "FogKCheck" );
	StartSimpleJob( "FogLCheck" );
	StartSimpleJob( "FogMCheck" );
	StartSimpleJob( "FogNCheck" );
end
function CreateFogAt( _name, _posOrigin, _range, _random, _show )
    for y = 1, 5 do
        for x = 1, 4 do
            local pos;
            if _random then
                pos = { X = _posOrigin.X + math.random( _range ) - _range / 2, Y = _posOrigin.Y + math.random( _range ) - _range / 2 };
            else
                pos = { X = _posOrigin.X + x * _range / 4 - _range / 2, Y = _posOrigin.Y + y * _range / 4 - _range / 2 };
            end
            CreateEntity( 0, Entities.XD_BlendingFog, pos, _name .. y .. "_" .. x );
        end
    end
    CreateDynamicFog( _name, _show and 5 or 0 );
end
function FogACheck()
    if fogATimer then
        fogATimer = fogATimer - 1;
        if fogATimer == 0 then
            fogATimer = false;
            fogAVisible = not fogAVisible;
        end
    end
    if not fogAVisible and not fogATimer and IsNear( "dario", "nebel1", 1000 ) then
        ChangeDynamicFog( "FogA", 3, 1 );
        fogATimer = 1 * 3 + 2;
		Sound.PlayGUISound(Sounds.AmbientSounds_Nephilim_rnd_1, 0)
        BarbOne()
    end
    if fogAVisible and not fogATimer and not IsNear( "dario", "nebel1", 1000 ) then
        ChangeDynamicFog( "FogA", 0, 2 );
        fogATimer = 5 * 3 + 2;
    end
end
function BarbOne()
	local entity;
		entity = Entities.CU_Evil_LeaderBearman1; 
	for i = 1, 2 do 
		CreateMilitaryGroup(7,entity,8,GetPosition("barb1"))
	end
	return true
end
function FogBCheck()
    if FogBTimer then
        FogBTimer = FogBTimer - 1;
        if FogBTimer == 0 then
            FogBTimer = false;
            FogBVisible = not FogBVisible;
        end
    end
    if not FogBVisible and not FogBTimer and IsNear( "dario", "nebel2", 1000 ) then
        ChangeDynamicFog( "FogB", 4, 1 );
        FogBTimer = 1 * 4 + 2;
        DestroyEntity("nebel1")
    end
    if FogBVisible and not FogBTimer and not IsNear( "dario", "nebel2", 1000 ) then
        ChangeDynamicFog( "FogB", 0, 2 );
        FogBTimer = 5 * 4 + 2;
    end
end
function FogCCheck()
    if fogCTimer then
        fogCTimer = fogCTimer - 1;
        if fogCTimer == 0 then
            fogCTimer = false;
            fogCVisible = not fogCVisible; 
        end
    end
    if fogCVisible and not fogCTimer and IsNear( "dario", "nebel3", 1000 ) then
         ChangeDynamicFog( "FogC", 0, 1 );
        fogCTimer = 1 * 5 + 1; 
		Sound.PlayGUISound(Sounds.AmbientSounds_Nephilim_rnd_1, 0)
        BarbTwo()
    end
    if not fogCVisible and not fogCTimer and not IsNear( "dario", "nebel3", 1000 ) then
        ChangeDynamicFog( "FogC", 5, 8 );
        fogCTimer = 8 * 5 + 2;
    end
end
function BarbTwo()
	local entity;
		entity = Entities.CU_Evil_LeaderBearman1; 
	for i = 1, 2 do 
		CreateMilitaryGroup(7,entity,16,GetPosition("barb2"))
	end
	return true
end
function FogDCheck()
    if FogDTimer then
        FogDTimer = FogDTimer - 1;
        if FogDTimer == 0 then
            FogDTimer = false;
            FogDVisible = not FogDVisible;
        end
    end
    if not FogDVisible and not FogDTimer and IsNear( "dario", "nebel4", 1000 ) then
        ChangeDynamicFog( "FogD", 4, 1 );
        FogDTimer = 1 * 4 + 2;
        DestroyEntity("nebel3")
    end
    if FogDVisible and not FogDTimer and not IsNear( "dario", "nebel4", 1000 ) then
        ChangeDynamicFog( "FogD", 0, 2 );
        FogDTimer = 5 * 4 + 2;
    end
end
function FogECheck()
    if FogETimer then
        FogETimer = FogETimer - 1;
        if FogETimer == 0 then
            FogETimer = false;
            FogEVisible = not FogEVisible; 
        end
    end
    if FogEVisible and not FogETimer and IsNear( "dario", "nebel5", 1000 ) then
         ChangeDynamicFog( "FogE", 0, 1 );
        FogETimer = 1 * 5 + 1; 
		Sound.PlayGUISound(Sounds.AmbientSounds_Nephilim_rnd_1, 0)
        BarbThree()
    end
    if not FogEVisible and not FogETimer and not IsNear( "dario", "nebel5", 1000 ) then
        ChangeDynamicFog( "FogE", 5, 8 );
        FogETimer = 8 * 5 + 2;
    end
end
function BarbThree()
	local entity;
		entity = Entities.CU_Evil_LeaderSkirmisher1; 
	for i = 1, 2 do 
		CreateMilitaryGroup(7,entity,8,GetPosition("barb3"))
	end
	return true
end
function FogFCheck()
    if FogFTimer then
        FogFTimer = FogFTimer - 1;
        if FogFTimer == 0 then
            FogFTimer = false;
            FogFVisible = not FogFVisible;
        end
    end
    if not FogFVisible and not FogFTimer and IsNear( "dario", "nebel6", 1000 ) then
        ChangeDynamicFog( "FogF", 4, 1 );
        FogFTimer = 1 * 4 + 2;
		DestroyEntity("nebel5")
    end
    if FogFVisible and not FogFTimer and not IsNear( "dario", "nebel6", 1000 ) then
        ChangeDynamicFog( "FogF", 0, 2 );
        FogFTimer = 5 * 4 + 2;
    end
end
function FogGCheck()
    if FogGTimer then
        FogGTimer = FogGTimer - 1;
        if FogGTimer == 0 then
            FogGTimer = false;
            FogGVisible = not FogGVisible; 
        end
    end
    if FogGVisible and not FogGTimer and IsNear( "dario", "nebel7", 1000 ) then
         ChangeDynamicFog( "FogG", 0, 1 );
        FogGTimer = 1 * 5 + 1; 
		Sound.PlayGUISound(Sounds.AmbientSounds_Nephilim_rnd_1, 0)
        BarbFour()
    end
    if not FogGVisible and not FogGTimer and not IsNear( "dario", "nebel7", 1000 ) then
        ChangeDynamicFog( "FogG", 5, 8 );
        FogGTimer = 8 * 5 + 2;
    end
end
function BarbFour()
	local entity;
		entity = Entities.CU_Evil_LeaderBearman1; 
	for i = 1, 2 do 
		CreateMilitaryGroup(7,entity,16,GetPosition("barb4"))
	end
	return true
end
function FogHCheck()
    if FogHTimer then
        FogHTimer = FogHTimer - 1;
        if FogHTimer == 0 then
            FogHTimer = false;
            FogHVisible = not FogHVisible; 
        end
    end
    if FogHVisible and not FogHTimer and IsNear( "dario", "nebel8", 1000 ) then
         ChangeDynamicFog( "FogH", 0, 1 );
        FogHTimer = 1 * 5 + 1; 
		Sound.PlayGUISound(Sounds.AmbientSounds_Nephilim_rnd_1, 0)
        BarbFive()
    end
    if not FogHVisible and not FogHTimer and not IsNear( "dario", "nebel8", 1000 ) then
        ChangeDynamicFog( "FogH", 5, 8 );
        FogHTimer = 8 * 5 + 2;
    end
end
function BarbFive()
	local entity;
		entity = Entities.CU_Evil_LeaderSkirmisher1; 
	for i = 1, 2 do 
		CreateMilitaryGroup(7,entity,16,GetPosition("barb5"))
	end
	return true
end
function FogICheck()
    if FogITimer then
        FogITimer = FogITimer - 1;
        if FogITimer == 0 then
            FogITimer = false;
            FogIVisible = not FogIVisible; 
        end
    end
    if FogIVisible and not FogITimer and IsNear( "dario", "nebel9", 1000 ) then
         ChangeDynamicFog( "FogI", 0, 1 );
        FogITimer = 1 * 5 + 1; 
		Sound.PlayGUISound(Sounds.AmbientSounds_Nephilim_rnd_1, 0)
        BarbSix()
		DestroyEntity("nebel7")
		DestroyEntity("nebel8")
    end
    if not FogIVisible and not FogITimer and not IsNear( "dario", "nebel9", 1000 ) then
        ChangeDynamicFog( "FogI", 5, 8 );
        FogITimer = 8 * 5 + 2;
    end
end
function BarbSix()
	local entity;
		entity = Entities.CU_Evil_LeaderBearman1; 
	for i = 1, 2 do 
		CreateMilitaryGroup(7,entity,16,GetPosition("barb6"))
	end
	return true
end
function FogJCheck()
    if FogJTimer then
        FogJTimer = FogJTimer - 1;
        if FogJTimer == 0 then
            FogJTimer = false;
            FogJVisible = not FogJVisible; 
        end
    end
    if FogJVisible and not FogJTimer and IsNear( "dario", "nebel10", 1000 ) then
         ChangeDynamicFog( "FogJ", 0, 1 );
        FogJTimer = 1 * 5 + 1; 
		Sound.PlayGUISound(Sounds.AmbientSounds_Nephilim_rnd_1, 0)
        BarbSeven()
		DestroyEntity("nebel9")
		BriefingScout9()
    end
    if not FogJVisible and not FogJTimer and not IsNear( "dario", "nebel10", 1000 ) then
        ChangeDynamicFog( "FogJ", 5, 8 );
        FogJTimer = 8 * 5 + 2;
    end
end
function BarbSeven()
	local entity;
		entity = Entities.CU_Evil_LeaderSkirmisher1; 
	for i = 1, 2 do 
		CreateMilitaryGroup(7,entity,8,GetPosition("barb7"))
	end
	return true
end
function FogKCheck()
    if FogKTimer then
        FogKTimer = FogKTimer - 1;
        if FogKTimer == 0 then
            FogKTimer = false;
            FogKVisible = not FogKVisible; 
        end
    end
    if FogKVisible and not FogKTimer and IsNear( "dario", "nebel11", 1000 ) then
         ChangeDynamicFog( "FogK", 0, 1 );
        FogKTimer = 1 * 5 + 1; 
    end
    if not FogKVisible and not FogKTimer and not IsNear( "dario", "nebel11", 1000 ) then
        ChangeDynamicFog( "FogK", 5, 8 );
        FogKTimer = 8 * 5 + 2;
    end
end
function FogLCheck()
    if FogLTimer then
        FogLTimer = FogLTimer - 1;
        if FogLTimer == 0 then
            FogLTimer = false;
            FogLVisible = not FogLVisible;
        end
    end
    if not FogLVisible and not FogLTimer and IsNear( "dario", "nebel12", 1000 ) then
        ChangeDynamicFog( "FogL", 4, 1 );
        FogLTimer = 1 * 4 + 2;
        DestroyEntity("nebel10")
    end
    if FogLVisible and not FogLTimer and not IsNear( "dario", "nebel12", 1000 ) then
        ChangeDynamicFog( "FogL", 0, 2 );
        FogLTimer = 5 * 4 + 2;
    end
end
function FogMCheck()
    if FogMTimer then
        FogMTimer = FogMTimer - 1;
        if FogMTimer == 0 then
            FogMTimer = false;
            FogMVisible = not FogMVisible; 
        end
    end
    if FogMVisible and not FogMTimer and IsNear( "dario", "nebel13", 1000 ) then
         ChangeDynamicFog( "FogM", 0, 1 );
        FogMTimer = 1 * 5 + 1; 
		Sound.PlayGUISound(Sounds.AmbientSounds_Nephilim_rnd_1, 0)
        BarbEight()
    end
    if not FogMVisible and not FogMTimer and not IsNear( "dario", "nebel13", 1000 ) then
        ChangeDynamicFog( "FogM", 5, 8 );
        FogMTimer = 8 * 5 + 2;
    end
end
function BarbEight()
	local entity;
		entity = Entities.CU_Evil_LeaderBearman1; 
	for i = 1, 2 do 
		CreateMilitaryGroup(7,entity,16,GetPosition("barb8"))
	end
	return true
end
function FogNCheck()
    if FogNTimer then
        FogNTimer = FogNTimer - 1;
        if FogNTimer == 0 then
            FogNTimer = false;
            FogNVisible = not FogNVisible; 
        end
    end
    if FogNVisible and not FogNTimer and IsNear( "dario", "nebel14", 1000 ) then
         ChangeDynamicFog( "FogN", 0, 1 );
        FogNTimer = 1 * 5 + 1; 
		Sound.PlayGUISound(Sounds.AmbientSounds_Nephilim_rnd_1, 0)
        BarbNine()
    end
    if not FogNVisible and not FogNTimer and not IsNear( "dario", "nebel14", 1000 ) then
        ChangeDynamicFog( "FogN", 5, 8 );
        FogNTimer = 8 * 5 + 2;
    end
end
function BarbNine()
	local entity;
		entity = Entities.CU_Evil_LeaderSkirmisher1; 
	for i = 1, 2 do 
		CreateMilitaryGroup(7,entity,16,GetPosition("barb9"))
		DestroyEntity("nebel13")
		DestroyEntity("nebel14")
	end
	return true
end
function BriefingScout9()
    nbrief                         =   {}
    nbrief.finished                =   BriefingScout9Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Hallo Dario. Eine unheimliche Gegend hier. @cr Dieser verfluchte Nebel nervt mich langsam."
    nbrief[page].position      =   GetPosition("scout9")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Aber ich zeige Euch den Weg, den Leonardo auch genommen hat, um an einer Maschine zu basteln. folgt mir."
    nbrief[page].position      =   GetPosition("scout9")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "scout9"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingScout9Finished()
	for i = 1, 3 do
		CreateFogAt1( "Fog" .. i, GetPosition( "FogPos" .. i ), 2000, 5, 5 );
	end
	StartSimpleJob( "FogCheck1" );
	Move("scout9","nebel11");
	BriefingScout10()
end
function CreateFogAt1( _name, _posOrigin, _range, _desensity, _fadetime )
	for y = 1, _desensity do
		for x = 1, _desensity do
		 local pos = { X = _posOrigin.X + math.random( _range ) - _range / 2, Y = _posOrigin.Y + math.random( _range ) - _range / 2 };
		    CreateEntity( 0, Entities.XD_BlendingFog, pos, _name .. y .. "_" .. x );
		end
	end
	CreateDynamicFog( _name, 0 );
	local entry = {};
	entry.name = _name;
	entry.groups = _desensity;
	entry.fadetime = _fadetime;
	entry.visible = false;
	tFog = tFog or {};
	table.insert( tFog, entry );
end
function FogCheck1()
	local bEndJob = false;
	if IsNear( "dario", "nebelAn", 2000 ) then
		for i = 1, table.getn( tFog ) do
			local entry = tFog[i];
			if entry.visible then
				if IsDead( "steam4" ) then
				 ChangeDynamicFog( entry.name, 0, entry.fadetime );
				    bEndJob = true;
				end
			else
			 ChangeDynamicFog( entry.name, entry.groups, entry.fadetime );
				entry.visible = true;
			end
		end
	end
	return bEndJob;
end
function BriefingScout10()
    nbrief                         =   {}
    nbrief.finished                =   BriefingScout10Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Durch diesen Pass müsst ihr durch. @cr aber ohne mich. das ist mir zu gefährlich, ich warte da hinten wieder auf euch."
    nbrief[page].position      =   GetPosition("scout9")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "wenn ihr die höllenmaschine totgemacht habt, kommt wieder zu mir. @cr Ich stelle da ein paar fackeln auf, vielleicht sieht man dann mehr."
    nbrief[page].position      =   GetPosition("scout9")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "scout9"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingScout10Finished()
	Move("scout9","nebelAn1");
	CreateEntity( 0, Entities.XD_Torch, GetPosition("fackel1") );
	CreateEntity( 0, Entities.XD_Torch, GetPosition("fackel2") );
	CreateEntity( 0, Entities.XD_Torch, GetPosition("fackel3") );
	BriefingScout11()
end
function BriefingScout11()
    nbrief                         =   {}
    nbrief.finished                =   BriefingScout11Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "Hallo. Ihr habt die höllenmaschine zerstört? Oder habt ihr euch nicht getraut? @cr ist auch egal, bloss wäre dann dieser blöde nebel ...."
    nbrief[page].position      =   GetPosition("scout9")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "folgt den Fackeln und geht am wasserfall vorbei. Dort wartet ein Kumpel von mir."
    nbrief[page].position      =   GetPosition("scout9")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "scout9"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingScout11Finished()
	ChangePlayer( "scout9", 1 );
	BriefingScout12()
end
function BriefingScout12()
    nbrief                         =   {}
    nbrief.finished                =   BriefingScout12Finished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   " Aber Hallo. Ihr seid Ari? Ihr seht sehr gut aus."
    nbrief[page].position      =   GetPosition("scout10")
    nbrief[page].dialogCamera  =   true
    page = page + 1
	nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   " Ich habe leonardo gesehen. @cr Ihr müsst an Lord gareks schloss vorbei. weiter hinten auf der insel steht eine hütte, wo sich auch leonardo aufhält. bitte helft ihm, euer freund ist doch stark. @cr und ich habe ein paar kanonen erbeutet. Bloss stehen die da doof."
    nbrief[page].position      =   GetPosition("scout10")
    nbrief[page].dialogCamera  =   true
    nbrief[page]               =   {}
    nbrief[page].title         =   "Kundschafter"
    nbrief[page].text          =   "ich glaube, lord garek wird ruhiger, wenn seine Melissa wieder bei ihm ist. @cr bloss dieser dusslige felsen stört, aber das ist kein für pilgrim, oder?"
    nbrief[page].position      =   GetPosition("scout10")
    nbrief[page].dialogCamera  =   true
	
   	local Npc               =   {}
    Npc.name                =   "scout10"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "ari"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingScout12Finished()
	ChangePlayer( "scout10", 1 );
	StartSimpleJob( "Rock3" );
end
function Rock3()
	if IsDead( "rock3" ) then
		Move("melissa","garekEnd");
		BriefingGarek()
		return true
	end
end
function BriefingGarek()
    nbrief                         =   {}
    nbrief.finished                =   BriefingGarekFinished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Lord Garek"
    nbrief[page].text          =   "Hallo, ihr seid dario? ich bin ein schlechter mensch. ich dachte, ich könnte euch besiegen, aber ... ??? @cr ich unterwerfe mich euch. Ihr habt mir meine mellissa wieder gebracht."
    nbrief[page].position      =   GetPosition("garek")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Lord Garek"
    nbrief[page].text          =   "Leonardo ist dort hinten, meine leute habe ich nicht mehr unter kontrolle, sie werden sich wehren. @cr aber leonardo wird sich freuen, euch zu sehen."
    nbrief[page].position      =   GetPosition("garek")
    nbrief[page].dialogCamera  =   true
	page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Lord Garek"
    nbrief[page].text          =   "Ich hoffe, ihr seid mit dem einverstanden. ich gehe mit mellissa fort von hier."
    nbrief[page].position      =   GetPosition("leonardo")
	nbrief[page].explore	= 2000
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "garek"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingGarekFinished()
	Move("garek","leoEnd");
	Move("melissa","leoEnd");
	BanditenFour()	
	BriefingLeonardo()
end
function BanditenFour()
	local entity;
		entity = Entities.CU_BanditLeaderBow1; 
	for i = 1, 8 do 
		CreateMilitaryGroup(3,entity,8,GetPosition("garRob1"))
		CreateMilitaryGroup(3,entity,8,GetPosition("garRob2"))
		CreateMilitaryGroup(3,entity,8,GetPosition("garRob3"))
		CreateMilitaryGroup(3,entity,8,GetPosition("garRob4"))
		CreateMilitaryGroup(3,entity,8,GetPosition("garRob5"))
		CreateMilitaryGroup(3,entity,8,GetPosition("garRob6"))
		CreateMilitaryGroup(3,entity,8,GetPosition("garRob7"))
		CreateMilitaryGroup(3,entity,8,GetPosition("garRob8"))
	end
	return true
end
function BriefingLeonardo()
    nbrief                         =   {}
    nbrief.finished                =   BriefingLeonardoFinished
    page = 0
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Leonardo"
    nbrief[page].text          =   "Dario. Mein freund! @cr ich freue mich, euch zu sehen."
    nbrief[page].position      =   GetPosition("leonardo")
    nbrief[page].dialogCamera  =   true
    page = page + 1
    nbrief[page]               =   {}
    nbrief[page].title         =   "Leonardo"
    nbrief[page].text          =   "Lord Garek ist weg? gut, dann steht unserer Siegesfeier nichts mehr im wege."
    nbrief[page].position      =   GetPosition("leonardo")
    nbrief[page].dialogCamera  =   true
   	local Npc               =   {}
    Npc.name                =   "leonardo"
    Npc.briefing            =   nbrief
    Npc.heroName            =   "dario"
    Npc.wrongHeroMessage    =   "Ich spreche nicht mit Euch." 
    CreateNPC(Npc) 
end
function BriefingLeonardoFinished()
	Victory()
end
function DarioIsNeargaertner1()
   if IsNear(GetEntityId("dario"), GetEntityId("gaertner1"), 1000) then
      EndJob(DarioIsNeargaertner1ID)
      _OP_counterGaertner = 2
      _OP_counterWachsen = 4
      _OP_NBaum  = 0
      _OP_nextBaum = true
      _OP_OKBaum = true
      _OP_MaxBaeume = 0
      _OP_gaertnerPos = {}
      _OP_gaertnerPos1 = {}
      _OP_forest01 = {}
      _OP_gaertner = "gaertner1"
      _OP_forest01=_OP_CreateWald(GetPosition("WaldEntity"), 500, 1800)
      _OP_pflanzeBaeumeID = StartSimpleJob("_OP_pflanzeBaeume")
      _OP_wachsedBaeumeID = StartSimpleJob("_OP_wachsedBaeume")
      _OP_moveGaertnerID = 0
   end
end
_OP_Grow = {
    nil,
    Entities.XD_Pine3,
    Entities.XD_Pine4,
    Entities.XD_Pine6,
    Entities.XD_Pine2,
}
function _OP_wachsedBaeume()
   _OP_counterWachsen = _OP_counterWachsen - 1
   if _OP_counterWachsen == 0 then
      local Ename = ""
      local Eresource = 0
      local DoFlag = true
	  local i
      for i=1,_OP_MaxBaeume do
      	 DoFlag = true
       	 Ename = _OP_forest01[i].name
       	 if _OP_forest01[i].status > 1 and _OP_forest01[i].status < 6 then
       	    Eresource = Logic.GetResourceDoodadGoodAmount(GetEntityId(Ename))
       	    if Eresource > 0 then
			   DoFlag = false
   	    end
       	    if _OP_CountEntitiesInArea( 0, _OP_forest01[i].position, 150)> 0 then
       	 	   DoFlag = false
       	    end
            local newEntityType = _OP_Grow[_OP_forest01[i].status]
            if newEntityType and not IsDead(Ename) and GetRandom(4) == 1 and DoFlag then
         	   _OP_forest01[i].status = _OP_forest01[i].status + 1;
         	   ReplaceEntity(Ename, newEntityType)
            end
         end
      end
      _OP_counterWachsen = 4
   end
end
function _OP_pflanzeBaeume()
   _OP_counterGaertner = _OP_counterGaertner - 1
   if _OP_counterGaertner == 0 then
      local Ename = ""
      local i = 0
      local Epos = {}
      for i=1, _OP_MaxBaeume do
       	 Ename = _OP_forest01[i].name
       	 Epos  = {
       	   X = _OP_forest01[i].position.X,
       	   Y = _OP_forest01[i].position.Y
		 }
         if _OP_forest01[i].status == 1 then
         	if _OP_OKBaum then
        	       if _OP_CountEntitiesInArea( 0, Epos, 100) == 0 then
         	      _OP_nextBaum = true
         	      if ReplaceEntity(Ename, Entities.XD_Bush4)>0 then
         	         _OP_forest01[i].status = 2
         	        else
         	         _OP_forest01[i].status = -1
         	      end
         	   else
			   if _OP_forest01[i].posF.X == GetPosition(_OP_gaertner).X and
					_OP_forest01[i].posF.Y == GetPosition(_OP_gaertner).Y then
       	   	   			_OP_forest01[i].status = 0
       	       			_OP_nextBaum = true
       	       	else
        	       	_OP_forest01[i].posF.X = GetPosition(_OP_gaertner).X 
					_OP_forest01[i].posF.Y = GetPosition(_OP_gaertner).Y
				end         	
       	       	_OP_counterGaertner = 1
         	   end
         	else
   				_OP_forest01[i].status = 0
   				_OP_nextBaum = true
  	       		_OP_counterGaertner = 1
  	       	end
         end
         if _OP_forest01[i].status > 1 and IsDead(Ename) then
         	_OP_forest01[i].status = 0
         	_OP_CleanUp(Epos, 200)
            CreateEntity(1, Entities.XD_ScriptEntity, Epos, Ename)
         end
      end
      if not _OP_nextBaum then
		if _OP_counterGaertner == 0 then
	      	_OP_counterGaertner = 2
      	end
      	return
      end
	  local liste = {}
  	  for i=1,_OP_MaxBaeume do
   	  	 if _OP_forest01[i].status == 0 then
   	  	 	table.insert( liste, i )
   	  	 end
   	  end
   	  if table.getn(liste) == 0 then
	     _OP_counterGaertner = 5
   	  	 return
   	  end
  	  i = liste[GetRandom(table.getn(liste))+1]
      Ename = _OP_forest01[i].name
     local PosF  = {
       	   X = _OP_forest01[i].position.X - 1,
       	   Y = _OP_forest01[i].position.Y - 1
	  }
		_OP_nextBaum = false
   		_OP_forest01[i].status = 1
		_OP_NBaum = GetEntityId(Ename)
   		Move(GetEntityId(_OP_gaertner), PosF, 0)
   		_OP_forest01[i].posF = {
      			X = GetPosition(_OP_gaertner).X,
       			Y = GetPosition(_OP_gaertner).Y
   		}
  		_OP_OKBaum = true
   		_OP_gaertnerPos = _OP_forest01[i].posF
   		_OP_gaertnerPos1 = _OP_forest01[i].posF
   		EndJob(_OP_pflanzeBaeumeID)
   		_OP_moveGaertnerID=StartSimpleJob("_OP_moveGaertner")
		if _OP_counterGaertner == 0 then
	      _OP_counterGaertner = 2
      	end
   end
end
function _OP_moveGaertner()
	if IsNear(GetEntityId(_OP_gaertner), _OP_NBaum, 50) then
  		Move(GetEntityId(_OP_gaertner), _OP_gaertnerPos1, 0)
  		EndJob(_OP_moveGaertnerID)
		_OP_pflanzeBaeumeID=StartSimpleJob("_OP_pflanzeBaeume")
        _OP_counterGaertner = 3
  	else
 		if _OP_gaertnerPos.X == GetPosition(_OP_gaertner).X and
			_OP_gaertnerPos.Y == GetPosition(_OP_gaertner).Y then
			_OP_OKBaum = false
			EndJob(_OP_moveGaertnerID)
			_OP_pflanzeBaeumeID=StartSimpleJob("_OP_pflanzeBaeume")
	        _OP_counterGaertner = 1
       	else
       	    _OP_gaertnerPos1 = _OP_gaertnerPos
       	    _OP_gaertnerPos.X = GetPosition(_OP_gaertner).X 
			_OP_gaertnerPos.Y = GetPosition(_OP_gaertner).Y
		end         	
	end
end
function _OP_CreateWald( _Pos, _Abstand, _Range)
   local Wald = {}
   local funcAdd = function( _n1, _n2 ) return _n1 + _n2 end
   local funcSub = function( _n1, _n2 ) return _n1 - _n2 end
   _OP_CreateSegment( Wald, _Pos, _Abstand, _Range, funcAdd, funcAdd )
   _OP_CreateSegment( Wald, _Pos, _Abstand, _Range, funcSub, funcAdd )
   _OP_CreateSegment( Wald, _Pos, _Abstand, _Range, funcAdd, funcSub )
   _OP_CreateSegment( Wald, _Pos, _Abstand, _Range, funcSub, funcSub )
   _OP_MaxBaeume = table.getn( Wald )
   return Wald
end
function _OP_CreateSegment( _Wald, _Pos, _Abstand, _Range, _opX, _opY )
   local abstand = _Abstand				
   local Range  = _Range				
   local abstand2 = math.sqrt(abstand*abstand-(abstand/2)*(abstand/2))
   local WaldPos01 = {
       X = _Pos.X,
       Y = _Pos.Y
   }
   local x = 0
   for y=0, Range/abstand2 do
   	while _OP_GetRange(_Pos, WaldPos01)<= Range do
         local entry = {
                  name     = string.format("OP_Baum%d", table.getn(_Wald) + 1),
                  resource = 0,
                  ID       = 0,
                  status   = 0
             }
         entry.position = {
                  X = WaldPos01.X + GetRandom(100) - 50,
                  Y = WaldPos01.Y + GetRandom(100) - 50
          }
         entry.posF = {
            X = 0,
            Y = 0
          }
         if _OP_TestePos(entry.position) then
            entry.ID=CreateEntity(1, Entities.XD_ScriptEntity, entry.position, entry.name)
            table.insert( _Wald, entry )
         end
         WaldPos01.X = _opX( WaldPos01.X, abstand )
      end
      WaldPos01.Y = _opY( WaldPos01.Y, abstand2 )
      WaldPos01.X = _opX( _Pos.X, (abstand/2)*x )
      if x==0 then
         x=1
       else
         x=0
      end
   end
end
function _OP_GetRange(Start, Pos)
	local X  = Pos.X - Start.X
	local Y  = Pos.Y - Start.Y
	return math.sqrt( X*X + Y*Y)
end
function _OP_TestePos(_WaldPos)
	if _OP_CountEntitiesInArea(Entities.XD_ScriptEntity, _WaldPos, 200)>0 then
		return false
	end
	return true
end
function _OP_CleanUp(_position, _range)
	local Data = { Logic.GetEntitiesInArea( Entities.XD_TreeStump1, _position.X, _position.Y, _range, 20)}
	local i
	for i=2, Data[1]+1 do
		DestroyEntity(Data[i])
	end
end
function _OP_CountEntitiesInArea( _entityType, _position, _range)
   local Data = { Logic.GetEntitiesInArea( _entityType, _position.X, _position.Y, _range, 20)}
   return Data[1]
end
function Startgaertner2()
      _OP_counterGaertner2 = 2
      _OP_counterWachsen2 = 4
      _OP_NBaum2  = 0
      _OP_nextBaum2 = true
      _OP_OKBaum2 = true
      _OP_MaxBaeume2 = 0
      _OP_gaertnerPos2 = {}
      _OP_gaertnerPos12 = {}
      _OP_forest02 = {}
      _OP_gaertner2 = "gaertner2"
      _OP_forest02=_OP_CreateWald2(GetPosition("WaldEntity2"), 500, 1800)
      _OP_pflanzeBaeumeID2 = StartSimpleJob("_OP_pflanzeBaeume2")
      _OP_wachsedBaeumeID2 = StartSimpleJob("_OP_wachsedBaeume2")
      _OP_moveGaertnerID2 = 0
end
function _OP_wachsedBaeume2()
   _OP_counterWachsen2 = _OP_counterWachsen2 - 1
   if _OP_counterWachsen2 == 0 then
      local Ename = ""
      local Eresource = 0
      local DoFlag = true
	  local i
     for i=1,_OP_MaxBaeume2 do
      	 DoFlag = true
       	 Ename = _OP_forest02[i].name
      	 if _OP_forest02[i].status > 1 and _OP_forest02[i].status < 6 then
       	    Eresource = Logic.GetResourceDoodadGoodAmount(GetEntityId(Ename))
       	    if Eresource > 0 then
			   DoFlag = false
       	    end
       	    if _OP_CountEntitiesInArea( 0, _OP_forest02[i].position, 150)> 0 then
       	 	   DoFlag = false
       	    end
            local newEntityType = _OP_Grow[_OP_forest02[i].status]
            if newEntityType and not IsDead(Ename) and GetRandom(4) == 1 and DoFlag then
         	   _OP_forest02[i].status = _OP_forest02[i].status + 1;
         	   ReplaceEntity(Ename, newEntityType)
            end
         end
      end
      _OP_counterWachsen2 = 4
   end
end
function _OP_pflanzeBaeume2()
   _OP_counterGaertner2 = _OP_counterGaertner2 - 1
   if _OP_counterGaertner2 == 0 then
      local Ename = ""
      local i = 0
      local Epos = {}
      for i=1, _OP_MaxBaeume2 do
       	 Ename = _OP_forest02[i].name
       	 Epos  = {
       	   X = _OP_forest02[i].position.X,
       	   Y = _OP_forest02[i].position.Y
		 }
        if _OP_forest02[i].status == 1 then
         	if _OP_OKBaum2 then
        	       if _OP_CountEntitiesInArea( 0, Epos, 100) == 0 then
         	      _OP_nextBaum2 = true
         	      if ReplaceEntity(Ename, Entities.XD_Bush4)>0 then
         	         _OP_forest02[i].status = 2
         	        else
         	         _OP_forest02[i].status = -1
         	      end
        	   else
			   if _OP_forest02[i].posF.X == GetPosition(_OP_gaertner2).X and
					_OP_forest02[i].posF.Y == GetPosition(_OP_gaertner2).Y then
       	   	   			_OP_forest02[i].status = 0
       	       			_OP_nextBaum2 = true
       	       	else
        	       	_OP_forest02[i].posF.X = GetPosition(_OP_gaertner2).X 
					_OP_forest02[i].posF.Y = GetPosition(_OP_gaertner2).Y
				end         	
       	       	_OP_counterGaertner2 = 1
         	   end
         	else
   				_OP_forest02[i].status = 0
   				_OP_nextBaum2 = true
  	       		_OP_counterGaertner2 = 1
  	       	end
        end
        if _OP_forest02[i].status > 1 and IsDead(Ename) then
         	_OP_forest02[i].status = 0
         	_OP_CleanUp(Epos, 200)
            CreateEntity(1, Entities.XD_ScriptEntity, Epos, Ename)
         end
      end
      if not _OP_nextBaum2 then
		if _OP_counterGaertner2 == 0 then
	      	_OP_counterGaertner2 = 2
      	end
      	return
      end
	  local liste = {}
   	  for i=1,_OP_MaxBaeume2 do
   	  	 if _OP_forest02[i].status == 0 then
   	  	 	table.insert( liste, i )
   	  	 end
   	  end
   	  if table.getn(liste) == 0 then
	     _OP_counterGaertner2 = 5
   	  	 return
   	  end
   	  i = liste[GetRandom(table.getn(liste))+1]
      Ename = _OP_forest02[i].name
      local PosF  = {
       	   X = _OP_forest02[i].position.X - 1,
       	   Y = _OP_forest02[i].position.Y - 1
	  }
		_OP_nextBaum2 = false
   		_OP_forest02[i].status = 1
		_OP_NBaum2 = GetEntityId(Ename)
   		Move(GetEntityId(_OP_gaertner2), PosF, 0)
   		_OP_forest02[i].posF = {
      			X = GetPosition(_OP_gaertner2).X,
       			Y = GetPosition(_OP_gaertner2).Y
   		}
   		_OP_OKBaum2 = true
   		_OP_gaertnerPos2 = _OP_forest02[i].posF
   		_OP_gaertnerPos12 = _OP_forest02[i].posF
   		EndJob(_OP_pflanzeBaeumeID2)
   		_OP_moveGaertnerID2=StartSimpleJob("_OP_moveGaertner2")
		if _OP_counterGaertner2 == 0 then
	      _OP_counterGaertner2 = 2
      	end
   end
end
function _OP_moveGaertner2()
	if IsNear(GetEntityId(_OP_gaertner2), _OP_NBaum2, 50) then
  		Move(GetEntityId(_OP_gaertner2), _OP_gaertnerPos12, 0)
  		EndJob(_OP_moveGaertnerID2)
		_OP_pflanzeBaeumeID2=StartSimpleJob("_OP_pflanzeBaeume2")
        _OP_counterGaertner2 = 3
  	else
		if _OP_gaertnerPos2.X == GetPosition(_OP_gaertner2).X and
			_OP_gaertnerPos2.Y == GetPosition(_OP_gaertner2).Y then
			_OP_OKBaum2 = false
			EndJob(_OP_moveGaertnerID2)
			_OP_pflanzeBaeumeID2=StartSimpleJob("_OP_pflanzeBaeume2")
	        _OP_counterGaertner2 = 1
       	else
       	    _OP_gaertnerPos12 = _OP_gaertnerPos2
       	    _OP_gaertnerPos2.X = GetPosition(_OP_gaertner2).X 
			_OP_gaertnerPos2.Y = GetPosition(_OP_gaertner2).Y
		end         	
	end
end
function _OP_CreateWald2( _Pos, _Abstand, _Range)
   local Wald = {}
   local funcAdd = function( _n1, _n2 ) return _n1 + _n2 end
   local funcSub = function( _n1, _n2 ) return _n1 - _n2 end
   _OP_CreateSegment2( Wald, _Pos, _Abstand, _Range, funcAdd, funcAdd )
   _OP_CreateSegment2( Wald, _Pos, _Abstand, _Range, funcSub, funcAdd )
   _OP_CreateSegment2( Wald, _Pos, _Abstand, _Range, funcAdd, funcSub )
   _OP_CreateSegment2( Wald, _Pos, _Abstand, _Range, funcSub, funcSub )
   _OP_MaxBaeume2 = table.getn( Wald )
   return Wald
end
function _OP_CreateSegment2( _Wald, _Pos, _Abstand, _Range, _opX, _opY )
   local abstand = _Abstand				
   local Range  = _Range				
   local abstand2 = math.sqrt(abstand*abstand-(abstand/2)*(abstand/2))
   local WaldPos01 = {
       X = _Pos.X,
       Y = _Pos.Y
   }
   local x = 0
   local y = 0
   for y=0, Range/abstand2 do
   	while _OP_GetRange(_Pos, WaldPos01)<= Range do
         local entry = {
                  name     = string.format("OP2_Baum%d", table.getn(_Wald) + 1),
                  resource = 0,
                  ID       = 0,
                  status   = 0
             }
         entry.position = {
                  X = WaldPos01.X + GetRandom(100) - 50,
                  Y = WaldPos01.Y + GetRandom(100) - 50
          }
         entry.posF = {
            X = 0,
            Y = 0
          }
         if _OP_TestePos(entry.position) then
            entry.ID=CreateEntity(1, Entities.XD_ScriptEntity, entry.position, entry.name)
            table.insert( _Wald, entry )
         end
         WaldPos01.X = _opX( WaldPos01.X, abstand )
      end
      WaldPos01.Y = _opY( WaldPos01.Y, abstand2 )
      WaldPos01.X = _opX( _Pos.X, (abstand/2)*x )
      if x==0 then
         x=1
       else
         x=0
      end
   end
end
function DefeatJob1()
	if IsDead( defeatEntity ) then
		return EntityIsDead( defeatEntity );
	else
		defeatEntityPos = GetPosition( defeatEntity )
	end
end
function EntityIsDead( _entity )
	if _entity == "HQ1" then
		StartDefeat1Briefing();
		defeatEntity = "dario"
		return false;
	end
	if _entity == "steam2" then
		StartDefeat3Briefing();
		return false;
	end
	if _entity == "HQ2" then
		StartDefeat2Briefing();
		return true;
	end
	assert( false, "Auf tote Entity wurde nicht reagiert" );
end
function StartDefeat1Briefing()
	Defeat1Briefing = {}
		page = 0
		page = page + 1
		Defeat1Briefing[page]	 		= 	{}
		Defeat1Briefing[page].title		 	= "oopps!!!"
		Defeat1Briefing[page].text	 	=	"Ihr habt soeben Euer Hauptquartier verloren. @cr Sucht Euch dringenst ein neues Hauptquartier."
		Defeat1Briefing[page].position 		= defeatEntityPos
		Defeat1Briefing[page].explore	 =	BRIEFING_EXPLORATION_RANGE
		StartBriefing(Defeat1Briefing)
end
function StartDefeat2Briefing()
	Defeat2Briefing = {}
	Defeat2Briefing.finished = Defeat2BriefingFinished
	page = 0
		page = page + 1
		Defeat2Briefing[page]	 		= 	{}
		Defeat2Briefing[page].title		 	= "Tja!!!"
		Defeat2Briefing[page].text	 	=	"Sucht Euch dringenst ein neues Hauptquartier. @cr am Besten fangt ihr noch mal von vorne an!"
		Defeat2Briefing[page].position 		= defeatEntityPos
		Defeat2Briefing[page].explore	 =	BRIEFING_EXPLORATION_RANGE
	StartBriefing(Defeat2Briefing)
end
function Defeat2BriefingFinished()
	Defeat();
end
function StartDefeat3Briefing()
	Defeat3Briefing = {}
	Defeat3Briefing.finished = Defeat3BriefingFinished
	page = 0
		page = page + 1
		Defeat3Briefing[page]	 		= 	{}
		Defeat3Briefing[page].title		 	= "Huch!!!"
		Defeat3Briefing[page].text	 	=	"Schade! Die Maschine, die ihr hättet gebrauchen können, ist leider zerstört. @cr Naja, vielleicht klappts im nächsten Anlauf."
		Defeat3Briefing[page].position 		= GetPosition("steam2")
		Defeat3Briefing[page].explore	 =	BRIEFING_EXPLORATION_RANGE
	StartBriefing(Defeat3Briefing)
end
function Defeat3BriefingFinished()
	Defeat();
end
function CreateEntityNormal( _playerId, _entity, _position, _name )
  	local entityId = Logic.CreateEntity(_entity,_position.X,_position.Y, 0,_playerId)
 	if _name ~= nil then Logic.SetEntityName(entityId,_name) end 
	return entityId;
end

Briefing_ExtraOrig = Briefing_Extra;
Briefing_Extra = Briefing_ExtraWrapper;
function unpack2(_table, _i)
	_i = _i or 1;
	assert(type(_table) == "table");
	if _i <= table.getn(_table) then
		return _table[_i], unpack2(_table, _i + 1);
	end
end
StartBriefingUmlauteOrig = StartBriefing;
function StartBriefing( _briefing )
	StartBriefingUmlauteOrig( Umlaute( _briefing ) );
end
CreateNPCUmlauteOrig = CreateNPC;
function CreateNPC( _npc )
	CreateNPCUmlauteOrig (_npc)
end
MessageUmlauteOrig = Message;
function Message( _text )
	MessageUmlauteOrig( Umlaute( tostring( _text ) ) );
end
ResolveBriefingOrig = ResolveBriefing;
function ResolveBriefing( _page )

    if _page ~= nil then
        ResolveBriefingOrig( Umlaute( _page ) );
	else Message("function ResolveBriefing(): _page is nil. Is that a test?");
	end
end
--GetSelectedBriefingMCButtonOrig=GetSelectedBriefingMCButton
--function GetSelectedBriefingMCButton( _page )
--    return GetSelectedBriefingMCButtonOrig( Umlaute( _page ) );
--end
function CreateEffect( _player, _type, _position )
    assert(type(_player) == "number" and _player >= 1 and _player <= 8 and type(_type) == "number", "fatal error: wrong input: _player or _type (function CreateEffect())");
	assert((type(_position) == "table" and type(_position.X) == "number" and type(_position.Y) == "number") or type(_position) == "number" or type(_position) == "string", "fatal error: wrong input: _position (function CreateEffect())");
	
	if type(_position) == "table" then
	    assert(_position.X >= 1 and _position.Y >= 1 and _position.X < Logic.WorldGetSize() and _position.Y < Logic.WorldGetSize(), "error: wrong position-statement (function CreateEffect())" );
		local effect = Logic.CreateEffect(_type, _position.X, _position.Y, _player);
		return effect;
	elseif type(_position) == "string" then
	    local id = GetEntityId(_position);
		assert(not IsDead(id), "error: entity is dead or not existing (function CreateEffect())");
		local position = GetPosition(id);
		local effect = Logic.CreateEffect(_type, position.X, position.Y, _player);
		return effect;
	else
	    assert(not IsDead(_position), "error: entity is dead or not existing (function CreateEffect())");
		local position = GetPosition(_position);
		local effect = Logic.CreateEffect(_type, position.X, position.Y, _player);
		return effect;
	end
end
function DestroyEffect( _effect )
    assert(type(_effect) == "number", "fatal error: wrong input: _effect (function DestroyEffect()");
	Logic.DestroyEffect( _effect );
end
function Umlaute( _text )
	local texttype = type( _text );
	if texttype == "string" then
		_text = string.gsub( _text, "ä", "\195\164" );
		_text = string.gsub( _text, "ö", "\195\182" );
		_text = string.gsub( _text, "ü", "\195\188" );
		_text = string.gsub( _text, "ß", "\195\159" );
		_text = string.gsub( _text, "Ä", "\195\132" );
		_text = string.gsub( _text, "Ö", "\195\150" );
		_text = string.gsub( _text, "Ü", "\195\156" );
		return _text;
	elseif texttype == "table" then
		for k,v in _text do
			_text[k] = Umlaute( v );
		end
		return _text;
	else
		return _text;
	end
end
MapEditor_QuestTitle = "Lord Gareks Rache"
MapEditor_QuestDescription = "Lord Garek nimmt Rache, er hat viele Fallen aufgestellt, nehmt Euch in Acht!!!"
