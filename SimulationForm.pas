unit SimulationForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Math, Inifiles, IOUtils, StrUtils, BetProfilForm;


type TSwitchCondition = record
     multiply: Integer;
     switchCondition: Integer;
     nextBetProfil: string;
end;

type TBetProfil = record
     profilName: String;
     profit: integer;
     multiply: integer;
     zeroBets: integer;
     inverse: boolean;
     condition: String;
     target: String;
     minRounds: integer;
     betType: TBetType;
     allowRevenge: boolean;
     revengeMultiply: integer;
     revengeTrigger: integer;
     allowSwitchProfilOnWin: boolean;
     nextBetProfil: string;
     switchConditions: array of TSwitchCondition;
end;

type
  TForm9 = class(TForm)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Button1: TButton;
    ListBox1: TListBox;
    procedure reset();
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure loadProfiles();
    procedure displayStatistik();
    procedure split(input: string; listOfStrings: TStrings);
    procedure calculateNextBetCost(round: integer);
    procedure addOneToAllAbove(index: Integer);
    procedure addOneToAllBelow(index: Integer);
    procedure simulateBet();
    function parseRequest(roll: Integer): boolean;
    function checkForWin(roll: String): boolean;
    function findMaxProfitForBalance(): Integer;
    function searchForSelectorProfil(): TBetProfil;
    function getNextBet(round: Integer): Extended;
    function loadBetProfil(betProfil: String): TBetProfil;
    function simulateRoll(): String;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TTipProfil = record
     receiver: String;
     percent: Integer;
     minAmount: Integer;
end;

var
  Form9: TForm9;
  loadedBetProfil, inUseBetProfil: TBetProfil;
  currentTipProfil: TTipProfil;
  totalTip, currentTip, profitAvailableForTip, currentBetIndex, currentRound, totalBrokeRounds, refinanceBalance, balance: Integer;
  computedBetList, computedProfitList, computedCostList: Array of Extended;
  pastRolls: array[0..9999, 1..2] of Integer;
  lastBetWon, lastBetSelector: Boolean;
  currentBet: Extended;
  randomRollNumber: String;

implementation

{$R *.dfm}

function TForm9.simulateRoll(): String;
var roll: String;
begin
     balance := balance - trunc(currentBet);
     roll := inttostr(Math.RandomRange(0, 10000));
     while roll.Length < 4 do
           roll := roll + '0';
     roll := roll.Insert(2, '.');
     result := roll;
end;

procedure TForm9.split(input: string; listOfStrings: TStrings);
begin
   listOfStrings.Clear;
   listOfStrings.Delimiter       := ':';
   listOfStrings.StrictDelimiter := True;
   listOfStrings.DelimitedText   := input;
end;

procedure TForm9.loadProfiles();
var path: String;
begin
    if not DirectoryExists('./bets/') then
           CreateDir('./bets');
    Combobox1.Clear;
    for path in TDirectory.GetFiles('./bets/') do
        Combobox1.Items.Add(path.Remove(0, 7));
end;

function TForm9.loadBetProfil(betProfil: String): TBetProfil;
var returnBetProfil: TBetProfil;
    iniFile: TIniFile;
    index: Integer;
    fileData, lineData: TStringlist;
begin
    iniFile := TIniFile.Create('./bets/' + betProfil);
    try
        returnBetProfil.profit := iniFile.ReadInteger('Betprofil', 'Profit', 0);
        returnBetProfil.profilName := iniFile.ReadString('Betprofil', 'Name', '');
        returnBetProfil.condition := iniFile.ReadString('Betprofil', 'Condition', '>');
        returnBetProfil.zeroBets := iniFile.ReadInteger('Betprofil', 'ZeroBets', 0);
        returnBetProfil.target := iniFile.ReadString('Betprofil', 'Target', '');
        returnBetProfil.multiply := iniFile.ReadInteger('Betprofil', 'Multiply', 0);
        returnBetProfil.inverse := iniFile.ReadBool('Betprofil', 'Inverse', false);
        returnBetProfil.minRounds := iniFile.ReadInteger('Betprofil', 'MinRounds', 0);
        returnBetProfil.betType := TBetType(iniFile.ReadInteger('Betprofil', 'BetType', 0));
        returnBetProfil.allowSwitchProfilOnWin := iniFile.ReadBool('SwitchProfil', 'AllowSwitch', false);
        returnBetProfil.nextBetProfil := iniFile.ReadString('SwitchProfil', 'NextProfil', '');
        if (returnBetProfil.betType = TBetType.BySelector) then
        begin
            fileData := TStringlist.Create;
            lineData := TStringlist.Create;
            if (FileExists('./bets/selector/selector_' + betProfil)) then
            begin
                fileData.LoadFromFile('./bets/selector/selector_' + betProfil);
                setLength(returnBetProfil.switchConditions, fileData.Count);
                for index := 0 to fileData.Count - 1 do
                begin
                    split(fileData[index], lineData);
                    returnBetProfil.switchConditions[index].multiply := strtoint(lineData[0]);
                    returnBetProfil.switchConditions[index].switchCondition := strtoint(lineData[1]);
                    returnBetProfil.switchConditions[index].nextBetProfil := lineData[2];
                end;
                fileData.Free;
                lineData.Free;
            end;
        end;
    finally
        iniFile.Free;
    end;
    loadedBetProfil := returnBetProfil;
    result := returnBetProfil;
end;

procedure TForm9.calculateNextBetCost(round: integer);
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
    if (inUseBetProfil.zeroBets <= round) then
    begin
        while ((newBet * inUseBetProfil.multiply) - addedCost - newBet < inUseBetProfil.profit) do
            newBet := newBet + 1;
    end;
    computedBetList[high(computedBetList)] := newBet;
    if (high(computedCostList) - 1 >= 0) then
        computedCostList[high(computedCostList)] := computedCostList[high(computedCostList) - 1] + newBet
    else
        computedCostList[high(computedCostList)] := newBet;
    computedProfitList[high(computedProfitList)] := (newBet * inUseBetProfil.multiply) - computedCostList[high(computedBetList)];
end;


function TForm9.getNextBet(round: Integer): Extended;
begin
    if (length(computedBetList) <= round) then
    begin
        calculateNextBetCost(round);
    end;
    result := computedBetList[round];
end;

function TForm9.searchForSelectorProfil(): TBetProfil;
var returnProfil: TBetProfil;
    index, multiply, high, low: Integer;
begin
    returnProfil := loadedBetProfil;
    currentBet := 0;
    for index := 0 to length(inUseBetProfil.switchConditions) -1 do
    begin
        multiply := inUseBetProfil.switchConditions[index].multiply;
        low := trunc(Math.RoundTo(99 / multiply, -2) * 100);
        high := trunc(Math.RoundTo(100 - (99 / multiply), -2) * 100);
        if (pastRolls[high, 1] > pastRolls[low, 2]) then
        begin
            if (inUseBetProfil.switchConditions[index].switchCondition <= pastRolls[high, 1]) then
            begin
                returnProfil := loadBetProfil(inUseBetProfil.switchConditions[index].nextBetProfil);
                returnProfil.allowSwitchProfilOnWin := true;
                returnProfil.nextBetProfil := inUseBetProfil.profilName + '.ini';
            end;
        end else if (inUseBetProfil.switchConditions[index].switchCondition <= pastRolls[low, 2]) then
            begin
                returnProfil := loadBetProfil(inUseBetProfil.switchConditions[index].nextBetProfil);
                returnProfil.condition := ifthen(returnProfil.condition = '>', '<', '>');
                returnProfil.target := Form3.calculateRollByMultiply(returnProfil.condition, returnProfil.multiply);
                returnProfil.allowSwitchProfilOnWin := true;
                returnProfil.nextBetProfil := inUseBetProfil.profilName + '.ini';
            end;
    end;
    result := returnProfil;
end;

function TForm9.findMaxProfitForBalance(): Integer;
var fileData, lineData: TStringList;
    fileName: String;
    profit, index: Integer;
begin
    fileData := TStringList.Create;
    lineData := TStringList.Create;
    profit := 0;
    fileName := 'preCalc/' + inttostr(inUseBetProfil.minRounds) + '_' + inttostr(inUseBetProfil.multiply) + '.txt';
    fileData.LoadFromFile(fileName);
    for index := 0 to fileData.Count - 1 do
    begin
        split(fileData[index], lineData);
        if (strtofloat(lineData[0]) <= balance) then
        begin
            profit := strtoint(lineData[1]);
        end else
            begin
                break;
            end;
    end;
    lineData.Free;
    fileData.Free;
    result := profit;
end;

function TForm9.checkForWin(roll: String): boolean;
begin
    result := false;
    if (inUseBetProfil.condition.Equals('>')) then
        if (roll > inUseBetProfil.target) then
        begin
            balance := balance + trunc(currentBet) * inUseBetProfil.multiply;
            result := true;
        end;
end;

procedure TForm9.addOneToAllAbove(index: Integer);
var i: Integer;
begin
    for I := index to 9999 do
        pastRolls[i, 1] := pastRolls[i, 1] + 1;
    for I := 0 to index do
        pastRolls[i, 1] := 0;
end;

procedure TForm9.addOneToAllBelow(index: Integer);
var i: Integer;
begin
    for I := 0 to index do
        pastRolls[i, 2] := pastRolls[i, 2] + 1;
    for I := index to 9999 do
        pastRolls[i, 2] := 0;
end;

function TForm9.parseRequest(roll: Integer): boolean;
begin
    addOneToAllAbove(roll);
    addOneToAllBelow(roll);
    balance := 5;// recalculate CurrentBalance
    result := true;
end;

procedure TForm9.displayStatistik();
begin
    ListBox1.Clear;
    Listbox1.items.add('Balance: ' + inttostr(balance));
    Listbox1.Items.Add('Wasted Tip: ' + inttostr(profitAvailableForTip));
    Listbox1.Items.Add('Tipped: ' + inttostr(currentTip));
    Listbox1.Items.Add('Rounds: ' + inttostr(currentRound));
end;

procedure TForm9.simulateBet();
begin
    lastBetWon := checkForWin(randomRollNumber);
    if (inUseBetProfil.betType = BySelector) then
    begin
        inUseBetProfil := searchForSelectorProfil();
        if (inUseBetProfil.betType <> BySelector) then
        begin
            lastBetWon := true;
            lastBetSelector := true;
        end;
    end;
    if not (inUseBetProfil.betType = BySelector) then
    begin
        if (lastBetWon) then
        begin
            if (not lastBetSelector) then
            begin
                inc(currentRound);
                profitAvailableForTip := profitAvailableForTip + round(computedProfitList[currentBetIndex]);
            end;
            Form9.reset();
            if (inUseBetProfil.allowSwitchProfilOnWin and not lastBetSelector) then
            begin
                inUseBetProfil := loadBetProfil(inUseBetProfil.nextBetProfil);
            end;
            if (inUseBetProfil.betType = ByProfit) then
            begin
                inUseBetProfil.profit := loadedBetProfil.profit;
            end;
            if (inUseBetProfil.betType = ByMinRounds) then
            begin
                if (findMaxProfitForBalance() <> inUseBetProfil.profit) then
                begin
                    inUseBetProfil.profit := findMaxProfitForBalance();
                end;
            end;
            if (inUseBetProfil.inverse and not lastBetSelector) then
            begin
                inUseBetProfil.condition := ifthen(inUseBetProfil.condition = '>', '<', '>');
                inUseBetProfil.target := Form3.calculateRollByMultiply(inUseBetProfil.condition, inUseBetProfil.multiply);
            end;
            currentBet := getNextBet(currentBetIndex);
            if (profitAvailableForTip div 100 * currentTipProfil.percent) >= currentTipProfil.minAmount then
            begin
                currentTip := currentTip + (profitAvailableForTip div 100 * currentTipProfil.percent);
                totalTip := totalTip + (profitAvailableForTip div 100 * currentTipProfil.percent);
                profitAvailableForTip := 0;
            end;
            lastBetSelector := false;
            randomRollNumber := simulateRoll();
            simulateBet();
        end else
            begin
                inc(currentBetIndex);
                currentBet := getNextBet(currentBetIndex);
                if (balance >= currentBet) then
                begin
                    randomRollNumber := simulateRoll();
                    simulateBet();
                end else
                    begin
                        Form9.Button1.Caption := 'End';
                        Form9.displayStatistik();
                    end;
            end;
    end;
end;

procedure TForm9.reset();
begin
    currentBetIndex := 0;
    lastBetWon := false;
    //setLength(computedCostList, 0);
    //setLength(computedProfitList, 0);
    //setLength(computedBetList, 0);
end;


procedure TForm9.Button1Click(Sender: TObject);
begin
    randomize();
    refinanceBalance := strtoint(edit1.text);
    totalBrokeRounds := strtoint(edit2.Text);
    balance := refinanceBalance;
    button1.Caption := 'Start';
    randomRollNumber := simulateRoll();
    lastBetSelector := false;
    reset();
    setLength(computedCostList, 0);
    setLength(computedProfitList, 0);
    setLength(computedBetList, 0);
    if (inUseBetProfil.betType = BySelector) then
    begin
        inUseBetProfil := searchForSelectorProfil();
    end;
    if (inUseBetProfil.betType = ByMinRounds) then
    begin
        inUseBetProfil.profit := findMaxProfitForBalance();
    end;
    currentBet := getNextBet(currentBetIndex);
    if (inUseBetProfil.betType = BySelector) then
    begin
        lastBetSelector := true;
    end;
    simulateBet();
end;

procedure TForm9.ComboBox1Change(Sender: TObject);
begin
    inUseBetProfil := loadBetProfil(combobox1.Items[combobox1.ItemIndex]);
end;

procedure TForm9.ComboBox2Change(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./tips/' + combobox2.Items[combobox2.ItemIndex]);
    try
        currentTipProfil.receiver := iniFile.ReadString('Tipprofil', 'Receiver', '');
        currentTipProfil.percent := iniFile.ReadInteger('Tipprofil', 'Percent', 0);
        currentTipProfil.minAmount := iniFile.ReadInteger('Tipprofil', 'MinAmount', 10000);
    finally
        iniFile.Free;
    end;
end;


procedure loadTipProfiles();
var path: String;
begin
    if not DirectoryExists('./tips/') then
           CreateDir('./tips');
    Form9.Combobox2.Clear;
    for path in TDirectory.GetFiles('./tips/') do
        Form9.Combobox2.Items.Add(path.Remove(0, 7));
end;

procedure TForm9.FormShow(Sender: TObject);
begin
    loadProfiles();
    loadTipProfiles();
end;

end.
