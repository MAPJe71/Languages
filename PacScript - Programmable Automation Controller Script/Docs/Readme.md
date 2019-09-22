
# PacScript

## Description


## Links

_WWW_

_Wiki_


## Keywords
~~~
   A RegEx to find them all:

       \b(?!(?-i:
       )\b)
~~~


## Identifiers


## String Literals

### Single quoted

### Double quoted

### Document String - Double or Single Triple-Quoted

### Backslash quoted


## Comment

### Single line comment

### Multi line comment

### Block comment

### Java Doc

### Here Doc

### Now Doc


## Classes & Methods


## Function


## Grammar

BNF | ABNF | EBNF | XBNF
[PacScript] --------------------------------------------------------------------
@=PacScript (Programmable Automation Controller) by DENSO Robotics

   "PacScript" is designed to have high affinity with Microsoft's Visual Basic,
   based on a programming language for industrial robot "SLIM."

   Its specifications related to robot motions comply with "SLIM."

   Non-motion instructions not accompanied by robot motions such as flow
   control and arithmetic function have high affinity with Visual Basic.

_WWW_=http://densorobotics.com/

_Wiki_=

Keywords=

   Abs Accel AccMode ACos AddHandler AddPathPoint All And Approach ArchMove
   Area AreaPos AreaSize Arm Array Arrive As Asc ASin ATn ATn2 AVec

   Base BasePos Bin Bit BusyState Buzzer ByRef Byte ByVal

   Call CallByName Cao Case ChangeTool ChangeWork Chr Chuck
   ClearAreaDetected ClearEvents ClearLog ClearQueue ClearServoLog ClearUserMessage
   ClrErr ClrPathPoint ClrSplinePoint CollisionDetection Comm Component
   ContinueAll ContinueRun ConvertPosBase ConvertPosTool ConvertPosWork
   Cos CpMode CreateArray CreateMutex CreateObject CreateQueue Cross CrtMotionAllow
   CurAcc CurCPMode CurDec CurDHMode CurDHOffset CurDHParam CurErr CurExJ CurExtAcc
   CurExtDec CurExtSpd CurFig CurForceSensorPayLoad CurJAcc CurJDec CurJnt CurJSpd
   CurLmt CurOptMode CurPathPoint CurPayLoad CurPos CurSpd CurSpeedMode CurTool
   CurTrn CurWork

   D Date DeadmanState Debug Decel Declare DefDbl DefFlt Define DefInt DefIO DefJnt
   DefObj DefPos DefSng DefStr DefTrn DefVec DegRad Delay DeleteMutex DeleteQueue
   Depart DeQueue DestExJ DestJnt DestPos DestTrn DetectOff DetectOn Dev DevH DHMode
   Dim Dist Do Dot Double Dps Draw Drive DriveA

   ElIf Else ElseIf EmgState EncMotionAllow EncMotionAllowJnt Encrypt Encryption
   End EndIf EnQueue ErAlw Err ErrLvl ErrMsg Error Ex ExA ExclusiveArea
   ExclusiveControlStatus ExeCal Exit Exp ExtAccel ExtDecel ExtSpeed

   F False Fig FireUserMessage Fix Float For ForceChangeTable ForceCtrl ForceParam
   ForceSensor ForceSensorPayload ForceValue ForceWaitCondition Format Freeze Function

   gCao GetAreaDetected GetCollisionStatus GetConfig GetHandIO GetLanguage GetPathPoint
   GetPathPointCount GetPoint GetPriority GetPublicValue GetSplinePoint GetSrvData
   GetSrvJntData GetUserMessage GiveArm GiveMutex GoSub GoTo GrvCtrl GrvOffset

   Halt Hand Hex HighPathAccuracy Hold HoldState

   I If Ifdef Ifndef Import In Include InposState InStr InStrRev Int Integer
   Interrupt InvDev IO Is IsArray IsNothing

   J J2P J2T JAccel JDecel Join Joint JSpeed

   Keep Kill KillAll KillByName

   LBound LCase Left Len LenB Let LetA LetF LetJ LetO LetP LetR LetRx LetRy LetRz
   LetT LetX LetY LetZ LoadPathPoint LockState Log Log10 Long Loop LTrim Magnitude
   Max Mid Min Mod Mode MotionComplete MotionContinue MotionDone MotionMode
   MotionSkip MotionTime MotionTimeout Motor MotorState Move MoveA MoveAh MoveH
   MoveP MoveR MoveRh MoveZh Mps MsgBox MutexID MutexState

   Namespace Next NormalVector NormTrn Not Nothing Now NoWait

   Object Off On Optimize Or Org OrgState Out OutRange OVec

   P P2J P2T Page_Change PageChange PageChangeByName Pallet PanelInfo Pause PayLoad
   PeekQueue PI PosClr Pose Position PosRx PosRy PosRz Post PosX PosY PosZ Pow Pragma
   PrintDbg PrintMsg Private Program Public PVec PWMCtrl

   QueueCount QueueID QueueSize

   RadDeg Randomize ReadByteArray RealPath Rem RemoveHandler Reset ResetArea
   ResetDHOffset ResetExclusiveArea ResetMutex Result Resume Return Right Rnd RobInfo
   Robot Robot0 Robot1 Robot2 Robot3 Rotate RotateH Rpm RTrim Run RunByName RVec

   S SaveLog Select Set SetArea SetCollisionDetection SetConfig SetDHOffset SetErr
   SetExclusiveArea SetHandIO SetJntProperty SetJntCalset SetPriority SetPublicValue
   SetSplinePoint SetSrvData SetSrvJntData Sgn Short Sim Sin Single SingularAvoid
   Speed SpeedMode Split Sprintf Sqr SrvUnLock StackMemorize StackRepair StartLog
   StartServoLog Static Status StatusByName Step Stop StopLog StopServoLog Str String
   Sub Suspend SuspendAll SuspendByName SyncTime SysDiag SysInfo SysLog SysState

   T T2J T2P TakeArm TakeArmState TakeMutex Tan Tar_Exjnt Tar_Posture Tar_Time
   TaskInfo Then Time Timer TInv TMul TNorm To Tool ToolPos TrackApproach
   TrackArrivalTime TrackBufferDelete TrackBufferIndexes TrackBufferRead
   TrackBufferSort TrackConveyorSpd TrackConveyorVector TrackCount TrackCurBufferSort
   TrackCurPos TrackCurStartArea TrackDepart TrackEncoder TrackInitialize TrackInRange
   TrackMinimumIntervalLength TrackMove TrackOffsetMargin TrackPrepareData
   TrackSetMargin TrackSetRange TrackSetSensor TrackSetVision TrackStandbyPos
   TrackStart TrackStartArea TrackStop TrackTargetOffset TrackTargetPos
   TrackTargetRelease TrackGetCalData TrackSetCalData Trans Trim True

   UBound UCase Unchuck Undef Until UpdateWork

   V Val VarChangeType VarCreateArray Variant Vars VarType VCMode Vector Ver
   VibrationControl VibrationControlM VirtualFence Vis Void

   Wait Wend While Word Work WorkAttribute WorkPos WriteByteArray

   Xor XY XYH XZ XZH

   YX YXH YZ YZH

   ZForce ZonState ZX ZXH ZY ZYH


   A RegEx to find them all:

       \b(?!(?-i:
       )\b)

Identifiers=

   The first letter should be a character of alphabet [a to z].
   The second-to-last character should be alphabet [a to z], number or "_ (underscore)".
   These are case-insensitive. "Test01", "test01" and "TEST01" are recognized as identical characters.
   Only one-byte characters are available.
   The maximum number of characters that can be used for a name is 64.
   Reserved word cannot be used for a name.

StringLiterals=

Comment=

   For each comment in a program, a statement from an identifier of either of
   the following 2 types to the end of line (line break) is recognized as a
   comment.

   - Single quotation mark (')
   - Rem statement

Classes_and_Methods=

Function=

Grammar=

