MODULE MainModule
  TASK PERS wobjdata wobjTest:=[FALSE,TRUE,"",[[1000,-500,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];

  TASK PERS GfxShapeData sdAxe1:=[1,1,[[0,0,320],[0.993597,0,0,-0.112981]],[[0,0,-320],[1,0,0,0]],[360,640,0],0x80808080];
  TASK PERS GfxShapeData sdAxe2:=[1,2,[[311.831,-71.8451,780],[0.0154311,0.143682,0.692355,0.706938]],[[-90,0,-250],[0.70668,-0.70668,0.02468,-0.02468]],[200,1280,0],0x80808080];
  TASK PERS GfxShapeData sdAxe3:=[1,3,[[522.853,-192.298,2038.67],[0.631088,-0.686585,-0.169117,-0.318949]],[[150,-50,0],[1,0,0,0]],[350,200,0],0x80808080];
  TASK PERS GfxShapeData sdAxe4:=[1,4,[[686.438,-158.154,2168.96],[0.0994638,-0.815242,0.463396,-0.332793]],[[0,0,0],[1,0,0,0]],[250,1550,0],0x40ff0000];
  TASK PERS GfxShapeData sdAxe5:=[1,5,[[1697.03,-390.993,961.09],[0.843305,-0.388648,0.337122,-0.155367]],[[0,100,0],[0.70711,0.70711,0,0]],[120,200,0],0x40ff0000];
  TASK PERS GfxShapeData sdAxe6:=[1,6,[[1697.03,-390.993,961.09],[0.346228,-0.93815,-4.7145E-07,-3.04552E-07]],[[0,0,200],[1,0,0,0]],[120,100,0],0x80808080];

  TASK PERS GfxShapeData sdBord1:=[2,0,[[1000,-500,0],[1,0,0,0]],[[0,0,-800],[0.96225,0.257834,0.084186,-0.022558]],[1200,1000,100],0x80808080];
  TASK PERS GfxShapeData sdBord2:=[2,0,[[1000,-500,0],[1,0,0,0]],[[1,0.5,0],[0.707107,0.707107,0,0]],[1200,1000,100],0x40ff0000];
  TASK PERS GfxShapeData sdBord3:=[2,0,[[1000,-500,0],[1,0,0,0]],[[0,0,200],[1,0,0,0]],[1200,1000,100],0x80808080];
  TASK PERS GfxShapeData sdBord4:=[2,0,[[1000,-500,0],[1,0,0,0]],[[0,0,200],[1,0,0,0]],[1200,1000,100],0x80808080];

  PROC main()
    MoveJ [[1697.35,-261.14,808.66],[0.346228,-0.93815,-4.29186E-07,-2.28449E-07],[-1,0,-3,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],v1000,z50,tool0;
    PlaceGfxShapeData sdAxe1,CJointT()\ResetColor;
    PlaceGfxShapeData sdAxe2,CJointT()\ResetColor;
    PlaceGfxShapeData sdAxe3,CJointT()\ResetColor;
    PlaceGfxShapeData sdAxe4,CJointT()\ResetColor;
    PlaceGfxShapeData sdAxe5,CJointT()\ResetColor;
    PlaceGfxShapeData sdAxe6,CJointT()\ResetColor;
    sdBord1.poseCurrentAxis:=wobjTest.uframe;
    sdBord2.poseCurrentAxis:=wobjTest.uframe;
    sdBord3.poseCurrentAxis:=wobjTest.uframe;
    sdBord4.poseCurrentAxis:=wobjTest.uframe;
    sdBord1.dnColor:=0x80808080;
    sdBord2.dnColor:=0x80808080;
    sdBord3.dnColor:=0x80808080;
    sdBord4.dnColor:=0x80808080;

    IF IsOnCollision(sdAxe4,sdBord1) THEN
      TPWrite "Collision Axe4 Box1";
      sdAxe4.dnColor:=0x40FF0000;
      sdBord1.dnColor:=0x40FF0000;
    ENDIF
    IF IsOnCollision(sdAxe4,sdBord2) THEN
      TPWrite "Collision Axe4 Box2";
      sdAxe4.dnColor:=0x40FF0000;
      sdBord2.dnColor:=0x40FF0000;
    ENDIF
    IF IsOnCollision(sdAxe5,sdBord1) THEN
      TPWrite "Collision Axe5 Box1";
      sdAxe5.dnColor:=0x40FF0000;
      sdBord1.dnColor:=0x40FF0000;
    ENDIF
    IF IsOnCollision(sdAxe5,sdBord2) THEN
      TPWrite "Collision Axe5 Box2";
      sdAxe5.dnColor:=0x40FF0000;
      sdBord2.dnColor:=0x40FF0000;
    ENDIF
    IF IsOnCollision(sdAxe6,sdBord1) THEN
      TPWrite "Collision Axe6 Box1";
      sdAxe6.dnColor:=0x40FF0000;
      sdBord1.dnColor:=0x40FF0000;
    ENDIF
    IF IsOnCollision(sdAxe6,sdBord2) THEN
      TPWrite "Collision Axe6 Box2";
      sdAxe6.dnColor:=0x40FF0000;
      sdBord2.dnColor:=0x40FF0000;
    ENDIF
    
    UpdateRSComp;
  ENDPROC
ENDMODULE
