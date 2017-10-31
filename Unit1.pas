unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IPPeerClient, REST.Client, System.JSON,
  Data.Bind.Components, Data.Bind.ObjectScope, Vcl.StdCtrls, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.EngExt, Vcl.Bind.DBEngExt,
  Vcl.ExtCtrls, Math, REST.HttpClient, Inifiles, Vcl.Menus, IOUtils, StrUtils, BetProfilForm;

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
  TForm1 = class(TForm)
    RESTRequest1: TRESTRequest;
    RESTClient1: TRESTClient;
    RESTResponse1: TRESTResponse;
    Label1: TLabel;
    Button1: TButton;
    Timer1: TTimer;
    ListBox1: TListBox;
    Button2: TButton;
    Edit10: TEdit;
    Label12: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    MainMenu1: TMainMenu;
    New1: TMenuItem;
    User1: TMenuItem;
    ComboBox2: TComboBox;
    Bet1: TMenuItem;
    Label2: TLabel;
    ComboBox1: TComboBox;
    CheckBox3: TCheckBox;
    ComboBox3: TComboBox;
    TipProfil1: TMenuItem;
    ools1: TMenuItem;
    BasicSurvivalCalc1: TMenuItem;
    Options1: TMenuItem;
    Endafterround: TMenuItem;
    Simulation: TMenuItem;
    Resetstatistik1: TMenuItem;
    Label3: TLabel;
    Label4: TLabel;
    RESTRequest2: TRESTRequest;
    RESTClient2: TRESTClient;
    RESTResponse2: TRESTResponse;
    BasicRoundCalc1: TMenuItem;
    Label13: TLabel;
    Label15: TLabel;
    RESTRequest3: TRESTRequest;
    RESTResponse3: TRESTResponse;
    RESTClient3: TRESTClient;
    ListBox2: TListBox;
    Button3: TButton;
    Label16: TLabel;
    Label17: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure betBySetProfit(amount: double; target, condition: string);
    procedure reset();
    procedure resetStatistic();
    procedure calculateNextBetCost(round: integer);
    procedure loadUserProfiles();
    procedure loadTipProfiles();
    procedure loadBetProfiles();
    procedure tip(amount: integer);
    procedure parseUser(input: TJSONValue);
    function loadBetProfil(betProfil: String): TBetProfil;
    procedure split(input: string; listOfStrings: TStrings);
    procedure writeRollHistory();
    procedure readRollHistory();
    procedure test();
    procedure addOneToAllAbove(index: Integer);
    procedure addOneToAllBelow(index: Integer);
    function findMaxProfitForBalance(): Integer;
    procedure displayHistoryBets();
    procedure doPrint(index: Integer);
    function searchForSelectorProfil(): TBetProfil;
    function parseRequest(input: TJSONValue): boolean;
    function parseForDisplayBet(currentBetIndex: Integer): string;
    function getNextBet(round: Integer): Extended;
    procedure writeLog(logString, fileName: String);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure User1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure Bet1Click(Sender: TObject);
    procedure TipProfil1Click(Sender: TObject);
    procedure EndafterroundClick(Sender: TObject);
    procedure SimulationClick(Sender: TObject);
    procedure Resetstatistik1Click(Sender: TObject);
    procedure BasicRoundCalc1Click(Sender: TObject);
    procedure BasicSurvivalCalc1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private

  public

  end;

type TUser = record
     apiKey: String;
     userName: String;
     balance: extended;
end;

type TTipProfil = record
     receiver: String;
     percent: Integer;
     minAmount: Integer;
end;

var
  Form1: TForm1;
  lastProfit: String;

  maxAmountOfRounds,  maxBetsPerRound, currentBetIndex,  currentRound: integer;
  lastBetWon, lastBetSelector: boolean;
  onceWon: boolean;

  currentUser: TUser;
  currentTipProfil: TTipProfil;
  loadedBetProfil, inUseBetProfil: TBetProfil;

  id, roll, nonce: string;
  longestLoosingStreak, profitAvailableForTip: Integer;
  currentBet, profitPerSesson, tipPerSesson: extended;
  computedBetList, computedProfitList, computedCostList: Array of Extended;

  pastRolls: array[0..9999, 1..2] of Integer;

implementation

uses UserForm, TippingForm, BasicRoundCalc, BasicProfitCalc;

{$R *.dfm}

procedure TForm1.calculateNextBetCost(round: integer);
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

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
    inUseBetProfil := loadBetProfil(combobox1.Items[combobox1.ItemIndex]);
end;

function TForm1.loadBetProfil(betProfil: String): TBetProfil;
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

procedure TForm1.ComboBox2Change(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./user/' + combobox2.Items[combobox2.ItemIndex]);
    try
        currentUser.apiKey := iniFile.ReadString('User', 'ApiKey', '');
        currentUser.userName := iniFile.ReadString('User', 'Name', '');
    finally
        iniFile.Free;
    end;
    RestClient3.BaseURL := 'https://api.primedice.com/api/users/1?api_key=' + currentUser.apiKey;
    RESTRequest3.Execute;
    parseUser(RestResponse3.JSONValue);
    label15.Caption := floattostr(currentUser.balance);
    readRollHistory();
end;

procedure TForm1.ComboBox3Change(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./tips/' + combobox3.Items[combobox3.ItemIndex]);
    try
        currentTipProfil.receiver := iniFile.ReadString('Tipprofil', 'Receiver', '');
        currentTipProfil.percent := iniFile.ReadInteger('Tipprofil', 'Percent', 0);
        currentTipProfil.minAmount := iniFile.ReadInteger('Tipprofil', 'MinAmount', 10000);
    finally
        iniFile.Free;
    end;
end;

procedure TForm1.EndafterroundClick(Sender: TObject);
begin
     Endafterround.checked := not Endafterround.checked;
end;

procedure TForm1.loadUserProfiles();
var path: String;
begin
    if not DirectoryExists('./user/') then
           CreateDir('./user');
    Combobox2.Clear;
    for path in TDirectory.GetFiles('./user/') do
        Combobox2.Items.Add(path.Remove(0, 7));
end;

procedure TForm1.loadTipProfiles();
var path: String;
begin
    if not DirectoryExists('./tips/') then
           CreateDir('./tips');
    Combobox3.Clear;
    for path in TDirectory.GetFiles('./tips/') do
        Combobox3.Items.Add(path.Remove(0, 7));
end;

procedure TForm1.loadBetProfiles();
var path: String;
begin
    if not DirectoryExists('./bets/') then
           CreateDir('./bets');
    if not DirectoryExists('./bets/selector/') then
           CreateDir('./bets/selector');
    if not DirectoryExists('./preCalc/') then
           CreateDir('./preCalc');
    Combobox1.Clear;
    for path in TDirectory.GetFiles('./bets/') do
        Combobox1.Items.Add(path.Remove(0, 7));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    resetStatistic();
    loadUserProfiles();
    loadTipProfiles();
    loadBetProfiles();
end;

function TForm1.getNextBet(round: Integer): Extended;
begin
    if (length(computedBetList) <= round) then
    begin
        calculateNextBetCost(round);
    end;
    result := computedBetList[round];
end;

function TForm1.searchForSelectorProfil(): TBetProfil;
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

procedure TForm1.Button1Click(Sender: TObject);
begin
    maxAmountOfRounds := strtoint(edit10.Text);
    longestLoosingStreak := 0;
    setLength(computedCostList, 0);
    setLength(computedProfitList, 0);
    setLength(computedBetList, 0);
    RestClient1.BaseURL := 'https://api.primedice.com/api/bet?api_key=' + currentUser.apiKey;
    reset();
    lastBetSelector := false;
    if (inUseBetProfil.betType = BySelector) then
    begin
        inUseBetProfil := searchForSelectorProfil();
    end;
    if (inUseBetProfil.betType = ByMinRounds) then
    begin
        inUseBetProfil.profit := findMaxProfitForBalance();
    end;
    currentBet := getNextBet(currentBetIndex);
    if (simulation.Checked) then
    begin
        currentBet := 0;
    end;
    if (inUseBetProfil.betType = BySelector) then
    begin
        lastBetSelector := true;
    end;
    timer1.Enabled := true;
    lastBetWon := false;
    button1.Enabled := false;
    combobox1.Enabled := false;
end;

procedure TForm1.displayHistoryBets();
begin
    doPrint(2);
    doPrint(5);
    doPrint(10);
    doPrint(25);
    doPrint(50);
    doPrint(75);
    doPrint(100);
    doPrint(150);
    doPrint(200);
    doPrint(250);
    doPrint(300);
    doPrint(500);
    doPrint(750);
    doPrint(1000);
    doPrint(1250);
end;

function TForm1.findMaxProfitForBalance(): Integer;
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
        if (strtofloat(lineData[0]) <= currentUser.balance) then
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

procedure TForm1.split(input: string; listOfStrings: TStrings);
begin
   listOfStrings.Clear;
   listOfStrings.Delimiter       := ':';
   listOfStrings.StrictDelimiter := True;
   listOfStrings.DelimitedText   := input;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    timer1.Enabled := false;
    button1.Enabled := true;
    combobox1.Enabled := true;
end;

procedure TForm1.addOneToAllAbove(index: Integer);
var i: Integer;
begin
    for I := index to 9999 do
        pastRolls[i, 1] := pastRolls[i, 1] + 1;
    for I := 0 to index do
        pastRolls[i, 1] := 0;
end;

procedure TForm1.addOneToAllBelow(index: Integer);
var i: Integer;
begin
    for I := 0 to index do
        pastRolls[i, 2] := pastRolls[i, 2] + 1;
    for I := index to 9999 do
        pastRolls[i, 2] := 0;
end;

procedure TForm1.doPrint(index: Integer);
var low, high: Integer;
begin
    low := trunc(Math.RoundTo(99 / index, -2) * 100);
    high := trunc(Math.RoundTo(100 - (99 / index), -2) * 100);
    Listbox2.Items.Add(inttostr(index) + ':High(' + (inttostr(pastRolls[high, 1])) + '):Low(' + (inttostr(pastRolls[low, 2])) + ')');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
    test();
end;

procedure TForm1.resetStatistic();
begin
    currentRound := 0;
    profitPerSesson := 0;
    listbox1.Clear;
    listbox1.Items.Add('Round:Bets   :Payed        :Profit');
end;

procedure TForm1.Resetstatistik1Click(Sender: TObject);
begin
    resetStatistic();
end;

procedure TForm1.SimulationClick(Sender: TObject);
begin
    simulation.Checked := not simulation.Checked;
end;

procedure TForm1.Tip(amount: integer);
begin
    RestClient2.BaseURL := 'https://api.primedice.com/api/tip?api_key=' + currentUser.apiKey;
    RESTRequest2.addParameter('amount', inttostr(amount));
    RESTRequest2.addParameter('username', currentTipProfil.receiver);
    RESTRequest2.Execute;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    betBySetProfit(currentBet, inUseBetProfil.target, inUseBetProfil.condition);
end;

procedure TForm1.User1Click(Sender: TObject);
begin
    Form2.show();
end;

procedure TForm1.BasicRoundCalc1Click(Sender: TObject);
begin
    Form5.Show();
end;

procedure TForm1.BasicSurvivalCalc1Click(Sender: TObject);
begin
    Form6.show();
end;

procedure TForm1.Bet1Click(Sender: TObject);
begin
    Form3.Show();
end;

procedure TForm1.TipProfil1Click(Sender: TObject);
begin
    Form4.show();
end;

procedure TForm1.betBySetProfit(amount: double; target, condition: string);
begin
    RESTRequest1.addParameter('amount', floatToStr(amount));
    RESTRequest1.addParameter('target', target);
    RESTRequest1.addParameter('condition', condition);
    RESTRequest1.Execute;
    if (RestResponse1.StatusCode = 200) then
    begin
        lastBetWon := parseRequest(RestResponse1.JSONValue);
        if (inUseBetProfil.betType = BySelector) then
        begin
            inUseBetProfil := searchForSelectorProfil();
            if (inUseBetProfil.betType <> BySelector) then
            begin
                lastBetWon := true;
                lastBetSelector := true;
            end;
        end;
        test();
        if not (inUseBetProfil.betType = BySelector) then
        begin
            if (lastBetWon) then
            begin
                if (not lastBetSelector) then
                begin
                    inc(currentRound);
                    listbox1.Items.Add(parseForDisplayBet(currentBetIndex));
                    profitPerSesson := profitPerSesson + computedProfitList[currentBetIndex];
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
                if (inUseBetProfil.betType = ByMinRounds) then
                begin
                    if (findMaxProfitForBalance() <> inUseBetProfil.profit) then
                    begin
                        inUseBetProfil.profit := findMaxProfitForBalance();
                    end;
                end;
                if (inUseBetProfil.allowRevenge and not lastBetSelector) then
                begin
                    inUseBetProfil.profit := inUseBetProfil.profit * inUseBetProfil.revengeMultiply;
                end;
                if (inUseBetProfil.inverse and not lastBetSelector) then
                begin
                    inUseBetProfil.condition := ifthen(inUseBetProfil.condition = '>', '<', '>');
                    inUseBetProfil.target := Form3.calculateRollByMultiply(inUseBetProfil.condition, inUseBetProfil.multiply);
                end;
                currentBet := getNextBet(currentBetIndex);
                if (checkbox3.Checked) then
                begin
                    if (profitAvailableForTip * 100 div currentTipProfil.percent) >= currentTipProfil.minAmount then
                    begin
                        tip(profitAvailableForTip * 100 div currentTipProfil.percent);
                        tipPerSesson := tipPerSesson + (profitAvailableForTip div currentTipProfil.percent);
                        profitAvailableForTip := 0;
                    end;
                end;
                if (simulation.Checked) then
                begin
                    currentBet := 0;
                end;
                if ((currentRound  >= maxAmountofRounds) or (endafterround.checked = true)) then
                begin
                    timer1.Enabled := false;
                    button1.Enabled := true;
                    endafterround.Checked := false;
                end;
                lastBetSelector := false;
            end else
                begin
                    inc(currentBetIndex);
                    if (currentBetIndex > longestLoosingStreak) then
                    begin
                        longestLoosingStreak := currentBetIndex;
                    end;
                    currentBet := getNextBet(currentBetIndex);
                    if (simulation.Checked) then
                    begin
                        currentBet := 0;
                    end;
                end;
        end;
        label15.Caption := floattostr(currentUser.balance);
        label4.Caption := floattostr(profitAvailableForTip);
        label6.Caption := inttostr(currentBetIndex);
        label8.Caption := floattostr(profitPerSesson);
        label10.Caption := inttostr(currentRound);
        label14.Caption := inttostr(longestLoosingStreak);
        label17.Caption := inUseBetProfil.profilName;
    end;
end;

procedure TForm1.reset();
begin
    currentBetIndex := 0;
    onceWon := false;
    lastBetWon := false;
    setLength(computedCostList, 0);
    setLength(computedProfitList, 0);
    setLength(computedBetList, 0);
end;

function TForm1.parseForDisplayBet(currentBetIndex: Integer): string;
var display, amountBets, displayPayment, displayProfit: string;
begin
    display := inttostr(currentRound);
    while (display.Length) < 5 do display := '0' + display;
    amountBets := inttostr(currentBetIndex + 1);
    while (amountBets.Length) < 5 do amountBets := '0' + amountBets;
    displayPayment := floattostr(computedCostList[currentBetIndex]);
    while (displayPayment.Length) < 9 do displayPayment := '0' + displayPayment;
    displayProfit := floattostr(computedProfitList[currentBetIndex]);
    while (displayProfit.Length) < 8 do displayProfit := '0' + displayProfit;
    result := display + ':' + amountBets + ':' + displayPayment + ':' + displayProfit;
    writeLog(result + ':' + id + ':' + nonce, 'log.txt');
end;

procedure TForm1.test();
begin
    Listbox2.Clear;
    displayHistoryBets();
end;

function TForm1.parseRequest(input: TJSONValue): boolean;
var jObject, betJSON: TJSONObject;
begin
    jObject := input as TJSONObject;
    betJSON := jObject.Values['bet'] as TJSONObject;
    parseUser(input);
    id := betJSON.Values['id'].Value;
    roll := betJSON.Values['roll'].Value;
    addOneToAllAbove(trunc(strtofloat(roll) * 100));
    addOneToAllBelow(trunc(strtofloat(roll) * 100));
    writeRollHistory();
    writeLog(roll + ':' + nonce + ':' + id, 'pastRolls.txt');
    nonce := betJSON.Values['nonce'].Value;
    if (roll.Equals('77.77')) then
    begin
        writeLog(nonce + ':' + id, 'jackpot.txt');
    end;
    lastProfit := betJSON.Values['profit'].Value;
    lastBetWon := StrToBool(betJSON.Values['win'].value);
    result := lastBetWon;
end;

procedure TForm1.parseUser(input: TJSONValue);
var jObject, userJSON: TJSONObject;
begin
    jObject := input as TJSONObject;
    userJSON := jObject.Values['user'] as TJSONObject;
    currentUser.balance := strtofloat(userJSON.Values['balance'].Value);
end;

procedure TForm1.writeRollHistory();
var f: TextFile;
    fileName: String;
    index: Integer;
begin
    fileName := currentUser.userName + '_pastRolls.txt';
    AssignFile(f, fileName);
    Rewrite(f);
    for index := 0 to 9999 do
    begin
        Writeln(f, inttostr(index) + ':' + inttostr(pastrolls[index, 1]) + ':' + inttostr(pastrolls[index, 2]));
    end;
    CloseFile(f);
end;

procedure TForm1.readRollHistory();
var fileName: String;
    index: Integer;
    fileData, lineData: TStringList;
begin
    fileName := currentUser.userName + '_pastRolls.txt';
    if FileExists(fileName) then
    begin
        fileData := TStringList.Create;
        lineData := TStringList.Create;
        fileData.LoadFromFile(currentUser.userName + '_pastRolls.txt');
        for index := 0 to fileData.Count - 1 do
        begin
            split(fileData[index], lineData);
            pastRolls[index, 1] := strtoint(lineData[1]);
            pastRolls[index, 2] := strtoint(lineData[2]);
        end;
        lineData.Free;
        fileData.Free;
    end else
    begin
        for index := 0 to 9999 do
        begin
            pastRolls[index, 1] := 0;
            pastRolls[index, 2] := 0;
        end;
    end;
end;

procedure TForm1.writeLog(logString, fileName: String);
var f: TextFile;
begin
    AssignFile(f, fileName);
    if FileExists(fileName) then
    begin
        Append(f)
    end else
    begin
        Rewrite(f);
    end;
    Writeln(f, LogString);
    CloseFile(f);
end;

end.
