object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'Form6'
  ClientHeight = 329
  ClientWidth = 180
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 36
    Height = 13
    Caption = 'Multiply'
  end
  object Label2: TLabel
    Left = 16
    Top = 51
    Width = 45
    Height = 13
    Caption = 'Min Profit'
  end
  object Label3: TLabel
    Left = 16
    Top = 88
    Width = 73
    Height = 13
    Caption = 'Display Rounds'
  end
  object ListBox1: TListBox
    Left = 16
    Top = 112
    Width = 153
    Height = 169
    ItemHeight = 13
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 91
    Top = 13
    Width = 78
    Height = 21
    NumbersOnly = True
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 91
    Top = 48
    Width = 78
    Height = 21
    NumbersOnly = True
    TabOrder = 2
  end
  object Button1: TButton
    Left = 94
    Top = 297
    Width = 75
    Height = 25
    Caption = 'Calculate'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Edit3: TEdit
    Left = 91
    Top = 85
    Width = 78
    Height = 21
    NumbersOnly = True
    TabOrder = 4
  end
end
