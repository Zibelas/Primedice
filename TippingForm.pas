unit TippingForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Inifiles, IOUtils, Vcl.Samples.Spin,
  Vcl.StdCtrls;

type
  TForm4 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Button1: TButton;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    Edit3: TEdit;
    procedure loadProfiles();
    procedure Button1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./tips/' + ChangeFileExt(edit1.Text, '.ini'));
    try
        iniFile.WriteString('Tipprofil', 'Receiver', edit2.Text);
        iniFile.WriteInteger('Tipprofil', 'Percent', SpinEdit1.Value);
        iniFile.WriteInteger('Tipprofil', 'MinAmount', strtoint(edit3.Text));
    finally
        iniFile.Free;
    end;
    loadProfiles();
end;

procedure TForm4.ComboBox2Change(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./tips/' + combobox2.Items[combobox2.ItemIndex]);
    try
        edit1.Text := combobox2.Items[combobox2.ItemIndex].Remove(combobox2.Items[combobox2.ItemIndex].IndexOf('.', 4));
        edit2.Text := iniFile.ReadString('Tipprofil', 'Receiver', '');
        SpinEdit1.Value := iniFile.ReadInteger('Tipprofil', 'Percent', 0);
        edit3.Text := inttostr(iniFile.ReadInteger('Tipprofil', 'MinAmount', 10000));
    finally
        iniFile.Free;
    end;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
    loadProfiles();
end;

procedure TForm4.loadProfiles();
var path: String;
begin
    if not DirectoryExists('./tips/') then
           CreateDir('./tips');
    Combobox2.Clear;
    for path in TDirectory.GetFiles('./tips/') do
        Combobox2.Items.Add(path.Remove(0, 7));
end;

end.
