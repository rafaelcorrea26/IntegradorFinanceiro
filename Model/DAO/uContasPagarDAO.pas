unit uContasPagarDAO;

interface

uses
  FireDAC.Comp.Client,
  System.SysUtils,
  System.StrUtils,
  uConnection,
  uQuery,
  System.DateUtils,
  uContasPagar,
  uInterfacesEntity,
  uFunctions,
  uFornecedorDAO,
  uVendedorDAO,
  uBancoDAO,
  uFormaPagamentoDAO,
  REST.JSON.Types,
  uConnectionRest,
  System.JSON,
  uToken,
  uTypeService,
  REST.Types,
  System.IniFiles,
  Vcl.Forms,
  System.Math,
  uSettings,
  uMessages,
  Vcl.Dialogs,
  uContaDAO,
  uContador;

type
  TContasPagarDAO = class(TInterfacedObject, iContasPagarDAO)
  private
  public
    // CRUD
    class function Limpar(pContasPagar: TContasPagar): boolean;
    class function Carrega(pContasPagar: TContasPagar): boolean;
    class function Incluir(pContasPagar: TContasPagar; pCommit: boolean = true): boolean;
    class function Alterar(pContasPagar: TContasPagar; pCommit: boolean = true): boolean;
    class function Excluir(pTitulo: string; pCommit: boolean = true): boolean;
    class function ExcluirPeloTituloEmpresa(pTituloEmpresa: String; pCommit: boolean = true): boolean;
    class function IncluirOuAltera(pContasPagar: TContasPagar; pCommit: boolean = true): String;

    // func aux e de buscas
    class function ExisteEmpresaTitulo(pTitulo: string): boolean;
    class function RetornaTituloPeloTituloEmpresa(pTituloEmp: String): string;
    class function GeraProximoTituloIntegracao: string;
    class function GeraProximoCodigo: Integer;
    class function Existe(pTitulo: string): boolean;

    // http
    class function Get(pAll: boolean = false): boolean;
    class function Delete(pTitulo, pData: string): boolean;
    class function Put(pTitulo: string; lNovaData: TDateTime; pContasPagar: TContasPagar): boolean;
    class function Post(pTitulo: string; lNovaData: TDateTime; pContasPagar: TContasPagar): boolean;

    // Monta objetos GET
    class function MontaObjetoContasPagar(pJson: TJSONObject; pContasPagar: TContasPagar): boolean;
    class function MontaObjetoVendedorContasPagar(pJson: TJSONObject; pContasPagar: TContasPagar): boolean;
    class function MontaObjetoFornecedorContasPagar(pJson: TJSONObject; pContasPagar: TContasPagar): boolean;
    class function MontaObjetoBancoCobrancaContasPagar(pJson: TJSONObject; pContasPagar: TContasPagar): boolean;
    class function MontaObjetoBancoPagamentoContasPagar(pJson: TJSONObject; pContasPagar: TContasPagar): boolean;
    class function MontaObjetoFormaPagamentoContasPagar(pJson: TJSONObject; pContasPagar: TContasPagar): boolean;
    class function MontaObjetoFormaPagamentoBaixarContasPagar(pJson: TJSONObject; pContasPagar: TContasPagar): boolean;

  end;

implementation

{ TContasPagarDAO }

class function TContasPagarDAO.Alterar(pContasPagar: TContasPagar; pCommit: boolean = true): boolean;
var
  lQuery: Tquery;
begin

  try
    lQuery := Tquery.Create(nil);
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' UPDATE MC08CPAG SET                          ');
      lQuery.SQL.Add('   AC08EMPRESA = :AC08EMPRESA                 ');
      lQuery.SQL.Add(' , AD08EMISSAO = :AD08EMISSAO                 ');
      lQuery.SQL.Add(' , AN08FORNEC = :AN08FORNEC                   ');
      lQuery.SQL.Add(' , AN08VALOR = :AN08VALOR                     ');
      lQuery.SQL.Add(' , AD08VCTO = :AD08VCTO                       ');
      lQuery.SQL.Add(' , AD08FLUXO = :AD08FLUXO                     ');
      lQuery.SQL.Add(' , AC08BCOR = :AC08BCOR                       ');
      lQuery.SQL.Add(' , AC08BCPG = :AC08BCPG                       ');
      lQuery.SQL.Add(' , AC08SIT = :AC08SIT                         ');
      lQuery.SQL.Add(' , AC08FRPGTO = :AC08FRPGTO                   ');
      lQuery.SQL.Add(' , AN08JUROS = :AN08JUROS                     ');
      lQuery.SQL.Add(' , AN08DESC = :AN08DESC                       ');
      lQuery.SQL.Add(' , AD08DTPGTO = :AD08DTPGTO                   ');
      lQuery.SQL.Add(' , AN08VLPAGO = :AN08VLPAGO                   ');
      lQuery.SQL.Add(' , AN08TOTALPAGO = :AN08TOTALPAGO             ');
      lQuery.SQL.Add(' , AC08DHCAD = :AC08DHCAD                     ');
      lQuery.SQL.Add(' , AC08DHPGTO = :AC08DHPGTO                   ');
      lQuery.SQL.Add(' , AC08USUCAD = :AC08USUCAD                   ');
      lQuery.SQL.Add(' , AC08USUPGTO = :AC08USUPGTO                 ');
      lQuery.SQL.Add(' , AC08DHALT = :AC08DHALT                     ');
      lQuery.SQL.Add(' , AC08USUALT = :AC08USUALT                   ');
      lQuery.SQL.Add(' , AC08ORIG = :AC08ORIG                       ');
      lQuery.SQL.Add(' , AN089DESC = :AN089DESC                     ');
      lQuery.SQL.Add(' , AC08_ANO = :AC08_ANO                       ');
      lQuery.SQL.Add(' , AC08_MES = :AC08_MES                       ');
      lQuery.SQL.Add(' , AC08_OBS1 = :AC08_OBS1                     ');
      lQuery.SQL.Add(' , AC08_OBS2 = :AC08_OBS2                     ');
      lQuery.SQL.Add(' , AC08_PARCIAL = :AC08_PARCIAL               ');
      lQuery.SQL.Add(' , AN08_EMPRESA = :AN08_EMPRESA               ');
      lQuery.SQL.Add(' , AC08_CTA = :AC08_CTA                       ');
      lQuery.SQL.Add(' , AC08_COD_BARRAS = :AC08_COD_BARRAS         ');
      lQuery.SQL.Add(' , AC08FRPGTO_BAIXARCP = :AC08FRPGTO_BAIXARCP ');
      lQuery.SQL.Add(' , AC08EMP_TIT = :AC08EMP_TIT                 ');
      lQuery.SQL.Add(' where (AC08TIT = :AC08TIT)                   ');
      lQuery.ParamByName('AC08TIT').AsString := copy(pContasPagar.Titulo, 1, 16);
      lQuery.ParamByName('AC08EMPRESA').AsInteger := pContasPagar.Empresa;
      lQuery.ParamByName('AD08EMISSAO').AsDate := strtodatedef(pContasPagar.data_hora_cadastro, now);
      lQuery.ParamByName('AN08FORNEC').AsInteger := pContasPagar.Fornecedor.codigo;
      lQuery.ParamByName('AN08VALOR').asfloat := pContasPagar.Valor;
      lQuery.ParamByName('AD08VCTO').AsDate := strtodatedef(pContasPagar.Vencimento, now);
      lQuery.ParamByName('AD08FLUXO').AsDate := strtodatedef(pContasPagar.Fluxo_Caixa, now);
      lQuery.ParamByName('AC08BCOR').AsString := pContasPagar.Banco_Cobranca.codigo;
      lQuery.ParamByName('AC08BCPG').AsString := pContasPagar.Banco_Pagamento.codigo;
      lQuery.ParamByName('AC08SIT').AsString := copy(pContasPagar.Situacao, 1, 1);
      lQuery.ParamByName('AC08FRPGTO').AsInteger := pContasPagar.Forma_Pagamento.codigo;
      lQuery.ParamByName('AN08JUROS').asfloat := pContasPagar.Juros;
      lQuery.ParamByName('AN08DESC').asfloat := pContasPagar.Desconto;
      lQuery.ParamByName('AD08DTPGTO').AsDate := strtodatedef(pContasPagar.Data_Pagamento, now);
      lQuery.ParamByName('AN08VLPAGO').asfloat := pContasPagar.Valor_Pago;
      lQuery.ParamByName('AN08TOTALPAGO').asfloat := pContasPagar.Total_Pago;
      lQuery.ParamByName('AC08DHCAD').AsDate := strtodatedef(pContasPagar.data_hora_cadastro, now);
      lQuery.ParamByName('AC08DHPGTO').AsDate := StrToDateTimedef(pContasPagar.Data_Hora_Pagamento, now);
      lQuery.ParamByName('AC08USUCAD').AsInteger := pContasPagar.Usuario_Cadastro;
      lQuery.ParamByName('AC08USUPGTO').AsInteger := pContasPagar.Usuario_Pagamento;
      lQuery.ParamByName('AC08DHALT').AsDate := strtodatedef(pContasPagar.Data_Hora_Alteracao, now);
      lQuery.ParamByName('AC08USUALT').AsInteger := pContasPagar.Usuario_Alteracao;
      lQuery.ParamByName('AC08ORIG').AsString := copy(pContasPagar.Origem, 1, 2);
      lQuery.ParamByName('AC08_ANO').AsString := copy(pContasPagar.Ano, 1, 4);
      lQuery.ParamByName('AC08_MES').AsString := copy(pContasPagar.Mes, 1, 2);
      lQuery.ParamByName('AC08_OBS1').AsString := copy(pContasPagar.OBS1, 1, 50);
      lQuery.ParamByName('AC08_OBS2').AsString := copy(pContasPagar.OBS2, 1, 50);
      lQuery.ParamByName('AC08_PARCIAL').AsString := copy(pContasPagar.Parcial, 1, 1);
      lQuery.ParamByName('AN08_EMPRESA').AsInteger := pContasPagar.Empresa;
      lQuery.ParamByName('AC08_CTA').AsString := copy(pContasPagar.Conta, 1, 3);
      lQuery.ParamByName('AC08_COD_BARRAS').AsString := copy(pContasPagar.Codigo_Barras, 1, 50);
      lQuery.ParamByName('AC08FRPGTO_BAIXARCP').AsInteger := pContasPagar.Forma_Pagamento_Baixar.codigo;
      lQuery.ParamByName('AC08EMP_TIT').AsString := copy(pContasPagar.Empresa_Titulo, 1, 30);
      lQuery.ExecSQL;
      lQuery.Connection.commit;
    finally
      lQuery.Free;
    end;

  except
    on E: Exception do
    begin

    end;
  end;

end;

class function TContasPagarDAO.Carrega(pContasPagar: TContasPagar): boolean;
var
  lQuery: Tquery;
  lFornecOk, lVendOk, lFormaPagaOk, lFormaPagBaixarOk, lBancoCobOk, lBancoPagOk: boolean;
begin
  result := false;

  lQuery := Tquery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' select * from MC08CPAG                          ');
    lQuery.SQL.Add(' left join TBL_CONFIGURACAO_FIN                  ');
    lQuery.SQL.Add(' on ID = 1                                       ');
    lQuery.SQL.Add(' where AC08TIT = :AC08TIT                        ');
    lQuery.ParamByName('AC08TIT').AsString := pContasPagar.Titulo;
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      // carrega dados
      pContasPagar.Titulo := lQuery.FieldByName('AC08TIT').AsString;
      pContasPagar.chave_empresa := lQuery.FieldByName('CHAVE_EMPRESA').AsString;
      pContasPagar.data_ultimo_sincronismo := lQuery.FieldByName('ULTIMA_SINC_CP').AsString;
      pContasPagar.Empresa := lQuery.FieldByName('AC08EMPRESA').AsInteger;
      pContasPagar.emissao := tfunctions.DecodeDateHourJson(lQuery.FieldByName('AD08EMISSAO').AsDateTime);
      pContasPagar.Valor := RoundTo(lQuery.FieldByName('AN08VALOR').asfloat, -2);
      pContasPagar.Vencimento := tfunctions.DecodeDateJson(lQuery.FieldByName('AD08VCTO').AsDateTime);
      pContasPagar.Fluxo_Caixa := tfunctions.DecodeDateJson(lQuery.FieldByName('AD08FLUXO').AsDateTime);
      pContasPagar.Situacao := lQuery.FieldByName('AC08SIT').AsString;
      pContasPagar.Juros := RoundTo(lQuery.FieldByName('AN08JUROS').asfloat, -2);
      pContasPagar.Desconto := RoundTo(lQuery.FieldByName('AN08DESC').asfloat, -2);
      pContasPagar.Data_Pagamento := tfunctions.DecodeDateHourJson((lQuery.FieldByName('AD08DTPGTO').AsDateTime));
      pContasPagar.Valor_Pago := RoundTo(lQuery.FieldByName('AN08VLPAGO').asfloat, -2);
      pContasPagar.Total_Pago := RoundTo(lQuery.FieldByName('AN08TOTALPAGO').asfloat, -2);
      pContasPagar.data_hora_cadastro := tfunctions.DecodeDateHourJson(lQuery.FieldByName('AC08DHCAD').AsDateTime);
      pContasPagar.Data_Hora_Pagamento := tfunctions.DecodeDateHourJson(lQuery.FieldByName('AC08DHPGTO').AsDateTime);
      pContasPagar.Usuario_Cadastro := lQuery.FieldByName('AC08USUCAD').AsInteger;
      pContasPagar.Usuario_Pagamento := lQuery.FieldByName('AC08USUPGTO').AsInteger;
      pContasPagar.Data_Hora_Alteracao := tfunctions.DecodeDateHourJson(lQuery.FieldByName('AC08DHALT').AsDateTime);
      pContasPagar.Usuario_Alteracao := lQuery.FieldByName('AC08USUALT').AsInteger;
      pContasPagar.Origem := lQuery.FieldByName('AC08ORIG').AsString;
      pContasPagar.Ano := lQuery.FieldByName('AC08_ANO').AsString;
      pContasPagar.Mes := lQuery.FieldByName('AC08_MES').AsString;
      pContasPagar.OBS1 := lQuery.FieldByName('AC08_OBS1').AsString;
      pContasPagar.OBS2 := lQuery.FieldByName('AC08_OBS2').AsString;
      pContasPagar.Parcial := lQuery.FieldByName('AC08_PARCIAL').AsString;
      pContasPagar.Empresa := lQuery.FieldByName('AN08_EMPRESA').AsInteger;
      pContasPagar.Conta := lQuery.FieldByName('AC08_CTA').AsString;
      pContasPagar.Codigo_Barras := lQuery.FieldByName('AC08_COD_BARRAS').AsString;

      // Carrega
      pContasPagar.Fornecedor.codigo := lQuery.FieldByName('AN08FORNEC').AsInteger;
      lFornecOk := TfornecedorDAO.Carrega(pContasPagar.Fornecedor);

      pContasPagar.vendedor.codigo := lQuery.FieldByName('AN08VEND').AsInteger;
      lVendOk := TVendedorDAO.Carrega(pContasPagar.vendedor);

      pContasPagar.Forma_Pagamento.codigo := lQuery.FieldByName('AC08FRPGTO').AsInteger;
      lFormaPagaOk := TFormaPagamentoDAO.Carrega(pContasPagar.Forma_Pagamento);

      pContasPagar.Forma_Pagamento_Baixar.codigo := lQuery.FieldByName('AC08FRPGTO_BAIXARCP').AsInteger;
      lFormaPagBaixarOk := TFormaPagamentoDAO.Carrega(pContasPagar.Forma_Pagamento_Baixar);

      pContasPagar.Banco_Cobranca.codigo := lQuery.FieldByName('AC08BCOR').AsString;
      lBancoCobOk := TBancoDAO.Carrega(pContasPagar.Banco_Cobranca);

      pContasPagar.Banco_Pagamento.codigo := lQuery.FieldByName('AC08BCPG').AsString;
      lBancoPagOk := TBancoDAO.Carrega(pContasPagar.Banco_Pagamento);
    end;
  finally
    lQuery.Free;
  end;
end;

class function TContasPagarDAO.Delete(pTitulo, pData: string): boolean;
var
  lHttp: TConnectionRest;
  lJson: string;

  function Tratamento: boolean;
  begin
    if (copy(IntToStr(lHttp.RestResponse.StatusCode), 1)) = '2' then
    begin
      TMessages.Messages.MessageOk := TMessages.Messages.MessageOk +
        ('DELETE - Contas Pagar: ' + pTitulo + ' - ' + DateTimeToStr(tfunctions.DateServer) + sLineBreak);
      result := true;
    end
    else
    begin
      result := false;
    end;
  end;

begin

  lHttp := TConnectionRest.Create;
  try
    lJson := '{"titulo":"' + pTitulo + '", "data_ultima_alteracao":"' + pData + '"}';
    lHttp.ConfigureRest(rmDELETE, tDeleteCP, lJson);
    result := Tratamento;
  finally
    lHttp.Free;
  end;

end;

class function TContasPagarDAO.Limpar(pContasPagar: TContasPagar): boolean;
begin
  pContasPagar.Titulo := EmptyStr;
  pContasPagar.Empresa := 0;
  pContasPagar.emissao := EmptyStr;
  pContasPagar.Valor := 0;
  pContasPagar.Vencimento := EmptyStr;
  pContasPagar.Fluxo_Caixa := EmptyStr;
  pContasPagar.Situacao := 'N';
  pContasPagar.Juros := 0;
  pContasPagar.Desconto := 0;
  pContasPagar.Data_Pagamento := EmptyStr;
  pContasPagar.Valor_Pago := 0;
  pContasPagar.Total_Pago := 0;
  pContasPagar.data_hora_cadastro := EmptyStr;
  pContasPagar.Data_Hora_Pagamento := EmptyStr;
  pContasPagar.Usuario_Cadastro := 0;
  pContasPagar.Usuario_Pagamento := 0;
  pContasPagar.Data_Hora_Alteracao := EmptyStr;
  pContasPagar.Usuario_Alteracao := 0;
  pContasPagar.Origem := EmptyStr;
  pContasPagar.Ano := EmptyStr;
  pContasPagar.Mes := EmptyStr;
  pContasPagar.OBS1 := EmptyStr;
  pContasPagar.OBS2 := EmptyStr;
  pContasPagar.Parcial := EmptyStr;
  pContasPagar.Conta := EmptyStr;
  pContasPagar.Codigo_Barras := EmptyStr;
  pContasPagar.Empresa_Titulo := EmptyStr;
  pContasPagar.data_ultimo_sincronismo := EmptyStr;
end;

class function TContasPagarDAO.MontaObjetoBancoCobrancaContasPagar(pJson: TJSONObject;
  pContasPagar: TContasPagar): boolean;
var
  lJsonArray: TJSONArray;
  lJsonCob: TJSONObject;
begin
  try
    if not tfunctions.ObjectIsNull('banco_cobranca', pJson.ToString) then
    begin

      lJsonCob := pJson.GetValue<TJSONObject>('banco_cobranca') as TJSONObject;

      if tfunctions.ColumnExists('codigo', lJsonCob.ToString) and (lJsonCob.GetValue<String>('codigo') <> '') then
      begin
        pContasPagar.Banco_Cobranca.codigo := lJsonCob.GetValue<String>('codigo');
      end;

      if tfunctions.ColumnExists('banco', lJsonCob.ToString) and (lJsonCob.GetValue<String>('banco') <> '') then
      begin
        pContasPagar.Banco_Cobranca.banco := lJsonCob.GetValue<String>('banco');
      end;

      if tfunctions.ColumnExists('arquivo', lJsonCob.ToString) and (lJsonCob.GetValue<String>('arquivo') <> '') then
      begin
        pContasPagar.Banco_Cobranca.arquivo := lJsonCob.GetValue<String>('arquivo');
      end;

      if tfunctions.ColumnExists('local', lJsonCob.ToString) and (lJsonCob.GetValue<String>('local') <> '') then
      begin
        pContasPagar.Banco_Cobranca.local := lJsonCob.GetValue<String>('local');
      end;

      if tfunctions.ColumnExists('numero_arquivo', lJsonCob.ToString) and
        (lJsonCob.GetValue<String>('numero_arquivo') <> '') then
      begin
        pContasPagar.Banco_Cobranca.numero_arquivo := lJsonCob.GetValue<String>('numero_arquivo');
      end;

      if tfunctions.ColumnExists('digito_banco', lJsonCob.ToString) and (lJsonCob.GetValue<String>('digito_banco') <> '')
      then
      begin
        pContasPagar.Banco_Cobranca.digito_banco := lJsonCob.GetValue<String>('digito_banco');
      end;

      if tfunctions.ColumnExists('data_hora_arquivo_sn', lJsonCob.ToString) and
        (lJsonCob.GetValue<String>('data_hora_arquivo_sn') <> '') then
      begin
        pContasPagar.Banco_Cobranca.data_hora_arquivo_sn := lJsonCob.GetValue<String>('data_hora_arquivo_sn');
      end;

      if TBancoDAO.Existe(pContasPagar.Banco_Cobranca) then
      begin
        TBancoDAO.Alterar(pContasPagar.Banco_Cobranca);
      end
      else
      begin
        TBancoDAO.Incluir(pContasPagar.Banco_Cobranca);
      end;
      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCP := false;
    end;
  end;
end;

class function TContasPagarDAO.MontaObjetoBancoPagamentoContasPagar(pJson: TJSONObject;
  pContasPagar: TContasPagar): boolean;
var
  lJsonArray: TJSONArray;
  lJsonPag: TJSONObject;
begin
  try
    if not tfunctions.ObjectIsNull('banco_pagamento', pJson.ToString) then
    begin
      lJsonPag := pJson.GetValue<TJSONObject>('banco_pagamento') as TJSONObject;

      if tfunctions.ColumnExists('codigo', lJsonPag.ToString) and (lJsonPag.GetValue<String>('codigo') <> '') then
      begin
        pContasPagar.Banco_Pagamento.codigo := lJsonPag.GetValue<String>('codigo');
      end;
      if tfunctions.ColumnExists('banco', lJsonPag.ToString) and (lJsonPag.GetValue<String>('banco') <> '') then
      begin
        pContasPagar.Banco_Pagamento.banco := lJsonPag.GetValue<String>('banco');
      end;
      if tfunctions.ColumnExists('arquivo', lJsonPag.ToString) and (lJsonPag.GetValue<String>('arquivo') <> '') then
      begin
        pContasPagar.Banco_Pagamento.arquivo := lJsonPag.GetValue<String>('arquivo');
      end;
      if tfunctions.ColumnExists('local', lJsonPag.ToString) and (lJsonPag.GetValue<String>('local') <> '') then
      begin
        pContasPagar.Banco_Pagamento.local := lJsonPag.GetValue<String>('local');
      end;
      if tfunctions.ColumnExists('numero_arquivo', lJsonPag.ToString) and
        (lJsonPag.GetValue<String>('numero_arquivo') <> '') then
      begin
        pContasPagar.Banco_Pagamento.numero_arquivo := lJsonPag.GetValue<String>('numero_arquivo');
      end;
      if tfunctions.ColumnExists('digito_banco', lJsonPag.ToString) and (lJsonPag.GetValue<String>('digito_banco') <> '')
      then
      begin
        pContasPagar.Banco_Pagamento.digito_banco := lJsonPag.GetValue<String>('digito_banco');
      end;
      if tfunctions.ColumnExists('data_hora_arquivo_sn', lJsonPag.ToString) and
        (lJsonPag.GetValue<String>('data_hora_arquivo_sn') <> '') then
      begin
        pContasPagar.Banco_Pagamento.data_hora_arquivo_sn := lJsonPag.GetValue<String>('data_hora_arquivo_sn');
      end;

      if TBancoDAO.Existe(pContasPagar.Banco_Pagamento) then
      begin
        TBancoDAO.Alterar(pContasPagar.Banco_Pagamento);
      end
      else
      begin
        TBancoDAO.Incluir(pContasPagar.Banco_Pagamento);
      end;
      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCP := false;
    end;
  end;
end;

class function TContasPagarDAO.MontaObjetoContasPagar(pJson: TJSONObject; pContasPagar: TContasPagar): boolean;
begin
  try
    if tfunctions.ColumnExists('titulo', pJson.ToString) and (pJson.GetValue<String>('titulo') <> '') then
    begin
      pContasPagar.Empresa_Titulo := pJson.GetValue<String>('titulo');
    end;

    if tfunctions.ColumnExists('chave_empresa', pJson.ToString) and (pJson.GetValue<String>('chave_empresa') <> '') then
    begin
      pContasPagar.chave_empresa := pJson.GetValue<String>('chave_empresa');
    end;

    if tfunctions.ColumnExists('emissao', pJson.ToString) and (pJson.GetValue<String>('emissao') <> '') then
    begin
      pContasPagar.emissao := pJson.GetValue<String>('emissao');
    end;

    if tfunctions.ColumnExists('empresa', pJson.ToString) and (pJson.GetValue<String>('empresa') <> '') then
    begin
      pContasPagar.Empresa := pJson.GetValue<Integer>('empresa');
    end;

    if tfunctions.ColumnExists('valor', pJson.ToString) and (pJson.GetValue<String>('valor') <> '') then
    begin
      pContasPagar.Valor := pJson.GetValue<Double>('valor');
    end;

    if tfunctions.ColumnExists('vencimento', pJson.ToString) and (pJson.GetValue<String>('vencimento') <> '') then
    begin
      pContasPagar.Vencimento := pJson.GetValue<String>('vencimento');
    end;

    if tfunctions.ColumnExists('fluxo_caixa', pJson.ToString) and (pJson.GetValue<String>('fluxo_caixa') <> '') then
    begin
      pContasPagar.Fluxo_Caixa := pJson.GetValue<String>('fluxo_caixa');
    end;

    if tfunctions.ColumnExists('situacao', pJson.ToString) and (pJson.GetValue<String>('situacao') <> '') then
    begin
      pContasPagar.Situacao := pJson.GetValue<String>('situacao');
    end;

    if tfunctions.ColumnExists('juros', pJson.ToString) and (pJson.GetValue<String>('juros') <> '') then
    begin
      pContasPagar.Juros := pJson.GetValue<Double>('juros');
    end;

    if tfunctions.ColumnExists('desconto', pJson.ToString) and (pJson.GetValue<String>('desconto') <> '') then
    begin
      pContasPagar.Desconto := pJson.GetValue<Double>('desconto');
    end;

    if tfunctions.ColumnExists('data_pagamento', pJson.ToString) and (pJson.GetValue<String>('data_pagamento') <> '')
    then
    begin
      pContasPagar.Data_Pagamento := pJson.GetValue<String>('data_pagamento');
    end;

    if tfunctions.ColumnExists('valor_pago', pJson.ToString) and (pJson.GetValue<String>('valor_pago') <> '') then
    begin
      pContasPagar.Valor_Pago := pJson.GetValue<Double>('valor_pago');
    end;

    if tfunctions.ColumnExists('total_pago', pJson.ToString) and (pJson.GetValue<String>('total_pago') <> '') then
    begin
      pContasPagar.Total_Pago := pJson.GetValue<Double>('total_pago');
    end;

    if tfunctions.ColumnExists('data_hora_cadastro', pJson.ToString) and
      (pJson.GetValue<String>('data_hora_cadastro') <> '') then
    begin
      pContasPagar.data_hora_cadastro := pJson.GetValue<String>('data_hora_cadastro');
    end;

    if tfunctions.ColumnExists('data_hora_pagamento', pJson.ToString) and
      (pJson.GetValue<String>('data_hora_pagamento') <> '') then
    begin
      pContasPagar.Data_Hora_Pagamento := pJson.GetValue<String>('data_hora_pagamento');
    end;

    if tfunctions.ColumnExists('usuario_cadastro', pJson.ToString) and (pJson.GetValue<String>('usuario_cadastro') <> '')
    then
    begin
      pContasPagar.Usuario_Cadastro := pJson.GetValue<Integer>('usuario_cadastro');
    end;

    if tfunctions.ColumnExists('usuario_pagamento', pJson.ToString) and
      (pJson.GetValue<String>('usuario_pagamento') <> '') then
    begin
      pContasPagar.Usuario_Pagamento := pJson.GetValue<Integer>('usuario_pagamento');
    end;

    if tfunctions.ColumnExists('data_hora_alteracao', pJson.ToString) and
      (pJson.GetValue<String>('data_hora_alteracao') <> '') then
    begin
      pContasPagar.Data_Hora_Alteracao := pJson.GetValue<String>('data_hora_alteracao');
    end;

    if tfunctions.ColumnExists('usuario_alteracao', pJson.ToString) and
      (pJson.GetValue<String>('usuario_alteracao') <> '') then
    begin
      pContasPagar.Usuario_Alteracao := pJson.GetValue<Integer>('usuario_alteracao');
    end;

    if tfunctions.ColumnExists('origem', pJson.ToString) and (pJson.GetValue<String>('origem') <> '') then
    begin
      pContasPagar.Origem := pJson.GetValue<String>('origem');
    end;

    if tfunctions.ColumnExists('ano', pJson.ToString) and (pJson.GetValue<String>('ano') <> '') then
    begin
      pContasPagar.Ano := pJson.GetValue<String>('ano');
    end;

    if tfunctions.ColumnExists('mes', pJson.ToString) and (pJson.GetValue<String>('mes') <> '') then
    begin
      pContasPagar.Mes := pJson.GetValue<String>('mes');
    end;

    if tfunctions.ColumnExists('obs1', pJson.ToString) and (pJson.GetValue<String>('obs1') <> '') then
    begin
      pContasPagar.OBS1 := pJson.GetValue<String>('obs1');
    end;

    if tfunctions.ColumnExists('obs2', pJson.ToString) and (pJson.GetValue<String>('obs2') <> '') then
    begin
      pContasPagar.OBS2 := pJson.GetValue<String>('obs2');
    end;

    if tfunctions.ColumnExists('parcial', pJson.ToString) and (pJson.GetValue<String>('parcial') <> '') then
    begin
      pContasPagar.Parcial := pJson.GetValue<String>('parcial');
    end;

    if tfunctions.ColumnExists('conta', pJson.ToString) and (pJson.GetValue<String>('conta') <> '') then
    begin
      pContasPagar.Conta := pJson.GetValue<String>('conta');
    end;

    if tfunctions.ColumnExists('codigo_barras', pJson.ToString) and (pJson.GetValue<String>('codigo_barras') <> '') then
    begin
      pContasPagar.Codigo_Barras := pJson.GetValue<String>('codigo_barras');
    end;
    // if pJson.GetValue<String>('data_ultimo_sincronismo') <> '' then
    // begin
    // pContasPagar. := pJson.GetValue<String>('data_ultimo_sincronismo');
    // end;

    result := true;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCP := false;
    end;
  end;
end;

class function TContasPagarDAO.MontaObjetoFormaPagamentoBaixarContasPagar(pJson: TJSONObject;
  pContasPagar: TContasPagar): boolean;
var
  lJsonArray: TJSONArray;
  lJsonFPagB: TJSONObject;
  lJsonBanco: TJSONObject;
begin
  try
    if not tfunctions.ObjectIsNull('forma_pagamento_baixar', pJson.ToString) then
    begin
      lJsonFPagB := pJson.GetValue<TJSONObject>('forma_pagamento_baixar') as TJSONObject;

      if tfunctions.ColumnExists('codigo', lJsonFPagB.ToString) and (lJsonFPagB.GetValue<String>('codigo') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.codigo := lJsonFPagB.GetValue<Integer>('codigo');
      end;

      if tfunctions.ColumnExists('descricao', lJsonFPagB.ToString) and (lJsonFPagB.GetValue<String>('descricao') <> '')
      then
      begin
        pContasPagar.Forma_Pagamento_Baixar.descricao := lJsonFPagB.GetValue<String>('descricao');
      end;

      if tfunctions.ColumnExists('tipo', lJsonFPagB.ToString) and (lJsonFPagB.GetValue<String>('tipo') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.tipo := lJsonFPagB.GetValue<String>('tipo');
      end;

      if tfunctions.ColumnExists('codigo_ecf', lJsonFPagB.ToString) and (lJsonFPagB.GetValue<String>('codigo_ecf') <> '')
      then
      begin
        pContasPagar.Forma_Pagamento_Baixar.codigo_ecf := lJsonFPagB.GetValue<String>('codigo_ecf');
      end;

      if tfunctions.ColumnExists('origem', lJsonFPagB.ToString) and (lJsonFPagB.GetValue<String>('origem') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.Origem := lJsonFPagB.GetValue<String>('origem');
      end;

      if tfunctions.ColumnExists('nome_fiscal', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('nome_fiscal') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.nome_fiscal := lJsonFPagB.GetValue<String>('nome_fiscal');
      end;

      if tfunctions.ColumnExists('permite_desconto', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('permite_desconto') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.permite_desconto := lJsonFPagB.GetValue<String>('permite_desconto');
      end;

      if tfunctions.ColumnExists('tipo_da_comissao', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('tipo_da_comissao') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.tipo_da_comissao := lJsonFPagB.GetValue<String>('tipo_da_comissao');
      end;

      if tfunctions.ColumnExists('tipo_de_movimentacao', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('tipo_de_movimentacao') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.tipo_de_movimentacao := lJsonFPagB.GetValue<String>('tipo_de_movimentacao');
      end;
      if tfunctions.ColumnExists('qtde_dias_para_primeiro_vencimento', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('qtde_dias_para_primeiro_vencimento') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.qtde_dias_para_primeiro_vencimento :=
          lJsonFPagB.GetValue<Integer>('qtde_dias_para_primeiro_vencimento');
      end;
      if tfunctions.ColumnExists('agrupar', lJsonFPagB.ToString) and (lJsonFPagB.GetValue<String>('agrupar') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.agrupar := lJsonFPagB.GetValue<String>('agrupar');
      end;
      if tfunctions.ColumnExists('multiplas_formas_de_pagamento', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('multiplas_formas_de_pagamento') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.multiplas_formas_de_pagamento :=
          lJsonFPagB.GetValue<String>('multiplas_formas_de_pagamento');
      end;
      if tfunctions.ColumnExists('forma_de_fechamento', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('forma_de_fechamento') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.forma_de_fechamento := lJsonFPagB.GetValue<Integer>('forma_de_fechamento');
      end;
      if tfunctions.ColumnExists('imprimir_boleto', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('imprimir_boleto') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.imprimir_boleto := lJsonFPagB.GetValue<String>('imprimir_boleto');
      end;
      if tfunctions.ColumnExists('lancar_no_caixa', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('lancar_no_caixa') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.lancar_no_caixa := lJsonFPagB.GetValue<String>('lancar_no_caixa');
      end;
      if tfunctions.ColumnExists('banco_de_lancamento_no_caixa', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('banco_de_lancamento_no_caixa') <> '') then
      begin
        pContasPagar.Forma_Pagamento_Baixar.banco_de_lancamento_no_caixa :=
          lJsonFPagB.GetValue<Integer>('banco_de_lancamento_no_caixa');
      end;

      if not tfunctions.ObjectIsNull('conta_de_lancamento_no_caixa', pJson.ToString) then
      begin

        if tfunctions.ColumnExists('conta_de_lancamento_no_caixa', lJsonFPagB.ToString) then
        begin
          lJsonBanco := lJsonFPagB.GetValue<TJSONObject>('conta_de_lancamento_no_caixa') as TJSONObject;

          if tfunctions.ColumnExists('codigo', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('codigo') <> '')
          then
          begin
            pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.codigo :=
              lJsonBanco.GetValue<String>('codigo');
          end;

          if tfunctions.ColumnExists('nome', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('nome') <> '') then
          begin
            pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.nome :=
              lJsonBanco.GetValue<String>('nome');
          end;

          if tfunctions.ColumnExists('tipo', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('tipo') <> '') then
          begin
            pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.tipo :=
              lJsonBanco.GetValue<String>('tipo');
          end;

          if tfunctions.ColumnExists('centro_custo', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('centro_custo') <> '') then
          begin
            pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.centro_custo :=
              lJsonBanco.GetValue<String>('centro_custo');
          end;

          if tfunctions.ColumnExists('duplicar', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('duplicar') <> '')
          then
          begin
            pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.duplicar :=
              lJsonBanco.GetValue<String>('duplicar');
          end;

          if tfunctions.ColumnExists('caixa_dest', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('caixa_dest') <> '') then
          begin
            pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.caixa_dest :=
              lJsonBanco.GetValue<String>('caixa_dest');
          end;

          if tfunctions.ColumnExists('historico', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('historico') <> '') then
          begin
            pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.historico :=
              lJsonBanco.GetValue<String>('historico');
          end;

          if tfunctions.ColumnExists('dre', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('dre') <> '') then
          begin
            pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.dre := lJsonBanco.GetValue<String>('dre');
          end;

          if tfunctions.ColumnExists('nivel_dre', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('nivel_dre') <> '') then
          begin
            pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.nivel_dre :=
              lJsonBanco.GetValue<Integer>('nivel_dre');
          end;

          if tfunctions.ColumnExists('tipo_custo', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('tipo_custo') <> '') then
          begin
            pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.tipo_custo :=
              lJsonBanco.GetValue<String>('tipo_custo');
          end;

          if tfunctions.ColumnExists('combustivel', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('combustivel') <> '') then
          begin
            pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.combustivel :=
              lJsonBanco.GetValue<String>('combustivel');
          end;

          if tfunctions.ColumnExists('subgrupo', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('subgrupo') <> '')
          then
          begin
            pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.subgrupo :=
              lJsonBanco.GetValue<String>('subgrupo');
          end;

          if TContaDAO.Existe(pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa) then
          begin
            TContaDAO.Alterar(pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa);
          end
          else
          begin
            TContaDAO.Incluir(pContasPagar.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa);
          end;
        end;
      end;

      if TFormaPagamentoDAO.Existe(pContasPagar.Forma_Pagamento_Baixar) then
      begin
        TFormaPagamentoDAO.Alterar(pContasPagar.Forma_Pagamento_Baixar);
      end
      else
      begin
        TFormaPagamentoDAO.Incluir(pContasPagar.Forma_Pagamento_Baixar);
      end;

      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCP := false;
    end;
  end;
end;

class function TContasPagarDAO.MontaObjetoFormaPagamentoContasPagar(pJson: TJSONObject;
  pContasPagar: TContasPagar): boolean;
var
  lJsonArray: TJSONArray;
  lJsonFPag: TJSONObject;
  lJsonBanco: TJSONObject;
begin
  try
    if not tfunctions.ObjectIsNull('forma_pagamento', pJson.ToString) then
    begin
      lJsonFPag := pJson.GetValue<TJSONObject>('forma_pagamento') as TJSONObject;
      if tfunctions.ColumnExists('codigo', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('codigo') <> '') then
      begin
        pContasPagar.Forma_Pagamento.codigo := lJsonFPag.GetValue<Integer>('codigo');
      end;

      if tfunctions.ColumnExists('descricao', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('descricao') <> '')
      then
      begin
        pContasPagar.Forma_Pagamento.descricao := lJsonFPag.GetValue<String>('descricao');
      end;

      if tfunctions.ColumnExists('tipo', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('tipo') <> '') then
      begin
        pContasPagar.Forma_Pagamento.tipo := lJsonFPag.GetValue<String>('tipo');
      end;

      if tfunctions.ColumnExists('codigo_ecf', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('codigo_ecf') <> '')
      then
      begin
        pContasPagar.Forma_Pagamento.codigo_ecf := lJsonFPag.GetValue<String>('codigo_ecf');
      end;

      if tfunctions.ColumnExists('origem', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('origem') <> '') then
      begin
        pContasPagar.Forma_Pagamento.Origem := lJsonFPag.GetValue<String>('origem');
      end;

      if tfunctions.ColumnExists('nome_fiscal', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('nome_fiscal') <> '')
      then
      begin
        pContasPagar.Forma_Pagamento.nome_fiscal := lJsonFPag.GetValue<String>('nome_fiscal');
      end;

      if tfunctions.ColumnExists('permite_desconto', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('permite_desconto') <> '') then
      begin
        pContasPagar.Forma_Pagamento.permite_desconto := lJsonFPag.GetValue<String>('permite_desconto');
      end;

      if tfunctions.ColumnExists('tipo_da_comissao', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('tipo_da_comissao') <> '') then
      begin
        pContasPagar.Forma_Pagamento.tipo_da_comissao := lJsonFPag.GetValue<String>('tipo_da_comissao');
      end;

      if tfunctions.ColumnExists('tipo_de_movimentacao', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('tipo_de_movimentacao') <> '') then
      begin
        pContasPagar.Forma_Pagamento.tipo_de_movimentacao := lJsonFPag.GetValue<String>('tipo_de_movimentacao');
      end;
      if tfunctions.ColumnExists('qtde_dias_para_primeiro_vencimento', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('qtde_dias_para_primeiro_vencimento') <> '') then
      begin
        pContasPagar.Forma_Pagamento.qtde_dias_para_primeiro_vencimento :=
          lJsonFPag.GetValue<Integer>('qtde_dias_para_primeiro_vencimento');
      end;
      if tfunctions.ColumnExists('agrupar', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('agrupar') <> '') then
      begin
        pContasPagar.Forma_Pagamento.agrupar := lJsonFPag.GetValue<String>('agrupar');
      end;
      if tfunctions.ColumnExists('multiplas_formas_de_pagamento', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('multiplas_formas_de_pagamento') <> '') then
      begin
        pContasPagar.Forma_Pagamento.multiplas_formas_de_pagamento :=
          lJsonFPag.GetValue<String>('multiplas_formas_de_pagamento');
      end;
      if tfunctions.ColumnExists('forma_de_fechamento', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('forma_de_fechamento') <> '') then
      begin
        pContasPagar.Forma_Pagamento.forma_de_fechamento := lJsonFPag.GetValue<Integer>('forma_de_fechamento');
      end;
      if tfunctions.ColumnExists('imprimir_boleto', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('imprimir_boleto') <> '') then
      begin
        pContasPagar.Forma_Pagamento.imprimir_boleto := lJsonFPag.GetValue<String>('imprimir_boleto');
      end;
      if tfunctions.ColumnExists('lancar_no_caixa', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('lancar_no_caixa') <> '') then
      begin
        pContasPagar.Forma_Pagamento.lancar_no_caixa := lJsonFPag.GetValue<String>('lancar_no_caixa');
      end;
      if tfunctions.ColumnExists('banco_de_lancamento_no_caixa', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('banco_de_lancamento_no_caixa') <> '') then
      begin
        pContasPagar.Forma_Pagamento.banco_de_lancamento_no_caixa :=
          lJsonFPag.GetValue<Integer>('banco_de_lancamento_no_caixa');
      end;

      if not tfunctions.ObjectIsNull('conta_de_lancamento_no_caixa', pJson.ToString) then
      begin

        if tfunctions.ColumnExists('conta_de_lancamento_no_caixa', lJsonFPag.ToString) then
        begin
          lJsonBanco := lJsonFPag.GetValue<TJSONObject>('conta_de_lancamento_no_caixa') as TJSONObject;

          if tfunctions.ColumnExists('codigo', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('codigo') <> '')
          then
          begin
            pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa.codigo := lJsonBanco.GetValue<String>('codigo');
          end;

          if tfunctions.ColumnExists('nome', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('nome') <> '') then
          begin
            pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa.nome := lJsonBanco.GetValue<String>('nome');
          end;

          if tfunctions.ColumnExists('tipo', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('tipo') <> '') then
          begin
            pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa.tipo := lJsonBanco.GetValue<String>('tipo');
          end;

          if tfunctions.ColumnExists('centro_custo', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('centro_custo') <> '') then
          begin
            pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa.centro_custo :=
              lJsonBanco.GetValue<String>('centro_custo');
          end;

          if tfunctions.ColumnExists('duplicar', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('duplicar') <> '')
          then
          begin
            pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa.duplicar :=
              lJsonBanco.GetValue<String>('duplicar');
          end;

          if tfunctions.ColumnExists('caixa_dest', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('caixa_dest') <> '') then
          begin
            pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa.caixa_dest :=
              lJsonBanco.GetValue<String>('caixa_dest');
          end;

          if tfunctions.ColumnExists('historico', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('historico') <> '') then
          begin
            pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa.historico :=
              lJsonBanco.GetValue<String>('historico');
          end;

          if tfunctions.ColumnExists('dre', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('dre') <> '') then
          begin
            pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa.dre := lJsonBanco.GetValue<String>('dre');
          end;

          if tfunctions.ColumnExists('nivel_dre', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('nivel_dre') <> '') then
          begin
            pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa.nivel_dre :=
              lJsonBanco.GetValue<Integer>('nivel_dre');
          end;

          if tfunctions.ColumnExists('tipo_custo', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('tipo_custo') <> '') then
          begin
            pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa.tipo_custo :=
              lJsonBanco.GetValue<String>('tipo_custo');
          end;

          if tfunctions.ColumnExists('combustivel', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('combustivel') <> '') then
          begin
            pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa.combustivel :=
              lJsonBanco.GetValue<String>('combustivel');
          end;

          if tfunctions.ColumnExists('subgrupo', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('subgrupo') <> '')
          then
          begin
            pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa.subgrupo :=
              lJsonBanco.GetValue<String>('subgrupo');
          end;

          if TContaDAO.Existe(pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa) then
          begin
            TContaDAO.Alterar(pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa);
          end
          else
          begin
            TContaDAO.Incluir(pContasPagar.Forma_Pagamento.conta_de_lancamento_no_caixa);
          end;
        end;
      end;

      if TFormaPagamentoDAO.Existe(pContasPagar.Forma_Pagamento) then
      begin
        TFormaPagamentoDAO.Alterar(pContasPagar.Forma_Pagamento);
      end
      else
      begin
        TFormaPagamentoDAO.Incluir(pContasPagar.Forma_Pagamento);
      end;
      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCP := false;
    end;
  end;
end;

class function TContasPagarDAO.MontaObjetoFornecedorContasPagar(pJson: TJSONObject; pContasPagar: TContasPagar)
  : boolean;
var
  lJsonArray: TJSONArray;
  lJsonForn: TJSONObject;
  lCPF, lCNPJ: string;
  lPessoaFisica: boolean;
  lCodigo: Integer;
begin
  try
    if not tfunctions.ObjectIsNull('fornecedor', pJson.ToString) then
    begin
      lJsonForn := pJson.GetValue<TJSONObject>('fornecedor') as TJSONObject;

      if tfunctions.ColumnExists('nome', lJsonForn.ToString) and (lJsonForn.GetValue<String>('nome') <> '') then
      begin
        pContasPagar.Fornecedor.nome := lJsonForn.GetValue<String>('nome');
      end;

      if tfunctions.ColumnExists('fantasia', lJsonForn.ToString) and (lJsonForn.GetValue<String>('fantasia') <> '') then
      begin
        pContasPagar.Fornecedor.fantasia := lJsonForn.GetValue<String>('fantasia');
      end;

      if tfunctions.ColumnExists('endereco', lJsonForn.ToString) and (lJsonForn.GetValue<String>('endereco') <> '') then
      begin
        pContasPagar.Fornecedor.endereco := lJsonForn.GetValue<String>('endereco');
      end;

      if tfunctions.ColumnExists('numero', lJsonForn.ToString) and (lJsonForn.GetValue<String>('numero') <> '') then
      begin
        pContasPagar.Fornecedor.numero := lJsonForn.GetValue<String>('numero');
      end;

      if tfunctions.ColumnExists('bairro', lJsonForn.ToString) and (lJsonForn.GetValue<String>('bairro') <> '') then
      begin
        pContasPagar.Fornecedor.bairro := lJsonForn.GetValue<String>('bairro');
      end;

      if tfunctions.ColumnExists('cidade', lJsonForn.ToString) and (lJsonForn.GetValue<String>('cidade') <> '') then
      begin
        pContasPagar.Fornecedor.cidade := lJsonForn.GetValue<String>('cidade');
      end;

      if tfunctions.ColumnExists('cep', lJsonForn.ToString) and (lJsonForn.GetValue<String>('cep') <> '') then
      begin
        pContasPagar.Fornecedor.cep := lJsonForn.GetValue<String>('cep');
      end;

      if tfunctions.ColumnExists('ie', lJsonForn.ToString) and (lJsonForn.GetValue<String>('ie') <> '') then
      begin
        pContasPagar.Fornecedor.ie := lJsonForn.GetValue<String>('ie');
      end;

      if tfunctions.ColumnExists('fone', lJsonForn.ToString) and (lJsonForn.GetValue<String>('fone') <> '') then
      begin
        pContasPagar.Fornecedor.fone := lJsonForn.GetValue<String>('fone');
      end;

      if tfunctions.ColumnExists('fax', lJsonForn.ToString) and (lJsonForn.GetValue<String>('fax') <> '') then
      begin
        pContasPagar.Fornecedor.fax := lJsonForn.GetValue<String>('fax');
      end;

      if tfunctions.ColumnExists('celular', lJsonForn.ToString) and (lJsonForn.GetValue<String>('celular') <> '') then
      begin
        pContasPagar.Fornecedor.celular := lJsonForn.GetValue<String>('celular');
      end;

      if tfunctions.ColumnExists('email', lJsonForn.ToString) and (lJsonForn.GetValue<String>('email') <> '') then
      begin
        pContasPagar.Fornecedor.email := lJsonForn.GetValue<String>('email');
      end;

      if tfunctions.ColumnExists('codigo_cidade_ibge', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('codigo_cidade_ibge') <> '') then
      begin
        pContasPagar.Fornecedor.codigo_cidade_ibge := lJsonForn.GetValue<String>('codigo_cidade_ibge');
      end;

      if tfunctions.ColumnExists('uf', lJsonForn.ToString) and (lJsonForn.GetValue<String>('uf') <> '') then
      begin
        pContasPagar.Fornecedor.uf := lJsonForn.GetValue<String>('uf');
      end;

      if tfunctions.ColumnExists('sped', lJsonForn.ToString) and (lJsonForn.GetValue<String>('sped') <> '') then
      begin
        pContasPagar.Fornecedor.sped := lJsonForn.GetValue<boolean>('sped');
      end;

      if tfunctions.ColumnExists('usuario_cadastro', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('usuario_cadastro') <> '') then
      begin
        pContasPagar.Fornecedor.Usuario_Cadastro := lJsonForn.GetValue<Integer>('usuario_cadastro');
      end;

      if tfunctions.ColumnExists('usuario_alteracao', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('usuario_alteracao') <> '') then
      begin
        pContasPagar.Fornecedor.Usuario_Alteracao := lJsonForn.GetValue<Integer>('usuario_alteracao');
      end;

      if tfunctions.ColumnExists('data_alteracao', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('data_alteracao') <> '') then
      begin
        pContasPagar.Fornecedor.data_alteracao := lJsonForn.GetValue<String>('data_alteracao');
      end;

      if tfunctions.ColumnExists('data_cadastro', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('data_cadastro') <> '') then
      begin
        pContasPagar.Fornecedor.data_cadastro := lJsonForn.GetValue<String>('data_cadastro');
      end;

      if tfunctions.ColumnExists('ativo', lJsonForn.ToString) and (lJsonForn.GetValue<String>('ativo') <> '') then
      begin
        pContasPagar.Fornecedor.ativo := lJsonForn.GetValue<boolean>('ativo');
      end;

      if tfunctions.ColumnExists('pessoa_fisica', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('pessoa_fisica') <> '') then
      begin
        lPessoaFisica := lJsonForn.GetValue<boolean>('pessoa_fisica');
        pContasPagar.Fornecedor.pessoa_fisica := lPessoaFisica;
      end;

      if tfunctions.ColumnExists('cpf', lJsonForn.ToString) and (lJsonForn.GetValue<String>('cpf') <> '') then
      begin
        lCPF := lJsonForn.GetValue<String>('cpf');
        pContasPagar.Fornecedor.cpf := lCPF;
      end;

      if tfunctions.ColumnExists('cnpj', lJsonForn.ToString) and (lJsonForn.GetValue<String>('cnpj') <> '') then
      begin
        lCNPJ := lJsonForn.GetValue<String>('cnpj');
        pContasPagar.Fornecedor.cnpj := lCNPJ;
      end;

      if tfunctions.ColumnExists('site', lJsonForn.ToString) and (lJsonForn.GetValue<String>('site') <> '') then
      begin
        pContasPagar.Fornecedor.site := lJsonForn.GetValue<String>('site');
      end;

      if tfunctions.ColumnExists('observacao1', lJsonForn.ToString) and (lJsonForn.GetValue<String>('observacao1') <> '')
      then
      begin
        pContasPagar.Fornecedor.observacao1 := lJsonForn.GetValue<String>('observacao1');
      end;

      if tfunctions.ColumnExists('observacao2', lJsonForn.ToString) and (lJsonForn.GetValue<String>('observacao2') <> '')
      then
      begin
        pContasPagar.Fornecedor.observacao2 := lJsonForn.GetValue<String>('observacao2');
      end;

      if tfunctions.ColumnExists('endereco_cobranca', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('endereco_cobranca') <> '') then
      begin
        pContasPagar.Fornecedor.endereco_cobranca := lJsonForn.GetValue<String>('endereco_cobranca');
      end;

      if tfunctions.ColumnExists('bairro_cobranca', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('bairro_cobranca') <> '') then
      begin
        pContasPagar.Fornecedor.bairro_cobranca := lJsonForn.GetValue<String>('bairro_cobranca');
      end;

      if tfunctions.ColumnExists('cidade_cobranca', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('cidade_cobranca') <> '') then
      begin
        pContasPagar.Fornecedor.cidade_cobranca := lJsonForn.GetValue<String>('cidade_cobranca');
      end;

      if tfunctions.ColumnExists('cep_cobranca', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('cep_cobranca') <> '') then
      begin
        pContasPagar.Fornecedor.cep_cobranca := lJsonForn.GetValue<String>('cep_cobranca');
      end;

      if tfunctions.ColumnExists('uf_cobranca', lJsonForn.ToString) and (lJsonForn.GetValue<String>('uf_cobranca') <> '')
      then
      begin
        pContasPagar.Fornecedor.uf_cobranca := lJsonForn.GetValue<String>('uf_cobranca');
      end;

      if tfunctions.ColumnExists('localizacao', lJsonForn.ToString) and (lJsonForn.GetValue<String>('localizacao') <> '')
      then
      begin
        pContasPagar.Fornecedor.localizacao := lJsonForn.GetValue<Integer>('localizacao');
      end;

      if tfunctions.ColumnExists('extra', lJsonForn.ToString) and (lJsonForn.GetValue<String>('extra') <> '') then
      begin
        pContasPagar.Fornecedor.extra := lJsonForn.GetValue<Integer>('extra');
      end;

      if tfunctions.ColumnExists('utilizar_rotina_atacado', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('utilizar_rotina_atacado') <> '') then
      begin
        pContasPagar.Fornecedor.utilizar_rotina_atacado := lJsonForn.GetValue<boolean>('utilizar_rotina_atacado');
      end;

      if tfunctions.ColumnExists('observacao_geral', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('observacao_geral') <> '') then
      begin
        pContasPagar.Fornecedor.observacao_geral := lJsonForn.GetValue<String>('observacao_geral');
      end;

      if tfunctions.ColumnExists('nome_representante', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('nome_representante') <> '') then
      begin
        pContasPagar.Fornecedor.nome_representante := lJsonForn.GetValue<String>('nome_representante');
      end;

      if tfunctions.ColumnExists('fone_representante', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('fone_representante') <> '') then
      begin
        pContasPagar.Fornecedor.fone_representante := lJsonForn.GetValue<String>('fone_representante');
      end;

      if tfunctions.ColumnExists('email_representante', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('email_representante') <> '') then
      begin
        pContasPagar.Fornecedor.email_representante := lJsonForn.GetValue<String>('email_representante');
      end;

      if tfunctions.ColumnExists('emissao_ultimo_movimento', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('emissao_ultimo_movimento') <> '') then
      begin
        pContasPagar.Fornecedor.emissao_ultimo_movimento := lJsonForn.GetValue<String>('emissao_ultimo_movimento');
      end;

      if tfunctions.ColumnExists('nota_fiscal_ultimo_movimento', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('nota_fiscal_ultimo_movimento') <> '') then
      begin
        pContasPagar.Fornecedor.nota_fiscal_ultimo_movimento :=
          lJsonForn.GetValue<String>('nota_fiscal_ultimo_movimento');
      end;

      if tfunctions.ColumnExists('valor_nota_fiscal_ultimo_movimento', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('valor_nota_fiscal_ultimo_movimento') <> '') then
      begin
        pContasPagar.Fornecedor.valor_nota_fiscal_ultimo_movimento :=
          lJsonForn.GetValue<Double>('valor_nota_fiscal_ultimo_movimento');
      end;

      if tfunctions.ColumnExists('data_nascimento', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('data_nascimento') <> '') then
      begin
        pContasPagar.Fornecedor.data_nascimento := lJsonForn.GetValue<String>('data_nascimento');
      end;
      if tfunctions.ColumnExists('carteira_identidade', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('carteira_identidade') <> '') then
      begin
        pContasPagar.Fornecedor.carteira_identidade := lJsonForn.GetValue<String>('carteira_identidade');
      end;

      if tfunctions.ColumnExists('sequencia', lJsonForn.ToString) and (lJsonForn.GetValue<String>('sequencia') <> '')
      then
      begin
        pContasPagar.Fornecedor.sequencia := lJsonForn.GetValue<Integer>('sequencia');
      end;

      if tfunctions.ColumnExists('alterar_custos', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('alterar_custos') <> '') then
      begin
        pContasPagar.Fornecedor.alterar_custos := lJsonForn.GetValue<boolean>('alterar_custos');
      end;

      if tfunctions.ColumnExists('regime_tributario', lJsonForn.ToString) and
        (lJsonForn.GetValue<String>('regime_tributario') <> '') then
      begin
        pContasPagar.Fornecedor.regime_tributario := lJsonForn.GetValue<Integer>('regime_tributario');
      end;

      if tfunctions.ColumnExists('crt', lJsonForn.ToString) and (lJsonForn.GetValue<String>('crt') <> '') then
      begin
        pContasPagar.Fornecedor.crt := lJsonForn.GetValue<Integer>('crt');
      end;

      if tfunctions.ColumnExists('cnae', lJsonForn.ToString) and (lJsonForn.GetValue<String>('cnae') <> '') then
      begin
        pContasPagar.Fornecedor.cnae := lJsonForn.GetValue<String>('cnae');
      end;

      if lPessoaFisica then
      begin
        lCodigo := TfornecedorDAO.BuscaCodigoPeloCpf(lCPF);
      end
      else
      begin
        lCodigo := TfornecedorDAO.BuscaCodigoPeloCnpj(lCNPJ);
      end;

      if lCodigo > 0 then
      begin
        pContasPagar.Fornecedor.codigo := lCodigo;
        TfornecedorDAO.Alterar(pContasPagar.Fornecedor);
      end
      else
      begin
        pContasPagar.Fornecedor.codigo := TfornecedorDAO.GeraProximoCodigo;
        TfornecedorDAO.Incluir(pContasPagar.Fornecedor);
      end;
      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCP := false;
    end;
  end;
end;

class function TContasPagarDAO.MontaObjetoVendedorContasPagar(pJson: TJSONObject; pContasPagar: TContasPagar): boolean;
var
  lJsonArray: TJSONArray;
  lJsonVend: TJSONObject;
  lIndetificador: string;
  lCodigo: Integer;
begin

  try
    if not tfunctions.ObjectIsNull('vendedor', pJson.ToString) then
    begin
      lJsonVend := pJson.GetValue<TJSONObject>('vendedor') as TJSONObject;

      if tfunctions.ColumnExists('cpf_cnpj', lJsonVend.ToString) and (lJsonVend.GetValue<String>('cpf_cnpj') <> '') then
      begin

        if tfunctions.ColumnExists('nome', lJsonVend.ToString) and (lJsonVend.GetValue<String>('nome') <> '') then
        begin
          pContasPagar.vendedor.nome := lJsonVend.GetValue<String>('nome');
        end;

        if tfunctions.ColumnExists('comissao_vista', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('comissao_vista') <> '') then
        begin
          pContasPagar.vendedor.comissao_vista := lJsonVend.GetValue<Double>('comissao_vista');
        end;

        if tfunctions.ColumnExists('comissao_prazo', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('comissao_prazo') <> '') then
        begin
          pContasPagar.vendedor.comissao_prazo := lJsonVend.GetValue<Double>('comissao_prazo');
        end;

        if tfunctions.ColumnExists('modifica_preco_venda', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('modifica_preco_venda') <> '') then
        begin
          pContasPagar.vendedor.modifica_preco_venda := lJsonVend.GetValue<boolean>('modifica_preco_venda');
        end;

        if tfunctions.ColumnExists('limite_desconto', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('limite_desconto') <> '') then
        begin
          pContasPagar.vendedor.limite_desconto := lJsonVend.GetValue<Double>('limite_desconto');
        end;

        if tfunctions.ColumnExists('meta_venda', lJsonVend.ToString) and (lJsonVend.GetValue<String>('meta_venda') <> '')
        then
        begin
          pContasPagar.vendedor.meta_venda := lJsonVend.GetValue<Double>('meta_venda');
        end;
        if tfunctions.ColumnExists('participar_agenda', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('participar_agenda') <> '') then
        begin
          pContasPagar.vendedor.participar_agenda := lJsonVend.GetValue<boolean>('participar_agenda');
        end;

        if tfunctions.ColumnExists('tipo_preco_venda', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('tipo_preco_venda') <> '') then
        begin
          pContasPagar.vendedor.tipo_preco_venda := lJsonVend.GetValue<String>('tipo_preco_venda');
        end;

        if tfunctions.ColumnExists('endereco', lJsonVend.ToString) and (lJsonVend.GetValue<String>('endereco') <> '')
        then
        begin
          pContasPagar.vendedor.endereco := lJsonVend.GetValue<String>('endereco');
        end;

        if tfunctions.ColumnExists('cidade', lJsonVend.ToString) and (lJsonVend.GetValue<String>('cidade') <> '') then
        begin
          pContasPagar.vendedor.cidade := lJsonVend.GetValue<String>('cidade');
        end;

        if tfunctions.ColumnExists('cep', lJsonVend.ToString) and (lJsonVend.GetValue<String>('cep') <> '') then
        begin
          pContasPagar.vendedor.cep := lJsonVend.GetValue<String>('cep');
        end;
        if tfunctions.ColumnExists('fone', lJsonVend.ToString) and (lJsonVend.GetValue<String>('fone') <> '') then
        begin
          pContasPagar.vendedor.fone := lJsonVend.GetValue<String>('fone');
        end;
        if tfunctions.ColumnExists('email', lJsonVend.ToString) and (lJsonVend.GetValue<String>('email') <> '') then
        begin
          pContasPagar.vendedor.email := lJsonVend.GetValue<String>('email');
        end;
        if tfunctions.ColumnExists('observacoes', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('observacoes') <> '') then
        begin
          pContasPagar.vendedor.observacoes := lJsonVend.GetValue<String>('observacoes');
        end;
        if tfunctions.ColumnExists('senha', lJsonVend.ToString) and (lJsonVend.GetValue<String>('senha') <> '') then
        begin
          pContasPagar.vendedor.senha := lJsonVend.GetValue<String>('senha');
        end;

        lIndetificador := lJsonVend.GetValue<String>('cpf_cnpj');
        pContasPagar.vendedor.cpf_cnpj := lIndetificador;
        lCodigo := TVendedorDAO.ExisteCPFouCNPJ(lIndetificador);

        if lCodigo > 0 then
        begin
          pContasPagar.vendedor.codigo := lCodigo;
          TVendedorDAO.Alterar(pContasPagar.vendedor);
        end
        else
        begin
          pContasPagar.vendedor.codigo := TVendedorDAO.GeraProximoCodigo;
          TVendedorDAO.Incluir(pContasPagar.vendedor);
        end;
      end;

      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCP := false;
    end;
  end;
end;

class function TContasPagarDAO.Post(pTitulo: string; lNovaData: TDateTime; pContasPagar: TContasPagar): boolean;
var
  lHttp: TConnectionRest;

  function Tratamento: boolean;
  begin
    result := true;

    if (copy(IntToStr(lHttp.RestResponse.StatusCode), 1, 1)) = '2' then
    begin
      // Para n�o reenviar o CP, atualizamos com data ultimo sinc -1
      tfunctions.AtualizaContaPagarComoEnviado(pTitulo, lNovaData);
      tfunctions.AtualizaTituloEmpresaCP(pTitulo); // Monta o titulo empresa para proximas conexoes

      // Mensagem ok
      TMessages.Messages.MessageOk := TMessages.Messages.MessageOk +
        ('POST - Contas Pagar: ' + pTitulo + ' - Enviado - ' + DateTimeToStr(tfunctions.DateServer)) + sLineBreak;
    end
    else if (lHttp.RestResponse.StatusCode = 409) then
    begin
      // Para n�o reenviar o CP, atualizamos com data ultimo sinc -1
      tfunctions.AtualizaContaPagarComoEnviado(pTitulo, lNovaData);

      // Mensagem troca status
      TMessages.Messages.MessageErro := TMessages.Messages.MessageErro +
        ('POST - Contas Pagar: ' + pTitulo + ' - Ja existia na API, o status foi trocado para enviado - ' +
        DateTimeToStr(tfunctions.DateServer)) + sLineBreak;
    end
    else
    begin

      // Mensagem erro
      TMessages.Messages.MessageErro := TMessages.Messages.MessageErro + 'POST - Contas Pagar: ' + pTitulo + ' - ' +
        pContasPagar.emissao + ' - N�o Enviado - Motivo/Erro: ' + IntToStr(lHttp.RestResponse.StatusCode) + ' - ' +
        lHttp.RestResponse.Content + ' - ' + DateTimeToStr(tfunctions.DateServer);

      result := false;
    end;
  end;

begin
  lHttp := TConnectionRest.Create;
  try
    lHttp.ConfigureRest(rmPOST, tPostCP, pContasPagar.ToJson);
    result := Tratamento;
  finally
    lHttp.Free;
  end;

end;

class function TContasPagarDAO.Put(pTitulo: string; lNovaData: TDateTime; pContasPagar: TContasPagar): boolean;
var
  lHttp: TConnectionRest;
  function Tratamento: boolean;
  begin
    result := true;
    if (lHttp.RestResponse.StatusCode = 404) then
    begin
      tfunctions.AtualizaCPParaReenvio(pTitulo);
    end;

    if (copy(IntToStr(lHttp.RestResponse.StatusCode), 1, 1)) = '2' then
    begin
      // Para n�o reenviar o CP, atualizamos com data ultimo sinc -1
      tfunctions.AtualizaComoEnviadaTabelaAuxCP(pTitulo, lNovaData);

      TMessages.Messages.MessageOk := TMessages.Messages.MessageOk +
        ('PUT - Contas Pagar: ' + pTitulo + ' - Alterado - ' + DateTimeToStr(tfunctions.DateServer) + sLineBreak);
    end
    else
    begin
      TMessages.Messages.MessageErro := TMessages.Messages.MessageErro +
        ('PUT - Contas Pagar: ' + pTitulo + ' - N�o Alterado - Motivo/Erro: ' + IntToStr(lHttp.RestResponse.StatusCode)
        + ' - ' + lHttp.RestResponse.Content + ' - ' +

        DateTimeToStr(tfunctions.DateServer)) + sLineBreak;

      result := false;
    end;
  end;

begin
  lHttp := TConnectionRest.Create;
  try
    lHttp.ConfigureRest(rmPUT, tPutCP, pContasPagar.ToJson);
    result := Tratamento;
  finally
    lHttp.Free;
  end;
end;

class function TContasPagarDAO.Excluir(pTitulo: string; pCommit: boolean = true): boolean;
var
  lQuery: Tquery;
begin
  lQuery := Tquery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM MC08CPAG WHERE AC08TIT = :AC08TIT ');
    lQuery.ParamByName('AC08TIT').AsString := pTitulo;
    lQuery.ExecSQL;
    lQuery.Connection.commit;
  finally
    lQuery.Free;
  end;

end;

class function TContasPagarDAO.ExcluirPeloTituloEmpresa(pTituloEmpresa: String; pCommit: boolean = true): boolean;
var
  lQuery: Tquery;
begin
  lQuery := Tquery.Create(nil);
  try
    result := false;

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' select * from MC08CPAG  WHERE AC08EMP_TIT = :AC08EMP_TIT ');
    lQuery.ParamByName('AC08EMP_TIT').AsString := pTituloEmpresa;
    lQuery.Open;
    lQuery.FetchAll;

    if lQuery.RecordCount > 0 then
    begin
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add('DELETE FROM MC08CPAG WHERE AC08EMP_TIT = :AC08EMP_TIT ');
      lQuery.ParamByName('AC08EMP_TIT').AsString := pTituloEmpresa;
      lQuery.ExecSQL;
      lQuery.Connection.commit;

      result := true;
    end;
  finally
    lQuery.Free;
  end;
end;

class function TContasPagarDAO.Existe(pTitulo: string): boolean;
var
  lQuery: Tquery;
begin
  result := false;
  lQuery := Tquery.Create(nil);
  try

    lQuery.Connection := Tconnection.ObjectConnection.Connection;
    lQuery.SQL.Add('SELECT * FROM MC08CPAG WHERE AC08TIT = :AC08TIT');
    lQuery.ParamByName('AC08TIT').AsString := pTitulo;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      result := true;
    end;
  finally
    lQuery.Free;
  end;
end;

class function TContasPagarDAO.ExisteEmpresaTitulo(pTitulo: string): boolean;
var
  lQuery: Tquery;
begin
  lQuery := Tquery.Create(nil);
  try

    lQuery.Connection := Tconnection.ObjectConnection.Connection;
    lQuery.SQL.Add('SELECT * FROM MC08CPAG WHERE AC08EMP_TIT = :AC08EMP_TIT');
    lQuery.ParamByName('AC08EMP_TIT').AsString := pTitulo;
    lQuery.Open;

    result := lQuery.RecordCount > 0;

  finally
    lQuery.Free;
  end;

end;

class function TContasPagarDAO.GeraProximoCodigo: Integer;
var
  lQuery: Tquery;
begin
  lQuery := Tquery.Create(nil);
  try
    result := 0;

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT MAX(AC08TIT) + 1 PROXIMO_CODIGO FROM MC08CPAG ');
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      result := lQuery.FieldByName('PROXIMO_CODIGO').AsInteger;
    end;
  finally
    lQuery.Free;
  end;
end;

class function TContasPagarDAO.GeraProximoTituloIntegracao: string;
var
  lQuery: Tquery;
  lProximoNumero: Integer;
begin
  lQuery := Tquery.Create(nil);

  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT FIRST 1 CAST(substring(AC08TIT FROM 6 FOR CHAR_LENGTH(AC08TIT)-5) AS int) AS PROX_NUMERO ');
    lQuery.SQL.Add(' from mc08cpag                                                              ');
    lQuery.SQL.Add(' where substring(AC08TIT FROM 1 FOR 3) = ''INT''                            ');
    lQuery.SQL.Add(' order by 1 desc                                                            ');
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      lProximoNumero := lQuery.FieldByName('PROX_NUMERO').AsInteger + 1;
    end
    else
    begin
      lProximoNumero := 1;
    end;

    result := lProximoNumero.ToString;
  finally
    lQuery.Free;
  end;
end;

class function TContasPagarDAO.Get(pAll: boolean): boolean;
var
  lJson: TJSONObject;
  lJsonArray: TJSONArray;
  i: Integer;
  lContaRegistros, lTotalVendas: Integer;
  lDataUltimaSinc: TDateTime;
  lCP: TContasPagar;
  lExcluido: boolean;
  lResposta: string;
  lDataTimeCP: string;
  lHttp: TConnectionRest;
  JsonValue: TJSonValue;
  CpOk, CpVendOk, CpFornecOk, CpBancoCobOk, CpBancoPagOk, CpFormaOk, CpFormaBaixarOk: boolean;

begin
  TContador.Contador.RecebimentoCP := 0;
  TContador.Contador.TotalRecebimentoCP := 0;
  TMessages.Messages.MessageOk := EmptyStr;
  TMessages.Messages.MessageErro := EmptyStr;
  try
    lHttp := TConnectionRest.Create;
    try
      lDataUltimaSinc := tfunctions.RetornaUltimoSincCP;

      if pAll then
      begin
        lDataTimeCP := '2000/01/01 00:00:00';
      end
      else
      begin
        lDataTimeCP := tfunctions.DecodeDateHourJson(lDataUltimaSinc);
      end;

      tsettings.settings.DataFormatada := lDataTimeCP;
      ttoken.AccessToken;
      lHttp.ConfigureRest(rmGET, tGetCP, '');

      if lHttp.RestResponse.StatusCode = 401 then
      begin
        lHttp.GetAccessToken;
        lHttp.ConfigureRest(rmGET, tGetCP, '');
      end;

      if (tfunctions.LengthString(IntToStr(lHttp.RestResponse.StatusCode), 1)) = '2' then
      begin
        lCP := TContasPagar.Create;
        try
          lJson := TJSONObject.ParseJSONValue(lHttp.RestResponse.Content) as TJSONObject;
          lJsonArray := lJson.GetValue<TJSONArray>('contas') as TJSONArray;
          TContador.Contador.TotalRecebimentoCP := lJsonArray.Count;

          if not(TJSONObject.ParseJSONValue(lJsonArray.ToString).Null) and
            not(TJSONObject.ParseJSONValue(lJsonArray.ToString).ToString = '[]') then
          begin
            tfunctions.CreateFileTxtLog(lHttp.RestResponse.Content, 'GET');
          end;

          for i := 0 to lJsonArray.Count - 1 do
          begin
            if (lJsonArray <> nil) then
            begin
              TContador.Contador.RecebimentoCP := TContador.Contador.RecebimentoCP + 1;
              lJson := lJsonArray.Items[i] as TJSONObject;
              lJson := lJson.GetValue<TJSONObject> as TJSONObject;

              lExcluido := lJson.GetValue<String>('excluido') = 'S';
              if lExcluido then // Variavel Utilizada pra baixar ou deletar apartir do GET da api
              begin
                if lJson.GetValue<String>('titulo') <> '' then
                begin
                  lCP.Empresa_Titulo := lJson.GetValue<String>('titulo');
                  if ExcluirPeloTituloEmpresa(lCP.Empresa_Titulo) then
                  begin
                    TContador.Contador.Excluido := TContador.Contador.Excluido + 1;
                    TMessages.Messages.MessageOk :=
                      (TMessages.Messages.MessageOk + 'GET - Exclus�o do titulo: ' +
                      RetornaTituloPeloTituloEmpresa(lJson.GetValue<String>('titulo')) + ' - Titulo Empresa: ' +
                      lJson.GetValue<String>('titulo') + ' - ' + DateTimeToStr(tfunctions.DateServer) + sLineBreak);
                  end
                  else
                  begin
                    TMessages.Messages.MessageErro :=
                      (TMessages.Messages.MessageErro + 'GET - N�o encontrado para exclus�o o titulo: ' +
                      RetornaTituloPeloTituloEmpresa(lJson.GetValue<String>('titulo')) + ' - Titulo Empresa: ' +
                      lJson.GetValue<String>('titulo') + ' - ' + DateTimeToStr(tfunctions.DateServer) + sLineBreak);
                  end;
                end;
              end
              else
              begin
                Limpar(lCP);
                CpOk := MontaObjetoContasPagar(lJson, lCP);
                CpVendOk := MontaObjetoVendedorContasPagar(lJson, lCP);
                CpFornecOk := MontaObjetoFornecedorContasPagar(lJson, lCP);
                CpBancoCobOk := MontaObjetoBancoCobrancaContasPagar(lJson, lCP);
                CpBancoPagOk := MontaObjetoBancoPagamentoContasPagar(lJson, lCP);
                CpFormaOk := MontaObjetoFormaPagamentoContasPagar(lJson, lCP);
                CpFormaBaixarOk := MontaObjetoFormaPagamentoBaixarContasPagar(lJson, lCP);

                lCP.data_ultimo_sincronismo := tfunctions.DecodeDateHourJson(lDataUltimaSinc);
                lCP.Empresa := strtointdef(tfunctions.RetornaCodigoEmpresa, 0);
                lResposta := IncluirOuAltera(lCP);

                if trim(lResposta) <> EmptyStr then
                begin
                  TMessages.Messages.MessageOk :=
                    (lResposta + ' - ' + DateTimeToStr(tfunctions.DateServer) + sLineBreak);
                  TContador.Contador.Sucesso := TContador.Contador.Sucesso + 1;
                end;
              end;
            end;
          end;
        finally
          lCP.Free;
        end;

        result := true;
      end
      else if (lHttp.RestResponse.StatusCode <> 400) then
      begin
        TMessages.Messages.MessageOk := TMessages.Messages.MessageOk +
          ('Erro ao pegar as CP:' + IntToStr(lHttp.RestResponse.StatusCode) + sLineBreak);
        result := false;
      end;
    finally
      lHttp.Free;
    end;
  except
    on E: Exception do
    begin
      result := false;
    end;
  end;
end;

class function TContasPagarDAO.Incluir(pContasPagar: TContasPagar; pCommit: boolean = true): boolean;
var
  lQuery: Tquery;
begin

  try

    lQuery := Tquery.Create(nil);
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add('INSERT INTO MC08CPAG (     ');
      lQuery.SQL.Add('   AC08TIT                 ');
      lQuery.SQL.Add(' , AC08EMPRESA             ');
      lQuery.SQL.Add(' , AD08EMISSAO             ');
      lQuery.SQL.Add(' , AN08FORNEC              ');
      lQuery.SQL.Add(' , AN08VALOR               ');
      lQuery.SQL.Add(' , AD08VCTO                ');
      lQuery.SQL.Add(' , AD08FLUXO               ');
      lQuery.SQL.Add(' , AN08VEND                ');
      lQuery.SQL.Add(' , AC08BCOR                ');
      lQuery.SQL.Add(' , AC08BCPG                ');
      lQuery.SQL.Add(' , AC08SIT                 ');
      lQuery.SQL.Add(' , AC08FRPGTO              ');
      lQuery.SQL.Add(' , AN08JUROS               ');
      lQuery.SQL.Add(' , AN08DESC                ');
      lQuery.SQL.Add(' , AD08DTPGTO              ');
      lQuery.SQL.Add(' , AN08VLPAGO              ');
      lQuery.SQL.Add(' , AN08TOTALPAGO           ');
      lQuery.SQL.Add(' , AC08DHCAD               ');
      lQuery.SQL.Add(' , AC08DHPGTO              ');
      lQuery.SQL.Add(' , AC08USUCAD              ');
      lQuery.SQL.Add(' , AC08USUPGTO             ');
      lQuery.SQL.Add(' , AC08DHALT               ');
      lQuery.SQL.Add(' , AC08USUALT              ');
      lQuery.SQL.Add(' , AC08ORIG                ');
      lQuery.SQL.Add(' , AN089DESC               ');
      lQuery.SQL.Add(' , AC08_ANO                ');
      lQuery.SQL.Add(' , AC08_MES                ');
      lQuery.SQL.Add(' , AC08_OBS1               ');
      lQuery.SQL.Add(' , AC08_OBS2               ');
      lQuery.SQL.Add(' , AC08_PARCIAL            ');
      lQuery.SQL.Add(' , AN08_EMPRESA            ');
      lQuery.SQL.Add(' , AC08_CTA                ');
      lQuery.SQL.Add(' , AC08_COD_BARRAS         ');
      lQuery.SQL.Add(' , AC08FRPGTO_BAIXARCP     ');
      lQuery.SQL.Add(' )VALUES (                 ');
      lQuery.SQL.Add('   :AC08TIT                ');
      lQuery.SQL.Add(' , :AC08EMPRESA            ');
      lQuery.SQL.Add(' , :AD08EMISSAO            ');
      lQuery.SQL.Add(' , :AN08FORNEC             ');
      lQuery.SQL.Add(' , :AN08VALOR              ');
      lQuery.SQL.Add(' , :AD08VCTO               ');
      lQuery.SQL.Add(' , :AD08FLUXO              ');
      lQuery.SQL.Add(' , :AN08VEND               ');
      lQuery.SQL.Add(' , :AC08BCOR               ');
      lQuery.SQL.Add(' , :AC08BCPG               ');
      lQuery.SQL.Add(' , :AC08SIT                ');
      lQuery.SQL.Add(' , :AC08FRPGTO             ');
      lQuery.SQL.Add(' , :AN08JUROS              ');
      lQuery.SQL.Add(' , :AN08DESC               ');
      lQuery.SQL.Add(' , :AD08DTPGTO             ');
      lQuery.SQL.Add(' , :AN08VLPAGO             ');
      lQuery.SQL.Add(' , :AN08TOTALPAGO          ');
      lQuery.SQL.Add(' , :AC08DHCAD              ');
      lQuery.SQL.Add(' , :AC08DHPGTO             ');
      lQuery.SQL.Add(' , :AC08USUCAD             ');
      lQuery.SQL.Add(' , :AC08USUPGTO            ');
      lQuery.SQL.Add(' , :AC08DHALT              ');
      lQuery.SQL.Add(' , :AC08USUALT             ');
      lQuery.SQL.Add(' , :AC08ORIG               ');
      lQuery.SQL.Add(' , :AN089DESC              ');
      lQuery.SQL.Add(' , :AC08_ANO               ');
      lQuery.SQL.Add(' , :AC08_MES               ');
      lQuery.SQL.Add(' , :AC08_OBS1              ');
      lQuery.SQL.Add(' , :AC08_OBS2              ');
      lQuery.SQL.Add(' , :AC08_PARCIAL           ');
      lQuery.SQL.Add(' , :AN08_EMPRESA           ');
      lQuery.SQL.Add(' , :AC08_CTA               ');
      lQuery.SQL.Add(' , :AC08_COD_BARRAS        ');
      lQuery.SQL.Add(' , :AC08FRPGTO_BAIXARCP    ');
      lQuery.SQL.Add('  )                        ');
      lQuery.ParamByName('AC08TIT').AsString := copy(pContasPagar.Titulo, 1, 16);
      lQuery.ParamByName('AC08EMPRESA').AsInteger := pContasPagar.Empresa;
      lQuery.ParamByName('AD08EMISSAO').AsDate := strtodatedef(pContasPagar.emissao, now);
      lQuery.ParamByName('AN08FORNEC').AsInteger := pContasPagar.Fornecedor.codigo;
      lQuery.ParamByName('AN08VALOR').asfloat := RoundTo(pContasPagar.Valor, -2);
      lQuery.ParamByName('AD08VCTO').AsDate := strtodatedef(pContasPagar.Vencimento, now);
      lQuery.ParamByName('AD08FLUXO').AsDate := strtodatedef(pContasPagar.Fluxo_Caixa, now);
      lQuery.ParamByName('AC08BCOR').AsString := copy(pContasPagar.Banco_Cobranca.codigo, 1, 3);
      lQuery.ParamByName('AC08BCPG').AsString := copy(pContasPagar.Banco_Pagamento.codigo, 1, 3);
      lQuery.ParamByName('AC08SIT').AsString := copy(pContasPagar.Situacao, 1, 1);
      lQuery.ParamByName('AC08FRPGTO').AsInteger := pContasPagar.Forma_Pagamento.codigo;
      lQuery.ParamByName('AN08JUROS').asfloat := RoundTo(pContasPagar.Juros, -2);
      lQuery.ParamByName('AN08DESC').asfloat := RoundTo(pContasPagar.Desconto, -2);
      lQuery.ParamByName('AD08DTPGTO').AsDate := strtodatedef(pContasPagar.Data_Pagamento, now);
      lQuery.ParamByName('AN08VLPAGO').asfloat := RoundTo(pContasPagar.Valor_Pago, -2);
      lQuery.ParamByName('AN08TOTALPAGO').asfloat := RoundTo(pContasPagar.Total_Pago, -2);
      lQuery.ParamByName('AC08DHCAD').AsDate := StrToDateTimedef(pContasPagar.data_hora_cadastro, now);
      lQuery.ParamByName('AC08DHPGTO').AsDate := StrToDateTimedef(pContasPagar.Data_Hora_Pagamento, now);
      lQuery.ParamByName('AC08USUCAD').AsInteger := pContasPagar.Usuario_Cadastro;
      lQuery.ParamByName('AC08USUPGTO').AsInteger := pContasPagar.Usuario_Pagamento;
      lQuery.ParamByName('AC08DHALT').AsDate := StrToDateTimedef(pContasPagar.Data_Hora_Alteracao, now);
      lQuery.ParamByName('AC08USUALT').AsInteger := pContasPagar.Usuario_Alteracao;
      lQuery.ParamByName('AC08ORIG').AsString := copy(pContasPagar.Origem, 1, 2);
      lQuery.ParamByName('AC08_ANO').AsString := copy(pContasPagar.Ano, 1, 4);
      lQuery.ParamByName('AC08_MES').AsString := copy(pContasPagar.Mes, 1, 2);
      lQuery.ParamByName('AC08_OBS1').AsString := copy(pContasPagar.OBS1, 1, 50);
      lQuery.ParamByName('AC08_OBS2').AsString := copy(pContasPagar.OBS2, 1, 50);
      lQuery.ParamByName('AC08_PARCIAL').AsString := copy(pContasPagar.Parcial, 1, 1);
      lQuery.ParamByName('AN08_EMPRESA').AsInteger := pContasPagar.Empresa;
      lQuery.ParamByName('AC08_CTA').AsString := copy(pContasPagar.Conta, 1, 3);
      lQuery.ParamByName('AC08_COD_BARRAS').AsString := copy(pContasPagar.Codigo_Barras, 1, 50);
      lQuery.ParamByName('AC08FRPGTO_BAIXARCP').AsInteger := pContasPagar.Forma_Pagamento_Baixar.codigo;
      lQuery.ExecSQL;
      lQuery.Connection.commit;

    finally
      lQuery.Free;
    end;
  except
    on E: Exception do
    begin

    end;
  end;

end;

class function TContasPagarDAO.IncluirOuAltera(pContasPagar: TContasPagar; pCommit: boolean = true): String;
var
  lQuery: Tquery;
  lTitulo: string;
begin
  result := EmptyStr;
  lTitulo := EmptyStr;

  try
    lQuery := Tquery.Create(nil);
    try
      // Valida��o se existe a titulo, para alterarmos
      if ExisteEmpresaTitulo(pContasPagar.Empresa_Titulo) then
      begin
        lTitulo := RetornaTituloPeloTituloEmpresa(copy(pContasPagar.Empresa_Titulo, 1, 30));
        pContasPagar.Titulo := lTitulo;
        Alterar(pContasPagar);

        lQuery.Close;
        lQuery.SQL.Clear;
        lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CP (              ');
        lQuery.SQL.Add(' TITULO, DATA_ATUALIZACAO, EXCLUIDO, ENVIADO)      ');
        lQuery.SQL.Add(' VALUES (:TITULO, :DATA_ATUALIZACAO, ''N'', ''S'') ');
        lQuery.SQL.Add(' MATCHING (TITULO)                                 ');
        lQuery.ParamByName('TITULO').AsString := lTitulo;
        lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime :=
          incminute(tfunctions.DecodeStringToDate(pContasPagar.data_ultimo_sincronismo), -1);
        lQuery.ExecSQL;
        lQuery.Connection.commit;

        result := 'GET - Alterado o titulo: ' + lTitulo + ' - Titulo Empresa: ' + pContasPagar.Empresa_Titulo;
      end
      else // se n�o existir, a incluimos com INT + cod empresa + numero incremental
      begin
        lTitulo := 'INT' + copy(pContasPagar.Empresa_Titulo, 1, 1) + '-' + GeraProximoTituloIntegracao;
        pContasPagar.Titulo := lTitulo;
        Incluir(pContasPagar);

        lQuery.Close;
        lQuery.SQL.Clear;
        lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CP (              ');
        lQuery.SQL.Add(' TITULO, DATA_ATUALIZACAO, EXCLUIDO, ENVIADO)      ');
        lQuery.SQL.Add(' VALUES (:TITULO, :DATA_ATUALIZACAO, ''N'', ''S'') ');
        lQuery.SQL.Add(' MATCHING (TITULO)                                 ');
        lQuery.ParamByName('TITULO').AsString := lTitulo;
        lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime :=
          incminute(tfunctions.DecodeStringToDate(pContasPagar.data_ultimo_sincronismo), -1);
        lQuery.ExecSQL;
        lQuery.Connection.commit;

        result := 'GET - Incluido o titulo: ' + lTitulo + ' - Titulo Empresa: ' + pContasPagar.Empresa_Titulo;
      end;
    finally
      lQuery.Free;
    end;
  except
    on E: Exception do
    begin

    end;
  end;

end;

class function TContasPagarDAO.RetornaTituloPeloTituloEmpresa(pTituloEmp: String): string;
var
  lQuery: Tquery;
begin
  lQuery := Tquery.Create(nil);
  try
    result := EmptyStr;
    lQuery.Connection := Tconnection.ObjectConnection.Connection;
    lQuery.SQL.Add('SELECT * FROM MC08CPAG WHERE AC08EMP_TIT = :AC08EMP_TIT');
    lQuery.ParamByName('AC08EMP_TIT').AsString := pTituloEmp;
    lQuery.Open;
    if lQuery.RecordCount > 0 then
    begin
      result := lQuery.FieldByName('AC08TIT').AsString;
    end;

  finally
    lQuery.Free;
  end;

end;

end.
