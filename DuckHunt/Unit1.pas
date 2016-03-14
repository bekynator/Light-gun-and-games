unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, StdCtrls, MMSystem, CPDrv, IniFiles;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Ducks: TImageList;
    Render: TTimer;
    Move: TTimer;
    Dog: TImageList;
    Image2: TImage;
    CommPortDriver1: TCommPortDriver;
    SettingRender: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure RenderTimer(Sender: TObject);
    procedure MoveTimer(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CommPortDriver1ReceiveData(Sender: TObject; DataPtr: Pointer;
      DataSize: Cardinal);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SettingRenderTimer(Sender: TObject);
  private
    { Private declarations }
  public
    procedure nextDuck;
    { Public declarations }
  end;

var
  Form1: TForm1;
  anim,animD,animD2,animS,StI,StDx,StDy,StSI,PhtRes,BlackL,StpBlckC,Score:integer;
  R:TRect;
  animA:string; //Направление анимации
  Background,Green:TBitmap;
  DogWDuck,DogRolf,DogRolfA,ScnWait,StpShow:boolean;
  StC:array[0..5] of record
  x,y:integer;
  end;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
Ini:TIniFile;
begin
Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'setup.ini');
R.Left:=0; R.Top:=0;
R.Right:=Ini.ReadInteger('Main','ResWidth',640);
R.Bottom:=Ini.ReadInteger('Main','ResHeight',480);;
CommPortDriver1.PortName:=Ini.ReadString('Connection','Port','\\.\Com7');
StpShow:=Ini.ReadBool('Main','ShowSetup',true);
Ini.Free;

ShowCursor(false);

CommPortDriver1.BaudRateValue:=9600;
CommPortDriver1.DataBits:=db8BITS;
CommPortDriver1.Connect;

ScnWait:=false;

BorderStyle:=bsNone;
WindowState:=wsMaximized;

Color:=clBlack;

Image2.Width:=R.Right;
Image2.Height:=R.Bottom;
Image2.Left:=Screen.Width div 2 - Image2.Width div 2;
Image2.Top:=Screen.Height div 2 - Image2.Height div 2;

Randomize;
DoubleBuffered:=true;

//Начальные координаты уток
StC[0].x:=125;
StC[0].y:=160;

StC[1].x:=105;
StC[1].y:=160;

StC[2].x:=256;
StC[2].y:=40;

StC[3].x:=256;
StC[3].y:=60;

StC[4].x:=-38;
StC[4].y:=40;

StC[5].x:=-38;
StC[5].y:=60;

StI:=random(Length(StC));

Background:=TBitmap.Create;
Background.LoadFromFile('Sprites\background.bmp');

Green:=TBitmap.Create;
Green.LoadFromFile('Sprites\green.bmp');
Green.Transparent:=true;
Green.TransparentColor:=clFuchsia;

BlackL:=0;
StpBlckC:=0;

animD:=0;
animD2:=160;
Score:=0;

DogWDuck:=false;
DogRolf:=false;

Image1.Canvas.Brush.Color:=clBlack;
Image1.Canvas.Font.Color:=clWhite;
Image1.Canvas.Font.Size:=6;

if StpShow then SettingRender.Enabled:=true else nextDuck;
end;

procedure TForm1.RenderTimer(Sender: TObject);
begin
Image1.Canvas.Draw(0,0,Background);

Image1.Canvas.Brush.Color:=clBlack;

if CommPortDriver1.Connect=false then begin
Image1.Canvas.TextOut(10,10,' Пистолет не найден ');
end;

if AnimA='UP' then
if (anim<6) or (anim>8) then anim:=6;

if AnimA='LEFTUP' then
if (anim<14) or (anim>16) then anim:=14;

if AnimA='LEFT' then
if (anim<11) or (anim>13) then anim:=11;

if AnimA='RIGHTUP' then
if (anim<3) or (anim>5) then anim:=3;

if AnimA='RIGHT' then
if (anim<0) or (anim>2) then anim:=0;

if AnimA='SHOT' then anim:=9;

if (AnimA<>'SHOT') and (AnimA<>'DOWN') then Ducks.Draw(Image1.Canvas,StC[StI].x,StC[StI].y,anim,true) else begin

if animS>2 then Ducks.Draw(Image1.Canvas,StC[StSI].x,StC[StSI].y,10,true) else Ducks.Draw(Image1.Canvas,StC[StSI].x,StC[StSI].y,anim,true);
inc(animS);
end;

inc(anim);

if DogWDuck then begin
inc(animD);
if animD>24 then animD2:=animD2+2 else animD2:=animD2-2;
Dog.Draw(Image1.Canvas,100,animD2,2,true);
if animD>50 then begin DogWDuck:=false; animD:=0; animD2:=160; nextDuck; end;
end;

if DogRolf then begin
inc(animD);
if animD>24 then animD2:=animD2+2 else animD2:=animD2-2;
if DogRolfA then Dog.Draw(Image1.Canvas,110,animD2,0,true) else Dog.Draw(Image1.Canvas,110,animD2,1,true);
if DogRolfA then DogRolfA:=false else DogRolfA:=true;
if animD>50 then begin DogRolf:=false; animD:=0; animD2:=160; nextDuck; end;
end;

Image1.Canvas.Draw(0,0,Green);

Image1.Canvas.TextOut(20,210,' Очки: '+IntToStr(Score*100)+' ');

Image2.Canvas.StretchDraw(R,Image1.Picture.Graphic);
end;

procedure TForm1.MoveTimer(Sender: TObject);
begin
//Направления движения
case StI of


0: begin

if StC[StI].y>117 then begin
AnimA:='UP';
StC[StI].y:=StC[StI].y-3
end else

if StC[StI].y>50 then begin
AnimA:='RIGHTUP';
StC[StI].x:=StC[StI].x+3;
StC[StI].y:=StC[StI].y-2;
end else

if StC[StI].y>-36 then begin
AnimA:='UP';
StC[StI].y:=StC[StI].y-3;
end else
if StC[StI].y<-36 then begin Move.Enabled:=false; StC[StI].x:=StDx; StC[StI].y:=StDy; StI:=random(Length(StC)); DogRolf:=true; end;

end;


1: begin

if StC[StI].y>117 then begin
AnimA:='UP';
StC[StI].y:=StC[StI].y-3
end else

if StC[StI].y>50 then begin
AnimA:='LEFTUP';
StC[StI].x:=StC[StI].x-3;
StC[StI].y:=StC[StI].y-2;
end else

if StC[StI].y>-36 then begin
AnimA:='UP';
StC[StI].y:=StC[StI].y-3;
end else
if StC[StI].y<-36 then begin Move.Enabled:=false; StC[StI].x:=StDx; StC[StI].y:=StDy; StI:=random(Length(StC)); DogRolf:=true; PlaySound('Sounds\rolf.wav', 0, SND_ASYNC); end;

end;


2: begin

if StC[StI].x>-36 then begin
AnimA:='LEFT';
StC[StI].x:=StC[StI].x-3
end else begin Move.Enabled:=false; StC[StI].x:=StDx; StC[StI].y:=StDy; StI:=random(Length(StC)); DogRolf:=true; PlaySound('Sounds\rolf.wav', 0, SND_ASYNC); end;

end;


3: begin

if StC[StI].x>-36 then begin
AnimA:='LEFT';
StC[StI].x:=StC[StI].x-3
end else begin Move.Enabled:=false; StC[StI].x:=StDx; StC[StI].y:=StDy; StI:=random(Length(StC)); DogRolf:=true; PlaySound('Sounds\rolf.wav', 0, SND_ASYNC); end;

end;


4: begin

if StC[StI].x<256 then begin
AnimA:='RIGHT';
StC[StI].x:=StC[StI].x+3
end else begin Move.Enabled:=false; StC[StI].x:=StDx; StC[StI].y:=StDy; StI:=random(Length(StC)); DogRolf:=true; PlaySound('Sounds\rolf.wav', 0, SND_ASYNC); end;

end;


5: begin

if StC[StI].x<256 then begin
AnimA:='RIGHT';
StC[StI].x:=StC[StI].x+3
end else begin Move.Enabled:=false; StC[StI].x:=StDx; StC[StI].y:=StDy; StI:=random(Length(StC)); DogRolf:=true; PlaySound('Sounds\rolf.wav', 0, SND_ASYNC); end;

end;


6: begin

if StC[StSI].y<160 then begin
AnimA:='SHOT';
StC[StSI].y:=StC[StSI].y+3
end else begin Move.Enabled:=false; StC[StSI].x:=StDx; StC[StSI].y:=StDy; StI:=random(Length(StC)); DogWDuck:=true; PlaySound('Sounds\good.wav', 0, SND_ASYNC); end;

end;


end;

//Label1.Caption:=IntToStr(StC[StI].x)+' '+IntToStr(StC[StI].y);
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//Label2.Caption:=IntToStr(x)+' '+IntToStr(y);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Render.Enabled:=false;
Move.Enabled:=false;
Background.Free;
Green.Free;
CommPortDriver1.Disconnect;
ShowCursor(true);
end;

procedure TForm1.CommPortDriver1ReceiveData(Sender: TObject;
  DataPtr: Pointer; DataSize: Cardinal);
var i,icode:integer;
s:string;
begin
s:='';

for i:=0 to DataSize-1 do s:=s+(PChar(DataPtr)[i]);

if ScnWait then begin
s:=trim(s);
val(s,PhtRes,icode);

//Шум от вибромотора
if PhtRes<40 then begin
ScnWait:=false;

//Попал
if (PhtRes>BlackL) and (StpShow=false) then begin
StSI:=StI;
StI:=6;
inc(Score);
end;

//Настройка
if StpShow then begin
inc(StpBlckC);
if BlackL<PhtRes then BlackL:=PhtRes;
end else begin

Render.Enabled:=true;
Move.Enabled:=true;

end;

end;

end;

if pos('SHOT',s)>0 then begin

if StpShow=false then begin
Render.Enabled:=false;
Move.Enabled:=false;
Image1.Canvas.Brush.Color:=clBlack;
Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
Image1.Canvas.Brush.Color:=clWhite;
Image1.Canvas.Rectangle(StC[StI].x,StC[StI].y,StC[StI].x+38,StC[StI].y+38);
Image2.Canvas.StretchDraw(R,Image1.Picture.Graphic);
end;
PlaySound('Sounds\shot.wav', 0, SND_ASYNC);

ScnWait:=true;
end;

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then Close;
if key=VK_RETURN then CommPortDriver1.Connect;
end;

procedure TForm1.nextDuck;
begin
StDx:=StC[StI].x;
StDy:=StC[StI].y;

Render.Enabled:=true;
Move.Enabled:=true;

animS:=0;

PlaySound('Sounds\duck.wav', 0, SND_ASYNC);
end;

procedure TForm1.SettingRenderTimer(Sender: TObject);
begin
if StpBlckC>=4 then begin SettingRender.Enabled:=false; StpShow:=false; nextDuck; end;

Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));

if CommPortDriver1.Connect=false then begin
Image1.Canvas.TextOut(Image1.Width div 2 - Image1.Canvas.TextWidth('Пистолет не найден / Gun not found') div 2,80,'Пистолет не найден / Gun not found');
Image1.Canvas.TextOut(Image1.Width div 2 - Image1.Canvas.TextWidth('Вставьте пистолет и нажмите Enter') div 2,100,'Вставьте пистолет и нажмите Enter');
Image1.Canvas.TextOut(Image1.Width div 2 - Image1.Canvas.TextWidth('Insert the gun and press Enter') div 2,120,'Insert the gun and press Enter');
end else begin
Image1.Canvas.TextOut(Image1.Width div 2 - Image1.Canvas.TextWidth('Выстрелите в углы экрана') div 2,80,'Выстрелите в углы экрана');
Image1.Canvas.TextOut(Image1.Width div 2 - Image1.Canvas.TextWidth('Shot the corners of the screen') div 2,100,'Shot the corners of the screen');
Image1.Canvas.TextOut(Image1.Width div 2 - Image1.Canvas.TextWidth('Выстрелов '+IntToStr(StpBlckC)+' из 4 / Shot '+IntToStr(StpBlckC)+' of 4') div 2,120,'Выстрелов '+IntToStr(StpBlckC)+' из 4 / Shot '+IntToStr(StpBlckC)+' of 4');
end;

Image2.Canvas.StretchDraw(R,Image1.Picture.Graphic);
end;

end.
