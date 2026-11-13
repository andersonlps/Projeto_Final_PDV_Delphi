unit Controller.Cliente;

// CONTROLLER: ponte entre a tela e o Service.
// A tela conhece o Controller; o Controller conhece o Service.

interface

uses
  Generics.Collections,
  Model.Cliente,
  Model.Endereco,
  Service.Cliente;

type
  TClienteController = class
  private
    FService: IClienteService;
  public
    constructor Create(service: IClienteService);
    // Quem chama e DONO da lista devolvida e deve liberar com Free.
    function ObterClientes(const filtro: string): TObjectList<TClienteModel>;
    procedure ValidarEndereco(endereco: TEnderecoModel);
    procedure Salvar(cliente: TClienteModel);
    procedure Excluir(id: Integer);
  end;

implementation

{ TClienteController }

constructor TClienteController.Create(service: IClienteService);
begin
  inherited Create;
  FService := service;
end;

function TClienteController.ObterClientes(const filtro: string): TObjectList<TClienteModel>;
begin
  Result := FService.ObterClientes(filtro);
end;

procedure TClienteController.ValidarEndereco(endereco: TEnderecoModel);
begin
  FService.ValidarEndereco(endereco);
end;

procedure TClienteController.Salvar(cliente: TClienteModel);
begin
  FService.Salvar(cliente);
end;

procedure TClienteController.Excluir(id: Integer);
begin
  FService.Excluir(id);
end;

end.

