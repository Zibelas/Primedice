object Form7: TForm7
  Left = 0
  Top = 0
  ClientHeight = 385
  ClientWidth = 224
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 10
    Top = 280
    Width = 56
    Height = 13
    Caption = 'Current Bet'
  end
  object Label6: TLabel
    Left = 211
    Top = 280
    Width = 6
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Label7: TLabel
    Left = 10
    Top = 299
    Width = 82
    Height = 13
    Caption = 'Profit this sesson'
  end
  object Label8: TLabel
    Left = 211
    Top = 299
    Width = 6
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Label9: TLabel
    Left = 8
    Top = 318
    Width = 71
    Height = 13
    Caption = 'Current Round'
  end
  object Label10: TLabel
    Left = 211
    Top = 318
    Width = 6
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Label11: TLabel
    Left = 8
    Top = 337
    Width = 111
    Height = 13
    Caption = 'Longest Loosing Streak'
  end
  object Label14: TLabel
    Left = 198
    Top = 337
    Width = 19
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Label3: TLabel
    Left = 10
    Top = 261
    Width = 77
    Height = 13
    Caption = 'Available for Tip'
  end
  object Label4: TLabel
    Left = 211
    Top = 261
    Width = 6
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Label13: TLabel
    Left = 8
    Top = 242
    Width = 37
    Height = 13
    Caption = 'Balance'
  end
  object Label15: TLabel
    Left = 211
    Top = 242
    Width = 6
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Label16: TLabel
    Left = 8
    Top = 356
    Width = 64
    Height = 13
    Caption = 'Current Profil'
  end
  object Label17: TLabel
    Left = 182
    Top = 356
    Width = 33
    Height = 13
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
  end
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 209
    Height = 201
    ItemHeight = 13
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 8
    Top = 215
    Width = 65
    Height = 21
    NumbersOnly = True
    TabOrder = 1
  end
  object Button1: TButton
    Left = 79
    Top = 215
    Width = 50
    Height = 25
    Caption = 'Add'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 160
    Top = 215
    Width = 57
    Height = 25
    Caption = 'Reset'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 96
    Top = 16
  end
end
