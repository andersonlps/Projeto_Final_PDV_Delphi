unit TelaProduto;

// VIEW: tela de produtos com as abas Consulta e Cadastro.
// A tela NAO tem SQL: ela so conhece o Controller.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Generics.Collections,
  Model.Produto, Controller.Produto;

type
  TfrmTelaProduto = class(TForm)
    pcProduto: TPageControl;
    tsConsulta: TTabSheet;
    tsCadastro: TTabSheet;
    // --- aba Consulta ---
    pnlConsulta: TPanel;
    lblPesquisa: TLabel;
    edtPesquisa: TEdit;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    lvProdutos: TListView;
    // --- aba Cadastro ---
    lblDescricao: TLabel;
    lblPreco: TLabel;
    lblEstoque: TLabel;
    edtDescricao: TEdit;
    edtPreco: TEdit;
    edtEstoque: TEdit;
    btnSalvar: TButton;
    btnCancelar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtPesquisaChange(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure lvProdutosDblClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FController: TProdutoController;
    FProdutos: TObjectList<TProdutoModel>; // produtos mostrados na lista
    FId: Integer;                          // 0 = novo; > 0 = editando

    procedure CarregarProdutos;
    procedure LimparCampos;
    procedure PreencherCampos(produto: TProdutoModel);
    procedure EditarSelecionado;
    function ProdutoSelecionado: TProdutoModel;
  end;

implementation

{$R *.dfm}

uses
  Factory.Produto;

procedure TfrmTelaProduto.FormCreate(Sender: TObject);
begin
  FController := TProdutoFactory.CriarController;
  pcProduto.ActivePage := tsConsulta;
  LimparCampos;
  CarregarProdutos;
end;

procedure TfrmTelaProduto.FormDestroy(Sender: TObject);
begin
  FProdutos.Free;
  FController.Free;
end;

procedure TfrmTelaProduto.CarregarProdutos;
begin
  lvProdutos.Items.BeginUpdate;
  try
    lvProdutos.Items.Clear;
    FreeAndNil(FProdutos);

    try
      FProdutos := FController.ObterProdutos(edtPesquisa.Text);
    except
      on E: Exception do
      begin
        ShowMessage('Erro: ' + E.Message);
        Exit;
      end;
    end;

    for var produto in FProdutos do
    begin
      var item := lvProdutos.Items.Add;
      item.Caption := IntToStr(produto.Id);
      item.SubItems.Add(produto.Descricao);
      item.SubItems.Add(FormatFloat('#,##0.00', produto.Preco));
      item.SubItems.Add(IntToStr(produto.Estoque));
      item.Data := produto; // guarda o objeto na linha da lista
    end;
  finally
    lvProdutos.Items.EndUpdate;
  end;
end;

function TfrmTelaProduto.ProdutoSelecionado: TProdutoModel;
begin
  if (lvProdutos.Selected <> nil) and Assigned(lvProdutos.Selected.Data) then
    Result := TProdutoModel(lvProdutos.Selected.Data)
  else
    Result := nil;
end;

procedure TfrmTelaProduto.LimparCampos;
begin
  FId := 0;
  edtDescricao.Clear;
  edtPreco.Clear;
  edtEstoque.Clear;
end;

procedure TfrmTelaProduto.PreencherCampos(produto: TProdutoModel);
begin
  FId := produto.Id;
  edtDescricao.Text := produto.Descricao;
  edtPreco.Text := FormatFloat('0.00', produto.Preco);
  edtEstoque.Text := IntToStr(produto.Estoque);
end;

procedure TfrmTelaProduto.EditarSelecionado;
begin
  var produto := ProdutoSelecionado;
  if produto = nil then
  begin
    ShowMessage('Selecione um produto na lista.');
    Exit;
  end;

  PreencherCampos(produto);
  pcProduto.ActivePage := tsCadastro;
  edtDescricao.SetFocus;
end;

procedure TfrmTelaProduto.edtPesquisaChange(Sender: TObject);
begin
  CarregarProdutos;
end;

procedure TfrmTelaProduto.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
  pcProduto.ActivePage := tsCadastro;
  edtDescricao.SetFocus;
end;

procedure TfrmTelaProduto.btnEditarClick(Sender: TObject);
begin
  EditarSelecionado;
end;

procedure TfrmTelaProduto.lvProdutosDblClick(Sender: TObject);
begin
  EditarSelecionado; // duplo clique na linha = Editar
end;

procedure TfrmTelaProduto.btnSalvarClick(Sender: TObject);
var
  preco: Currency;
  estoque: Integer;
begin
  if not TryStrToCurr(edtPreco.Text, preco) then
  begin
    ShowMessage('Informe um preço válido.');
    edtPreco.SetFocus;
    Exit;
  end;

  if not TryStrToInt(edtEstoque.Text, estoque) then
  begin
    ShowMessage('Informe um estoque válido (número inteiro).');
    edtEstoque.SetFocus;
    Exit;
  end;

  var produto := TProdutoModel.Create;
  try
    produto.Id := FId;
    produto.Descricao := edtDescricao.Text;
    produto.Preco := preco;
    produto.Estoque := estoque;

    try
      FController.Salvar(produto);
    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
        Exit;
      end;
    end;
  finally
    produto.Free;
  end;

  ShowMessage('Produto salvo com sucesso.');
  LimparCampos;
  CarregarProdutos;
  pcProduto.ActivePage := tsConsulta;
end;

procedure TfrmTelaProduto.btnCancelarClick(Sender: TObject);
begin
  LimparCampos;
  pcProduto.ActivePage := tsConsulta;
end;

procedure TfrmTelaProduto.btnExcluirClick(Sender: TObject);
begin
  var produto := ProdutoSelecionado;
  if produto = nil then
  begin
    ShowMessage('Selecione um produto na lista.');
    Exit;
  end;

  if MessageDlg('Deseja realmente excluir este produto?', mtConfirmation,
    [mbYes, mbNo], 0) <> mrYes then
    Exit;

  try
    FController.Excluir(produto.Id);
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Exit;
    end;
  end;

  CarregarProdutos;
end;

end.
