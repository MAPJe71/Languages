(*
 * (c) Copyright 1995, MAP Ltd., Veldhoven
 *
 * Function     : Pause!16.PAS
 *
 * Abstract     : Pause! Version 1.6
 *
 * Description  : see Summary
 *
 * Remarks      : á  ð Alt-225
 *                MV ð Menno A.P.J. Vogels
 *
 * History      : Version 1.4 source, ?
 *
 *                Version 1.5 source, 94-04
 *
 *  940608, removed command execution & added switch for repeating alert, MV
 *  940730, some miner modifications, MV
 *  950130, added some comment, MV
 *  950424, added GetFields-procedure & changed GetCommand-procedure, MV
 *
 *                Version 1.6 source, 95-mm
 *
 * Summary      :
 *)
program
  Pause (input,output);

{$M 4000,0,0}


(*---  USED UNITS  ---*)

uses
  Crt, Dos;


(*---  GLOBAL CONSTANTS  ---*)

const
  LowFrequency  = 50;
  DefFrequency  = 650;
  HighFrequency = 1950;
  MinTimeOn     = 5;
  MinTimeOff    = 5;


(*---  GLOBAL VARIABLES  ---*)

var
  Frequency,
  TimeOn,
  TimeOff    : Word;
  DoAlert,
  Multiple   : Boolean;


(*---  FUNCTION AND PROCEDURE DEFINITIONS  ---*)

(*
 * Function   : Init
 * Abstract   :
 * Decisions  :
 *)
procedure Init;
begin
  Frequency := DefFrequency;
  TimeOn    := 25;
  TimeOff   := 50;
  DoAlert   := FALSE;
  Multiple  := TRUE;
end; { of Init }

(*
 * Function   : UpStr
 * Abstract   : String to Upper Case
 * Decisions  : Converts all lower case characters of
 *              the input string to upper case
 *)
function UpStr(S: String): String;
var i: Integer;
begin
  for i := 1 to Length(S) do begin
    S[i] := UpCase(S[i]);
  end;
  UpStr := S;
end; { of UpStr }

(*
 * Function   : Str2Word
 * Abstract   : String to Word
 * Decisions  : Changes a string type identifier to
 *              a word type identifier
 *)
function Str2Word(S: String): Word;
var ErrorCode: Integer;
    W        : Word;
begin
  if Length(S) = 0 then
    Str2Word := 0
  else
    begin
      Val(S, W, ErrorCode);
      if ErrorCode = 0 then
        Str2Word := W
      else
        Str2Word := 0;
    end;
end; { of Str2Word }

(*
 * Function   : Alert
 * Abstract   :
 * Decisions  :
 *)
procedure Alert;
var I: Word;
begin
  I:=1;
  repeat
    Sound(Frequency);
    Delay(5);
    Inc(I);
  until KeyPressed or (I >= TimeOn);
  NoSound;
  I:=1;
  repeat
    Delay(5);
    Inc(I);
  until KeyPressed or (I >= TimeOff);
  NoSound;
end; { of Alert }

(*
 * Function   : CursorOff
 * Abstract   : Disable cursor display on the screen
 * Decisions  :
 *)
procedure CursorOff;
var Register: Registers;
begin
  Register.Ax := 1 SHL 8;
  Register.Cx := 14 SHL 8 +0;
  Intr($10, Register);
end; { of CursorOff }

(*
 * Function   : CursorOn
 * Abstract   : Enable cursor display on the screen
 * Decisions  :
 *)
procedure CursorOn;
var Register: Registers;
begin
  Register.Ax := 1 SHL 8;
  Register.Cx := 6 SHL 8 +7;
  Intr($10, Register);
end; { of CursorOn }

(*
 * Function   : Help
 * Abstract   : Display a 'help'-page on the screen
 * Decisions  :
 *)
procedure Help;
begin
  WriteLn;
  WriteLn('  Pause!  V1.6á                             MAP Ltd. ''94    ');
  WriteLn;
  WriteLn('   /?       : This Help                                     ');
  WriteLn('   /A       : Alert with Default Frequency & Dutycycle      ');
  WriteLn('   /A^      :            High                               ');
  WriteLn('   /A_      :            Low                                ');
  WriteLn('   /A:n,n,n : Custom Frequency, Alert time & Silence time   ');
  WriteLn('   /R       : Only one alert signal                         ');
  WriteLn('   eg. PAUSE! /a:850,5,25                                   ');
  WriteLn;
  CursorOn;
  Halt(0);
end; { of Help }

(*
 * Function     : GetFields
 *
 * Abstract     :
 *
 * Description  : Split the input string into two seperate strings,
 *                the 'splitter' indicates where the input string
 *                should be split in two
 *)
procedure GetFields(InStr   : String;
                    Splitter: Char;
                var OutStr1 : String;
                var OutStr2 : String;
                var OutStr3 : String);
var P, Nr: Byte;
    StrArray: array[1..3] of String;
begin
  Nr := 1;
  while Length(InStr) <> 0 do begin
    P := Pos(Splitter,InStr);
    if P = 0 then P := Length(InStr) +1;
    StrArray[Nr] := Copy(InStr, 1, P-1);
    Delete(InStr, 1, P);
    Inc(Nr);
  end;
  OutStr1 := StrArray[1];
  OutStr2 := StrArray[2];
  OutStr3 := StrArray[3];
end;

(*
 * Function   : GetCommand
 * Abstract   : Get the arguments from the command-line
 * Decisions  :
 *)
procedure  GetCommand;
var Count     : Byte;
    InStr     : ComStr;
    FreqStr,
    TimeOnStr,
    TimeOffStr: String;
begin
  for Count := 1 to ParamCount do begin
    InStr := UpStr(ParamStr(Count));
    if InStr[1] = '/' then
      case InStr[2] of
        'A': begin
               (*
                * Example for alert switch: /a:1900,5,25
                *)
               DoAlert := TRUE;
               if Length(InStr) > 2 then begin
                 case InStr[3] of
                   ':': begin
                          GetFields(Copy(InStr,4,Length(InStr) -3),
                                    ',',
                                    FreqStr,TimeOnStr,TimeOffStr);

                          (* Frequency <= 1900 *)
                          Frequency := Str2Word(FreqStr);

                          (* TimeOn <= 5 *)
                          TimeOn := Str2Word(TimeOnStr);
                          if TimeOn < MinTimeOn then TimeOn := MinTimeOn;

                          (* TimeOff <= 25 *)
                          TimeOff := Str2Word(TimeOffStr);
                          if TimeOff < MinTimeOff then TimeOff := MinTimeOff;

                          if Frequency = 0 then Frequency := HighFrequency;
                          if TimeOn > ((TimeOn+TimeOff) div 2) then begin
                            TimeOn  := MinTimeOn;
                            TimeOff := MinTimeOff;
                          end;
                        end;
                   '_':   Frequency := LowFrequency;
                   '^':   Frequency := HighFrequency;
                 end; {of case}
               end;
             end; { of case 'A' }
        'R': Multiple := FALSE;
        '?': Help;
        else begin
               WriteLn('Invalid option: ',InStr[2]);
               CursorOn;
               Halt(1);
             end;
      end; {of case}
  end; {for Count}
end; { of GetCommand }

(*
 * Function   : MAIN
 * Abstract   :
 * Decisions  :
 *)
BEGIN
  CursorOff;
  Init;
  GetCommand;
  Write ('Press a key to continue . . .');
  if NOT KeyPressed then
    if DoAlert then
      begin
        repeat
          Alert;
        until KeyPressed OR (NOT Multiple);
        repeat
        until KeyPressed;
      end
    else
      repeat
      until KeyPressed;
  WriteLn;
  CursorOn;
END. { of MAIN }