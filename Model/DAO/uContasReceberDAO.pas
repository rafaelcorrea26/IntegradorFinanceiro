unit uContasReceberDAO;

interface

uses
  FireDAC.Comp.Client,
  System.SysUtils,
  System.StrUtils,
  uConnection,
  uQuery,
  System.DateUtils,
  uInterfacesEntity,
  uContasReceber,
  System.JSON,
  uFunctions,
  uConnectionRest,
  REST.Types,
  uClienteDAO,
  uCidadeDAO,
  uVendedorDAO,
  uBancoDAO,
  uFormaPagamentoDAO,
  uContaDAO,
  REST.JSON.Types, uTypeService, uToken, System.Math, uSettings, Vcl.Dialogs,
  uContador, uMessages, System.Variants;

type

  TContasReceberDAO = class(TInterfacedObject, iContasReceberDAO)
  public
    // CRUD
    class function Limpar(pContasReceber: TContasReceber): Boolean;
    class function Carrega(pContasReceber: TContasReceber): Boolean;
    class function Incluir(pContasReceber: TContasReceber; pCommit: Boolean = true): Boolean;
    class function Alterar(pContasReceber: TContasReceber; pCommit: Boolean = true): Boolean;
    class function ExcluirPelaDuplicataEmpresa(pDuplicata: string; pCommit: Boolean = true): Boolean;
    class function IncluirOuAltera(pContasReceber: TContasReceber; pCommit: Boolean = true): String;
    class function Excluir(pDuplicata: string; pCommit: Boolean = true): Boolean;

    // Func Auxiliar
    class function RetornaDuplicataPelaDuplicataEmpresa(pDuplicataEmp: String): string;
    class function ExisteEmpresaDuplicata(pDuplicata: string): Boolean;
    class function GeraProximaDuplicataIntegracao: string;
    class function GeraProximoCodigo: integer;
    class function Existe(pDuplicata: string): Boolean;

    // HTTP
    class function Get(pAll: Boolean = false): Boolean;
    class function Delete(pDuplicata, pData: String): Boolean;
    class function Put(pDuplicata: String; lNovaData: TDateTime; pContasReceber: TContasReceber): Boolean;
    class function Post(pDuplicata: String; lNovaData: TDateTime; pContasReceber: TContasReceber): Boolean;

    // Monta objetos GET
    class function MontaObjetoContasReceber(pJson: TJSONObject; pContasReceber: TContasReceber): Boolean;
    class function MontaObjetoVendedorContasReceber(pJson: TJSONObject; pContasReceber: TContasReceber): Boolean;
    class function MontaObjetoLocalCobrancaContasReceber(pJson: TJSONObject; pContasReceber: TContasReceber): Boolean;
    class function MontaObjetoLocalPagamentoContasReceber(pJson: TJSONObject; pContasReceber: TContasReceber): Boolean;
    class function MontaObjetoFormaPagamentoContasReceber(pJson: TJSONObject; pContasReceber: TContasReceber): Boolean;
    class function MontaObjetoFormaPagamentoBaixarContasReceber(pJson: TJSONObject;
      pContasReceber: TContasReceber): Boolean;
    class function MontaObjetoContaContasReceber(pJson: TJSONObject; pContasReceber: TContasReceber): Boolean;
    class function MontaObjetoClienteContasReceber(pJson: TJSONObject; pContasReceber: TContasReceber): Boolean;

  end;

implementation

{ TContasPagarMC }

class function TContasReceberDAO.Alterar(pContasReceber: TContasReceber; pCommit: Boolean = true): Boolean;
var
  lQuery: Tquery;
begin
  try

    lQuery := Tquery.Create(nil);
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' UPDATE CREC SET                           ');
      lQuery.SQL.Add('   EMISSAO = :EMISSAO                  ');
      lQuery.SQL.Add(' , CLIENTE = :CLIENTE                  ');
      lQuery.SQL.Add(' , VALOR = :VALOR                      ');
      lQuery.SQL.Add(' , VCTO = :VCTO                        ');
      lQuery.SQL.Add(' , FLUXO = :FLUXO                      ');
      lQuery.SQL.Add(' , VEND = :VEND                        ');
      lQuery.SQL.Add(' , BCOR = :BCOR                        ');
      lQuery.SQL.Add(' , BCPG = :BCPG                        ');
      lQuery.SQL.Add(' , SIT = :SIT                          ');
      lQuery.SQL.Add(' , FRPGTO = :FRPGTO                    ');
      lQuery.SQL.Add(' , JUROS = :JUROS                      ');
      lQuery.SQL.Add(' , DESC = :DESC                        ');
      lQuery.SQL.Add(' , DTPGTO = :DTPGTO                    ');
      lQuery.SQL.Add(' , VLPAGO = :VLPAGO                    ');
      lQuery.SQL.Add(' , TOTALPAGO = :TOTALPAGO              ');
      lQuery.SQL.Add(' , DHCAD = :DHCAD                      ');
      lQuery.SQL.Add(' , DHPGTO = :DHPGTO                    ');
      lQuery.SQL.Add(' , USUCAD = :USUCAD                    ');
      lQuery.SQL.Add(' , USUPGTO = :USUPGTO                  ');
      lQuery.SQL.Add(' , DHALT = :DHALT                      ');
      lQuery.SQL.Add(' , USUALT = :USUALT                    ');
      lQuery.SQL.Add(' , ORIG = :ORIG                        ');
      lQuery.SQL.Add(' , VLORIG = :VLORIG                    ');
      lQuery.SQL.Add(' , BXPARCIAL = :BXPARCIAL              ');
      lQuery.SQL.Add(' , ANO = :ANO                        ');
      lQuery.SQL.Add(' , MES = :MES                        ');
      lQuery.SQL.Add(' , OBS1 = :OBS1                      ');
      lQuery.SQL.Add(' , OBS2 = :OBS2                      ');
      lQuery.SQL.Add(' , COMISSAO = :COMISSAO              ');
      lQuery.SQL.Add(' , VL_ORIGINAL = :VL_ORIGINAL        ');
      lQuery.SQL.Add(' , VL_PRINCIPAL = :VL_PRINCIPAL      ');
      lQuery.SQL.Add(' , TOTAL_REC = :TOTAL_REC            ');
      lQuery.SQL.Add(' , CTA = :CTA                        ');
      lQuery.SQL.Add(' , EMPRESA = :EMPRESA                ');
      lQuery.SQL.Add(' , FRPGTO_BAIXARCR = :FRPGTO_BAIXARCR  ');
      lQuery.SQL.Add(' , EMP_DUP         = :EMP_DUP          ');
      lQuery.SQL.Add('  where (DUP = :DUP)                   ');
      lQuery.ParamByName('DUP').AsString := copy(pContasReceber.Duplicata, 1, 12);
      lQuery.ParamByName('EMISSAO').AsDate := StrToDatedef(pContasReceber.Emissao, now);
      lQuery.ParamByName('CLIENTE').AsInteger := pContasReceber.Cliente.codigo;
      lQuery.ParamByName('VALOR').AsFloat := RoundTo(pContasReceber.Valor, -2);
      lQuery.ParamByName('VCTO').AsDate := StrToDatedef(pContasReceber.Vencimento, now);
      lQuery.ParamByName('FLUXO').AsDate := StrToDatedef(pContasReceber.Fluxo, now);
      lQuery.ParamByName('VEND').AsInteger := pContasReceber.Vendedor.codigo;
      lQuery.ParamByName('BCOR').AsString := copy(pContasReceber.Local_Cobranca.codigo, 1, 3);
      lQuery.ParamByName('BCPG').AsString := copy(pContasReceber.Local_Pagamento.codigo, 1, 3);
      lQuery.ParamByName('SIT').AsString := copy(pContasReceber.Situacao, 1, 1);
      lQuery.ParamByName('FRPGTO').AsInteger := pContasReceber.Forma_Pagamento.codigo;
      lQuery.ParamByName('JUROS').AsFloat := RoundTo(pContasReceber.Juros, -2);
      lQuery.ParamByName('DESC').AsFloat := RoundTo(pContasReceber.Desconto, -2);
      lQuery.ParamByName('DTPGTO').AsDate := StrToDatedef(pContasReceber.Data_Pagamento, now);
      lQuery.ParamByName('VLPAGO').AsFloat := RoundTo(pContasReceber.Valor_Pago, -2);
      lQuery.ParamByName('TOTALPAGO').AsFloat := RoundTo(pContasReceber.Total_Pago, -2);
      lQuery.ParamByName('DHCAD').AsDateTime := StrToDateTimeDef(pContasReceber.Data_Hora_Cadastro, now);
      lQuery.ParamByName('DHPGTO').AsDateTime := StrToDateTimeDef(pContasReceber.Data_Hora_Pagamento, now);
      lQuery.ParamByName('USUCAD').AsInteger := pContasReceber.Usuario_Cadastro;
      lQuery.ParamByName('USUPGTO').AsInteger := pContasReceber.Usuario_Pagamento;
      lQuery.ParamByName('DHALT').AsDateTime := StrToDateTimeDef(pContasReceber.Data_Hora_Alteracao, now);
      lQuery.ParamByName('USUALT').AsInteger := pContasReceber.Usuario_Alteracao;
      lQuery.ParamByName('ORIG').AsString := copy(pContasReceber.Origem, 1, 2);
      lQuery.ParamByName('VLORIG').AsFloat := RoundTo(pContasReceber.Valor_Origem, -2);
      lQuery.ParamByName('BXPARCIAL').AsString := copy(pContasReceber.Baixa_Parcial, 1, 1);
      lQuery.ParamByName('ANO').AsString := copy(pContasReceber.Ano, 1, 4);
      lQuery.ParamByName('MES').AsString := copy(pContasReceber.Mes, 1, 2);
      lQuery.ParamByName('OBS1').AsString := copy(pContasReceber.Obs1, 1, 50);
      lQuery.ParamByName('OBS2').AsString := copy(pContasReceber.Obs2, 1, 50);
      lQuery.ParamByName('COMISSAO').AsFloat := RoundTo(pContasReceber.Comissao, -2);
      lQuery.ParamByName('VL_ORIGINAL').AsFloat := RoundTo(pContasReceber.Valor_Original, -2);
      lQuery.ParamByName('VL_PRINCIPAL').AsFloat := RoundTo(pContasReceber.Valor_Principal, -2);
      lQuery.ParamByName('TOTAL_REC').AsFloat := RoundTo(pContasReceber.Total_Receber, -2);
      lQuery.ParamByName('CTA').AsString := copy(pContasReceber.Conta.codigo, 1, 3);
      lQuery.ParamByName('EMPRESA').AsInteger := StrToIntDef(pContasReceber.Empresa, 0);
      lQuery.ParamByName('FRPGTO_BAIXARCR').AsInteger := pContasReceber.Forma_Pagamento.codigo;
      lQuery.ParamByName('EMP_DUP').AsString := copy(pContasReceber.empresa_duplicata, 1, 30);

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

class function TContasReceberDAO.Carrega(pContasReceber: TContasReceber): Boolean;
var
  lQuery: Tquery;

  lClieOk, lVendOk, lFormaPagOk, lFormaPagBaixarOk, lContaOk, lLocalCobOk, lLocalPagOk: Boolean;
begin

  lQuery := Tquery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' select * from CREC                          ');
    lQuery.SQL.Add(' left join TBL_CONFIGURACAO_FIN                  ');
    lQuery.SQL.Add(' on ID = 1                                       ');
    lQuery.SQL.Add(' where DUP = :DUP                        ');
    lQuery.ParamByName('DUP').AsString := pContasReceber.Duplicata;
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      // carrega dados
      pContasReceber.Duplicata := lQuery.FieldByName('DUP').AsString;
      pContasReceber.chave_empresa := lQuery.FieldByName('CHAVE_EMPRESA').AsString;
      pContasReceber.data_ultimo_sincronismo := lQuery.FieldByName('ULTIMA_SINC_CR').AsString;
      pContasReceber.Empresa := lQuery.FieldByName('EMPRESA').AsString;
      pContasReceber.Emissao := TFunctions.DecodeDateHourJson(lQuery.FieldByName('EMISSAO').AsDateTime);
      pContasReceber.Valor := RoundTo(lQuery.FieldByName('VALOR').AsFloat, -2);
      pContasReceber.Vencimento := TFunctions.DecodeDateJson(lQuery.FieldByName('VCTO').AsDateTime);
      pContasReceber.Fluxo := TFunctions.DecodeDateJson(lQuery.FieldByName('FLUXO').AsDateTime);
      pContasReceber.Situacao := lQuery.FieldByName('SIT').AsString;
      pContasReceber.Juros := RoundTo(lQuery.FieldByName('JUROS').AsFloat, -2);
      pContasReceber.Desconto := RoundTo(lQuery.FieldByName('DESC').AsFloat, -2);
      pContasReceber.Data_Pagamento := TFunctions.DecodeDateJson(lQuery.FieldByName('DTPGTO').AsDateTime);
      pContasReceber.Valor_Pago := RoundTo(lQuery.FieldByName('VLPAGO').AsFloat, -2);
      pContasReceber.Total_Pago := RoundTo(lQuery.FieldByName('TOTALPAGO').AsFloat, -2);
      pContasReceber.Data_Hora_Cadastro := TFunctions.DecodeDateHourJson(lQuery.FieldByName('DHCAD').AsDateTime);
      pContasReceber.Data_Hora_Pagamento := TFunctions.DecodeDateHourJson(lQuery.FieldByName('DHPGTO').AsDateTime);
      pContasReceber.Usuario_Cadastro := lQuery.FieldByName('USUCAD').AsInteger;
      pContasReceber.Usuario_Pagamento := lQuery.FieldByName('USUPGTO').AsInteger;
      pContasReceber.Data_Hora_Alteracao := TFunctions.DecodeDateHourJson(lQuery.FieldByName('DHALT').AsDateTime);
      pContasReceber.Usuario_Alteracao := lQuery.FieldByName('USUALT').AsInteger;
      pContasReceber.Origem := lQuery.FieldByName('ORIG').AsString;
      pContasReceber.Valor_Origem := RoundTo(lQuery.FieldByName('VLORIG').AsFloat, -2);
      pContasReceber.Baixa_Parcial := lQuery.FieldByName('BXPARCIAL').AsString;
      pContasReceber.Ano := lQuery.FieldByName('ANO').AsString;
      pContasReceber.Mes := lQuery.FieldByName('MES').AsString;
      pContasReceber.Obs1 := lQuery.FieldByName('OBS1').AsString;
      pContasReceber.Obs2 := lQuery.FieldByName('OBS2').AsString;
      pContasReceber.Comissao := RoundTo(lQuery.FieldByName('COMISSAO').AsFloat, -2);
      pContasReceber.Valor_Original := RoundTo(lQuery.FieldByName('VL_ORIGINAL').AsFloat, -2);
      pContasReceber.Valor_Principal := RoundTo(lQuery.FieldByName('VL_PRINCIPAL').AsFloat, -2);
      pContasReceber.Total_Receber := RoundTo(lQuery.FieldByName('TOTAL_REC').AsFloat, -2);
      pContasReceber.empresa_duplicata := lQuery.FieldByName('EMP_DUP').AsString;

      // Classes
      pContasReceber.Cliente.codigo := lQuery.FieldByName('CLIENTE').AsInteger;
      lClieOk := TClienteDAO.Carrega(pContasReceber.Cliente);

      pContasReceber.Vendedor.codigo := lQuery.FieldByName('VEND').AsInteger;
      lVendOk := TVendedorDAO.Carrega(pContasReceber.Vendedor);

      pContasReceber.Forma_Pagamento.codigo := lQuery.FieldByName('FRPGTO').AsInteger;
      lFormaPagOk := TFormaPagamentoDAO.Carrega(pContasReceber.Forma_Pagamento);

      pContasReceber.Forma_Pagamento_Baixar.codigo := lQuery.FieldByName('FRPGTO_BAIXARCR').AsInteger;
      lFormaPagBaixarOk := TFormaPagamentoDAO.Carrega(pContasReceber.Forma_Pagamento_Baixar);

      pContasReceber.Conta.codigo := lQuery.FieldByName('CTA').AsString;
      lContaOk := TContaDAO.Carrega(pContasReceber.Conta);

      pContasReceber.Local_Cobranca.codigo := lQuery.FieldByName('BCOR').AsString;
      lLocalCobOk := TBancoDAO.Carrega(pContasReceber.Local_Cobranca);

      pContasReceber.Local_Pagamento.codigo := lQuery.FieldByName('BCPG').AsString;
      lLocalPagOk := TBancoDAO.Carrega(pContasReceber.Local_Pagamento);
    end;

  finally
    lQuery.Free;
  end;
end;

class function TContasReceberDAO.Delete(pDuplicata, pData: String): Boolean;
var
  lHttp: TConnectionRest;
  lJson: string;
  function Tratamento: Boolean;
  begin
    if (copy(IntToStr(lHttp.RestResponse.StatusCode), 1)) = '2' then
    begin
      TMessages.Messages.MessageOk := TMessages.Messages.MessageOk +
        ('DELETE - Contas Receber: ' + pDuplicata + ' - ' + DateTimeToStr(TFunctions.DateServer) + sLineBreak);
      result := true;
    end
    else
    begin
      TMessages.Messages.MessageErro := TMessages.Messages.MessageErro +
        ('DELETE - Contas Receber: ' + pDuplicata + ' - Não Excluido - Motivo/Erro: ' +
        IntToStr(lHttp.RestResponse.StatusCode) + ' - ' + lHttp.RestResponse.Content + ' - ' +
        DateTimeToStr(TFunctions.DateServer)) + sLineBreak;
      result := false;
    end;
  end;

begin
  lHttp := TConnectionRest.Create;
  try
    lJson := '{"duplicata":"' + pDuplicata + '", "data_ultima_alteracao":"' + pData + '"}';
    lHttp.ConfigureRest(rmDELETE, tDeleteCR, lJson);
    result := Tratamento;
  finally
    lHttp.Free;
  end;
end;

class function TContasReceberDAO.Excluir(pDuplicata: string; pCommit: Boolean = true): Boolean;
var
  lQuery: Tquery;
begin
  lQuery := Tquery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM CREC WHERE DUP = :DUP ');
    lQuery.ParamByName('DUP').AsString := pDuplicata;
    lQuery.ExecSQL;
    lQuery.Connection.commit;
  finally
    lQuery.Free;
  end;

end;

class function TContasReceberDAO.ExcluirPelaDuplicataEmpresa(pDuplicata: string; pCommit: Boolean = true): Boolean;
var
  lQuery: Tquery;
begin
  result := false;
  lQuery := Tquery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' select * from CREC  WHERE EMP_DUP = :EMP_DUP ');
    lQuery.ParamByName('EMP_DUP').AsString := pDuplicata;
    lQuery.Open;
    lQuery.FetchAll;

    if lQuery.RecordCount > 0 then
    begin
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add('DELETE FROM CREC WHERE EMP_DUP = :EMP_DUP ');
      lQuery.ParamByName('EMP_DUP').AsString := pDuplicata;
      lQuery.ExecSQL;
      lQuery.Connection.commit;

      result := true;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TContasReceberDAO.Existe(pDuplicata: string): Boolean;
var
  lQuery: Tquery;
begin
  result := false;
  lQuery := Tquery.Create(nil);
  try

    lQuery.SQL.Add('SELECT * FROM CREC WHERE DUP = :DUP');
    lQuery.ParamByName('DUP').AsString := pDuplicata;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      result := true;
    end;
  finally
    lQuery.Free;
  end;
end;

class function TContasReceberDAO.ExisteEmpresaDuplicata(pDuplicata: string): Boolean;
var
  lQuery: Tquery;
begin
  result := false;

  if trim(pDuplicata) <> EmptyStr then
  begin
    lQuery := Tquery.Create(nil);
    try
      lQuery.SQL.Add('SELECT * FROM CREC WHERE EMP_DUP = :EMP_DUP');
      lQuery.ParamByName('EMP_DUP').AsString := pDuplicata;
      lQuery.Open;

      result := lQuery.RecordCount > 0;
    finally
      lQuery.Free;
    end;
  end;
end;

class function TContasReceberDAO.GeraProximoCodigo: integer;
var
  lQuery: Tquery;
begin
  result := 0;
  lQuery := Tquery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT MAX(TIT) + 1 PROXIMO_CODIGO FROM CPAG ');
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      result := lQuery.FieldByName('PROXIMO_CODIGO').AsInteger;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TContasReceberDAO.GeraProximaDuplicataIntegracao: string;
var
  lQuery: Tquery;
  lProximoNumero: integer;
begin
  lQuery := Tquery.Create(nil);

  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT FIRST 1 CAST(substring(DUP FROM 6 FOR CHAR_LENGTH(DUP)-5) AS int) AS PROX_NUMERO ');
    lQuery.SQL.Add(' from CREC                                                                                   ');
    lQuery.SQL.Add(' where substring(DUP FROM 1 FOR 3) = ''INT''                                                 ');
    lQuery.SQL.Add(' order by 1 desc                                                                                 ');
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

class function TContasReceberDAO.Get(pAll: Boolean = false): Boolean;
var
  lJson: TJSONObject;
  lJsonArray: TJSONArray;
  lContaRegistros, lTotalVendas, i: integer;
  lDataUltimaSinc: TDateTime;
  lCR: TContasReceber;
  lExcluido: Boolean;
  lResposta, lDataTimeCP: string;
  lHttp: TConnectionRest;
  CrOk, CrVendOk, CrLocalOk, CrLocalpagOk, CrFormaOk, CrFormaBaixarOk, CrContaOk, CrClienteOk: Boolean;

begin
  TContador.Contador.RecebimentoCR := 0;
  TContador.Contador.TotalRecebimentoCR := 0;
  TMessages.Messages.MessageOk := EmptyStr;
  TMessages.Messages.MessageErro := EmptyStr;
  try
    lHttp := TConnectionRest.Create;
    try
      lDataUltimaSinc := TFunctions.RetornaUltimoSincCR;

      if pAll then
      begin
        lDataTimeCP := '2000/01/01 00:00:00';
      end
      else
      begin
        lDataTimeCP := TFunctions.DecodeDateHourJson(lDataUltimaSinc);
      end;

      tsettings.settings.DataFormatada := lDataTimeCP;
      ttoken.AccessToken;
      lHttp.ConfigureRest(rmGET, tGetCR, '');

      if lHttp.RestResponse.StatusCode = 401 then
      begin
        lHttp.GetAccessToken;
        lHttp.ConfigureRest(rmGET, tGetCP, '');
      end;

      if (TFunctions.LengthString(IntToStr(lHttp.RestResponse.StatusCode), 1)) = '2' then
      begin
        lCR := TContasReceber.Create;
        try
          lJson := TJSONObject.ParseJSONValue(lHttp.RestResponse.Content) as TJSONObject;
          lJsonArray := lJson.GetValue<TJSONArray>('contas') as TJSONArray;
          TContador.Contador.TotalRecebimentoCR := lJsonArray.Count;

          for i := 0 to lJsonArray.Count - 1 do
          begin
            if (lJsonArray <> nil) then
            begin
              TContador.Contador.RecebimentoCR := TContador.Contador.RecebimentoCR + 1;
              lJson := lJsonArray.Items[i] as TJSONObject;
              lJson := lJson.GetValue<TJSONObject> as TJSONObject;
             // ShowMessage(lJson.ToString);

              lExcluido := lJson.GetValue<String>('excluido') = 'S';

              if lExcluido then // Variavel Utilizada pra baixar ou deletar apartir do GET da api
              begin
                if lJson.GetValue<String>('duplicata') <> '' then
                begin
                  lCR.empresa_duplicata := lJson.GetValue<String>('duplicata');
                  if ExcluirPelaDuplicataEmpresa(lCR.empresa_duplicata) then
                  begin
                    TContador.Contador.Excluido := TContador.Contador.Excluido + 1;
                    TMessages.Messages.MessageOk := (TMessages.Messages.MessageOk + 'GET - Exclusão da Duplicata: ' +
                      RetornaDuplicataPelaDuplicataEmpresa(lJson.GetValue<String>('Duplicata')) +
                      ' - Duplicata Empresa: ' + lJson.GetValue<String>('Duplicata') + ' - ' +
                      DateTimeToStr(TFunctions.DateServer) + sLineBreak);
                  end
                  else
                  begin
                    TContador.Contador.Excluido := TContador.Contador.Excluido + 1;
                    TMessages.Messages.MessageErro :=
                      (TMessages.Messages.MessageErro + 'GET - Não encontrado para exclusão a Duplicata: ' +
                      RetornaDuplicataPelaDuplicataEmpresa(lJson.GetValue<String>('Duplicata')) +
                      ' - Duplicata Empresa: ' + lJson.GetValue<String>('Duplicata') + ' - ' +
                      DateTimeToStr(TFunctions.DateServer) + sLineBreak);
                  end;
                end;
              end
              else
              begin
                Limpar(lCR);
                CrOk := MontaObjetoContasReceber(lJson, lCR);
                CrVendOk := MontaObjetoVendedorContasReceber(lJson, lCR);
                CrLocalOk := MontaObjetoLocalCobrancaContasReceber(lJson, lCR);
                CrLocalpagOk := MontaObjetoLocalPagamentoContasReceber(lJson, lCR);
                CrFormaOk := MontaObjetoFormaPagamentoContasReceber(lJson, lCR);
                CrFormaBaixarOk := MontaObjetoFormaPagamentoBaixarContasReceber(lJson, lCR);
                CrContaOk := MontaObjetoContaContasReceber(lJson, lCR);
                CrClienteOk := MontaObjetoClienteContasReceber(lJson, lCR);

                if CrClienteOk then
                begin
                  lCR.data_ultimo_sincronismo := TFunctions.DecodeDateHourJson(lDataUltimaSinc);
                  lCR.Empresa := TFunctions.RetornaCodigoEmpresa;
                  lResposta := IncluirOuAltera(lCR);

                  TMessages.Messages.MessageOk := TMessages.Messages.MessageOk +
                    (lResposta + ' - ' + DateTimeToStr(TFunctions.DateServer) + sLineBreak);
                  TContador.Contador.Sucesso := TContador.Contador.Sucesso + 1;
                end
                else
                begin
                  TMessages.Messages.MessageErro := TMessages.Messages.MessageErro +
                    ('Get - Contas Receber: ' + lCR.empresa_duplicata +
                    ' - Não incluido/alterado pois o cliente é inválido. ' + DateTimeToStr(TFunctions.DateServer) +
                    sLineBreak);
                  TContador.Contador.Sucesso := TContador.Contador.Sucesso + 1;
                end;
              end;
            end;
          end;

        finally
          lCR.Free;
        end;
        result := true;
      end
      else if (lHttp.RestResponse.StatusCode <> 400) then
      begin
        tsettings.settings.PermiteAlterarDataSincronismoCR := false;
        TMessages.Messages.MessageErro := TMessages.Messages.MessageErro +
          ('Error:' + IntToStr(lHttp.RestResponse.StatusCode) + sLineBreak);
        result := false;
      end;

    finally
      lHttp.Free;
    end;
  except
    on E: Exception do
    begin
      tsettings.settings.PermiteAlterarDataSincronismoCR := false;
      result := false;
    end;
  end;
end;

class function TContasReceberDAO.Incluir(pContasReceber: TContasReceber; pCommit: Boolean = true): Boolean;
var
  lQuery: Tquery;
begin
  try
    lQuery := Tquery.Create(nil);
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add('  INSERT INTO CREC (     ');
      lQuery.SQL.Add('    EMPRESA              ');
      lQuery.SQL.Add('  , EMISSAO              ');
      lQuery.SQL.Add('  , CLIENTE              ');
      lQuery.SQL.Add('  , VALOR                ');
      lQuery.SQL.Add('  , VCTO                 ');
      lQuery.SQL.Add('  , FLUXO                ');
      lQuery.SQL.Add('  , VEND                 ');
      lQuery.SQL.Add('  , BCOR                 ');
      lQuery.SQL.Add('  , BCPG                 ');
      lQuery.SQL.Add('  , SIT                  ');
      lQuery.SQL.Add('  , FRPGTO               ');
      lQuery.SQL.Add('  , JUROS                ');
      lQuery.SQL.Add('  , DESC                 ');
      lQuery.SQL.Add('  , DTPGTO               ');
      lQuery.SQL.Add('  , VLPAGO               ');
      lQuery.SQL.Add('  , TOTALPAGO            ');
      lQuery.SQL.Add('  , DHCAD                ');
      lQuery.SQL.Add('  , DHPGTO               ');
      lQuery.SQL.Add('  , USUCAD               ');
      lQuery.SQL.Add('  , USUPGTO              ');
      lQuery.SQL.Add('  , DHALT                ');
      lQuery.SQL.Add('  , USUALT               ');
      lQuery.SQL.Add('  , ORIG                 ');
      lQuery.SQL.Add('  , VLORIG               ');
      lQuery.SQL.Add('  , BXPARCIAL            ');
      lQuery.SQL.Add('  , DT1                  ');
      lQuery.SQL.Add('  , VL1                  ');
      lQuery.SQL.Add('  , DT2                  ');
      lQuery.SQL.Add('  , VL2                  ');
      lQuery.SQL.Add('  , DT3                  ');
      lQuery.SQL.Add('  , VL3                  ');
      lQuery.SQL.Add('  , DT4                  ');
      lQuery.SQL.Add('  , VL4                  ');
      lQuery.SQL.Add('  , ANO                 ');
      lQuery.SQL.Add('  , MES                 ');
      lQuery.SQL.Add('  , OBS1                ');
      lQuery.SQL.Add('  , OBS2                ');
      lQuery.SQL.Add('  , COMISSAO            ');
      lQuery.SQL.Add('  , DUP                  ');
      lQuery.SQL.Add('  , VL_ORIGINAL         ');
      lQuery.SQL.Add('  , VL_PRINCIPAL        ');
      lQuery.SQL.Add('  , JUROS               ');
      lQuery.SQL.Add('  , DESCONTOS           ');
      lQuery.SQL.Add('  , TOTAL_REC           ');
      lQuery.SQL.Add('  , CTA                 ');
      lQuery.SQL.Add('  , EMPRESA             ');
      lQuery.SQL.Add('  , FRPGTO_BAIXARCR      ');
      lQuery.SQL.Add('  , EMP_DUP              ');
      lQuery.SQL.Add('  ) values (                 ');
      lQuery.SQL.Add('    :EMPRESA             ');
      lQuery.SQL.Add('  , :EMISSAO             ');
      lQuery.SQL.Add('  , :CLIENTE             ');
      lQuery.SQL.Add('  , :VALOR               ');
      lQuery.SQL.Add('  , :VCTO                ');
      lQuery.SQL.Add('  , :FLUXO               ');
      lQuery.SQL.Add('  , :VEND                ');
      lQuery.SQL.Add('  , :BCOR                ');
      lQuery.SQL.Add('  , :BCPG                ');
      lQuery.SQL.Add('  , :SIT                 ');
      lQuery.SQL.Add('  , :FRPGTO              ');
      lQuery.SQL.Add('  , :JUROS               ');
      lQuery.SQL.Add('  , :DESC                ');
      lQuery.SQL.Add('  , :DTPGTO              ');
      lQuery.SQL.Add('  , :VLPAGO              ');
      lQuery.SQL.Add('  , :TOTALPAGO           ');
      lQuery.SQL.Add('  , :DHCAD               ');
      lQuery.SQL.Add('  , :DHPGTO              ');
      lQuery.SQL.Add('  , :USUCAD              ');
      lQuery.SQL.Add('  , :USUPGTO             ');
      lQuery.SQL.Add('  , :DHALT               ');
      lQuery.SQL.Add('  , :USUALT              ');
      lQuery.SQL.Add('  , :ORIG                ');
      lQuery.SQL.Add('  , :VLORIG              ');
      lQuery.SQL.Add('  , :BXPARCIAL           ');
      lQuery.SQL.Add('  , :DT1                 ');
      lQuery.SQL.Add('  , :VL1                 ');
      lQuery.SQL.Add('  , :DT2                 ');
      lQuery.SQL.Add('  , :VL2                 ');
      lQuery.SQL.Add('  , :DT3                 ');
      lQuery.SQL.Add('  , :VL3                 ');
      lQuery.SQL.Add('  , :DT4                 ');
      lQuery.SQL.Add('  , :VL4                 ');
      lQuery.SQL.Add('  , :ANO                ');
      lQuery.SQL.Add('  , :MES                ');
      lQuery.SQL.Add('  , :OBS1               ');
      lQuery.SQL.Add('  , :OBS2               ');
      lQuery.SQL.Add('  , :COMISSAO           ');
      lQuery.SQL.Add('  , :DUP                 ');
      lQuery.SQL.Add('  , :VL_ORIGINAL        ');
      lQuery.SQL.Add('  , :VL_PRINCIPAL       ');
      lQuery.SQL.Add('  , :JUROS              ');
      lQuery.SQL.Add('  , :DESCONTOS          ');
      lQuery.SQL.Add('  , :TOTAL_REC          ');
      lQuery.SQL.Add('  , :CTA                ');
      lQuery.SQL.Add('  , :EMPRESA            ');
      lQuery.SQL.Add('  , :FRPGTO_BAIXARCR     ');
      lQuery.SQL.Add('  , :EMP_DUP             ');
      lQuery.SQL.Add('  )                          ');
      lQuery.ParamByName('DUP').AsString := copy(pContasReceber.Duplicata, 1, 12);
      lQuery.ParamByName('EMISSAO').AsDate := StrToDatedef(pContasReceber.Emissao, now);
      lQuery.ParamByName('CLIENTE').AsInteger := pContasReceber.Cliente.codigo;
      lQuery.ParamByName('VALOR').AsFloat := RoundTo(pContasReceber.Valor, -2);
      lQuery.ParamByName('VCTO').AsDate := StrToDatedef(pContasReceber.Vencimento, now);
      lQuery.ParamByName('FLUXO').AsDate := StrToDatedef(pContasReceber.Fluxo, now);
      lQuery.ParamByName('VEND').AsInteger := pContasReceber.Vendedor.codigo;
      lQuery.ParamByName('BCOR').AsString := copy(pContasReceber.Local_Cobranca.codigo, 1, 3);
      lQuery.ParamByName('BCPG').AsString := copy(pContasReceber.Local_Pagamento.codigo, 1, 3);
      lQuery.ParamByName('SIT').AsString := copy(pContasReceber.Situacao, 1, 1);
      lQuery.ParamByName('FRPGTO').AsInteger := pContasReceber.Forma_Pagamento.codigo;
      lQuery.ParamByName('JUROS').AsFloat := RoundTo(pContasReceber.Juros, -2);
      lQuery.ParamByName('DESC').AsFloat := RoundTo(pContasReceber.Desconto, -2);
      lQuery.ParamByName('DTPGTO').AsDate := StrToDatedef(pContasReceber.Data_Pagamento, now);
      lQuery.ParamByName('VLPAGO').AsFloat := RoundTo(pContasReceber.Valor_Pago, -2);
      lQuery.ParamByName('TOTALPAGO').AsFloat := RoundTo(pContasReceber.Total_Pago, -2);
      lQuery.ParamByName('DHCAD').AsDateTime := StrToDateTimeDef(pContasReceber.Data_Hora_Cadastro, now);
      lQuery.ParamByName('DHPGTO').AsDateTime := StrToDateTimeDef(pContasReceber.Data_Hora_Pagamento, now);
      lQuery.ParamByName('USUCAD').AsInteger := pContasReceber.Usuario_Cadastro;
      lQuery.ParamByName('USUPGTO').AsInteger := pContasReceber.Usuario_Pagamento;
      lQuery.ParamByName('DHALT').AsDateTime := StrToDateTimeDef(pContasReceber.Data_Hora_Alteracao, now);
      lQuery.ParamByName('USUALT').AsInteger := pContasReceber.Usuario_Alteracao;
      lQuery.ParamByName('ORIG').AsString := copy(pContasReceber.Origem, 1, 2);
      lQuery.ParamByName('VLORIG').AsFloat := RoundTo(pContasReceber.Valor_Origem, -2);
      lQuery.ParamByName('BXPARCIAL').AsString := copy(pContasReceber.Baixa_Parcial, 1, 1);
      lQuery.ParamByName('ANO').AsString := copy(pContasReceber.Ano, 1, 4);
      lQuery.ParamByName('MES').AsString := copy(pContasReceber.Mes, 1, 2);
      lQuery.ParamByName('OBS1').AsString := copy(pContasReceber.Obs1, 1, 50);
      lQuery.ParamByName('OBS2').AsString := copy(pContasReceber.Obs2, 1, 50);
      lQuery.ParamByName('COMISSAO').AsFloat := RoundTo(pContasReceber.Comissao, -2);
      lQuery.ParamByName('VL_ORIGINAL').AsFloat := RoundTo(pContasReceber.Valor_Original, -2);
      lQuery.ParamByName('VL_PRINCIPAL').AsFloat := RoundTo(pContasReceber.Valor_Principal, -2);
      lQuery.ParamByName('TOTAL_REC').AsFloat := RoundTo(pContasReceber.Total_Receber, -2);
      lQuery.ParamByName('CTA').AsString := copy(pContasReceber.Conta.codigo, 1, 3);
      lQuery.ParamByName('EMPRESA').AsInteger := StrToIntDef(pContasReceber.Empresa, 0);
      lQuery.ParamByName('FRPGTO_BAIXARCR').AsInteger := pContasReceber.Forma_Pagamento.codigo;
      lQuery.ParamByName('EMP_DUP').AsString := copy(pContasReceber.empresa_duplicata, 1, 30);
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

class function TContasReceberDAO.IncluirOuAltera(pContasReceber: TContasReceber; pCommit: Boolean = true): String;
var
  lQuery: Tquery;
  lDuplicata: string;
begin
  try
    lDuplicata := EmptyStr;
    lQuery := Tquery.Create(nil);
    try
      // Validação se existe a duplicata, para alterarmos
      if ExisteEmpresaDuplicata(pContasReceber.empresa_duplicata) then
      begin
        lDuplicata := RetornaDuplicataPelaDuplicataEmpresa(copy(pContasReceber.empresa_duplicata, 1, 30));
        pContasReceber.duplicata := lDuplicata;
        Alterar(pContasReceber);

        lQuery.Close;
        lQuery.SQL.Clear;
        lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CR (                 ');
        lQuery.SQL.Add(' DUPLICATA, DATA_ATUALIZACAO, EXCLUIDO, ENVIADO)      ');
        lQuery.SQL.Add(' VALUES (:DUPLICATA, :DATA_ATUALIZACAO, ''N'', ''S'') ');
        lQuery.SQL.Add(' MATCHING (DUPLICATA)                                    ');
        lQuery.ParamByName('DUPLICATA').AsString := lDuplicata;
        lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime :=
          incminute(TFunctions.DecodeStringToDate(pContasReceber.data_ultimo_sincronismo), -1);
        lQuery.ExecSQL;
        lQuery.Connection.commit;

        result := 'GET - Alterado a DUPLICATA: ' + lDuplicata + ' - DUPLICATA Empresa: ' +
          pContasReceber.empresa_duplicata;
      end
      else // se não existir, a incluimos com INT + cod empresa + numero incremental
      begin
        lDuplicata := 'INT' + copy(pContasReceber.empresa_duplicata, 1, 1) + '-' + GeraProximaDuplicataIntegracao;
        pContasReceber.Duplicata := lDuplicata;
        Incluir(pContasReceber);

        lQuery.Close;
        lQuery.SQL.Clear;
        lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CR (              ');
        lQuery.SQL.Add(' DUPLICATA, DATA_ATUALIZACAO, EXCLUIDO, ENVIADO)      ');
        lQuery.SQL.Add(' VALUES (:DUPLICATA, :DATA_ATUALIZACAO, ''N'', ''S'') ');
        lQuery.SQL.Add(' MATCHING (DUPLICATA)                                 ');
        lQuery.ParamByName('DUPLICATA').AsString := lDuplicata;
        lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime :=
          incminute(TFunctions.DecodeStringToDate(pContasReceber.data_ultimo_sincronismo), -1);
        lQuery.ExecSQL;
        lQuery.Connection.commit;

        result := 'GET - Incluido a DUPLICATA: ' + lDuplicata + ' - DUPLICATA Empresa: ' +
          pContasReceber.empresa_duplicata;
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

class function TContasReceberDAO.Limpar(pContasReceber: TContasReceber): Boolean;
begin
  pContasReceber.empresa_duplicata := EmptyStr;
  pContasReceber.Duplicata := EmptyStr;
  pContasReceber.chave_empresa := EmptyStr;
  pContasReceber.Empresa := EmptyStr;
  pContasReceber.Emissao := EmptyStr;
  pContasReceber.Valor := 0;
  pContasReceber.Vencimento := EmptyStr;
  pContasReceber.Fluxo := EmptyStr;
  pContasReceber.Situacao := EmptyStr;
  pContasReceber.Juros := 0;
  pContasReceber.Desconto := 0;
  pContasReceber.Data_Pagamento := EmptyStr;
  pContasReceber.Valor_Pago := 0;
  pContasReceber.Total_Pago := 0;
  pContasReceber.Data_Hora_Cadastro := EmptyStr;
  pContasReceber.Data_Hora_Pagamento := EmptyStr;
  pContasReceber.Usuario_Cadastro := 0;
  pContasReceber.Usuario_Pagamento := 0;
  pContasReceber.Data_Hora_Alteracao := EmptyStr;
  pContasReceber.Usuario_Alteracao := 0;
  pContasReceber.Origem := EmptyStr;
  pContasReceber.Valor_Origem := 0;
  pContasReceber.Baixa_Parcial := EmptyStr;
  pContasReceber.Ano := EmptyStr;
  pContasReceber.Mes := EmptyStr;
  pContasReceber.Obs1 := EmptyStr;
  pContasReceber.Obs2 := EmptyStr;
  pContasReceber.Comissao := 0;
  pContasReceber.Valor_Original := 0;
  pContasReceber.Valor_Principal := 0;
  pContasReceber.Total_Receber := 0;
  pContasReceber.data_ultimo_sincronismo := EmptyStr;
  pContasReceber.empresa_duplicata := EmptyStr;
end;

class function TContasReceberDAO.MontaObjetoClienteContasReceber(pJson: TJSONObject;
  pContasReceber: TContasReceber): Boolean;
var
  lJsonArray: TJSONArray;
  lJsonCli: TJSONObject;
  lJsonCid: TJSONObject;
  lCPF, lCNPJ: string;
  lCodigo: integer;
begin

  try
    lCodigo := 0;

    if not TFunctions.ObjectIsNull('cliente', pJson.ToString) then
    begin

      lJsonCli := pJson.GetValue<TJSONObject>('cliente') as TJSONObject;

      if TFunctions.ColumnExists('nome', lJsonCli.ToString) and (lJsonCli.GetValue<String>('nome') <> '') then
      begin
        pContasReceber.Cliente.nome := lJsonCli.GetValue<String>('nome');
      end;

      if TFunctions.ColumnExists('cpf', lJsonCli.ToString) and (lJsonCli.GetValue<String>('cpf') <> '') then
      begin
        lCPF := lJsonCli.GetValue<String>('cpf');
        pContasReceber.Cliente.cpf := lCPF;
      end;

      if TFunctions.ColumnExists('cnpj', lJsonCli.ToString) and (lJsonCli.GetValue<String>('cnpj') <> '') then
      begin
        lCNPJ := lJsonCli.GetValue<String>('cnpj');
        pContasReceber.Cliente.cnpj := lCNPJ;
      end;

      if TFunctions.ColumnExists('forma_de_pagamento_padrao', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('forma_de_pagamento_padrao') <> '') then
      begin
        pContasReceber.Cliente.forma_de_pagamento_padrao := lJsonCli.GetValue<integer>('forma_de_pagamento_padrao');
      end;
      if TFunctions.ColumnExists('limite_de_credito', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('limite_de_credito') <> '') then
      begin
        pContasReceber.Cliente.limite_de_credito := lJsonCli.GetValue<Double>('limite_de_credito');
      end;
      if TFunctions.ColumnExists('tipo_de_credito', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('tipo_de_credito') <> '') then
      begin
        pContasReceber.Cliente.tipo_de_credito := lJsonCli.GetValue<String>('tipo_de_credito');
      end;
      if TFunctions.ColumnExists('ativo', lJsonCli.ToString) and (lJsonCli.GetValue<String>('ativo') <> '') then
      begin
        pContasReceber.Cliente.ativo := lJsonCli.GetValue<Boolean>('ativo');
      end;
      if TFunctions.ColumnExists('prazo_maximo_em_dias', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('prazo_maximo_em_dias') <> '') then
      begin
        pContasReceber.Cliente.prazo_maximo_em_dias := lJsonCli.GetValue<integer>('prazo_maximo_em_dias');
      end;
      if TFunctions.ColumnExists('pessoa_fisica', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('pessoa_fisica') <> '') then
      begin
        pContasReceber.Cliente.pessoa_fisica := lJsonCli.GetValue<Boolean>('pessoa_fisica');
      end;

      if TFunctions.ColumnExists('saldo_calculado', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('saldo_calculado') <> '') then
      begin
        pContasReceber.Cliente.saldo_calculado := lJsonCli.GetValue<Double>('saldo_calculado');
      end;
      if TFunctions.ColumnExists('ativo_no_spc', lJsonCli.ToString) and (lJsonCli.GetValue<String>('ativo_no_spc') <> '')
      then
      begin
        pContasReceber.Cliente.ativo_no_spc := lJsonCli.GetValue<Boolean>('ativo_no_spc');
      end;
      if TFunctions.ColumnExists('valor_limite_do_cliente', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('valor_limite_do_cliente') <> '') then
      begin
        pContasReceber.Cliente.valor_limite_do_cliente := lJsonCli.GetValue<Double>('valor_limite_do_cliente');
      end;
      if TFunctions.ColumnExists('dia_fixo_de_vencimento', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('dia_fixo_de_vencimento') <> '') then
      begin
        pContasReceber.Cliente.dia_fixo_de_vencimento := lJsonCli.GetValue<integer>('dia_fixo_de_vencimento');
      end;
      if TFunctions.ColumnExists('ie', lJsonCli.ToString) and (lJsonCli.GetValue<String>('ie') <> '') then
      begin
        pContasReceber.Cliente.ie := lJsonCli.GetValue<String>('ie');
      end;
      if TFunctions.ColumnExists('fone', lJsonCli.ToString) and (lJsonCli.GetValue<String>('fone') <> '') then
      begin
        pContasReceber.Cliente.fone := lJsonCli.GetValue<String>('fone');
      end;
      if TFunctions.ColumnExists('email', lJsonCli.ToString) and (lJsonCli.GetValue<String>('email') <> '') then
      begin
        pContasReceber.Cliente.email := lJsonCli.GetValue<String>('email');
      end;
      if TFunctions.ColumnExists('bairro', lJsonCli.ToString) and (lJsonCli.GetValue<String>('bairro') <> '') then
      begin
        pContasReceber.Cliente.bairro := lJsonCli.GetValue<String>('bairro');
      end;
      if TFunctions.ColumnExists('fax', lJsonCli.ToString) and (lJsonCli.GetValue<String>('fax') <> '') then
      begin
        pContasReceber.Cliente.fax := lJsonCli.GetValue<String>('fax');
      end;
      if TFunctions.ColumnExists('uf', lJsonCli.ToString) and (lJsonCli.GetValue<String>('uf') <> '') then
      begin
        pContasReceber.Cliente.uf := lJsonCli.GetValue<String>('uf');
      end;
      if TFunctions.ColumnExists('cep', lJsonCli.ToString) and (lJsonCli.GetValue<String>('cep') <> '') then
      begin
        pContasReceber.Cliente.cep := lJsonCli.GetValue<String>('cep');
      end;
      if TFunctions.ColumnExists('numero', lJsonCli.ToString) and (lJsonCli.GetValue<String>('numero') <> '') then
      begin
        pContasReceber.Cliente.numero := lJsonCli.GetValue<String>('numero');
      end;
      if TFunctions.ColumnExists('complemento', lJsonCli.ToString) and (lJsonCli.GetValue<String>('complemento') <> '')
      then
      begin
        pContasReceber.Cliente.complemento := lJsonCli.GetValue<String>('complemento');
      end;
      if TFunctions.ColumnExists('data_cadastro', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('data_cadastro') <> '') then
      begin
        pContasReceber.Cliente.data_cadastro := lJsonCli.GetValue<String>('data_cadastro');
      end;
      if TFunctions.ColumnExists('matricula', lJsonCli.ToString) and (lJsonCli.GetValue<String>('matricula') <> '') then
      begin
        pContasReceber.Cliente.matricula := lJsonCli.GetValue<String>('matricula');
      end;
      if TFunctions.ColumnExists('cidade', lJsonCli.ToString) and (lJsonCli.GetValue<String>('cidade') <> '') then
      begin
        pContasReceber.Cliente.cidade := lJsonCli.GetValue<String>('cidade');
      end;

      if TFunctions.ColumnExists('endereco', lJsonCli.ToString) and (lJsonCli.GetValue<String>('endereco') <> '') then
      begin
        pContasReceber.Cliente.endereco := lJsonCli.GetValue<String>('endereco');
      end;
      if TFunctions.ColumnExists('celular', lJsonCli.ToString) and (lJsonCli.GetValue<String>('celular') <> '') then
      begin
        pContasReceber.Cliente.celular := lJsonCli.GetValue<String>('celular');
      end;
      if TFunctions.ColumnExists('endereco_ok', lJsonCli.ToString) and (lJsonCli.GetValue<String>('endereco_ok') <> '')
      then
      begin
        pContasReceber.Cliente.endereco_ok := lJsonCli.GetValue<Boolean>('endereco_ok');
      end;
      if TFunctions.ColumnExists('convenio_ok', lJsonCli.ToString) and (lJsonCli.GetValue<String>('convenio_ok') <> '')
      then
      begin
        pContasReceber.Cliente.convenio_ok := lJsonCli.GetValue<Boolean>('convenio_ok');
      end;
      if TFunctions.ColumnExists('substituicao_tributaria', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('substituicao_tributaria') <> '') then
      begin
        pContasReceber.Cliente.substituicao_tributaria := lJsonCli.GetValue<Boolean>('substituicao_tributaria');
      end;
      if TFunctions.ColumnExists('salario_ok', lJsonCli.ToString) and (lJsonCli.GetValue<String>('salario_ok') <> '')
      then
      begin
        pContasReceber.Cliente.salario_ok := lJsonCli.GetValue<Boolean>('salario_ok');
      end;
      if TFunctions.ColumnExists('pis_cofins', lJsonCli.ToString) and (lJsonCli.GetValue<String>('pis_cofins') <> '')
      then
      begin
        pContasReceber.Cliente.pis_cofins := lJsonCli.GetValue<Boolean>('pis_cofins');
      end;
      if TFunctions.ColumnExists('sped', lJsonCli.ToString) and (lJsonCli.GetValue<String>('sped') <> '') then
      begin
        pContasReceber.Cliente.sped := lJsonCli.GetValue<Boolean>('sped');
      end;
      if TFunctions.ColumnExists('usuario_alteracao', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('usuario_alteracao') <> '') then
      begin
        pContasReceber.Cliente.Usuario_Alteracao := lJsonCli.GetValue<integer>('usuario_alteracao');
      end;
      if TFunctions.ColumnExists('usuario_cadastro', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('usuario_cadastro') <> '') then
      begin
        pContasReceber.Cliente.Usuario_Cadastro := lJsonCli.GetValue<integer>('usuario_cadastro');
      end;
      if TFunctions.ColumnExists('indicador_destinatario', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('indicador_destinatario') <> '') then
      begin
        pContasReceber.Cliente.indicador_destinatario := lJsonCli.GetValue<String>('indicador_destinatario');
      end;
      if TFunctions.ColumnExists('consumidor_final', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('consumidor_final') <> '') then
      begin
        pContasReceber.Cliente.consumidor_final := lJsonCli.GetValue<String>('consumidor_final');
      end;
      if TFunctions.ColumnExists('indicador_presenca_comprador', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('indicador_presenca_comprador') <> '') then
      begin
        pContasReceber.Cliente.indicador_presenca_comprador :=
          lJsonCli.GetValue<String>('indicador_presenca_comprador');
      end;
      if TFunctions.ColumnExists('data_alteracao', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('data_alteracao') <> '') then
      begin
        pContasReceber.Cliente.data_alteracao := lJsonCli.GetValue<String>('data_alteracao');
      end;
      if TFunctions.ColumnExists('saldo_credito', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('saldo_credito') <> '') then
      begin
        pContasReceber.Cliente.saldo_credito := lJsonCli.GetValue<Double>('saldo_credito');
      end;
      if TFunctions.ColumnExists('numero_duplicatas_abertas', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('numero_duplicatas_abertas') <> '') then
      begin
        pContasReceber.Cliente.numero_duplicatas_abertas := lJsonCli.GetValue<integer>('numero_duplicatas_abertas');
      end;
      if TFunctions.ColumnExists('data_nascimento', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('data_nascimento') <> '') then
      begin
        pContasReceber.Cliente.data_nascimento := lJsonCli.GetValue<String>('data_nascimento');
      end;
      if TFunctions.ColumnExists('rg', lJsonCli.ToString) and (lJsonCli.GetValue<String>('rg') <> '') then
      begin
        pContasReceber.Cliente.rg := lJsonCli.GetValue<String>('rg');
      end;
      if TFunctions.ColumnExists('sexo', lJsonCli.ToString) and (lJsonCli.GetValue<String>('sexo') <> '') then
      begin
        pContasReceber.Cliente.sexo := lJsonCli.GetValue<String>('sexo');
      end;
      if TFunctions.ColumnExists('estado_civil', lJsonCli.ToString) and (lJsonCli.GetValue<String>('estado_civil') <> '')
      then
      begin
        pContasReceber.Cliente.estado_civil := lJsonCli.GetValue<String>('estado_civil');
      end;
      if TFunctions.ColumnExists('naturalidade', lJsonCli.ToString) and (lJsonCli.GetValue<String>('naturalidade') <> '')
      then
      begin
        pContasReceber.Cliente.naturalidade := lJsonCli.GetValue<String>('naturalidade');
      end;
      if TFunctions.ColumnExists('pai', lJsonCli.ToString) and (lJsonCli.GetValue<String>('pai') <> '') then
      begin
        pContasReceber.Cliente.pai := lJsonCli.GetValue<String>('pai');
      end;
      if TFunctions.ColumnExists('mae', lJsonCli.ToString) and (lJsonCli.GetValue<String>('mae') <> '') then
      begin
        pContasReceber.Cliente.mae := lJsonCli.GetValue<String>('mae');
      end;
      if TFunctions.ColumnExists('endereco_cobranca', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('endereco_cobranca') <> '') then
      begin
        pContasReceber.Cliente.endereco_cobranca := lJsonCli.GetValue<String>('endereco_cobranca');
      end;
      if TFunctions.ColumnExists('cidade_cobranca', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('cidade_cobranca') <> '') then
      begin
        pContasReceber.Cliente.cidade_cobranca := lJsonCli.GetValue<String>('cidade_cobranca');
      end;
      if TFunctions.ColumnExists('bairro_cobranca', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('bairro_cobranca') <> '') then
      begin
        pContasReceber.Cliente.bairro_cobranca := lJsonCli.GetValue<String>('bairro_cobranca');
      end;
      if TFunctions.ColumnExists('cep_cobranca', lJsonCli.ToString) and (lJsonCli.GetValue<String>('cep_cobranca') <> '')
      then
      begin
        pContasReceber.Cliente.cep_cobranca := lJsonCli.GetValue<String>('cep_cobranca');
      end;
      if TFunctions.ColumnExists('uf_cobranca', lJsonCli.ToString) and (lJsonCli.GetValue<String>('uf_cobranca') <> '')
      then
      begin
        pContasReceber.Cliente.uf_cobranca := lJsonCli.GetValue<String>('uf_cobranca');
      end;
      if TFunctions.ColumnExists('contato', lJsonCli.ToString) and (lJsonCli.GetValue<String>('contato') <> '') then
      begin
        pContasReceber.Cliente.contato := lJsonCli.GetValue<String>('contato');
      end;
      if TFunctions.ColumnExists('aluguel', lJsonCli.ToString) and (lJsonCli.GetValue<String>('aluguel') <> '') then
      begin
        pContasReceber.Cliente.aluguel := lJsonCli.GetValue<String>('aluguel');
      end;
      if TFunctions.ColumnExists('valor_aluguel', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('valor_aluguel') <> '') then
      begin
        pContasReceber.Cliente.valor_aluguel := lJsonCli.GetValue<Double>('valor_aluguel');
      end;
      if TFunctions.ColumnExists('tempo_aluguel', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('tempo_aluguel') <> '') then
      begin
        pContasReceber.Cliente.tempo_aluguel := lJsonCli.GetValue<String>('tempo_aluguel');
      end;
      if TFunctions.ColumnExists('empresa', lJsonCli.ToString) and (lJsonCli.GetValue<String>('empresa') <> '') then
      begin
        pContasReceber.Cliente.Empresa := lJsonCli.GetValue<String>('empresa');
      end;
      if TFunctions.ColumnExists('fone_empresa', lJsonCli.ToString) and (lJsonCli.GetValue<String>('fone_empresa') <> '')
      then
      begin
        pContasReceber.Cliente.fone_empresa := lJsonCli.GetValue<String>('fone_empresa');
      end;

      if TFunctions.ColumnExists('funcao_empresa', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('funcao_empresa') <> '') then
      begin
        pContasReceber.Cliente.funcao_empresa := lJsonCli.GetValue<String>('funcao_empresa');
      end;

      if TFunctions.ColumnExists('admissao', lJsonCli.ToString) and (lJsonCli.GetValue<String>('admissao') <> '') then
      begin
        pContasReceber.Cliente.admissao := lJsonCli.GetValue<String>('admissao');
      end;
      if TFunctions.ColumnExists('salario', lJsonCli.ToString) and (lJsonCli.GetValue<String>('salario') <> '') then
      begin
        pContasReceber.Cliente.salario := lJsonCli.GetValue<String>('salario');
      end;
      if TFunctions.ColumnExists('referencia_comercial', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('referencia_comercial') <> '') then
      begin
        pContasReceber.Cliente.referencia_comercial := lJsonCli.GetValue<String>('referencia_comercial');
      end;
      if TFunctions.ColumnExists('referencia_banco', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('referencia_banco') <> '') then
      begin
        pContasReceber.Cliente.referencia_banco := lJsonCli.GetValue<String>('referencia_banco');
      end;
      if TFunctions.ColumnExists('data_spc', lJsonCli.ToString) and (lJsonCli.GetValue<String>('data_spc') <> '') then
      begin
        pContasReceber.Cliente.data_spc := lJsonCli.GetValue<String>('data_spc');
      end;
      if TFunctions.ColumnExists('observacao_spc', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('observacao_spc') <> '') then
      begin
        pContasReceber.Cliente.observacao_spc := lJsonCli.GetValue<String>('observacao_spc');
      end;
      if TFunctions.ColumnExists('observacao_geral', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('observacao_geral') <> '') then
      begin
        pContasReceber.Cliente.observacao_geral := lJsonCli.GetValue<String>('observacao_geral');
      end;
      if TFunctions.ColumnExists('conjuge', lJsonCli.ToString) and (lJsonCli.GetValue<String>('conjuge') <> '') then
      begin
        pContasReceber.Cliente.conjuge := lJsonCli.GetValue<String>('conjuge');
      end;
      if TFunctions.ColumnExists('referencia_pessoal', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('referencia_pessoal') <> '') then
      begin
        pContasReceber.Cliente.referencia_pessoal := lJsonCli.GetValue<String>('referencia_pessoal');
      end;
      if TFunctions.ColumnExists('data_orci', lJsonCli.ToString) and (lJsonCli.GetValue<String>('data_orci') <> '') then
      begin
        pContasReceber.Cliente.data_orci := lJsonCli.GetValue<String>('data_orci');
      end;
      if TFunctions.ColumnExists('data_movimento', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('data_movimento') <> '') then
      begin
        pContasReceber.Cliente.data_movimento := lJsonCli.GetValue<String>('data_movimento');
      end;
      if TFunctions.ColumnExists('ultima_nf', lJsonCli.ToString) and (lJsonCli.GetValue<String>('ultima_nf') <> '') then
      begin
        pContasReceber.Cliente.ultima_nf := lJsonCli.GetValue<String>('ultima_nf');
      end;
      if TFunctions.ColumnExists('valor_nf', lJsonCli.ToString) and (lJsonCli.GetValue<String>('valor_nf') <> '') then
      begin
        pContasReceber.Cliente.valor_nf := lJsonCli.GetValue<Double>('valor_nf');
      end;
      if TFunctions.ColumnExists('vip', lJsonCli.ToString) and (lJsonCli.GetValue<String>('vip') <> '') then
      begin
        pContasReceber.Cliente.vip := lJsonCli.GetValue<String>('vip');
      end;
      if TFunctions.ColumnExists('validade_vip', lJsonCli.ToString) and (lJsonCli.GetValue<String>('validade_vip') <> '')
      then
      begin
        pContasReceber.Cliente.validade_vip := lJsonCli.GetValue<String>('validade_vip');
      end;
      if TFunctions.ColumnExists('tabela_convenio', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('tabela_convenio') <> '') then
      begin
        pContasReceber.Cliente.tabela_convenio := lJsonCli.GetValue<integer>('tabela_convenio');
      end;
      if TFunctions.ColumnExists('tabela_profissao', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('tabela_profissao') <> '') then
      begin
        pContasReceber.Cliente.tabela_profissao := lJsonCli.GetValue<integer>('tabela_profissao');
      end;
      if TFunctions.ColumnExists('data_cobranca', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('data_cobranca') <> '') then
      begin
        pContasReceber.Cliente.data_cobranca := lJsonCli.GetValue<String>('data_cobranca');
      end;
      if TFunctions.ColumnExists('quantida_de_cobranca', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('quantida_de_cobranca') <> '') then
      begin
        pContasReceber.Cliente.quantida_de_cobranca := lJsonCli.GetValue<integer>('quantida_de_cobranca');
      end;
      if TFunctions.ColumnExists('icms', lJsonCli.ToString) and (lJsonCli.GetValue<String>('icms') <> '') then
      begin
        pContasReceber.Cliente.icms := lJsonCli.GetValue<Double>('icms');
      end;
      if TFunctions.ColumnExists('foto_caminho', lJsonCli.ToString) and (lJsonCli.GetValue<String>('foto_caminho') <> '')
      then
      begin
        pContasReceber.Cliente.foto_caminho := lJsonCli.GetValue<String>('foto_caminho');
      end;
      if TFunctions.ColumnExists('atacado', lJsonCli.ToString) and (lJsonCli.GetValue<String>('atacado') <> '') then
      begin
        pContasReceber.Cliente.atacado := lJsonCli.GetValue<String>('atacado');
      end;
      if TFunctions.ColumnExists('limite_desconto', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('limite_desconto') <> '') then
      begin
        pContasReceber.Cliente.limite_desconto := lJsonCli.GetValue<Double>('limite_desconto');
      end;
      if TFunctions.ColumnExists('mudar_forma_pagamento', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('mudar_forma_pagamento') <> '') then
      begin
        pContasReceber.Cliente.mudar_forma_pagamento := lJsonCli.GetValue<String>('mudar_forma_pagamento');
      end;
      if TFunctions.ColumnExists('divida', lJsonCli.ToString) and (lJsonCli.GetValue<String>('divida') <> '') then
      begin
        pContasReceber.Cliente.divida := lJsonCli.GetValue<Double>('divida');
      end;
      if TFunctions.ColumnExists('saldo_total', lJsonCli.ToString) and (lJsonCli.GetValue<String>('saldo_total') <> '')
      then
      begin
        pContasReceber.Cliente.saldo_total := lJsonCli.GetValue<Double>('saldo_total');
      end;
      if TFunctions.ColumnExists('rota', lJsonCli.ToString) and (lJsonCli.GetValue<String>('rota') <> '') then
      begin
        pContasReceber.Cliente.rota := lJsonCli.GetValue<String>('rota');
      end;
      if TFunctions.ColumnExists('ordem_visita', lJsonCli.ToString) and (lJsonCli.GetValue<String>('ordem_visita') <> '')
      then
      begin
        pContasReceber.Cliente.ordem_visita := lJsonCli.GetValue<integer>('ordem_visita');
      end;
      if TFunctions.ColumnExists('observacao1', lJsonCli.ToString) and (lJsonCli.GetValue<String>('observacao1') <> '')
      then
      begin
        pContasReceber.Cliente.observacao1 := lJsonCli.GetValue<String>('observacao1');
      end;
      if TFunctions.ColumnExists('observacao2', lJsonCli.ToString) and (lJsonCli.GetValue<String>('observacao2') <> '')
      then
      begin
        pContasReceber.Cliente.observacao2 := lJsonCli.GetValue<String>('observacao2');
      end;
      if TFunctions.ColumnExists('super_limite_dias', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('super_limite_dias') <> '') then
      begin
        pContasReceber.Cliente.super_limite_dias := lJsonCli.GetValue<integer>('super_limite_dias');
      end;
      if TFunctions.ColumnExists('cartorio', lJsonCli.ToString) and (lJsonCli.GetValue<String>('cartorio') <> '') then
      begin
        pContasReceber.Cliente.cartorio := lJsonCli.GetValue<String>('cartorio');
      end;
      if TFunctions.ColumnExists('serasa', lJsonCli.ToString) and (lJsonCli.GetValue<String>('serasa') <> '') then
      begin
        pContasReceber.Cliente.serasa := lJsonCli.GetValue<String>('serasa');
      end;
      if TFunctions.ColumnExists('boleto_com_taxa', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('boleto_com_taxa') <> '') then
      begin
        pContasReceber.Cliente.boleto_com_taxa := lJsonCli.GetValue<String>('boleto_com_taxa');
      end;
      if TFunctions.ColumnExists('nome_completo_nfe', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('nome_completo_nfe') <> '') then
      begin
        pContasReceber.Cliente.nome_completo_nfe := lJsonCli.GetValue<String>('nome_completo_nfe');
      end;
      if TFunctions.ColumnExists('observacao_interna', lJsonCli.ToString) and
        (lJsonCli.GetValue<String>('observacao_interna') <> '') then
      begin
        pContasReceber.Cliente.observacao_interna := lJsonCli.GetValue<String>('observacao_interna');
      end;

      if not TFunctions.ObjectIsNull('cidade_ibge', pJson.ToString) then
      begin
        if TFunctions.ColumnExists('cidade_ibge', lJsonCli.ToString) then
        begin
          lJsonCid := lJsonCli.GetValue<TJSONObject>('cidade_ibge') as TJSONObject;

          if TFunctions.ColumnExists('codigo', lJsonCid.ToString) and (lJsonCid.GetValue<String>('codigo') <> '') then
          begin
            pContasReceber.Cliente.cidade_ibge.codigo := lJsonCid.GetValue<String>('codigo');
          end;

          if TFunctions.ColumnExists('nome', lJsonCid.ToString) and (lJsonCid.GetValue<String>('nome') <> '') then
          begin
            pContasReceber.Cliente.cidade_ibge.nome := lJsonCid.GetValue<String>('nome');
          end;

          if TFunctions.ColumnExists('uf', lJsonCid.ToString) and (lJsonCid.GetValue<String>('uf') <> '') then
          begin
            pContasReceber.Cliente.cidade_ibge.uf := lJsonCid.GetValue<String>('uf');
          end;

          if TFunctions.ColumnExists('cep', lJsonCid.ToString) and (lJsonCid.GetValue<String>('cep') <> '') then
          begin
            pContasReceber.Cliente.cidade_ibge.cep := lJsonCid.GetValue<String>('cep');
          end;

          if TFunctions.ColumnExists('aliquota', lJsonCid.ToString) and (lJsonCid.GetValue<String>('aliquota') <> '')
          then
          begin
            pContasReceber.Cliente.cidade_ibge.aliquota := lJsonCid.GetValue<Double>('aliquota');
          end;

          if TCidadeDAO.Existe(pContasReceber.Cliente.cidade_ibge) then
          begin
            TCidadeDAO.Alterar(pContasReceber.Cliente.cidade_ibge);
          end
          else
          begin
            TCidadeDAO.Incluir(pContasReceber.Cliente.cidade_ibge);
          end;
        end;
      end;

      if trim(lCPF) <> EmptyStr then
      begin
        lCodigo := TClienteDAO.ExisteCPF(lCPF);
      end
      else if trim(lCNPJ) <> EmptyStr then
      begin
        lCodigo := TClienteDAO.ExisteCNPJ(lCNPJ);
      end;

      if lCodigo > 0 then
      begin
        pContasReceber.Cliente.codigo := lCodigo;
        TClienteDAO.Alterar(pContasReceber.Cliente);
      end
      else
      begin
        pContasReceber.Cliente.codigo := TClienteDAO.GeraCodigo;
        TClienteDAO.Incluir(pContasReceber.Cliente);
      end;

      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCR := false;
    end;
  end;
end;

class function TContasReceberDAO.MontaObjetoContaContasReceber(pJson: TJSONObject;
  pContasReceber: TContasReceber): Boolean;
var
  lJsonArray: TJSONArray;
  lJsonConta: TJSONObject;
begin
  try
    if not TFunctions.ObjectIsNull('conta_de_lancamento_no_caixa', pJson.ToString) then
    begin
      lJsonConta := pJson.GetValue<TJSONObject>('conta_de_lancamento_no_caixa') as TJSONObject;

      if TFunctions.ColumnExists('codigo', lJsonConta.ToString) and (lJsonConta.GetValue<String>('codigo') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.codigo :=
          lJsonConta.GetValue<String>('codigo');
      end;

      if TFunctions.ColumnExists('nome', lJsonConta.ToString) and (lJsonConta.GetValue<String>('nome') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.nome := lJsonConta.GetValue<String>('nome');
      end;

      if TFunctions.ColumnExists('tipo', lJsonConta.ToString) and (lJsonConta.GetValue<String>('tipo') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.tipo := lJsonConta.GetValue<String>('tipo');
      end;

      if TFunctions.ColumnExists('centro_custo', lJsonConta.ToString) and
        (lJsonConta.GetValue<String>('centro_custo') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.centro_custo :=
          lJsonConta.GetValue<String>('centro_custo');
      end;

      if TFunctions.ColumnExists('duplicar', lJsonConta.ToString) and (lJsonConta.GetValue<String>('duplicar') <> '')
      then
      begin
        pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.duplicar :=
          lJsonConta.GetValue<String>('duplicar');
      end;

      if TFunctions.ColumnExists('caixa_dest', lJsonConta.ToString) and (lJsonConta.GetValue<String>('caixa_dest') <> '')
      then
      begin
        pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.caixa_dest :=
          lJsonConta.GetValue<String>('caixa_dest');
      end;

      if TFunctions.ColumnExists('historico', lJsonConta.ToString) and (lJsonConta.GetValue<String>('historico') <> '')
      then
      begin
        pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.historico :=
          lJsonConta.GetValue<String>('historico');
      end;

      if TFunctions.ColumnExists('dre', lJsonConta.ToString) and (lJsonConta.GetValue<String>('dre') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.dre := lJsonConta.GetValue<String>('dre');
      end;

      if TFunctions.ColumnExists('nivel_dre', lJsonConta.ToString) and (lJsonConta.GetValue<String>('nivel_dre') <> '')
      then
      begin
        pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.nivel_dre :=
          lJsonConta.GetValue<integer>('nivel_dre');
      end;

      if TFunctions.ColumnExists('tipo_custo', lJsonConta.ToString) and (lJsonConta.GetValue<String>('tipo_custo') <> '')
      then
      begin
        pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.tipo_custo :=
          lJsonConta.GetValue<String>('tipo_custo');
      end;

      if TFunctions.ColumnExists('combustivel', lJsonConta.ToString) and
        (lJsonConta.GetValue<String>('combustivel') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.combustivel :=
          lJsonConta.GetValue<String>('combustivel');
      end;

      if TFunctions.ColumnExists('subgrupo', lJsonConta.ToString) and (lJsonConta.GetValue<String>('subgrupo') <> '')
      then
      begin
        pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.subgrupo :=
          lJsonConta.GetValue<String>('subgrupo');
      end;

      if TFormaPagamentoDAO.Existe(pContasReceber.Forma_Pagamento_Baixar) then
      begin
        TFormaPagamentoDAO.Alterar(pContasReceber.Forma_Pagamento_Baixar);
      end
      else
      begin
        TFormaPagamentoDAO.Incluir(pContasReceber.Forma_Pagamento_Baixar);
      end;
      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCR := false;
    end;
  end;
end;

class function TContasReceberDAO.MontaObjetoContasReceber(pJson: TJSONObject; pContasReceber: TContasReceber): Boolean;
begin
  try
    if TFunctions.ColumnExists('duplicata', pJson.ToString) and (pJson.GetValue<String>('duplicata') <> '') then
    begin
      pContasReceber.empresa_duplicata := pJson.GetValue<String>('duplicata');
    end;

    if TFunctions.ColumnExists('chave_empresa', pJson.ToString) and (pJson.GetValue<String>('chave_empresa') <> '') then
    begin
      pContasReceber.chave_empresa := pJson.GetValue<String>('chave_empresa');
    end;

    if TFunctions.ColumnExists('empresa', pJson.ToString) and (pJson.GetValue<String>('empresa') <> '') then
    begin
      pContasReceber.Empresa := pJson.GetValue<String>('empresa');
    end;

    if TFunctions.ColumnExists('emissao', pJson.ToString) and (pJson.GetValue<String>('emissao') <> '') then
    begin
      pContasReceber.Emissao := pJson.GetValue<String>('emissao');
    end;

    if TFunctions.ColumnExists('valor', pJson.ToString) and (pJson.GetValue<String>('valor') <> '') then
    begin
      pContasReceber.Valor := pJson.GetValue<Double>('valor');
    end;

    if TFunctions.ColumnExists('vencimento', pJson.ToString) and (pJson.GetValue<String>('vencimento') <> '') then
    begin
      pContasReceber.Vencimento := pJson.GetValue<String>('vencimento');
    end;

    if TFunctions.ColumnExists('fluxo_caixa', pJson.ToString) and (pJson.GetValue<String>('fluxo_caixa') <> '') then
    begin
      pContasReceber.Fluxo := pJson.GetValue<String>('fluxo_caixa');
    end;

    if TFunctions.ColumnExists('situacao', pJson.ToString) and (pJson.GetValue<String>('situacao') <> '') then
    begin
      pContasReceber.Situacao := pJson.GetValue<String>('situacao');
    end;

    if TFunctions.ColumnExists('juros', pJson.ToString) and (pJson.GetValue<String>('juros') <> '') then
    begin
      pContasReceber.Juros := pJson.GetValue<Double>('juros');
    end;

    if TFunctions.ColumnExists('desconto', pJson.ToString) and (pJson.GetValue<String>('desconto') <> '') then
    begin
      pContasReceber.Desconto := pJson.GetValue<Double>('desconto');
    end;

    if TFunctions.ColumnExists('data_pagamento', pJson.ToString) and (pJson.GetValue<String>('data_pagamento') <> '')
    then
    begin
      pContasReceber.Data_Pagamento := pJson.GetValue<String>('data_pagamento');
    end;

    if TFunctions.ColumnExists('valor_pago', pJson.ToString) and (pJson.GetValue<String>('valor_pago') <> '') then
    begin
      pContasReceber.Valor_Pago := pJson.GetValue<Double>('valor_pago');
    end;

    if TFunctions.ColumnExists('total_pago', pJson.ToString) and (pJson.GetValue<String>('total_pago') <> '') then
    begin
      pContasReceber.Total_Pago := pJson.GetValue<Double>('total_pago');
    end;

    if TFunctions.ColumnExists('data_hora_cadastro', pJson.ToString) and
      (pJson.GetValue<String>('data_hora_cadastro') <> '') then
    begin
      pContasReceber.Data_Hora_Cadastro := pJson.GetValue<String>('data_hora_cadastro');
    end;

    if TFunctions.ColumnExists('data_hora_pagamento', pJson.ToString) and
      (pJson.GetValue<String>('data_hora_pagamento') <> '') then
    begin
      pContasReceber.Data_Hora_Pagamento := pJson.GetValue<String>('data_hora_pagamento');
    end;

    if TFunctions.ColumnExists('usuario_cadastro', pJson.ToString) and (pJson.GetValue<String>('usuario_cadastro') <> '')
    then
    begin
      pContasReceber.Usuario_Cadastro := pJson.GetValue<integer>('usuario_cadastro');
    end;

    if TFunctions.ColumnExists('usuario_pagamento', pJson.ToString) and
      (pJson.GetValue<String>('usuario_pagamento') <> '') then
    begin
      pContasReceber.Usuario_Pagamento := pJson.GetValue<integer>('usuario_pagamento');
    end;

    if TFunctions.ColumnExists('data_hora_alteracao', pJson.ToString) and
      (pJson.GetValue<String>('data_hora_alteracao') <> '') then
    begin
      pContasReceber.Data_Hora_Alteracao := pJson.GetValue<String>('data_hora_alteracao');
    end;

    if TFunctions.ColumnExists('usuario_alteracao', pJson.ToString) and
      (pJson.GetValue<String>('usuario_alteracao') <> '') then
    begin
      pContasReceber.Usuario_Alteracao := pJson.GetValue<integer>('usuario_alteracao');
    end;

    if TFunctions.ColumnExists('origem', pJson.ToString) and (pJson.GetValue<String>('origem') <> '') then
    begin
      pContasReceber.Origem := pJson.GetValue<String>('origem');
    end;

    if TFunctions.ColumnExists('ano', pJson.ToString) and (pJson.GetValue<String>('ano') <> '') then
    begin
      pContasReceber.Ano := pJson.GetValue<String>('ano');
    end;

    if TFunctions.ColumnExists('mes', pJson.ToString) and (pJson.GetValue<String>('mes') <> '') then
    begin
      pContasReceber.Mes := pJson.GetValue<String>('mes');
    end;

    if TFunctions.ColumnExists('obs1', pJson.ToString) and (pJson.GetValue<String>('obs1') <> '') then
    begin
      pContasReceber.Obs1 := pJson.GetValue<String>('obs1');
    end;

    if TFunctions.ColumnExists('obs2', pJson.ToString) and (pJson.GetValue<String>('obs2') <> '') then
    begin
      pContasReceber.Obs2 := pJson.GetValue<String>('obs2');
    end;

    if TFunctions.ColumnExists('comissao', pJson.ToString) and (pJson.GetValue<String>('comissao') <> '') then
    begin
      pContasReceber.Comissao := pJson.GetValue<Double>('comissao');
    end;
    if TFunctions.ColumnExists('valor_original', pJson.ToString) and (pJson.GetValue<String>('valor_original') <> '')
    then
    begin
      pContasReceber.Valor_Original := pJson.GetValue<Double>('valor_original');
    end;
    if TFunctions.ColumnExists('valor_principal', pJson.ToString) and (pJson.GetValue<String>('valor_principal') <> '')
    then
    begin
      pContasReceber.Valor_Principal := pJson.GetValue<Double>('valor_principal');
    end;
    if TFunctions.ColumnExists('total_receber', pJson.ToString) and (pJson.GetValue<String>('total_receber') <> '') then
    begin
      pContasReceber.Total_Receber := pJson.GetValue<Double>('total_receber');
    end;
    // if TFunctions.ColumnExists('data_ultimo_sincronismo', pJson.ToString) and (pJson.GetValue<String>('data_ultimo_sincronismo') <> '') then
    // begin
    // pContasReceber.data_ultimo_sincronismo := pJson.GetValue<String>('data_ultimo_sincronismo');
    // end;

    result := true;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCR := false;
    end;
  end;
end;

class function TContasReceberDAO.MontaObjetoFormaPagamentoBaixarContasReceber(pJson: TJSONObject;
  pContasReceber: TContasReceber): Boolean;
var
  lJsonArray: TJSONArray;
  lJsonFPagB: TJSONObject;
  lJsonBanco: TJSONObject;
begin
  try
    if not TFunctions.ObjectIsNull('forma_pagamento_baixar', pJson.ToString) then
    begin
      lJsonFPagB := pJson.GetValue<TJSONObject>('forma_pagamento_baixar') as TJSONObject;

      if TFunctions.ColumnExists('codigo', lJsonFPagB.ToString) and (lJsonFPagB.GetValue<String>('codigo') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.codigo := lJsonFPagB.GetValue<integer>('codigo');
      end;

      if TFunctions.ColumnExists('descricao', lJsonFPagB.ToString) and (lJsonFPagB.GetValue<String>('descricao') <> '')
      then
      begin
        pContasReceber.Forma_Pagamento_Baixar.descricao := lJsonFPagB.GetValue<String>('descricao');
      end;

      if TFunctions.ColumnExists('tipo', lJsonFPagB.ToString) and (lJsonFPagB.GetValue<String>('tipo') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.tipo := lJsonFPagB.GetValue<String>('tipo');
      end;

      if TFunctions.ColumnExists('codigo_ecf', lJsonFPagB.ToString) and (lJsonFPagB.GetValue<String>('codigo_ecf') <> '')
      then
      begin
        pContasReceber.Forma_Pagamento_Baixar.codigo_ecf := lJsonFPagB.GetValue<String>('codigo_ecf');
      end;

      if TFunctions.ColumnExists('origem', lJsonFPagB.ToString) and (lJsonFPagB.GetValue<String>('origem') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.Origem := lJsonFPagB.GetValue<String>('origem');
      end;

      if TFunctions.ColumnExists('nome_fiscal', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('nome_fiscal') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.nome_fiscal := lJsonFPagB.GetValue<String>('nome_fiscal');
      end;

      if TFunctions.ColumnExists('permite_desconto', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('permite_desconto') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.permite_desconto := lJsonFPagB.GetValue<String>('permite_desconto');
      end;

      if TFunctions.ColumnExists('tipo_da_comissao', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('tipo_da_comissao') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.tipo_da_comissao := lJsonFPagB.GetValue<String>('tipo_da_comissao');
      end;

      if TFunctions.ColumnExists('tipo_de_movimentacao', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('tipo_de_movimentacao') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.tipo_de_movimentacao :=
          lJsonFPagB.GetValue<String>('tipo_de_movimentacao');
      end;
      if TFunctions.ColumnExists('qtde_dias_para_primeiro_vencimento', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('qtde_dias_para_primeiro_vencimento') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.qtde_dias_para_primeiro_vencimento :=
          lJsonFPagB.GetValue<integer>('qtde_dias_para_primeiro_vencimento');
      end;
      if TFunctions.ColumnExists('agrupar', lJsonFPagB.ToString) and (lJsonFPagB.GetValue<String>('agrupar') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.agrupar := lJsonFPagB.GetValue<String>('agrupar');
      end;
      if TFunctions.ColumnExists('multiplas_formas_de_pagamento', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('multiplas_formas_de_pagamento') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.multiplas_formas_de_pagamento :=
          lJsonFPagB.GetValue<String>('multiplas_formas_de_pagamento');
      end;
      if TFunctions.ColumnExists('forma_de_fechamento', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('forma_de_fechamento') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.forma_de_fechamento :=
          lJsonFPagB.GetValue<integer>('forma_de_fechamento');
      end;
      if TFunctions.ColumnExists('imprimir_boleto', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('imprimir_boleto') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.imprimir_boleto := lJsonFPagB.GetValue<String>('imprimir_boleto');
      end;
      if TFunctions.ColumnExists('lancar_no_caixa', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('lancar_no_caixa') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.lancar_no_caixa := lJsonFPagB.GetValue<String>('lancar_no_caixa');
      end;
      if TFunctions.ColumnExists('banco_de_lancamento_no_caixa', lJsonFPagB.ToString) and
        (lJsonFPagB.GetValue<String>('banco_de_lancamento_no_caixa') <> '') then
      begin
        pContasReceber.Forma_Pagamento_Baixar.banco_de_lancamento_no_caixa :=
          lJsonFPagB.GetValue<integer>('banco_de_lancamento_no_caixa');
      end;

      if not TFunctions.ObjectIsNull('conta_de_lancamento_no_caixa', pJson.ToString) then
      begin

        if TFunctions.ColumnExists('conta_de_lancamento_no_caixa', lJsonFPagB.ToString) then
        begin
          lJsonBanco := pJson.GetValue<TJSONObject>('conta_de_lancamento_no_caixa') as TJSONObject;

          if TFunctions.ColumnExists('codigo', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('codigo') <> '')
          then
          begin
            pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.codigo :=
              lJsonBanco.GetValue<String>('codigo');
          end;

          if TFunctions.ColumnExists('nome', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('nome') <> '') then
          begin
            pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.nome :=
              lJsonBanco.GetValue<String>('nome');
          end;

          if TFunctions.ColumnExists('tipo', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('tipo') <> '') then
          begin
            pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.tipo :=
              lJsonBanco.GetValue<String>('tipo');
          end;

          if TFunctions.ColumnExists('centro_custo', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('centro_custo') <> '') then
          begin
            pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.centro_custo :=
              lJsonBanco.GetValue<String>('centro_custo');
          end;

          if TFunctions.ColumnExists('duplicar', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('duplicar') <> '')
          then
          begin
            pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.duplicar :=
              lJsonBanco.GetValue<String>('duplicar');
          end;

          if TFunctions.ColumnExists('caixa_dest', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('caixa_dest') <> '') then
          begin
            pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.caixa_dest :=
              lJsonBanco.GetValue<String>('caixa_dest');
          end;

          if TFunctions.ColumnExists('historico', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('historico') <> '') then
          begin
            pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.historico :=
              lJsonBanco.GetValue<String>('historico');
          end;

          if TFunctions.ColumnExists('dre', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('dre') <> '') then
          begin
            pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.dre :=
              lJsonBanco.GetValue<String>('dre');
          end;

          if TFunctions.ColumnExists('nivel_dre', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('nivel_dre') <> '') then
          begin
            pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.nivel_dre :=
              lJsonBanco.GetValue<integer>('nivel_dre');
          end;

          if TFunctions.ColumnExists('tipo_custo', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('tipo_custo') <> '') then
          begin
            pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.tipo_custo :=
              lJsonBanco.GetValue<String>('tipo_custo');
          end;

          if TFunctions.ColumnExists('combustivel', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('combustivel') <> '') then
          begin
            pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.combustivel :=
              lJsonBanco.GetValue<String>('combustivel');
          end;

          if TFunctions.ColumnExists('subgrupo', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('subgrupo') <> '')
          then
          begin
            pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa.subgrupo :=
              lJsonBanco.GetValue<String>('subgrupo');
          end;

          if TContaDAO.Existe(pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa) then
          begin
            TContaDAO.Alterar(pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa);
          end
          else
          begin
            TContaDAO.Incluir(pContasReceber.Forma_Pagamento_Baixar.conta_de_lancamento_no_caixa);
          end;
        end;
      end;

      if TFormaPagamentoDAO.Existe(pContasReceber.Forma_Pagamento_Baixar) then
      begin
        TFormaPagamentoDAO.Alterar(pContasReceber.Forma_Pagamento_Baixar);
      end
      else
      begin
        TFormaPagamentoDAO.Incluir(pContasReceber.Forma_Pagamento_Baixar);
      end;
      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCR := false;
    end;
  end;
end;

class function TContasReceberDAO.MontaObjetoFormaPagamentoContasReceber(pJson: TJSONObject;
  pContasReceber: TContasReceber): Boolean;
var
  lJsonArray: TJSONArray;
  lJsonFPag: TJSONObject;
  lJsonBanco: TJSONObject;
begin
  try
    if not TFunctions.ObjectIsNull('forma_pagamento', pJson.ToString) then
    begin
      lJsonFPag := pJson.GetValue<TJSONObject>('forma_pagamento') as TJSONObject;
      if TFunctions.ColumnExists('codigo', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('codigo') <> '') then
      begin
        pContasReceber.Forma_Pagamento.codigo := lJsonFPag.GetValue<integer>('codigo');
      end;

      if TFunctions.ColumnExists('descricao', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('descricao') <> '')
      then
      begin
        pContasReceber.Forma_Pagamento.descricao := lJsonFPag.GetValue<String>('descricao');
      end;

      if TFunctions.ColumnExists('tipo', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('tipo') <> '') then
      begin
        pContasReceber.Forma_Pagamento.tipo := lJsonFPag.GetValue<String>('tipo');
      end;

      if TFunctions.ColumnExists('codigo_ecf', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('codigo_ecf') <> '')
      then
      begin
        pContasReceber.Forma_Pagamento.codigo_ecf := lJsonFPag.GetValue<String>('codigo_ecf');
      end;

      if TFunctions.ColumnExists('origem', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('origem') <> '') then
      begin
        pContasReceber.Forma_Pagamento.Origem := lJsonFPag.GetValue<String>('origem');
      end;

      if TFunctions.ColumnExists('nome_fiscal', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('nome_fiscal') <> '')
      then
      begin
        pContasReceber.Forma_Pagamento.nome_fiscal := lJsonFPag.GetValue<String>('nome_fiscal');
      end;

      if TFunctions.ColumnExists('permite_desconto', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('permite_desconto') <> '') then
      begin
        pContasReceber.Forma_Pagamento.permite_desconto := lJsonFPag.GetValue<String>('permite_desconto');
      end;

      if TFunctions.ColumnExists('tipo_da_comissao', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('tipo_da_comissao') <> '') then
      begin
        pContasReceber.Forma_Pagamento.tipo_da_comissao := lJsonFPag.GetValue<String>('tipo_da_comissao');
      end;

      if TFunctions.ColumnExists('tipo_de_movimentacao', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('tipo_de_movimentacao') <> '') then
      begin
        pContasReceber.Forma_Pagamento.tipo_de_movimentacao := lJsonFPag.GetValue<String>('tipo_de_movimentacao');
      end;
      if TFunctions.ColumnExists('qtde_dias_para_primeiro_vencimento', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('qtde_dias_para_primeiro_vencimento') <> '') then
      begin
        pContasReceber.Forma_Pagamento.qtde_dias_para_primeiro_vencimento :=
          lJsonFPag.GetValue<integer>('qtde_dias_para_primeiro_vencimento');
      end;
      if TFunctions.ColumnExists('agrupar', lJsonFPag.ToString) and (lJsonFPag.GetValue<String>('agrupar') <> '') then
      begin
        pContasReceber.Forma_Pagamento.agrupar := lJsonFPag.GetValue<String>('agrupar');
      end;
      if TFunctions.ColumnExists('multiplas_formas_de_pagamento', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('multiplas_formas_de_pagamento') <> '') then
      begin
        pContasReceber.Forma_Pagamento.multiplas_formas_de_pagamento :=
          lJsonFPag.GetValue<String>('multiplas_formas_de_pagamento');
      end;
      if TFunctions.ColumnExists('forma_de_fechamento', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('forma_de_fechamento') <> '') then
      begin
        pContasReceber.Forma_Pagamento.forma_de_fechamento := lJsonFPag.GetValue<integer>('forma_de_fechamento');
      end;
      if TFunctions.ColumnExists('imprimir_boleto', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('imprimir_boleto') <> '') then
      begin
        pContasReceber.Forma_Pagamento.imprimir_boleto := lJsonFPag.GetValue<String>('imprimir_boleto');
      end;
      if TFunctions.ColumnExists('lancar_no_caixa', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('lancar_no_caixa') <> '') then
      begin
        pContasReceber.Forma_Pagamento.lancar_no_caixa := lJsonFPag.GetValue<String>('lancar_no_caixa');
      end;
      if TFunctions.ColumnExists('banco_de_lancamento_no_caixa', lJsonFPag.ToString) and
        (lJsonFPag.GetValue<String>('banco_de_lancamento_no_caixa') <> '') then
      begin
        pContasReceber.Forma_Pagamento.banco_de_lancamento_no_caixa :=
          lJsonFPag.GetValue<integer>('banco_de_lancamento_no_caixa');
      end;

      if not TFunctions.ObjectIsNull('conta_de_lancamento_no_caixa', pJson.ToString) then
      begin

        if TFunctions.ColumnExists('conta_de_lancamento_no_caixa', lJsonFPag.ToString) then
        begin
          lJsonBanco := pJson.GetValue<TJSONObject>('conta_de_lancamento_no_caixa') as TJSONObject;

          if TFunctions.ColumnExists('codigo', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('codigo') <> '')
          then
          begin
            pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa.codigo := lJsonBanco.GetValue<String>('codigo');
          end;

          if TFunctions.ColumnExists('nome', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('nome') <> '') then
          begin
            pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa.nome := lJsonBanco.GetValue<String>('nome');
          end;

          if TFunctions.ColumnExists('tipo', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('tipo') <> '') then
          begin
            pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa.tipo := lJsonBanco.GetValue<String>('tipo');
          end;

          if TFunctions.ColumnExists('centro_custo', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('centro_custo') <> '') then
          begin
            pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa.centro_custo :=
              lJsonBanco.GetValue<String>('centro_custo');
          end;

          if TFunctions.ColumnExists('duplicar', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('duplicar') <> '')
          then
          begin
            pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa.duplicar :=
              lJsonBanco.GetValue<String>('duplicar');
          end;

          if TFunctions.ColumnExists('caixa_dest', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('caixa_dest') <> '') then
          begin
            pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa.caixa_dest :=
              lJsonBanco.GetValue<String>('caixa_dest');
          end;

          if TFunctions.ColumnExists('historico', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('historico') <> '') then
          begin
            pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa.historico :=
              lJsonBanco.GetValue<String>('historico');
          end;

          if TFunctions.ColumnExists('dre', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('dre') <> '') then
          begin
            pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa.dre := lJsonBanco.GetValue<String>('dre');
          end;

          if TFunctions.ColumnExists('nivel_dre', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('nivel_dre') <> '') then
          begin
            pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa.nivel_dre :=
              lJsonBanco.GetValue<integer>('nivel_dre');
          end;

          if TFunctions.ColumnExists('tipo_custo', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('tipo_custo') <> '') then
          begin
            pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa.tipo_custo :=
              lJsonBanco.GetValue<String>('tipo_custo');
          end;

          if TFunctions.ColumnExists('combustivel', lJsonBanco.ToString) and
            (lJsonBanco.GetValue<String>('combustivel') <> '') then
          begin
            pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa.combustivel :=
              lJsonBanco.GetValue<String>('combustivel');
          end;

          if TFunctions.ColumnExists('subgrupo', lJsonBanco.ToString) and (lJsonBanco.GetValue<String>('subgrupo') <> '')
          then
          begin
            pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa.subgrupo :=
              lJsonBanco.GetValue<String>('subgrupo');
          end;

          if TContaDAO.Existe(pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa) then
          begin
            TContaDAO.Alterar(pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa);
          end
          else
          begin
            TContaDAO.Incluir(pContasReceber.Forma_Pagamento.conta_de_lancamento_no_caixa);
          end;
        end;
      end;

      if TFormaPagamentoDAO.Existe(pContasReceber.Forma_Pagamento) then
      begin
        TFormaPagamentoDAO.Alterar(pContasReceber.Forma_Pagamento);
      end
      else
      begin
        TFormaPagamentoDAO.Incluir(pContasReceber.Forma_Pagamento);
      end;

      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCR := false;
    end;
  end;
end;

class function TContasReceberDAO.MontaObjetoLocalCobrancaContasReceber(pJson: TJSONObject;
  pContasReceber: TContasReceber): Boolean;
var
  lJsonArray: TJSONArray;
  lJsonCob: TJSONObject;
begin
  try

    if not TFunctions.ObjectIsNull('banco_cobranca', pJson.ToString) then
    begin
      lJsonCob := pJson.GetValue<TJSONObject>('banco_cobranca') as TJSONObject;

      if TFunctions.ColumnExists('codigo', lJsonCob.ToString) and (lJsonCob.GetValue<String>('codigo') <> '') then
      begin
        pContasReceber.Conta.codigo := lJsonCob.GetValue<String>('codigo');
      end;

      if TFunctions.ColumnExists('banco', lJsonCob.ToString) and (lJsonCob.GetValue<String>('banco') <> '') then
      begin
        pContasReceber.Local_Cobranca.banco := lJsonCob.GetValue<String>('banco');
      end;

      if TFunctions.ColumnExists('arquivo', lJsonCob.ToString) and (lJsonCob.GetValue<String>('arquivo') <> '') then
      begin
        pContasReceber.Local_Cobranca.arquivo := lJsonCob.GetValue<String>('arquivo');
      end;

      if TFunctions.ColumnExists('local', lJsonCob.ToString) and (lJsonCob.GetValue<String>('local') <> '') then
      begin
        pContasReceber.Local_Cobranca.local := lJsonCob.GetValue<String>('local');
      end;

      if TFunctions.ColumnExists('numero_arquivo', lJsonCob.ToString) and
        (lJsonCob.GetValue<String>('numero_arquivo') <> '') then
      begin
        pContasReceber.Local_Cobranca.numero_arquivo := lJsonCob.GetValue<String>('numero_arquivo');
      end;

      if TFunctions.ColumnExists('digito_banco', lJsonCob.ToString) and (lJsonCob.GetValue<String>('digito_banco') <> '')
      then
      begin
        pContasReceber.Local_Cobranca.digito_banco := lJsonCob.GetValue<String>('digito_banco');
      end;

      if TFunctions.ColumnExists('data_hora_arquivo_sn', lJsonCob.ToString) and
        (lJsonCob.GetValue<String>('data_hora_arquivo_sn') <> '') then
      begin
        pContasReceber.Local_Cobranca.data_hora_arquivo_sn := lJsonCob.GetValue<String>('data_hora_arquivo_sn');
      end;

      if TBancoDAO.Existe(pContasReceber.Local_Cobranca) then
      begin
        TBancoDAO.Alterar(pContasReceber.Local_Cobranca);
      end
      else
      begin
        TBancoDAO.Incluir(pContasReceber.Local_Cobranca);
      end;
      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCR := false;
    end;
  end;
end;

class function TContasReceberDAO.MontaObjetoLocalPagamentoContasReceber(pJson: TJSONObject;
  pContasReceber: TContasReceber): Boolean;
var
  lJsonArray: TJSONArray;
  lJsonPag: TJSONObject;
begin
  try
    if not TFunctions.ObjectIsNull('banco_pagamento', pJson.ToString) then
    begin
      lJsonPag := pJson.GetValue<TJSONObject>('banco_pagamento') as TJSONObject;

      if TFunctions.ColumnExists('codigo', lJsonPag.ToString) and (lJsonPag.GetValue<String>('codigo') <> '') then
      begin
        pContasReceber.Local_Pagamento.codigo := lJsonPag.GetValue<String>('codigo');
      end;
      if TFunctions.ColumnExists('banco', lJsonPag.ToString) and (lJsonPag.GetValue<String>('banco') <> '') then
      begin
        pContasReceber.Local_Pagamento.banco := lJsonPag.GetValue<String>('banco');
      end;
      if TFunctions.ColumnExists('arquivo', lJsonPag.ToString) and (lJsonPag.GetValue<String>('arquivo') <> '') then
      begin
        pContasReceber.Local_Pagamento.arquivo := lJsonPag.GetValue<String>('arquivo');
      end;
      if TFunctions.ColumnExists('local', lJsonPag.ToString) and (lJsonPag.GetValue<String>('local') <> '') then
      begin
        pContasReceber.Local_Pagamento.local := lJsonPag.GetValue<String>('local');
      end;
      if TFunctions.ColumnExists('numero_arquivo', lJsonPag.ToString) and
        (lJsonPag.GetValue<String>('numero_arquivo') <> '') then
      begin
        pContasReceber.Local_Pagamento.numero_arquivo := lJsonPag.GetValue<String>('numero_arquivo');
      end;
      if TFunctions.ColumnExists('digito_banco', lJsonPag.ToString) and (lJsonPag.GetValue<String>('digito_banco') <> '')
      then
      begin
        pContasReceber.Local_Pagamento.digito_banco := lJsonPag.GetValue<String>('digito_banco');
      end;
      if TFunctions.ColumnExists('data_hora_arquivo_sn', lJsonPag.ToString) and
        (lJsonPag.GetValue<String>('data_hora_arquivo_sn') <> '') then
      begin
        pContasReceber.Local_Pagamento.data_hora_arquivo_sn := lJsonPag.GetValue<String>('data_hora_arquivo_sn');
      end;

      if TBancoDAO.Existe(pContasReceber.Local_Pagamento) then
      begin
        TBancoDAO.Alterar(pContasReceber.Local_Pagamento);
      end
      else
      begin
        TBancoDAO.Incluir(pContasReceber.Local_Pagamento);
      end;
      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCR := false;
    end;
  end;
end;

class function TContasReceberDAO.MontaObjetoVendedorContasReceber(pJson: TJSONObject;
  pContasReceber: TContasReceber): Boolean;
var
  lJsonArray: TJSONArray;
  lJsonVend: TJSONObject;
  lIndetificador: string;
  lCodigo: integer;
  lVariant: Variant;
begin
  try

    if not TFunctions.ObjectIsNull('vendedor', pJson.ToString) then
    begin

      lJsonVend := pJson.GetValue<TJSONObject>('vendedor') as TJSONObject;

      if TFunctions.ColumnExists('cpf_cnpj', lJsonVend.ToString) and (lJsonVend.GetValue<String>('cpf_cnpj') <> '') then
      begin

        if TFunctions.ColumnExists('nome', lJsonVend.ToString) and (lJsonVend.GetValue<String>('nome') <> '') then
        begin
          pContasReceber.Vendedor.nome := lJsonVend.GetValue<String>('nome');
        end;

        if TFunctions.ColumnExists('comissao_vista', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('comissao_vista') <> '') then
        begin
          pContasReceber.Vendedor.comissao_vista := lJsonVend.GetValue<Double>('comissao_vista');
        end;

        if TFunctions.ColumnExists('comissao_prazo', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('comissao_prazo') <> '') then
        begin
          pContasReceber.Vendedor.comissao_prazo := lJsonVend.GetValue<Double>('comissao_prazo');
        end;

        if TFunctions.ColumnExists('modifica_preco_venda', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('modifica_preco_venda') <> '') then
        begin
          pContasReceber.Vendedor.modifica_preco_venda := lJsonVend.GetValue<Boolean>('modifica_preco_venda');
        end;

        if TFunctions.ColumnExists('limite_desconto', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('limite_desconto') <> '') then
        begin
          pContasReceber.Vendedor.limite_desconto := lJsonVend.GetValue<Double>('limite_desconto');
        end;

        if TFunctions.ColumnExists('meta_venda', lJsonVend.ToString) and (lJsonVend.GetValue<String>('meta_venda') <> '')
        then
        begin
          pContasReceber.Vendedor.meta_venda := lJsonVend.GetValue<Double>('meta_venda');
        end;
        if TFunctions.ColumnExists('participar_agenda', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('participar_agenda') <> '') then
        begin
          pContasReceber.Vendedor.participar_agenda := lJsonVend.GetValue<Boolean>('participar_agenda');
        end;

        if TFunctions.ColumnExists('tipo_preco_venda', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('tipo_preco_venda') <> '') then
        begin
          pContasReceber.Vendedor.tipo_preco_venda := lJsonVend.GetValue<String>('tipo_preco_venda');
        end;

        if TFunctions.ColumnExists('endereco', lJsonVend.ToString) and (lJsonVend.GetValue<String>('endereco') <> '')
        then
        begin
          pContasReceber.Vendedor.endereco := lJsonVend.GetValue<String>('endereco');
        end;

        if TFunctions.ColumnExists('cidade', lJsonVend.ToString) and (lJsonVend.GetValue<String>('cidade') <> '') then
        begin
          pContasReceber.Vendedor.cidade := lJsonVend.GetValue<String>('cidade');
        end;

        if TFunctions.ColumnExists('cep', lJsonVend.ToString) and (lJsonVend.GetValue<String>('cep') <> '') then
        begin
          pContasReceber.Vendedor.cep := lJsonVend.GetValue<String>('cep');
        end;
        if TFunctions.ColumnExists('fone', lJsonVend.ToString) and (lJsonVend.GetValue<String>('fone') <> '') then
        begin
          pContasReceber.Vendedor.fone := lJsonVend.GetValue<String>('fone');
        end;
        if TFunctions.ColumnExists('email', lJsonVend.ToString) and (lJsonVend.GetValue<String>('email') <> '') then
        begin
          pContasReceber.Vendedor.email := lJsonVend.GetValue<String>('email');
        end;
        if TFunctions.ColumnExists('observacoes', lJsonVend.ToString) and
          (lJsonVend.GetValue<String>('observacoes') <> '') then
        begin
          pContasReceber.Vendedor.observacoes := lJsonVend.GetValue<String>('observacoes');
        end;
        if TFunctions.ColumnExists('senha', lJsonVend.ToString) and (lJsonVend.GetValue<String>('senha') <> '') then
        begin
          pContasReceber.Vendedor.senha := lJsonVend.GetValue<String>('senha');
        end;

        lIndetificador := lJsonVend.GetValue<String>('cpf_cnpj');
        pContasReceber.Vendedor.cpf_cnpj := lIndetificador;
        lCodigo := TVendedorDAO.ExisteCPFouCNPJ(lIndetificador);

        if lCodigo > 0 then
        begin
          pContasReceber.Vendedor.codigo := lCodigo;
          TVendedorDAO.Alterar(pContasReceber.Vendedor);
        end
        else
        begin
          pContasReceber.Vendedor.codigo := TVendedorDAO.GeraProximoCodigo;
          TVendedorDAO.Incluir(pContasReceber.Vendedor);
        end;
      end;
      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      tsettings.settings.PermiteAlterarDataSincronismoCR := false;
    end;
  end;
end;

class function TContasReceberDAO.Post(pDuplicata: String; lNovaData: TDateTime; pContasReceber: TContasReceber)
  : Boolean;
var
  lHttp: TConnectionRest;

  function Tratamento: Boolean;
  begin
    result := true;

    if (copy(IntToStr(lHttp.RestResponse.StatusCode), 1, 1)) = '2' then
    begin
      TFunctions.AtualizaContaReceberComoEnviado(pDuplicata, lNovaData);
      TFunctions.AtualizaDuplicataEmpresaCR(pDuplicata);

      // Mensagem ok
      TMessages.Messages.MessageOk := TMessages.Messages.MessageOk +
        ('POST - Contas Receber: ' + pDuplicata + ' - Enviado - ' + DateTimeToStr(TFunctions.DateServer) + sLineBreak);
    end
    else if (lHttp.RestResponse.StatusCode = 409) then
    begin
      TFunctions.AtualizaContaReceberComoEnviado(pDuplicata, lNovaData);

      // Mensagem troca status
      TMessages.Messages.MessageOk := TMessages.Messages.MessageOk +
        ('POST - Contas Receber: ' + pDuplicata + ' - Ja existia na API, o status foi trocado para enviado - ' +
        DateTimeToStr(TFunctions.DateServer) + sLineBreak);
    end
    else
    begin
      // Mensagem erro
      TMessages.Messages.MessageErro := TMessages.Messages.MessageErro + 'POST - Contas Receber: ' + pDuplicata + ' - '
        + pContasReceber.Emissao + ' - Não Enviado - Motivo/Erro: ' + IntToStr(lHttp.RestResponse.StatusCode) + ' - ' +
        lHttp.RestResponse.Content + ' - ' + DateTimeToStr(TFunctions.DateServer);

      result := false;
    end;
  end;

begin
  lHttp := TConnectionRest.Create;
  try
    lHttp.ConfigureRest(rmPOST, tPostCR, pContasReceber.tojson);
    result := Tratamento;
  finally
    lHttp.Free;
  end;
end;

class function TContasReceberDAO.Put(pDuplicata: String; lNovaData: TDateTime; pContasReceber: TContasReceber): Boolean;
var
  lHttp: TConnectionRest;

  function Tratamento: Boolean;
  begin
    result := false;
    if (lHttp.RestResponse.StatusCode = 404) then
    begin
      TFunctions.AtualizaCPParaReenvio(pDuplicata);
    end;

    if (copy(IntToStr(lHttp.RestResponse.StatusCode), 1, 1)) = '2' then
    begin
      TFunctions.AtualizaComoEnviadaTabelaAuxCR(pDuplicata, lNovaData);
      TMessages.Messages.MessageOk := TMessages.Messages.MessageOk +
        ('PUT - Contas Receber: ' + pDuplicata + ' - Alterado - ' + DateTimeToStr(TFunctions.DateServer) + sLineBreak);
      result := true;
    end
    else
    begin
      TMessages.Messages.MessageErro := TMessages.Messages.MessageErro +
        ('PUT - Contas Receber: ' + pDuplicata + ' - Não Alterado - Motivo/Erro: ' +
        IntToStr(lHttp.RestResponse.StatusCode) + ' - ' + lHttp.RestResponse.Content + ' - ' +
        DateTimeToStr(TFunctions.DateServer)) + sLineBreak;
    end;

  end;

begin
  lHttp := TConnectionRest.Create;
  try
    lHttp.ConfigureRest(rmPUT, tPutCR, pContasReceber.tojson);
    result := Tratamento;
  finally
    lHttp.Free;
  end;

end;

class function TContasReceberDAO.RetornaDuplicataPelaDuplicataEmpresa(pDuplicataEmp: String): string;
var
  lQuery: Tquery;
begin
  lQuery := Tquery.Create(nil);
  try
    result := EmptyStr;
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT * FROM CREC WHERE EMP_DUP = :EMP_DUP');
    lQuery.ParamByName('EMP_DUP').AsString := pDuplicataEmp;
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      result := lQuery.FieldByName('DUP').AsString;
    end;

  finally
    lQuery.Free;
  end;

end;

end.
