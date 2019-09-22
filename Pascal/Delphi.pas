unit Strings;

interface

uses
    SysUtils;

resourcestring

(* next line is a problem, because of '(*'. So the function
 * IDtoVer could not recognize                              *)
    SScenarioFileSelectFilter='Scenario files (*.sce)|*.sce';

function IDtoVER(FileVerID:TGUID):Cardinal;

implementation

function IDtoVER(FileVerID:TGUID):Cardinal ;
var
    i:integer;
begin
    Result:=0;
end;

initialization
    AppPath:=ExtractFilePath(paramstr(0));
end.