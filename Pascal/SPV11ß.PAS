(*
 * (c) Copyright 1994, MAP Ltd., Veldhoven
 *
 * Function    : SPV11.PAS
 *
 * Abstract    : Set Ports Version 1.1
 *
 * Description : see Summary
 *
 * History     : MV ð Menno A.P.J. Vogels
 *
 *                Version 1.0 source, 94-05
 *
 *   940616, added DecodeStr function & StripZeroParam procedure and
 *           changed help screen, MV
 *   940730, changed CopyRight strings implementation for Help function, MV
 *   941114, updated error messages, MV
 *   950113, simplified addressing the memory addresses, MV
 *   950225, improved DecodeStr function, MV
 *
 *                Version 1.1 source, yy-mm
 *
 * Summary     :
 *
 * Error msg.  : 0 :  No error
 *               1 :  Invalid Option
 *               2 :  Invalid Switch
 *)
program
  Set__Ports (input, output);


(*---  USED UNITS  ---*)

uses
  Crt, Dos;


(*---  GLOBAL TYPES  ---*)

type
  IOPorts       = (Com1, Com2, Com3, Com4, Lpt1, Lpt2, Lpt3);
  IOPortType    = array[IOPorts] of record
                    Clear   : Boolean;
                    Change  : Boolean;
                    PortStr : String[4];
                    MemAddr : Word;
                    PortAddr: Word;
                  end;


(*---  GLOBAL CONSTANTS  ---*)

const
  ProgramName   : array[1..9] of Byte =
                  { S   e   t       P   o   r   t   s }
                  ( 83,101,116, 32, 80,111,114,116,115);
  Version       : array[1..12] of Byte =
                  { V   e   r   s   i   o   n       1   .   1   á }
                  ( 86,101,114,115,105,111,110, 32, 49, 46, 49,225);
  Company       : array[1..8] of Byte =
                  { M   A   P       L   t   d   . }
                  ( 77, 65, 80, 32, 76,116,100, 46);
  Year          : array[1..3] of Byte =
                  { '   9   4 }
                  ( 39, 57, 52);
  NumberOfPorts = 7;    { Com1, Com2, ..., Lpt3 }
  SwitchInd     = ['/','-'];
  ChangeCom     : Boolean    = FALSE;
  ChangeLpt     : Boolean    = FALSE;
  Default       : Boolean    = FALSE;
  Quiet         : Boolean    = FALSE;
  Ports         : IOPortType =
  ( { begin of Ports }
  (Clear:FALSE; Change:FALSE; PortStr:'Com1'; MemAddr:$400; PortAddr:$3F8),
  (Clear:FALSE; Change:FALSE; PortStr:'Com2'; MemAddr:$402; PortAddr:$2F8),
  (Clear:FALSE; Change:FALSE; PortStr:'Com3'; MemAddr:$404; PortAddr:$3E8),
  (Clear:FALSE; Change:FALSE; PortStr:'Com4'; MemAddr:$406; PortAddr:$2E8),
  (Clear:FALSE; Change:FALSE; PortStr:'Lpt1'; MemAddr:$408; PortAddr:$378),
  (Clear:FALSE; Change:FALSE; PortStr:'Lpt2'; MemAddr:$40A; PortAddr:$278),
  (Clear:FALSE; Change:FALSE; PortStr:'Lpt3'; MemAddr:$40C; PortAddr:$3BC)
  ); { end of Ports }


(*---  FUNCTION AND PROCEDURE DEFINITIONS  ---*)

(*
 * Function   : Replicate
 *
 * Abstract   :
 *
 * Decisions  : Repeat the input character a number of times
 *)
function Replicate(C:Char; N:Byte): String;
var TempStr: String;
begin
  if N = 0 then
    TempStr := ''
  else begin
    If (N > 255) then N := 1;
    FillChar(TempStr, N+1, C);
    TempStr[0] := Chr(N);
  end;
  Replicate := Tempstr;
end; { of Replicate }

(*
 * Function   : Byte2HexStr
 *
 * Abstract   : Byte-decimals to Hexadecimal-string
 *
 * Decisions  : Changes a byte to a hexadecimal string
 *)
function Byte2HexStr(B: Byte): String;
const HexString: String[16] = '0123456789ABCDEF';
begin
  Byte2HexStr := HexString[(B DIV 16) +1] +HexString[(B MOD 16) +1];
end; { of Byte2HexStr }

(*
 * Function   : Str2Word
 *
 * Abstract   : String to Word
 *
 * Decisions  : Converts the input string to a word
 *)
function Str2Word(S: String): Word;
var ErrorCode: Integer;
    W: Word;
begin
  if Length(S) = 0 then
    Str2Word := 0
  else begin
    Val(S, W, ErrorCode);
    if ErrorCode = 0 then
      Str2Word := W
    else
      Str2Word := 0;
  end;
end; { of Str2Word }

(*
 * Function   : UpStr
 *
 * Abstract   : String to Upper Case
 *
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
 * Function   : DecodeStr
 *
 * Abstract   : Decode the input string
 *
 * Decisions  : Get the address' for the ports in the range from the
 *              first to the last port from the input string
 *)
procedure DecodeStr(InStr: String; FirstPort,LastPort: IOPorts);
var NextPort, QuitLoop: Boolean;
    CommaPos: Byte;
    p: IOPorts;
begin
  Delete(InStr, 1, Pos(':', InStr));
  p := FirstPort;
  NextPort := FALSE;
  QuitLoop := FALSE;
  while (p <= LastPort) AND (NOT QuitLoop) do begin
    if NextPort then p := Succ(p);
    CommaPos := Pos(',', InStr);
    if CommaPos = 0 then CommaPos := Length(InStr) +1;
    if CommaPos = 1 then
      Ports[p].Clear := TRUE
    else begin
      Ports[p].Change   := TRUE;
      Ports[p].PortAddr := Str2Word('$' +Copy(InStr, 1, CommaPos -1));
    end;
    Delete(InStr, 1, CommaPos);
    NextPort := TRUE;
    if p = LastPort then QuitLoop := TRUE;
  end; { of while }
end; { of DecodeStr }

(*
 * Function   : ReadPortsFromMemory
 *
 * Abstract   :
 *
 * Decisions  : Reads the address' of the ports from
 *              memory and displays them on screen
 *)
procedure ReadPortsFromMemory;
var LowStr,HighStr: String;
    p: IOPorts;
begin
  for p := IOPorts(0) to IOPorts(NumberOfPorts -1) do begin
    LowStr  := Byte2HexStr(Mem[$0:Ports[p].MemAddr    ]);
    HighStr := Byte2HexStr(Mem[$0:Ports[p].MemAddr +$1]);
    Write(Ports[p].PortStr +':' +HighStr +LowStr +'  ');
  end;
  WriteLn;
end; { of ReadPortsFromMemory }

(*
 * Function   : WritePortsToMemory
 *
 * Abstract   :
 *
 * Decisions  : Writes the address' of the ports to memory
 *)
procedure WritePortsToMemory;
var p: IOPorts;
begin
  for p := IOPorts(0) to IOPorts(NumberOfPorts -1) do begin
    if Ports[p].Clear = TRUE then
      begin
        Mem[$0:Ports[p].MemAddr    ] := Lo($0);
        Mem[$0:Ports[p].MemAddr +$1] := Hi($0);
      end
    else if Ports[p].Change = TRUE then
      begin
        Mem[$0:Ports[p].MemAddr    ] := Lo(Ports[p].PortAddr);
        Mem[$0:Ports[p].MemAddr +$1] := Hi(Ports[p].PortAddr);
      end;
  end; { of for p }
end; { of WritePortsToMemory }

(*
 * Function   : StripZeroParam
 *
 * Abstract   : Strip the first commandline parameter-string
 *
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
 *
 * Abstract   :
 *
 * Decisions  :
 *)
procedure Help;
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
  WriteLn('  Usage : '+TempStr+' [/|-][ports:address('')|D(efault)|Q(uiet)|V(iew)|?]');
  WriteLn('  ports : C(om), C1, C2, C3, C4, L(pt), L1, L2, L3');
  WriteLn('  e.g.  : '+TempStr+' /C:3F8,2F8,3E8,2E8 /L:378,278,3BC');
  WriteLn('          '+TempStr+' /C        clears address'' of all com-ports');
  WriteLn('          '+TempStr+' /C1       clears address of com-port 1');
  WriteLn('          '+TempStr+' /C:,,2E8  clears address'' of first two & the last com-port');
  Write  (Replicate(' ',Length('          '+TempStr)));
  WriteLn(                     '           and sets address of com-port 3 to 2E8 hex');
  WriteLn('          '+TempStr+' /C1:3F8 /L2:278  sets address of com-port 1 and lpt-port 2');
end; { of Help }

(*
 * Function   : GetCommandLine
 *
 * Abstract   :
 *
 * Decisions  :
 *)
procedure GetCommandLine;
var Count,LenStr: Byte;
    Str: ComStr;
    p: IOPorts;
begin
  for Count := 1 to ParamCount do begin
    Str := UpStr(ParamStr(Count));
    LenStr := Length(Str);
    if Str[1] in SwitchInd then
      case Str[2] of
        'C': if (NOT Default) then begin
               ChangeCom := TRUE;
               if (LenStr in [2,3]) AND
                  (Str[LenStr] in ['C','1','2','3','4']) then
                 (*
                  * Clear the address(') for one or more COM-ports
                  *)
                 begin
                   case Str[LenStr] of
                     'C': for p := Com1 to Com4 do begin
                             Ports[p].Clear := TRUE;
                          end;
                     '1': Ports[Com1].Clear := TRUE;
                     '2': Ports[Com2].Clear := TRUE;
                     '3': Ports[Com3].Clear := TRUE;
                     '4': Ports[Com4].Clear := TRUE;
                   end; { of case }
                 end
               else if ((LenStr > 3) AND (Str[3] = ':')) then
                 (*
                  * Set the address for one or more COM-ports
                  *)
                 begin
                   DecodeStr(Str,Com1,Com4);
                 end
               else if ((LenStr > 4) AND (Str[4] = ':')) then
                 (*
                  * Set the address for -one- COM-port
                  *)
                 begin
                   case Str[3] of
                     '1': DecodeStr(Str,Com1,Com1);
                     '2': DecodeStr(Str,Com2,Com2);
                     '3': DecodeStr(Str,Com3,Com3);
                     '4': DecodeStr(Str,Com4,Com4);
                   end; { of case Str[3] }
                 end;
             end; { of 'C' }
        'D': if (NOT ChangeCom) AND (NOT ChangeLpt) then begin
               Default := TRUE;
               for p := IOPorts(0) to IOPorts(NumberOfPorts -1) do begin
                 Ports[p].Change := TRUE;
               end;
             end; { of 'D' }
        'L': if (NOT Default) then begin
               ChangeLpt := TRUE;
               if (LenStr in [2,3]) AND
                  (Str[LenStr] in ['L','1','2','3']) then
                 (*
                  * Clear the address(') for one or more LPT-ports
                  *)
                 begin
                   case Str[LenStr] of
                     'L': for p := Lpt1 to Lpt3 do begin
                             Ports[p].Clear := TRUE;
                          end;
                     '1': Ports[Lpt1].Clear := TRUE;
                     '2': Ports[Lpt2].Clear := TRUE;
                     '3': Ports[Lpt3].Clear := TRUE;
                   end; { of case }
                 end
               else if ((LenStr > 3) AND (Str[3] = ':')) then
                 (*
                  * Set the address for one or more LPT-ports
                  *)
                 begin
                   DecodeStr(Str,Lpt1,Lpt3);
                 end
               else if ((LenStr > 4) AND (Str[4] = ':')) then
                 (*
                  * Set the address for -one- LPT-port
                  *)
                 begin
                   case Str[3] of
                     '1': DecodeStr(Str,Lpt1,Lpt1);
                     '2': DecodeStr(Str,Lpt2,Lpt2);
                     '3': DecodeStr(Str,Lpt3,Lpt3);
                   end; { of case Str[3] }
                 end;
             end; { of 'L' }
        'Q': Quiet := TRUE;
        'V': begin
               ReadPortsFromMemory;
               Halt(0);            { Error: none }
             end; { of 'V' }
        '?': begin
               Help;
               Halt(0);            { Error: none }
             end; { of '?' }
        else begin
               if (NOT Quiet) then WriteLn('Invalid option: ',Str[2]);
               Halt(1);            { Error: invalid option }
             end;
      end {of case}
    else
      begin
        if (NOT Quiet) then WriteLn('Invalid switch: ',Str[1]);
        Halt(2);                   { Error: invalid switch }
      end;
  end; { of for Count }
end; { of GetCommandLine }

(*
 * Function   : Main
 *
 * Abstract   :
 *
 * Decisions  :
 *)
BEGIN
  GetCommandLine;
  WritePortsToMemory;
  if NOT Quiet then ReadPortsFromMemory;
END. { of Main }