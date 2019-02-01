object SIncronizador: TSIncronizador
  Left = 0
  Top = 0
  Caption = 'Migrador Empari -> Atron'
  ClientHeight = 408
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 49
    Width = 1008
    Height = 318
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object DBGrid: TDBGrid
      Left = 313
      Top = 1
      Width = 694
      Height = 316
      Align = alClient
      DataSource = dsLocal
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 312
      Height = 316
      Align = alLeft
      Caption = 'Panel3'
      TabOrder = 1
      object Memo: TMemo
        Left = 1
        Top = 1
        Width = 310
        Height = 314
        Align = alClient
        BorderStyle = bsNone
        CharCase = ecUpperCase
        Ctl3D = True
        HideSelection = False
        Lines.Strings = (
          '')
        ParentCtl3D = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 1008
    Height = 49
    Align = alTop
    TabOrder = 1
    object Button2: TButton
      Left = 16
      Top = 10
      Width = 100
      Height = 25
      Caption = 'Produtos'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button4: TButton
      Left = 140
      Top = 10
      Width = 100
      Height = 25
      Caption = 'Clientes'
      TabOrder = 1
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 808
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Reset'
      TabOrder = 2
      Visible = False
    end
    object endereco: TButton
      Left = 704
      Top = 10
      Width = 75
      Height = 25
      Caption = 'test'
      TabOrder = 3
      Visible = False
    end
    object Button1: TButton
      Left = 262
      Top = 10
      Width = 100
      Height = 25
      Caption = 'receber pedido'
      TabOrder = 4
      Visible = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 367
    Width = 1008
    Height = 41
    Align = alBottom
    TabOrder = 2
    object pb: TProgressBar
      Left = 1
      Top = 1
      Width = 1006
      Height = 39
      Align = alClient
      TabOrder = 0
    end
  end
  object dsLocal: TDataSource
    DataSet = dm.qrCommonWeb
    Left = 560
    Top = 192
  end
end
