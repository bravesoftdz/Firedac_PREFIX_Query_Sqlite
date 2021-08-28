object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 138
  Width = 234
  object FdCon_Sqlite: TFDConnection
    Params.Strings = (
      
        'Database=D:\Sydney_2021\VCL Loggin\Basic Demo\PREFIX SELECT\Basi' +
        'cData\BasicData.s3db')
    LoginPrompt = False
    AfterConnect = FdCon_SqliteAfterConnect
    Left = 40
    Top = 16
  end
  object Phys_Sqlite: TFDPhysSQLiteDriverLink
    Left = 128
    Top = 16
  end
  object GUIx_Wait: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrAppWait
    Left = 128
    Top = 72
  end
end
