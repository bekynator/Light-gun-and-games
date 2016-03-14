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
    Left = 16
    Top = 16
  end
  object Timer1: TTimer
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 48
    Top = 16
  end
end
