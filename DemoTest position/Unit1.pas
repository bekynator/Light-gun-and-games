unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPDrv, ExtCtrls, MMSystem;
type
  TForm1 = class(TForm)
    CommPortDriver1: TCommPortDriver;
    Image1: TImage;
    Render: TTimer;
    Move: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure CommPortDriver1ReceiveData(Sender: TObject; DataPtr: Pointer;
      DataSize: Cardinal);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RenderTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MoveTimer(Sender: TObject);
   
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  PhtRes: integer;
  x,y,cTrg,gTrg: integer;
  ScnWait: boolean;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  cTrg:=0;
  gTrg:=0;
  ScnWait:=false;

  Randomize;

  BorderStyle:=bsNone;
  WindowState:=wsMaximized;

  Image1.Width:=Screen.Width;
  Image1.Height:=Screen.Height;

  ShowCursor(false);

  DoubleBuffered:=true;
  CommPortDriver1.BaudRateValue:=9600;
  CommPortDriver1.PortName:='\\.\Com7';
  CommPortDriver1.DataBits:=db8BITS;
  CommPortDriver1.Connect;
  //if CommPortDriver1.Connected=true then Application.Title:='Подключен' else Application.Title:='Не удается подключиться';
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
var
  i, icode: integer;
  s:string;
begin
  s:='';
  for i:=0 to DataSize-1 do s:=s+(PChar(DataPtr)[i]);

  gTrg:=0;

  //Ждем данные
  if ScnWait then begin
    s:=trim(s);
    val(s,PhtRes,icode);

    //Шум от вибромотора
    if PhtRes<40 then begin
    //Memo1.Lines.Add('Фоторезистор - '+IntToStr(PhtRes));

      //Если попал (3 - уровень черного)
      if PhtRes>3 then begin
      //Memo1.Lines.Add('Этап проверки, цель - '+IntToStr(cTrg));

        if cTrg=9 then gTrg:=9;

        if cTrg=8 then begin cTrg:=9; gTrg:=8; end;
        if cTrg=7 then begin cTrg:=9; gTrg:=7; end;
        if cTrg=6 then begin cTrg:=9; gTrg:=6; end;

        if cTrg=5 then begin cTrg:=9; gTrg:=5; end;
        if cTrg=4 then begin cTrg:=9; gTrg:=4; end;
        if cTrg=3 then begin cTrg:=9; gTrg:=3; end;

        if cTrg=2 then begin cTrg:=9; gTrg:=2; end;
        if cTrg=1 then begin cTrg:=9; gTrg:=1; end;
      end;

  //После проверки попадания

      if cTrg=9 then begin
        ScnWait:=false;
        Render.Enabled:=true;
        Move.Enabled:=true;
        x:=1;
        y:=1;
      end;

      if cTrg=8 then begin
        //Memo1.Lines.Add('Этап отрисовки, цель - '+IntToStr(cTrg+1));
        cTrg:=9;
        Image1.Canvas.Brush.Color:=clBlack;
        Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
        Image1.Canvas.Brush.Color:=clWhite;
        Image1.Canvas.Rectangle(x,y,x+Screen.Width div 3,y+(Screen.Height div 3));
        x:=x+Screen.Width div 3;
      end;

      if cTrg=7 then begin
        //Memo1.Lines.Add('Этап отрисовки, цель - '+IntToStr(cTrg+1));
        cTrg:=8;
        Image1.Canvas.Brush.Color:=clBlack;
        Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
        Image1.Canvas.Brush.Color:=clWhite;
        Image1.Canvas.Rectangle(x,y,x+Screen.Width div 3,y+(Screen.Height div 3));
        x:=x+Screen.Width div 3;
      end;

      if cTrg=6 then begin
        //Memo1.Lines.Add('Этап отрисовки, цель - '+IntToStr(cTrg+1));
        cTrg:=7;
        Image1.Canvas.Brush.Color:=clBlack;
        Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
        Image1.Canvas.Brush.Color:=clWhite;
        x:=1;
        Image1.Canvas.Rectangle(x,y,x+Screen.Width div 3,y+(Screen.Height div 3));
        x:=x+Screen.Width div 3;
      end;

      if cTrg=5 then begin
        //Memo1.Lines.Add('Этап отрисовки, цель - '+IntToStr(cTrg+1));
        cTrg:=6;
        Image1.Canvas.Brush.Color:=clBlack;
        Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
        Image1.Canvas.Brush.Color:=clWhite;
        Image1.Canvas.Rectangle(x,y,x+Screen.Width div 3,y+(Screen.Height div 3));
        x:=x+Screen.Width div 3;
        y:=y+Screen.Height div 3;
      end;

      if cTrg=4 then begin
        //Memo1.Lines.Add('Этап отрисовки, цель - '+IntToStr(cTrg+1));
        cTrg:=5;
        Image1.Canvas.Brush.Color:=clBlack;
        Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
        Image1.Canvas.Brush.Color:=clWhite;
        Image1.Canvas.Rectangle(x,y,x+Screen.Width div 3,y+(Screen.Height div 3));
        x:=x+Screen.Width div 3;
      end;

      if cTrg=3 then begin
        //Memo1.Lines.Add('Этап отрисовки, цель - '+IntToStr(cTrg+1));
        cTrg:=4;
        Image1.Canvas.Brush.Color:=clBlack;
        Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
        Image1.Canvas.Brush.Color:=clWhite;
        x:=1;
        Image1.Canvas.Rectangle(x,y,x+Screen.Width div 3,y+(Screen.Height div 3));
        x:=x+Screen.Width div 3;
      end;

      if cTrg=2 then begin
        //Memo1.Lines.Add('Этап отрисовки, цель - '+IntToStr(cTrg+1));
        cTrg:=3;
        Image1.Canvas.Brush.Color:=clBlack;
        Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
        Image1.Canvas.Brush.Color:=clWhite;
        Image1.Canvas.Rectangle(x,y,x+Screen.Width div 3,y+Screen.Height div 3);
        y:=y+Screen.Height div 3;
      end;

      if cTrg=1 then begin
        //Memo1.Lines.Add('Этап отрисовки, цель - '+IntToStr(cTrg+1));
        cTrg:=2;
        Image1.Canvas.Brush.Color:=clBlack;
        Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
        Image1.Canvas.Brush.Color:=clWhite;
        Image1.Canvas.Rectangle(x,y,x+Screen.Width div 3,y+Screen.Height div 3);
        x:=x+Screen.Width div 3;
      end;

    end;

  end;

  if (pos('SHOT',s)>0) and (ScnWait=false) then begin
    PlaySound('shot.wav', 0, SND_ASYNC);
    ScnWait:=true;
    Render.Enabled:=false;
    Move.Enabled:=false;

    Image1.Canvas.Brush.Color:=clBlack;
    Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
    Image1.Canvas.Brush.Color:=clWhite;
    //Memo1.Lines.Add('Этап отрисовки, цель - '+IntToStr(cTrg+1));
    Image1.Canvas.Rectangle(x,y,x+Screen.Width div 3,y+Screen.Height div 3);
    x:=x+Screen.Width div 3;
    cTrg:=1;
end;

end;


procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then Close;
end;

procedure TForm1.RenderTimer(Sender: TObject);
begin
  Image1.Canvas.Brush.Color:=rgb(135,224,249);
  Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));

  Image1.Canvas.Brush.Color:=clWhite;
  Form1.Image1.Canvas.Font.Color:=clBlack;
  Form1.Image1.Canvas.Font.Size:=18;

  case gTrg of
    1: TextDraw('Попал в часть 1');
    2: TextDraw('Попал в часть 2');
    3: TextDraw('Попал в часть 3');
    4: TextDraw('Попал в часть 4');
    5: TextDraw('Попал в часть 5');
    6: TextDraw('Попал в часть 6');
    7: TextDraw('Попал в часть 7');
    8: TextDraw('Попал в часть 8');
    9: TextDraw('Попал в часть 9');
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ShowCursor(true);
end;

procedure TForm1.MoveTimer(Sender: TObject);
begin
  gTrg:=0;
end;

end.
