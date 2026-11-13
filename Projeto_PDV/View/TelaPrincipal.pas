unit TelaPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, TelaCliente, TelaProduto, TelaVenda,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TfrmTelaPrincipal = class(TForm)
    pnlHeader: TPanel;
    pnlMenu: TPanel;
    pnlFooter: TPanel;
    pnlInfo: TPanel;
    btnProdutos: TButton;
    btnClientes: TButton;
    btnVendas: TButton;
    btnSair: TButton;
    pnlConteudo: TPanel;
    P: TImage;
    lblNomeLoja: TLabel;
    Label2: TLabel;
    procedure btnClientesClick(Sender: TObject);
    procedure btnProdutosClick(Sender: TObject);
    procedure btnVendasClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTelaPrincipal: TfrmTelaPrincipal;

implementation

{$R *.dfm}

procedure TfrmTelaPrincipal.btnClientesClick(Sender: TObject);
begin
  // 1. Cria a tela de clientes
  var FormCliente := TfrmTelaCliente.Create(Self);
  try
    // 2. Tira as bordas
    FormCliente.BorderStyle := bsNone;

    // 3. Joga a tela para dentro do painel central da tela principal
    FormCliente.Parent := pnlConteudo;

    // 4. Faz ela esticar para preencher todo o painel
    FormCliente.Align := alClient;

    // 5. Mostra a tela
    FormCliente.Show;
  except
    FormCliente.Free;
    raise;
  end;
end;

procedure TfrmTelaPrincipal.btnProdutosClick(Sender: TObject);
begin
  // 1. Cria a tela de produtos
  var FormProduto := TfrmTelaProduto.Create(Self);
  try
    // 2. Tira as bordas
    FormProduto.BorderStyle := bsNone;

    // 3. Joga a tela para dentro do painel central da tela principal
    FormProduto.Parent := pnlConteudo;

    // 4. Faz ela esticar para preencher todo o painel
    FormProduto.Align := alClient;

    // 5. Mostra a tela
    FormProduto.Show;
  except
    FormProduto.Free;
    raise;
  end;
end;

procedure TfrmTelaPrincipal.btnSairClick(Sender: TObject);
begin
  // Pergunta se o usuário realmente quer sair (opcional, mas fica bem profissional)
  if MessageDlg('Deseja realmente sair do sistema?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Close; // Fecha o formulário principal, encerrando o programa inteiro
  end;
end;

procedure TfrmTelaPrincipal.btnVendasClick(Sender: TObject);
begin
  var FormVenda := TfrmTelaVenda.Create(Self);
  try
    FormVenda.BorderStyle := bsNone;
    FormVenda.Parent := pnlConteudo;
    FormVenda.Align := alClient;
    FormVenda.Show;
  except
    FormVenda.Free;
    raise;
  end;
end;



end.
