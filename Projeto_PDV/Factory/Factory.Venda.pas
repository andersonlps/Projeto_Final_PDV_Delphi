unit Factory.Venda;

// FACTORY: monta a cadeia Controller -> Service -> Repository da venda.

interface

uses
  Controller.Venda,
  Service.Venda,
  Repository.Venda;

type
  TVendaFactory = class
  public
    class function CriarController: TVendaController;
    class function CriarService: IVendaService;
    class function CriarRepository: IVendaRepository;
  end;

implementation

{ TVendaFactory }

class function TVendaFactory.CriarController: TVendaController;
begin
  Result := TVendaController.Create(CriarService);
end;

class function TVendaFactory.CriarService: IVendaService;
begin
  Result := TVendaService.Create(CriarRepository);
end;

class function TVendaFactory.CriarRepository: IVendaRepository;
begin
  Result := TVendaRepository.Create;
end;

end.
