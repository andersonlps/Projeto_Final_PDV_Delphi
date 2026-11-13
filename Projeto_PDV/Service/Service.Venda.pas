unit Service.Venda;

// SERVICE: regras de negocio da venda.

interface

uses
  Generics.Collections,
  Model.Venda,
  Repository.Venda;

type
  IVendaService = interface
    function ObterVendas: TObjectList<TVendaModel>;
    procedure Salvar(venda: TVendaModel);
    procedure Excluir(id: Integer);
  end;

  TVendaService = class(TInterfacedObject, IVendaService)
  private
    FRepository: IVendaRepository;
    procedure Validar(venda: TVendaModel);
  public
    constructor Create(repository: IVendaRepository);
    function ObterVendas: TObjectList<TVendaModel>;
    procedure Salvar(venda: TVendaModel);
    procedure Excluir(id: Integer);
  end;

implementation

uses
  System.SysUtils;

{ TVendaService }

constructor TVendaService.Create(repository: IVendaRepository);
begin
  inherited Create;
  FRepository := repository;
end;

function TVendaService.ObterVendas: TObjectList<TVendaModel>;
begin
  Result := FRepository.ObterVendas;
end;

procedure TVendaService.Validar(venda: TVendaModel);
begin
  if venda.IdCliente <= 0 then
    raise Exception.Create('Selecione o cliente da venda.');

  if venda.Itens.Count = 0 then
    raise Exception.Create('Adicione pelo menos um produto à venda.');

  if Trim(venda.FormaPagamento) = '' then
    raise Exception.Create('Selecione a forma de pagamento.');

  for var item in venda.Itens do
  begin
    if item.Quantidade <= 0 then
      raise Exception.CreateFmt('Quantidade inválida para "%s".',
        [item.DescricaoProduto]);

    if item.PrecoUnitario < 0 then
      raise Exception.CreateFmt('Preço inválido para "%s".',
        [item.DescricaoProduto]);
  end;
end;

procedure TVendaService.Salvar(venda: TVendaModel);
begin
  Validar(venda);

  venda.DataVenda := Now; // data e hora do fechamento da venda
  FRepository.Salvar(venda);
end;

procedure TVendaService.Excluir(id: Integer);
begin
  if id <= 0 then
    raise Exception.Create('Selecione uma venda para cancelar.');

  FRepository.Excluir(id);
end;

end.
