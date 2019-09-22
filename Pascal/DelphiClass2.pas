unit FFormMain;

interface

uses
    Windows, Messages, ...;

type
    TFormMain = class(TForm)
                    OpenDialog1: TOpenDialog;
                    Button1: TButton;
                    procedure Button1Click(Sender: TObject);
                    procedure FormDestroy(Sender: TObject);
                    procedure FileReset(ReloadFile,ReloadParams,Scenario:Boolean);
                private
                    { Private declarations }
                public
                    { Public declarations }
                end;
var
    FormMain: TFormMain;

implementation
{$R *.dfm}

procedure TFormMain.Button1Click(Sender: TObject);
begin
    ...
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
    ...
end;

procedure TFormMain.FileReset(ReloadFile,ReloadParams,Scenario:Boolean);
var
    str:string;
begin
    if ReloadFile then begin
    ...
    end else begin
    ...
    end;
end;