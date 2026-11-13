unit Model.Endereco;

interface

type
  TEnderecoModel = class
    private
      FId: Integer;
      FIdCliente: Integer;
      FCep: string;
      FLogradouro: string;
      FNumero: string;
      FBairro: string;
      FCidade: string;
      FUf: string;
    public
      constructor Create;

      function Clonar: TEnderecoModel;
      procedure Copiar(origem: TEnderecoModel);

      property Id: Integer read FId write FId;
      property IdCliente: Integer read FIdCliente write FIdCliente;
      property Cep: string read FCep write FCep;
      property Logradouro: string read FLogradouro write FLogradouro;
      property Numero: string read FNumero write FNumero;
      property Bairro: string read FBairro write FBairro;
      property Cidade: string read FCidade write FCidade;
      property Uf: string read FUf write FUf;
    end;

implementation

constructor TEnderecoModel.Create;
begin
  inherited Create;
  FId := 0;
  FIdCliente := 0;
end;

function TEnderecoModel.Clonar: TEnderecoModel;
begin
  Result := TEnderecoModel.Create;
  Result.Id := FId;
  Result.IdCliente := FIdCliente;
  Result.Copiar(Self);
end;

procedure TEnderecoModel.Copiar(origem: TEnderecoModel);
begin
  FCep := origem.Cep;
  FLogradouro := origem.Logradouro;
  FNumero := origem.Numero;
  FBairro := origem.Bairro;
  FCidade := origem.Cidade;
  FUf := origem.Uf;
end;

end.