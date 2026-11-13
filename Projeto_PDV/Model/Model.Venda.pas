unit Model.Venda;

// MODEL do MASTER da venda: cliente, forma de pagamento e a lista de itens.
// A lista e criada no construtor e liberada no destrutor.

interface

uses
  Generics.Collections,
  Model.ItemVenda,
  Model.Produto;

const
  FormasPagamento: array[0..4] of string =
    ('Dinheiro', 'Pix', 'Cartão de débito', 'Cartão de crédito', 'Boleto');

type
  TVendaModel = class
  private
    FId: Integer;
    FIdCliente: Integer;
    FNomeCliente: string;
    FDataVenda: TDateTime;
    FFormaPagamento: string;
    FItens: TObjectList<TItemVendaModel>;
    function GetTotal: Currency;
    function BuscarItem(idProduto: Integer): TItemVendaModel;
  public
    constructor Create;
    destructor Destroy; override;

    // Regra de negocio: coloca o produto na venda (soma a quantidade se
    // o produto ja estiver na lista) e confere o estoque.
    procedure AdicionarItem(produto: TProdutoModel; quantidade: Integer);
    // Remove o item da lista e o libera.
    procedure RemoverItem(item: TItemVendaModel);

    property Id: Integer read FId write FId;
    property IdCliente: Integer read FIdCliente write FIdCliente;
    property NomeCliente: string read FNomeCliente write FNomeCliente;
    property DataVenda: TDateTime read FDataVenda write FDataVenda;
    property FormaPagamento: string read FFormaPagamento write FFormaPagamento;
    property Itens: TObjectList<TItemVendaModel> read FItens;
    // Calculado: soma dos subtotais dos itens.
    property Total: Currency read GetTotal;
  end;

implementation

uses
  System.SysUtils;

{ TVendaModel }

constructor TVendaModel.Create;
begin
  inherited Create;
  FItens := TObjectList<TItemVendaModel>.Create;
end;

destructor TVendaModel.Destroy;
begin
  FItens.Free;
  inherited Destroy;
end;

function TVendaModel.GetTotal: Currency;
begin
  Result := 0;
  for var item in FItens do
    Result := Result + item.Subtotal;
end;

function TVendaModel.BuscarItem(idProduto: Integer): TItemVendaModel;
begin
  Result := nil;
  for var item in FItens do
    if item.IdProduto = idProduto then
      Exit(item);
end;

procedure TVendaModel.AdicionarItem(produto: TProdutoModel; quantidade: Integer);
begin
  if quantidade <= 0 then
    raise Exception.Create('A quantidade deve ser maior que zero.');

  var item := BuscarItem(produto.Id);

  var jaNaVenda := 0;
  if item <> nil then
    jaNaVenda := item.Quantidade;

  if jaNaVenda + quantidade > produto.Estoque then
    raise Exception.CreateFmt('Estoque insuficiente para "%s". Disponível: %d.',
      [produto.Descricao, produto.Estoque]);

  if item = nil then
  begin
    item := TItemVendaModel.Create;
    item.IdProduto := produto.Id;
    item.DescricaoProduto := produto.Descricao;
    item.PrecoUnitario := produto.Preco;
    FItens.Add(item);
  end;

  item.Quantidade := item.Quantidade + quantidade;
end;

procedure TVendaModel.RemoverItem(item: TItemVendaModel);
begin
  FItens.Remove(item);
end;

end.
