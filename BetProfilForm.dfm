object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Bet Profile'
  ClientHeight = 277
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
  object Label4: TLabel
    Left = 8
    Top = 150
    Width = 45
    Height = 13
    Caption = 'Condition'
  end
  object Label13: TLabel
    Left = 8
    Top = 172
    Width = 36
    Height = 13
    Caption = 'Multiply'
  end
  object Label5: TLabel
    Left = 8
    Top = 40
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object Label3: TLabel
    Left = 8
    Top = 199
    Width = 51
    Height = 13
    Caption = 'Bet Target'
  end
  object Label1: TLabel
    Left = 20
    Top = 227
    Width = 46
    Height = 13
    Caption = 'Zero Bets'
  end
  object ComboBox1: TComboBox
    Left = 72
    Top = 147
    Width = 97
    Height = 21
    ItemIndex = 0
    TabOrder = 0
    Text = '>'
    OnChange = Edit11Change
    Items.Strings = (
      '>'
      '<')
  end
  object Edit11: TEdit
    Left = 72
    Top = 169
    Width = 97
    Height = 21
    NumbersOnly = True
    TabOrder = 1
    OnChange = Edit11Change
  end
  object ComboBox2: TComboBox
    Left = 72
    Top = 13
    Width = 97
    Height = 21
    TabOrder = 2
    OnChange = ComboBox2Change
  end
  object Edit1: TEdit
    Left = 72
    Top = 40
    Width = 97
    Height = 21
    TabOrder = 3
  end
  object Button1: TButton
    Left = 276
    Top = 244
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Edit3: TEdit
    Left = 72
    Top = 196
    Width = 97
    Height = 21
    Enabled = False
    TabOrder = 5
  end
  object CheckBox1: TCheckBox
    Left = 20
    Top = 250
    Width = 149
    Height = 17
    Caption = 'Inverse Condition on Win'
    TabOrder = 6
  end
  object Edit4: TEdit
    Left = 72
    Top = 223
    Width = 97
    Height = 21
    NumbersOnly = True
    TabOrder = 7
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 67
    Width = 169
    Height = 77
    Caption = 'Bet Type'
    ItemIndex = 0
    Items.Strings = (
      'Fixed Profit'
      'Min Rounds')
    TabOrder = 8
  end
  object Edit2: TEdit
    Left = 97
    Top = 80
    Width = 72
    Height = 21
    NumbersOnly = True
    TabOrder = 9
  end
  object Edit5: TEdit
    Left = 97
    Top = 107
    Width = 72
    Height = 21
    NumbersOnly = True
    TabOrder = 10
  end
  object GroupBox1: TGroupBox
    Left = 198
    Top = 67
    Width = 153
    Height = 77
    TabOrder = 11
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
    Top = 143
    Width = 153
    Height = 58
    TabOrder = 12
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
end
