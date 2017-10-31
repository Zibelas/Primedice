unit UserForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Inifiles, IOUtils;

type
  TForm2 = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Edit3: TEdit;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure loadProfiles();
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./user/' + ChangeFileExt(edit1.Text, '.ini'));
    try
        iniFile.WriteString('User', 'ApiKey', edit2.Text);
        iniFile.WriteString('User', 'Name', edit3.Text);
    finally
        iniFile.Free;
    end;
    loadProfiles();
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
var iniFile: TIniFile;
begin
    iniFile := TIniFile.Create('./user/' + combobox1.Items[combobox1.ItemIndex]);
    try
        edit1.Text := combobox1.Items[combobox1.ItemIndex].Remove(combobox1.Items[combobox1.ItemIndex].IndexOf('.', 4));
        edit2.Text := iniFile.ReadString('User', 'ApiKey', '');
        edit3.Text := iniFile.ReadString('User', 'Name', '');
    finally
        iniFile.Free;
    end;
end;

procedure TForm2.loadProfiles();
var path: String;
begin
    if not DirectoryExists('./user/') then
           CreateDir('./user');
    Combobox1.Clear;
    for path in TDirectory.GetFiles('./user/') do
        Combobox1.Items.Add(path.Remove(0, 7));
end;

procedure TForm2.FormShow(Sender: TObject);
var path: String;
begin
    loadProfiles();
end;

end.
