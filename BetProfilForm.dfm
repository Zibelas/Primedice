object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Bet Profile'
  ClientHeight = 520
  ClientWidth = 359
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
  object Label5: TLabel
    Left = 8
    Top = 40
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
  object Edit1: TEdit
    Left = 72
    Top = 40
    Width = 97
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 276
    Top = 487
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 2
    OnClick = Button1Click
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 67
    Width = 169
    Height = 110
    Caption = 'Bet Type'
    ItemIndex = 0
    Items.Strings = (
      'Fixed Profit'
      'Min Rounds'
      'Selector'
      'Custom')
    TabOrder = 3
    OnClick = RadioGroup1Click
  end
  object Edit2: TEdit
    Left = 97
    Top = 80
    Width = 72
    Height = 21
    NumbersOnly = True
    TabOrder = 4
  end
  object Edit5: TEdit
    Left = 97
    Top = 107
    Width = 72
    Height = 21
    NumbersOnly = True
    TabOrder = 5
  end
  object GroupBox1: TGroupBox
    Left = 198
    Top = 236
    Width = 153
    Height = 77
    TabOrder = 6
    object Label2: TLabel
      Left = 16
      Top = 24
      Width = 57
      Height = 13
      Caption = 'Increase by'
    end
    object Label6: TLabel
      Left = 16
      Top = 47
      Width = 69
      Height = 13
      Caption = 'Increase after'
    end
    object Edit6: TEdit
      Left = 96
      Top = 22
      Width = 41
      Height = 21
      NumbersOnly = True
      TabOrder = 0
      Text = '0'
    end
    object Edit7: TEdit
      Left = 96
      Top = 49
      Width = 41
      Height = 21
      NumbersOnly = True
      TabOrder = 1
      Text = '0'
    end
    object CheckBox2: TCheckBox
      Left = 3
      Top = 3
      Width = 97
      Height = 17
      Caption = 'Revenge Betting'
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 198
    Top = 181
    Width = 153
    Height = 58
    TabOrder = 7
    object CheckBox3: TCheckBox
      Left = 3
      Top = 3
      Width = 126
      Height = 17
      Caption = 'Switch Betprofil on Win'
      TabOrder = 0
    end
    object ComboBox3: TComboBox
      Left = 5
      Top = 26
      Width = 145
      Height = 21
      TabOrder = 1
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 178
    Width = 169
    Height = 136
    TabOrder = 8
    object Label13: TLabel
      Left = 14
      Top = 78
      Width = 36
      Height = 13
      Caption = 'Multiply'
    end
    object Label3: TLabel
      Left = 14
      Top = 51
      Width = 51
      Height = 13
      Caption = 'Bet Target'
    end
    object Label1: TLabel
      Left = 14
      Top = 105
      Width = 46
      Height = 13
      Caption = 'Zero Bets'
    end
    object Label4: TLabel
      Left = 14
      Top = 24
      Width = 45
      Height = 13
      Caption = 'Condition'
    end
    object Edit11: TEdit
      Left = 78
      Top = 76
      Width = 74
      Height = 21
      NumbersOnly = True
      TabOrder = 0
      OnChange = Edit11Change
    end
    object Edit3: TEdit
      Left = 78
      Top = 49
      Width = 74
      Height = 21
      Enabled = False
      TabOrder = 1
    end
    object Edit4: TEdit
      Left = 78
      Top = 103
      Width = 74
      Height = 21
      NumbersOnly = True
      TabOrder = 2
    end
    object ComboBox1: TComboBox
      Left = 78
      Top = 22
      Width = 74
      Height = 21
      ItemIndex = 0
      TabOrder = 3
      Text = '>'
      OnChange = Edit11Change
      Items.Strings = (
        '>'
        '<')
    end
    object CheckBox1: TCheckBox
      Left = 3
      Top = 3
      Width = 149
      Height = 17
      Caption = 'Inverse Condition on Win'
      TabOrder = 4
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 320
    Width = 343
    Height = 161
    TabOrder = 9
    object Label7: TLabel
      Left = 211
      Top = 16
      Width = 36
      Height = 13
      Caption = 'Multiply'
    end
    object Label8: TLabel
      Left = 211
      Top = 51
      Width = 25
      Height = 13
      Caption = 'After'
    end
    object ListBox1: TListBox
      Left = 14
      Top = 3
      Width = 191
      Height = 137
      ItemHeight = 13
      TabOrder = 0
      OnClick = ListBox1Click
    end
    object Edit8: TEdit
      Left = 253
      Top = 16
      Width = 87
      Height = 21
      NumbersOnly = True
      TabOrder = 1
    end
    object Edit9: TEdit
      Left = 253
      Top = 43
      Width = 87
      Height = 21
      NumbersOnly = True
      TabOrder = 2
    end
    object ComboBox4: TComboBox
      Left = 211
      Top = 70
      Width = 129
      Height = 21
      TabOrder = 3
    end
    object Button2: TButton
      Left = 265
      Top = 128
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 4
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 211
      Top = 128
      Width = 48
      Height = 25
      Caption = 'Delete'
      TabOrder = 5
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 265
      Top = 97
      Width = 75
      Height = 25
      Caption = 'Replace'
      TabOrder = 6
      OnClick = Button4Click
    end
  end
  object ListBox2: TListBox
    Left = 198
    Top = 80
    Width = 73
    Height = 95
    ItemHeight = 13
    TabOrder = 10
  end
  object Edit10: TEdit
    Left = 281
    Top = 80
    Width = 70
    Height = 21
    TabOrder = 11
  end
  object Button5: TButton
    Left = 281
    Top = 107
    Width = 71
    Height = 25
    Caption = 'Add'
    TabOrder = 12
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 281
    Top = 153
    Width = 71
    Height = 25
    Caption = 'Delete'
    TabOrder = 13
  end
end
