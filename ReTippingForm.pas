unit ReTippingForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Inifiles, IOUtils, Vcl.StdCtrls;

type
  TForm8 = class(TForm)
    ComboBox2: TComboBox;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure loadProfiles();
    procedure ComboBox2Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8: TForm8;

implementation

{$R *.dfm}

procedure TForm8.Button1Click(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./retips/' + ChangeFileExt(edit1.Text, '.ini'));
    try
        iniFile.WriteString('ReTipprofil', 'ApiKey', edit2.Text);
        iniFile.WriteInteger('ReTipprofil', 'Amount', strtoint(edit3.Text));
    finally
        iniFile.Free;
    end;
    loadProfiles();
end;

procedure TForm8.ComboBox2Change(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./retips/' + combobox2.Items[combobox2.ItemIndex]);
    try
        edit1.Text := combobox2.Items[combobox2.ItemIndex].Remove(combobox2.Items[combobox2.ItemIndex].IndexOf('.', 4));
        edit2.Text := iniFile.ReadString('ReTipprofil', 'ApiKey', '');
        edit3.Text := inttostr(iniFile.ReadInteger('ReTipprofil', 'Amount', 10000));
    finally
        iniFile.Free;
    end;
end;

procedure TForm8.FormShow(Sender: TObject);
begin
    loadProfiles();
end;

procedure TForm8.loadProfiles();
var path: String;
begin
    if not DirectoryExists('./retips/') then
           CreateDir('./retips');
    Combobox2.Clear;
    for path in TDirectory.GetFiles('./retips/') do
        Combobox2.Items.Add(path.Remove(0, 7));
end;

end.
