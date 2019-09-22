%%%
  VERSION:1
  LANGUAGE:ENGLISH
%%%

MODULE PPACAL
  !***********************************************************
  !
  ! Module: PPACAL
  !
  ! $Revision: 1.2 $
  !
  ! Depending on
  !
  ! Description
  !   This program module prepares CNV1 or CNV2 for 
  !   vision to robot calibration using encoder board DSQC377.
  !
  ! Copyright (c) ABB Robotics Products AB 2000.  
  ! All rights reserved
  !
  !***********************************************************
  PERS tooldata Gripper:=[TRUE,[[0,0,0],[1,0,0,0]],[0.1,[0,0,0.001],[1,0,0,0],0,0,0]];
  PERS wobjdata WorkObject:=[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];
  PERS num RemoteMode:=0;
  VAR mecunit CnvMecUnit;
  VAR string CnvMecString:="";
  VAR datapos block;
  VAR num CnvNum:=0;
  VAR num IndNum:=0;
  VAR num CalibType:=0;
  VAR num ConfirmSave:=0;
  VAR intnum NewObj;
  VAR bool NewObjReported:=FALSE;
  VAR num ObjectPosition1:=0;
  VAR num ObjectPosition2:=0;
  VAR signaldo doRemAllPObj;
  VAR signaldo doDropWObj;
  VAR signaldo doPosInJobQ;
  VAR signaldi diNewObjStrobe;
  VAR signaldo doManSync;
  VAR signalgi giCount1FromEnc;
  VAR signalgi giCount2FromEnc;
  VAR signalgo goCount1ToEnc;
  VAR signalgo goCount2ToEnc;
  VAR signaldo doForceJob;
  VAR signaldo doCountToEncStr;

  !========================== main ===========================
  PROC main()
    TPErase;
    CalibType:=0;
    WorkObject:=wobj0;
    IF RemoteMode=0 THEN
      CnvName:="";
      NonCnvWobjName:="";
      TPWrite "WHICH KIND OF CALIBRATION DO YOU WANT TO DO?";
      TPReadFK CalibType,"CONVEYOR OR FIXED/INDEXED","","","","Cnv","Ind";
    ENDIF
    IF CnvName<>"" OR CalibType=4 THEN
      IF RemoteMode=0 THEN
        TPWrite "Vision to robot calibration.";
        TPWrite "DSQC377 version.";
        TPReadFK CnvNum,"Choose conveyor","CNV1","CNV2","CNV3","CNV4","MORE";
        IF CnvNum=5 THEN
          TPReadFK CnvNum,"Choose conveyor","CNV5","CNV6","","","";
          CnvNum:=CnvNum+4;
        ENDIF
        CnvName:="CNV"+ValToStr(CnvNum);
      ELSE
        TEST CnvName
        CASE "CNV1":
          CnvNum:=1;
        CASE "CNV2":
          CnvNum:=2;
        CASE "CNV3":
          CnvNum:=3;
        CASE "CNV4":
          CnvNum:=4;
        CASE "CNV5":
          CnvNum:=5;
        CASE "CNV6":
          CnvNum:=6;
        ENDTEST
      ENDIF
      GetDataVal "c"+ValToStr(CnvNum)+"RemAllPObj",doRemAllPObj;
      GetDataVal "c"+ValToStr(CnvNum)+"DropWObj",doDropWObj;
      GetDataVal "c"+ValToStr(CnvNum)+"PosInJobQ",doPosInJobQ;
      GetDataVal "c"+ValToStr(CnvNum)+"NewObjStrobe",diNewObjStrobe;
      GetDataVal "doManSync"+ValToStr(CnvNum),doManSync;
      GetDataVal "c"+ValToStr(CnvNum)+"Count1FromEnc",giCount1FromEnc;
      GetDataVal "c"+ValToStr(CnvNum)+"Count2FromEnc",giCount2FromEnc;
      GetDataVal "c"+ValToStr(CnvNum)+"Count1ToEnc",goCount1ToEnc;
      GetDataVal "c"+ValToStr(CnvNum)+"Count2ToEnc",goCount2ToEnc;
      GetDataVal "c"+ValToStr(CnvNum)+"ForceJob",doForceJob;
      GetDataVal "c"+ValToStr(CnvNum)+"CountToEncStr",doCountToEncStr;
      SetDataSearch "mecunit"\Object:=CnvName;
      IF GetNextSym(CnvMecString,block) THEN
        GetDataVal CnvMecString\Block:=block,CnvMecUnit;
      ELSE
        ErrWrite "UNKNOWN CONVEYOR",CnvName\RL2:="is an unknown conveyor name. Look in"\RL3:="the S4 MOC configuration file for"\RL4:="valid conveyor names.";
        Stop;
      ENDIF
      WorkObject.ufmec:=CnvName;
      WorkObject.ufprog:=FALSE;
      TPWrite "DELETING OBJECTS FROM CNV"+ValToStr(CnvNum);
      NewObjReported:=FALSE;
      IDelete NewObj;
      SetDO doRemAllPObj,0;
      SetDO doDropWObj,0;
      WaitTime 0.5;
      PulseDO doRemAllPObj;
      WaitTime 0.5;
      PulseDO doDropWObj;
      WaitTime 0.5;
      SetDO doPosInJobQ,1;
      ActUnit CnvMecUnit;
      WaitTime 0.5;
      DropWObj WorkObject;
      WaitTime 0.5;
      !
      TPWrite "WAITING FOR TRAP ON CNV"+ValToStr(CnvNum);
      CONNECT NewObj WITH ObjTrap;
      ISignalDI diNewObjStrobe,1,NewObj;
      PulseDO doManSync;
      WaitUntil NewObjReported=TRUE;
      SetSysData Gripper;
      SetSysData WorkObject;
      TPWrite "CNV"+ValToStr(CnvNum)+" READY FOR CALIB";
      WaitTime 3;
    ELSEIF NonCnvWobjName<>"" OR CalibType=5 THEN
      IF RemoteMode=0 THEN
        TPWrite "Vision to robot calibration.";
        TPReadFK IndNum,"Choose WorkObject","IdxWobj1","IdxWobj2","IdxWobj3","IdxWobj4","MORE";
        IF IndNum=5 THEN
          TPReadFK IndNum,"Choose WorkObject","IdxWobj5","IdxWobj6","IdxWobj7","IdxWobj8","";
          IndNum:=IndNum+4;
        ENDIF
        NonCnvWobjName:="IdxWobj"+ValToStr(IndNum);
      ELSE
        TEST NonCnvWobjName
        CASE "IdxWobj1":
          IndNum:=1;
        CASE "IdxWobj2":
          IndNum:=2;
        CASE "IdxWobj3":
          IndNum:=3;
        CASE "IdxWobj4":
          IndNum:=4;
        CASE "IdxWobj5":
          IndNum:=5;
        CASE "IdxWobj6":
          IndNum:=6;
        CASE "IdxWobj7":
          IndNum:=7;
        CASE "IdxWobj8":
          IndNum:=8;
        ENDTEST
      ENDIF
      SetSysData Gripper;
      SetSysData WorkObject;
      TPWrite "DEFINE CURRENT WORKOBJECT";
      TPWrite " ";
      TPWrite "CONTINUE RAPID EXECUTION WHEN READY";
      TPWrite "TO SAVE THE NEW WORKOBJECT DEFINITION";
      WaitTime 2;
      Stop;
      TPWrite " ";
      TPReadFK ConfirmSave,"DO YOU WANT TO SAVE THIS WOBJ DEF?","","","","Yes","No";
      IF ConfirmSave=4 THEN
        FOR i FROM 1 TO MaxNoSources DO
          IF NonCnvWOData{i}.NonCnvWobjName=NonCnvWobjName THEN
            NonCnvWOData{i}.Used:=TRUE;
            NonCnvWOData{i}.Wobj:=WorkObject;
          ENDIF
        ENDFOR
        Save "PPASYS"\File:="ppasys.sys";
      ENDIF
    ENDIF
  ENDPROC

  !======================== ObjTrap =========================
  TRAP ObjTrap
    TPWrite "READING/COPYING ENC COUNTERS FOR CNV"+ValToStr(CnvNum);
    ObjectPosition1:=GInput(giCount1FromEnc);
    ObjectPosition2:=GInput(giCount2FromEnc);
    WaitTime 0.2;
    SetGO goCount1ToEnc,ObjectPosition1;
    SetGO goCount2ToEnc,ObjectPosition2;
    WaitTime 0.2;
    PulseDO doForceJob;
    PulseDO doCountToEncStr;
    NewObjReported:=TRUE;
    RETURN;
  ENDTRAP
ENDMODULE

