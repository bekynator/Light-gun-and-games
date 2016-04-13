object Form1: TForm1
  Left = 197
  Top = 138
  Width = 811
  Height = 479
  Caption = 'Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 449
    Height = 225
  end
  object CommPortDriver1: TCommPortDriver
    Port = pnCustom
    PortName = '\\.\COM7'
    BaudRate = brCustom
    OnReceiveData = CommPortDriver1ReceiveData
    OnReceivePacket = CommPortDriver1ReceiveData
    Left = 64
    Top = 40
  end
  object Render: TTimer
    Interval = 45
    OnTimer = RenderTimer
    Left = 8
    Top = 8
  end
  object Move: TTimer
    Interval = 2000
    OnTimer = MoveTimer
    Left = 40
    Top = 8
  end
end
