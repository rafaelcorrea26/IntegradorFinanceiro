program IntegradorFinanceiro;

uses
  Vcl.Forms,
  fModoADM in 'View\fModoADM.pas' {frmModoADM},
  fPrincipal in 'View\fPrincipal.pas' {frmPrincipal},
  uAuthentication in 'httpClient\uAuthentication.pas',
  uConnectionRest in 'httpClient\uConnectionRest.pas',
  uToken in 'httpClient\uToken.pas',
  uInterfacesAPI in 'Interfaces\uInterfacesAPI.pas',
  uInterfacesEntity in 'Interfaces\uInterfacesEntity.pas',
  uInterfacesHttp in 'Interfaces\uInterfacesHttp.pas',
  uFunctions in 'Shared\uFunctions.pas',
  uMessages in 'Shared\uMessages.pas',
  uSettings in 'Shared\uSettings.pas',
  uTypeAuth in 'Shared\Types\uTypeAuth.pas',
  uTypeService in 'Shared\Types\uTypeService.pas',
  uQuery in 'Model\uQuery.pas',
  uConnection in 'Model\uConnection.pas',
  uTypeFormaPagamento in 'Shared\Types\uTypeFormaPagamento.pas',
  uBancoDAO in 'Model\DAO\uBancoDAO.pas',
  uCidadeDAO in 'Model\DAO\uCidadeDAO.pas',
  uClienteDAO in 'Model\DAO\uClienteDAO.pas',
  uContasPagarDAO in 'Model\DAO\uContasPagarDAO.pas',
  uContasReceberDAO in 'Model\DAO\uContasReceberDAO.pas',
  uFormaPagamentoDAO in 'Model\DAO\uFormaPagamentoDAO.pas',
  uFornecedorDAO in 'Model\DAO\uFornecedorDAO.pas',
  uVendedorDAO in 'Model\DAO\uVendedorDAO.pas',
  uBanco in 'Model\Entity\uBanco.pas',
  uCidade in 'Model\Entity\uCidade.pas',
  uCliente in 'Model\Entity\uCliente.pas',
  uContasPagar in 'Model\Entity\uContasPagar.pas',
  uContasReceber in 'Model\Entity\uContasReceber.pas',
  uFormaPagamento in 'Model\Entity\uFormaPagamento.pas',
  uFornecedor in 'Model\Entity\uFornecedor.pas',
  uVendedor in 'Model\Entity\uVendedor.pas',
  uConta in 'Model\Entity\uConta.pas',
  uContaDAO in 'Model\DAO\uContaDAO.pas',
  uContador in 'Shared\uContador.pas',
  fAvisos in 'View\fAvisos.pas' {frmAvisos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
