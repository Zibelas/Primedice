object Form9: TForm9
  Left = 0
  Top = 0
  Caption = 'Form9'
  ClientHeight = 356
  ClientWidth = 335
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
    Top = 16
    Width = 40
    Height = 13
    Caption = 'BetProfil'
  end
  object Label2: TLabel
    Left = 8
    Top = 38
    Width = 38
    Height = 13
    Caption = 'TipProfil'
  end
  object Label3: TLabel
    Left = 8
    Top = 65
    Width = 33
    Height = 13
    Caption = 'Capital'
  end
  object Label4: TLabel
    Left = 8
    Top = 92
    Width = 36
    Height = 13
    Caption = 'Rounds'
  end
  object ComboBox1: TComboBox
    Left = 54
    Top = 8
    Width = 145
    Height = 21
    TabOrder = 0
    OnChange = ComboBox1Change
  end
  object ComboBox2: TComboBox
    Left = 54
    Top = 35
    Width = 145
    Height = 21
    TabOrder = 1
    OnChange = ComboBox2Change
  end
  object Edit1: TEdit
    Left = 54
    Top = 62
    Width = 145
    Height = 21
    TabOrder = 2
    Text = '1000'
  end
  object Edit2: TEdit
    Left = 54
    Top = 89
    Width = 145
    Height = 21
    TabOrder = 3
    Text = '1'
  end
  object Button1: TButton
    Left = 122
    Top = 116
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 4
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 147
    Width = 189
    Height = 97
    ItemHeight = 13
    TabOrder = 5
  end
  object Memo1: TMemo
    Left = 8
    Top = 256
    Width = 189
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 6
  end
  object ListBox2: TListBox
    Left = 205
    Top = 8
    Width = 121
    Height = 337
    ItemHeight = 13
    TabOrder = 7
  end
end
