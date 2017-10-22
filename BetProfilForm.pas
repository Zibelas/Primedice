unit BetProfilForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Inifiles, IOUtils, Math;

type
  TForm3 = class(TForm)
    Label2: TLabel;
    Label4: TLabel;
    Label13: TLabel;
    Edit2: TEdit;
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
    procedure loadProfiles;
    procedure clearData();
    function calculateRollByMultiply(condition: String; multiply: Integer): String;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit11Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

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
        iniFile.WriteString('Betprofil', 'Target', edit3.Text);
        iniFile.WriteString('Betprofil', 'Condition', combobox1.Items[combobox1.ItemIndex]);
        iniFile.WriteInteger('Betprofil', 'Multiply', strtoint(edit11.Text));
        iniFile.WriteBool('Betprofil', 'Inverse', checkbox1.checked);
        iniFile.WriteInteger('Betprofil', 'ZeroBets', strtoint(edit4.Text));
    finally
        iniFile.Free;
    end;
    loadProfiles();
end;

procedure TForm3.ComboBox2Change(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./bets/' + combobox2.Items[combobox2.ItemIndex]);
    try
        edit1.Text := combobox2.Items[combobox2.ItemIndex].Remove(combobox2.Items[combobox2.ItemIndex].IndexOf('.', 4));
        edit2.Text := inttostr(iniFile.ReadInteger('Betprofil', 'Profit', 0));
        edit11.Text := inttostr(iniFile.ReadInteger('Betprofil', 'Multiply', 0));
        combobox1.Text := iniFile.ReadString('Betprofil', 'Condition', '>');
        edit3.Text := iniFile.ReadString('Betprofil', 'Target', '');
        edit4.Text := inttostr(iniFile.ReadInteger('Betprofil', 'ZeroBets', 0));

        checkbox1.checked := iniFile.ReadBool('BetProfil', 'Inverse', false);
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

function TForm3.calculateRollByMultiply(condition: String; multiply: Integer): String;
begin
    if (condition = '>') then
    begin
         result := floatToStr(Math.RoundTo((100 - (99 / multiply) - 0.01), -2)).replace(',', '.');
    end else
        begin
             result := floatToStr(Math.RoundTo(99 / multiply, -2)).replace(',', '.');
        end;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
    loadProfiles();
    clearData();
end;

procedure TForm3.loadProfiles();
var path: String;
begin
    if not DirectoryExists('./bets/') then
           CreateDir('./bets');
    Combobox2.Clear;
    for path in TDirectory.GetFiles('./bets/') do
        Combobox2.Items.Add(path.Remove(0, 7));
end;

procedure TForm3.clearData();
begin
    edit1.Text := '';
    edit2.Text := '';
    edit3.Text := '';
    edit4.Text := '0';
    edit11.Text := '';
    combobox1.Text := '>';
    checkbox1.Checked := false;
end;

end.
