unit Controller.Venda;

// CONTROLLER: ponte entre a tela de vendas e o Service.

interface

uses
  Generics.Collections,
  Model.Venda,
  Service.Venda;

type
  TVendaController = class
  private
    FService: IVendaService;
  public
    constructor Create(service: IVendaService);
    // Quem chama e DONO da lista devolvida e deve liberar com Free.
    function ObterVendas: TObjectList<TVendaModel>;
    procedure Salvar(venda: TVendaModel);
    procedure Excluir(id: Integer);
  end;

implementation

{ TVendaController }

constructor TVendaController.Create(service: IVendaService);
begin
  inherited Create;
  FService := service;
end;

function TVendaController.ObterVendas: TObjectList<TVendaModel>;
begin
  Result := FService.ObterVendas;
end;

procedure TVendaController.Salvar(venda: TVendaModel);
begin
  FService.Salvar(venda);
end;

procedure TVendaController.Excluir(id: Integer);
begin
  FService.Excluir(id);
end;

end.
