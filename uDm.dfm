object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 217
  Width = 348
  object connWeb_OLD: TFDConnection
    Params.Strings = (
      'ConnectionDef=empari')
    LoginPrompt = False
    Left = 68
    Top = 25
  end
  object connLocal: TFDConnection
    Params.Strings = (
      'Database=C:\Atron\GESTOR\BD\BASE.FDB'
      'DriverID=FB'
      'Password=masterkey'
      'Server=localhost'
      'User_Name=sysdba')
    LoginPrompt = False
    Left = 149
    Top = 24
  end
  object qrCommonWeb: TFDQuery
    Connection = connWeb_OLD
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'select TOP 1 * FROM [hlpdados].[dbo].[prodfornec]')
    Left = 72
    Top = 88
  end
  object qrCommonLoc: TFDQuery
    Connection = connLocal
    FetchOptions.AssignedValues = [evRowsetSize, evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'select * from L000003')
    Left = 152
    Top = 88
  end
  object qrAuxLoc: TFDQuery
    Connection = connLocal
    FetchOptions.AssignedValues = [evRowsetSize, evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      
        'select sum(pit.total) as total, sum(pit.desconto) as desconto  f' +
        'rom c000075 pit group by pit.codnota')
    Left = 144
    Top = 152
  end
  object connWeb: TFDConnection
    Params.Strings = (
      'MARS=Yes'
      'Password=1'
      'LoginTimeout=1000'
      'MetaDefCatalog=dbo'
      'MetaDefSchema=dbo')
    LoginPrompt = False
    Left = 253
    Top = 21
  end
end
