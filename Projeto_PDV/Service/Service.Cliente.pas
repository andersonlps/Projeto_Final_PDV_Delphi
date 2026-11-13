unit Service.Cliente;

interface

uses
  Generics.Collections,
  Model.Cliente,
  Model.Endereco,
  Repository.Cliente;

type
  IClienteService = interface
    function ObterClientes(const filtro: string): TObjectList<TClienteModel>;
    procedure ValidarEndereco(endereco: TEnderecoModel);
    procedure Salvar(cliente: TClienteModel);
    procedure Excluir(id: Integer);
  end;

  TClienteService = class(TInterfacedObject, IClienteService)
  private
    FRepository: IClienteRepository;
    procedure Normalizar(cliente: TClienteModel);
    procedure Validar(cliente: TClienteModel);
  public
    constructor Create(repository: IClienteRepository);
    function ObterClientes(const filtro: string): TObjectList<TClienteModel>;
    procedure ValidarEndereco(endereco: TEnderecoModel);
    procedure Salvar(cliente: TClienteModel);
    procedure Excluir(id: Integer);
  end;

implementation

uses
  System.SysUtils,
  Utils.Formato;

constructor TClienteService.Create(repository: IClienteRepository);
begin
  inherited Create;
  FRepository := repository;
end;

function TClienteService.ObterClientes(const filtro: string): TObjectList<TClienteModel>;
begin
  Result := FRepository.ObterClientes(filtro);
end;

procedure TClienteService.Normalizar(cliente: TClienteModel);
begin
  cliente.Nome := Trim(cliente.Nome);
  cliente.Cpf := SomenteDigitos(cliente.Cpf);
  cliente.Telefone := Trim(cliente.Telefone);
  cliente.Email := Trim(cliente.Email);
end;

procedure TClienteService.Validar(cliente: TClienteModel);
begin
  if cliente.Nome = '' then
    raise Exception.Create('Nome não informado.');

  if Length(cliente.Cpf) <> 11 then
    raise Exception.Create('O CPF deve ter 11 dígitos.');

  if (cliente.Email <> '') and (Pos('@', cliente.Email) = 0) then
    raise Exception.Create('E-mail inválido.');

  if Assigned(cliente.Endereco) then
  ValidarEndereco(cliente.Endereco);
end;

procedure TClienteService.ValidarEndereco(endereco: TEnderecoModel);
begin
  // Ajusta os dados (tira espacos, deixa so numeros no CEP, UF maiuscula)
  // e depois confere as regras.
  endereco.Cep := SomenteDigitos(endereco.Cep);
  endereco.Logradouro := Trim(endereco.Logradouro);
  endereco.Numero := Trim(endereco.Numero);
  endereco.Bairro := Trim(endereco.Bairro);
  endereco.Cidade := Trim(endereco.Cidade);
  endereco.Uf := UpperCase(Trim(endereco.Uf));

  if Length(endereco.Cep) <> 8 then
    raise Exception.Create('O CEP deve ter 8 dígitos.');

  if endereco.Logradouro = '' then
    raise Exception.Create('Logradouro não informado.');

  if endereco.Cidade = '' then
    raise Exception.Create('Cidade não informada.');

  if Length(endereco.Uf) <> 2 then
    raise Exception.Create('A UF deve ter 2 letras.');
end;

procedure TClienteService.Salvar(cliente: TClienteModel);
begin
  Normalizar(cliente);
  Validar(cliente);

  if FRepository.CpfJaExiste(cliente.Cpf, cliente.Id) then
    raise Exception.Create('Já existe um cliente cadastrado com este CPF.');

  FRepository.Salvar(cliente);
end;

procedure TClienteService.Excluir(id: Integer);
begin
  if id <= 0 then
    raise Exception.Create('Selecione um cliente para excluir.');

  FRepository.Excluir(id);
end;

end.

