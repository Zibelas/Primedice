unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IPPeerClient, REST.Client, System.JSON,
  Data.Bind.Components, Data.Bind.ObjectScope, Vcl.StdCtrls, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.EngExt, Vcl.Bind.DBEngExt,
  Vcl.ExtCtrls, System.Math, REST.HttpClient, Inifiles, Vcl.Menus, IOUtils, StrUtils;

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
    Edit4: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label15: TLabel;
    Label16: TLabel;
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
    Button3: TButton;
    Options1: TMenuItem;
    Endafterround: TMenuItem;
    Simulation: TMenuItem;
    Resetstatistik1: TMenuItem;
    Label3: TLabel;
    Label4: TLabel;
    RESTRequest2: TRESTRequest;
    RESTClient2: TRESTClient;
    RESTResponse2: TRESTResponse;
    MemoContent: TMemo;
    LinkControlToFieldContent: TLinkControlToField;
    BindingsList1: TBindingsList;
    procedure Button1Click(Sender: TObject);
    procedure betBySetProfit(amount: double; target, condition: string);
    procedure reset();
    procedure resetStatistic();
    procedure calculateNextBetCost(round: integer);
    procedure loadUserProfiles();
    procedure loadTipProfiles();
    procedure loadBetProfiles();
    procedure tip(amount: integer);
    function parseRequest(input: TJSONValue): boolean;
    function parseForDisplayBet(currentBetIndex: Integer): string;
    function getNextBet(round: Integer): Extended;
    procedure writeLog(logString, fileName: String);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure User1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure Bet1Click(Sender: TObject);
    procedure TipProfil1Click(Sender: TObject);
    procedure EndafterroundClick(Sender: TObject);
    procedure SimulationClick(Sender: TObject);
    procedure Resetstatistik1Click(Sender: TObject);

  private
    { Privat
    procedure ipProfil1Click(Sender: TObject);e declarations }
  public
    { Public declarations }
  end;

type TUser = class
     apiKey: String;
end;

type TBetProfil = class
     profit: integer;
     multiply: integer;
     zeroBets: integer;
     inverse: boolean;
     condition: String;
     target: String
end;

type TTipProfil = class
     receiver: String;
     percent: Integer;
     minAmount: Integer;
end;

var
  Form1: TForm1;
  //apiKey, condition, target,
  lastProfit: String;

  //multiply,
  maxAmountOfRounds,  maxBetsPerRound, currentBetIndex,  currentRound: integer;
  lastBetWon, lastBetDone: boolean;
  onceWon: boolean;

  currentUser: TUser;
  currentTipProfil: TTipProfil;
  currentBetProfil: TBetProfil;

  id, roll, nonce: string;
  //targetProfitPerRound,
  longestLoosingStreak, softStop, hardStop, profitAvailableForTip: Integer;
  currentBet, profitPerSesson, tipPerSesson: extended;
  computedBetList, computedProfitList, computedCostList: Array of Extended;

implementation

uses UserForm, BetProfilForm, TippingForm;

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
    if (currentBetProfil.zeroBets <= round) then
    begin
        while ((newBet * currentBetProfil.multiply) - addedCost - newBet < currentBetProfil.profit) do
            newBet := newBet + 1;
    end;
    computedBetList[high(computedBetList)] := newBet;
    if (high(computedCostList) - 1 >= 0) then
        computedCostList[high(computedCostList)] := computedCostList[high(computedCostList) - 1] + newBet
    else
        computedCostList[high(computedCostList)] := newBet;
    computedProfitList[high(computedProfitList)] := (newBet * currentBetProfil.multiply) - computedCostList[high(computedBetList)];
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./bets/' + combobox1.Items[combobox1.ItemIndex]);
    currentBetProfil := TBetProfil.Create;
    try
        currentBetProfil.profit := iniFile.ReadInteger('Betprofil', 'Profit', 0);
        currentBetProfil.condition := iniFile.ReadString('Betprofil', 'Condition', '>');
        currentBetProfil.zeroBets := iniFile.ReadInteger('Betprofil', 'ZeroBets', 0);
        currentBetProfil.target := iniFile.ReadString('Betprofil', 'Target', '');
        currentBetProfil.multiply := iniFile.ReadInteger('Betprofil', 'Multiply', 0);
        currentBetProfil.inverse := iniFile.ReadBool('Betprofil', 'Inverse', false);
    finally
        iniFile.Free;
    end;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./user/' + combobox2.Items[combobox2.ItemIndex]);
    currentUser := TUser.Create;
    try
        currentUser.apiKey := iniFile.ReadString('User', 'ApiKey', '');
    finally
        iniFile.Free;
    end;
end;

procedure TForm1.ComboBox3Change(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./tips/' + combobox3.Items[combobox3.ItemIndex]);
    currentTipProfil := TTipProfil.Create;
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

procedure TForm1.Button1Click(Sender: TObject);
begin
//    apiKey := edit1.Text;
    maxAmountOfRounds := strtoint(edit10.Text);
//    multiply := strtoint(edit11.Text);
//    targetProfitPerRound := strtoint(edit2.Text);
    softStop := strtoint(edit5.Text);
    hardStop := strtoint(edit6.Text);
//    target := edit3.Text;
    longestLoosingStreak := 0;
    setLength(computedCostList, 0);
    setLength(computedProfitList, 0);
    setLength(computedBetList, 0);
//    condition := combobox1.Items[combobox1.ItemIndex];
    RestClient1.BaseURL := 'https://api.primedice.com/api/bet?api_key=' + currentUser.apiKey;
    reset();
    currentBet := getNextBet(currentBetIndex);
    if (simulation.Checked) then
    begin
        currentBet := 0;
    end;
    timer1.Enabled := true;
    lastBetDone := true;
    lastBetWon := false;
    button1.Enabled := false;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    timer1.Enabled := false;
    button1.Enabled := true;
end;

procedure TForm1.Button3Click(Sender: TObject);
var i: Integer;
begin
    listbox1.Clear;
//    multiply := strtoint(edit11.Text);
//    targetProfitPerRound := strtoint(edit2.Text);
    setLength(computedCostList, 0);
    setLength(computedProfitList, 0);
    setLength(computedBetList, 0);
    listbox1.Items.Add('Round, TotalCost, Profit');
    for I := 1 to strtoint(edit4.Text) do
    begin
        calculateNextBetCost(i-1);
        listbox1.Items.Add(inttostr(i) + '/' + floattostr(computedCostList[i-1]) + '/' + floattostr(computedProfitList[i-1]));
    end;
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

procedure TForm1.Button5Click(Sender: TObject);
begin
    RestClient1.BaseURL := 'https://api.primedice.com/api/tip?api_key=' + currentUser.apiKey;
    //RESTRequest1.addParameter('amount', currentTipProfil.percent);
    RESTRequest1.addParameter('username', currentTipProfil.receiver);
    RESTRequest1.Execute;
end;

procedure TForm1.Tip(amount: integer);
begin
    RestClient2.BaseURL := 'https://api.primedice.com/api/tip?api_key=' + currentUser.apiKey;
    RESTRequest2.addParameter('amount', inttostr(amount));
    RESTRequest2.addParameter('username', currentTipProfil.receiver);
    RESTRequest2.Execute;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
    RestClient1.BaseURL := 'https://api.primedice.com/api/mybets?api_key=' + currentUser.apiKey;
    RESTRequest1.Execute;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    betBySetProfit(currentBet, currentBetProfil.target, currentBetProfil.condition);
end;

procedure TForm1.User1Click(Sender: TObject);
begin
    Form2.show();
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
        if (lastBetWon) then
        begin
            inc(currentRound);
            listbox1.Items.Add(parseForDisplayBet(currentBetIndex));
            profitPerSesson := profitPerSesson + computedProfitList[currentBetIndex];
            profitAvailableForTip := profitAvailableForTip + round(computedProfitList[currentBetIndex]);
            reset();
            if (currentBetProfil.inverse) then
            begin
                currentBetProfil.condition := ifthen(currentBetProfil.condition = '>', '<', '>');
                currentBetProfil.target := Form3.calculateRollByMultiply(currentBetProfil.condition, currentBetProfil.multiply);
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
            if ((softStop <> 0) and (currentBetIndex >= softStop)) then
            begin
                timer1.Enabled := false;
                button1.Enabled := true;
                endafterround.checked := false;
            end;
            if ((currentRound  >= maxAmountofRounds) or (endafterround.checked = true)) then
            begin
                timer1.Enabled := false;
                button1.Enabled := true;
                endafterround.Checked := false;
            end;
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
                if ((hardStop <> 0) and (currentBetIndex >= hardStop)) then
                begin
                  timer1.Enabled := false;
                end;
            end;
        label4.Caption := floattostr(profitAvailableForTip);
        label6.Caption := inttostr(currentBetIndex);
        label8.Caption := floattostr(profitPerSesson);
        label10.Caption := inttostr(currentRound);
        label14.Caption := inttostr(longestLoosingStreak);
    end;
end;

procedure TForm1.reset();
begin
    currentBetIndex := 0;
    onceWon := false;
    lastBetWon := false;
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

function TForm1.parseRequest(input: TJSONValue): boolean;
var jObject, betJSON, userJSON: TJSONObject;
begin
    jObject := input as TJSONObject;
    betJSON := jObject.Values['bet'] as TJSONObject;
    userJSON := jObject.Values['user'] as TJSONObject;
    id := betJSON.Values['id'].Value;
    roll := betJSON.Values['roll'].Value;
    writeLog(roll + ':' + nonce + ':' + id, 'pastRolls.txt');
    nonce := betJSON.Values['nonce'].Value;
    if (roll.Equals('77.77')) then
    begin
        writeLog(nonce + ':' + id, 'jackpot.txt');
    end;
    lastProfit := betJSON.Values['profit'].Value;
    lastBetWon := StrToBool(betJSON.Values['win'].value);
    //listbox1.Items.Add('ID: ' + id + ', roll: ' + roll + ' betAmount: ' + floatToStr(lastBetAmount) + ' win: ' + BoolToStr(lastBetWon));
    result := lastBetWon;
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
