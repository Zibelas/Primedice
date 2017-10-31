object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'PrimeDice'
  ClientHeight = 534
  ClientWidth = 427
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
    Left = 4
    Top = 115
    Width = 86
    Height = 13
    Caption = 'Amount of rounds'
  end
  object Label5: TLabel
    Left = 10
    Top = 390
    Width = 56
    Height = 13
    Caption = 'Current Bet'
  end
  object Label6: TLabel
    Left = 205
    Top = 390
    Width = 6
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Label7: TLabel
    Left = 10
    Top = 409
    Width = 82
    Height = 13
    Caption = 'Profit this sesson'
  end
  object Label8: TLabel
    Left = 205
    Top = 409
    Width = 6
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Label9: TLabel
    Left = 10
    Top = 428
    Width = 71
    Height = 13
    Caption = 'Current Round'
  end
  object Label10: TLabel
    Left = 205
    Top = 428
    Width = 6
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Label11: TLabel
    Left = 10
    Top = 447
    Width = 111
    Height = 13
    Caption = 'Longest Loosing Streak'
  end
  object Label14: TLabel
    Left = 205
    Top = 447
    Width = 6
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 43
    Height = 13
    Caption = 'Bet Profil'
  end
  object Label3: TLabel
    Left = 10
    Top = 371
    Width = 77
    Height = 13
    Caption = 'Available for Tip'
  end
  object Label4: TLabel
    Left = 205
    Top = 371
    Width = 6
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Label13: TLabel
    Left = 8
    Top = 352
    Width = 37
    Height = 13
    Caption = 'Balance'
  end
  object Label15: TLabel
    Left = 205
    Top = 352
    Width = 6
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Label16: TLabel
    Left = 8
    Top = 466
    Width = 64
    Height = 13
    Caption = 'Current Profil'
  end
  object Label17: TLabel
    Left = 208
    Top = 466
    Width = 3
    Height = 13
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
  end
  object Button1: TButton
    Left = 168
    Top = 498
    Width = 40
    Height = 25
    Caption = 'Bet'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 142
    Width = 201
    Height = 198
    ItemHeight = 13
    TabOrder = 1
  end
  object Button2: TButton
    Left = 8
    Top = 498
    Width = 38
    Height = 25
    Caption = 'Stop'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit10: TEdit
    Left = 110
    Top = 115
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
    Left = 62
    Top = 45
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
  object ListBox2: TListBox
    Left = 224
    Top = 16
    Width = 161
    Height = 324
    ItemHeight = 13
    TabOrder = 8
  end
  object Button3: TButton
    Left = 310
    Top = 346
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 9
    OnClick = Button3Click
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
    Top = 160
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    Params = <>
    HandleRedirects = True
    Left = 26
    Top = 272
  end
  object RESTResponse1: TRESTResponse
    Left = 26
    Top = 216
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 700
    OnTimer = Timer1Timer
    Left = 130
    Top = 360
  end
  object MainMenu1: TMainMenu
    Left = 176
    Top = 120
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
    Top = 160
  end
  object RESTClient2: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    Params = <>
    HandleRedirects = True
    Left = 66
    Top = 272
  end
  object RESTResponse2: TRESTResponse
    Left = 66
    Top = 216
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
    Top = 160
  end
  object RESTResponse3: TRESTResponse
    Left = 106
    Top = 216
  end
  object RESTClient3: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    Params = <>
    HandleRedirects = True
    Left = 106
    Top = 272
  end
end
