program MyBittrexPortfolio;

uses
  Vcl.Forms,
  MyBittrexPortfolioMainFormUnit in 'MyBittrexPortfolioMainFormUnit.pas' {MyBittexPortfolioMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMyBittexPortfolioMainForm, MyBittexPortfolioMainForm);
  Application.Run;
end.
