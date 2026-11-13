unit Repository.Produto;

interface

uses
  Data.DB,
  DataModulePrincipal,
  Generics.Collections,
  Model.Produto;

type
  IProdutoRepository = interface
    function ObterProdutos(const filtro: string): TObjectList<TProdutoModel>;
    procedure Salvar(produto: TProdutoModel);
    procedure Excluir(id: Integer);
  end;

  TProdutoRepository = class(TInterfacedObject, IProdutoRepository)
  private
    procedure AplicarFiltro(const filtro: string);
  public
    function ObterProdutos(const filtro: string): TObjectList<TProdutoModel>;
    procedure Salvar(produto: TProdutoModel);
    procedure Excluir(id: Integer);
  end;

implementation

uses
  System.SysUtils;

procedure TProdutoRepository.AplicarFiltro(const filtro: string);
begin
  var tabela := dtmPrincipal.fdTableProduto;

  // GARANTE QUE A TABELA ESTÁ ABERTA ANTES DE FILTRAR
  if not tabela.Active then
    tabela.Open;

  var texto := Trim(filtro).Replace('''', '''''');

  tabela.Filtered := False;
  if texto = '' then
    Exit;

  tabela.FilterOptions := [foCaseInsensitive];
  tabela.Filter := Format('descricao LIKE ''%%%s%%''', [texto]);
  tabela.Filtered := True;
end;

function TProdutoRepository.ObterProdutos(const filtro: string): TObjectList<TProdutoModel>;
begin
  Result := TObjectList<TProdutoModel>.Create;
  try
    var tabela := dtmPrincipal.fdTableProduto;

    // Garante que a tabela está aberta
    if not tabela.Active then
      tabela.Open;

    AplicarFiltro(filtro);

    tabela.First;
    while not tabela.Eof do
    begin
      var produto := TProdutoModel.Create;
      Result.Add(produto);

      produto.Id := tabela.FieldByName('id').AsInteger;
      produto.Descricao := tabela.FieldByName('descricao').AsString;
      produto.Preco := tabela.FieldByName('preco').AsCurrency;
      produto.Estoque := tabela.FieldByName('estoque').AsInteger;

      tabela.Next;
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure TProdutoRepository.Salvar(produto: TProdutoModel);
begin
  var tabela := dtmPrincipal.fdTableProduto;

  // Garante que a tabela está aberta
  if not tabela.Active then
    tabela.Open;

  tabela.Filtered := False;

  try
    if (produto.Id > 0) and tabela.Locate('id', produto.Id, []) then
      tabela.Edit
    else
      tabela.Append;

    tabela.FieldByName('descricao').AsString := produto.Descricao;
    tabela.FieldByName('preco').AsCurrency := produto.Preco;
    tabela.FieldByName('estoque').AsInteger := produto.Estoque;
    tabela.Post;

    produto.Id := dtmPrincipal.IdGerado(tabela);
  except
    if tabela.State in dsEditModes then
      tabela.Cancel;
    raise;
  end;
end;

procedure TProdutoRepository.Excluir(id: Integer);
begin
  var tabela := dtmPrincipal.fdTableProduto;

  // Garante que a tabela está aberta
  if not tabela.Active then
    tabela.Open;

  tabela.Filtered := False;

  // Regra: produto que ja foi vendido nao pode ser excluido.
  if dtmPrincipal.fdConnection.ExecSQLScalar(
    'SELECT COUNT(*) FROM item_venda WHERE id_produto = :id', [id]) > 0 then
    raise Exception.Create('Não é possível excluir: o produto já foi vendido.');

  if tabela.Locate('id', id, []) then
    tabela.Delete;
end;

end.
