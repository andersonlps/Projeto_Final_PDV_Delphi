unit Service.Endereco;

interface

uses
  Model.Endereco,
  REST.Client,
  REST.Types,
  System.Classes,
  System.JSON,
  System.SysUtils;

type
  TServicoEndereco = class
  private
    FClient: TRESTClient;
    FRequest: TRESTRequest;
    FResponse: TRESTResponse;
  public
    constructor Create;
    destructor Destroy; override;
    function ObterEndereco(const CEP: string): TEnderecoModel;
  end;

implementation

{ TServicoEndereco }

constructor TServicoEndereco.Create;
begin
  FClient := TRESTClient.Create('https://viacep.com.br/ws/');
  FRequest := TRESTRequest.Create(nil);
  FResponse := TRESTResponse.Create(nil);

  FRequest.Client := FClient;
  FRequest.Response := FResponse;
  FRequest.Method := rmGET;
end;

destructor TServicoEndereco.Destroy;
begin
  FClient.Free;
  FRequest.Free;
  FResponse.Free;
  inherited;
end;

function TServicoEndereco.ObterEndereco(const CEP: string): TEnderecoModel;
var
  JSONObj: TJSONObject;
  CepLimpo: string;
begin
  Result := nil;

  // Limpa caracteres especiais do CEP
  CepLimpo := StringReplace(CEP, '-', '', [rfReplaceAll]);
  CepLimpo := StringReplace(CepLimpo, '.', '', [rfReplaceAll]);

  if Length(CepLimpo) <> 8 then
    raise Exception.Create('Informe um CEP válido com 8 dígitos.');

  try
    FRequest.Resource := CepLimpo + '/json/';
    FRequest.Execute;

    if FResponse.StatusCode <> 200 then
      raise Exception.CreateFmt('Erro na requisição: %d - %s',
        [FResponse.StatusCode, FResponse.StatusText]);

    JSONObj := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONObject;
    try
      if not Assigned(JSONObj) then
        raise Exception.Create('Resposta inválida do serviço de CEP.');

      // Verifica se a API retornou erro (CEP não encontrado)
      if JSONObj.Values['erro'] <> nil then
        raise Exception.Create('CEP não encontrado na base de dados.');

      Result := TEnderecoModel.Create;
      Result.Cep        := JSONObj.GetValue<string>('cep');
      Result.Logradouro := JSONObj.GetValue<string>('logradouro');
      Result.Bairro     := JSONObj.GetValue<string>('bairro');
      Result.Cidade     := JSONObj.GetValue<string>('localidade');
      Result.Uf         := JSONObj.GetValue<string>('uf');
    finally
      JSONObj.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create('Falha ao obter endereço: ' + E.Message);
  end;
end;

end.
