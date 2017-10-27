unit BasicProfitCalc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm6 = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Label3: TLabel;
    Edit3: TEdit;
    procedure calculateNextBetCost(round: integer);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;
  multiply, targetProfitPerRound: Integer;
  computedBetList, computedProfitList, computedCostList: Array of Extended;

implementation

{$R *.dfm}

procedure TForm6.calculateNextBetCost(round: integer);
var index: Integer;
    addedCost, newBet:extended;
begin
    addedCost := 0;
    newBet := 0;
    for index := Low(computedBetList) to High(computedBetList) do
    begin
        addedCost := addedCost + computedBetList[index];
    end;
    setLength(computedBetList, length(computedBetList) + 1);
    setLength(computedProfitList, length(computedProfitList) + 1);
    setLength(computedCostList, length(computedCostList) + 1);
    while ((newBet * multiply) - addedCost - newBet < targetProfitPerRound) do
        newBet := newBet + 1;
    computedBetList[high(computedBetList)] := newBet;
    if (high(computedCostList) - 1 >= 0) then
        computedCostList[high(computedCostList)] := computedCostList[high(computedCostList) - 1] + newBet
    else
        computedCostList[high(computedCostList)] := newBet;
    computedProfitList[high(computedProfitList)] := (newBet * multiply) - computedCostList[high(computedBetList)];
end;

procedure TForm6.Button1Click(Sender: TObject);
var i: Integer;
begin
    listbox1.Clear;
    multiply := strtoint(edit1.Text);
    targetProfitPerRound := strtoint(edit2.Text);
    setLength(computedCostList, 0);
    setLength(computedProfitList, 0);
    setLength(computedBetList, 0);
    listbox1.Items.Add('Round, TotalCost, Profit');
    for I := 1 to strtoint(edit3.Text) do
    begin
        calculateNextBetCost(i-1);
        listbox1.Items.Add(inttostr(i) + '/' + floattostr(computedCostList[i-1]) + '/' + floattostr(computedProfitList[i-1]));
    end;
end;

end.
