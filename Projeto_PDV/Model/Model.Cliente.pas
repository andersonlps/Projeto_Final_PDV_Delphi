unit Model.Cliente;

interface

uses
  Model.Endereco;

type
  TClienteModel = class
    private
      FId: Integer;
      FNome: string;
      FCpf: string;
      FTelefone: string;
      FEmail: string;
      FEndereco: TEnderecoModel;
    public

      constructor Create;
      destructor Destroy; override;

      function Clonar: TClienteModel;

      property Id: Integer read FId write FId;
      property Nome: string read FNome write FNome;
      property Cpf: string read FCpf write FCpf;
      property Telefone: string read FTelefone write FTelefone;
      property Email: string read FEmail write FEmail;
      property Endereco: TEnderecoModel read FEndereco write FEndereco;
  end;

implementation
constructor TClienteModel.Create;
begin
  inherited Create;
  FEndereco := TEnderecoModel.Create;
end;

destructor TClienteModel.Destroy;
begin
  FEndereco.Free;
  inherited Destroy;
end;

function TClienteModel.Clonar: TClienteModel;
begin
  Result := TClienteModel.Create;
  Result.Id := FId;
  Result.Nome := FNome;
  Result.Cpf := FCpf;
  Result.Telefone := FTelefone;
  Result.Email := FEmail;

  if Assigned(FEndereco) then
    Result.Endereco := FEndereco.Clonar;
end;

end.
