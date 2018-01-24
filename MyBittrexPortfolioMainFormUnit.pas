unit MyBittrexPortfolioMainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BittrexAPI, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, System.Actions, Vcl.ActnList,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ComCtrls;

type
  TMyBittexPortfolioMainForm = class(TForm)
    aTimer: TTimer;
    ActionManager1: TActionManager;
    ActionToolBar1: TActionToolBar;
    actRefresh: TAction;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    stgrWallet: TStringGrid;
    procedure aTimerTimer(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
  private
    { Private declarations }
    fBittrexApi: TBittrexAPI;
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
    //procedure RefreshMarket;
  end;

var
  MyBittexPortfolioMainForm: TMyBittexPortfolioMainForm;

implementation

uses
  System.UITypes,
  inifiles;

const
  FEE = 0.25;

{$R *.dfm}
  { TForm3 }

procedure TMyBittexPortfolioMainForm.actRefreshExecute(Sender: TObject);
begin
  aTimerTimer(self);
end;

procedure TMyBittexPortfolioMainForm.aTimerTimer(Sender: TObject);
var
  aBalances: TBalances;
  aOrdersHistory: TOrdersHistory;
  k: integer;
  aRow: integer;
  j: integer;
  aTicker: TTicker;
  aByUnit: double;
  onlybuy: boolean;
begin
  actRefresh.Enabled := false;

  aTimer.Enabled := false;
  aTimer.Interval := 30000;

  stgrWallet.RowCount := 1;
  aRow := 0;

  aBalances := TBalances.Create;
  aOrdersHistory := TOrdersHistory.Create;

  if fBittrexApi.GetBalances(aBalances) and fBittrexApi.GetOrderHistory
    (aOrdersHistory) then
  begin

    for k := 0 to aBalances.Count - 1 do
    begin
      stgrWallet.RowCount := stgrWallet.RowCount + 1;
      stgrWallet.FixedRows := 1;

      inc(aRow);
      stgrWallet.Cells[0, aRow] := aBalances[k].Currency;
      stgrWallet.Cells[1, aRow] := floattostrf(aBalances[k].Available,
        ffFixed, 8, 8);

      aTicker := TTicker.Create;
      if fBittrexApi.GetTicker('BTC-' + aBalances[k].Currency, aTicker) then
      begin
        stgrWallet.Cells[3, aRow] := floattostrf(aTicker.Last, ffFixed, 8, 8);

        begin

          onlybuy := true;

          for j := 0 to aOrdersHistory.Count - 1 do
          begin
            if (aOrdersHistory[j].Exchange = 'BTC-' + aBalances[k].Currency)
            then
            begin

              inc(aRow);
              stgrWallet.RowCount := stgrWallet.RowCount + 1;

              stgrWallet.Cells[2, aRow] :=
                floattostrf(aOrdersHistory[j].Quantity, ffFixed, 8, 8);
              stgrWallet.Cells[3, aRow] :=
                floattostrf(aOrdersHistory[j].PricePerUnit, ffFixed, 8, 8);
              stgrWallet.Cells[4, aRow] := floattostrf(aOrdersHistory[j].Price,
                ffFixed, 8, 8);
              stgrWallet.Cells[5, aRow] :=
                floattostrf(aOrdersHistory[j].Commision, ffFixed, 8, 8);
              stgrWallet.Cells[6, aRow] := floattostrf(aOrdersHistory[j].Cost,
                ffFixed, 8, 8);

              // Only information of the latest order
              if onlybuy and (aOrdersHistory[j].OrderType = 'LIMIT_BUY') then
              // if j = 0 then
              begin
                // Price per unit including commision
                aByUnit := abs(aOrdersHistory[j].Cost / aOrdersHistory[j]
                  .Quantity); // aBalances[k].Available);

                stgrWallet.Cells[7, aRow] :=
                  floattostrf(aByUnit, ffFixed, 8, 8);
                //

                stgrWallet.Cells[8, aRow] :=
                  floattostrf(aTicker.Last, ffFixed, 8, 8);

                // if aTicker.Last < aByUnit then
                // begin
                stgrWallet.Cells[9, aRow] :=
                  floattostrf(((aTicker.Last * 100) / aByUnit) - 100 - FEE,
                  ffFixed, 8, 2) + '%';

                stgrWallet.Cells[10, aRow] :=
                  floattostrf((aTicker.Last * aOrdersHistory[j].Quantity *
                  1.0025) + aOrdersHistory[j].Cost, ffFixed, 8, 8);

              end
              else
                onlybuy := false;

            end;
          end;
        end;

      end;

      aTicker.Free;

    end;
  end;

  aOrdersHistory.Free;
  aBalances.Free;

  // RefreshMarket;

  // aTimer.Enabled := true;
  actRefresh.Enabled := true;
end;

constructor TMyBittexPortfolioMainForm.Create(Owner: TComponent);
var
  aINIFile: TIniFile;
  aConfigurationFile: string;
begin
  inherited;

  stgrWallet.Cells[1, 0] := 'Quantity';
  stgrWallet.Cells[2, 0] := 'Quantity per op';
  stgrWallet.Cells[3, 0] := 'Price per unit';
  stgrWallet.Cells[4, 0] := 'Price total';
  stgrWallet.Cells[5, 0] := 'Commision';
  stgrWallet.Cells[6, 0] := 'Cost';
  stgrWallet.Cells[7, 0] := 'PPU+Com';
  stgrWallet.Cells[8, 0] := 'Last price';
  stgrWallet.Cells[9, 0] := 'Profit-Fee';
  stgrWallet.Cells[10, 0] := 'Satoshis';

  fBittrexApi := TBittrexAPI.Create(self);

  aConfigurationFile := ChangeFileExt(Application.ExeName, '.ini');

  if not FileExists(aConfigurationFile) then
  begin
    MessageDlg
      (format('Creating configuration file, please open it and configure at %s',
      [aConfigurationFile]), mtWarning, [mbOk], 0);

    aINIFile := TIniFile.Create(aConfigurationFile);
    aINIFile.WriteString('CONFIG', 'apikey', '');
    aINIFile.WriteString('CONFIG', 'secret', '');

    Application.Terminate;
  end
  else
  begin
    aINIFile := TIniFile.Create(aConfigurationFile);

    fBittrexApi.apikey := aINIFile.ReadString('CONFIG', 'apikey', '');
    fBittrexApi.secret := aINIFile.ReadString('CONFIG', 'secret', '');

    if (fBittrexApi.apikey = '') or (fBittrexApi.secret = '') then
    begin
      MessageDlg(format('Please, configure %s file', [aConfigurationFile]),
        mtWarning, [mbOk], 0);
      Application.Terminate;
    end
    else
    begin
      aTimer.Enabled := true;
    end;

  end;
end;

{*
procedure TMyBittexPortfolioMainForm.RefreshMarket;
var
  aMarkets: TMarkets;
  aTicker: TTicker;
  k: integer;
begin
  aMarkets := TMarkets.Create;

  if fBittrexApi.GetMarkets(aMarkets) then
  begin
    strgCoins.RowCount := aMarkets.Count;

    for k := 0 to aMarkets.Count - 1 do
    begin
      strgCoins.Cells[0, k + 1] := aMarkets[k].MarketCurrency;

      aTicker := TTicker.Create;

      if aMarkets[k].IsActive then
      begin
        if fBittrexApi.GetTicker('BTC-' + aMarkets[k].MarketCurrency, aTicker)
        then
        begin
          strgCoins.Cells[1, k + 1] := floattostrf(aTicker.Bid, ffFixed, 8, 8);
          strgCoins.Cells[2, k + 1] := floattostrf(aTicker.Ask, ffFixed, 8, 8);

          strgCoins.Cells[3, k + 1] :=
            floattostrf(100 - ((aTicker.Bid * 100) / aTicker.Ask), ffFixed,
            8, 2) + '%';

        end;
        aTicker.Free;
      end;

    end;
  end;

  aMarkets.Free;
end;
  *}
end.
