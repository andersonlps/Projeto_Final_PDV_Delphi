unit Repository.Cliente;

interface

uses
  Data.DB,
  DataModulePrincipal,
  Generics.Collections,
  Model.Cliente,
  Model.Endereco;

type
  IClienteRepository = interface
    function ObterClientes(const filtro: string): TObjectList<TClienteModel>;
    function CpfJaExiste(const cpf: string; idIgnorar: Integer): Boolean;
    procedure Salvar(cliente: TClienteModel);
    procedure Excluir(id: Integer);
  end;

  TClienteRepository = class(TInterfacedObject, IClienteRepository)
  private
    procedure AplicarFiltro(const filtro: string);
    procedure LerEndereco(cliente: TClienteModel);
    procedure SalvarEndereco(idCliente: Integer; endereco: TEnderecoModel);
    procedure CancelarEdicoesPendentes;
  public
    function ObterClientes(const filtro: string): TObjectList<TClienteModel>;
    function CpfJaExiste(const cpf: string; idIgnorar: Integer): Boolean;
    procedure Salvar(cliente: TClienteModel);
    procedure Excluir(id: Integer);
  end;

implementation

uses
  System.SysUtils,
  Utils.Formato;

procedure TClienteRepository.AplicarFiltro(const filtro: string);
begin
  var tabela := dtmPrincipal.fdTableCliente;

  if not tabela.Active then
    tabela.Open;

  var texto := Trim(filtro).Replace('''', '''''');
  var digitos := SomenteDigitos(filtro);

  tabela.Filtered := False;
  if texto = '' then
    Exit;

  // Procura por trecho do nome (ou do CPF, se foram digitados números).
  var expressao := Format('nome LIKE ''%%%s%%''', [texto]);
  if digitos <> '' then
    expressao := expressao + Format(' OR cpf LIKE ''%%%s%%''', [digitos]);

  tabela.FilterOptions := [foCaseInsensitive];
  tabela.Filter := expressao;
  tabela.Filtered := True;
end;

function TClienteRepository.ObterClientes(const filtro: string): TObjectList<TClienteModel>;
begin
  Result := TObjectList<TClienteModel>.Create;
  try
    var tabelaCliente := dtmPrincipal.fdTableCliente;
    var tabelaEndereco := dtmPrincipal.fdTableEndereco;

    if not tabelaCliente.Active then
      tabelaCliente.Open;
    if not tabelaEndereco.Active then
      tabelaEndereco.Open;

    AplicarFiltro(filtro);

    tabelaCliente.First;
    while not tabelaCliente.Eof do
    begin
      var cliente := TClienteModel.Create;
      Result.Add(cliente);

      cliente.Id := tabelaCliente.FieldByName('id').AsInteger;
      cliente.Nome := tabelaCliente.FieldByName('nome').AsString;
      cliente.Cpf := tabelaCliente.FieldByName('cpf').AsString;
      cliente.Telefone := tabelaCliente.FieldByName('telefone').AsString;
      cliente.Email := tabelaCliente.FieldByName('email').AsString;

      LerEndereco(cliente);

      tabelaCliente.Next;
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure TClienteRepository.LerEndereco(cliente: TClienteModel);
begin
  var tabela := dtmPrincipal.fdTableEndereco;

  if not tabela.Active then
    tabela.Open;

  if not tabela.IsEmpty then
  begin
    cliente.Endereco.Id := tabela.FieldByName('id').AsInteger;
    cliente.Endereco.IdCliente := tabela.FieldByName('id_cliente').AsInteger;
    cliente.Endereco.Cep := tabela.FieldByName('cep').AsString;
    cliente.Endereco.Logradouro := tabela.FieldByName('logradouro').AsString;
    cliente.Endereco.Numero := tabela.FieldByName('numero').AsString;
    cliente.Endereco.Bairro := tabela.FieldByName('bairro').AsString;
    cliente.Endereco.Cidade := tabela.FieldByName('cidade').AsString;
    cliente.Endereco.Uf := tabela.FieldByName('uf').AsString;
  end;
end;

function TClienteRepository.CpfJaExiste(const cpf: string; idIgnorar: Integer): Boolean;
begin
  var tabela := dtmPrincipal.fdTableCliente;

  if not tabela.Active then
    tabela.Open;

  tabela.Filtered := False;

  Result := False;
  tabela.First;
  while not tabela.Eof do
  begin
    if (tabela.FieldByName('cpf').AsString = cpf) and
       (tabela.FieldByName('id').AsInteger <> idIgnorar) then
      Exit(True);
    tabela.Next;
  end;
end;

procedure TClienteRepository.Salvar(cliente: TClienteModel);
begin
  var tabelaCliente := dtmPrincipal.fdTableCliente;
  var tabelaEndereco := dtmPrincipal.fdTableEndereco;
  var conexao := dtmPrincipal.fdConnection;

  if not tabelaCliente.Active then
    tabelaCliente.Open;
  if not tabelaEndereco.Active then
    tabelaEndereco.Open;

  // Transação: grava o cliente E o endereço, ou não grava nada.
  conexao.StartTransaction;
  try
    tabelaCliente.Filtered := False;

    if (cliente.Id > 0) and tabelaCliente.Locate('id', cliente.Id, []) then
      tabelaCliente.Edit
    else
      tabelaCliente.Append;

    tabelaCliente.FieldByName('nome').AsString := cliente.Nome;
    tabelaCliente.FieldByName('cpf').AsString := cliente.Cpf;
    tabelaCliente.FieldByName('telefone').AsString := cliente.Telefone;
    tabelaCliente.FieldByName('email').AsString := cliente.Email;
    tabelaCliente.Post;

    cliente.Id := dtmPrincipal.IdGerado(tabelaCliente);

    // Garante o cursor no cliente salvo para o detalhe acompanhar via MasterSource
    tabelaCliente.Locate('id', cliente.Id, []);

    // Salva o único endereço do cliente
    if Assigned(cliente.Endereco) then
      SalvarEndereco(cliente.Id, cliente.Endereco);

    conexao.Commit;
  except
    CancelarEdicoesPendentes;
    if conexao.InTransaction then
      conexao.Rollback;
    raise;
  end;
end;

procedure TClienteRepository.SalvarEndereco(idCliente: Integer; endereco: TEnderecoModel);
begin
  var tabelaEndereco := dtmPrincipal.fdTableEndereco;

  if not tabelaEndereco.Active then
    tabelaEndereco.Open;

  if (endereco.Id > 0) and tabelaEndereco.Locate('id', endereco.Id, []) then
    tabelaEndereco.Open; // Garante edição se necessário

  if (endereco.Id > 0) and tabelaEndereco.Locate('id', endereco.Id, []) then
    tabelaEndereco.Edit
  else
    tabelaEndereco.Append;

  tabelaEndereco.FieldByName('id_cliente').AsInteger := idCliente;
  tabelaEndereco.FieldByName('cep').AsString := endereco.Cep;
  tabelaEndereco.FieldByName('logradouro').AsString := endereco.Logradouro;
  tabelaEndereco.FieldByName('numero').AsString := endereco.Numero;
  tabelaEndereco.FieldByName('bairro').AsString := endereco.Bairro;
  tabelaEndereco.FieldByName('cidade').AsString := endereco.Cidade;
  tabelaEndereco.FieldByName('uf').AsString := endereco.Uf;
  tabelaEndereco.Post;

  endereco.Id := dtmPrincipal.IdGerado(tabelaEndereco);
  endereco.IdCliente := idCliente;
end;

procedure TClienteRepository.CancelarEdicoesPendentes;
begin
  if dtmPrincipal.fdTableEndereco.Active and (dtmPrincipal.fdTableEndereco.State in dsEditModes) then
    dtmPrincipal.fdTableEndereco.Cancel;

  if dtmPrincipal.fdTableCliente.Active and (dtmPrincipal.fdTableCliente.State in dsEditModes) then
    dtmPrincipal.fdTableCliente.Cancel;
end;

procedure TClienteRepository.Excluir(id: Integer);
begin
  var tabelaCliente := dtmPrincipal.fdTableCliente;
  var tabelaEndereco := dtmPrincipal.fdTableEndereco;
  var conexao := dtmPrincipal.fdConnection;

  if not tabelaCliente.Active then
    tabelaCliente.Open;
  if not tabelaEndereco.Active then
    tabelaEndereco.Open;

  tabelaCliente.Filtered := False;
  if not tabelaCliente.Locate('id', id, []) then
    Exit;

  // Regra: cliente que já comprou não pode ser excluído.
  if conexao.ExecSQLScalar('SELECT COUNT(*) FROM venda WHERE id_cliente = :id',
    [id]) > 0 then
    raise Exception.Create('Não é possível excluir: o cliente possui vendas registradas.');

  conexao.StartTransaction;
  try
    // Como é 1 para 1, se houver um registro correspondente na tabela de endereço, apagamos ele também
    if not tabelaEndereco.IsEmpty then
      tabelaEndereco.Delete;

    tabelaCliente.Locate('id', id, []);
    tabelaCliente.Delete;

    conexao.Commit;
  except
    CancelarEdicoesPendentes;
    if conexao.InTransaction then
      conexao.Rollback;
    raise;
  end;
end;

end.
