unit BasicRoundCalc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm5 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label3: TLabel;
    procedure calcOrDisplay();
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.calcOrDisplay();
var f: TextFile;
    fileName: String;
    index, multiply, profitRound, maxProfit, targetRounds, profit, round: Integer;
    addedCost, newBet, lastBet: extended;
begin
    targetRounds := strtoint(edit1.Text);
    multiply := strtoint(edit2.Text);
    fileName := 'preCalc/' + inttostr(targetRounds) + '_' + inttostr(multiply) + '.txt';
    if FileExists(fileName) then
    begin
        listbox1.Items.LoadFromFile(fileName);
    end else
        begin
            AssignFile(f, fileName);
            Rewrite(f);
            maxProfit := strtoint(edit3.text);
            for profit := 0 to maxProfit do
            begin
                addedCost := 0;
                newBet := 0;
                for round := 1 to targetRounds do
                begin
                    while ((newBet * multiply) - addedCost - newBet < profit) do
                    begin
                        newBet := newBet + 1;
                    end;
                    addedCost := addedCost + newBet;
                end;
                writeln(f, floattostr(addedCost) + ':' + inttostr(profit));
            end;
            CloseFile(f);
            calcOrDisplay();
        end;
end;

procedure TForm5.Button1Click(Sender: TObject);
begin
    calcOrDisplay();
end;

end.
