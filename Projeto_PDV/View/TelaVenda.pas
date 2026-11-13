unit TelaVenda;

// VIEW: tela de vendas com as abas Consulta e Nova venda.
// Consulta: historico de vendas (com os itens da venda selecionada).
// Nova venda: escolhe o cliente, adiciona produtos, escolhe a forma de
// pagamento e fecha a venda. Nada vai ao banco ate clicar em "Fechar venda".
// A tela NAO tem SQL: ela so conhece os Controllers.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Generics.Collections,
  Model.Venda, Model.ItemVenda, Model.Cliente, Model.Produto,
  Controller.Venda, Controller.Cliente, Controller.Produto;

type
  TfrmTelaVenda = class(TForm)
    pcVenda: TPageControl;
    tsConsulta: TTabSheet;
    tsNovaVenda: TTabSheet;
    // --- aba Consulta ---
    pnlConsulta: TPanel;
    btnNovaVenda: TButton;
    btnCancelarVenda: TButton;
    gbItensVenda: TGroupBox;
    lvItensVenda: TListView;
    lvVendas: TListView;
    // --- aba Nova venda ---
    pnlCabecalho: TPanel;
    lblCliente: TLabel;
    lblPagamento: TLabel;
    cmbCliente: TComboBox;
    cmbPagamento: TComboBox;
    pnlItem: TPanel;
    lblProduto: TLabel;
    lblQuantidade: TLabel;
    lblInfoProduto: TLabel;
    cmbProduto: TComboBox;
    edtQuantidade: TEdit;
    btnAdicionarItem: TButton;
    btnRemoverItem: TButton;
    pnlRodapeVenda: TPanel;
    lblTotal: TLabel;
    btnFecharVenda: TButton;
    btnDescartar: TButton;
    lvItens: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNovaVendaClick(Sender: TObject);
    procedure btnCancelarVendaClick(Sender: TObject);
    procedure lvVendasSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure cmbProdutoChange(Sender: TObject);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure btnRemoverItemClick(Sender: TObject);
    procedure btnFecharVendaClick(Sender: TObject);
    procedure btnDescartarClick(Sender: TObject);
    procedure pcVendaChange(Sender: TObject);
  private
    FVendaController: TVendaController;
    FClienteController: TClienteController;
    FProdutoController: TProdutoController;

    FVendas: TObjectList<TVendaModel>;     // historico mostrado na consulta
    FClientes: TObjectList<TClienteModel>; // clientes do combo
    FProdutos: TObjectList<TProdutoModel>; // produtos do combo
    FVenda: TVendaModel;                   // venda em andamento

    procedure CarregarVendas;
    procedure CarregarItensVenda(venda: TVendaModel);
    function CarregarCombos: Boolean;
    procedure CarregarItens;
    procedure AtualizarTotal;
    procedure AtualizarInfoProduto;
    procedure TrocarVenda(nova: TVendaModel);
    function PrepararNovaVenda: Boolean;
    procedure LimparNovaVenda;
    function ClienteEscolhido: TClienteModel;
    function ProdutoEscolhido: TProdutoModel;
  end;

implementation

{$R *.dfm}

uses
  Factory.Venda,
  Factory.Cliente,
  Factory.Produto,
  Utils.Formato;

procedure TfrmTelaVenda.FormCreate(Sender: TObject);
begin
  FVendaController := TVendaFactory.CriarController;
  FClienteController := TClienteFactory.CriarController;
  FProdutoController := TProdutoFactory.CriarController;
  FVenda := TVendaModel.Create;

  for var forma in FormasPagamento do
    cmbPagamento.Items.Add(forma);

  pcVenda.ActivePage := tsConsulta;
  CarregarVendas;
end;

procedure TfrmTelaVenda.FormDestroy(Sender: TObject);
begin
  FVenda.Free;
  FProdutos.Free;
  FClientes.Free;
  FVendas.Free;
  FProdutoController.Free;
  FClienteController.Free;
  FVendaController.Free;
end;

// =================== CONSULTA (historico) ===================

procedure TfrmTelaVenda.CarregarVendas;
begin
  lvItensVenda.Items.Clear;

  lvVendas.Items.BeginUpdate;
  try
    lvVendas.Items.Clear;
    FreeAndNil(FVendas);

    try
      FVendas := FVendaController.ObterVendas;
    except
      on E: Exception do
      begin
        ShowMessage('Erro: ' + E.Message);
        Exit;
      end;
    end;

    for var venda in FVendas do
    begin
      var item := lvVendas.Items.Add;
      item.Caption := IntToStr(venda.Id);
      item.SubItems.Add(FormatDateTime('dd/mm/yyyy hh:nn', venda.DataVenda));
      item.SubItems.Add(venda.NomeCliente);
      item.SubItems.Add(venda.FormaPagamento);
      item.SubItems.Add(FormatFloat('#,##0.00', venda.Total));
      item.Data := venda; // guarda o objeto na linha da lista
    end;
  finally
    lvVendas.Items.EndUpdate;
  end;
end;

procedure TfrmTelaVenda.CarregarItensVenda(venda: TVendaModel);
begin
  lvItensVenda.Items.BeginUpdate;
  try
    lvItensVenda.Items.Clear;
    for var itemVenda in venda.Itens do
    begin
      var item := lvItensVenda.Items.Add;
      item.Caption := itemVenda.DescricaoProduto;
      item.SubItems.Add(IntToStr(itemVenda.Quantidade));
      item.SubItems.Add(FormatFloat('#,##0.00', itemVenda.PrecoUnitario));
      item.SubItems.Add(FormatFloat('#,##0.00', itemVenda.Subtotal));
    end;
  finally
    lvItensVenda.Items.EndUpdate;
  end;
end;

procedure TfrmTelaVenda.lvVendasSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected and Assigned(Item.Data) then
    CarregarItensVenda(TVendaModel(Item.Data))
  else
    lvItensVenda.Items.Clear;
end;

procedure TfrmTelaVenda.btnCancelarVendaClick(Sender: TObject);
begin
  if (lvVendas.Selected = nil) or (lvVendas.Selected.Data = nil) then
  begin
    ShowMessage('Selecione uma venda na lista.');
    Exit;
  end;

  if MessageDlg('Deseja cancelar esta venda? O estoque dos produtos será ' +
    'devolvido.', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  try
    FVendaController.Excluir(TVendaModel(lvVendas.Selected.Data).Id);
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Exit;
    end;
  end;

  CarregarVendas;
end;

// =================== NOVA VENDA ===================

// Troca a venda em andamento (libera a antiga).
procedure TfrmTelaVenda.TrocarVenda(nova: TVendaModel);
begin
  lvItens.Items.Clear; // a lista nao pode apontar para itens liberados
  FVenda.Free;
  FVenda := nova;
end;

function TfrmTelaVenda.CarregarCombos: Boolean;
begin
  Result := False;

  cmbCliente.Items.Clear;
  cmbProduto.Items.Clear;
  FreeAndNil(FClientes);
  FreeAndNil(FProdutos);

  try
    FClientes := FClienteController.ObterClientes('');
    FProdutos := FProdutoController.ObterProdutos('');
  except
    on E: Exception do
    begin
      ShowMessage('Erro: ' + E.Message);
      Exit;
    end;
  end;

  for var cliente in FClientes do
    cmbCliente.Items.AddObject(cliente.Nome + '  -  ' + FormatarCpf(cliente.Cpf),
      cliente);

  for var produto in FProdutos do
    cmbProduto.Items.AddObject(produto.Descricao, produto);

  Result := True;
end;

function TfrmTelaVenda.ClienteEscolhido: TClienteModel;
begin
  if cmbCliente.ItemIndex < 0 then
    Result := nil
  else
    Result := TClienteModel(cmbCliente.Items.Objects[cmbCliente.ItemIndex]);
end;

function TfrmTelaVenda.ProdutoEscolhido: TProdutoModel;
begin
  if cmbProduto.ItemIndex < 0 then
    Result := nil
  else
    Result := TProdutoModel(cmbProduto.Items.Objects[cmbProduto.ItemIndex]);
end;

procedure TfrmTelaVenda.AtualizarInfoProduto;
begin
  var produto := ProdutoEscolhido;
  if produto = nil then
    lblInfoProduto.Caption := ''
  else
    lblInfoProduto.Caption := Format('Preço: R$ %s   |   Estoque disponível: %d',
      [FormatFloat('#,##0.00', produto.Preco), produto.Estoque]);
end;

procedure TfrmTelaVenda.cmbProdutoChange(Sender: TObject);
begin
  AtualizarInfoProduto;
end;

procedure TfrmTelaVenda.CarregarItens;
begin
  lvItens.Items.BeginUpdate;
  try
    lvItens.Items.Clear;
    for var itemVenda in FVenda.Itens do
    begin
      var item := lvItens.Items.Add;
      item.Caption := itemVenda.DescricaoProduto;
      item.SubItems.Add(IntToStr(itemVenda.Quantidade));
      item.SubItems.Add(FormatFloat('#,##0.00', itemVenda.PrecoUnitario));
      item.SubItems.Add(FormatFloat('#,##0.00', itemVenda.Subtotal));
      item.Data := itemVenda;
    end;
  finally
    lvItens.Items.EndUpdate;
  end;
end;

procedure TfrmTelaVenda.AtualizarTotal;
begin
  lblTotal.Caption := 'Total: R$ ' + FormatFloat('#,##0.00', FVenda.Total);
end;

// Carrega clientes e produtos do banco nos combos e comeca uma venda nova.
// Devolve False (com mensagem) se nao for possivel vender.
function TfrmTelaVenda.PrepararNovaVenda: Boolean;
begin
  Result := False;

  if not CarregarCombos then
    Exit;

  if (FClientes.Count = 0) or (FProdutos.Count = 0) then
  begin
    LimparNovaVenda;
    ShowMessage('Cadastre pelo menos um cliente e um produto antes de vender.');
    Exit;
  end;

  TrocarVenda(TVendaModel.Create);
  cmbCliente.ItemIndex := -1;
  cmbPagamento.ItemIndex := -1;
  cmbProduto.ItemIndex := -1;
  edtQuantidade.Text := '1';
  AtualizarInfoProduto;
  CarregarItens;
  AtualizarTotal;

  Result := True;
end;

// Zera a aba "Nova venda" (venda, combos e listas). Na proxima vez que a
// aba for aberta, os dados sao carregados de novo do banco.
procedure TfrmTelaVenda.LimparNovaVenda;
begin
  TrocarVenda(TVendaModel.Create);
  cmbCliente.Items.Clear;
  cmbProduto.Items.Clear;
  FreeAndNil(FClientes);
  FreeAndNil(FProdutos);
  cmbPagamento.ItemIndex := -1;
  edtQuantidade.Text := '1';
  AtualizarInfoProduto;
  CarregarItens;
  AtualizarTotal;
end;

procedure TfrmTelaVenda.btnNovaVendaClick(Sender: TObject);
begin
  if not PrepararNovaVenda then
    Exit;

  pcVenda.ActivePage := tsNovaVenda;
  cmbCliente.SetFocus;
end;

// Se o usuario clicar direto na aba "Nova venda" (sem usar o botao),
// os combos ainda estao vazios: carrega os dados do banco agora.
procedure TfrmTelaVenda.pcVendaChange(Sender: TObject);
begin
  if (pcVenda.ActivePage = tsNovaVenda) and (cmbCliente.Items.Count = 0) then
    if not PrepararNovaVenda then
      pcVenda.ActivePage := tsConsulta;
end;

procedure TfrmTelaVenda.btnAdicionarItemClick(Sender: TObject);
var
  quantidade: Integer;
begin
  var produto := ProdutoEscolhido;
  if produto = nil then
  begin
    ShowMessage('Selecione um produto.');
    cmbProduto.SetFocus;
    Exit;
  end;

  if not TryStrToInt(edtQuantidade.Text, quantidade) then
  begin
    ShowMessage('Informe uma quantidade válida (número inteiro).');
    edtQuantidade.SetFocus;
    Exit;
  end;

  try
    FVenda.AdicionarItem(produto, quantidade); // confere o estoque
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Exit;
    end;
  end;

  CarregarItens;
  AtualizarTotal;
  edtQuantidade.Text := '1';
  cmbProduto.SetFocus;
end;

procedure TfrmTelaVenda.btnRemoverItemClick(Sender: TObject);
begin
  if (lvItens.Selected = nil) or (lvItens.Selected.Data = nil) then
  begin
    ShowMessage('Selecione um item na lista.');
    Exit;
  end;

  var item := TItemVendaModel(lvItens.Selected.Data);
  lvItens.Items.Clear;
  FVenda.RemoverItem(item); // remove e libera

  CarregarItens;
  AtualizarTotal;
end;

procedure TfrmTelaVenda.btnFecharVendaClick(Sender: TObject);
begin
  // Passa para a venda o que foi escolhido nos combos.
  var cliente := ClienteEscolhido;
  if cliente = nil then
    FVenda.IdCliente := 0
  else
  begin
    FVenda.IdCliente := cliente.Id;
    FVenda.NomeCliente := cliente.Nome;
  end;

  if cmbPagamento.ItemIndex < 0 then
    FVenda.FormaPagamento := ''
  else
    FVenda.FormaPagamento := cmbPagamento.Items[cmbPagamento.ItemIndex];

  try
    // Valida, grava venda + itens e baixa o estoque (em transacao).
    FVendaController.Salvar(FVenda);
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Exit;
    end;
  end;

  ShowMessage(Format('Venda %d fechada com sucesso!' + sLineBreak +
    'Total: R$ %s', [FVenda.Id, FormatFloat('#,##0.00', FVenda.Total)]));

  LimparNovaVenda;
  CarregarVendas;
  pcVenda.ActivePage := tsConsulta;
end;

procedure TfrmTelaVenda.btnDescartarClick(Sender: TObject);
begin
  LimparNovaVenda;
  pcVenda.ActivePage := tsConsulta;
end;

end.
