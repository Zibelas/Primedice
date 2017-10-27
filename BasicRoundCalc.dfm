object Form5: TForm5
  Left = 0
  Top = 0
  ClientHeight = 290
  ClientWidth = 187
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
    Left = 9
    Top = 29
    Width = 76
    Height = 13
    Caption = 'Amount Rounds'
  end
  object Label2: TLabel
    Left = 8
    Top = 59
    Width = 36
    Height = 13
    Caption = 'Multiply'
  end
  object Label3: TLabel
    Left = 8
    Top = 86
    Width = 49
    Height = 13
    Caption = 'Max Profit'
  end
  object ListBox1: TListBox
    Left = 9
    Top = 110
    Width = 168
    Height = 139
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 102
    Top = 255
    Width = 75
    Height = 25
    Caption = 'Calculate'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 101
    Top = 26
    Width = 76
    Height = 21
    NumbersOnly = True
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 101
    Top = 56
    Width = 76
    Height = 21
    NumbersOnly = True
    TabOrder = 3
  end
  object Edit3: TEdit
    Left = 101
    Top = 83
    Width = 76
    Height = 21
    NumbersOnly = True
    TabOrder = 4
  end
end
