unit Factory.Cliente;

// FACTORY: monta a cadeia Controller -> Service -> Repository.

interface

uses
  Controller.Cliente,
  Service.Cliente,
  Repository.Cliente;

type
  TClienteFactory = class
  public
    class function CriarController: TClienteController;
    class function CriarService: IClienteService;
    class function CriarRepository: IClienteRepository;
  end;

implementation

{ TClienteFactory }

class function TClienteFactory.CriarController: TClienteController;
begin
  Result := TClienteController.Create(CriarService);
end;

class function TClienteFactory.CriarService: IClienteService;
begin
  Result := TClienteService.Create(CriarRepository);
end;

class function TClienteFactory.CriarRepository: IClienteRepository;
begin
  Result := TClienteRepository.Create;
end;

end.

