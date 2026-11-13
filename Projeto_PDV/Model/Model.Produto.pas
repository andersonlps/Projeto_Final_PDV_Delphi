unit Model.Produto;

interface

type
  TProdutoModel = class
  private
    FId: Integer;
    FDescricao: string;
    FPreco: Currency;
    FEstoque: Integer;
  public
    procedure AdicionarEstoque(quantidade: Integer);
    //procedure BaixarEstoque(quantidade: Integer);

    property Id: Integer read FId write FId;
    property Descricao: string read FDescricao write FDescricao;
    property Preco: Currency read FPreco write FPreco;
    property Estoque: Integer read FEstoque write FEstoque;
  end;

implementation

uses
  System.SysUtils;

procedure TProdutoModel.AdicionarEstoque(quantidade: Integer);
begin
  if quantidade <= 0 then
    raise Exception.Create('A quantidade deve ser maior que zero');

  if quantidade >= FEstoque then
    raise Exception.CreateFmt('Estoque insuficiente. Quantidade disponível: %d.', [FEstoque]);

    FEstoque := Festoque - quantidade;
end;

end.
