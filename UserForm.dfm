object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'User Management'
  ClientHeight = 132
  ClientWidth = 228
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
    Top = 46
    Width = 60
    Height = 13
    Caption = 'Profile Name'
  end
  object Label2: TLabel
    Left = 8
    Top = 73
    Width = 36
    Height = 13
    Caption = 'Api Key'
  end
  object ComboBox1: TComboBox
    Left = 74
    Top = 16
    Width = 145
    Height = 21
    TabOrder = 0
    OnChange = ComboBox1Change
  end
  object Edit1: TEdit
    Left = 74
    Top = 43
    Width = 145
    Height = 21
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 74
    Top = 70
    Width = 145
    Height = 21
    TabOrder = 2
  end
  object Button1: TButton
    Left = 144
    Top = 97
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 3
    OnClick = Button1Click
  end
end
