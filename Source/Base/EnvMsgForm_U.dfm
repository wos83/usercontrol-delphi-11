object EnvMsgForm: TEnvMsgForm
  Left = 304
  Top = 204
  BorderStyle = bsDialog
  Caption = 'Mensagem'
  ClientHeight = 364
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 377
    Height = 35
    Align = alTop
    BevelOuter = bvLowered
    Color = clWhite
    TabOrder = 0
    object lbTitulo: TLabel
      Left = 48
      Top = 10
      Width = 205
      Height = 18
      Caption = 'Enviar Nova Mensagem'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Image1: TImage
      Left = 8
      Top = 4
      Width = 28
      Height = 28
      AutoSize = True
      Picture.Data = {
        07544269746D6170760C0000424D760C00000000000036000000280000001C00
        00001C0000000100200000000000400C00000000000000000000000000000000
        0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C7B2A300694731006947
        3100694731006947310069473100694731006947310069473100694731006947
        3100694731006947310069473100694731006947310069473100694731006947
        310069473100694731006947310069473100694731006947310069473100FFFF
        FF00FFFFFF00C7B2A300DBC9BF00B7A29300B7A29300B7A29300B7A29300B7A2
        9300B7A29300B7A29300B7A29300B7A29300B7A29300B7A29300B7A29300B7A2
        9300B7A29300B7A29300B7A29300B7A29300B7A29300B7A29300B7A29300B7A2
        9300B7A29300B7A2930069473100FFFFFF00FFFFFF00C7B2A300B7A29300DFD0
        C700DFD0C700DFD0C700DFD0C700DFD0C700DFD0C700DFD0C700DFD0C700DFD0
        C700DFD0C700DFD0C700DFD0C700DFD0C700DFD0C700DFD0C700DFD0C700DFD0
        C700DFD0C700DFD0C700DFD0C700DFD0C700DFD0C700CE99970069473100FFFF
        FF00FFFFFF00C7B2A300DBC9BF00B7A29300E4D7CF00E4D7CF00E4D7CF00E4D7
        CF00E4D7CF00E4D7CF00E4D7CF00E4D7CF00E4D7CF00E4D7CF00E4D7CF00E4D7
        CF00E4D7CF00E4D7CF00E4D7CF00E4D7CF00E4D7CF00E4D7CF00E4D7CF00E4D7
        CF00B7A29300B7A2930069473100FFFFFF00FFFFFF00C7B2A300DECEC500DECE
        C500B7A29300E9DED700E9DED700E9DED700E9DED700E9DED700E9DED700E9DE
        D700E9DED700E9DED700E9DED700E9DED700E9DED700E9DED700E9DED700E9DE
        D700E9DED700E9DED700E9DED700B7A29300DECEC500B7A2930069473100FFFF
        FF00FFFFFF00C7B2A300E2D4CC00E2D4CC00E2D4CC00B7A29300EDE4DF00EDE4
        DF00EDE4DF00EDE4DF00EDE4DF00EDE4DF00EDE4DF00EDE4DF00EDE4DF00EDE4
        DF00EDE4DF00EDE4DF00EDE4DF00EDE4DF00EDE4DF00EDE4DF00B7A29300E2D4
        CC00E2D4CC00B7A2930069473100FFFFFF00FFFFFF00C7B2A300E6D9D200E6D9
        D200E6D9D200E6D9D200B7A29300F0E9E500F0E9E500F0E9E500F0E9E500F0E9
        E500F0E9E500F0E9E500F0E9E500F0E9E500F0E9E500F0E9E500F0E9E500F0E9
        E500F0E9E500B7A29300E6D9D200E6D9D200E6D9D200B7A2930069473100FFFF
        FF00FFFFFF00C7B2A300EADFD900EADFD900EADFD900EADFD900EADFD900B7A2
        9300F4EFEC00F4EFEC00F4EFEC00F4EFEC00F4EFEC00F4EFEC00F4EFEC00F4EF
        EC00F4EFEC00F4EFEC00F4EFEC00F4EFEC00B7A29300EADFD900EADFD900EADF
        D900EADFD900B7A2930069473100FFFFFF00FFFFFF00C7B2A300EDE4DF00EDE4
        DF00EDE4DF00EDE4DF00EDE4DF00EDE4DF00B7A29300F8F4F200F8F4F200F8F4
        F200F8F4F200F8F4F200F8F4F200F8F4F200F8F4F200F8F4F200F8F4F200B7A2
        9300EDE4DF00EDE4DF00EDE4DF00EDE4DF00EDE4DF00B7A2930069473100FFFF
        FF00FFFFFF00C7B2A300F0E8E400F0E8E400F0E8E400F0E8E400F0E8E400F0E8
        E400B7A29300B7A29300FCFAF900FCFAF900FCFAF900FCFAF900FCFAF900FCFA
        F900FCFAF900FCFAF900B7A29300B7A29300F0E8E400F0E8E400F0E8E400F0E8
        E400F0E8E400B7A2930069473100FFFFFF00FFFFFF00C7B2A300F3EDE900F3ED
        E900F3EDE900F3EDE900F3EDE900B7A29300DDC5C200DDC5C200B7A29300DDC5
        C200FFFFFF00FFFFFF00FFFFFF00FFFFFF00DDC5C200B7A29300DDC5C200DDC5
        C200B7A29300F3EDE900F3EDE900F3EDE900F3EDE900B7A2930069473100FFFF
        FF00FFFFFF00C7B2A300F6F1EF00F6F1EF00F6F1EF00F6F1EF00B7A29300DDC5
        C200FBF9F700F7F4F100DDC5C200C7B2A300B7A29300B7A29300B7A29300B7A2
        9300C7B2A300DDC5C200DCCBC100DBC9BF00DDC5C200B7A29300F6F1EF00F6F1
        EF00F6F1EF00B7A2930069473100FFFFFF00FFFFFF00C7B2A300F9F6F400F9F6
        F400F9F6F400B7A29300DDC5C200FFFFFF00FEFDFC00FBF9F700F7F4F100EEE0
        E000EEE0E000EEE0E000EEE0E000EEE0E000EEE0E000E4D7CF00E1D2C900DECD
        C400DBC9BF00DDC5C200B7A29300F9F6F400F9F6F400B7A2930069473100FFFF
        FF00FFFFFF00C7B2A300FCFBFA00FCFBFA00B7A29300C8B3A400FFFFFF00FFFF
        FF00B7A29300B7A29300B7A29300B7A29300B7A29300B7A29300B7A29300B7A2
        9300B7A29300B7A29300B7A29300B7A29300DECDC400DBC9BF00D2C0B300B7A2
        9300FCFBFA00B7A2930069473100FFFFFF00FFFFFF00C7B2A300FFFFFF00B8A3
        9400DDC5C200C8B3A400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FCFB
        F900F9F6F400F6F2EF00F3EDE900F0E8E400EDE4DF00EAE0D900E7DBD400E4D7
        CF00E1D2C900DECDC400D2BFB200DDC5C200B7A29300FFFFFF0069473100FFFF
        FF00FFFFFF00C7B2A300B7A29300DDC5C20027A5E900C8B3A400FFFFFF00FFFF
        FF00B7A29300B7A29300B7A29300B7A29300B7A29300B7A29300B7A29300B7A2
        9300B7A29300B7A29300B7A29300B7A29300E4D7CF00E1D2C900D1BEB10027A5
        E900DDC5C200B7A2930069473100FFFFFF00FFFFFF00C7B2A300DDC5C20027A5
        E90027A5E900C8B3A400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FCFBF900F9F6F400F6F2EF00F3EDE900F0E8E400EDE4DF00EAE0
        D900E7DBD400E4D7CF00D1BEB10027A5E90027A5E900B7A2930069473100FFFF
        FF00FFFFFF00FFFFFF00C7B2A300DDC5C20047B6FF00C8B3A400FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FCFBF900F9F6
        F400F6F2EF00F3EDE900F0E8E400EDE4DF00EAE0D900E7DBD400D0BDB00047B6
        FF00B7A2930069473100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C7B2
        A300DDC5C200C8B3A400C8B3A400C8B3A400C8B3A400C8B3A400C8B3A400C9B4
        A500C9B5A600CAB6A700CBB6A800CBB7A900CCB8AA00CCB9AB00CDB9AB00CEBA
        AC00CEBBAD00CFBBAE00CFBCAF00BCA7980069473100FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C7B2A300DDC5C200DBF3FA00DBF3
        FA00DBF3FA00D4F0FA00C7EBFB00B9E5FB00ACDFFB009ED9FC0091D4FC0082CE
        FD0073C8FD0064C2FE0055BCFE0047B6FF0047B6FF0047B6FF00BBA697007353
        3E00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00C7B2A300EEE0E000DBF3FA00DBF3FA00DBF3FA00D4F0FA00C7EB
        FB00B9E5FB00B2E2FB00A5DCFC0097D6FC0089D1FC007BCBFD006CC5FD005DBF
        FE004EB9FE00B7A2930069473100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C7B2A300EEE0
        E000DBF3FA00DBF3FA00DBF3FA00DBF3FA00CDEDFA00C0E8FB00B2E2FB00A5DC
        FC0097D6FC0089D1FC007BCBFD006CC5FD00B7A2930069473100FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00C7B2A300EEE0E000DBF3FA00DBF3FA00DBF3
        FA00DBF3FA00CDEDFA00C0E8FB00B2E2FB00A5DCFC0097D6FC0089D1FC00B7A2
        930069473100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00C7B2A300EEE0E000DBF3FA00DBF3FA00DBF3FA00DBF3FA00CDEDFA00C0E8
        FB00B2E2FB00A5DCFC00B7A2930069473100FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C7B2A300EEE0E000EEE0
        E000EEE0E000EEE0E000EEE0E000EEE0E000DDC5C200B7A2930069473100FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00C7B2A300C7B2A300C7B2A300C7B2A300C7B2A300C7B2
        A300C7B2A300C7B2A300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00}
    end
  end
  object gbPara: TGroupBox
    Left = 8
    Top = 40
    Width = 361
    Height = 81
    Caption = 'Para'
    TabOrder = 1
    object rbUsuario: TRadioButton
      Left = 40
      Top = 24
      Width = 80
      Height = 17
      Caption = 'Usu'#225'rio :'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbUsuarioClick
    end
    object rbTodos: TRadioButton
      Left = 40
      Top = 56
      Width = 113
      Height = 17
      Caption = 'Todos'
      TabOrder = 1
      OnClick = rbUsuarioClick
    end
    object dbUsuario: TDBLookupComboBox
      Left = 120
      Top = 18
      Width = 217
      Height = 21
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      KeyField = 'IdUser'
      ListField = 'Nome'
      ListSource = DataSource1
      TabOrder = 2
      OnCloseUp = dbUsuarioCloseUp
    end
  end
  object gbMensagem: TGroupBox
    Left = 8
    Top = 128
    Width = 361
    Height = 201
    Caption = 'Mensagem'
    TabOrder = 2
    object lbAssunto: TLabel
      Left = 24
      Top = 24
      Width = 38
      Height = 13
      Caption = 'Assunto'
    end
    object lbMensagem: TLabel
      Left = 24
      Top = 72
      Width = 52
      Height = 13
      Caption = 'Mensagem'
    end
    object EditAssunto: TEdit
      Left = 24
      Top = 40
      Width = 313
      Height = 21
      MaxLength = 50
      TabOrder = 0
    end
    object MemoMsg: TMemo
      Left = 24
      Top = 88
      Width = 313
      Height = 97
      MaxLength = 255
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object btEnvia: TBitBtn
    Left = 110
    Top = 335
    Width = 79
    Height = 25
    Caption = '&Enviar'
    TabOrder = 3
    OnClick = btEnviaClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FF00FFA47874
      A47874A47874A47874A47874A47874A47874A47874A47874A47874A47874A478
      74A47874A47874FF00FFA47874C6978DEDC3A5FFDBADFED8ABFFD8ACFFD8ACFF
      D8ACFFD8ACFFD8ACFFD8ACFFD8ABFFDDAEEBBFA3C4948EA47874A47874DFB49C
      C69791F4D9BEF7DDC0F5DABFF5DBBFF5DBBFF5DBBFF5DBBFF5DABFF7DDC0F0D1
      B9C59590E1BBA5A47874A47874F4DDC6D2A494CFA9A4F3E6D5F1E1D1F1E1D1F1
      E1D1F1E1D1F1E1D1F1E1D1F3E5D4CCA39ED0A79BF3E1CFA47874A47874EFE4DB
      F2DBC3C2938AE0CDC6F3EDE2F2E9E0F2E9E0F2E9E0F2E9E0F5EFE4DBC0BAC496
      8FF3E4D3EFE4DBA47874A47874F3EAE5FAF6EDEAC8B2BF938DEDDFDAF5EBE4F3
      E9E2F3E9E2F4EAE3EAD6D1C3938FE9D2C5F9F7EFF4EAE4A47874A47874F9F5F2
      FBFAF6D5AFA9C0918DA47874A47874A47874A47874A47874A47874C08F8CE0C6
      C1FFFFFEF8F3F1A47874A47874EDD9D8C79D9BC9A3A2F2EDEDF4F4F4EDE9EAEC
      EAEBEAEAEAE9EEEFEEF9F9DFD9D8C29897CCA5A4F1E4E4A47874A47874C09796
      DBC2C1FFFFFFFCFFFFFAFFFFF7FFFFF5FFFFF2FFFFF0FFFFEFFFFFF0FFFFECF8
      F8D0B6B5C59A97A47874A47874B6E3E6FFFFFFFDFFFFFBFFFFFBFFFFFBFFFFF9
      FFFFF9FFFFF4FEFDF0FAFAE8F7F7DFF1F2D2F1F5BDCACEA47874FF00FFA47874
      FFFFFFFFFFFFFFFFFFF4F9FAE8F1F2D5E9EBB9D8DCA9CFD69CC8D393C2D288C0
      D78BB5CDA47874FF00FFFF00FFFF00FFA47874BAE1E6A2FDFF95E6EF8CDEE886
      E1EA84E3EE86E1F287E1F586E3FD9EC9DDA47874FF00FFFF00FFFF00FFFF00FF
      FF00FFA47874A8C7CC8AF4FD88F9FF8CF5FF8CF6FF89F9FF8FECFBB0BCC6A478
      74FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA47874A478749AE1E78C
      F4FB8DF3FA9BE0E7A47874A47874FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFA47874A47874A47874A47874FF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
  end
  object btCancela: TBitBtn
    Left = 188
    Top = 335
    Width = 79
    Height = 25
    Cancel = True
    Caption = 'Cancelar'
    TabOrder = 4
    OnClick = btCancelaClick
    Glyph.Data = {
      66030000424D6603000000000000660200002800000010000000100000000100
      08000000000000010000120B0000120B00008C0000008C00000000000000FFFF
      FF00FF00FF00F8F7F800F2EFED00E6E2DF00FAF7F300FAFBF800D2F1FF00FCFE
      FF0060C4FE00B7E4FD00BAE6FF005BC0FD00EEF8FE0042AEF70075C6FA0097D2
      FB0099D4FB00FAFDFF0032A0F40034A1F40041ABF7004BADF50050B0F7004FAE
      F60054B4F8008FCDFB00D8EDFC00F3FAFF002293F1002593EF002694F1002897
      F2002E9AF2003199F100339EF30090CBFA00A0D1F900A4D4FA00B2DAFA00D7EC
      FD00D6EBFC00D8ECFD00E2ECF4001487EE00188AEE00218FEF002790EF002992
      EF002C91EE0077B8F5009ACBF8009ECEF800ABD4F900D4E9FC00D5EAFC00ECF5
      FD00EEF6FD00EAF2F9000073E8000677EA000677E9000877E9000976E6000A66
      C4000D7FEB00107CE9001182ED000C58A6001362B300156AC0001B81E9001978
      DA001F84EB002084EB001F84E7001F84E6002283E600288DED006DB2F700609D
      DA0079B8F50079B6F4007EB9F50080BAF3008AC0F7008CC1F7008FC3F70076A0
      CB007098C1008ABBEC007DA8D40093C5F80090C2F40079A3CD009FCBF600B2D6
      FA0098B2CB00CFE5FB00D3E8FC00D2E7FB00D5E9FC00DAE3EC00F0F7FE00FDFE
      FF00006EE8000070E8000072E800006DE700006EE700006FE7000070E7000054
      AE000474E8000572E800055DB8000876E900065CB7000A76E6000B76E6000A66
      C5002183EB004094ED00509FF1004F9CEF00578CC400629EDC0073B2F30075B3
      F30077B4F300C7DDF400C5DBF200D2E6FB00D1E5FA00EDF5FE00006AE700EFF6
      FE00FAFCFF00FEFEFF0002020202024545454545450202020202020202797949
      515C5F7E467145020202020279785E032C838467055A76450202024177610180
      7A3E3D7A82066274450202795D8B7B73706B6F6C6A7C075945024D4E8A817289
      603C4363636E540447454D523A4F426501606301606F4A3B7F454D34382F2D30
      370101603C6B3F865B454D2629221E23660101603C6B3F8558454D256817152B
      01363701606D4B8750454D190911161D28203164638855134845024D0B8B100F
      14212E44757D69577902024D0D08011218241F3253016140790202024D0A0C01
      0E1C2A390156787902020202024D4D1A1B2735334C797902020202020202024D
      4D4D4D4D4D0202020202}
  end
  object DataSource1: TDataSource
    Left = 145
    Top = 96
  end
end
