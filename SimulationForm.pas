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
     target: Integer;
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
    Memo1: TMemo;
    ListBox2: TListBox;
    procedure reset();
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure loadProfiles();
    procedure displayStatistik();
    procedure calculateCustomCost();
    procedure split(input: string; listOfStrings: TStrings);
    procedure calculateNextBetCost(round: integer);
    procedure addOneToAllAbove(index: Integer);
    procedure addOneToAllBelow(index: Integer);
    function simulateBet(): boolean;
    function parseRequest(roll: Integer): boolean;
    function checkForWin(): boolean;
    function findMaxProfitForBalance(): Integer;
    function searchForSelectorProfil(): TBetProfil;
    function getNextBet(round: Integer): Extended;
    function loadBetProfil(betProfil: String): TBetProfil;
    function simulateRoll(): Integer;
    procedure resetComputedBets();
    procedure resetStatistik();
    procedure resetAfterBroke();
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
  originalLoadedBetProfil, loadedBetProfil, inUseBetProfil: TBetProfil;
  currentTipProfil: TTipProfil;
  currentTip, profitAvailableForTip, currentBetIndex, currentRound, totalRounds, totalBrokeRounds, refinanceBalance, balance: Integer;
  computedBetList, computedProfitList, computedCostList: Array of Extended;
  wonOnRound: Array of Integer;
  pastRolls: array[0..9999, 1..2] of Integer;
  lastBetWon, lastBetSelector: Boolean;
  currentBet, avarageTipPerRound, totalTip, wastedTips, investedMoney: Extended;
  randomRollNumber: Integer;

implementation

{$R *.dfm}

function TForm9.simulateRoll(): Integer;
var roll: Integer;
begin
     balance := balance - trunc(currentBet);
     roll := Math.RandomRange(0, 10000);
     addOneToAllAbove(roll);
     addOneToAllBelow(roll);
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
        returnBetProfil.target := strtoint(iniFile.ReadString('Betprofil', 'Target', '').Replace('.', ''));
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
        if (inUseBetProfil.betType = ByProfit) or (inUseBetProfil.betType = ByMinRounds) then
        begin
            calculateNextBetCost(round);
        end;
        if (inUseBetProfil.betType = ByCustom) then
        begin
            result := 0;
            exit;
        end;
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
                returnProfil.target := strtoint(Form3.calculateRollByMultiply(returnProfil.condition, returnProfil.multiply).Replace('.', ''));
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

function TForm9.checkForWin(): boolean;
begin
    result := false;
    if (inUseBetProfil.condition.Equals('>')) then
    begin
        if (randomRollNumber > inUseBetProfil.target) then
        begin
            balance := balance + (trunc(currentBet) * inUseBetProfil.multiply);
            result := true;
        end;
    end else
        begin
            if (randomRollNumber < inUseBetProfil.target) then
            begin
                balance := balance + (trunc(currentBet) * inUseBetProfil.multiply);
                result := true;
            end;
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
    result := true;
end;

procedure TForm9.calculateCustomCost();
var fileData, lineData: TStringList;
    index: Integer;
    addedCost, newBet:extended;
begin
    fileData := TStringlist.Create;
    lineData := TStringlist.Create;
    addedCost := 0;
    if (FileExists('./bets/selector/custom_' + inUseBetProfil.profilName + '.ini')) then
    begin
        fileData.LoadFromFile('./bets/selector/custom_' + inUseBetProfil.profilName + '.ini');
        setLength(computedBetList, fileData.Count);
        setLength(computedCostList, fileData.Count);
        setLength(computedProfitList, fileData.Count);
        for index := 0 to fileData.Count - 1 do
        begin
            split(fileData[index], lineData);
            computedBetList[index] := strtofloat(lineData[1]);
            addedCost := addedCost + computedBetList[index];
            computedCostList[index] := addedCost;
            computedProfitList[index] := (computedBetList[index] * inUseBetProfil.multiply) - computedCostList[index];
        end;
        fileData.Free;
        lineData.Free;
    end;
end;

procedure TForm9.displayStatistik();
var i: integer;
begin
    Memo1.Clear;
    Memo1.lines.add('Balance: ' + inttostr(balance));
    Memo1.lines.Add('Wasted Tip: ' + floattostr(wastedTips));
    Memo1.lines.Add('Avg wasted tip per round: ' + floattostr(trunc(wastedTips / totalBrokeRounds)));
    Memo1.lines.Add('Avg tipped per round: ' + floattostr(trunc(totalTip / totalBrokeRounds)));
    Memo1.lines.Add('Profit: ' + floattostr(totalTip - investedMoney));
    Memo1.lines.Add('Total Rounds: ' + inttostr(totalRounds));
    listbox2.Clear;
    for i := 1 to 250 do
        listbox2.items.Add(inttostr(i) + ':' + inttostr(wonOnRound[i-1]));
end;

function TForm9.simulateBet(): boolean;
begin
    lastBetWon := checkForWin();
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
            wonOnRound[currentBetIndex] := wonOnRound[currentBetIndex] + 1;
            if (not lastBetSelector) then
            begin
                inc(currentRound);
                inc(totalRounds);
                if (round(computedProfitList[currentBetIndex]) > 0) then
                    profitAvailableForTip := profitAvailableForTip + round(computedProfitList[currentBetIndex]);
            end;
            reset();
            if (inUseBetProfil.allowSwitchProfilOnWin and not lastBetSelector) then
            begin
                inUseBetProfil := loadBetProfil(inUseBetProfil.nextBetProfil);
            end;
            if (inUseBetProfil.betType = ByProfit) then
            begin
                inUseBetProfil.profit := loadedBetProfil.profit;
            end;
            if (inUseBetProfil.betType = ByCustom) then
            begin
                calculateCustomCost();
            end;
            if (inUseBetProfil.betType = ByMinRounds) then
            begin
                if (findMaxProfitForBalance() <> inUseBetProfil.profit) then
                begin
                    inUseBetProfil.profit := findMaxProfitForBalance();
                    resetComputedBets();
                end;
            end;
            if (inUseBetProfil.inverse and not lastBetSelector) then
            begin
                inUseBetProfil.condition := ifthen(inUseBetProfil.condition = '>', '<', '>');
                inUseBetProfil.target := strtoint(Form3.calculateRollByMultiply(inUseBetProfil.condition, inUseBetProfil.multiply).Replace('.',''));
            end;
            currentBet := getNextBet(currentBetIndex);
            if (profitAvailableForTip div 100 * currentTipProfil.percent) >= currentTipProfil.minAmount then
            begin
                currentTip := currentTip + (profitAvailableForTip div 100 * currentTipProfil.percent);
                totalTip := totalTip + (profitAvailableForTip div 100 * currentTipProfil.percent);
                balance := balance - (profitAvailableForTip div 100 * currentTipProfil.percent);
                profitAvailableForTip := 0;
            end;
            lastBetSelector := false;
            randomRollNumber := simulateRoll();
            result := false;
        end else
            begin
                inc(currentBetIndex);
                currentBet := getNextBet(currentBetIndex);
                if (balance > currentBet) then
                begin
                    randomRollNumber := simulateRoll();
                    result := false;
                end else
                    begin
                        wastedTips := wastedTips + profitAvailableForTip;
                        result := true;
                    end;
            end;
    end else
        begin
            randomRollNumber := simulateRoll();
            result := false;
        end;
end;

procedure TForm9.reset();
begin
    currentBetIndex := 0;
    lastBetWon := false;
end;


procedure TForm9.Button1Click(Sender: TObject);
var betlost: boolean;
    i: Integer;
begin
    originalLoadedBetProfil := loadedBetProfil;
    randomize();
    refinanceBalance := strtoint(edit1.text);
    totalBrokeRounds := strtoint(edit2.Text);
    button1.Caption := 'Start';
    button1.enabled := false;
    resetStatistik();
    setLength(wonOnRound, 250);
    for I := 1 to totalBrokeRounds do
    begin
        reset();
        resetAfterBroke();
        resetComputedBets();
        if (inUseBetProfil.betType = BySelector) then
        begin
            inUseBetProfil := searchForSelectorProfil();
        end;
        if (inUseBetProfil.betType = ByMinRounds) then
        begin
            inUseBetProfil.profit := findMaxProfitForBalance();
        end;
        if (inUseBetProfil.betType = BySelector) then
        begin
            lastBetSelector := true;
        end;
        if (inUseBetProfil.betType = ByCustom) then
        begin
            calculateCustomCost();
        end;
        currentBet := getNextBet(currentBetIndex);
        randomRollNumber := simulateRoll();
        repeat
            betLost := simulateBet();
        until betLost;
        button1.Caption := inttostr(i);
    end;
    Form9.displayStatistik();
    button1.enabled := true;
    Form9.Button1.Caption := 'End';
end;

procedure TForm9.resetStatistik();
var i: Integer;
begin
    currentRound := 0;
    totalRounds := 0;
    profitAvailableForTip := 0;
    totalTip := 0;
    currentTip := 0;
    currentBet := 0;
    wastedTips := 0;
    balance := 0;
    investedMoney := 0;
    inUseBetProfil := originalLoadedBetProfil;
    loadedBetProfil := originalLoadedBetProfil;
    for I := 0 to 9999 do
    begin
        pastRolls[i, 1] := 0;
        pastRolls[i, 2] := 0;
    end;
end;

procedure TForm9.resetComputedBets();
begin
    setLength(computedCostList, 0);
    setLength(computedProfitList, 0);
    setLength(computedBetList, 0);
end;

procedure TForm9.resetAfterBroke();
begin
    investedMoney := investedMoney + refinanceBalance;
    profitAvailableForTip := 0;
    currentRound := 0;
    currentBet := 0;
    lastBetSelector := false;
    balance := balance + refinanceBalance;
    inUseBetProfil := originalLoadedBetProfil;
    loadedBetProfil := originalLoadedBetProfil;
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
