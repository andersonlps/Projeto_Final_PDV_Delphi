unit Service.Produto;

interface

uses
  Generics.Collections,
  Model.Produto,
  Repository.Produto;

type
  IProdutoService = interface
    function ObterProdutos(const filtro: string): TObjectList<TProdutoModel>;
    procedure Salvar(produto: TProdutoModel);
    procedure Excluir(id: Integer);
  end;

  TProdutoService = class(TInterfacedObject, IProdutoService)
  private
    FRepository: IProdutoRepository;
    procedure Validar(produto: TProdutoModel);
  public
    constructor Create(repository: IProdutoRepository);
    function ObterProdutos(const filtro: string): TObjectList<TProdutoModel>;
    procedure Salvar(produto: TProdutoModel);
    procedure Excluir(id: Integer);
  end;

implementation

uses
  System.SysUtils;

constructor TProdutoService.Create(repository: IProdutoRepository);
begin
  inherited Create;
  FRepository := repository;
end;

function TProdutoService.ObterProdutos(const filtro: string): TObjectList<TProdutoModel>;
begin
  Result := FRepository.ObterProdutos(filtro);
end;

procedure TProdutoService.Validar(produto: TProdutoModel);
begin
  if produto.Descricao = '' then
    raise Exception.Create('Descrição não informada.');

  if produto.Preco < 0 then
    raise Exception.Create('O preço não pode ser negativo.');

  if produto.Estoque < 0 then
    raise Exception.Create('O estoque não pode ser negativo.');
end;

procedure TProdutoService.Salvar(produto: TProdutoModel);
begin
  produto.Descricao := Trim(produto.Descricao);
  Validar(produto);

  FRepository.Salvar(produto);
end;

procedure TProdutoService.Excluir(id: Integer);
begin
  if id <= 0 then
    raise Exception.Create('Selecione um produto para excluir.');

  FRepository.Excluir(id);
end;

end.

