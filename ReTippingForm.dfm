object Form8: TForm8
  Left = 0
  Top = 0
  Caption = 'Retipping'
  ClientHeight = 172
  ClientWidth = 180
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 70
    Width = 33
    Height = 13
    Caption = 'ApiKey'
  end
  object Label2: TLabel
    Left = 8
    Top = 97
    Width = 37
    Height = 13
    Caption = 'Amount'
  end
  object Label3: TLabel
    Left = 8
    Top = 43
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object ComboBox2: TComboBox
    Left = 72
    Top = 13
    Width = 97
    Height = 21
    TabOrder = 0
    OnChange = ComboBox2Change
  end
  object Button1: TButton
    Left = 93
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 72
    Top = 40
    Width = 96
    Height = 21
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 72
    Top = 67
    Width = 96
    Height = 21
    TabOrder = 3
  end
  object Edit3: TEdit
    Left = 72
    Top = 94
    Width = 96
    Height = 21
    TabOrder = 4
  end
end
