unit Model.ItemVenda;

// MODEL do DETALHE da venda: um produto dentro da venda.

interface

type
  TItemVendaModel = class
  private
    FId: Integer;
    FIdVenda: Integer;
    FIdProduto: Integer;
    FDescricaoProduto: string;
    FQuantidade: Integer;
    FPrecoUnitario: Currency;
    function GetSubtotal: Currency;
  public
    property Id: Integer read FId write FId;
    property IdVenda: Integer read FIdVenda write FIdVenda;
    property IdProduto: Integer read FIdProduto write FIdProduto;
    property DescricaoProduto: string read FDescricaoProduto write FDescricaoProduto;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property PrecoUnitario: Currency read FPrecoUnitario write FPrecoUnitario;
    // Calculado: quantidade x preco unitario.
    property Subtotal: Currency read GetSubtotal;
  end;

implementation

{ TItemVendaModel }

function TItemVendaModel.GetSubtotal: Currency;
begin
  Result := FQuantidade * FPrecoUnitario;
end;

end.
