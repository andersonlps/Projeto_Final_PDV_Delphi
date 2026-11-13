object frmTelaVenda: TfrmTelaVenda
  Left = 0
  Top = 0
  Caption = 'Vendas'
  ClientHeight = 520
  ClientWidth = 760
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pcVenda: TPageControl
    Left = 0
    Top = 0
    Width = 760
    Height = 520
    ActivePage = tsNovaVenda
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = pcVendaChange
    object tsConsulta: TTabSheet
      Caption = 'Consulta'
      object pnlConsulta: TPanel
        Left = 0
        Top = 0
        Width = 752
        Height = 56
        Align = alTop
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 0
        object btnNovaVenda: TButton
          Left = 16
          Top = 14
          Width = 120
          Height = 28
          Caption = 'Nova venda'
          TabOrder = 0
          OnClick = btnNovaVendaClick
        end
        object btnCancelarVenda: TButton
          Left = 144
          Top = 14
          Width = 140
          Height = 28
          Caption = 'Cancelar venda'
          TabOrder = 1
          OnClick = btnCancelarVendaClick
        end
      end
      object gbItensVenda: TGroupBox
        AlignWithMargins = True
        Left = 16
        Top = 276
        Width = 720
        Height = 192
        Margins.Left = 16
        Margins.Top = 0
        Margins.Right = 16
        Margins.Bottom = 16
        Align = alBottom
        Caption = 'Itens da venda selecionada'
        TabOrder = 2
        ExplicitTop = 282
        object lvItensVenda: TListView
          AlignWithMargins = True
          Left = 10
          Top = 23
          Width = 700
          Height = 159
          Margins.Left = 8
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alClient
          Columns = <
            item
              Caption = 'Produto'
              Width = 350
            end
            item
              Caption = 'Qtd'
              Width = 70
            end
            item
              Caption = 'Pre'#231'o unit.'
              Width = 120
            end
            item
              Caption = 'Subtotal'
              Width = 120
            end>
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          ExplicitTop = 17
          ExplicitHeight = 165
        end
      end
      object lvVendas: TListView
        AlignWithMargins = True
        Left = 16
        Top = 56
        Width = 720
        Height = 212
        Margins.Left = 16
        Margins.Top = 0
        Margins.Right = 16
        Margins.Bottom = 8
        Align = alClient
        Columns = <
          item
            Caption = 'N'#186
            Width = 60
          end
          item
            Caption = 'Data'
            Width = 130
          end
          item
            Caption = 'Cliente'
            Width = 250
          end
          item
            Caption = 'Pagamento'
            Width = 130
          end
          item
            Caption = 'Total'
            Width = 110
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
        OnSelectItem = lvVendasSelectItem
        ExplicitHeight = 218
      end
    end
    object tsNovaVenda: TTabSheet
      Caption = 'Nova venda'
      ImageIndex = 1
      object pnlCabecalho: TPanel
        Left = 0
        Top = 0
        Width = 752
        Height = 76
        Align = alTop
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 0
        DesignSize = (
          752
          76)
        object lblCliente: TLabel
          Left = 16
          Top = 8
          Width = 48
          Height = 21
          Caption = 'Cliente'
        end
        object lblPagamento: TLabel
          Left = 462
          Top = 8
          Width = 149
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'Forma de pagamento'
        end
        object cmbCliente: TComboBox
          Left = 16
          Top = 27
          Width = 430
          Height = 29
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
        object cmbPagamento: TComboBox
          Left = 462
          Top = 27
          Width = 270
          Height = 29
          Style = csDropDownList
          Anchors = [akTop, akRight]
          TabOrder = 1
        end
      end
      object pnlItem: TPanel
        Left = 0
        Top = 76
        Width = 752
        Height = 92
        Align = alTop
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 1
        DesignSize = (
          752
          92)
        object lblProduto: TLabel
          Left = 16
          Top = 8
          Width = 56
          Height = 21
          Caption = 'Produto'
        end
        object lblQuantidade: TLabel
          Left = 462
          Top = 8
          Width = 81
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'Quantidade'
        end
        object lblInfoProduto: TLabel
          Left = 16
          Top = 62
          Width = 4
          Height = 21
        end
        object cmbProduto: TComboBox
          Left = 16
          Top = 27
          Width = 430
          Height = 29
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnChange = cmbProdutoChange
        end
        object edtQuantidade: TEdit
          Left = 462
          Top = 27
          Width = 80
          Height = 29
          Anchors = [akTop, akRight]
          NumbersOnly = True
          TabOrder = 1
          Text = '1'
        end
        object btnAdicionarItem: TButton
          Left = 552
          Top = 25
          Width = 90
          Height = 27
          Anchors = [akTop, akRight]
          Caption = 'Adicionar'
          TabOrder = 2
          OnClick = btnAdicionarItemClick
        end
        object btnRemoverItem: TButton
          Left = 648
          Top = 25
          Width = 90
          Height = 27
          Anchors = [akTop, akRight]
          Caption = 'Remover'
          TabOrder = 3
          OnClick = btnRemoverItemClick
        end
      end
      object pnlRodapeVenda: TPanel
        Left = 0
        Top = 420
        Width = 752
        Height = 64
        Align = alBottom
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 3
        ExplicitTop = 426
        DesignSize = (
          752
          64)
        object lblTotal: TLabel
          Left = 16
          Top = 18
          Width = 119
          Height = 25
          Caption = 'Total: R$ 0,00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object btnFecharVenda: TButton
          Left = 480
          Top = 14
          Width = 140
          Height = 34
          Anchors = [akTop, akRight]
          Caption = 'Fechar venda'
          TabOrder = 0
          OnClick = btnFecharVendaClick
        end
        object btnDescartar: TButton
          Left = 632
          Top = 14
          Width = 100
          Height = 34
          Anchors = [akTop, akRight]
          Caption = 'Cancelar'
          TabOrder = 1
          OnClick = btnDescartarClick
        end
      end
      object lvItens: TListView
        AlignWithMargins = True
        Left = 16
        Top = 168
        Width = 720
        Height = 252
        Margins.Left = 16
        Margins.Top = 0
        Margins.Right = 16
        Margins.Bottom = 0
        Align = alClient
        Columns = <
          item
            Caption = 'Produto'
            Width = 380
          end
          item
            Caption = 'Qtd'
            Width = 70
          end
          item
            Caption = 'Pre'#231'o unit.'
            Width = 120
          end
          item
            Caption = 'Subtotal'
            Width = 120
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 2
        ViewStyle = vsReport
        ExplicitHeight = 258
      end
    end
  end
end
