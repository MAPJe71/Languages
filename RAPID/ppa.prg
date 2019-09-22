%%%
  VERSION:1
  LANGUAGE:ENGLISH
%%%
  
MODULE PPAMAIN
  !***********************************************************
  !
  ! File: PMppa340.prg
  !
  ! $Revision: 31 $
  !
  ! Description
  !   This is the main program for a pick and place 
  !   application.
  !
  ! Copyright (c) ABB Automation Technology Products 2002.
  ! All rights reserved
  !
  !***********************************************************
  
  !***********************************************************
  !
  ! Module: PPAMAIN
  !
  ! Description
  !   This is the main program module for a pick and 
  !   place application. 
  !
  !***********************************************************
  
  !***********************************************************
  !
  ! Procedure main
  !
  !   This is the PickMaster MAIN routine.
  !
  !***********************************************************
  PROC main()
    TPWrite "main";
    InCoordRout:=FALSE;
    InitSafeStop;
    InitSpeed;
    WHILE TRUE DO
      SetDO ppaExe,0;
      WaitForExeOrder:=TRUE;
      IF RemoteIPNode<>"" THEN
        SCWrite\ToNode:=RemoteIPNode,WaitForExeOrder;
      ENDIF
      WaitDO ppaExe,1;
      %RoutineName%;
    ENDWHILE

  ERROR (PPA_JUMP_MOVE)
    IF ERRNO = PPA_JUMP_MOVE THEN
      ClearPath;
      GotoRestartPos;
      RETRY;
    ELSEIF ERRNO=ERR_SC_WRITE THEN
      TRYNEXT;
    ENDIF
  ENDPROC

  !***********************************************************
  !
  ! Procedure InitSafeStop
  !
  !   This routine initiates the robot stop interrupt.
  !
  !***********************************************************
  PROC InitSafeStop()
    Reset doSafeStop;
    IDelete SafeStopSignal;
    CONNECT SafeStopSignal WITH SafeStopTrap;
    ISignalDO doSafeStop, 1, SafeStopSignal;
  ENDPROC

  !***********************************************************
  !
  ! Procedure InitTriggs
  !
  !   This routine sets the triggdata for the vacuum signals
  !   for all used item sources.
  !
  !***********************************************************
  PROC InitTriggs()
    FOR i FROM 1 TO MaxNoSources DO
      IF (ItmSrcData{i}.Used) THEN
        SetTriggs i;
      ENDIF
    ENDFOR
  ENDPROC

  !***********************************************************
  !
  ! Procedure InitPickTune
  !
  !   This routine initiates the tuning interrupt.
  !
  !***********************************************************
  PROC InitPickTune()
    Reset doTune;
    IDelete PickTuneInt;
    CONNECT PickTuneInt WITH PickTuneTrap;
    ISignalDO doTune, 1, PickTuneInt;
  ENDPROC

  !***********************************************************
  !
  ! Procedure SetTriggs
  !
  !   This routine sets the triggdata for the vacuum signals.
  !   This will be changed when more than one vacuum ejector
  !   is used.
  !
  !***********************************************************
  PROC SetTriggs(num Index)
    TEST ItmSrcData{Index}.SourceType
    CASE PICK_TYPE:
      TriggEquip ItmSrcData{Index}.VacuumAct1,0,ItmSrcData{Index}.VacActDelay\GOp:=goVacBlow1,1;
    CASE PLACE_TYPE:
      TriggEquip ItmSrcData{Index}.VacuumRev1,0,ItmSrcData{Index}.VacRevDelay\GOp:=goVacBlow1,2;
      TriggEquip ItmSrcData{Index}.VacuumOff1,0,ItmSrcData{Index}.VacOffDelay\GOp:=goVacBlow1,0;
    DEFAULT:
      TriggEquip ItmSrcData{Index}.VacuumAct1,0,ItmSrcData{Index}.VacActDelay\GOp:=goVacBlow1,1;
      TriggEquip ItmSrcData{Index}.VacuumRev1,0,ItmSrcData{Index}.VacRevDelay\GOp:=goVacBlow1,2;
      TriggEquip ItmSrcData{Index}.VacuumOff1,0,ItmSrcData{Index}.VacOffDelay\GOp:=goVacBlow1,0;
    ENDTEST
  ENDPROC

  !***********************************************************
  !
  ! Procedure InitSpeed
  !
  !   This routine sets the speed limits. It may be changed
  !   in different projects.
  !
  !***********************************************************
  PROC InitSpeed()
    MaxSpeed.v_tcp:=Vtcp;
    LowSpeed.v_tcp:=Vtcp/3;
    VeryLowSpeed.v_tcp:=250;
    VelSet 100,10000;
  ENDPROC

  !***********************************************************
  !
  ! Procedure pickplace
  !
  !   Initiate the final settings before starting the process
  !   and specify the pick-place cycle.
  !
  !***********************************************************
  PROC PickPlace()
    TPWrite "PickPlace";
    InCoordRout:=FALSE;
    ConfL\Off;
    MoveL SafePos,VeryLowSpeed,fine,Gripper\WObj:=wobj0;
    SetGO goVacBlow1,0;
    WaitTime 0.1;
    IndReset IRB,4\RefNum:=0\Short;
    WaitTime 0.2;
    PickPlaceRunning:=TRUE;
    IF RemoteIPNode<>"" THEN
      SCWrite\ToNode:=RemoteIPNode,PickPlaceRunning;
    ENDIF
    IF FirstTime=TRUE THEN
      FOR i FROM 1 TO MaxNoSources DO
        IF (ItmSrcData{i}.Used) THEN
          QStartItmSrc ItmSrcData{i}.ItemSource;
        ENDIF
      ENDFOR
      SetupIndexes;
      InitTriggs;
      InitPickTune;
      PickRateInit;
      FirstTime:=FALSE;
      WaitTime 0.2;
    ENDIF
    WHILE TRUE DO
      FOR i FROM 1 TO 2000 DO
        IF (StopProcess = TRUE) THEN
          StopProcess:=FALSE;
          SafeStop;
        ENDIF
        PickPlaceSeq;
        Incr Picks;
      ENDFOR
      MoveL SafePos,MaxSpeed,fine,Gripper\WObj:=wobj0;
      WaitTime 0.1;
      IndReset IRB,4\RefNum:=0\Short;
      WaitTime 0.2;
    ENDWHILE
  ERROR
    IF ERRNO=ERR_SC_WRITE THEN
      TRYNEXT;
    ENDIF
  ENDPROC

  !***********************************************************
  !
  ! Procedure SafeStop
  !
  !   This routine execute a movement to the SafeStop
  !   position and resets some variables.
  !
  !***********************************************************
  PROC SafeStop()
    VAR string time;
    VAR string date;
    
    InCoordRout:=FALSE;
    SafeStopExecuted:=FALSE;
    IDelete SafeStopSignal;
    TPWrite "Safe stop requested "+CDate()+" "+CTime();
    GotoRestartPos;
    WaitTime 0.1;
    IndReset IRB,4\RefNum:=0\Short;
    WaitTime 0.2;
    StopProcess:=FALSE;
    SafeStopExecuted:=TRUE;
    IF RemoteIPNode<>"" THEN
      SCWrite\ToNode:=RemoteIPNode,SafeStopExecuted;
    ENDIF
    ExitCycle;

  ERROR
    IF ERRNO=ERR_SC_WRITE THEN
      TRYNEXT;
    ENDIF
  ENDPROC
  
  !***********************************************************
  !
  ! Procedure GotoRestartPos
  !
  !   This routine moves the robot to the SafePos and will
  !   also acknowledge all item sources so the execution can
  !   be restarted.
  !
  !***********************************************************
  PROC GotoRestartPos()
    FOR i FROM 1 TO MaxNoSources DO
      IF (ItmSrcData{i}.Used) THEN
        TriggL SafePos,VeryLowSpeed,ItmSrcData{i}.Nack,fine,Gripper\WObj:=wobj0;
      ENDIF
    ENDFOR
    SetGO goVacBlow1,0;
  ENDPROC 

  !**********************************************************
  !
  ! Trap SafeStopTrap
  !
  !   This trap will run the SafeStop routine.
  !
  !**********************************************************
  TRAP SafeStopTrap
    Reset doSafeStop;
    SafeStop;
  ENDTRAP

  !**********************************************************
  !
  ! Trap PickTuneTrap
  !
  !   This trap sets the tune datas.
  !
  !**********************************************************
  TRAP PickTuneTrap
    Reset doTune;
    TEST TuneType
    CASE SPEED_TUNE:
      MaxSpeed.v_tcp:=Vtcp;
      LowSpeed.v_tcp:=Vtcp/3;
    CASE PICKPLACE_TUNE:
      IF ItmSrcData{SourceIndex}.Used THEN
        IF (ItmSrcData{SourceIndex}.SourceType = PICK_TYPE) THEN
          ItmSrcData{SourceIndex}.VacActDelay:=VacActDelay;
        ELSEIF (ItmSrcData{SourceIndex}.SourceType = PLACE_TYPE) THEN
          ItmSrcData{SourceIndex}.VacRevDelay:=VacRevDelay;        
          ItmSrcData{SourceIndex}.VacOffDelay:=VacOffDelay;        
        ELSE
          ItmSrcData{SourceIndex}.VacActDelay:=VacActDelay;
          ItmSrcData{SourceIndex}.VacRevDelay:=VacRevDelay;        
          ItmSrcData{SourceIndex}.VacOffDelay:=VacOffDelay;        
        ENDIF
        IF ItmSrcData{SourceIndex}.TrackPoint.Type = fllwtime THEN
          ItmSrcData{SourceIndex}.TrackPoint.followtime:=FollowTime;
        ELSEIF ItmSrcData{SourceIndex}.TrackPoint.Type = stoptime THEN
          ItmSrcData{SourceIndex}.TrackPoint.stoptime:=FollowTime;
        ENDIF
        ItmSrcData{SourceIndex}.OffsZ:=OffsZ;
        SetTriggs SourceIndex;
      ELSE
        ErrWrite "Tune not possible ","The workarea index "+ValToStr(SourceIndex)+" is an unused index";
      ENDIF
    ENDTEST
  ENDTRAP
  
ENDMODULE

MODULE PPASERVICE
  !***********************************************************
  !
  ! Module: PPASERVICE
  !
  ! Description
  !   This program module includes all service modules
  !   that i able to run from PickMaster.
  !   All service routine names and service variable should 
  !   be inserted in the persistant variables to be
  !   recognized by PickMaster.
  !
  !***********************************************************

  PERS string ServiceRoutine1:="Home";
  PERS string ServiceRoutine2:="WashDown";
  PERS string ServiceRoutine3:="TestCycle";
  PERS string ServiceRoutine4:="Homepos";
  PERS string ServiceRoutine5:="";
  PERS string ServiceRoutine6:="";
  PERS string ServiceRoutine7:="";
  PERS string ServiceRoutine8:="";
  PERS string ServiceRoutine9:="";
  PERS string ServiceRoutine10:="";
  
  PERS string ServiceVar1:="ServVar1";
  PERS string ServiceVar2:="ServVar2";
  PERS string ServiceVar3:="ServVar3";
  PERS string ServiceVar4:="";
  PERS string ServiceVar5:="";
  PERS string ServiceVar6:="";
  PERS string ServiceVar7:="";
  PERS string ServiceVar8:="";
  PERS string ServiceVar9:="";
  PERS string ServiceVar10:="";
  
  PERS num ServVar1:=0;
  PERS num ServVar2:=0;
  PERS num ServVar3:=0;

  !***********************************************************
  !
  ! Procedure Home
  !
  !   Service routine
  !
  !***********************************************************
  PROC Home()
    MoveL SafePos,VeryLowSpeed,fine,Gripper\WObj:=wobj0;
    TPWrite "Home Routine executed";
    ExitCycle;
  ENDPROC

  !***********************************************************
  !
  ! Procedure WashDown
  !
  !   Service routine
  !
  !***********************************************************
  PROC WashDown()
    TPWrite "WashDown Routine executed";
    ExitCycle;
  ENDPROC

  !***********************************************************
  !
  ! Procedure TestCycle
  !
  !   Service routine
  !
  !***********************************************************
  PROC TestCycle()
    TPWrite "TestCycle Routine executed";
    ExitCycle;
  ENDPROC

  !***********************************************************
  !
  ! Procedure Homepos
  !
  !   Service routine
  !
  !***********************************************************
  PROC Homepos()
    MoveAbsJ [[-11,-11,-11,0,0,0],[0,0,0,0,0,0]]\NoEOffs,VeryLowSpeed,fine,Gripper\WObj:=wobj0;
    ExitCycle;
  ENDPROC

ENDMODULE

MODULE PPAEXECUTING
  !***********************************************************
  !
  ! Module: PPAEXECUTING
  !
  ! Description
  !   This program module executes all movements when the
  !   process is running.
  !   Edit this module to customize the project.
  !
  !***********************************************************

  VAR num PickIndex1:=0;
  VAR num PickIndex2:=0;
  VAR num PickIndex3:=0;
  VAR num PickIndex4:=0;
  VAR num PickIndex5:=0;
  VAR num PickIndex6:=0;
  VAR num PickIndex7:=0;
  VAR num PickIndex8:=0;
  VAR num PlaceIndex1:=0;  
  VAR num PlaceIndex2:=0;  
  VAR num PlaceIndex3:=0;  
  VAR num PlaceIndex4:=0;  
  VAR num PlaceIndex5:=0;  
  VAR num PlaceIndex6:=0;  
  VAR num PlaceIndex7:=0;  
  VAR num PlaceIndex8:=0;  
  VAR num OtherIndex1:=0;  
  VAR num OtherIndex2:=0;  
  VAR num OtherIndex3:=0;  
  VAR num OtherIndex4:=0;  
  VAR num OtherIndex5:=0;  
  VAR num OtherIndex6:=0;  
  VAR num OtherIndex7:=0;  
  VAR num OtherIndex8:=0;  

  ! Definition of the item targets, are temporarely used in the pick and place routines.
  VAR itmtgt PickTarget:=[0,0,0,[[0,0,0],[0,-1,0,0],[0,0,0,0],[0,0,0,0,0,0]]];
  VAR itmtgt PlaceTarget:=[0,0,0,[[0,0,0],[0,-1,0,0],[0,0,0,0],[0,0,0,0,0,0]]];
  PERS wobjdata WObjPick:=[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];
  PERS wobjdata WObjPlace:=[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];
  
  ! Safe/stop position and where the intermediate points before pick/place should be placed.
  PERS robtarget SafePos:=[[0,0,-1000],[0,-1,0,0],[0,0,0,0],[0,0,0,0,0,0]];

  ! Set the TCP location and the tool load for current tool.
  PERS tooldata Gripper:=[TRUE,[[0,0,50],[1,0,0,0]],[0.1,[0,0,0.001],[1,0,0,0],0,0,0]];

  ! Set the payload for the items which is picked.
  PERS loaddata ItemLoad:=[0.001,[0,0,0.001],[1,0,0,0],0,0,0];

 
  !***********************************************************
  !
  ! Procedure SetupIndexes
  !
  !   Sets up the correct indexes for the different.
  !   The index is the same as the one that is set in the 
  !   PickMaster workarea.
  !   The default setup is only made to catch all workareas.
  !   Customize this for each project to get the correct
  !   indexes.
  !
  !***********************************************************
  PROC SetupIndexes()
    PickIndex1:=0;
    PickIndex2:=0;
    PickIndex3:=0;
    PickIndex4:=0;
    PickIndex5:=0;
    PickIndex6:=0;
    PickIndex7:=0;
    PickIndex8:=0;
    PlaceIndex1:=0;  
    PlaceIndex2:=0;  
    PlaceIndex3:=0;  
    PlaceIndex4:=0;  
    PlaceIndex5:=0;  
    PlaceIndex6:=0;  
    PlaceIndex7:=0;  
    PlaceIndex8:=0;  
    OtherIndex1:=0;  
    OtherIndex2:=0;  
    OtherIndex3:=0;  
    OtherIndex4:=0;  
    OtherIndex5:=0;  
    OtherIndex6:=0;  
    OtherIndex7:=0;  
    OtherIndex8:=0;  
    FOR i FROM 1 TO MaxNoSources DO
      IF (ItmSrcData{i}.Used) THEN
        IF (ItmSrcData{i}.SourceType = PICK_TYPE) THEN
          IF (PickIndex1 = 0) THEN
            PickIndex1:=i;
          ELSEIF (PickIndex2 = 0) THEN
            PickIndex2:=i;
          ELSEIF (PickIndex3 = 0) THEN
            PickIndex3:=i;
          ELSEIF (PickIndex4 = 0) THEN
            PickIndex4:=i;
          ELSEIF (PickIndex5 = 0) THEN
            PickIndex5:=i;
          ELSEIF (PickIndex6 = 0) THEN
            PickIndex6:=i;
          ELSEIF (PickIndex7 = 0) THEN
            PickIndex7:=i;
          ELSEIF (PickIndex8 = 0) THEN
            PickIndex8:=i;
          ENDIF
        ELSEIF (ItmSrcData{i}.SourceType = PLACE_TYPE) THEN
          IF (PlaceIndex1 = 0) THEN
            PlaceIndex1:=i;
          ELSEIF (PlaceIndex2 = 0) THEN
            PlaceIndex2:=i;
          ELSEIF (PlaceIndex3 = 0) THEN
            PlaceIndex3:=i;
          ELSEIF (PlaceIndex4 = 0) THEN
            PlaceIndex4:=i;
          ELSEIF (PlaceIndex5 = 0) THEN
            PlaceIndex5:=i;
          ELSEIF (PlaceIndex6 = 0) THEN
            PlaceIndex6:=i;
          ELSEIF (PlaceIndex7 = 0) THEN
            PlaceIndex7:=i;
          ELSEIF (PlaceIndex8 = 0) THEN
            PlaceIndex8:=i;
          ENDIF
        ELSE
          IF (OtherIndex1 = 0) THEN
            OtherIndex1:=i;
          ELSEIF (OtherIndex2 = 0) THEN
            OtherIndex2:=i;
          ELSEIF (OtherIndex3 = 0) THEN
            OtherIndex3:=i;
          ELSEIF (OtherIndex4 = 0) THEN
            OtherIndex4:=i;
          ELSEIF (OtherIndex5 = 0) THEN
            OtherIndex5:=i;
          ELSEIF (OtherIndex6 = 0) THEN
            OtherIndex6:=i;
          ELSEIF (OtherIndex7 = 0) THEN
            OtherIndex7:=i;
          ELSEIF (OtherIndex8 = 0) THEN
            OtherIndex8:=i;
          ENDIF
        ENDIF
      ENDIF
    ENDFOR
  ENDPROC

  !***********************************************************
  !
  ! Procedure PickPlaceSeq
  !
  !   The Pick and Place sequence. 
  !   Edit this routine to specify how the robot shall 
  !   execute the movements.
  !
  !***********************************************************
  PROC PickPlaceSeq()
	  Pick PickIndex1;
    Place PlaceIndex1;
	  !Place PlaceIndex2;   
  ENDPROC
  !***********************************************************
  !
  ! Procedure Pick
  !
  !   Executes a pick movement
  !
  !***********************************************************
  PROC Pick(num Index)
    InCoordRout:=TRUE;
    WObjPick:=ItmSrcData{Index}.Wobj;
    GetItmTgt ItmSrcData{Index}.ItemSource,PickTarget;
    TriggL\Conc,RelTool(PickTarget.RobTgt,0,0,-ItmSrcData{Index}.OffsZ),MaxSpeed,ItmSrcData{Index}.VacuumAct1,z20,Gripper\WObj:=WObjPick;
    MoveL\Conc,PickTarget.RobTgt,LowSpeed,z5\Inpos:=ItmSrcData{Index}.TrackPoint,Gripper\WObj:=WObjPick;
    GripLoad ItemLoad;
    TriggL RelTool(PickTarget.RobTgt,0,0,-ItmSrcData{Index}.OffsZ),LowSpeed,ItmSrcData{Index}.Ack,z20,Gripper\WObj:=WObjPick;
    InCoordRout:=FALSE;
  ENDPROC

  !***********************************************************
  !
  ! Procedure Place
  !
  !   Executes a place movement
  !
  !***********************************************************
  PROC Place(num Index)
    InCoordRout:=TRUE;
    WObjPlace:=ItmSrcData{Index}.Wobj;
    GetItmTgt ItmSrcData{Index}.ItemSource,PlaceTarget;
    MoveL\Conc,RelTool(PlaceTarget.RobTgt,0,0,-ItmSrcData{Index}.OffsZ),MaxSpeed,z20,Gripper\WObj:=WObjPlace;
    TriggL\Conc,PlaceTarget.RobTgt,LowSpeed,ItmSrcData{Index}.VacuumRev1\T2:=ItmSrcData{Index}.VacuumOff1,z5\Inpos:=ItmSrcData{Index}.TrackPoint,Gripper\WObj:=WObjPlace;
    GripLoad load0;
    TriggL RelTool(PlaceTarget.RobTgt,0,0,-ItmSrcData{Index}.OffsZ),LowSpeed,ItmSrcData{Index}.Ack,z20,Gripper\WObj:=WObjPlace;
    InCoordRout:=FALSE;
  ENDPROC

ENDMODULE
