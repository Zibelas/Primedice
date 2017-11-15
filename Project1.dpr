program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UserForm in 'UserForm.pas' {Form2},
  BetProfilForm in 'BetProfilForm.pas' {Form3},
  TippingForm in 'TippingForm.pas' {Form4},
  BasicProfitCalc in 'BasicProfitCalc.pas' {Form6},
  BasicRoundCalc in 'BasicRoundCalc.pas' {Form5},
  StatistikForm in 'StatistikForm.pas' {Form7},
  ReTippingForm in 'ReTippingForm.pas' {Form8},
  SimulationForm in 'SimulationForm.pas' {Form9};

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
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm9, Form9);
  Application.Run;
end.
