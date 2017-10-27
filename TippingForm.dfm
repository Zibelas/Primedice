object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Tips'
  ClientHeight = 199
  ClientWidth = 181
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
  object Label2: TLabel
    Left = 8
    Top = 75
    Width = 59
    Height = 13
    Caption = 'Tip Receiver'
  end
  object Label3: TLabel
    Left = 8
    Top = 127
    Width = 59
    Height = 13
    Caption = 'Amount (%)'
  end
  object Label5: TLabel
    Left = 8
    Top = 48
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object Label1: TLabel
    Left = 8
    Top = 101
    Width = 33
    Height = 13
    Caption = 'Min Tip'
  end
  object Edit2: TEdit
    Left = 72
    Top = 67
    Width = 97
    Height = 21
    TabOrder = 0
  end
  object ComboBox2: TComboBox
    Left = 72
    Top = 13
    Width = 97
    Height = 21
    TabOrder = 1
    OnChange = ComboBox2Change
  end
  object Edit1: TEdit
    Left = 72
    Top = 40
    Width = 97
    Height = 21
    TabOrder = 2
  end
  object Button1: TButton
    Left = 94
    Top = 156
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 3
    OnClick = Button1Click
  end
  object SpinEdit1: TSpinEdit
    Left = 73
    Top = 118
    Width = 96
    Height = 22
    MaxValue = 100
    MinValue = 0
    TabOrder = 4
    Value = 0
  end
  object Edit3: TEdit
    Left = 73
    Top = 91
    Width = 96
    Height = 21
    NumbersOnly = True
    TabOrder = 5
  end
end
