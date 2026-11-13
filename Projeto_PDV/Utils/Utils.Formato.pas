unit Utils.Formato;

// Funcoes auxiliares de texto, usadas por varias camadas.

interface

// Remove tudo que nao for numero: "123.456.789-01" vira "12345678901".
function SomenteDigitos(const texto: string): string;

// Formata para EXIBIR (o banco guarda so os numeros).
function FormatarCpf(const cpf: string): string;
function FormatarCep(const cep: string): string;

implementation

uses
  System.SysUtils;

function SomenteDigitos(const texto: string): string;
begin
  Result := '';
  for var c in texto do
    if CharInSet(c, ['0'..'9']) then
      Result := Result + c;
end;

function FormatarCpf(const cpf: string): string;
begin
  if Length(cpf) = 11 then
    Result := Copy(cpf, 1, 3) + '.' + Copy(cpf, 4, 3) + '.' +
      Copy(cpf, 7, 3) + '-' + Copy(cpf, 10, 2)
  else
    Result := cpf;
end;

function FormatarCep(const cep: string): string;
begin
  if Length(cep) = 8 then
    Result := Copy(cep, 1, 5) + '-' + Copy(cep, 6, 3)
  else
    Result := cep;
end;

end.

