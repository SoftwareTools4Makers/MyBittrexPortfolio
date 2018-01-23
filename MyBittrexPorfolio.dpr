program MyBittrexPorfolio;

uses
  Vcl.Forms,
  MyBittrexWalletMainFormUnit in 'MyBittrexWalletMainFormUnit.pas' {MyBittexPortfolioMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMyBittexPortfolioMainForm, MyBittexPortfolioMainForm);
  Application.Run;
end.
