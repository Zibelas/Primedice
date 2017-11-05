unit StatistikForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Math, Unit1;

type
  TForm7 = class(TForm)
    ListBox1: TListBox;
    Edit1: TEdit;
    Button1: TButton;
    Timer1: TTimer;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Button2: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;
  watchList: array of integer;

implementation

{$R *.dfm}

procedure TForm7.Button1Click(Sender: TObject);
begin
    setLength(watchList, length(watchList) + 1);
    watchList[length(watchList) - 1] := strtoint(edit1.text);
    edit1.Text := '';
end;

procedure TForm7.Button2Click(Sender: TObject);
begin
    setLength(watchList, 0);
end;

procedure TForm7.Timer1Timer(Sender: TObject);
var low, high, index: Integer;
begin
    listbox1.clear;
    for index := 0 to length(watchList) - 1 do
    begin
        low := trunc(Math.RoundTo(99 / watchList[index], -2) * 100);
        high := trunc(Math.RoundTo(100 - (99 / watchList[index]), -2) * 100);
        Listbox1.Items.Add(inttostr(watchList[index]) + ':High(' + (inttostr(pastRolls[high, 1])) + '):Low(' + (inttostr(pastRolls[low, 2])) + ')');
    end;
    label15.Caption := floattostr(currentUser.balance);
    label4.Caption := floattostr(profitAvailableForTip);
    label6.Caption := inttostr(currentBetIndex);
    label8.Caption := floattostr(profitPerSesson);
    label10.Caption := inttostr(currentRound);
    label14.Caption := inttostr(longestLoosingStreak);
    label17.Caption := inUseBetProfil.profilName;
end;

end.
