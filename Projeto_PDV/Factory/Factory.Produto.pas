unit Factory.Produto;

// FACTORY: monta a cadeia Controller -> Service -> Repository de produto.

interface

uses
  Controller.Produto,
  Service.Produto,
  Repository.Produto;

type
  TProdutoFactory = class
  public
    class function CriarController: TProdutoController;
    class function CriarService: IProdutoService;
    class function CriarRepository: IProdutoRepository;
  end;

implementation

{ TProdutoFactory }

class function TProdutoFactory.CriarController: TProdutoController;
begin
  Result := TProdutoController.Create(CriarService);
end;

class function TProdutoFactory.CriarService: IProdutoService;
begin
  Result := TProdutoService.Create(CriarRepository);
end;

class function TProdutoFactory.CriarRepository: IProdutoRepository;
begin
  Result := TProdutoRepository.Create;
end;

end.

