unit STRUC;

interface

uses
    SysUtils,Math,Classes,Zlib, ...;

type
    TIntArray    = array of Integer;
    TTwoDimFloat = array of array of Float;

    TQStructure = class
                  private
                      Fz: array of Float; //??? ? ???????, ??? ????????, ????? ?????????? ????????
                      FVetv: TQVetv; //??? ??????
                      FVetvStep: TIntArray;//?????? ????? ?? ????? ?????????
                      FVetvCount:Cardinal;
                      FUzel: TQUzel; //??? ?????
                      FUzelCount:Cardinal;

                      function GetQUzel(index, depth: Cardinal): TQstruc;
                      function GetQVetv(index, step, depth: Cardinal): TQstruc;
                      function GetZ(index:Cardinal): Float;

                      procedure SetZ(index: Cardinal; const Value: Float);
                      procedure SetUzelDim(Value: Cardinal);
                      procedure SetVetvDim(Value: Cardinal);

                      function GetVetvStep(VetvNum: Cardinal): Cardinal;
                      procedure SetVetvLength(VetvNum,StepCount: Cardinal);

                  public
                      destructor Destroy; override;
                  end;

implementation

destructor TStatic.Destroy;
begin
    ...
    inherited;
end;

procedure TStatic.Read(S: TStream);
begin
    ...
end;

constructor TUzel.Create;
begin
    ...
end;

destructor TUzel.Destroy;
begin
    ...
    inherited;
end;