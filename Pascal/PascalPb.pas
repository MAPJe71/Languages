{$M 32768}
 
{$N+,I-}
 
{$IFNDEF DPMI}
  kompiluj pouze v protected modu!
{$ENDIF}
 
{$IFNDEF VYROBA}
  {$IFNDEF QSG}
    {$IFNDEF ALFA}
      nastav aspon jeden z vyse uvedenych define!
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
 
{$IFDEF ALFA}
  {$DEFINE VYROBA}
{$ENDIF}
 
{$IFDEF VYROBA}
  {$IFNDEF ALFA}
    {$DEFINE BARVY}
  {$ENDIF}
  {DEFINE PSWEXIT}  {vyskakujeme na heslo}
{$ENDIF}
 
{$IFDEF ALFA}
  {$IFDEF BARVY}
    ALFA a BARVY nejde dohromady!
  {$ENDIF}
{$ENDIF}
 
{$IFDEF QSG}
  {$IFDEF BARVY}
    QSG a BARVY nejde dohromady!
  {$ENDIF}
{$ENDIF}
 
{$IFDEF VYROBA}
  {$DEFINE ETI}
{$ENDIF}
 
{$IFDEF DOMA}
  {$DEFINE SIMULACE}
{$ENDIF}
 
{$IFDEF DEBUG}
  {$DEFINE HEAP}
{$ENDIF}
 
{$DEFINE TIME}
 
uses dos,objects,drivers,views,menus,app,dialogs,gadgets,
     kjutil,kjobject,csmsgbox,cshelpf,cstddlg,
     pedaldef,pedalsys,pedalobj,pedalaut,pedalmer,pedaldb,
     kjcview,pedalprg,pedalbar,
     devices,etikety,biosprn,isel,tedia,outputs,melexis,
{$IFDEF DEBUG}
     kjdbgwin,
{$ENDIF}
     ssaver,pedalpsw,kjfiles,kjdosfnt,kjparams,logfile;
 
{Pro ADVANTECH:
 
Specialni funkcni klavesy:
 
  SF1 = Alt+F1      SF6 = Tab
  SF2               SF7
  SF3               SF8
  SF4               SF9
  SF5 = Shift+Tab   SF10
 
}
 
const
 
helpfn='PEDALHLP.HLP';
 
ss_delay=300; {v sekundach prodleva pred spusteni ScreenSaveru}
 
{3Eh - barva CCluster Disabled}
 
CNewAppColor =
 
   {  0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F  }
 
        #$71#$70#$78#$74#$20#$28#$24#$17#$1F#$1A#$31#$31#$1E#$71#$1F + { 0 }
    #$37#$3F#$3A#$13#$13#$3E#$21#$3F#$70#$7F#$7A#$13#$13#$70#$7F#$7E + { 1 }
    #$70#$7F#$7A#$13#$13#$70#$70#$7F#$7E#$20#$2B#$2F#$78#$2E#$70#$30 + { 2 }
    #$3F#$3E#$1F#$2F#$1A#$20#$72#$31#$31#$30#$2F#$3E#$31#$13#$37#$00 + { 3 }
    #$17#$1F#$1A#$71#$71#$1E#$17#$1F#$1E#$20#$2B#$2F#$78#$2E#$10#$30 + { 4 }
    #$3F#$3E#$70#$2F#$7A#$20#$12#$31#$31#$30#$2F#$3E#$31#$13#$38#$00 + { 5 }
    #$37#$3F#$3A#$13#$13#$3E#$30#$3F#$3E#$20#$2B#$2F#$78#$2E#$30#$70 + { 6 }
    #$7F#$7E#$1F#$2F#$1A#$20#$32#$31#$71#$70#$2F#$7E#$71#$13#$38#$00;  { 7 }
 
type
 
PDateView = ^TDateView;
TDateView = object(TView)
  Refresh: Byte;
  LastDate: DateTime;
  DateStr: string[12];
  constructor Init(var Bounds: TRect);
  procedure Draw; virtual;
  function FormatDateStr(Y, M, D: Word): String; virtual;
  procedure Update; virtual;
end;
 
pmystatusline=^tmystatusline;
tmystatusline=object(tstatusline)
  pphase:word; {predchozi hodnota PEDALDEF.a_phase - pouze ALFA}
  pzakl:byte;  {predchozi hodnota zakladani - pouze Alfa}
  function hint(ahelpctx:word):string; virtual;
{$IFDEF ALFA}
  function phmsg:string; virtual;
  procedure update; virtual;
{$ENDIF}
end;
 
pmydesktop=^tmydesktop;
tmydesktop=object(tdesktop)
  procedure initbackground; virtual;
  procedure handleevent(var event:tevent); virtual;
end;
 
pkjhelpwin=^tkjhelpwin;
tkjhelpwin=object(thelpwindow)
  procedure handleevent(var event:tevent); virtual;
  procedure sizelimits(var min,max:tpoint); virtual;
  destructor done; virtual;
end;
 
paboutdlg=^taboutdlg;
taboutdlg=object(tdialog)
  constructor init;
end;
 
tpedalapp=object(tapplication)
{$IFDEF TIME}
  clock:pclockview;
  datum:pdateview;
{$ENDIF}
{$IFDEF HEAP}
  heap:pheapview;
{$ENDIF}
  title:pstringview;
  menubox:pmenubox;
  p_reset:boolean;
  p_start:boolean;
  ss_time:longint; {cas na screensaver}
{$IFDEF ALFA}
  msgd1:pdialog;
  prein:word; {predchozi stav vstupu}
{$ENDIF}
  constructor init;
  function getpalette:ppalette; virtual;
  procedure idle; virtual;
  procedure initmenubox; virtual;
  procedure initstatusline; virtual;
  procedure initdesktop; virtual;
  procedure showcurrent; virtual;
  procedure getevent(var event:tevent); virtual;
  procedure handleevent(var event:tevent);virtual;
  destructor done; virtual;
end;
 
 
{GLOBAL VAR}
 
var
 
{etiprn:petiprn;  {tady je tiskarna etiket - v PEDALDEF}
pedalapp:tpedalapp;
scrs:tscrsaver;
 
{UTILS}
 
procedure inc_ok;
var s:string[4];
    f:file;
begin
  inc(poc_ok);
  s:=align(strl(poc_ok),4,2);
  move(s[1],pedalapp.title^.text^[45],4);
  pedalapp.title^.draw;
  assign(f,progdir+cntfn);
  rewrite(f,1);
  blockwrite(f,poc_ok,2);
  blockwrite(f,poc_zm,2);
  close(f);
end;
 
procedure inc_zm;
var s:string[4];
    f:file;
begin
  inc(poc_zm);
  s:=align(strl(poc_zm),4,2);
  move(s[1],pedalapp.title^.text^[54],4);
  pedalapp.title^.draw;
  assign(f,progdir+cntfn);
  rewrite(f,1);
  blockwrite(f,poc_ok,2);
  blockwrite(f,poc_zm,2);
  close(f);
end;
 
procedure draw_okzm;
var s:string[4];
begin
  s:=align(strl(poc_ok),4,2);
  move(s[1],pedalapp.title^.text^[45],4);
  s:=align(strl(poc_zm),4,2);
  move(s[1],pedalapp.title^.text^[54],4);
  pedalapp.title^.draw;
end;
 
procedure clear_okzm;
var s:string[4];
    f:file;
begin
  poc_ok:=0;
  poc_zm:=0;
  draw_okzm;
  {jeste ulozit}
end;
 
procedure init_okzm;
var f:file;
begin
  assign(f,progdir+cntfn);
  clriores;
  reset(f,1);
  if ioresult=0 then begin
    blockread(f,poc_ok,2);
    blockread(f,poc_zm,2);
  end else begin
    poc_ok:=0;
    poc_zm:=0;
  end;
  close(f);
  clriores;
  draw_okzm;
end;
 
procedure readcfg;
var f:pkjfile;
    s:string[8];
begin
  if f_exist(cfgfn) then begin
    f:=new(pkjfile,init_read(cfgfn,cfgid));
    f^.read(ostpar.errn,2);
    f^.read(ostpar.chkb,2);
    f^.read(ostpar.netw,81);
    f^.read(ostpar.hcnt,2);
    f^.read(ostpar.tolj,2);
    f^.read(ostpar.tolp,2);
    if f^.ver=1 then f^.read(ostpar.pajt,2);
    f^.read(ostpar.fpid,3);
    dispose(f,done);
  end else begin
    ostpar.errn:=4;
    ostpar.chkb:=0;
    ostpar.netw:='';
    ostpar.fpid:='';
    ostpar.hcnt:=0;
    ostpar.tolj:=emptyword;
    ostpar.tolp:=emptyword;
  end;
end;
 
procedure writecfg;
var f:pkjfile;
begin
  f:=new(pkjfile,init_write(cfgfn,cfgid,1));
  f^.write(ostpar,sizeof(ostpar));
  dispose(f,done);
end;
 
{TDATEVIEW}
 
function LeadingZero(w: Word): String;
var s: String;
begin
  Str(w:0, s);
  LeadingZero := Copy('00', 1, 2 - Length(s)) + s;
end;
 
constructor TDateView.Init(var Bounds: TRect);
begin
  inherited Init(Bounds);
  FillChar(LastDate, SizeOf(LastDate), #$FF);
  DateStr := '';
  Refresh := 1;
end;
 
 
procedure TDateView.Draw;
var
  B: TDrawBuffer;
  C: Byte;
begin
  C := GetColor(2);
  MoveChar(B, ' ', C, Size.X);
  MoveStr(B, DateStr, C);
  WriteLine(0, 0, Size.X, 1, B);
end;
 
procedure TDateView.Update;
var
  y,m,d,w:word;
begin
  GetDate(y,m,d,w);
  if (d<>LastDate.day) or (m<>LastDate.Month) or (y<>LastDate.Year) then
  begin
    with LastDate do
    begin
      Year := y;
      Month := m;
      Day := d;
    end;
    DateStr := FormatDateStr(y, m, d);
    DrawView;
  end;
end;
 
function TDateView.FormatDateStr(Y, M, D: Word): String;
begin
  FormatDateStr := align(strl(d),2,2)+ '.'+ LeadingZero(m) +
    '.' + LeadingZero(y);
end;
 
 
 
{TMYSTATUSLINE}
 
{$IFDEF ALFA}
 
procedure TMyStatusLine.Update;
var
  H: Word;
begin
{$IFNDEF DOMA}
  if digio^.getin(1,0) then begin
    inherited update;
  end else begin
    H:=hchand;
    if (helpctx<>H) or (pphase<>a_phase) or (pzakl<>a_zakl) then begin
      pphase:=a_phase;
      pzakl:=a_zakl;
      helpctx:=H;
      items:=nil;
      drawview;
    end;
  end;
{$ELSE}
  inherited update;
{$ENDIF}
end;
 
function tmystatusline.phmsg:string;
var hc:word;
begin
  hc:=topview^.gethelpctx;
  if (hc>=hcerror) and (hc<=hclistm) then begin
    phmsg:='PýepnØte do ruŸn¡ho re§imu!';
  end else begin
    case a_phase of
       0:phmsg:='UvolnØte bezpeŸnostn¡ sp¡naŸ!';
       1:phmsg:='¬ek m na sign l INIT';
       2:phmsg:='Inicializace typu';
{      10:phmsg:='¬ek m na START najet¡';
      11:phmsg:='¬ek m na START zkouçky';}
    else
      phmsg:='('+strl(a_phase)+')';
    end;
  end;
end;
 
{$ENDIF}
 
function tmystatusline.hint(ahelpctx:word):string;
begin
  case ahelpctx of
    hcdragging:hint:='Pýesouv n¡';
 
    hcapp    :hint:='PEDAL ver '+verstr+' (C)1998 <KJ>';
 
    hcmprov  :hint:='SpuçtØn¡ provozn¡ho re§imu';
    hcmnast  :hint:='Nastaven¡ a prohl¡§en¡ parametr…';
    hcmkal   :hint:='Kalibrov n¡ mØýic¡ch syst‚m…';
    hcmserv  :hint:='Speci ln¡ nastaven¡';
    hcmdat   :hint:='Pr ce s daty';
    hcmhelp  :hint:='Index n povØdy';
    hcmexit  :hint:='UkonŸen¡ programu';
 
    hcmparams:hint:='Editace aktu ln¡ch parametr…';
    hcmdb    :hint:='Editace parametr… jinìch typ…';
    hcmeti   :hint:='Nastaven¡ tisku etiket';
    hcmbar   :hint:='Definov n¡ a editace barev';
    hcmprint :hint:='Tisk parametr…';
    hcmztyp  :hint:='Nastaven¡ na jinì typ';
    hcmrescnt:hint:='Vynulov n¡ Ÿ¡taŸe OK a Zmetk…';
 
    hcmsil   :hint:='Kalibrace s¡ly';
    hcmkel   :hint:='Kalibrace elektrickìch veliŸin';
    hcmkb    :hint:='Kalibrace karty pro mØýen¡ barev';
    hcmkpar  :hint:='Vìpis kalibraŸn¡ch konstant';
 
    hcmdtime :hint:='Nastaven¡ data a Ÿasu';
    hcmhw    :hint:='Spr vce hardware';
    hcmkan   :hint:='MØýic¡ kan ly';
    hcmostpar:hint:='Ostatn¡ nastaven¡';
    hcmrucprg:hint:='RuŸn¡ programov n¡';
    hcmsup   :hint:='Aktivace diag. mo§nost¡';
    hcmabout :hint:='Informace o tv…rci a verzi programu';
 
    hcmvia   :hint:='Prohl¡§en¡ aktu ln¡ch dat';
    hcmvim   :hint:='Prohl¡§en¡ jinìch dat aktu ln¡ho typu';
    hcmvio   :hint:='Prohl¡§en¡ ostatn¡ch dat';
 
    hcdp1    :hint:='Z kladn¡ £daje o senzoru a ped lu';
    hcdp1typ :hint:='OznaŸen¡ typu';
    hcdp1pozn:hint:='Libovolnì text';
    hcdp1kpri:hint:='K¢dov n¡ pý¡pravku';
    hcdp1kka :hint:='K¢dov n¡ kabelu';
    hcdp1smer..hcdp1smer+1:hint:='SmØr stlaŸov n¡ ped lu';
    hcdp1refd:hint:='Startovac¡ poloha jezdce';
    hcdp1senz..hcdp1senz+8:hint:='Vlastnosti senzoru';
    hcdp1ped..hcdp1ped+8:hint:='Vlastnosti ped lu';
    hcdp1zkus:hint:='Test najet¡ do startovac¡ pozice';
 
    hcdp2    :hint:='Volba mØýen¡ a testov n¡';
 
    hcddb    :hint:='Datab ze typ…';
    hcdcopy  :hint:='Kop¡rov n¡ parametr…';
    hcdztyp  :hint:='Vyberte aktu ln¡ typ';
 
    hcdeti   :hint:='Zadejte £daje pro tisk etiket';
    hcdetifon:hint:='P¡smo: 0 a§ 8 - Draft, 10 a§ 18 - Arial';
    hcdetibmp:hint:='Jm‚no souboru s obr zkem *.BMP';
    hcetifd  :hint:='Vyberte obr zek ...';
    hcdetibar:hint:='Barva etikety';
    hcdetiblb:hint:='Vyberte barvu etikety ...';
 
    hcddtime :hint:='Zadejte nov‚ datum nebo Ÿas';
 
    hcdetiprn:hint:='Parametry tisk rny etiket';
 
    hcprovoz :hint:='Vìsledky testu';
    hcmpstart:hint:='SpuçtØn¡ testu';
    hcmpgraf :hint:='Zobrazen¡ grafu';
    hcmpprint:hint:='Tisk namØýenìch hodnot';
    hcmpexit :hint:='N vrat do hl. menu';
 
    hcvol    :hint:='Kontrola volnobØhu';
 
    hcostpar :hint:='Ostatn¡ parametry';
    hcdmkan  :hint:='MØýic¡ kan ly';
    hcdsup   :hint:='Diagnostick‚ mo§nosti';
 
    hchelpwin:hint:='Okno n povØdy';
 
    hcerror  :hint:='Chybov  zpr va';
    hcinfo   :hint:='Informace';
    hcyesno  :hint:='UpozornØn¡ - odpovØzte "Ano" nebo "Ne"';
    hcokcan  :hint:='Informace';
    hclistm  :hint:='Zpr va se seznamem';
 
    hcuserdlg:hint:='Editace u§ivatele';
    hcuserlst:hint:='Seznam u§ivatel…';
    hclogin  :hint:='Zadejte jm‚no a heslo';
    hcconfpw :hint:='PotvrÔte nov‚ heslo';
 
    hccview  :hint:='Prohl¡§en¡ ulo§enìch hodnot';
    hccstat  :hint:='Statistika';
    hccschop :hint:='Vìsledky vìpoŸtu Cgm a Cgmk';
    hccquit  :hint:='??';
    hccprint :hint:='??';
 
    hcmstvyr :hint:='Statistika vìroby';
    hcmsthoo :hint:='Statistika z dobrìch mØýen¡';
    hcmsthov :hint:='Statistika ze vçech mØýen¡';
    hcmschop :hint:='VìpoŸet Cgm a Cgmk';
    hcmcprn  :hint:='Tisk vçech hodnot';
    hcmcquit :hint:='N vrat do hl. menu';
    hcmcstat :hint:='R…zn‚ statistick‚ pýehledy';
 
    hcdbarl  :hint:='Prohl¡§en¡ a editace barev';
    hcdbarva :hint:='Zadejte parametry barvy';
 
    hcabout  :hint:='Informace o programu ...';
 
    hcpartree+hcttparam,hcpartree+hcttparamr:hint:='Skupina';
    hcpartree+hcttparam_bo,hcpartree+hcttparam_bor:hint:='Zaçkrt vac¡ pole';
    hcpartree+hcttparam_co:hint:='VìbØr ze seznamu';
    hcpartree+hcttparam_nv:hint:='Parametr nastaven¡';
    hcpartree+hcttparam_ev:hint:='Zkuçebn¡ hodnota';
    hcpartree+hcttparam_so:hint:='Zkuçebn¡ hodnota';
    hcpartree+hcttparam_xs:hint:='Pýidat soubØh ...';
 
    hcprgtree+hcttparam,hcprgtree+hcttparamr:hint:='Skupina';
    hcprgtree+hcttparam_bo,hcprgtree+hcttparam_bor:hint:='Zaçkrt vac¡ pole';
    hcprgtree+hcttparam_co:hint:='VìbØr ze seznamu';
    hcprgtree+hcttparam_nv:hint:='Parametr nastaven¡';
 
    hcttparam_coe:hint:='VìbØr ze seznamu';
    hcttparam_nve:hint:='Parametr nastaven¡';
    hcttparam_eve:hint:='Zkuçebn¡ hodnota';
    hcttparam_soe:hint:='Zkuçebn¡ hodnota';
 
    hcasytol     :hint:='Asymetrick  tolerance';
 
{$IFDEF DEBUG}
    hckjdbgwin   :hint:='Debug window';
{$ENDIF}
 
{$IFDEF ALFA}
    hchand   :hint:='| AUTOMATICKí PROVOZ - '+phmsg+' - Zakl:'+strl(a_zakl)+' -';
{$ENDIF}
 
  else
    hint:='*** NO HINT *** ('+strl(ahelpctx)+')';
  end;
end;
 
{TMYDESKTOP}
 
procedure tmydesktop.initbackground;
var r:trect;
begin
  getextent(r);
{$IFNDEF NOCG}
  background:=new(pbackground,init(r,'-'));  {176 pro CRT, 177 pro LCD}
{$ELSE}
  background:=new(pbackground,init(r,'-'));
{$ENDIF}
end;
 
procedure tmydesktop.handleevent(var event:tevent);
begin
  inherited handleevent(event);
  if event.what=evmessage then begin
    case event.command of
      cm_incok:inc_ok;
      cm_inczm:inc_zm;
      cm_clrok:if yesnomsg('Chcete vynulovat Ÿ¡taŸe OK a zmetk…?') then clear_okzm;
    end;
  end;
end;
 
{TKJHELPWIN}
 
procedure tkjhelpwin.handleevent(var event:tevent);
begin
  if event.what=evkeydown then begin
    case event.keycode of
      kbf5:begin
        event.what:=evcommand;
        event.command:=cmzoom;
      end;
      kbctrlf5:begin
        event.what:=evcommand;
        event.command:=cmresize;
      end;
      kbaltf3:begin
        event.what:=evcommand;
        event.command:=cmclose;
      end;
    end;
  end;
  inherited handleevent(event);
end;
 
procedure tkjhelpwin.sizelimits(var min,max:tpoint);
begin
  inherited sizelimits(min,max);
  if typeof(owner^)=typeof(tpedalapp) then dec(max.y,1);
end;
 
destructor tkjhelpwin.done;
begin
  inherited done;
end;
 
{TABOUTDLG}
 
constructor taboutdlg.Init;
var
  R: TRect;
  Control : PView;
  ms:string;
begin
  R.Assign(17, 2, 62, 21);
  inherited Init(R, 'O programu');
  Options := Options or ofCenterX or ofCenterY;
  helpctx:=hcabout;
 
  R.Assign(17, 16, 27, 18);
  Control := New(PButton, Init(R, '~Z~avý¡t', cmcancel, bfDefault));
  Control^.Options := Control^.Options or ofCenterX;
  Insert(Control);
 
  R.Assign(4, 2, 41, 5);
  Control := New(PStaticText, Init(R, '%03PEDAL_NT'^M+
     '%03(C)2002 Ing. Jan Kr tkì <KJ>'^M+
     '%03B”HM Pr…myslov  automatizace'));
  Control^.Options := Control^.Options or ofFramed or ofCenterX;
  Insert(Control);
 
  R.Assign(4, 6, 41, 8);
  Control := New(PStaticText, Init(R, '%03ü¡dic¡ program stavu pro zkouçen¡ '+
                                      'plynovìch ped l… (FPM)'));
  Insert(Control);
 
  R.Assign(17, 9, 28, 10);
  Control := New(PStaticText, Init(R, 'Verze: '+ver));
  Control^.Options := Control^.Options or ofCenterX;
  Insert(Control);
 
  R.Assign(17, 10, 28, 11);
  Control := New(PStaticText, Init(R, 'Build: '+bld));
  Control^.Options := Control^.Options or ofCenterX;
  Insert(Control);
 
  ms:='';
 
{$IFDEF VYROBA}
  ms:='VYR';
  {$IFDEF ALFA}
    ms:=ms+'/ALFA';
  {$ENDIF}
{$ENDIF}
{$IFDEF QSG}
  ms:='QSG';
{$ENDIF}
{$IFDEF DOMA}
  ms:=ms+'.TEST';
{$ENDIF}
{$IFDEF DEBUG}
  ms:=ms+'.DBG';
{$ENDIF}
 
  R.Assign(12, 11, 41, 12);
  Control := New(PStaticText, Init(R, 'Modifikace: '+ms));
  Insert(Control);
 
  R.Assign(4, 13, 41, 15);
  Control := New(PStaticText, Init(R, '%03V pý¡padØ probl‚m… volejte na Ÿ¡slo'^M+
     '%030602 560 362'));
  Insert(Control);
 
  SelectNext(False);
end;
 
{TPEDALAPP}
 
constructor tpedalapp.init;
type tports=array[0..1]of word;
var r:trect;
    p:byte;
    s:string;
    dlg:pdialog;
    ev:tevent;
    ok:boolean;
    f:file;
    pin,pout:^tports;
    st:byte;
begin

  inherited init;
 
{$IFNDEF NOCG}
 
  hidemouse;
  installdosfont(@font_fpmlat,16);
  showmouse;
 
{$ENDIF}
 
  applog:=new(plogfile,init('pedal.log',65000));
 
  applog^.write('*** Program spuçtØn, PEDALNT.EXE verze '+ver+'/'+bld);
 
  initmenubox;
  if menubox<>nil then desktop^.insert(menubox);
 
  ss_time:=gettickcount;
 
  helpctx:=hcapp;
 
{$IFDEF HEAP}
 
  GetExtent(R);
  Dec(R.B.X);
  R.A.X := R.B.X - 9; R.A.Y := R.B.Y - 1;
  Heap := New(PHeapView, Init(R));
  Insert(Heap);
 
{$ENDIF}
{$IFDEF TIME}
 
  GetExtent(R);
  R.A.X := R.B.X - 9; R.B.Y := R.A.Y + 1;
  Clock := New(PClockView, Init(R));
  Insert(Clock);
 
  GetExtent(R);
  R.A.X := R.B.X - 20;
  R.B.X := R.B.X -10;
  R.B.Y := R.A.Y + 1;
  Datum := New(PDateView, Init(R));
  Insert(Datum);
 
{$ENDIF}
 
{$IFDEF DEBUG}
  GetExtent(R);
  R.Grow(-10,-5);
  debug_init(r,'DEBUG');
{$ENDIF}
 
  GetExtent(R);
  R.B.X:=R.B.X-20;
  R.B.Y:=R.A.Y+1;
  title:=new(pstringview,init(r,newstr(' <KJ>FPM '+ver+'/'+bld+' - Typ: inicializace  - OK:      ZM:     -')));
  title^.mode:=swdispose;
  insert(title);                                                 {26}                          {56}     {65}
 
  init_okzm;
 
{$IFDEF DEBUG}debug^.writeln('OKZM .. OK');{$ENDIF}
 
  registerhelpfile;
 
  statusmsg('NaŸ¡t m soubor s parametry typ…');
 
  readcfg;
 
{$IFDEF DEBUG}debug^.writeln('READCFG .. OK');{$ENDIF}
 
  netdir:=ostpar.netw;  {AKTUALIZOVAT NETDIR}
 
{  if not f_exist(typname) then begin
    errormsg('Neexistuje soubor typ…! Bude vytvoýen novì, pr zdnì');
    typcol:=new(ptypcol,init(typname));
    typcol^.write;
 
  ^^ toto je osetreno v typcol.read ^^
 
  }
 
  typcol:=new(ptypcol,init(typname));
 
{$IFDEF DEBUG}debug^.writeln('TYPCOL .. OK');{$ENDIF}
 
  showcurrent;
{$IFDEF ETI}
{$IFDEF BARVY}
  barvycol:=new(pbarvycol,load(colfn));
  {$IFDEF DEBUG}debug^.writeln('BARVY .. OK');{$ENDIF}
{$ENDIF}
{$ENDIF}
 
  psw_init(pswfn);
 
  menubox^.hide;
 
  init_ok:=true;
 
  statusmsg('Inicializace hardware');
 
  devcol:=new(pdevcol,load(progdir+devfn));
 

  if devcol^.count=0 then begin
    errormsg('Neplatnì soubor definice hardware! Bude vytvoýen novì. Pros¡m zadejte spr vn‚ £daje ve "Spr vci Hardware"!');
    dispose(devcol,done);
 
    dlg:=msgdlg('Hardware','Vytv ý¡ se datab ze hardwarovìch ovladaŸ…, pros¡m Ÿekejte');
    devcol:=new(pdevcol,init(progdir+devfn));
    devcol^.insert(new(ppca1608,init(d_pca1608,'MØýic¡ karta PCA-1608A',$300)));
    devcol^.insert(new(ppcaamp,init(d_pcaamp,'Pýep¡nac¡ karta PCA-AMP',$308)));
{$IFDEF ETI}
{$IFDEF BARVY}
    devcol^.insert(new(ppca1608,init(d_ana2,'MØýic¡ karta PCA-1608A (barvy)',$208)));
{$ENDIF}
{$ENDIF}
{    devcol^.insert(new(ppcd4848,init(d_pcd4848,'Digit ln¡ karta PCD-4848',$310)));}
    devcol^.insert(new(pmotor,init(d_motor,'Karta krokov‚ho motoru ISEL IMK-1',$350)));
    devcol^.insert(new(ppct2403,init(d_pct2403,'Karta inkr. Ÿ¡taŸ… PCT-2403',$200)));
    devcol^.insert(new(pprinter,init(d_lpt1,'Tisk rna CANON BJC-250',0)));
{$IFDEF ETI}
    devcol^.insert(new(petiprn,init(d_etikety,'Tisk rna etiket DATAMAX',2)));
{$ELSE}
    etiprn:=nil;
{$ENDIF}
{  devcol^.insert(new(petiprn,init(d_barcode,'Tisk rna Ÿ rov‚ho k¢du na COM1:',1)));}
    new(pin);
    new(pout);
    pin^[0]:=$303;
    pin^[1]:=$207;
    pout^[0]:=$303;
    pout^[1]:=$207;
    devcol^.insert(new(pdigiport,init(999,'Digit ln¡ vstupy a vìstupy',2,2,pin,pout)));
    devcol^.insert(new(psyspar,init(d_syspar,'Syst‚m')));
    devcol^.store;
{    init_ok:=false;}
 
    donedlg(dlg);
  end;

  syspar:=psyspar(devcol^.atid(d_syspar));
 
  motor:=pmotor(devcol^.atid(d_motor));
  analog:=ppca1608(devcol^.atid(d_pca1608));
  pcaamp:=ppcaamp(devcol^.atid(d_pcaamp));
  digio:=pdigiport(devcol^.atid(d_digio));
  citac:=ppct2403(devcol^.atid(d_pct2403));
  tisk:=pprinter(devcol^.atid(d_lpt1));
{$IFDEF ETI}
  etiprn:=petiprn(devcol^.atid(d_etikety));
  if etiprn=nil then begin
    devcol^.atinsert(5,new(petiprn,init(d_etikety,'Tisk rna etiket DATAMAX Allegro',1)));
    etiprn:=petiprn(devcol^.atid(d_etikety));
  end;
{$IFDEF BARVY}
  ana2:=ppca1608(devcol^.atid(d_ana2));
  if ana2=nil then begin
    devcol^.atinsert(2,new(ppca1608,init(d_ana2,'MØýic¡ karta PCA-1608A (barvy)',$208)));
    ana2:=ppca1608(devcol^.atid(d_ana2));
  end;
{$ENDIF}
 
{$IFDEF MELEXIS}
  mlx:=pmelexis(devcol^.atid(d_mlx));
  if mlx=nil then begin
    devcol^.atinsert(3,new(pmelexis,init(d_mlx,'MELEXIS SDAP Programmer',2)));
    mlx:=pmelexis(devcol^.atid(d_mlx));
  end;
{$ENDIF}
 
  if paramcount<>0 then begin
    if copy(paramstr(1),1,2)='/e' then begin
      etiprn^.yoffs:=vall(copy(paramstr(1),3,length(paramstr(1))-2));
    end;
  end;
{$ENDIF}
 
{$IFNDEF ETI}
  if devcol^.atid(d_etikety)<>nil then devcol^.free(devcol^.atid(d_etikety));
  etiprn:=nil;
{$ENDIF}
 
{$IFNDEF BARVY}
  if devcol^.atid(d_ana2)<>nil then devcol^.free(devcol^.atid(d_ana2));
  ana2:=nil;
{$ENDIF}
 
{$IFNDEF MELEXIS}
  if devcol^.atid(d_mlx)<>nil then devcol^.free(devcol^.atid(d_mlx));
  mlx:=nil;
{$ENDIF}
 
  quickdevshow(devcol);
 
  ok:=true;
  ok:=ok and (syspar<>nil);
  ok:=ok and (motor<>nil);
  ok:=ok and (citac<>nil);
  ok:=ok and (analog<>nil);
  ok:=ok and (pcaamp<>nil);
  ok:=ok and (digio<>nil);
 
  if not ok then begin
    errormsg('FATµLNÖ CHYBA! Jeden nebo v¡ce z kladn¡ch ovladaŸ… hardware chyb¡!!!');
    if yesnomsg('Chcete obnovit datab zi ovladaŸ… ze z lohy?') then begin
      assign(f,progdir+devfn);
      rename(f,progdir+gettempname+'.DE?');
      infomsg('Nyn¡ se restartuje poŸ¡taŸ ...');
      reboot;
    end;
    init_ok:=false;
    menubox^.show;
    exit;
  end;
 
  ok:=true;
 
  motor^.digio:=digio;  {nastav bezpecnostni spinac motoru (digin(0,0))}
 
  ok:=ok and motor^.ready;
  ok:=ok and citac^.ready;
  ok:=ok and analog^.ready;
  ok:=ok and pcaamp^.ready;
  ok:=ok and digio^.ready;
 
{$IFDEF ALFA}
{inicializace nalepovace etiket}
 
  dlg:=msgdlg('NALEPOVA¬','Prob¡h  inicializace ... Pros¡m Ÿekejte');
 
  digio^.setout(1,2); {Zapnuti nalepovace}
  delaytick(3);
  digio^.resout(1,2);
 
  digio^.setout(1,1); {Reset nalepovace}
  delaytick(3);
  digio^.resout(1,1);
 
  donedlg(dlg);
 
{$ENDIF}
 
{$IFNDEF DOMA}
 
  if not ok then begin
    errormsg('Jeden nebo v¡ce ovladaŸ… se nepodaýilo inicializovat!');
    applog^.write('!!! Chyba pýi inicializace hardware');
    init_ok:=false;
  end else begin
  {$IFDEF ETI}
    if etiprn^.ready then begin
      st:=etiprn^.readstatus;
      if ((st and $06)=0) or (st=$FF) then begin
    {$IFNDEF ALFA}
        dlg:=msgdlg('Tisk rna etiket','Kalibrace podavaŸe ... Pros¡m odeberte etiketu!');
{        etiprn^.command(#02'O'+fill0(strl(etiprn^.yoffs),4)); {STX O - nastav pocatek tisku na dolni okraj}
        etiprn^.eti_begin;
        etiprn^.text_xy(1,2,50,50,'_');
        etiprn^.eti_end;
{        etiprn^.command(#02'F');  {Form Feed}
        delaytick(18);
        etiprn^.wait;
        donedlg(dlg);
    {$ENDIF}
        st:=etiprn^.readstatus;
        if st<>$FF then begin
          if (st and $06)<>0 then begin
          {vymaz posledni etiketu z tiskarny}
            etiprn^.sendstr(#01'C');
            infomsg('V tisk rnØ etiket doçly etikety nebo p ska. Pros¡m doplåte to, co '+
                    'chyb¡ a stisknØte FEED na tisk rnØ. Pak vytisknØte zkuçebn¡ etiketu');
            {protoze SOH C tiskarnu zapauzuje, odmackni pauzu}
            etiprn^.sendstr(#01'B');
          end;
        end;
      end else begin
        infomsg('V tisk rnØ etiket nejsou etikety nebo p ska. Pros¡m doplåte to, co'+
                'chyb¡ a stisknØte FEED na tisk rnØ. Pak vytisknØte zkuçebn¡ etiketu');
      end;
    end else begin
      errormsg('Tisk rna etiket nebyla nalezena, etikety se nebudou tisknout ...');
    end;
  {$ENDIF}
  end;
 
  if not syspar^.ready then begin
    infomsg('Pros¡m zadejte syst‚mov‚ parametry ve "Spr vci hardware" !!');
  end;
 
  if not init_ok then begin
    infomsg('Jeliko§ nØkter  z d…le§itìch Ÿ st¡ nepracuje spr vnØ, nebude mo§no prov dØt testy!');
  end else begin
  {$IFNDEF ALFA}
    if testbitw(ostpar.chkb,0) then digio^.setout(0,0);
  {$ENDIF}
  end;
 
{$ENDIF}
 
{$IFDEF ALFA}
 
  if init_ok then digio^.setout(0,0);
  {nastav CHECK na jednicku}
 
{$ENDIF}
 
{$IFDEF ALFA}
  {$IFDEF DOMA}
  if true then begin
  {$ELSE}
  if digio^.getin(1,0) then begin
  {$ENDIF}
{$ENDIF}
 
  motor^.setcurrent(m_standby); {standby rezim motoru}
 
  menubox^.show;
 
  ev.what:=evcommand;
  ev.command:=cmmenu;
 
  putevent(ev);
{$IFDEF ALFA}
  end;
 
  if not digio^.getin(0,0) then a_phase:=0 else a_phase:=1;
 
{$ENDIF}
 
end;
 
function tpedalapp.GetPalette: PPalette;
const
  CNewColor = CNewAppColor + CHelpColor;
  CNewBlackWhite = CAppBlackWhite + CHelpBlackWhite;
  CNewMonochrome = CAppMonochrome + CHelpMonochrome;
  P: array[apColor..apMonochrome] of string[Length(CNewColor)] =
    (CNewColor, CNewBlackWhite, CNewMonochrome);
begin
  GetPalette := @P[AppPalette];
end;
 
procedure tpedalapp.idle;
begin
  if not ss_flag then begin
{$IFDEF TIME}
    clock^.update;
    datum^.update;
{$ENDIF}
{$IFDEF HEAP}
    heap^.update;
{$ENDIF}
    inherited idle;
  end;
end;
 
procedure tpedalapp.initmenubox;
var r:trect;
begin
  r.assign(10,5,50,20);
  menubox:=New(PMenuBox,Init(R,NewMenu(
    NewItem('~P~rovoz','F3',kbf3,cmprovoz,hcmprov,
    newline(
    NewSubMenu('~N~astaven¡',hcmnast,NewMenu(
      NewItem('~Z~mØna typu','F9',kbf9,cmztyp,hcmztyp,
      newline(
      NewItem('~D~atab ze typ…','F4',kbf4,cmmdb,hcmdb,
      NewItem('~A~ktu ln¡ parametry','F6',kbf6,cmparams,hcmparams,
{$IFDEF ETI}
      NewItem('Aktu ln¡ ~E~tiketa','F7',kbf7,cmmeti,hcmeti,
{$IFDEF BARVY}
      NewItem('~B~arvy','Alt+F7',kbaltf7,cmmbar,hcmbar,
{$ENDIF}
{$ENDIF}
      NewLine(
      NewItem('~N~ulovat OK/ZM','',kbnokey,cmrescnt,hcmrescnt,
      newline(
      NewItem('~T~isk parametr…','',kbNoKey,cmprint,hcmprint,
    NIL
{$IFDEF ETI}
    )
{$IFDEF BARVY}
    )
{$ENDIF}
{$ENDIF}
    ))))))))),
    NewSubMenu('~K~alibrace',hcmkal,NewMenu(
      NewItem('Kalibrace ~s~¡ly','',kbNoKey,cmkalibs,hcmsil,
      newItem('Kalibrace ~e~lektrick ','',kbnokey,cmkalibe,hcmkel,
      newline(
{$IFDEF BARVY}
      newitem('Kalibrace mØýen¡ ~b~arev','',kbnokey,cmkalibb,hcmkb,
      newline(
{$ENDIF}
      newitem('~P~arametry kalibrace','',kbnokey,cmcalpar,hcmkpar,
    NIL
{$IFDEF BARVY}
    ))
{$ENDIF}
    ))))),
    NewSubMenu('~S~ervis',hcmserv,NewMenu(
      NewItem('~D~atum a Ÿas','',kbnokey,cmdtime,hcmdtime,
      NewItem('~S~pr vce hardware','',kbnokey,cmhw,hcmhw,
      NewItem('~M~Øýic¡ kan ly','',kbnokey,cmkan,hcmkan,
{$IFDEF MELEXIS}
      NewItem('~R~uŸn¡ programov n¡','',kbnokey,cmrucprg,hcmrucprg,
{$ENDIF}
      NewItem('~O~statn¡','',kbnokey,cmostpar,hcmostpar,
      newLine(
      newItem('~H~esla','',kbnokey,cmhesla,hcmhesla,
      NewLine(
      NewItem('Di~a~gnostika ...','',kbnokey,cmsup,hcmsup,
      NewLiNe(
      NewItem('O ~p~rogramu ...','',kbnokey,cmabout,hcmabout,
    NIL
{$IFDEF MELEXIS}
    )
{$ENDIF}
    ))))))))))),
    NewSubMenu('~D~ata',hcmdat,NewMenu(
      NewItem('Uk zat ~a~ktu ln¡','F5',kbf5,cmviewa,hcmvia,
      NewItem('~T~ento mØs¡c pro aktu ln¡ typ','',kbnokey,cmviewt,hcmvim,
      newItem('Uk zat ~o~statn¡ ...','',kbnokey,cmviewm,hcmvio,
    NIL)))),
    NewLine(
    NewItem('N po~v~Øda','F1',kbf1,cmhelpix,hcmhelp,
    newline(
    NewItem('K~o~nec','Alt+X',kbaltx,cmquit,hcmexit,
  NIL))))))))))),
  NIL));
end;
 
procedure tpedalapp.initstatusline;
var r:trect;
    ps:pstatusdef;
begin
  ps:=newstatusdef(hcdragging,hcdragging,
        newstatuskey('~'#24#25#26#27'~ Pýesunout',kbnokey,cmnothing,
        newstatuskey('~Shift+'#24#25#26#27'~ Velikost',kbnokey,cmnothing,
        newstatuskey('~Enter~ OK',kbnokey,cmnothing,
        newstatuskey('~Esc~ Zruçit',kbnokey,cmnothing,
      nil)))),nil);
  ps:=newstatusdef(hcapp,hcapp,
        NewStatusKey('~F1~ Pomoc',kbf1,cmhelp,
        NewStatusKey('~F3~ Provoz',kbf3,cmprovoz,
        NewStatusKey('~F6~ Param',kbf6,cmparams,
        NewStatusKey('~F10~ Menu',kbf10,cmmenu,
      nil)))),ps);
  ps:=NewStatusDef(1000,1999,
        NewStatusKey('~F1~ Pomoc',kbf1,cmhelp,
        NewStatusKey('~F3~ Provoz',kbf3,cmprovoz,
        NewStatusKey('~F6~ Param',kbf6,cmparams,
        newstatuskey('~F7~ Eti',kbf7,cmmeti,
      NIL)))),ps);
  ps:=newstatusdef(hcdp1,2099,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F6~ Dalç¡',kbf6,cmnext,
        newstatuskey('~F8~ Zkus',kbf8,cmtry,
      nil)))),ps);
  ps:=newstatusdef(hcdp2,2599,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F5~ Pýedch',kbf5,cmprev,
        newstatuskey('~F6~ Dalç¡',kbf6,cmnext,
      nil)))),ps);
  ps:=newstatusdef(2600,2699,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F5~ Pýedch',kbf5,cmprev,
      nil))),ps);
  ps:=newstatusdef(2800,2802,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F8~ Zkusit',kbf8,cmtry,
      nil))),ps);
  ps:=newstatusdef(2803,2803,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F8~ Zkusit',kbf8,cmtry,
        newstatuskey('~F9~ Vybrat',kbf9,cmfiledlg,
      nil)))),ps);
  ps:=newstatusdef(2804,2804,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~SF6~ Do seznamu',kbnokey,cmnothing,
      nil))),ps);
  ps:=newstatusdef(hcdetibar,hcdetibar,
        newstatuskey('~Del~ Vymazat',kbnokey,cmnothing,
        newstatuskey('~[%19]~ Vybrat',kbnokey,cmnothing,
{       newstatuskey('~F6~ Zjistit',kbnokey,cmnothing,}
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F8~ Zkusit',kbf8,cmtry,
      nil)))),ps);
  ps:=newstatusdef(hcdetiblb,hcdetiblb,
        newstatuskey('~Enter~ Potvrdit',kbnokey,cmnothing,
      nil),ps);
  ps:=newstatusdef(hcddtime,hcddtime,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~F3~ Nastavit',kbf3,cmok,
      nil)),ps);
  ps:=newstatusdef(hcostpar,hcdsup,
        newstatuskey('~F3~ Ulo§it',kbf3,cmok,
        newstatuskey('~Esc~ Zruçit',kbesc,cmcancel,
      nil)),ps);
  ps:=newstatusdef(hcdmkan,hcdmkan,
        newstatuskey('~Esc~ Konec',kbesc,cmcancel,
        newstatuskey('~æipky~ Re§im',kbnokey,cmnothing,
      nil)),ps);
  ps:=newstatusdef(hcddb,hcddb,
        newstatuskey('',kbf1,cmhelp,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F6~ Param',kbf6,cmparam,
{$IFDEF ETI}
        newstatuskey('~F7~ Eti',kbf7,cmeti,
{$ENDIF}
        newstatuskey('~F8~ Tisk',kbf8,cmprint,
        newstatuskey('~F10~ Menu',kbf10,cmmenu,
        newstatuskey('~Ins~ Novì',kbins,cmadd,
        newstatuskey('~Del~ Sma§',kbdel,cmdel,
      nil))))
{$IFDEF ETI}
      )
{$ENDIF}
      ))),ps);
  ps:=newstatusdef(hcdcopy,hcdcopy,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~F3~ Potvrdit',kbf3,cmok,
        newstatuskey('~Esc~ Zruçit',kbesc,cmcancel,
      nil))),ps);
  ps:=newstatusdef(hcdztyp,hcdztyp,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~Enter~',kbenter,cmok,
        newstatuskey('~F3~ Vybrat',kbf3,cmok,
        newstatuskey('~Esc~ Zruçit',kbesc,cmcancel,
      nil)))),ps);
  ps:=newstatusdef(hcdetiprn,hcdetiprn,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F8~ Test',kbf8,cmtry,
        newstatuskey('~F9~ Feed',kbf9,cmfeed,
      nil)))),ps);
  ps:=newstatusdef(hcdbarl,hcdbarl,
        newstatuskey('~Ins~ Nov ',kbins,cmadd,
        newstatuskey('~Enter~ ZmØnit',kbenter,cmshow,
        newstatuskey('~Del~ Smazat',kbdel,cmdel,
        newstatuskey('~F3~ Konec',kbf3,cmok,
      nil)))),ps);
  ps:=newstatusdef(hcdbarva,hcdbarva,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~Esc~ Zruçit',kbesc,cmcancel,
      nil)),ps);
  ps:=newstatusdef(6000,6000,
{$IFDEF ALFA}
        newstatuskey('~F2~ NulOK',kbf2,cmclrok,
{$ELSE}
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
{$ENDIF}
        newstatuskey('~F3~ Start',kbf3,cmstart,
        newstatuskey('~F4~ Graf',kbf4,cmgraf,
        newstatuskey('~F5~ Vol',kbf5,cmvol,
        newstatuskey('~F8~ Tisk',kbf8,cmprint,
        newstatuskey('~F10~ Menu',kbf10,cmmenu,
        newstatuskey('',kbf6,cmparams,
        newstatuskey('',kbf7,cmeti,
      nil)))))))),ps);
  ps:=newstatusdef(6001,6010,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~F3~ Start',kbf3,cmstart,
        newstatuskey('~F4~ Graf',kbf4,cmgraf,
        newstatuskey('~F8~ Tisk',kbf8,cmprint,
        newstatuskey('~F10~ Hl.Menu',kbf10,cmquit,
      nil))))),ps);
  ps:=newstatusdef(hcvol,hcvol,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~Esc~ Konec',kbesc,cmcancel,
        newstatuskey('~[+]~ Upnout',kbnokey,cmnothing,
        newstatuskey('~[-]~ Uvolnit',kbnokey,cmnothing,
      nil)))),ps);
  ps:=newstatusdef(7000,7001,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~F4~ Schop',kbf4,cmcschop,
        newstatuskey('~F8~ Tisk',kbf8,cmcprint,
        newstatuskey('~F10~ Menu',kbf10,cmmenu,
      nil)))),ps);
  ps:=newstatusdef(7003,7003,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F8~ Tisk',kbf8,cmcprint,
      nil)),ps);
  ps:=newstatusdef(7100,7199,
        newstatuskey('~F1~ Pomoc',kbf1,cmhelp,
        newstatuskey('~F4~ Schop',kbf4,cmcschop,
        newstatuskey('~F8~ Tisk',kbf8,cmcprint,
      nil))),ps);
  ps:=newstatusdef(9001,9001,
        newstatuskey('~SF1~ Pýedchoz¡',kbnokey,cmnothing,
        newstatuskey('~F5~ ZvØtçit',kbf5,cmzoom,
        newstatuskey('~Enter~ Skok',kbnokey,cmnothing,
        newstatuskey('~Esc~ Zavý¡t',kbesc,cmclose,
      nil)))),ps);
  ps:=newstatusdef(hcpartree+hcttparam,hcpartree+hcttparam,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F5~ Pýedch',kbf5,cmprev,
        newstatuskey('~F6~ Dalç¡',kbf6,cmnext,
      nil))),ps);
  ps:=newstatusdef(hcpartree+hcttparam_bo,hcpartree+hcttparam_bo,
        newstatuskey('~Space~ ZmØnit',kbnokey,cmnothing,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F5~ Pýedch',kbf5,cmprev,
        newstatuskey('~F6~ Dalç¡',kbf6,cmnext,
      nil)))),ps);
  ps:=newstatusdef(hcpartree+hcttparam_co,hcpartree+hcttparam_co,
        newstatuskey('~Space~',kbnokey,cmnothing,
        newstatuskey('~Enter~ Edit',kbnokey,cmnothing,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F5~ Pýedch',kbf5,cmprev,
        newstatuskey('~F6~ Dalç¡',kbf6,cmnext,
      nil))))),ps);
  ps:=newstatusdef(hcpartree+hcttparam_nv,hcpartree+hcttparam_nv,
        newstatuskey('~Enter~ Edit',kbnokey,cmnothing,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F5~ Pýedch',kbf5,cmprev,
        newstatuskey('~F6~ Dalç¡',kbf6,cmnext,
      nil)))),ps);
  ps:=newstatusdef(hcpartree+hcttparam_ev,hcpartree+hcttparam_ev,
        newstatuskey('~Space~ Zap/Vyp',kbnokey,cmnothing,
        newstatuskey('~Enter~ Edit',kbnokey,cmnothing,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F5~ Pýedch',kbf5,cmprev,
        newstatuskey('~F6~ Dalç¡',kbf6,cmnext,
      nil))))),ps);
  ps:=newstatusdef(hcpartree+hcttparam_so,hcpartree+hcttparam_so,
        newstatuskey('~Space~ Zap/Vyp',kbnokey,cmnothing,
        newstatuskey('~Enter~ Edit',kbnokey,cmnothing,
        newstatuskey('~Del~ Sma§',kbnokey,cmnothing,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F5~ Pýedch',kbf5,cmprev,
        newstatuskey('~F6~ Dalç¡',kbf6,cmnext,
      nil)))))),ps);
  ps:=newstatusdef(hcpartree+hcttparam_xs,hcpartree+hcttparam_xs,
        newstatuskey('~Enter~ Pýidej soubØh',kbnokey,cmnothing,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F5~ Pýedch',kbf5,cmprev,
        newstatuskey('~F6~ Dalç¡',kbf6,cmnext,
      nil)))),ps);
  ps:=newstatusdef(hcpartree+hcttparamr,hcpartree+hcttparamr,
        newstatuskey('~Enter~ Rozbal',kbnokey,cmnothing,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F5~ Pýedch',kbf5,cmprev,
        newstatuskey('~F6~ Dalç¡',kbf6,cmnext,
      nil)))),ps);
  ps:=newstatusdef(hcpartree+hcttparamr+1,hcpartree+hcttparamr+9,
        newstatuskey('~Space~ ZmØnit',kbnokey,cmnothing,
        newstatuskey('~Enter~ Rozbal',kbnokey,cmnothing,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~F5~ Pýedch',kbf5,cmprev,
        newstatuskey('~F6~ Dalç¡',kbf6,cmnext,
      nil))))),ps);
 
  ps:=newstatusdef(hcprgtree+hcttparam,hcprgtree+hcttparam,
        newstatuskey('~Esc~ Konec',kbesc,cmclose,
        newstatuskey('~F3~ ¬ti',kbf3,cmreadEE,
        newstatuskey('~F4~ >RAM',kbf4,cmwriteRAM,
        newstatuskey('~F5~ Vypal',kbf5,cmwriteEE,
        newstatuskey('~F8~ üeçen¡',kbf8,cmrucsolv,
      nil))))),ps);
  ps:=newstatusdef(hcprgtree+hcttparam_bo,hcprgtree+hcttparam_bo,
        newstatuskey('~Space~ ZmØnit',kbnokey,cmnothing,
        newstatuskey('~F3~ ¬ti',kbf3,cmreadEE,
        newstatuskey('~F4~ >RAM',kbf4,cmwriteRAM,
        newstatuskey('~F5~ Vypal',kbf5,cmwriteEE,
        newstatuskey('~F8~ üeçen¡',kbf8,cmrucsolv,
      nil))))),ps);
  ps:=newstatusdef(hcprgtree+hcttparam_co,hcprgtree+hcttparam_co,
        newstatuskey('~Space~',kbnokey,cmnothing,
        newstatuskey('~Enter~ Edit',kbnokey,cmnothing,
        newstatuskey('~F3~ ¬ti',kbf3,cmreadEE,
        newstatuskey('~F4~ >RAM',kbf4,cmwriteRAM,
        newstatuskey('~F5~ Vypal',kbf5,cmwriteEE,
        newstatuskey('~F8~ üeçen¡',kbf8,cmrucsolv,
      nil)))))),ps);
  ps:=newstatusdef(hcprgtree+hcttparam_nv,hcprgtree+hcttparam_nv,
        newstatuskey('~Enter~ Edit',kbnokey,cmnothing,
        newstatuskey('~F3~ ¬ti',kbf3,cmreadEE,
        newstatuskey('~F4~ >RAM',kbf4,cmwriteRAM,
        newstatuskey('~F5~ Vypal',kbf5,cmwriteEE,
        newstatuskey('~F8~ üeçen¡',kbf8,cmrucsolv,
      nil))))),ps);
  ps:=newstatusdef(hcprgtree+hcttparam_ev,hcprgtree+hcttparam_ev,
        newstatuskey('~Space~ Zap/Vyp',kbnokey,cmnothing,
        newstatuskey('~Enter~ Edit',kbnokey,cmnothing,
        newstatuskey('~F3~ ¬ti',kbf3,cmreadEE,
        newstatuskey('~F4~ >RAM',kbf4,cmwriteRAM,
        newstatuskey('~F5~ Vypal',kbf5,cmwriteEE,
        newstatuskey('~F8~ üeçen¡',kbf8,cmrucsolv,
      nil)))))),ps);
  ps:=newstatusdef(hcprgtree+hcttparamr,hcprgtree+hcttparamr,
        newstatuskey('~Enter~ Rozbal',kbnokey,cmnothing,
        newstatuskey('~F3~ ¬ti',kbf3,cmreadEE,
        newstatuskey('~F4~ >RAM',kbf4,cmwriteRAM,
        newstatuskey('~F5~ Vypal',kbf5,cmwriteEE,
        newstatuskey('~F8~ üeçen¡',kbf8,cmrucsolv,
      nil))))),ps);
  ps:=newstatusdef(hcprgtree+hcttparamr+1,hcprgtree+hcttparamr+9,
        newstatuskey('~Space~ ZmØnit',kbnokey,cmnothing,
        newstatuskey('~Enter~ Rozbal',kbnokey,cmnothing,
        newstatuskey('~F3~ ¬ti',kbf3,cmreadEE,
        newstatuskey('~F4~ >RAM',kbf4,cmwriteRAM,
        newstatuskey('~F5~ Vypal',kbf5,cmwriteEE,
        newstatuskey('~F8~ üeçen¡',kbf8,cmrucsolv,
      nil)))))),ps);
 
  ps:=newstatusdef(hcttparam_coe,hcttparam_nve,
        newstatuskey('~Enter~ OK+D le',kbnokey,cmnothing,
        newstatuskey('~SF5~ ZpØt',kbnokey,cmnothing,
        newstatuskey('~Esc~ Zruçit',kbnokey,cmnothing,
      nil))),ps);
  ps:=newstatusdef(hcttparam_eve,hcttparam_soe,
        newstatuskey('~Enter~ OK+D le',kbnokey,cmnothing,
        newstatuskey('~SF5~ ZpØt',kbnokey,cmnothing,
        newstatuskey('~Esc~ Zruçit',kbnokey,cmnothing,
        newstatuskey('~F9~ Asym.tol',kbnokey,cmnothing,
      nil)))),ps);
  ps:=newstatusdef(hcasytol,hcasytol,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~Esc~ Zruçit',kbnokey,cmnothing,
        newstatuskey('~SF5~ Pýedch',kbnokey,cmnothing,
        newstatuskey('~SF6~ Dalç¡',kbnokey,cmnothing,
      nil)))),ps);
  ps:=newstatusdef(hcerror,hcinfo,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~Enter~ OK',kbenter,cmok,
      nil)),ps);
  ps:=newstatusdef(hcyesno,hcyesno,
        newstatuskey('~A~ Ano',kbnokey,cmyes,
        newstatuskey('~N~ Ne',kbnokey,cmno,
        newstatuskey('~Esc~ ZpØt',kbesc,cmcancel,
      nil))),ps);
  ps:=newstatusdef(hcokcan,hcokcan,
        newstatuskey('~F3~/~Enter~ OK',kbf3,cmok,
        newstatuskey('~Esc~ Zruçit',kbesc,cmcancel,
      nil)),ps);
  ps:=newstatusdef(hclistm,hclistm,
        newstatuskey('~F3~ OK',kbf3,cmok,
      nil),ps);
  ps:=newstatusdef(hcuserdlg,hcuserdlg,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~Esc~ Zruçit',kbesc,cmcancel,
      nil)),ps);
  ps:=newstatusdef(hcuserlst,hcuserlst,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~Ins~ Novì',kbins,cmadd,
        newstatuskey('~Enter~ ZmØnit',kbenter,cmedit,
        newstatuskey('~Del~ Smazat',kbdel,cmdel,
      nil)))),ps);
  ps:=newstatusdef(hclogin,hclogin,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~Kl¡Ÿ~ OK',kbnokey,cmnothing,
        newstatuskey('~[%19]~ Vybrat',kbnokey,cmnothing,
        newstatuskey('~Esc~ Zruçit',kbesc,cmcancel,
      nil)))),ps);
  ps:=newstatusdef(hcconfpw,hcconfpw,
        newstatuskey('~F3~ OK',kbf3,cmok,
        newstatuskey('~Esc~ Zruçit',kbesc,cmcancel,
      nil)),ps);
  ps:=newstatusdef(hcabout,hcabout,
        newstatuskey('~F3~ OK',kbf3,cmok,
      nil),ps);
{$IFDEF DEBUG}
  ps:=newstatusdef(hckjdbgwin,hckjdbgwin,
        newstatuskey('~Esc~ Konec',kbesc,cmclose,
        newstatuskey('~F5~ Zoom',kbf5,cmzoom,
        newstatuskey('~Ctrl+F5~ Resize',kbctrlf5,cmresize,
      nil))),ps);
{$ENDIF}
 
  GetExtent(R);
  R.A.Y:=R.B.Y-1;
  StatusLine:=New(PMyStatusLine,Init(R,ps));
 
end;
 
procedure tpedalapp.initdesktop;
var r:trect;
begin
  getextent(r);
  inc(r.a.y);
  dec(r.b.y);
  desktop:=new(pmydesktop,init(r));
end;
 
procedure tpedalapp.showcurrent;
var s:string[24];
    t:string[24];
    pt:ptyprec;
begin
  s:='';
  if typcol=nil then exit;
  pt:=typcol^.atid(typcol^.current);
  if pt=nil then s:=' -- nenalezen --';
  if typcol^.current=emptyword then s:=' -- § dnì --';
  if s='' then s:=pt^.typ;
  s:=align(s,14,0);
  move(s[1],title^.text^[26],14);
  title^.draw;
  if pt<>nil then begin
  {nastavime napeti atd...}
    if testbitw(pt^.senz,st_10v) then m_volt:=0 else m_volt:=(mv_5V or mv_50uA);
    m_MLX:=testbitw(pt^.senz,st_melexis);
  end;
end;
 
{$IFDEF ALFA}
 
procedure tpedalapp.getevent(var event:tevent);
{getevent pro ALFU}
var chf:boolean;
    w:word;
    ph:boolean; {pre-hand}
    ok:boolean;
    hc:word;
    dlg:pdialog;
    fl:boolean;
    pt:ptyprec;
begin
  if digio=nil then begin
    inherited getevent(event);
    exit;
  end;
  w:=word(digio^.getinb(0))+(word(digio^.getinb(1)) shl 8);
  ph:=(prein and 1)<>0; {zjisti minuly stav HAND}
{$IFDEF DOMA}
  if prein<>w then begin
    {ODSTRANENI KMITU TLACITEK}
    delaytick(2);
    w:=word(digio^.getinb(0))+(word(digio^.getinb(1)) shl 8);
  end;
{$ENDIF}
  if prein<>w then begin
    chf:=true;
    prein:=w;
  end else chf:=false;
 
{SEKCE KOPIROVANI VSTUPU A VYSTUPU "NATVRDO"}
 
  ok:=digio^.getin(1,5) and etiprn^.ready;
  digio^.outp(1,5,ok);
 
{$IFNDEF DOMA}
  ok:=ok and motor^.ready;
  ok:=ok and citac^.ready;
  ok:=ok and analog^.ready;
  ok:=ok and pcaamp^.ready;
  ok:=ok and digio^.ready;
{$ENDIF}
 
  ok:=ok and digio^.getin(0,0); {and total stop}
  if not digio^.getin(1,0) then begin
    {v automatickem rezimu jeste kontroluj okynka}
    hc:=topview^.gethelpctx;
    ok:=ok and (not ((hc>=hcerror) and (hc<=hclistm)));
  end;
 
  digio^.outp(0,0,ok);
 
  {mame smer vpravo a nemame kalib. pripravek}
  fl:=(pedalmer.smer) and (not digio^.getin(0,2));
  {mame smer vlevo a musime mit kalib. pripravek}
  fl:=fl or (not pedalmer.smer) and (digio^.getin(0,2));
  fl:=fl and a_refpos;
 
  digio^.outp(0,5,fl);
 
{KONEC}
 
{automaticka obsluha}
 
  if chf and digio^.getin(1,4) then begin
    if etiprn<>nil then begin
      etiprn^.ready:=true;
      dlg:=msgdlg('Tisk rna etiket','Kalibrace podavaŸe ... Pros¡m odeberte etiketu!');
      etiprn^.eti_begin;
      etiprn^.text_xy(1,2,50,50,'_');
      etiprn^.eti_end;
      delaytick(18);
      etiprn^.wait;
      donedlg(dlg);
      dlg:=msgdlg('Tisk rna etiket','Kalibrace podavaŸe ... Pros¡m uvolnØte tlaŸ¡tko');
      repeat until not digio^.getin(1,4);
      donedlg(dlg);
    end;
  end;
 
{KONEC}
 
{$IFNDEF DOMA}
  if not digio^.getin(1,0) then begin
    if (menubox^.state and sfvisible)<>0 then menubox^.hide;
    if chf then begin
      event.what:=evcommand;
      event.command:=cminchanged;
    end else begin
      inherited getevent(event);
      clearevent(event);
    end;
  end else begin
    if chf then begin
      if ph then begin
        event.what:=evcommand;
        event.command:=cminchanged;
        exit;
      end;
    end;
    inherited getevent(event);
  end;
{$ELSE}
  inherited getevent(event);
{$ENDIF}
end;
 
{$ELSE}
 
procedure tpedalapp.getevent(var event:tevent);
{getevent pro normalni verzi}
var HFile: PHelpFile;
    HelpStrm: PDosStream;
    hcx:word;
    helpw:pkjhelpwin;
    mbf:boolean;
    b:boolean;
 
    i:integer;
    j:integer;
    dl:longint;
 
    h,m,s,w:word;
begin
  inherited getevent(event);
 
  if (event.what=evnothing) and (digio<>nil) then begin
    {RESET}
    b:=digio^.getin(0,2);
    if (p_reset=false) and b then begin
      event.what:=evkeydown;
      event.keycode:=kbesc;
    end;
    p_reset:=b;
    {START}
    b:=digio^.getin(0,3);
    if (p_start=false) and b then begin
      event.what:=evcommand;
      event.command:=cmstart;
    end;
    p_start:=b;
  end;
 
  if not ss_flag then begin
    if (event.what=evcommand) and ((event.command=cmhelp) or (event.command=cmhelpix)) then begin
      HelpStrm := New(PDosStream, Init(helpfn, stOpenRead));
      if HelpStrm^.Status <> stOk then begin
         errormsg('Nemohu otevý¡t soubor s n povØdou!');
      end else begin
        HFile := New(PHelpFile, Init(HelpStrm));
        if event.command=cmhelpix then hcx:=hcindex else hcx:=gethelpctx;
        helpw := New(PKJHelpWin,Init(HFile, hcx)); {!!!}
        helpw^.helpctx:=hchelpwin;
        if ValidView(helpw) <> nil then begin
          desktop^.execview(helpw);
          dispose(helpw,done);
        end;
        ClearEvent(Event);
      end;
    end;
{$IFDEF DEBUG}
    if (event.what=evkeydown) then begin
      if event.keycode=kbaltw then begin
        if debug<>nil then desktop^.execview(debug);
        clearevent(event);
      end;
    end;
{$ENDIF}
  end;
 
  if (event.what=evnothing) {and (digio^.getin(0,0)=true)} then begin
    if not ss_flag then begin
      if (gettickcount-ss_time>(18*ss_delay)) and (ss_enable) then begin
        ss_flag:=true;
        i:=0;
        randomize;
        repeat
          repeat
            j:=random(25*80);
          until bytes(screenbuffer^)[j*2]<>0;
          bytes(screenbuffer^)[j*2]:=0;
          bytes(screenbuffer^)[j*2+1]:=0;
          inc(i);
 
          for dl:=0 to 500 do begin
            j:=round(dl/1000);
          end;
 
        until (i=25*80);
        hidemouse;
        donevideo;
        donesyserror;
        scrs.init;
      end else begin
        if not ss_enable then ss_time:=gettickcount;
      end;
    end else begin
      scrs.iterate;
      gettime(h,m,s,w);
      if (h=23) and (m=59) then begin
        ss_flag:=false;
        scrs.done;
        initsyserror;
        initvideo;
{$IFNDEF NOCG}
        installdosfont(@font_fpmlat,16);
{$ENDIF}
        showmouse;
        redraw;
        ss_time:=gettickcount;
      end;
    end;
  end else begin
    if ss_flag then begin
      ss_flag:=false;
      scrs.done;
      initsyserror;
      initvideo;
{$IFNDEF NOCG}
      installdosfont(@font_fpmlat,16);
{$ENDIF}
      showmouse;
      redraw;
      clearevent(event);
    end;
    ss_time:=gettickcount;
  end;
end;
 
{$ENDIF}
 
procedure tpedalapp.handleevent(var event:tevent);
 
procedure params;
var s:string;
    rec:ptyprec;
begin
  if typcol^.current=emptyword then begin
    errormsg('Nen¡ zad n aktu ln¡ typ!');
    exit;
  end;
  if not psw_login(rg_typy) then exit;
  rec:=ptyprec(typcol^.atid(typcol^.current));
  if paramdlg(rec,1) then begin
    showcurrent;
    typcol^.write;
  end;
end;
 
procedure etikety;
var rec:retidlg;
    w:word;
begin
  if etiprn=nil then begin
    errormsg('Tisk rna etiket nen¡ nainstalov na. Kontaktujte firmu B”hm!');
    exit;
  end;
  if typcol^.current=emptyword then begin
    errormsg('Nen¡ zad n aktu ln¡ typ!');
    exit;
  end;
  if not psw_login(rg_eti or rg_relpos) then exit;
  rec:=ptyprec(typcol^.atid(typcol^.current))^.etiketa;
  if (rec.txt[0].txt='') and (rec.txt[0].fnt=0)
    then rec.txt[0].txt:=ptyprec(typcol^.atid(typcol^.current))^.typ;
  w:=executedialog(new(petidlg,init(etiprn)),@rec);
  if w=cmok then begin
    ptyprec(typcol^.atid(typcol^.current))^.etiketa:=rec;
    typcol^.write;
  end;
end;
 
procedure rescnt;
begin
  if yesnomsg('Opravdu chcete vynulovat Ÿ¡taŸ dobrìch kus… a zmetk…?') then clear_okzm;
end;
 
procedure help;
begin
end;
 
procedure provoz;
var rec:ptyprec;
    dlg:pdialog;
    i:integer;
    ff:boolean;
    zpos:longint;
begin
{$IFNDEF SIMULACE}
  if not init_ok then begin
    errormsg('Hardware nen¡ v poý dku, nemohu spustit test!');
    exit;
  end;
  if not syspar^.ready then begin
    errormsg('Nejsou zad ny syst‚mov‚ parametry!');
    exit;
  end;
{$ENDIF}
 
{$IFDEF ALFA}
  {automaticky vyber typu}
 
  {Pokud neni rucni provoz}
  if not digio^.getin(1,0) then begin
    if a_getktyp=0 then begin
      dlg:=msgdlg('Chyba',^C'æpatnØ nastaven  poloha osy!'^M^C'Enter = OK');
      repeat
        digio^.resout(0,0); {shodime check}
 
      until false;
      digio^.setout(0,0); {nahodime check}
      donedlg(dlg);
    end;
    dlg:=msgdlg('DATABµZE','Vyhled v m nastavenì typ');
    if typcol^.count=0 then begin
      digio^.resout(0,0); {shod CHECK}
      donedlg(dlg);
      errormsg('Datab ze typ… je pr zdn ! Je nutno zadat nØjak‚ typy!');
      exit;
    end else begin
      ff:=false;
      for i:=0 to typcol^.count-1 do begin
        rec:=typcol^.at(i);
        if rec^.params.param1.kka=a_getktyp then begin
          if typcol^.current<>rec^.id then begin
            typcol^.current:=rec^.id;
            showcurrent;
            typcol^.write;
          end;
          ff:=true;
          break;
        end;
      end;
      if ff=false then begin
        donedlg(dlg);
        errormsg('TypID '+strl(a_getktyp)+' nen¡ v datab zi!');
        exit;
      end;
    end;
    donedlg(dlg);
  end else begin
    if typcol^.atid(typcol^.current)<>nil then begin
      rec:=typcol^.atid(typcol^.current);
      if rec^.params.param1.kka<>emptyword then begin
        if a_getktyp=0 then begin
          errormsg('æpatnØ nastaven  poloha osy! Pros¡m nastavte polohu '+strl(rec^.params.param1.kka)+'!');
          exit;
        end else begin
          if rec^.params.param1.kka<>a_getktyp then begin
            errormsg('Pros¡m nastavte osu do polohy '+strl(rec^.params.param1.kka)+'!');
            exit;
          end;
        end;
      end;
    end;
  end;
 
{$ENDIF}
 
  if typcol^.current=emptyword then begin
    errormsg('Nen¡ zad n aktu ln¡ typ!');
    exit;
  end;
 
  rec:=ptyprec(typcol^.atid(typcol^.current));
 
{$IFNDEF SIMULACE}
  motor^.recover;  {kdyby se prerusilo, tak se zotav}
  dlg:=msgdlg('MOTOR','Naj¡§d¡ se do z kladn¡ polohy, pros¡m Ÿekejte ...');
{$IFDEF ALFA}
  digio^.setout(0,7); {runsign}
{$ENDIF}
  m_setdir(rec^.smer);
  {citac se vynuluje, az dojede na pozici}
  zpos:=rec^.refd;
{$IFDEF ALFA}
{  if zpos>a_zpos then zpos:=a_zpos;}
  zpos:=zpos-a_zpdif;
  {predzakladni poloha aby se neurazil pedal}
{$ENDIF}
  if not m_gotoref(zpos) then begin
    donedlg(dlg);
{$IFDEF ALFA}
  digio^.resout(0,7);
{$ENDIF}
{$IFDEF ALFA}
    if digio^.getin(1,0) then begin
    delaytick(2);
{$ENDIF}
    errormsg('Naj¡§dØn¡ pýeruçeno bezpeŸnostn¡m sp¡naŸem!');
{$IFDEF ALFA}
    end else begin
      dlg:=msgdlg('Chyba','PüERUæENÖ BEZPE¬NOSTNÖM SPÖNA¬EM');
      delaytick(32);
      donedlg(dlg);
    end;
{$ENDIF}
    exit;
  end;
  donedlg(dlg);
{$IFDEF ALFA}
  digio^.resout(0,7);
{$ENDIF}
{$ENDIF}
 
  motor^.setcurrent(m_standby); {vypni proud motoru - standby}
 
  executedialog(new(presultdlg,init(rec,etiprn,nil)),nil);
end;
 
procedure dtime;
begin
  if not psw_login(rg_ostpar) then exit;
  executedialog(new(pdtimedlg,init),nil);
end;
 
procedure dbase;
var rec:tlbrec;
begin
  if not psw_login(rg_typy) then exit;
  rec.list:=typcol;
  rec.sel:=0;
  applog^.write('Datab ze typ…');
  executedialog(new(ptyplistdlg,init),@rec); {ulozi se samo}
end;
 
procedure ztyp;
var rec:tlbrec;
    w:word;
    p:pointer;
    pt:ptyprec;
begin
  if typcol^.count=0 then begin
    infomsg('V datab zi jeçtØ nen¡ zad n § dnì typ. Bude vyvol na datab ze typ… ...');
    dbase;
    exit;
  end;
  rec.list:=typcol;
  p:=typcol^.atid(typcol^.current);
  if p<>nil then rec.sel:=typcol^.indexof(p) else rec.sel:=0;
  w:=executedialog(new(pztypdlg,init),@rec);
  if w=cmok then begin
    pt:=ptyprec(typcol^.at(rec.sel));
    if pt<>typcol^.atid(typcol^.current) then begin
      if yesnomsg('Opravdu chcete zmØnit aktu ln¡ typ?') then begin
        pt:=ptyprec(typcol^.at(rec.sel));
        typcol^.current:=pt^.id;
        showcurrent;
        applog^.write('@ ZmØna typu: '+pt^.typ);
{$IFNDEF ALFA}
        infomsg('Pro typ '+pt^.typ+' nasaÔte:'+
              ^M'Pý¡pravek Ÿ.: '+strl(pt^.kpri)+
              ^M'    Kabel Ÿ.: '+strl(pt^.kka));
{$ENDIF}
        if yesnomsg('Chcete tak‚ vynulovat Ÿ¡taŸ dobrìch kus… a zmetk…?') then clear_okzm;
        typcol^.write;
      end;
    end else begin
      infomsg('Tento typ je ji§ vybr n jako aktu ln¡!');
    end;
  end;
end;
 
procedure viewm;
var w:word;
    fn:string;
    var r:trect;
    s:string;
begin
  fn:='';
  getdir(0,s);
  clriores;
  fn:=datadir;
  dec(byte(fn[0]));
  chdir(fn);
  if ioresult<>0 then errormsg('Nemohu naj¡t adres ý '+datadir);
  fn:='';
  w:=executedialog(new(pfiledialog,init('*.0??','Vyberte datovì soubor','Soubor:',fdopenbutton,0)),@fn);
  if (w=cmok) or (w=cmfileopen) then begin
    executedialog(new(pviewer,init(fn,fpmid,fn)),nil);
  end;
  chdir(s);
end;
 
procedure viewa;
var r:trect;
    s:string;
    s1:string;
    d:string[15];
    dt:string[15];
begin
  if typcol^.current=emptyword then begin
    errormsg('Nen¡ zad n aktu ln¡ typ!');
    exit;
  end;
  d:=ptyprec(typcol^.atid(typcol^.current))^.typ;
  dt:=d;
  cleanstr(d,' ');
  if length(d)>8 then system.insert('.',d,8);
  s:=datadir+d+'\'+boschfd+'\*.'+dayext;
  s1:=findnewest(s);
  if s1='' then begin
    infomsg(^C'Typ '+dt+' se dnes jeçtØ nezkouçel. Aktu ln¡ datovì soubor neexistuje!');
  end else begin
    executedialog(new(pviewer,init('Aktu ln¡ data pro '+dt,fpmid,s1)),nil);
  end;
end;
 
procedure viewt;
var s:string;
    fn:string;
    d:string[15];
    dt:string[15];
    w:word;
begin
  fn:='';
  getdir(0,s);
  if typcol^.current=emptyword then begin
    errormsg('Nen¡ zad n aktu ln¡ typ!');
    exit;
  end;
  d:=ptyprec(typcol^.atid(typcol^.current))^.typ;
  dt:=d;
  cleanstr(d,' ');
  if length(d)>8 then system.insert('.',d,8);
  if dir_exist(datadir+d) then begin
    if dir_exist(datadir+d+'\'+boschfd) then begin
      chdir(datadir+d+'\'+boschfd);
      w:=executedialog(new(pfiledialog,init('*.0??','Vyberte datovì soubor','Soubor:',fdopenbutton,0)),@fn);
      if (w=cmok) or (w=cmfileopen) then begin
        executedialog(new(pviewer,init(fn,fpmid,fn)),nil);
      end;
    end else begin
      infomsg(^C'Typ '+dt+' se tento mØs¡c jeçtØ nezkouçel. Adres ý neexistuje!');
    end;
  end else begin
    infomsg(^C'Typ '+dt+' se jeçtØ nikdy nezkouçel. Jeho adres ý neexistuje!');
  end;
  chdir(s);
end;
 
procedure printp;
var pt:ptyprec;
begin
  pt:=ptyprec(typcol^.atid(typcol^.current));
  if pt<>nil then begin
    printparam(pt);
  end;
end;
 
procedure hwman;
var w:word;
begin
  if not psw_login(rg_hwman) then exit;
  if hwwarning then begin
    applog^.write('Spr vce hardware !!');
    w:=application^.executedialog(new(pdevdlg,init(devcol)),nil);
    devcol^.store;
  end;
end;
 
procedure kan;
begin
  if (analog=nil) or (pcaamp=nil) then begin
    errormsg('Nemohu spustit mØýen¡, chyb¡ ovladaŸe mØýic¡ch karet!');
    exit;
  end;
  application^.executedialog(new(pmerdlg,init),nil);
end;
 
procedure calpar;
begin
  m_calpar;
end;
 
procedure h_ostpar;
var w:word;
    rec:tostpar;
begin
  if not psw_login(rg_ostpar) then exit;
  if not ostwarndlg then exit;
  rec:=ostpar;
  w:=application^.executedialog(new(postpardlg,init),@rec);
  if w=cmok then begin
    ostpar:=rec;
    if ostpar.netw<>'' then begin
      if ostpar.netw[length(ostpar.netw)]<>'\' then ostpar.netw:=ostpar.netw+'\';
      if not dir_exist(ostpar.netw) then begin
        errormsg('Adres ý '+ostpar.netw+' neexistuje!');
      end;
    end;
    applog^.write('Editace ostatn¡ch parametr…');
    writecfg;
    if testbitw(ostpar.chkb,0) then digio^.setout(0,0) else digio^.resout(0,0);
    netdir:=ostpar.netw;
  end;
end;
 
procedure kalibsily;
var smer:word;
begin
  if not psw_login(rg_ksily) then exit;
  if typcol^.current=emptyword then begin
    errormsg('Nen¡ zad n aktu ln¡ typ! Bude se kalibrovat na PRAVOU stranu.');
    smer:=0;
  end else begin
    smer:=ptyprec(typcol^.atid(typcol^.current))^.smer;
  end;
  m_setdir(smer);
  applog^.write('[K] Kalibrace s¡ly');
  k_kalibsily;
end;
 
procedure kalibel;
begin
  if not psw_login(rg_kel) then exit;
  applog^.write('[K] Kalibrace elektrick ');
  k_kalibel;
end;
 
procedure super;
var w:word;
    b:boolean;
begin
  b:=psw_login(rg_diags);
  if b then begin
    applog^.write('Diagnostick‚ parametry');
    w:=application^.executedialog(new(pdiagdlg,init),@diagopt);
  end else begin
    infomsg('Nastaven¡ vynulov no ...');
    fillchar(diagopt,sizeof(diagopt),0);
  end
end;
 
procedure barvy;
var rec:tlistboxrec;
begin
  if not psw_login(rg_barvy) then exit;
  rec.list:=barvycol;
  rec.sel:=0;
  applog^.write('Editace parametr… barev');
  application^.executedialog(new(pbarvyldlg,init),@rec);
end;
 
procedure about;
begin
  application^.executedialog(new(paboutdlg,init),nil);
end;
 
procedure hesla;
begin
  if not psw_login(rg_users) then exit;
  applog^.write('Editace u§ivatel… a hesel');
  psw_edit;
end;
 
procedure rucprg;
var pt:ptyprec;
    kb:byte;
begin
  if typcol^.current<>emptyword then begin
    pt:=typcol^.atid(typcol^.current);
    if pt<>nil then begin
 
{$IFNDEF DOMA}
{$IFNDEF BELGIE}
      if testbitw(pt^.senz,st_melexis) then begin
        kb:=m_getkkab;
        if (kb>=12) and (kb<=14) then begin
          if not psw_login(rg_ostpar) then exit;
{$ENDIF}
{$ENDIF}
          rucprgdlg(pt);
{$IFNDEF DOMA}
{$IFNDEF BELGIE}
        end else errormsg('Programovatelnì senzor m…§e bìt pýipojen pouze na kabely 12..14!');
      end else errormsg('Tento typ nelze programovat!');
{$ENDIF}
{$ENDIF}
 
    end else errormsg('Nen¡ vybr n typ (asi chyba ID)');
  end else errormsg('Nen¡ vybr n § dnì typ!');
end;
 
{tpedalapp.handleevent}
 
{$IFDEF ALFA}
label hx;
{$ENDIF}
 
begin
  if ss_flag then begin
    clearevent(event);
    exit;
  end;
{$IFDEF PSWEXIT}
  if event.what=evcommand then begin
    if event.command=cmquit then begin
      menubox^.hide;
      if not psw_login(rg_hwman or rg_users) then clearevent(event);
      menubox^.show;
    end;
  end;
{$ENDIF}
  inherited handleevent(event);
  if event.what=evcommand then begin
{$IFDEF ALFA}
  {$IFDEF DOMA}
  if true then begin
  {$ELSE}
  if digio^.getin(1,0) then begin
  {$ENDIF}
  {kdyz je HAND}
{$ENDIF}
    menubox^.hide;
    case event.command of
      cmparams:params;
{$IFDEF ETI}
      cmmeti:etikety;
{$IFDEF BARVY}
      cmmbar:barvy;
      cmkalibb:if psw_login(rg_kbar) then begin
        applog^.write('[K] Kalibrace barev');
        b_kalib;
      end;
{$ENDIF}
{$ENDIF}
{$IFDEF MELEXIS}
      cmrucprg:rucprg;
{$ENDIF}
      cmrescnt:rescnt;
      cmprovoz:provoz;
      cmstart:provoz;
      cmhelp:help;
      cmdtime:dtime;
      cmmdb:dbase;
      cmztyp:ztyp;
      cmviewm:viewm;
      cmviewa:viewa;
      cmviewt:viewt;
      cmprint:printp;
      cmhw:hwman;
      cmkan:kan;
      cmcalpar:calpar;
      cmkalibs:kalibsily;
      cmkalibe:kalibel;
      cmostpar:h_ostpar;
      cmsup:super;
      cmabout:about;
      cmhesla:hesla;
    end;
{$IFDEF ALFA}
{$IFDEF DOMA}
    if true then begin
{$ELSE}
    if digio^.getin(1,0) then begin
{$ENDIF}
{$ENDIF}
    menubox^.show;
    event.what:=evcommand;
    event.command:=cmmenu;
    putevent(event);
{$IFDEF ALFA}
    end;
   end else begin
     menubox^.hide;
     {kdyz je automatic}
     if event.command=cminchanged then begin
       if not digio^.getin(0,0) then begin
         a_phase:=0;
         goto hx;
       end else begin
         a_phase:=1;
       end;
       if digio^.getin(0,1) then begin
         {kdyz je INIT}
         {zjisti aktualni typ podle cisla}
         provoz;
         goto hx;
       end;
     end;
hx:
     if digio^.getin(1,0) then begin
       menubox^.show;
       event.what:=evcommand;
       event.command:=cmmenu;
       putevent(event);
     end;
   end;
{$ENDIF}
  end;
end;
 
destructor tpedalapp.done;
begin
  digio^.clearall; {vsechno do nuly}
{  typcol^.write;}
  dispose(typcol,done);
  dispose(devcol,done);
{$IFDEF ETI}
{$IFDEF BARVY}
  dispose(barvycol,done);
{$ENDIF}
{$ENDIF}
  disposemenu(menubox^.menu);
{$IFDEF DEBUG}
  debug_done;
{$ENDIF}
  psw_done;
 
  applog^.write('*** Program ukonŸen '#13#10);
 
  dispose(applog,done);
 
  inherited done;
end;
 
{$F+}
 
var oldexit:pointer;
    s:string;
 
procedure antihrut; far;
begin
  exitproc:=oldexit;
  if exitcode<>0 then begin
    if digio<>nil then digio^.clearall;
    if motor<>nil then motor^.abort;
    case exitcode of
      162: s:='162: Selh n¡ hardwaru';
      200: s:='200: DØlen¡ nulou';
      202: s:='PýeplnØn¡ prog. z sobn¡ku';
      203: s:='PýeplnØn¡ pamØti (heap)';
      204: s:='Neplatn  operace s ukazatelem';
      205: s:='205: Aritmetick‚ pýeteŸen¡';
      206: s:='206: Aritmetick‚ podteŸen¡';
      207: s:='207: Neplatn  operace FPU';
      210: s:='Objekt nebyl inicializov n';
      211: s:='Vol n¡ abstraktn¡ metody';
      212: s:='Chyba pýi registraci streamu';
      213: s:='Index kolekce mimo rozsah';
      214: s:='214: PýeplnØn¡ kolekce';
      215: s:='215: Chyba pýi vìpoŸtu';
      216: s:='Obecn‚ selh n¡ ochrany (GPF)';
      220: s:='220: Singul rn¡ matice';
      230: s:='Nepodaýilo se zkalibrovat';
    else
      s:='Neobvykl  chyba Ÿ¡slo '+strl(exitcode);
    end;
 
    applog^.write('!!! Runtime Error '+strl(exitcode)+' !!!'#13#10);
 
    messagebox('%03Pýi bØhu programu doçlo k chybØ'^M^C'a bude ukonŸen'^M'%03('+s+')',nil,
               mferror+mfokbutton+mfinsertinapp);
    {pri chybe by se nemela ukladat databaze typu!!!}
    {pedalapp.done;}
    dispose(typcol,done);
    dispose(devcol,done);
    psw_done;
    clearscreen;
  end;
end;
 
procedure getver;
var c:char;
begin
{$IFDEF SIMULACE}
  c:='s';
{$ELSE}
  {$IFDEF ALFA}
    c:='a';
  {$ELSE}
    {$IFDEF ETI}
      c:='e';
      {$IFDEF BARVY}
        c:='b';
      {$ENDIF}
    {$ELSE}
      c:='q';
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  verstr:=ver+c+'/'+bld;
end;
 
{MAIN}
 
var hp:longint;
 
begin
 
  oldexit:=exitproc;
  exitproc:=@antihrut;
 
  hp:=memavail;
 
  getver;
 
  ss_flag:=false;
  ss_enable:=true;
 
  a_phase:=0;
 
  pedalapp.init;
 
  pedalapp.run;
  pedalapp.done;
 
  if memavail<>hp then begin
    {leak 1920 bytes je z cehosi systemoveho a neda se zjistit proc}
    {je to asi obrazovka, protoze 1920 = 24*80}
    if (hp-memavail)<>1920 then begin
      writeln;
      writeln;
      writeln('!!! Memory leak: ',hp-memavail,' bytes!');
      delaytick(18);
    end;
  end;
 
end.
 