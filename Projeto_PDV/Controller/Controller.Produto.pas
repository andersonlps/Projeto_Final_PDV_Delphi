unit Controller.Produto;

// CONTROLLER: ponte entre a tela de produtos e o Service.

interface

uses
  Generics.Collections,
  Model.Produto,
  Service.Produto;

type
  TProdutoController = class
  private
    FService: IProdutoService;
  public
    constructor Create(service: IProdutoService);
    // Quem chama e DONO da lista devolvida e deve liberar com Free.
    function ObterProdutos(const filtro: string): TObjectList<TProdutoModel>;
    procedure Salvar(produto: TProdutoModel);
    procedure Excluir(id: Integer);
  end;

implementation

{ TProdutoController }

constructor TProdutoController.Create(service: IProdutoService);
begin
  inherited Create;
  FService := service;
end;

function TProdutoController.ObterProdutos(const filtro: string): TObjectList<TProdutoModel>;
begin
  Result := FService.ObterProdutos(filtro);
end;

procedure TProdutoController.Salvar(produto: TProdutoModel);
begin
  FService.Salvar(produto);
end;

procedure TProdutoController.Excluir(id: Integer);
begin
  FService.Excluir(id);
end;

end.

