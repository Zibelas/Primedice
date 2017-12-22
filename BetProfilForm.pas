unit BetProfilForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Inifiles, IOUtils, Math,
  Vcl.ExtCtrls;

type
  TForm3 = class(TForm)
    Label4: TLabel;
    Label13: TLabel;
    ComboBox1: TComboBox;
    Edit11: TEdit;
    ComboBox2: TComboBox;
    Label5: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Edit3: TEdit;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Edit4: TEdit;
    RadioGroup1: TRadioGroup;
    Edit2: TEdit;
    Edit5: TEdit;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    CheckBox2: TCheckBox;
    Label6: TLabel;
    GroupBox2: TGroupBox;
    CheckBox3: TCheckBox;
    ComboBox3: TComboBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    ListBox1: TListBox;
    Edit8: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Edit9: TEdit;
    ComboBox4: TComboBox;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ListBox2: TListBox;
    Edit10: TEdit;
    Button5: TButton;
    Button6: TButton;
    procedure loadProfiles;
    procedure clearData();
    procedure split(input: string; listOfStrings: TStrings);
    function calculateRollByMultiply(condition: String; multiply: Integer): String;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit11Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TBetType = (ByProfit = 0, ByMinRounds = 1, BySelector = 2, ByCustom = 3);

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./bets/' + ChangeFileExt(edit1.Text, '.ini'));
    try
        iniFile.WriteInteger('Betprofil', 'Profit', strtoint(edit2.Text));
        iniFile.WriteString('Betprofil', 'Name', edit1.Text);
        iniFile.WriteString('Betprofil', 'Target', edit3.Text);
        iniFile.WriteString('Betprofil', 'Condition', combobox1.Items[combobox1.ItemIndex]);
        iniFile.WriteInteger('Betprofil', 'Multiply', strtoint(edit11.Text));
        iniFile.WriteBool('Betprofil', 'Inverse', checkbox1.checked);
        iniFile.WriteInteger('Betprofil', 'ZeroBets', strtoint(edit4.Text));
        iniFile.WriteInteger('Betprofil', 'MinRounds', strtoint(edit5.Text));
        iniFile.WriteInteger('Betprofil', 'BetType', RadioGroup1.ItemIndex);
        iniFile.WriteBool('Revenge', 'AllowRevange', checkbox2.Checked);
        iniFile.WriteInteger('Revenge', 'Multiply', strtoint(edit6.Text));
        iniFile.WriteInteger('Revenge', 'TriggerTime', strtoint(edit7.Text));
        iniFile.WriteBool('SwitchProfil', 'AllowSwitch', checkbox3.Checked);
        iniFile.WriteString('SwitchProfil', 'NextProfil', combobox3.Items[combobox3.ItemIndex]);
    finally
        iniFile.Free;
    end;
    if (RadioGroup1.ItemIndex = 2) then
    begin
        listbox1.Items.SaveToFile('./bets/selector/selector_'+ ChangeFileExt(edit1.Text, '.ini'));
    end;
    if (RadioGroup1.ItemIndex = 3) then
    begin
        listbox2.Items.SaveToFile('./bets/selector/custom_' + ChangeFileExt(edit1.Text, '.ini'));
    end;
    loadProfiles();
end;

procedure TForm3.ComboBox2Change(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./bets/' + combobox2.Items[combobox2.ItemIndex]);
    try
        edit1.Text := iniFile.ReadString('Betprofil', 'Name', '');
        edit2.Text := inttostr(iniFile.ReadInteger('Betprofil', 'Profit', 0));
        edit11.Text := inttostr(iniFile.ReadInteger('Betprofil', 'Multiply', 0));
        combobox1.Text := iniFile.ReadString('Betprofil', 'Condition', '>');
        edit3.Text := iniFile.ReadString('Betprofil', 'Target', '');
        edit4.Text := inttostr(iniFile.ReadInteger('Betprofil', 'ZeroBets', 0));
        edit5.Text := inttostr(iniFile.ReadInteger('Betprofil', 'MinRounds', 0));
        checkbox1.checked := iniFile.ReadBool('Betprofil', 'Inverse', false);
        RadioGroup1.ItemIndex := iniFile.ReadInteger('Betprofil', 'BetType', 0);
        checkbox3.Checked := iniFile.ReadBool('SwitchProfil', 'AllowSwitch', false);
        combobox3.Text := iniFile.ReadString('SwitchProfil', 'NextProfil', '');
    finally
        iniFile.Free;
    end;
end;

procedure TForm3.Edit11Change(Sender: TObject);
var multiply: Integer;
    condition: String;
begin
    if (edit11.Text <> '') and (edit11.Text <> '0') then
    begin
         multiply := strtoint(edit11.Text);
         condition := combobox1.Items[combobox1.ItemIndex];
         edit3.Text := calculateRollByMultiply(condition, multiply);
    end;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
    Listbox1.Items.Add(Edit8.Text + ':' + edit9.Text + ':' + combobox4.items[combobox4.ItemIndex]);
    edit8.Text := '';
    edit9.Text := '';
    combobox4.Text := '';
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
    Listbox1.Items.Delete(listbox1.ItemIndex);
end;

procedure TForm3.Button4Click(Sender: TObject);
begin
    listbox1.items[listbox1.ItemIndex] := Edit8.Text + ':' + edit9.Text + ':' + combobox4.items[combobox4.ItemIndex];
end;

procedure TForm3.Button5Click(Sender: TObject);
begin
    listbox2.Items.Add(inttostr(listbox2.Items.Count + 1) + ':' + edit10.Text);
end;

function TForm3.calculateRollByMultiply(condition: String; multiply: Integer): String;
var target: String;
begin
    if (condition = '>') then
    begin
         target := floatToStr(Math.RoundTo((100 - (99 / multiply) - 0.01), -2)).replace(',', '.');
    end else
        begin
             target := floatToStr(Math.RoundTo(99 / multiply, -2)).replace(',', '.');
        end;
    if not target.Contains('.') then
           begin
               target := target + '.00';
           end;
    if (target.Length < 5) and (target.Length - target.IndexOf('.') = 2) then
    begin
        target := target + '0';
    end;
    while target.Length < 5 do
    begin
        target := '0' + target;
    end;
    result := target;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
    loadProfiles();
    clearData();
end;

procedure TForm3.split(input: string; listOfStrings: TStrings);
begin
   listOfStrings.Clear;
   listOfStrings.Delimiter       := ':';
   listOfStrings.StrictDelimiter := True;
   listOfStrings.DelimitedText   := input;
end;

procedure TForm3.ListBox1Click(Sender: TObject);
var lineData: TStringList;
begin
    lineData := TStringList.Create();
    split(listbox1.Items[listbox1.ItemIndex], lineData);
    edit8.Text := lineData[0];
    edit9.Text := lineData[1];
    combobox4.text := lineData[2];
    lineData.Free;
end;

procedure TForm3.loadProfiles();
var path: String;
begin
    if not DirectoryExists('./bets/') then
           CreateDir('./bets');
    if not DirectoryExists('./bets/selector/') then
           CreateDir('./bets/selector');
    Combobox2.Clear;
    for path in TDirectory.GetFiles('./bets/') do
        Combobox2.Items.Add(path.Remove(0, 7));
    Combobox3.Clear;
    for path in TDirectory.GetFiles('./bets/') do
        Combobox3.Items.Add(path.Remove(0, 7));
    Combobox4.Clear;
    for path in TDirectory.GetFiles('./bets/') do
        Combobox4.Items.Add(path.Remove(0, 7));
end;

procedure TForm3.RadioGroup1Click(Sender: TObject);
begin
    if (RadioGroup1.ItemIndex = 2) and(FileExists('./bets/selector/selector_'+ ChangeFileExt(edit1.Text, '.ini'))) then
    begin
        listbox1.Items.LoadFromFile('./bets/selector/selector_'+ ChangeFileExt(edit1.Text, '.ini'));
    end;
end;

procedure TForm3.clearData();
begin
    edit1.Text := '';
    edit2.Text := '0';
    edit3.Text := '';
    edit4.Text := '0';
    edit5.Text := '0';
    edit11.Text := '';
    combobox1.Text := '>';
    checkbox1.Checked := false;
    checkbox2.Checked := false;
    checkbox3.Checked := false;
    RadioGroup1.ItemIndex := 0;
end;

end.
