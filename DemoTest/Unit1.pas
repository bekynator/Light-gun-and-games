unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPDrv, ExtCtrls, MMSystem;
type
  TForm1 = class(TForm)
    CommPortDriver1: TCommPortDriver;
    Image1: TImage;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure CommPortDriver1ReceiveData(Sender: TObject; DataPtr: Pointer;
      DataSize: Cardinal);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
   
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Photo:integer;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
BorderStyle:=bsNone;
WindowState:=wsMaximized;

Image1.Width:=Screen.Width;
Image1.Height:=Screen.Height;

Image1.Canvas.Brush.Color:=clBlack;
Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));

ShowCursor(false);

DoubleBuffered:=true;
CommPortDriver1.BaudRateValue:=9600;
CommPortDriver1.PortName:='\\.\Com7';
CommPortDriver1.DataBits:=db8BITS;
CommPortDriver1.Connect;
//if CommPortDriver1.Connect=true then Application.Title:='Подключен' else Application.Title:='Не удается подключиться';
Image1.Canvas.Font.Color:=clWhite;
end;

function TextDraw(text:string):boolean;
begin
Form1.Image1.Canvas.Brush.Color:=clBlack;
Form1.Image1.Canvas.Font.Color:=clWhite;
Form1.Image1.Canvas.Font.Size:=54;
Form1.Image1.Canvas.TextOut(100,100,text);
end;

procedure TForm1.CommPortDriver1ReceiveData(Sender: TObject;
  DataPtr: Pointer; DataSize: Cardinal);
var i,icode:integer;
s:string;
begin
s:='';
for i:=0 to DataSize-1 do s:=s+(PChar(DataPtr)[i]);
if pos('SHOT',s)>0 then begin

PlaySound('shot.wav', 0, SND_ASYNC);

s:=StringReplace(s,'SHOT','',[rfReplaceAll]);
s:=trim(s);
val(s,photo,icode);

if photo>3 then TextDraw('Вы попали '+IntToStr(photo)) else TextDraw('Вы промахнулись '+IntToStr(photo));
{Timer1.Enabled:=false;
CommPortDriver1.Disconnect;
Memo1.Lines.Add('Выстрел '+IntToStr(photo));
ShowMessage(s); }
end;

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then Close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
x,y:integer;
begin
Image1.Canvas.Brush.Color:=clBlack;
Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
Image1.Canvas.Brush.Color:=clWhite;
x:=random(Image1.Width-200);
y:=random(Image1.Height-200);
Image1.Canvas.Ellipse(x,y,x+200,y+200);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
ShowCursor(true);
end;

end.
