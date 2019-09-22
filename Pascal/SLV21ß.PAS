(*
 * (c) Copyright 1995, MAP Ltd., Veldhoven
 *
 * Function     : SLV21.PAS
 *
 * Abstract     : Source Lister Version 2.1
 *
 * Description  : see Summary
 *
 * History      : MV ð Menno A.P.J. Vogels
 *
 *                Version 1.9 source, 93-11
 *
 *   940122, added the headers and comment, MV
 *   940123, added comment, MV
 *   940124, added comment, I-option and UpStr, MV
 *   940125, added 'WAIT' indicators, MV
 *
 *                Version 2.0 source, 94-01
 *
 *   940423, split up copyright string, MV
 *   940509, changed help screen, MV
 *   940526, added UNIX switch indicator '-', MV
 *   940529, changed function 'IncludeIn',
 *           added conditional compilation directives, MV
 *   940607, added perforation skip option (partly !!), MV
 *   940611, added date & time for debugging log-file, MV
 *   940617, added the StripZeroParam function, MV
 *   940720, changed perforation skip implementation
 *           (CheckCurrentRow function), MV
 *   940727, changed Help procedure for new header implementation,
 *           changed Replace function, MV
 *   940728, added tabsize option, MV
 *   940729, changed ProcessLine procedure, MV
 *
 *                Version 2.1 source, 95-mm
 *
 * Summary      :
 *)
program
  Source__Lister (input,output);


(*---  USED UNITS  ---*)

uses
  Crt, Dos;


(*---  GLOBAL TYPES, see forward too  ---*)

type
  LPT_TYPE = (LPT1, LPT2, LPT3);


(*---  GLOBAL CONSTANTS  ---*)

{$IFDEF DEBUG}
const
  DebugFileName     = 'DEBUG.LOG';
{$ENDIF}

const
  PathLength        = 127;
  WorkStringLength  = 240;

  ProgramName       : array[1..13] of Byte =
                      { S   o   u   r   c   e       L   i   s   t   e   r }
                      ( 83,111,117,114, 99,101, 32, 76,105,115,116,101,114);
  Version           : array[1..12] of Byte =
                      { V   e   r   s   i   o   n       2   .   1   á }
                      ( 86,101,114,115,105,111,110, 32, 50, 46, 49,225);
  Company           : array[1..8] of Byte =
                      { M   A   P       L   t   d   . }
                      ( 77, 65, 80, 32, 76,116,100, 46);
  Year              : array[1..3] of Byte =
                      { '   9   4 }
                      ( 39, 57, 52);

  { Number of new lines for -one- vertical tab }
  VerticalTabLength = 3;

  { Horizontal positions in relation to current cursor position }
  InitPrinterStrX   = 2;
  InitPrinterIndX   = 0;
  ProcessStrX       = 2;
  ProcessIndX       = 0;

  { Vertical positions in relation to current cursor position }
  InitPrinterStrY   = 2;
  InitPrinterIndY   = 2;
  ProcessStrY       = 2;
  ProcessIndY       = 2;

  { Default values }
  DefLeftMargin     = 10;
  DefRightMargin    = 90;
  DefPrintLength    = 60;
  DefTabSize        = 8;

  { Character indicators }
  LeftMarginChar    = '[';
  RightMarginChar   = ']';
  PrintLengthChar   = '=';

  { Minimum values }
  LeftMarginMin     = 5;
  RightMarginMin    = LeftMarginMin +2;
  PrintLengthMin    = 5;
  TabSizeMin        = 1;

  { Maximum values }
  RightMarginMax    = 255;
  LeftMarginMax     = RightMarginMax -2;
  PrintLengthMax    = 255;
  TabSizeMax        = 255;

  { Different forms that the include compiler directive can take }
  IncludeSearch : array[1..4] of String[5] =
                  ('{$'+'I',
                   '{$'+'i',
                   '(*$'+'I',
                   '(*$'+'i'
                  );

  { Option switch indicators }
  SwitchInd     = ['/','-'];

  { Status phase indicators }
  StatusStr     : array[0..4] of String[51] =
                  ('                                                   ',
                   'ADD PAPER TO THE OUTPUT DEVICE !!!                 ',
                   'PRESS THE -ON LINE- BUTTON ON THE OUTPUT DEVICE !!!',
                   'THE OUTPUT DEVICE IS BUSY, PLEASE WAIT !!!         ',
                   'Undetermined ERROR, CHECK IT OUT !!!               '
                  );

  { Process phase indicators }
  ProcessStr    : array[1..2] of String[15] =
                  ('Printing file  ',
                   '  completed    '
                  );

  { Output device identifiers }
  LPTByte       : array[LPT_TYPE] of Byte = (0,1,2);
  LPTString     : array[LPT_TYPE] of String[4] =
                  ('LPT1',
                   'LPT2',
                   'LPT3'
                  );

(*---  GLOBAL TYPES  ---*)

type
  WORK_STRING  = String[WorkStringLength];


(*---  GLOBAL VARIABLES  ---*)

var
  CurrentRow,
  CurrentY,
  RightMargin,
  LeftMargin,
  PageWidth,
  PrintLength,
  TabSize,
  ProcessStage     : Byte;
  MainFileName     : ComStr;
  MainFile         : Text;
  LPT              : LPT_TYPE;
  SkipPerforation,
  Quality,
  Include          : Boolean;


(*---  FUNCTION AND PROCEDURE DEFINITIONS  ---*)

{$IFDEF DEBUG}
(*
 * Function   : LeadingZero
 * Abstract   : Converts a word type identifier to a string type
 *              identifier and adds a zero to give the string a
 *              length of two characters
 * Decisions  :
 *)
function LeadingZero(W: Word): String;
var S: String;
begin
  Str(W:0, S);
  if Length(S) = 1 then S := '0' +S;
  LeadingZero := S;
end; { of LeadingZero }

(*
 * Function   : DateAndTime
 * Abstract   : Composes a string containing the name of the day (three
 *              characters), the date and the time of the operating system
 * Decisions  :
 *)
function DateAndTime: String;
const Days: String[21] = 'SunMonTueWedThuFriSat';
      TimeDelimiter = ':';
      DateDelimiter = '-';
var hour, min, sec, hund, year, mon, day, dow: Word;
    DayName, Date, Time: String;
begin
  GetTime(hour, min, sec, hund);
  Time := LeadingZero(hour) +TimeDelimiter +
          LeadingZero(min)  +TimeDelimiter +
          LeadingZero(sec)  +TimeDelimiter +
          LeadingZero(hund);
  GetDate(year, mon, day, dow);
  Date := LeadingZero(day)  +DateDelimiter +
          LeadingZero(mon)  +DateDelimiter +
          LeadingZero(year);
  DayName := Copy(Days, (3 *dow) +1, 3);
  DateAndTime := DayName +' ' +Date +' ' +Time;
end; { of DateAndTime }
{$ENDIF}

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
 * Function   : Replicate
 * Abstract   : Repeat the input character a number of times
 * Decisions  :
 *)
function Replicate(C:Char; N:Byte): String;
var TempStr: String;
begin
  if N = 0 then
    TempStr := ''
  else
    begin
      if (N > 255) then N := 1;
      FillChar(TempStr, N+1, C);
      TempStr[0] := Chr(N);
    end;
  Replicate := Tempstr;
end; { of Replicate }

(*
 * Function   : Replace
 * Abstract   : Replaces every 'OldStr' in the source-string by 'NewStr',
 *              if the source-string is shorter or there is no match, then
 *              the source-string will not be changed
 * Decisions  :
 *)
procedure Replace(var Src: String; OldStr, NewStr: String);
var TempStr,S: String;
    P: Word;
begin
  TempStr := Src;
(*  94-07-27, MV
 * for P := (Length(Src)-Length(OldStr) +1) downto 1 do begin
 *   if Src[P] = OldStr[1] then begin
 *     S := Copy(Src, P, Length(OldStr));
 *     if S = OldStr then begin
 *       Delete(TempStr, P, Length(OldStr));
 *       Insert(NewStr, TempStr, P);
 *     end;
 *   end;
 * end;
 *)
  repeat
    P := Pos(OldStr, TempStr);
    if P <> 0 then begin
      Delete(TempStr, P, Length(OldStr));
      Insert(NewStr, TempStr, P);
    end;
  until P = 0;
(*
 *)
  Src := TempStr;
end; { of Replace }

(*
 * Function   : InProcess
 * Abstract   : Display a process-indicator on the screen
 * Decisions  :
 *)
procedure InProcess(X,Y,B: Byte);
const Process: array[1..10] of Char = ('Ä','\','³','/', { Process indicators }
                                       '*',             { End of process     }
                                       '>',' ','>',' ', { Wait indicators    }
                                       ' '              { End of wait        }
                                      );
      Wait   = 500;
begin
  GotoXY(X,Y);
  case B of
    1: ProcessStage := 1;               { Begin of the process         }
    2: begin                            { In the middle of the process }
         if ProcessStage < 4 then
           Inc(ProcessStage)
         else
           ProcessStage := 1;
       end;
    3: ProcessStage := 5;               { End of the process           }

    4: ProcessStage := 6;               { Begin of the wait            }
    5: begin                            { In the middle of the wait    }
         if ProcessStage < 9 then
           Inc(ProcessStage)
         else
           ProcessStage := 6;
         Delay(Wait);
       end;
    6: ProcessStage := 10;              { End of the wait              }
  end; {of case}
  Write(Process[ProcessStage]);
end; { of InProcess }

(*
 * Function   : Initialize
 * Abstract   :
 * Decisions  :
 *)
procedure Initialize;
begin
  CurrentRow      := 0;
  CurrentY        := WhereY;
  { Start with a clear screen when the current screen is almost full }
  if CurrentY > 20 then begin
    ClrScr;
    CurrentY := WhereY;
  end;
  LeftMargin      := DefLeftMargin;
  RightMargin     := DefRightMargin;
  PageWidth       := RightMargin -LeftMargin;
  PrintLength     := DefPrintLength;
  TabSize         := DefTabSize;

  { Default: skip the perforation of pinfeed paper }
  SkipPerforation := TRUE;

  { Default: print in Near Letter Quality }
  Quality         := TRUE;

  { Default: include the include-file source }
  Include         := TRUE;

  { Default: output device LPT1 }
  LPT             := LPT1;
end; { of initialize }

(*
 * Function   : WriteLPT
 * Abstract   : Write a string to the output device,
 *              excluding (without) a carriage return
 * Decisions  :
 *)
procedure WriteLPT(S: String);
var F: Text;
begin
{$IFNDEF DEBUG}
  Assign(F, LPTString[LPT]);
  Rewrite(F);
    Write(F, S);
  Close(F);
{$ELSE}
  Assign(F, DebugFileName);
  {$I-}
  Append(F);
  {$I+}
  if IOResult <> 0 then ReWrite(F);     { file not found -> create it  }
  if S <> Chr(12) then Write(F, S);     { write string unless formfeed }
  Close(F);
{$ENDIF}
end; { of WriteLPT }

(*
 * Function   : WriteLnLPT
 * Abstract   : Write a string to the output device,
 *              including a carriage return
 * Decisions  :
 *)
procedure WriteLnLPT(S: String);
var F: Text;
begin
{$IFNDEF DEBUG}
  Assign(F, LPTString[LPT]);
  Rewrite(F);
    WriteLn(F, S);
  Close(F);
{$ELSE}
  Assign(F, DebugFileName);
  {$I-}
  Append(F);
  {$I+}
  if IOResult <> 0 then Rewrite(F);     { file not found -> create it  }
  if S <> Chr(12) then WriteLn(F, S);   { write string unless formfeed }
  Close(F);
{$ENDIF}
end; { of WriteLnLPT }

(*
 * Function   : PrinterStatus
 * Abstract   : Get the status of the connected output device
 * Decisions  :
 *)
function PrinterStatus: Byte;
var Register: Registers;
begin
  with Register do begin
    Ah := 2;
    Dx := LPTByte[LPT];
    Intr($17, Register);

      if (Ah AND $B8) = $90 then PrinterStatus := 0   { all is well         }
    else
      if (Ah AND $20) = $20 then PrinterStatus := 1   { device out of paper }
    else
      if (Ah AND $10) = $00 then PrinterStatus := 2   { device off line     }
    else
      if (Ah AND $80) = $00 then PrinterStatus := 3   { device is busy      }
    else
      if (Ah AND $08) = $08 then PrinterStatus := 4;  { undetermined error  }
  end;
end; { of PrinterStatus }

(*
 * Function   : InitializePrinter
 * Abstract   : Initialize the connected output device
 * Decisions  :
 *)
procedure InitializePrinter;
const Draft = #27+'x'+'0';      { EPSON }
      NLQ   = #27+'x'+'1';      { EPSON }
      Elite = #27+'M';          { EPSON }
      PrinterReady: Boolean = FALSE;
begin
  InProcess(1 +InitPrinterIndX, CurrentY +InitPrinterIndY, 4);
  repeat
    GotoXY(1 +InitPrinterStrX, CurrentY +InitPrinterStrY);
    case PrinterStatus of
      0: begin
           PrinterReady := TRUE;
           Write(StatusStr[0]);
         end;
      1:   Write(StatusStr[1]);
      2:   Write(StatusStr[2]);
      3:   Write(StatusStr[3]);
      4: begin
           Write(StatusStr[4]);
           CursorOn;
           Halt(0);
         end;
    end; { of case }
    InProcess(1 +InitPrinterIndX, CurrentY +InitPrinterIndY, 5);
  until PrinterReady;
  InProcess(1 +InitPrinterIndX, CurrentY +InitPrinterIndY, 6);

  if PrinterReady then begin
    if Quality then
      WriteLPT(NLQ +Elite)
    else
      WriteLPT(Draft +Elite);
  end;
end; { of InitializePrinter }

(*
 * Function   : Open
 * Abstract   : Open a file
 * Decisions  :
 *)
function Open(var fp:Text; Name:ComStr): Boolean;
begin
  Assign(fp, Name);
  {$I-}
  Reset(fp);
  {$I+}
  Open := IOResult = 0;
end; { of Open }

(*
 * Function   : UpStr
 * Abstract   : Converts all lower case characters of
 *              the input string to upper case
 * Decisions  :
 *)
function UpStr(S: String): String;
var i: Word;
begin
  for i := 1 to Length(S) do begin
    S[i] := UpCase(S[i]);
  end;
  UpStr := S;
end; { of UpStr }

(*
 * Function   : Int2Str
 * Abstract   : Convert an integer-type to a string-type
 * Decisions  :
 *)
function Int2Str(I: Integer): String;
var S: String;
begin
  Str(I:3, S);
  Int2Str := S;
end; { of Int2Str }

(*
 * Function   : Str2Int
 * Abstract   : Convert a string type to an integer-type
 * Decisions  :
 *)
function Str2Int(Str:ComStr; FirstPos,LastPos:Byte; Option:Char): Integer;
var Int, ErrorCode: Integer;
begin
  Inc(FirstPos);
  Int := FirstPos;
  While (Int <= LastPos) AND (Str[Int] in ['0'..'9']) do Inc(Int);
  Str := Copy(Str, FirstPos, Int -FirstPos);
  Val(Str, Int, ErrorCode);
  case Option of
    LeftMarginChar :
      begin
        if Int < LeftMarginMin then Int := LeftMarginMin;
        if Int > LeftMarginMax then Int := LeftMarginMax;
      end;
    RightMarginChar:
      begin
        if Int < RightMarginMin then Int := RightMarginMin;
        if Int > RightMarginMax then Int := RightMarginMax;
      end;
    PrintLengthChar:
      begin
        if Int < PrintLengthMin then Int := PrintLengthMin;
        if Int > PrintLengthMax then Int := PrintLengthMax;
      end;
    'T':
      begin
        if Int < TabSizeMin then Int := TabSizeMin;
        if Int > TabSizeMax then Int := TabSizeMax;
      end;
  end;
  if ErrorCode = 0 then Str2Int := Int;
end; { of Str2Int }

(*
 * Function   : DefDrive
 * Abstract   : Get the default drive of the current system
 * Decisions  :
 *)
function  DefDrive: String;
var P: String;
begin
  GetDir(0, P);
  DefDrive := P[1] +':';
end; { of DefDrive }

(*
 * Function   : StripZeroParam
 * Abstract   : Strip the first commandline parameter-string
 * Decisions  : The first parameter-string from the commandline
 *              contains the full path and name of the program
 *              that is executed. Strip the path and the extension
 *              of the executable so that its name remains.
 *)
function StripZeroParam: String;
var TempStr: String;
begin
  TempStr := ParamStr(0);
  while Pos('\', TempStr) <> 0 do Delete(TempStr, 1, Pos('\', TempStr));
  if Pos('.', TempStr) <> 0 then
    Delete(TempStr, Pos('.', TempStr), Length(TempStr)-(Pos('.', TempStr)-1));
  StripZeroParam := TempStr;
end; { of StripZeroParam }

(*
 * Function   : Help
 * Abstract   : Display a 'help'-page on the screen
 * Decisions  :
 *)
procedure  Help;
var NumberOfSpaces,b: Byte;
    TempStr: String;
begin
  TempStr := StripZeroParam;
  NumberOfSpaces :=
    80 -                        { screen width                         }
    (2 +                        { left margin                          }
     SizeOf(ProgramName) +      { size of the ProgramName array        }
     2 +                        { space between ProgamName & Version   }
     SizeOf(Version) +          { size of the Version array            }
     1 +                        { min. space between Version & Company }
     SizeOf(Company) +          { size of the Company array            }
     1 +                        { space between Company & Year         }
     SizeOf(Year) +             { size of the Year array               }
     2                          { rigth margin                         }
    );
  WriteLn;
  Write  ('  ');
  for b := 1 to SizeOf(ProgramName) do Write(Chr(ProgramName[b]));
  Write  ('  ');
  for b := 1 to SizeOf(Version)     do Write(Chr(Version[b]));
  Write  (' '+Replicate(' ',NumberOfSpaces));
  for b := 1 to SizeOf(Company)     do Write(Chr(Company[b]));
  Write  (' ');
  for b := 1 to SizeOf(Year)        do Write(Chr(Year[b]));
  WriteLn;
  WriteLn;
  WriteLn('  Usage   : '+TempStr+' [/|-][options] [drive:][path]file');
  WriteLn('  Options :');
  Write  ('    '+LeftMarginChar +'nnn  Leftmargin,   default = '+Int2Str(DefLeftMargin) +' ');
  WriteLn('    Q   NLQ printing -off-');
  Write  ('    '+RightMarginChar+'nnn  Rightmargin,  default = '+Int2Str(DefRightMargin)+' ');
  WriteLn('    I   Exclude the include-file source');
  Write  ('    '+PrintLengthChar+'nn   Pagelength,   default = '+Int2Str(DefPrintLength)+' ');
  WriteLn('    S   Skip paper perforation -off-');
  Write  ('    Pn    Printer port, default = '+Int2Str(LPTByte[LPT]+1)+' ');
  WriteLn('    (1 = LPT1, 2 = LPT2, 3 = LPT3)');
  WriteLn('    Tnnn  Tabsize,      default = '+Int2Str(DefTabSize)+' ');
  WriteLn('  Examples: '+TempStr+' /'+LeftMarginChar+'30qI'+RightMarginChar+'75'+PrintLengthChar+'66 c:\demo.pas');
  WriteLn('            '+TempStr+' -'+LeftMarginChar+'30 -Q /i /'+PrintLengthChar+'66 c:\demo.pas');
  WriteLn('            '+TempStr+' c:\demo.pas');
  WriteLn;
  CursorOn;
  Halt(0);
end; { of Help }

(*
 * Function   : GetCommand
 * Abstract   : Get the arguments from the command-line
 * Decisions  :
 *)
procedure  GetCommand(var Path: ComStr);
var ParCnt,ParStrPos,LenParStr: Byte;
    ParStr: ComStr;
begin
  for ParCnt := 1 to ParamCount do begin
    ParStr := UpStr(ParamStr(ParCnt));
    LenParStr := Length(ParStr);
    if ParStr[1] in SwitchInd then
      for ParStrPos := 2 to LenParStr do begin
        case ParStr[ParStrPos] of
          'I': Include := FALSE;
          'P': case ParStr[ParStrPos+1] of
                 '2': LPT := LPT2;
                 '3': LPT := LPT3;
                 else LPT := LPT1;
               end; {of case}
          'Q': Quality := FALSE;
          'S': SkipPerforation := FALSE;
          'T':
            TabSize     := Str2Int(ParStr,ParStrPos,LenParStr,'T');
          LeftMarginChar:
            LeftMargin  := Str2Int(ParStr,ParStrPos,LenParStr,LeftMarginChar);
          RightMarginChar:
            RightMargin := Str2Int(ParStr,ParStrPos,LenParStr,RightMarginChar);
          PrintLengthChar:
            PrintLength := Str2Int(ParStr,ParStrPos,LenParStr,PrintLengthChar);
          '0'..'9': { Skip all digits };
          else begin
                 WriteLn('Invalid option: ',ParStr[ParStrPos]);
                 CursorOn;
                 Halt(1);
               end;
        end; {of case}
      end {of for StrPos}
    else
      Path := ParStr;
  end; {of for Count}

  if RightMargin <= LeftMargin then begin
    LeftMargin  := DefLeftMargin;
    RightMargin := DefRightMargin;
  end;
  PageWidth := RightMargin -LeftMargin;
end; { of GetCommand }

(*
 * Function   : OpenMain
 * Abstract   : Open the main file to be sent to the output device
 * Decisions  :
 *)
procedure OpenMain;
begin
  if ParamCount = 0 then
    Help
  else
    begin
      MainFileName := Chr(0);
      GetCommand(MainFileName);
    end;

  if (MainFileName = Chr(0)) OR NOT Open(MainFile,MainFileName) then begin
    WriteLn('ERROR:  file not found ('+MainFileName+')');
    CursorOn;
    Halt(2);
  end;
end; { of OpenMain }

(*
 * Function   : HorizontalTab
 * Abstract   : Tabulate horizontal
 * Decisions  : Write a given amount of spaces
 *)
procedure HorizontalTab;
var w: Word;
begin
  for w := 1 to LeftMargin do begin
    WriteLPT(' ');
    if (w MOD 2) = 0 then
      InProcess(1 +ProcessIndX, CurrentY +ProcessIndY, 2);
  end;
end; { of HorizontalTab }

(*
 * Function   : VerticalTab
 * Abstract   : Tabulate vertical
 * Decisions  : Write a given amount of new-lines
 *)
procedure VerticalTab;
var w: Word;
begin
  for w := 1 to VerticalTabLength do begin
    WriteLnLPT('');
    if (w MOD 2) = 0 then
      InProcess(1 +ProcessIndX, CurrentY +ProcessIndY, 2);
  end;
end; { of VerticalTab }

(*
 * Function   : CheckCurrentRow
 * Abstract   : Check the current (present) row
 * Decisions  : Go to a new page if the max number of lines on the present
 *              page has been reached
 *)
procedure CheckCurrentRow;
begin
  if CurrentRow >= PrintLength then begin
    if SkipPerforation then
      begin
{$IFDEF DEBUG}
        WriteLnLPT('*** FORMFEED (PERFORATION SKIP) ***');
{$ENDIF}
        WriteLPT(Chr(12)); { Formfeed }
        VerticalTab;
{$IFDEF DEBUG}
      end
    else
      begin
        WriteLnLPT('*** NO PERFORATION SKIP ***');
{$ENDIF}
      end;
    CurrentRow := 0;
  end;
end; { of CheckCurrentRow }

(*
 * Function   : ProcessLine
 * Abstract   : Process the present line
 * Decisions  : Write the string from the buffer to the output device
 *)
procedure ProcessLine(PrintStr: WORK_STRING);
const TabChr= Chr(9);
var TempStr: String;
begin
  TempStr := PrintStr;
  Replace(TempStr, TabChr, Replicate(' ',TabSize));
                              { replace every tab-character by a               }
                              { given amount of spaces                         }

  CheckCurrentRow;
  Inc(CurrentRow);            { indicate which line is processed               }
  HorizontalTab;

  while Length(TempStr) > PageWidth do begin
    WriteLnLPT(Copy(TempStr, 1, PageWidth));
    Delete(TempStr, 1, PageWidth);
    CheckCurrentRow;          { check if the page is full                      }
    Inc(CurrentRow);          { indicate that next line will be processed      }
    HorizontalTab;
  end;

  WriteLnLPT(TempStr);        { the full line or the remaining part            }

  if TempStr = Chr(12) then begin
    VerticalTab;
    CurrentRow := 0;
  end;
end; { of ProcessLine }

(*
 * Function   : IncludeIn
 * Abstract   : Check if include file definition in main file source
 * Decisions  :
 *)
function IncludeIn(var CurStr: WORK_STRING): Boolean;
var Column,Number: Byte;
    ChkChar: Char;
begin
  Number := 0;
  repeat
    Inc(Number);
    Column := Pos(IncludeSearch[Number], CurStr)
  until (Number = 4) OR (Column <> 0);
  if (Column <> 0) AND
     (CurStr[Column +Length(IncludeSearch[Number])] = ' ') then
    IncludeIn := TRUE
  else
    IncludeIn := FALSE;
end; { of IncludeIn }

(*
 * Function   : Parse
 * Abstract   : Get the include-filename from the line-buffer
 * Decisions  :
 *)
procedure Parse(IncStr: WORK_STRING;var IncludeFileName: ComStr);
var NameStart, NameEnd: Integer;
begin
  NameStart := Pos('$I', IncStr) +2;
  while IncStr[NameStart] = ' ' do NameStart := Succ(NameStart);
  NameEnd := NameStart;
  while (NOT (IncStr[NameEnd] in [' ','}','*'])) AND
        ((NameEnd -NameStart) <= PathLength) do Inc(NameEnd);
  Dec(NameEnd);
  IncludeFileName := Copy(IncStr,NameStart,(NameEnd -NameStart +1));
end; { of Parse }

(*
 * Function   : ProcessIncludeFile
 * Abstract   : Process the present include-file
 * Decisions  : If include-file found then put it to the output device and
 *              check if the include-file includes a file
 *)
procedure ProcessIncludeFile(var IncStr: WORK_STRING);
var IncludeFile: Text;
    IncludeFileName: ComStr;
    LineBuffer: WORK_STRING;
begin
  Parse(IncStr, IncludeFileName);
  if NOT Open(IncludeFile,IncludeFileName) then
    begin
      LineBuffer := 'ERROR:  include file not found ('+IncludeFileName+ ')';
      ProcessLine(LineBuffer);
    end
  else
    begin
      while NOT EOF(IncludeFile) do begin
        InProcess(1 +ProcessIndX, CurrentY +ProcessIndY, 2);
        ReadLn(IncludeFile,LineBuffer);
        if IncludeIn(LineBuffer) then
          ProcessIncludeFile(LineBuffer)
        else
          ProcessLine(LineBuffer);
      end;
      Close(IncludeFile);
    end;
end; { of ProcessIncludeFile }

(*
 * Function   : ProcessFile
 * Abstract   : Process the present (main-) file
 * Decisions  : Put the file to the output device and
 *              check for include-files
 *)
procedure ProcessFile;
var LineBuffer: WORK_STRING;
begin
{$IFDEF DEBUG}
  WriteLnLPT('*** '+DateAndTime+' '+Replicate('*',40));
{$ENDIF}

  VerticalTab;
  GotoXY(1 +ProcessStrX, CurrentY +ProcessStrY);
  Write(ProcessStr[1] +UpStr(MainFileName));

  InProcess(1 +ProcessIndX, CurrentY +ProcessIndY, 1);
  while NOT EOF(MainFile) do begin
    InProcess(1 +ProcessIndX, CurrentY +ProcessIndY, 2);
    ReadLn(MainFile,LineBuffer);
    if (IncludeIn(LineBuffer) AND (Include = TRUE)) then
      ProcessIncludeFile(LineBuffer)
    else
      ProcessLine(LineBuffer);
  end;
  Close(MainFile);

  InProcess(1 +ProcessIndX, CurrentY +ProcessIndY, 3);
  GotoXY(1 +ProcessStrX, CurrentY +ProcessStrY);
  WriteLn(ProcessStr[1] +UpStr(MainFileName) +ProcessStr[2]);
  WriteLPT(Chr(12)); { Formfeed }
{$IFDEF DEBUG}
  WriteLnLPT('*** FORMFEED (END OF FILE) ***');
{$ENDIF}
end; { of ProcessFile }

(*
 * Function   : MAIN
 * Abstract   :
 * Decisions  :
 *)
BEGIN
  CursorOff;         { Disable cursor display on screen       }
  Initialize;        { Initialize some global variables       }
  OpenMain;          { Open the file to print                 }
{$IFNDEF DEBUG}
  InitializePrinter; { Initialize the output device (printer) }
{$ENDIF}
  ProcessFile;       { Put the read file to the output device }
  CursorOn;          { Enable cursor display on screen        }
END. { of Main }