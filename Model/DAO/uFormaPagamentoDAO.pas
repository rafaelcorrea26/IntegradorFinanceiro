unit uFormaPagamentoDAO;

interface

uses
  System.Classes,
  uQuery,
  System.SysUtils,
  uFunctions,
  uFormaPagamento,
  REST.JSON.Types, uInterfacesEntity, uContaDAO;

type
  TFormaPagamentoDAO = class(TInterfacedObject, iFormaPagamentoDAO)
  private

  public
    class function Existe(pFormaPagamento: TformaPagamento): Boolean;
    class function Limpar(pFormaPagamento: TformaPagamento): Boolean;
    class function Carrega(pFormaPagamento: TformaPagamento): Boolean;
    class function Incluir(pFormaPagamento: TformaPagamento; pCommit : Boolean = true): Boolean;
    class function Alterar(pFormaPagamento: TformaPagamento; pCommit : Boolean = true): Boolean;
    class function Excluir(pCodigo: Integer; pCommit : Boolean = true): Boolean;
    class function GetFormaPagamentoMultiplasFormasCompra: Integer;

  end;

implementation

{ TFormaDePagamento }

class function TFormaPagamentoDAO.Excluir(pCodigo: Integer; pCommit : Boolean = true): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM FRPGTO WHERE CODIGO = :CODIGO ');
    lQuery.ParamByName('CODIGO').AsInteger := pCodigo;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;

  finally
    lQuery.Free;
  end;

end;

class function TFormaPagamentoDAO.Existe(pFormaPagamento: TformaPagamento): Boolean;
var
  lQuery: TQuery;
begin
  Result := false;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM FRPGTO WHERE CODIGO = :CODIGO');
    lQuery.ParamByName('CODIGO').AsInteger := pFormaPagamento.Codigo;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := True;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TFormaPagamentoDAO.GetFormaPagamentoMultiplasFormasCompra: Integer;
var
  lQuery: TQuery;
begin
  Result := 0;

  lQuery.Close;
  lQuery.SQL.Clear;
  lQuery.SQL.Add('SELECT FIRST 1 CODIGO FROM FRPGTO             ');
  lQuery.SQL.Add('WHERE MOV_ES = ''E'' AND MULTI_FP = ''S''   ');
  lQuery.Open;

  if (lQuery.RecordCount > 0) then
  begin
    Result := lQuery.fieldByName('CODIGO').AsInteger;
  end;

end;

class function TFormaPagamentoDAO.Alterar(pFormaPagamento: TformaPagamento; pCommit : Boolean = true): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('UPDATE FRPGTO SET                                ');
    lQuery.SQL.Add('    DESC               = :DESC               ');
    lQuery.SQL.Add('  , TIPO               = :TIPO               ');
    lQuery.SQL.Add('  , CODECF             = :CODECF             ');
    lQuery.SQL.Add('  , ORIG               = :ORIG               ');
    lQuery.SQL.Add('  , NOMEFISCAL         = :NOMEFISCAL         ');
    lQuery.SQL.Add('  , DESCONTO           = :DESCONTO           ');
    lQuery.SQL.Add('  , CARNE_ECF         = :CARNE_ECF         ');
    lQuery.SQL.Add('  , TIPO_COMI         = :TIPO_COMI         ');
    lQuery.SQL.Add('  , MOV_ES            = :MOV_ES            ');
    lQuery.SQL.Add('  , DIAS              = :DIAS              ');
    lQuery.SQL.Add('  , AGRUPAR           = :AGRUPAR           ');
    lQuery.SQL.Add('  , MULTI_FP          = :MULTI_FP          ');
    lQuery.SQL.Add('  , FRFECHA            = :FRFECHA            ');
    lQuery.SQL.Add('  , BOLETO            = :BOLETO            ');
    lQuery.SQL.Add('  , LCTO_CAIXA        = :LCTO_CAIXA        ');
    lQuery.SQL.Add('  , BCO_CAIXA         = :BCO_CAIXA         ');
    lQuery.SQL.Add('  , CTA_CAIXA         = :CTA_CAIXA         ');
    lQuery.SQL.Add('  , SPED_SN           = :SPED_SN           ');
    lQuery.SQL.Add('  , IMPRIME_DUAS_VIAS = :IMPRIME_DUAS_VIAS ');
    lQuery.SQL.Add('  , BRANRISUL_SN      = :BRANRISUL_SN      ');
    lQuery.SQL.Add('  , MAXIMO_PARCELAS   = :MAXIMO_PARCELAS   ');
    lQuery.SQL.Add('  , PRAZO_MEDIO       = :PRAZO_MEDIO       ');
    lQuery.SQL.Add('  , CONFISSAO_DIVIDA  = :CONFISSAO_DIVIDA  ');
    lQuery.SQL.Add('  , FINANCEIRA        = :FINANCEIRA        ');
    lQuery.SQL.Add('  , GERAR_CR          = :GERAR_CR          ');
    lQuery.SQL.Add('  , CODIGO_SCANNTECH  = :CODIGO_SCANNTECH  ');
    lQuery.SQL.Add('WHERE CODIGO           = :CODIGO             ');

    lQuery.ParamByName('DESC').AsString := copy(pFormaPagamento.Descricao, 1, 25);
    lQuery.ParamByName('TIPO').AsString := copy(pFormaPagamento.Tipo, 1, 1);
    lQuery.ParamByName('CODECF').AsString := copy(pFormaPagamento.codigo_ecf, 1, 2);
    lQuery.ParamByName('ORIG').AsString := copy(pFormaPagamento.Origem, 1, 2);
    lQuery.ParamByName('NOMEFISCAL').AsString := copy(pFormaPagamento.nome_fiscal, 1, 16);
    lQuery.ParamByName('DESCONTO').AsString := copy(pFormaPagamento.permite_desconto, 1, 1);
    lQuery.ParamByName('CARNE_ECF').AsString := copy(pFormaPagamento.permite_carne_no_final_da_ecf, 1, 1);
    lQuery.ParamByName('TIPO_COMI').AsString := copy(pFormaPagamento.tipo_da_comissao, 1, 1);
    lQuery.ParamByName('MOV_ES').AsString := copy(pFormaPagamento.tipo_de_movimentacao, 1, 1);
    lQuery.ParamByName('DIAS').AsInteger := pFormaPagamento.qtde_dias_para_primeiro_vencimento;
    lQuery.ParamByName('AGRUPAR').AsString := copy(pFormaPagamento.Agrupar, 1, 6);
    lQuery.ParamByName('MULTI_FP').AsString := copy(pFormaPagamento.multiplas_formas_de_pagamento, 1, 1);
    lQuery.ParamByName('FRFECHA').AsInteger := pFormaPagamento.forma_de_fechamento;
    lQuery.ParamByName('BOLETO').AsString := copy(pFormaPagamento.imprimir_boleto, 1, 1);
    lQuery.ParamByName('LCTO_CAIXA').AsString := copy(pFormaPagamento.lancar_no_caixa, 1, 1);
    lQuery.ParamByName('BCO_CAIXA').AsInteger := pFormaPagamento.banco_de_lancamento_no_caixa;
    lQuery.ParamByName('CTA_CAIXA').AsString := copy(pFormaPagamento.conta_de_lancamento_no_caixa.Codigo, 1, 3);
    lQuery.ParamByName('SPED_SN').AsString := copy(pFormaPagamento.permite_sped_fiscal, 1, 1);
    lQuery.ParamByName('BRANRISUL_SN').AsString := Tfunctions.GetSN(pFormaPagamento.valida_se_e_banrisul);
    lQuery.ParamByName('MAXIMO_PARCELAS').AsInteger := pFormaPagamento.maximo_parcelas;
    lQuery.ParamByName('PRAZO_MEDIO').AsInteger := pFormaPagamento.prazo_medio;
    lQuery.ParamByName('CONFISSAO_DIVIDA').AsString := Tfunctions.GetSN(pFormaPagamento.confissao_divida);
    lQuery.ParamByName('FINANCEIRA').AsInteger := pFormaPagamento.administradora_tef;
    lQuery.ParamByName('GERAR_CR').AsString := Tfunctions.GetSN(pFormaPagamento.gerar_contas_receber);
    lQuery.ParamByName('CODIGO_SCANNTECH').AsInteger := pFormaPagamento.codigo_scanntech;
    lQuery.ParamByName('CODIGO').AsInteger := pFormaPagamento.Codigo;
    lQuery.ExecSQL;

    lQuery.Connection.Commit;

  finally
    lQuery.Free;
  end;

end;

class function TFormaPagamentoDAO.Incluir(pFormaPagamento: TformaPagamento; pCommit : Boolean = true): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('INSERT INTO FRPGTO (    ');
    lQuery.SQL.Add('    CODIGO              ');
    lQuery.SQL.Add('  , DESC                ');
    lQuery.SQL.Add('  , TIPO                ');
    lQuery.SQL.Add('  , CODECF              ');
    lQuery.SQL.Add('  , ORIG                ');
    lQuery.SQL.Add('  , NOMEFISCAL          ');
    lQuery.SQL.Add('  , DESCONTO            ');
    lQuery.SQL.Add('  , CARNE_ECF          ');
    lQuery.SQL.Add('  , TIPO_COMI          ');
    lQuery.SQL.Add('  , MOV_ES             ');
    lQuery.SQL.Add('  , DIAS               ');
    lQuery.SQL.Add('  , AGRUPAR            ');
    lQuery.SQL.Add('  , MULTI_FP           ');
    lQuery.SQL.Add('  , FRFECHA             ');
    lQuery.SQL.Add('  , BOLETO             ');
    lQuery.SQL.Add('  , LCTO_CAIXA         ');
    lQuery.SQL.Add('  , BCO_CAIXA          ');
    lQuery.SQL.Add('  , CTA_CAIXA          ');
    lQuery.SQL.Add('  , SPED_SN            ');
    lQuery.SQL.Add('  , IMPRIME_DUAS_VIAS  ');
    lQuery.SQL.Add('  , BRANRISUL_SN       ');
    lQuery.SQL.Add('  , MAXIMO_PARCELAS    ');
    lQuery.SQL.Add('  , PRAZO_MEDIO        ');
    lQuery.SQL.Add('  , CONFISSAO_DIVIDA   ');
    lQuery.SQL.Add('  , FINANCEIRA         ');
    lQuery.SQL.Add('  , GERAR_CR           ');
    lQuery.SQL.Add('  , CODIGO_SCANNTECH   ');
    lQuery.SQL.Add('  ) VALUES (                ');
    lQuery.SQL.Add('    :CODIGO             ');
    lQuery.SQL.Add('  , :DESC               ');
    lQuery.SQL.Add('  , :TIPO               ');
    lQuery.SQL.Add('  , :CODECF             ');
    lQuery.SQL.Add('  , :ORIG               ');
    lQuery.SQL.Add('  , :NOMEFISCAL         ');
    lQuery.SQL.Add('  , :DESCONTO           ');
    lQuery.SQL.Add('  , :CARNE_ECF         ');
    lQuery.SQL.Add('  , :TIPO_COMI         ');
    lQuery.SQL.Add('  , :MOV_ES            ');
    lQuery.SQL.Add('  , :DIAS              ');
    lQuery.SQL.Add('  , :AGRUPAR           ');
    lQuery.SQL.Add('  , :MULTI_FP          ');
    lQuery.SQL.Add('  , :FRFECHA            ');
    lQuery.SQL.Add('  , :BOLETO            ');
    lQuery.SQL.Add('  , :LCTO_CAIXA        ');
    lQuery.SQL.Add('  , :BCO_CAIXA         ');
    lQuery.SQL.Add('  , :CTA_CAIXA         ');
    lQuery.SQL.Add('  , :SPED_SN           ');
    lQuery.SQL.Add('  , :IMPRIME_DUAS_VIAS ');
    lQuery.SQL.Add('  , :BRANRISUL_SN      ');
    lQuery.SQL.Add('  , :MAXIMO_PARCELAS   ');
    lQuery.SQL.Add('  , :PRAZO_MEDIO       ');
    lQuery.SQL.Add('  , :CONFISSAO_DIVIDA  ');
    lQuery.SQL.Add('  , :FINANCEIRA        ');
    lQuery.SQL.Add('  , :GERAR_CR          ');
    lQuery.SQL.Add('  , :CODIGO_SCANNTECH  ');
    lQuery.SQL.Add('  )                         ');
    lQuery.ParamByName('DESC').AsString := copy(pFormaPagamento.Descricao, 1, 25);
    lQuery.ParamByName('TIPO').AsString := copy(pFormaPagamento.Tipo, 1, 1);
    lQuery.ParamByName('CODECF').AsString := copy(pFormaPagamento.codigo_ecf, 1, 2);
    lQuery.ParamByName('ORIG').AsString := copy(pFormaPagamento.Origem, 1, 2);
    lQuery.ParamByName('NOMEFISCAL').AsString := copy(pFormaPagamento.nome_fiscal, 1, 16);
    lQuery.ParamByName('DESCONTO').AsString := copy(pFormaPagamento.permite_desconto, 1, 1);
    lQuery.ParamByName('CARNE_ECF').AsString := copy(pFormaPagamento.permite_carne_no_final_da_ecf, 1, 1);
    lQuery.ParamByName('TIPO_COMI').AsString := copy(pFormaPagamento.tipo_da_comissao, 1, 1);
    lQuery.ParamByName('MOV_ES').AsString := copy(pFormaPagamento.tipo_de_movimentacao, 1, 1);
    lQuery.ParamByName('DIAS').AsInteger := pFormaPagamento.qtde_dias_para_primeiro_vencimento;
    lQuery.ParamByName('AGRUPAR').AsString := copy(pFormaPagamento.Agrupar, 1, 6);
    lQuery.ParamByName('MULTI_FP').AsString := copy(pFormaPagamento.multiplas_formas_de_pagamento, 1, 1);
    lQuery.ParamByName('FRFECHA').AsInteger := pFormaPagamento.forma_de_fechamento;
    lQuery.ParamByName('BOLETO').AsString := copy(pFormaPagamento.imprimir_boleto, 1, 1);
    lQuery.ParamByName('LCTO_CAIXA').AsString := copy(pFormaPagamento.lancar_no_caixa, 1, 1);
    lQuery.ParamByName('BCO_CAIXA').AsInteger := pFormaPagamento.banco_de_lancamento_no_caixa;
    lQuery.ParamByName('CTA_CAIXA').AsString := copy(pFormaPagamento.conta_de_lancamento_no_caixa.Codigo, 1, 3);
    lQuery.ParamByName('SPED_SN').AsString := copy(pFormaPagamento.permite_sped_fiscal, 1, 1);
    lQuery.ParamByName('BRANRISUL_SN').AsString := Tfunctions.GetSN(pFormaPagamento.valida_se_e_banrisul);
    lQuery.ParamByName('MAXIMO_PARCELAS').AsInteger := pFormaPagamento.maximo_parcelas;
    lQuery.ParamByName('PRAZO_MEDIO').AsInteger := pFormaPagamento.prazo_medio;
    lQuery.ParamByName('CONFISSAO_DIVIDA').AsString := Tfunctions.GetSN(pFormaPagamento.confissao_divida);
    lQuery.ParamByName('FINANCEIRA').AsInteger := pFormaPagamento.administradora_tef;
    lQuery.ParamByName('GERAR_CR').AsString := Tfunctions.GetSN(pFormaPagamento.gerar_contas_receber);
    lQuery.ParamByName('CODIGO_SCANNTECH').AsInteger := pFormaPagamento.codigo_scanntech;
    lQuery.ParamByName('CODIGO').AsInteger := pFormaPagamento.Codigo;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;

  finally
    lQuery.Free;
  end;

end;

class function TFormaPagamentoDAO.Limpar(pFormaPagamento: TformaPagamento): Boolean;
begin
  pFormaPagamento.Codigo := 0;
  pFormaPagamento.Descricao := '';
  pFormaPagamento.Tipo := '';
  pFormaPagamento.codigo_ecf := '';
  pFormaPagamento.Origem := '';
  pFormaPagamento.nome_fiscal := '';
  pFormaPagamento.permite_desconto := '';
  pFormaPagamento.permite_carne_no_final_da_ecf := '';
  pFormaPagamento.tipo_da_comissao := '';
  pFormaPagamento.tipo_de_movimentacao := '';
  pFormaPagamento.qtde_dias_para_primeiro_vencimento := 0;
  pFormaPagamento.Agrupar := '';
  pFormaPagamento.multiplas_formas_de_pagamento := '';
  pFormaPagamento.forma_de_fechamento := 0;
  pFormaPagamento.imprimir_boleto := '';
  pFormaPagamento.lancar_no_caixa := '';
  pFormaPagamento.banco_de_lancamento_no_caixa := 0;
  pFormaPagamento.permite_sped_fiscal := '';
  pFormaPagamento.valida_se_e_banrisul := false;
end;

class function TFormaPagamentoDAO.Carrega(pFormaPagamento: TformaPagamento): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' select * from FRPGTO        ');
    lQuery.SQL.Add(' where CODIGO = :CODIGO  ');
    lQuery.ParamByName('CODIGO').AsInteger := pFormaPagamento.Codigo;
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      pFormaPagamento.Codigo := lQuery.fieldByName('CODIGO').AsInteger;
      pFormaPagamento.Descricao := lQuery.fieldByName('DESC').AsString;
      pFormaPagamento.Tipo := lQuery.fieldByName('TIPO').AsString;
      pFormaPagamento.codigo_ecf := lQuery.fieldByName('CODECF').AsString;
      pFormaPagamento.Origem := lQuery.fieldByName('ORIG').AsString;

//      if (pFormaPagamento.Origem = 'CH') then
//      begin
//        pFormaPagamento.IndPag := ipVista;
//        pFormaPagamento.TPag := fpCheque;
//      end;
//
//      if (pFormaPagamento.Origem = 'CD') then
//      begin
//        pFormaPagamento.IndPag := ipVista;
//        pFormaPagamento.TPag := fpCartaoDebito;
//      end;
//
//      if (pFormaPagamento.Origem = 'CC') then
//      begin
//        pFormaPagamento.IndPag := ipPrazo;
//        pFormaPagamento.TPag := fpCartaoCredito;
//      end;
//
//      if (pFormaPagamento.Origem = 'NF') and (pFormaPagamento.Tipo = 'A') then
//      begin
//        pFormaPagamento.IndPag := ipVista;
//        pFormaPagamento.TPag := fpDinheiro;
//      end;
//
//      if (pFormaPagamento.Origem = 'NF') and (pFormaPagamento.Tipo = 'P') then
//      begin
//        pFormaPagamento.IndPag := ipPrazo;
//        pFormaPagamento.TPag := fpCreditoLoja;
//      end;
//
//      if (pFormaPagamento.Origem = 'DV') and (pFormaPagamento.Tipo = 'A') then
//      begin
//        pFormaPagamento.IndPag := ipVista;
//        pFormaPagamento.TPag := fpDinheiro;
//      end;
//
//      if (pFormaPagamento.Origem = 'FT') and (pFormaPagamento.Tipo = 'P') then
//      begin
//        pFormaPagamento.IndPag := ipPrazo;
//        pFormaPagamento.TPag := fpCreditoLoja;
//      end;

      pFormaPagamento.nome_fiscal := lQuery.fieldByName('NOMEFISCAL').AsString;
      pFormaPagamento.permite_desconto := lQuery.fieldByName('DESCONTO').AsString;
      pFormaPagamento.permite_carne_no_final_da_ecf := lQuery.fieldByName('CARNE_ECF').AsString;
      pFormaPagamento.tipo_da_comissao := lQuery.fieldByName('TIPO_COMI').AsString;
      pFormaPagamento.tipo_de_movimentacao := lQuery.fieldByName('MOV_ES').AsString;
      pFormaPagamento.qtde_dias_para_primeiro_vencimento := lQuery.fieldByName('DIAS').AsInteger;
      pFormaPagamento.Agrupar := lQuery.fieldByName('AGRUPAR').AsString;
      pFormaPagamento.multiplas_formas_de_pagamento := lQuery.fieldByName('MULTI_FP').AsString;
      pFormaPagamento.forma_de_fechamento := lQuery.fieldByName('FRFECHA').AsInteger;
      pFormaPagamento.imprimir_boleto := lQuery.fieldByName('BOLETO').AsString;
      pFormaPagamento.lancar_no_caixa := lQuery.fieldByName('LCTO_CAIXA').AsString;
      pFormaPagamento.banco_de_lancamento_no_caixa := lQuery.fieldByName('BCO_CAIXA').AsInteger;
      pFormaPagamento.permite_sped_fiscal := lQuery.fieldByName('SPED_SN').AsString;
      pFormaPagamento.valida_se_e_banrisul := (lQuery.fieldByName('BRANRISUL_SN').AsString = 'S');

      pFormaPagamento.conta_de_lancamento_no_caixa.Codigo := lQuery.fieldByName('CTA_CAIXA').AsString;
      TContaDAO.Carrega(pFormaPagamento.conta_de_lancamento_no_caixa);
    end;


    Result := (lQuery.RecordCount > 0) and (lQuery.FieldByName('DESC').AsString <> EmptyStr);

  finally
    lQuery.Free;
  end;

end;

end.
