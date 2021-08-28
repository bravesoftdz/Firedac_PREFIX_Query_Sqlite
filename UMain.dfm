object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'FMain'
  ClientHeight = 363
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Tahoma'
  Font.Style = []
  Font.Quality = fqClearTypeNatural
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    564
    363)
  PixelsPerInch = 96
  TextHeight = 21
  object Lbl_SQL: TLabel
    Left = 8
    Top = 8
    Width = 87
    Height = 21
    Caption = 'SQL String  '
  end
  object Lbl_P1: TLabel
    Left = 367
    Top = 8
    Width = 104
    Height = 21
    Caption = 'Param USER: '
  end
  object Lbl_P2: TLabel
    Left = 367
    Top = 85
    Width = 151
    Height = 21
    Caption = 'Param PASSWORD: '
  end
  object DBGrid_TEST: TDBGrid
    Left = 8
    Top = 214
    Width = 548
    Height = 141
    Anchors = [akLeft, akRight, akBottom]
    DataSource = ds_TEST
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -17
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    TitleFont.Quality = fqClearTypeNatural
  end
  object Btn_RUN: TButton
    Left = 443
    Top = 178
    Width = 113
    Height = 30
    Cursor = crHandPoint
    Anchors = [akRight, akBottom]
    Caption = 'Execute SQL'
    TabOrder = 1
    OnClick = Btn_RUNClick
  end
  object Log_Sql: TMemo
    Left = 8
    Top = 35
    Width = 353
    Height = 173
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'SELECT'
      '  USER_.*'
      '  FROM USERS'
      '  WHERE "USER_Pseudo" = :USER AND'
      '  "USER_Password" = :PASSWORD')
    TabOrder = 2
  end
  object Edt_pUSER: TEdit
    Left = 367
    Top = 35
    Width = 189
    Height = 29
    Alignment = taCenter
    TabOrder = 3
    Text = 'User'
  end
  object Edt_pPASSWORD: TEdit
    Left = 367
    Top = 112
    Width = 189
    Height = 29
    Alignment = taCenter
    TabOrder = 4
    Text = 'User'
  end
  object ds_TEST: TDataSource
    Left = 416
    Top = 240
  end
end
