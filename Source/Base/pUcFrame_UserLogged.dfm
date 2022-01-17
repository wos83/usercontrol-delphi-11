object UCFrame_UsersLogged: TUCFrame_UsersLogged
  Left = 0
  Top = 0
  Width = 578
  Height = 240
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  TabStop = True
  object DBGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 578
    Height = 192
    Align = alClient
    DataSource = dsDados
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    PopupMenu = PopupMenu1
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'UserName'
        Title.Alignment = taCenter
        Title.Caption = 'Nome'
        Width = 159
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Login'
        Title.Alignment = taCenter
        Width = 123
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MACHINENAME'
        Title.Alignment = taCenter
        Title.Caption = 'Computador'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATA'
        Title.Alignment = taCenter
        Title.Caption = 'Data'
        Width = 130
        Visible = True
      end>
  end
  object Panel3: TPanel
    Left = 0
    Top = 192
    Width = 578
    Height = 48
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      578
      48)
    object BitMsg: TBitBtn
      Left = 266
      Top = 11
      Width = 145
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Mensagem'
      TabOrder = 0
      OnClick = BitMsgClick
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CD3001F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CD300D300
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C9A19D300D300D3003B32
        D3001F7C1F7CD8520D190D190D190D190D190D1915369A19FE4ABF429D3E5C36
        3B32D3001F7CD8521A5F964A964A964A964A964A964A9A191F53DF46BF429D3E
        5C365B32D300D852964A3B5F3B5F3B5F3B5F3B5F3B5F9A191F531F53BF429D3E
        9D3ED3001F7CD8527C6B964A7D6B7D6B7D6B7D6B7D6B9A199A199A199A19DF46
        D3001F7C1F7CD8529D739D73964ADF7BDF7BDF7BDF7BDF7BDF7BDF7B9A19D300
        964A1F7C1F7CD852DF7BDF7B964A964AFF7FFF7FFF7FFF7F1536964AD3007C6B
        0D191F7C1F7CD852FF7F964AB97F977F964A964A964A964A0D7FEA7E964A964A
        0D191F7C1F7CD852964ADB7FDB7FB97F977F757F537F517F2F7F0D7FEA7E1536
        0D191F7C1F7CD852DB7FDB7FDB7FDB7FB97F977F757F537F517F2F7F0D7FEA7E
        0D191F7C1F7C1F7CD852DB7FDB7FDB7FDB7FB97F977F757F537F517F2F7F4E21
        1F7C1F7C1F7C1F7C1F7CD856DB7FDB7FDB7FDB7FB97F977F757F537F0D191F7C
        1F7C1F7C1F7C1F7C1F7C1F7CD852DB7FDB7FDB7FDB7FB97F977F0D191F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7CD852D852D852D852D852D8521F7C1F7C1F7C
        1F7C1F7C1F7C}
    end
    object BitRefresh: TBitBtn
      Left = 417
      Top = 11
      Width = 145
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Atualizar'
      TabOrder = 1
      OnClick = BitRefreshClick
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        0800000000000001000000000000000000000001000000010000FF00FF000029
        6A00002F790000307B0000317E00003382000035870000399200003A95000040
        A3000041A5000044AF00004BC000004CC200004DC500004FCA000050CD000052
        D1000053D4000054D700065AD1000055D9000056DD000058E100005AE600005B
        E900005CEB00005DEE00005EF0000060F6000669F6000062F9000065FF000268
        FF00056BFF00066CFF00086EFF000A70FF000C72FF000F75FF001070F2001378
        FF001479FF00197DFF001E80FF002880EE002585FF002A88FF00328EFF003590
        FF003D95FF004592ED004596F6004097FF004598FB00469AFF00499DFF0050A0
        FF0056A4FF005AA6FF005CA7FF0066A3E90066A9F50060AAFF0066ACFF0069AF
        FF006CB1FF0072B4FF0074B5FF007FBBFF007FBCFF0088B8EE0081BCFF008AC1
        FF008FC4FF009FCEFF00A3CFFF00ADD5FF00B7DAFF00EAF3FC00EAF4FF00EDF6
        FF00FFFFFF000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000808060402020202020202010000000C1715110C
        0C0C0C0C0C0C0C0A01000015211F1C1B171115111515150F0200001C21211E3E
        5252523D1410150C0400001C27244950342D33504710150C0200001C2E2A5238
        1F1C1C335211150C0200001C372C523138521F283E15150C0400001C3C2F504C
        425252371B1B1B0F0600001C41303F52525252524D1C1B110800001C44322E38
        4E52524B2A1F1F1B0A00001C48392F2E465235271F21211B0B00001C49463F3C
        37312E2A2721271F0C00001C3F494948443C312C2727212110000000242B2B2B
        2A271F1F1F1C1C15000000000000000000000000000000000000}
    end
  end
  object dsDados: TDataSource
    Left = 132
    Top = 144
  end
  object PopupMenu1: TPopupMenu
    Left = 320
    Top = 88
    object miDeleteSelected: TMenuItem
      Caption = 'Excluir selecionado'
      OnClick = miDeleteSelectedClick
    end
    object miDeleteAll: TMenuItem
      Caption = 'Excluir todos'
      OnClick = miDeleteAllClick
    end
  end
end
