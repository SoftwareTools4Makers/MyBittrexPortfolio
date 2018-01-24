object MyBittexPortfolioMainForm: TMyBittexPortfolioMainForm
  Left = 0
  Top = 0
  Caption = 'My Bittrex Wallet'
  ClientHeight = 478
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ActionToolBar1: TActionToolBar
    Left = 0
    Top = 0
    Width = 900
    Height = 23
    ActionManager = ActionManager1
    Caption = 'ActionToolBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Spacing = 0
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 23
    Width = 900
    Height = 455
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Bittrex Portfolio'
      object stgrWallet: TStringGrid
        Left = 0
        Top = 0
        Width = 892
        Height = 427
        Align = alClient
        ColCount = 11
        DefaultColWidth = 80
        DefaultRowHeight = 18
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
        ColWidths = (
          80
          80
          80
          80
          80
          80
          80
          80
          80
          80
          80)
        RowHeights = (
          18
          18
          18
          18
          18)
      end
    end
  end
  object aTimer: TTimer
    Enabled = False
    OnTimer = aTimerTimer
    Left = 520
    Top = 160
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = actRefresh
            Caption = '&Refresh'
          end>
        ActionBar = ActionToolBar1
      end>
    Left = 424
    Top = 160
    StyleName = 'Platform Default'
    object actRefresh: TAction
      Caption = 'Refresh'
      OnExecute = actRefreshExecute
    end
  end
end
