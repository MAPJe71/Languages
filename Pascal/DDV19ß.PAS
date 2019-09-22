(*
 * (c) Copyright 1995, MAP Ltd., Veldhoven
 *
 * Function     : DD_V19.PAS
 *
 * Abstract     : Directory Displayer Version 1.9
 *
 * Description  : see Summary
 *
 * History      : MV = Menno A.P.J. Vogels
 *
 *                Version 1.n source, YY-MM
 *
 *  940331, added the headers and comment, MV
 *
 *                Version 1.8 source, 94-04
 *
 *  940528, added the UpStr function, MV
 *  940617, added the StripZeroParam function, MV
 *  940918, changed conditional attribute search, still a failure !!, MV
 *  941106, changed conditional attribute search, works !!, MV
 *  941112, made 'pause' option and 'wait' procedure work,
 *          added showing of filesize in bytes when size < 1Kbyte, MV
 *
 *                Version 1.9 source, 95-mm
 *
 * Summary      :
 *)
program
  Directory__Displayer (input,output);

{$A-}                        { Align Data               : Off }
{$B+}                        { Boolean Evaluation       : On  }
{$E-}                        { Emulation                : Off }
{$F-}                        { Force Far Calls          : Off }
{$I-}                        { Input/Output-Checking    : Off }
{$L-}                        { Local Symbol Information : Off }
{$N-}                        { 80x87 Numeric Processor  : Off }
{$O-}                        { Overlay Code Generation  : Off }
{$R+}                        { Range Checking           : On  }
{$S+}                        { Stack-Overflow Checking  : On  }
{$V-}                        { Var-String Checking      : Off }
{$M 16384,20000,655360}      { Memory Allocation Sizes        }


(*---  USED UNITS  ---*)

uses
  Crt, Dos, Printer;


(*---  GLOBAL CONSTANTS  ---*)

const
  ProgramName : array[1..19] of Byte =
    { D   i   r   e   c   t   o   r   y     }
    ( 68,105,114,101, 99,116,111,114,121, 32,
    { D   i   s   p   l   a   y   e   r }
      68,105,115,112,108, 97,121,101,114);
  Version     : array[1..12] of Byte =
    { V   e   r   s   i   o   n       1   .   9   á }
    ( 86,101,114,115,105,111,110, 32, 49, 46, 57,225);
  Company     : array[1..8] of Byte =
    { M   A   P       L   t   d   . }
    ( 77, 65, 80, 32, 76,116,100, 46);
  Year        : array[1..3] of Byte =
    { '   9   4 }
    ( 39, 57, 52);

  MaxDirSize  = 512;
  MonthStr    : array[1..12] of String[3] =
    ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');


(*---  GLOBAL TYPES  ---*)

type
  DirRec      = record
                  Attr: Byte;
                  Date: Longint;
                  Size: Longint;
                  Name: String[12];
                end;
  DirPtr      = ^DirRec;
  DirList     = array[0..MaxDirSize -1] of DirPtr;
  LessFunc    = function(X,Y: DirPtr): Boolean;
  NameExtStr  = String[12];


(*---  GLOBAL VARIABLES  ---*)

var
  SubDir,
  Totals,
  TotalSize,
  WideDir,
  Print,
  Pause,
  ShowAttribute,
  AllBut,
  ShowFile       : Boolean;
  Count          : Integer;
  Less           : LessFunc;
  Dir            : DirList;
  DDrive         : String;
  DDir           : DirStr;
  DName          : NameStr;
  DExt           : ExtStr;
  DNameExt       : NameExtStr;
  AttrPattern    : Byte;


(*---  FUNCTION AND PROCEDURE DEFINITIONS  ---*)

(*
 * Function   : NumStr
 *
 * Abstract   : from Number to String
 *
 * Decisions  : Converts 'Number' to a string with length 'Digits' and
 *              containing the last digits of the number
 *)
function NumStr(Number,Digits: Integer): String;
begin
  NumStr[0] := Chr(Digits);
  while Digits > 0 do begin
    NumStr[Digits] := Chr(Number MOD 10 +Ord('0'));
    Number := Number DIV 10;
    Dec(Digits);
  end;
end; { of NumStr }

{$F+}

(*
 * Function   : LessDate
 *
 * Abstract   : Less Date & Time
 *
 * Decisions  : Indicate if the date of first file is
 *              older than that of the second file
 *)
function LessDate(X,Y: DirPtr): Boolean;
begin
  LessDate := X^.Date < Y^.Date;
end; { of LessDate }

(*
 * Function   : LessDateAlt
 *
 * Abstract   : Less Date & Time Alternate
 *
 * Decisions  : Indicate if the date of first file is
 *              younger than that of the second file
 *)
function LessDateAlt(X,Y: DirPtr): Boolean;
begin
  LessDateAlt := X^.Date > Y^.Date;
end; { of LessDateAlt }

(*
 * Function   : LessExt
 *
 * Abstract   : Less Extension
 *
 * Decisions  : Indicate if the extension of first file is earlier
 *              in the alphabet than that of the second file
 *)
function LessExt(X,Y: DirPtr): Boolean;
var XExt,
    YExt: ExtStr;
begin
  XExt := Copy(X^.Name,Pos('.',X^.Name)+1,3);
  YExt := Copy(Y^.Name,Pos('.',Y^.Name)+1,3);
  LessExt := XExt < YExt;
end; { of LessExt }

(*
 * Function   : LessExtAlt
 *
 * Abstract   : Less Extension Alternate
 *
 * Decisions  : Indicate if the extension of the first file is later
 *              in the alphabet than that of the second file
 *)
function LessExtAlt(X,Y: DirPtr): Boolean;
var XExt,
    YExt: ExtStr;
begin
  XExt := Copy(X^.Name,Pos('.',X^.Name)+1,3);
  YExt := Copy(Y^.Name,Pos('.',Y^.Name)+1,3);
  LessExtAlt := XExt > YExt;
end; { of LessExtAlt }

(*
 * Function   : LessName
 *
 * Abstract   :
 *
 * Decisions  : Indicate if the name of first file is earlier in
 *              the alphabet than that of the second file
 *)
function LessName(X,Y: DirPtr): Boolean;
begin
  LessName := X^.Name < Y^.Name;
end; { of LessName }

(*
 * Function   : LessNameAlt
 *
 * Abstract   : Less Name Alternate
 *
 * Decisions  : Indicate if the name of the first file is later in
 *              the alphabet than the that of the second file
 *)
function LessNameAlt(X,Y: DirPtr): Boolean;
begin
  LessNameAlt := X^.Name > Y^.Name;
end; { of LessNameAlt }

(*
 * Function   : LessSize
 *
 * Abstract   :
 *
 * Decisions  : Indicate if the size of first file is smaller than
 *              the that of the second file
 *)
function LessSize(X,Y: DirPtr): Boolean;
begin
  LessSize := X^.Size < Y^.Size;
end; { of LessSize }

(*
 * Function   : LessSizeAlt
 *
 * Abstract   : Less Size Alternate
 *
 * Decisions  : Indicate if the size of first file is bigger than
 *              the that of the second file
 *)
function LessSizeAlt(X,Y: DirPtr): Boolean;
begin
  LessSizeAlt := X^.Date > Y^.Date;
end; { of LessSizeAlt }

{$F-}

(*
 * Function   : AddBackSlash
 *
 * Abstract   :
 *
 * Decisions  : Adds a backslash (\) to the input string.
 *)
function AddBackSlash(DirName: String): String;
const DosSet: Set of Char = ['\', ':', #0];
begin
  if DirName[Length(DirName)] in DosSet then
    AddBackSlash := DirName
  else
    AddBackSlash := DirName +'\';
end; { of AddBackSlash }

(*
 * Function   : UpStr
 *
 * Abstract   : String to Upper Case
 *
 * Decisions  : Converts all lower case characters of
 *                the input string to upper case
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
 * Function   : Replicate
 *
 * Abstract   :
 *
 * Decisions  : Repeat the input character a number of times
 *)
function Replicate(C:Char; N:Byte): String;
var TempStr: String;
begin
  If N = 0 then
    TempStr := ''
  else
    begin
      If (N > 255) then N := 1;
      FillChar(TempStr, N+1, C);
      TempStr[0] := Chr(N);
    end;
  Replicate := Tempstr;
end; { of Replicate }

(*
 * Function   : HasExtension
 *
 * Abstract   :
 *
 * Decisions  : Indicate if the inputfilename has an extension
 *)
function HasExtension(N: String): Boolean;
var I,
    DotPos: Byte;
begin
  HasExtension := TRUE;
  if N = '' then Exit;
  if N[Length(N)] = '.' then
    begin
      HasExtension := FALSE;
      Exit;
    end
  else
    for I := Length(N) downto 1 do
      if (N[I] = '.') AND (DotPos = 0) then DotPos := I;
  HasExtension := (DotPos > 0) AND (Pos('\',Copy(N,Succ(DotPos),64)) = 0);
end; { of HasExtension }

(*
 * Function   : Initialize
 *
 * Abstract   :
 *
 * Decisions  : Initializing some global parameters
 *)
procedure Initialize;
begin
  WideDir       := FALSE;
  SubDir        := FALSE;
  Totals        := FALSE;
  TotalSize     := FALSE;
  Print         := FALSE;
  Pause         := FALSE;

  ShowAttribute := FALSE;
  AllBut        := FALSE;
  AttrPattern   := 0;

  @Less         := NIL;
end; { of Initialize }

(*
 * Function   : PWrite
 *
 * Abstract   : Printer Write
 *
 * Decisions  : Write the input string to the screen and the printer
 *)
procedure PWrite(Str: String);
begin
  Write(Str);
  if Print then Write(LST, Str);
end; { of PWrite }

(*
 * Function   : PWriteLn
 *
 * Abstract   : Printer Write Line
 *
 * Decisions  : Write the input string to the screen and the printer,
 *              followed by a carriage return
 *)
procedure PWriteLn(Str: String);
begin
  WriteLn(Str);
  if Print then WriteLn(LST, Str);
end; { of PWriteLn }

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
  while Pos('\',TempStr) <> 0 do Delete(TempStr,1,Pos('\',TempStr));
  if Pos('.',TempStr) <> 0 then
    Delete(TempStr,Pos('.',TempStr),Length(TempStr)-(Pos('.',TempStr)-1));
  StripZeroParam := TempStr;
end; { of StripZeroParam }

(*
 * Function   : Help
 *
 * Abstract   :
 *
 * Decisions  : Definition of the -help screen-
 *)
procedure Help;
var NumberOfSpaces,b: Byte;
    TempStr: String;
begin
  TempStr := StripZeroParam;
  NumberOfSpaces :=
    80 -                        { screen width                         }
    (1 +                        { left margin                          }
     SizeOf(ProgramName) +      { size of the ProgramName array        }
     2 +                        { space between ProgamName & Version   }
     SizeOf(Version) +          { size of the Version array            }
     1 +                        { min. space between Version & Company }
     SizeOf(Company) +          { size of the Company array            }
     1 +                        { space between Company & Year         }
     SizeOf(Year) +             { size of the Year array               }
     1                          { rigth margin                         }
    );
  ClrScr;
  WriteLn;
  Write  (' ');                 { left margin                          }
  for b := 1 to SizeOf(ProgramName) do Write(Chr(ProgramName[b]));
  Write  ('  ');
  for b := 1 to SizeOf(Version)     do Write(Chr(Version[b]));
  Write  (' '+Replicate(' ',NumberOfSpaces));
  for b := 1 to SizeOf(Company)     do Write(Chr(Company[b]));
  Write  (' ');
  for b := 1 to SizeOf(Year)        do Write(Chr(Year[b]));
  WriteLn;
  WriteLn;
{*                  1         2         3         4         5         6         7         8*}
{*         12345678901234567890123456789012345678901234567890123456789012345678901234567890*}
  WriteLn(' Usage    : '+TempStr+' /[switches] [drive:][path][filename]');
  WriteLn;
  WriteLn(' Switches :');
  WriteLn('   ?       Shows this information.');
  WriteLn('   Aattr   Lists files with specified attributes.');
  WriteLn('   attr      A  Archive files    D  Directories   H  Hidden files');
  WriteLn('             R  Read-only files  S  System files  -  Prefix meaning ''all but''');
  WriteLn('   H       Displays the -total- disk size.');
  WriteLn('   D       Makes also a printer dump.');
  WriteLn('   Oordr   Lists files in the specified sorted order.');
  WriteLn('   ordr      D  By date & time (earliest first)  E  By extension (alphabetic)');
  WriteLn('             N  By name (alphabetic)             S  By size (smallest first)');
  WriteLn('             -  Prefix to reverse sort order');
  WriteLn('   P       Pauses after each screen full of information.');
  WriteLn('   S       Includes all subdirectories of the specified directory.');
  WriteLn('   T       Displays only the -total- file or directory size.');
  WriteLn('   W       Lists files in the wide format.');
  WriteLn;
end; { of Help }

(*
 * Function   : DefaultDrive
 *
 * Abstract   : Default Drive
 *
 * Decisions  : Get the name of the current active drive
 *)
function DefaultDrive: String;
var P: String;
begin
  GetDir(0, P);
  DefaultDrive := P[1] +':';
end; {of DefaultDrive}

(*
 * Function   : GetCommand
 *
 * Abstract   :
 *
 * Decisions  : Get the parameters from the command line,
 *              and configure the Directory-Displayer according them
 *)
procedure GetCommand;
var I    : Byte;
    Path,
    S    : PathStr;
    F    : File;
    Attr : Word;
begin {of GetCommand}
  Path := '';
  for I := 1 to ParamCount do begin
    S := UpStr(ParamStr(I));
    if S[1] = '/' then
      case S[2] of
        'A': if Length(S) > 2 then
               begin
                 {*
                  * Show the attributes of the file(s)
                  *}
                 ShowAttribute := TRUE;

                 case S[Length(S)] of
                   'A': AttrPattern := Archive;
                   'D': AttrPattern := Directory;
                   'H': AttrPattern := Hidden;
                   'R': AttrPattern := ReadOnly;
                   'S': AttrPattern := SysFile;
                 end; { of case S[Length(S)] }

                 {*
                  * Show all files, except those with the selected attribute
                  *}
                 if S[3] = '-' then AllBut := TRUE;
               end { of IF Length(S) > 2 }
             else
               ShowAttribute := TRUE;
        'D': Print := TRUE;
        'H': if NOT (Totals) then TotalSize := TRUE;
        'O': if S[3] = '-' then
               case UpCase(S[4]) of
                 'D': Less := LessDateAlt;
                 'E': Less := LessExtAlt;
                 'N': Less := LessNameAlt;
                 'S': Less := LessSizeAlt;
               end
             else
               case S[3] of
                 'D': Less := LessDate;
                 'E': Less := LessExt;
                 'N': Less := LessName;
                 'S': Less := LessSize;
               end;
        'P': Pause   := TRUE;
        'S': SubDir  := TRUE;
        'T': if NOT (TotalSize) then Totals := TRUE;
        'W': WideDir := TRUE;
        '?': begin
               Help;
               Halt(1);
             end;
        else begin
               WriteLn('Invalid option: ',S);
               Halt(2)
             end;
      end
    else
      Path := S;
  end; {of for I := 1 to ParamCount do}

  Path := FExpand(Path);
  if Path[Length(Path)] <> '\' then begin
    Assign(F, Path);
    GetFAttr(F, Attr);
    if (DosError = 0) AND (Attr AND Directory <> 0) then Path := Path +'\';
  end;

  FSplit(Path, DDir, DName, DExt);
  if (DName = '') OR (DName = ' ') then DName := '*';
  if DExt = '' then DExt := '.*';
  DNameExt := DName +DExt;
  if DDir[2] = ':' then
    DDrive := DDir[1] + ':'
  else
    DDrive := DefaultDrive;
end; { of GetCommand }

(*
 * Function   : VolumeName
 *
 * Abstract   :
 *
 * Decisions  : Get the volume name of the current active drive,
 *              and show it (screen or printer)
 *)
procedure VolumeName;
var F: SearchRec;
begin
  PWriteLn('');
  Write('Volume in drive ',DDrive[1],' : ');
  if Print then Write(LST,'Volume in drive ',DDrive[1],': ');
  FindFirst(DDrive + '\*.*', VolumeID, F);
  if DosError = 0  then
    begin
      Delete(F.Name,9,1);
      PWriteLn(F.Name);
    end
  else
    PWriteLn('(No volume name found)');
end; { of VolumeName }

(*
 * Function   : QuickSort
 *
 * Abstract   :
 *
 * Decisions  : Sort the input parameters very fast
 *)
procedure QuickSort(L,R: Integer);
var I,J: Integer;
    X,Y: DirPtr;
begin
  I := L;
  J := R;
  X := Dir[(L+R) DIV 2];
  repeat
    while Less(Dir[I],X) do Inc(I);
    while Less(X,Dir[J]) do Dec(J);
    if I <= J then begin
      Y := Dir[I];
      Dir[I] := Dir[J];
      Dir[J] := Y;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then QuickSort(L,I);
  if I < R then QuickSort(I,R);
end; { of QuickSort }

(*
 * Function   : SortFiles
 *
 * Abstract   :
 *
 * Decisions  : Sort the files of the directory
 *)
procedure SortFiles;
begin
  if (Count <> 0) AND (@Less <> NIL) then QuickSort(0,Count-1);
end; { of SortFiles }

(*
 * Function   : GetFields
 *
 * Abstract   :
 *
 * Decisions  : Split the input string into two seperate strings,
 *              the 'splitter' indicates where the input string
 *              should be split in two
 *)
procedure GetFields(var InStr:String;
                        Splitter:Char;
                    var OutStr1:String;
                    var OutStr2:String);
var P: Byte;
begin
  P := Pos(Splitter,InStr);
  if P > 1 then
    begin
      OutStr1 := Copy(InStr, 1, P-1);
      OutStr2 := Copy(InStr, P+1, Length(InStr) -P);
    end
  else
    begin
      OutStr1 := InStr;
      OutStr2 := '';
    end;
end; { of GetFields }

(*
 * Function   : FlushKeyBuffer
 *
 * Abstract   :
 *
 * Decisions  : Clear the buffer of the keyboard by flushing
 *              its contents through the toilet
 *)
procedure FlushKeyBuffer;
var Register: Registers;
begin
  Register.Ax := ($0C SHL 8) OR 6;
  Register.Dx := $00FF;
  Intr($21, Register);
end; { of FlushKeyBuffer }

(*
 * Function   : Wait
 *
 * Abstract   :
 *
 * Decisions  : Stop listing the files of the directory,
 *              until the user wants to continue
 *)
procedure Wait;
var Ch : Char;
begin
  WriteLn;
  Write('Press Enter/Return, Quit, Space bar or Escape . . .');
  repeat
    if KeyPressed then begin
      Ch := ReadKey;
      case Ch of
        ' ',#13:;
        #27: begin
               GotoXY(1,25);
               Write(Replicate(' ',79));
               GotoXY(1,25);
               Halt(3);
             end;
        'Q','q': Pause := FALSE;
      end; { of Case Ch }
    end;
  until Ch in [#13, #27, ' ', 'Q', 'q'];
  WriteLn;

  {*
   * Clear buffer of keyboard
   *}
  FlushKeyBuffer;
end; { of Wait }

(*
 * Function   : PrintFiles
 *
 * Abstract   :
 *
 * Decisions  : Show the files of the directory
 *)
procedure PrintFiles(Path: String);
var I       : Integer;
    ShowFile: Boolean;
    Total   : Longint;
    T       : DateTime;
    N       : NameStr;
    E       : ExtStr;
begin
  {*
   * Show the directory name, and indicate if no file(s) is (are) found
   *}
  PWriteLn('Directory of '+Path);
  if Count = 0 then begin
    if NOT (Totals XOR TotalSize) then PWriteLn('No files found');
    Exit;
  end;
  if NOT (Totals XOR TotalSize) then PWriteLn('');

  {*
   * Show the files that are found in the directory
   *}
  Total := 0;
  for I := 0 to Count-1 do begin
    with Dir[I]^ do begin
      {*
       * Check if the file should be shown or not
       *}
      if (Attr AND AttrPattern = AttrPattern) XOR
         (NOT AllBut) then
        ShowFile := FALSE
      else
        ShowFile := TRUE;

      {*
       * Split the filename in a name and an extension
       *}
      GetFields(Name,'.',N,E);

      if (NOT (Attr AND VolumeID = VolumeID)) AND
         ShowFile then
        begin
          if NOT (Totals XOR TotalSize) then begin
            PWrite(N);
            PWrite(Replicate(' ',9-Length(N)));
            PWrite(E);
            PWrite(Replicate(' ',4-Length(E)));

            if WideDir then
              begin
                if (Attr AND Directory = Directory) then
                  PWrite(' DIR')
                else begin
                  {*
                   * If the size of the file is smaller than one kilobyte,
                   * then show the number of bytes of the file,
                   * else show the number of kilobytes of the file
                   *}
                  if Size < 1024 then
                    begin
                      Write(Size:4);
                      if Print then Write(LST,Size:4);
                    end
                  else
                    begin
                      Write((Size + 1023) Shr 10:3,'k');
                      if Print then Write(LST,(Size + 1023) Shr 10:3,'k');
                    end;

                end;

                {*
                 * Make some space after the first three files on one row,
                 * goto a new line after the fourth file on that same row
                 *}
                if I AND 3 <> 3 then
                  PWrite('   ')
                else
                  PWriteLn('');
              end
            else {of if WideDir}
              begin
                if (Attr AND Directory = Directory) then
                  PWrite(' DIR     ')
                else begin
                  Write(' ',Size:8);
                  if Print then Write(LST,' ',Size:8);
                end;

                {*
                 * Show date and time of the file
                 *}
                UnPackTime(Date,T);
                Write('  ',T.Day:2,'-',MonthStr[T.Month],'-',
                  NumStr(T.Year MOD 100,2),'  ',T.Hour:2,':',NumStr(T.Min,2));
                if Print then
                  Write(LST,
                      '  ',T.Day:2,'-',MonthStr[T.Month],'-',
                  NumStr(T.Year MOD 100,2),'  ',T.Hour:2,':',NumStr(T.Min,2));

                if (Attr AND Directory <> Directory) AND
                   ShowAttribute then begin
                  PWrite('  ');
                  if (Attr AND Archive  <> 0) then PWrite('A') else PWrite('-');
                  if (Attr AND SysFile  <> 0) then PWrite('S') else PWrite('-');
                  if (Attr AND Hidden   <> 0) then PWrite('H') else PWrite('-');
                  if (Attr AND ReadOnly <> 0) then PWrite('R') else PWrite('-');
                end;

                PWriteLn('');
              end; {of else if WideDir}
          end; {of if NOT (Totals XOR TotalSize)}

          Inc(Total,Size);
        end
      else
        Dec(Count);

      {*
       * Take a pause in showing the files when 24 rows
       * of text have been printed on the screen
       *}
      if Pause then
        if WideDir then
          begin
            {*
             * 4 columns * 23 rows = 92 files
             *}
            if ((I+1) MOD 92 = 0) then Wait;
          end
        else
          {*
           * 1 column * 23 rows = 23 files
           *}
          if ((I+1) MOD 23 = 0) then Wait;
    end; {of with Dir[I]^ do}
  end; {of for I := 0 to Count-1 do}

  {*
   * Add an extra carrage return in wide-dir-mode if
   * the line is not completly filled
   *}
  if WideDir AND (Count AND 3 <> 0) then PWriteLn('');
  PWriteLn('');

  {*
   * Show the total amount of bytes used in the directory,
   * and make a difference between -one- or -more- files
   *}
  Write('  ',Total:15,' bytes in ',Count:3,' file');
  if Print then Write(LST,'  ',Total:15,' bytes in ',Count:3,' file');
  if (Count > 1) then
    PWriteLn('s')
  else
    PWriteLn('');
end; { of PrintFiles }

(*
 * Function   : SetDta
 *
 * Abstract   : ?
 *
 * Decisions  : ?
 *)
procedure SetDta(DTAptr: Pointer);
var Regs: Registers;
begin
  with Regs do begin
    AH := $1A;
    DS := Seg(DTAptr^);
    DX := Ofs(DTAptr^);
    MsDos(Regs);              { MsDos(Regs) == Intr($21,Regs) }
  end;
end; { of SetDta }

(*
 * Function   : FindAllFiles
 *
 * Abstract   :
 *
 * Decisions  : Find all the files in the defined directory
 *)
procedure FindAllFiles(DirStr:String);
var F: SearchRec;
begin
  Count := 0;
  FindFirst(AddBackSlash(DirStr) + DNameExt,AnyFile,F);
  while (DosError = 0) AND
        (Count < MaxDirSize) do begin
    if NOT (F.Attr AND VolumeID <> 0) then begin {'8' <-> 'VolumeID'}
      GetMem(Dir[Count],Length(F.Name) + 10);
      Move(F.Attr,Dir[Count]^,Length(F.Name) + 10);
      Inc(Count);
    end;
    FindNext(F);
  end;
end; { of FindAllFiles }

(*
 * Function   : FindFiles
 *
 * Abstract   :
 *
 * Decisions  : Find the files of the directory,
 *              sort them, show them, and find the
 *              files of the subdirectories if wished
 *)
procedure FindFiles(FDir: String);
var F: SearchRec;
begin
  FindAllFiles(Fdir);
  SortFiles;
  PrintFiles(AddBackSlash(FDir) + DNameExt);
  if SubDir then begin
    PWriteLn('');
    FindFirst(AddBackSlash(FDir) + '*.*',Anyfile,F);
    while DosError = 0 do begin
      with F do
        if (Attr AND Directory <> 0) AND             {'16' <-> 'Directory'}
           (Name[1] <> '.') AND
           (NOT (Attr AND VolumeID <> 0)) then begin {'8' <-> 'VolumeID'}
          FindFiles(AddBackSlash(FDir) + Name);
          SetDta(@F);
        end;
      FindNext(F);
    end;
  end;
end; { of FindFiles }

(*
 * Function   : DiskSpace
 *
 * Abstract   :
 *
 * Decisions  : Show the number of bytes that are
 *              free on the current drive
 *)
procedure DiskSpace;
begin
  WriteLn('  ',DiskFree(Ord(DDrive[1]) -64):15,' bytes free on drive ',DDrive[1]);
  if Print then begin
    WriteLn(LST,
          '  ',DiskFree(Ord(DDrive[1]) -64):15,' bytes free on drive ',DDrive[1]);
  end;
end; { of DiskSpace }

(*
 * Function   : TotalDiskSize
 *
 * Abstract   :
 *
 * Decisions  : Show the -total- size of the current drive
 *)
procedure TotalDiskSize;
begin
  WriteLn('  ',DiskSize(Ord(DDrive[1]) -64):15,' bytes total disk size');
  if Print then begin
    WriteLn(LST,
          '  ',DiskSize(Ord(DDrive[1]) -64):15,' bytes total disk size');
  end;
end; { of TotalDiskSize }

(*
 * Function   : MAIN
 *
 * Abstract   :
 *
 * Decisions  :
 *)
BEGIN
  Initialize;
  GetCommand;
  VolumeName;
  FindFiles(DDir);
  DiskSpace;
  if TotalSize then TotalDiskSize;
END. { of MAIN }