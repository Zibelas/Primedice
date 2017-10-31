program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UserForm in 'UserForm.pas' {Form2},
  BetProfilForm in 'BetProfilForm.pas' {Form3},
  TippingForm in 'TippingForm.pas' {Form4},
  BasicProfitCalc in 'BasicProfitCalc.pas' {Form6},
  BasicRoundCalc in 'BasicRoundCalc.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
