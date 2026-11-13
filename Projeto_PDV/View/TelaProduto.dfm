object frmTelaProduto: TfrmTelaProduto
  Left = 0
  Top = 0
  Caption = 'Cadastro de Produtos'
  ClientHeight = 400
  ClientWidth = 600
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
  object pcProduto: TPageControl
    Left = 0
    Top = 0
    Width = 600
    Height = 400
    ActivePage = tsConsulta
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object tsConsulta: TTabSheet
      Caption = 'Consulta'
      object pnlConsulta: TPanel
        Left = 0
        Top = 0
        Width = 592
        Height = 64
        Align = alTop
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 0
        DesignSize = (
          592
          64)
        object lblPesquisa: TLabel
          Left = 16
          Top = 8
          Width = 163
          Height = 21
          Caption = 'Pesquisar por descri'#231#227'o'
        end
        object edtPesquisa: TEdit
          Left = 16
          Top = 29
          Width = 290
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          TextHint = 'digite para filtrar a lista'
          OnChange = edtPesquisaChange
        end
        object btnNovo: TButton
          Left = 322
          Top = 27
          Width = 80
          Height = 27
          Anchors = [akTop, akRight]
          Caption = 'Novo'
          TabOrder = 1
          OnClick = btnNovoClick
        end
        object btnEditar: TButton
          Left = 408
          Top = 27
          Width = 80
          Height = 27
          Anchors = [akTop, akRight]
          Caption = 'Editar'
          TabOrder = 2
          OnClick = btnEditarClick
        end
        object btnExcluir: TButton
          Left = 494
          Top = 27
          Width = 80
          Height = 27
          Anchors = [akTop, akRight]
          Caption = 'Excluir'
          TabOrder = 3
          OnClick = btnExcluirClick
        end
      end
      object lvProdutos: TListView
        AlignWithMargins = True
        Left = 16
        Top = 64
        Width = 560
        Height = 284
        Margins.Left = 16
        Margins.Top = 0
        Margins.Right = 16
        Margins.Bottom = 16
        Align = alClient
        Columns = <
          item
            Caption = 'C'#243'digo'
            Width = 70
          end
          item
            Caption = 'Descri'#231#227'o'
            Width = 280
          end
          item
            Caption = 'Pre'#231'o'
            Width = 100
          end
          item
            Caption = 'Estoque'
            Width = 80
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
        OnDblClick = lvProdutosDblClick
        ExplicitHeight = 290
      end
    end
    object tsCadastro: TTabSheet
      Caption = 'Cadastro'
      ImageIndex = 1
      DesignSize = (
        592
        364)
      object lblDescricao: TLabel
        Left = 16
        Top = 16
        Width = 67
        Height = 21
        Caption = 'Descri'#231#227'o'
      end
      object lblPreco: TLabel
        Left = 16
        Top = 72
        Width = 39
        Height = 21
        Caption = 'Pre'#231'o'
      end
      object lblEstoque: TLabel
        Left = 160
        Top = 72
        Width = 55
        Height = 21
        Caption = 'Estoque'
      end
      object edtDescricao: TEdit
        Left = 16
        Top = 35
        Width = 558
        Height = 29
        Anchors = [akLeft, akTop, akRight]
        MaxLength = 100
        TabOrder = 0
      end
      object edtPreco: TEdit
        Left = 16
        Top = 91
        Width = 120
        Height = 29
        TabOrder = 1
      end
      object edtEstoque: TEdit
        Left = 160
        Top = 91
        Width = 100
        Height = 29
        NumbersOnly = True
        TabOrder = 2
      end
      object btnSalvar: TButton
        Left = 16
        Top = 136
        Width = 90
        Height = 28
        Caption = 'Salvar'
        TabOrder = 3
        OnClick = btnSalvarClick
      end
      object btnCancelar: TButton
        Left = 114
        Top = 136
        Width = 90
        Height = 28
        Caption = 'Cancelar'
        TabOrder = 4
        OnClick = btnCancelarClick
      end
    end
  end
end
