object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'PrimeDice'
  ClientHeight = 404
  ClientWidth = 217
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 22
    Height = 13
    Caption = 'User'
  end
  object Label12: TLabel
    Left = 6
    Top = 139
    Width = 86
    Height = 13
    Caption = 'Amount of rounds'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 43
    Height = 13
    Caption = 'Bet Profil'
  end
  object Button1: TButton
    Left = 169
    Top = 370
    Width = 40
    Height = 25
    Caption = 'Bet'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 166
    Width = 201
    Height = 198
    ItemHeight = 13
    TabOrder = 1
  end
  object Button2: TButton
    Left = 8
    Top = 370
    Width = 38
    Height = 25
    Caption = 'Stop'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit10: TEdit
    Left = 112
    Top = 139
    Width = 97
    Height = 21
    TabOrder = 3
    Text = '10000'
  end
  object ComboBox2: TComboBox
    Left = 62
    Top = 13
    Width = 145
    Height = 21
    TabOrder = 4
    OnChange = ComboBox2Change
  end
  object ComboBox1: TComboBox
    Left = 64
    Top = 51
    Width = 145
    Height = 21
    TabOrder = 5
    OnChange = ComboBox1Change
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 80
    Width = 57
    Height = 17
    Caption = 'Tipping'
    TabOrder = 6
  end
  object ComboBox3: TComboBox
    Left = 62
    Top = 78
    Width = 145
    Height = 21
    TabOrder = 7
    OnChange = ComboBox3Change
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 116
    Width = 57
    Height = 17
    Caption = 'Retip'
    TabOrder = 8
  end
  object ComboBox4: TComboBox
    Left = 62
    Top = 112
    Width = 145
    Height = 21
    TabOrder = 9
    OnChange = ComboBox4Change
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Method = rmPOST
    Params = <
      item
        name = 'amount'
        Value = '1'
      end>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 26
    Top = 184
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    Params = <>
    HandleRedirects = True
    Left = 26
    Top = 296
  end
  object RESTResponse1: TRESTResponse
    Left = 26
    Top = 240
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 700
    OnTimer = Timer1Timer
    Left = 154
    Top = 72
  end
  object MainMenu1: TMainMenu
    Left = 176
    Top = 144
    object New1: TMenuItem
      Caption = 'New'
      object User1: TMenuItem
        Caption = 'User'
        OnClick = User1Click
      end
      object Bet1: TMenuItem
        Caption = 'Bet Profil'
        OnClick = Bet1Click
      end
      object TipProfil1: TMenuItem
        Caption = 'Tip Profil'
        OnClick = TipProfil1Click
      end
      object ReTipProfil1: TMenuItem
        Caption = 'ReTip Profil'
        OnClick = ReTipProfil1Click
      end
    end
    object ools1: TMenuItem
      Caption = 'Tools'
      object BasicSurvivalCalc1: TMenuItem
        Caption = 'Basic Profit Calc'
        OnClick = BasicSurvivalCalc1Click
      end
      object BasicRoundCalc1: TMenuItem
        Caption = 'Basic Round Calc'
        OnClick = BasicRoundCalc1Click
      end
      object Statistiks1: TMenuItem
        Caption = 'Statistiks'
        OnClick = Statistiks1Click
      end
      object Simulation1: TMenuItem
        Caption = 'Simulation'
        OnClick = Simulation1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object Endafterround: TMenuItem
        Caption = 'End after round'
        OnClick = EndafterroundClick
      end
      object Simulation: TMenuItem
        Caption = 'Simulation'
        OnClick = SimulationClick
      end
      object Resetstatistik1: TMenuItem
        Caption = 'Reset statistik'
        OnClick = Resetstatistik1Click
      end
    end
  end
  object RESTRequest2: TRESTRequest
    Client = RESTClient2
    Method = rmPOST
    Params = <
      item
        name = 'amount'
        Value = '1'
      end>
    Response = RESTResponse2
    SynchronizedEvents = False
    Left = 66
    Top = 184
  end
  object RESTClient2: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    Params = <>
    HandleRedirects = True
    Left = 66
    Top = 296
  end
  object RESTResponse2: TRESTResponse
    Left = 66
    Top = 240
  end
  object RESTRequest3: TRESTRequest
    Client = RESTClient3
    Params = <
      item
        name = 'amount'
        Value = '1'
      end>
    Response = RESTResponse3
    SynchronizedEvents = False
    Left = 106
    Top = 184
  end
  object RESTResponse3: TRESTResponse
    Left = 106
    Top = 240
  end
  object RESTClient3: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    Params = <>
    HandleRedirects = True
    Left = 106
    Top = 296
  end
end
