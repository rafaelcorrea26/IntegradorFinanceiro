unit uFornecedorDAO;

interface

uses
  FireDAC.Comp.Client,
  System.SysUtils,
  System.StrUtils,
  uConnection,
  uInterfacesEntity,
  uQuery,
  uFornecedor,
  uFunctions,
  REST.JSON.Types, Vcl.Dialogs;

type
  TFornecedorDAO = class(TInterfacedObject, iFornecedorDAO)
  private

  public
    class function Limpar(pFornecedor: TFornecedor): boolean;
    class function Carrega(pFornecedor: TFornecedor): boolean;
    class function Incluir(pFornecedor: TFornecedor; pCommit : Boolean = true): boolean;
    class function Alterar(pFornecedor: TFornecedor; pCommit : Boolean = true): boolean;
    class function Excluir(pCodigo: Integer; pCommit : Boolean = true): boolean;
    class function Existe(pCodigo: Integer): boolean;
    class function BuscaCodigoPeloCnpj(pCnpj: string): Integer;
    class function BuscaCodigoPeloCpf(pCpf: string): Integer;
    class function GeraProximoCodigo: Integer;

  end;

implementation

{ TFornecedorMC }

class function TFornecedorDAO.Alterar(pFornecedor: TFornecedor; pCommit : Boolean = true): boolean;
var
  lQuery: TQuery;
begin

  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE FORNEC SET                               ');
    lQuery.SQL.Add('   NOME = :NOME                              ');
    lQuery.SQL.Add(' , FANTASIA = :FANTASIA                      ');
    lQuery.SQL.Add(' , ENDERECO = :ENDERECO                      ');
    lQuery.SQL.Add(' , BAIRRO = :BAIRRO                          ');
    lQuery.SQL.Add(' , CIDADE = :CIDADE                          ');
    lQuery.SQL.Add(' , CEP = :CEP                                ');
    lQuery.SQL.Add(' , UF = :UF                                  ');
    lQuery.SQL.Add(' , FONE = :FONE                              ');
    lQuery.SQL.Add(' , FAX = :FAX                                ');
    lQuery.SQL.Add(' , CELULAR = :CELULAR                        ');
    lQuery.SQL.Add(' , EMAIL = :EMAIL                            ');
    lQuery.SQL.Add(' , DTCADASTRO = :DTCADASTRO                  ');
    lQuery.SQL.Add(' , FISJUR = :FISJUR                          ');
    lQuery.SQL.Add(' , ATIINATIVO = :ATIINATIVO                  ');
    lQuery.SQL.Add(' , DTNASCTO = :DTNASCTO                      ');
    lQuery.SQL.Add(' , CPF = :CPF                                ');
    lQuery.SQL.Add(' , CI = :CI                                  ');
    lQuery.SQL.Add(' , CGC = :CGC                                ');
    lQuery.SQL.Add(' , IE = :IE                                  ');
    lQuery.SQL.Add(' , ENDCOB = :ENDCOB                          ');
    lQuery.SQL.Add(' , CIDADECOB = :CIDADECOB                    ');
    lQuery.SQL.Add(' , BAIRROCOB = :BAIRROCOB                    ');
    lQuery.SQL.Add(' , UFCOB = :UFCOB                            ');
    lQuery.SQL.Add(' , CONTATO = :CONTATO                        ');
    lQuery.SQL.Add(' , OBSGERAL = :OBSGERAL                      ');
    lQuery.SQL.Add(' , DTMOV = :DTMOV                            ');
    lQuery.SQL.Add(' , ULTIMANF = :ULTIMANF                      ');
    lQuery.SQL.Add(' , VALORNF = :VALORNF                        ');
    lQuery.SQL.Add(' , ATACADO = :ATACADO                      ');
    lQuery.SQL.Add(' , TBLOCAL = :TBLOCAL                        ');
    lQuery.SQL.Add(' , TBEXTRA = :TBEXTRA                        ');
    lQuery.SQL.Add(' , FONE_CONTATO = :FONE_CONTATO              ');
    lQuery.SQL.Add(' , EMAIL_CONTATO = :EMAIL_CONTATO            ');
    lQuery.SQL.Add(' , SEQUENCIA = :SEQUENCIA                  ');
    lQuery.SQL.Add(' , DT_ALTERCAO = :DT_ALTERCAO              ');
    lQuery.SQL.Add(' , USU_ALTERACAO = :USU_ALTERACAO          ');
    lQuery.SQL.Add(' , SITE = :SITE                            ');
    lQuery.SQL.Add(' , OBS1 = :OBS1                            ');
    lQuery.SQL.Add(' , OBS2 = :OBS2                            ');
    lQuery.SQL.Add(' , USU_CADASTRO = :USU_CADASTRO            ');
    lQuery.SQL.Add(' , SPED_SN = :SPED_SN                      ');
    lQuery.SQL.Add(' , COD_SEFAZ = :COD_SEFAZ                  ');
    lQuery.SQL.Add(' , NR = :NR                                ');
    // lQuery.SQL.Add(' , CODIGO_LOGRADOURO = :CODIGO_LOGRADOURO  ');
    lQuery.SQL.Add(' , ALTERAR_CUSTOS = :ALTERAR_CUSTOS        ');
    lQuery.SQL.Add(' , REGIME = :REGIME                          ');
    lQuery.SQL.Add(' , CNAE = :CNAE                              ');
    lQuery.SQL.Add(' , CRT = :CRT                                ');
    // lQuery.SQL.Add(' , CONTA_GERENCIAL = :CONTA_GERENCIAL      ');
    lQuery.SQL.Add(' where (CODIGO = :CODIGO)                    ');
    lQuery.ParamByName('CODIGO').AsInteger := pFornecedor.Codigo;
    lQuery.ParamByName('NOME').AsString := copy(pFornecedor.Nome, 1, 35);
    lQuery.ParamByName('FANTASIA').AsString := copy(pFornecedor.Fantasia, 1, 20);
    lQuery.ParamByName('ENDERECO').AsString := copy(pFornecedor.Endereco, 1, 35);
    lQuery.ParamByName('BAIRRO').AsString := copy(pFornecedor.Bairro, 1, 20);
    lQuery.ParamByName('CIDADE').AsString := copy(pFornecedor.Cidade, 1, 30);
    lQuery.ParamByName('CEP').AsString := copy(pFornecedor.Cep, 1, 10);
    lQuery.ParamByName('UF').AsString := copy(pFornecedor.Uf, 1, 2);
    lQuery.ParamByName('FONE').AsString := copy(pFornecedor.Fone, 1, 15);
    lQuery.ParamByName('FAX').AsString := copy(pFornecedor.Fax, 1, 15);
    lQuery.ParamByName('CELULAR').AsString := copy(pFornecedor.Celular, 1, 15);
    lQuery.ParamByName('EMAIL').AsString := copy(pFornecedor.Email, 1, 50);
    lQuery.ParamByName('DTCADASTRO').AsDateTime := StrToDateTimedef(pFornecedor.data_cadastro, now);
    lQuery.ParamByName('FISJUR').AsString := tfunctions.GetSN(pFornecedor.pessoa_fisica);
    lQuery.ParamByName('ATIINATIVO').AsString := tfunctions.GetSN(pFornecedor.Ativo);
    lQuery.ParamByName('DTNASCTO').AsDate := StrToDatedef(pFornecedor.data_nascimento, now);
    lQuery.ParamByName('CPF').AsString := copy(pFornecedor.Cpf, 1, 11);
    lQuery.ParamByName('CI').AsString := copy(pFornecedor.carteira_identidade, 1, 10);
    lQuery.ParamByName('CGC').AsString := copy(pFornecedor.Cnpj, 1, 14);
    lQuery.ParamByName('IE').AsString := copy(pFornecedor.Ie, 1, 20);
    lQuery.ParamByName('ENDCOB').AsString := copy(pFornecedor.endereco_cobranca, 1, 35);
    lQuery.ParamByName('CIDADECOB').AsString := copy(pFornecedor.cidade_cobranca, 1, 30);
    lQuery.ParamByName('BAIRROCOB').AsString := copy(pFornecedor.bairro_cobranca, 1, 20);
    lQuery.ParamByName('UFCOB').AsString := copy(pFornecedor.uf_cobranca, 1, 2);
    lQuery.ParamByName('CONTATO').AsString := copy(pFornecedor.nome_representante, 1, 50);
    lQuery.ParamByName('OBSGERAL').AsString := pFornecedor.observacao_geral;
    lQuery.ParamByName('DTMOV').AsDate := StrToDatedef(pFornecedor.emissao_ultimo_movimento, now);
    lQuery.ParamByName('ULTIMANF').AsString := copy(pFornecedor.nota_fiscal_ultimo_movimento, 1, 10);
    lQuery.ParamByName('VALORNF').AsFloat := pFornecedor.valor_nota_fiscal_ultimo_movimento;
    lQuery.ParamByName('ATACADO').AsString := tfunctions.GetSN(pFornecedor.utilizar_rotina_atacado);
    lQuery.ParamByName('TBLOCAL').AsInteger := pFornecedor.Localizacao;
    lQuery.ParamByName('TBEXTRA').AsInteger := pFornecedor.Extra;
    lQuery.ParamByName('FONE_CONTATO').AsString := copy(pFornecedor.fone_representante, 1, 15);
    lQuery.ParamByName('EMAIL_CONTATO').AsString := copy(pFornecedor.email_representante, 1, 50);
    lQuery.ParamByName('SEQUENCIA').AsInteger := pFornecedor.Sequencia;
    lQuery.ParamByName('SITE').AsString := copy(pFornecedor.Site, 1, 100);
    lQuery.ParamByName('OBS1').AsString := copy(pFornecedor.Observacao1, 1, 150);
    lQuery.ParamByName('OBS2').AsString := copy(pFornecedor.Observacao2, 1, 150);
    lQuery.ParamByName('USU_CADASTRO').AsInteger := pFornecedor.usuario_cadastro;
    lQuery.ParamByName('SPED_SN').AsString := tfunctions.GetSN(pFornecedor.Sped);
    lQuery.ParamByName('COD_SEFAZ').AsString := copy(pFornecedor.codigo_cidade_ibge, 1, 14);
    lQuery.ParamByName('NR').AsString := copy(pFornecedor.Numero, 1, 15);
    lQuery.ParamByName('ALTERAR_CUSTOS').AsString := tfunctions.GetSN(pFornecedor.alterar_custos);
    lQuery.ParamByName('REGIME').AsInteger := pFornecedor.regime_tributario;
    lQuery.ParamByName('CNAE').AsString := copy(pFornecedor.CNAE, 1, 15);
    lQuery.ParamByName('CRT').AsInteger := pFornecedor.Crt;
    lQuery.ExecSQL;

    lQuery.Connection.commit;
  finally
    lQuery.Free;
  end;

end;

class function TFornecedorDAO.BuscaCodigoPeloCnpj(pCnpj: string): Integer;
var
  lQuery: TQuery;
  lIE: string;
begin
  Result := 0;
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.Connection := Tconnection.ObjectConnection.Connection;
    lQuery.SQL.Add('SELECT CODIGO FROM FORNEC    ');
    lQuery.SQL.Add(' WHERE CGC = :CNPJ               ');
    lQuery.ParamByName('CNPJ').AsString := pCnpj;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := lQuery.FieldByName('CODIGO').AsInteger;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TFornecedorDAO.BuscaCodigoPeloCpf(pCpf: string): Integer;
var
  lQuery: TQuery;
begin
  Result := 0;

  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT CPF FROM FORNEC ');
    lQuery.SQL.Add(' WHERE CPF = :CPF          ');
    lQuery.ParamByName('CPF').AsString := pCpf;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := lQuery.FieldByName('CODIGO').AsInteger;
    end;
  finally
    lQuery.Free;
  end;
end;

class function TFornecedorDAO.Carrega(pFornecedor: TFornecedor): boolean;
var
  lConsulta: TQuery;
begin

  lConsulta := TQuery.Create(nil);
  try
    lConsulta.Close;
    lConsulta.SQL.Clear;
    lConsulta.SQL.Add(' select * from FORNEC where CODIGO = :CODIGO ');
    lConsulta.ParamByName('CODIGO').AsInteger := pFornecedor.Codigo;
    lConsulta.Open;

    if lConsulta.RecordCount > 0 then
    begin
      // carrega dados
      pFornecedor.Codigo := lConsulta.FieldByName('CODIGO').AsInteger;
      pFornecedor.Nome := lConsulta.FieldByName('NOME').AsString;
      pFornecedor.Fantasia := lConsulta.FieldByName('FANTASIA').AsString;
      pFornecedor.Endereco := lConsulta.FieldByName('ENDERECO').AsString;
      pFornecedor.Numero := lConsulta.FieldByName('NR').AsString;
      pFornecedor.Bairro := lConsulta.FieldByName('BAIRRO').AsString;
      pFornecedor.Cidade := lConsulta.FieldByName('CIDADE').AsString;
      pFornecedor.Cep := lConsulta.FieldByName('CEP').AsString;
      pFornecedor.Ie := lConsulta.FieldByName('IE').AsString;
      pFornecedor.Fone := lConsulta.FieldByName('FONE').AsString;
      pFornecedor.Fax := lConsulta.FieldByName('FAX').AsString;
      pFornecedor.Celular := lConsulta.FieldByName('CELULAR').AsString;
      pFornecedor.Email := lConsulta.FieldByName('EMAIL').AsString;
      pFornecedor.codigo_cidade_ibge := lConsulta.FieldByName('COD_SEFAZ').AsString;
      pFornecedor.Uf := lConsulta.FieldByName('UF').AsString;
      pFornecedor.Sped := lConsulta.FieldByName('SPED_SN').AsString = 'S';
      pFornecedor.usuario_cadastro := lConsulta.FieldByName('USU_CADASTRO').AsInteger;
      pFornecedor.Usuario_Alteracao := lConsulta.FieldByName('USU_ALTERACAO').AsInteger;
      pFornecedor.Data_Alteracao := tfunctions.DecodeDateJson(lConsulta.FieldByName('DT_ALTERCAO').AsDateTime);
      pFornecedor.data_cadastro := tfunctions.DecodeDateHourJson(lConsulta.FieldByName('DTCADASTRO').AsDateTime);
      pFornecedor.Ativo := (lConsulta.FieldByName('ATIINATIVO').AsString = 'S');
      pFornecedor.pessoa_fisica := (lConsulta.FieldByName('FISJUR').AsString = 'S');
      pFornecedor.Cpf := lConsulta.FieldByName('CPF').AsString;
      pFornecedor.Cnpj := lConsulta.FieldByName('CGC').AsString;
      pFornecedor.Site := lConsulta.FieldByName('SITE').AsString;
      pFornecedor.Observacao1 := lConsulta.FieldByName('OBS1').AsString;
      pFornecedor.Observacao2 := lConsulta.FieldByName('OBS2').AsString;
      pFornecedor.endereco_cobranca := lConsulta.FieldByName('ENDCOB').AsString;
      pFornecedor.bairro_cobranca := lConsulta.FieldByName('BAIRROCOB').AsString;
      pFornecedor.cidade_cobranca := lConsulta.FieldByName('CIDADECOB').AsString;
      pFornecedor.Cep_Cobranca := lConsulta.FieldByName('CEP').AsString;
      pFornecedor.uf_cobranca := lConsulta.FieldByName('UFCOB').AsString;
      pFornecedor.Localizacao := lConsulta.FieldByName('TBLOCAL').AsInteger;
      pFornecedor.Extra := lConsulta.FieldByName('TBEXTRA').AsInteger;
      pFornecedor.utilizar_rotina_atacado := lConsulta.FieldByName('ATACADO').AsString = 'S';
      pFornecedor.observacao_geral := lConsulta.FieldByName('OBSGERAL').AsString;
      pFornecedor.nome_representante := lConsulta.FieldByName('CONTATO').AsString;
      pFornecedor.fone_representante := lConsulta.FieldByName('FONE_CONTATO').AsString;
      pFornecedor.email_representante := lConsulta.FieldByName('EMAIL_CONTATO').AsString;
      pFornecedor.emissao_ultimo_movimento := tfunctions.DecodeDateJson(lConsulta.FieldByName('DTMOV').AsDateTime);
      pFornecedor.nota_fiscal_ultimo_movimento := lConsulta.FieldByName('ULTIMANF').AsString;
      pFornecedor.valor_nota_fiscal_ultimo_movimento := lConsulta.FieldByName('VALORNF').AsFloat;
      pFornecedor.data_nascimento := tfunctions.DecodeDateJson((lConsulta.FieldByName('DTNASCTO').AsDateTime));
      pFornecedor.carteira_identidade := lConsulta.FieldByName('CI').AsString;
      pFornecedor.Sequencia := lConsulta.FieldByName('SEQUENCIA').AsInteger;
      pFornecedor.alterar_custos := lConsulta.FieldByName('ALTERAR_CUSTOS').AsString <> 'N';
      pFornecedor.regime_tributario := lConsulta.FieldByName('REGIME').AsInteger; // HS-100 // Vagner Oliveira
      pFornecedor.Crt := lConsulta.FieldByName('CRT').AsInteger; // HS-100 // Vagner Oliveira
      pFornecedor.CNAE := lConsulta.FieldByName('CNAE').AsString;
    end;

    Result := (lConsulta.RecordCount > 0) and (lConsulta.FieldByName('NOME').AsString <> EmptyStr);
  finally
    lConsulta.Free;
  end;
end;

class function TFornecedorDAO.Limpar(pFornecedor: TFornecedor): boolean;
begin
  pFornecedor.Codigo := 0;
  pFornecedor.Nome := EmptyStr;
  pFornecedor.Fantasia := EmptyStr;
  pFornecedor.Endereco := EmptyStr;
  pFornecedor.Numero := EmptyStr;
  pFornecedor.Bairro := EmptyStr;
  pFornecedor.Cidade := EmptyStr;
  pFornecedor.Cep := EmptyStr;
  pFornecedor.Ie := EmptyStr;
  pFornecedor.Fone := EmptyStr;
  pFornecedor.Fax := EmptyStr;
  pFornecedor.Celular := EmptyStr;
  pFornecedor.Email := EmptyStr;
  pFornecedor.codigo_cidade_ibge := EmptyStr;
  pFornecedor.Uf := EmptyStr;
  pFornecedor.Sped := false;
  pFornecedor.usuario_cadastro := 0;
  pFornecedor.Usuario_Alteracao := 0;
  pFornecedor.Data_Alteracao := '';
  pFornecedor.data_cadastro := '';
  pFornecedor.Ativo := true;
  pFornecedor.pessoa_fisica := true;
  pFornecedor.Cpf := EmptyStr;
  pFornecedor.Cnpj := EmptyStr;
  pFornecedor.Site := EmptyStr;
  pFornecedor.Observacao1 := EmptyStr;
  pFornecedor.Observacao2 := EmptyStr;
  pFornecedor.endereco_cobranca := EmptyStr;
  pFornecedor.bairro_cobranca := EmptyStr;
  pFornecedor.cidade_cobranca := EmptyStr;
  pFornecedor.Cep_Cobranca := EmptyStr;
  pFornecedor.uf_cobranca := EmptyStr;
  pFornecedor.Localizacao := 0;
  pFornecedor.Extra := 0;
  pFornecedor.utilizar_rotina_atacado := false;
  pFornecedor.observacao_geral := EmptyStr;
  pFornecedor.nome_representante := EmptyStr;
  pFornecedor.fone_representante := EmptyStr;
  pFornecedor.email_representante := EmptyStr;
  pFornecedor.emissao_ultimo_movimento := '';
  pFornecedor.nota_fiscal_ultimo_movimento := EmptyStr;
  pFornecedor.valor_nota_fiscal_ultimo_movimento := 0;
  pFornecedor.data_nascimento := '';
  pFornecedor.carteira_identidade := EmptyStr;
  pFornecedor.Sequencia := 0;
  pFornecedor.alterar_custos := false;
  pFornecedor.regime_tributario := 0;
  pFornecedor.Crt := 0;
  pFornecedor.CNAE := EmptyStr;
end;

class function TFornecedorDAO.Excluir(pCodigo: Integer; pCommit : Boolean = true): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM FORNEC WHERE CODIGO = :CODIGO ');
    lQuery.ParamByName('CODIGO').AsInteger := pCodigo;
    lQuery.ExecSQL;
    lQuery.Connection.commit;
  finally
    lQuery.Free;
  end;
end;

class function TFornecedorDAO.Existe(pCodigo: Integer): boolean;
var
  lQuery: TQuery;
begin
  Result := false;
  lQuery := TQuery.Create(nil);
  try

    lQuery.Connection := Tconnection.ObjectConnection.Connection;
    lQuery.SQL.Add('SELECT * FROM FORNEC WHERE CODIGO = :CODIGO');
    lQuery.ParamByName('CODIGO').AsInteger := pCodigo;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := true;
    end;
  finally
    lQuery.Free;
  end;
end;

class function TFornecedorDAO.GeraProximoCodigo: Integer;
var
  lQuery: TQuery;
begin
  Result := 0;
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT MAX(CODIGO) + 1 PROXIMO_CODIGO FROM FORNEC ');
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      Result := lQuery.FieldByName('PROXIMO_CODIGO').AsInteger;
    end;
  finally
    lQuery.Free;
  end;
end;

class function TFornecedorDAO.Incluir(pFornecedor: TFornecedor; pCommit : Boolean = true): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('INSERT INTO FORNEC (   ');
    lQuery.SQL.Add('    CODIGO             ');
    lQuery.SQL.Add('  , NOME               ');
    lQuery.SQL.Add('  , FANTASIA           ');
    lQuery.SQL.Add('  , ENDERECO           ');
    lQuery.SQL.Add('  , BAIRRO             ');
    lQuery.SQL.Add('  , CIDADE             ');
    lQuery.SQL.Add('  , CEP                ');
    lQuery.SQL.Add('  , UF                 ');
    lQuery.SQL.Add('  , FONE               ');
    lQuery.SQL.Add('  , FAX                ');
    lQuery.SQL.Add('  , CELULAR            ');
    lQuery.SQL.Add('  , EMAIL              ');
    lQuery.SQL.Add('  , DTCADASTRO         ');
    lQuery.SQL.Add('  , FISJUR             ');
    lQuery.SQL.Add('  , ATIINATIVO         ');
    lQuery.SQL.Add('  , DTNASCTO           ');
    lQuery.SQL.Add('  , CPF                ');
    lQuery.SQL.Add('  , CI                 ');
    lQuery.SQL.Add('  , CGC                ');
    lQuery.SQL.Add('  , IE                 ');
    lQuery.SQL.Add('  , ENDCOB             ');
    lQuery.SQL.Add('  , CIDADECOB          ');
    lQuery.SQL.Add('  , BAIRROCOB          ');
    lQuery.SQL.Add('  , UFCOB              ');
    lQuery.SQL.Add('  , CONTATO            ');
    lQuery.SQL.Add('  , OBSGERAL           ');
    lQuery.SQL.Add('  , DTMOV              ');
    lQuery.SQL.Add('  , ULTIMANF           ');
    lQuery.SQL.Add('  , VALORNF            ');
    lQuery.SQL.Add('  , ATACADO           ');
    lQuery.SQL.Add('  , TBLOCAL            ');
    lQuery.SQL.Add('  , TBEXTRA            ');
    lQuery.SQL.Add('  , FONE_CONTATO       ');
    lQuery.SQL.Add('  , EMAIL_CONTATO      ');
    lQuery.SQL.Add('  , SEQUENCIA         ');
    lQuery.SQL.Add('  , SITE              ');
    lQuery.SQL.Add('  , OBS1              ');
    lQuery.SQL.Add('  , OBS2              ');
    lQuery.SQL.Add('  , USU_CADASTRO      ');
    lQuery.SQL.Add('  , SPED_SN           ');
    lQuery.SQL.Add('  , COD_SEFAZ         ');
    lQuery.SQL.Add('  , NR                ');
    lQuery.SQL.Add('  , ALTERAR_CUSTOS    ');
    lQuery.SQL.Add('  , REGIME             ');
    lQuery.SQL.Add('  , CNAE               ');
    lQuery.SQL.Add('  , CRT                ');
    lQuery.SQL.Add(' )VALUES (                 ');
    lQuery.SQL.Add('    :CODIGO            ');
    lQuery.SQL.Add('  , :NOME              ');
    lQuery.SQL.Add('  , :FANTASIA          ');
    lQuery.SQL.Add('  , :ENDERECO          ');
    lQuery.SQL.Add('  , :BAIRRO            ');
    lQuery.SQL.Add('  , :CIDADE            ');
    lQuery.SQL.Add('  , :CEP               ');
    lQuery.SQL.Add('  , :UF                ');
    lQuery.SQL.Add('  , :FONE              ');
    lQuery.SQL.Add('  , :FAX               ');
    lQuery.SQL.Add('  , :CELULAR           ');
    lQuery.SQL.Add('  , :EMAIL             ');
    lQuery.SQL.Add('  , :DTCADASTRO        ');
    lQuery.SQL.Add('  , :FISJUR            ');
    lQuery.SQL.Add('  , :ATIINATIVO        ');
    lQuery.SQL.Add('  , :DTNASCTO          ');
    lQuery.SQL.Add('  , :CPF               ');
    lQuery.SQL.Add('  , :CI                ');
    lQuery.SQL.Add('  , :CGC               ');
    lQuery.SQL.Add('  , :IE                ');
    lQuery.SQL.Add('  , :ENDCOB            ');
    lQuery.SQL.Add('  , :CIDADECOB         ');
    lQuery.SQL.Add('  , :BAIRROCOB         ');
    lQuery.SQL.Add('  , :UFCOB             ');
    lQuery.SQL.Add('  , :CONTATO           ');
    lQuery.SQL.Add('  , :OBSGERAL          ');
    lQuery.SQL.Add('  , :DTMOV             ');
    lQuery.SQL.Add('  , :ULTIMANF          ');
    lQuery.SQL.Add('  , :VALORNF           ');
    lQuery.SQL.Add('  , :ATACADO          ');
    lQuery.SQL.Add('  , :TBLOCAL           ');
    lQuery.SQL.Add('  , :TBEXTRA           ');
    lQuery.SQL.Add('  , :FONE_CONTATO      ');
    lQuery.SQL.Add('  , :EMAIL_CONTATO     ');
    lQuery.SQL.Add('  , :SEQUENCIA        ');
    lQuery.SQL.Add('  , :SITE             ');
    lQuery.SQL.Add('  , :OBS1             ');
    lQuery.SQL.Add('  , :OBS2             ');
    lQuery.SQL.Add('  , :USU_CADASTRO     ');
    lQuery.SQL.Add('  , :SPED_SN          ');
    lQuery.SQL.Add('  , :COD_SEFAZ        ');
    lQuery.SQL.Add('  , :NR               ');
    lQuery.SQL.Add('  , :ALTERAR_CUSTOS   ');
    lQuery.SQL.Add('  , :REGIME            ');
    lQuery.SQL.Add('  , :CNAE              ');
    lQuery.SQL.Add('  , :CRT               ');
    lQuery.SQL.Add('  )                        ');
    lQuery.ParamByName('CODIGO').AsInteger := pFornecedor.Codigo;
    lQuery.ParamByName('NOME').AsString := copy(pFornecedor.Nome, 1, 35);
    lQuery.ParamByName('FANTASIA').AsString := copy(pFornecedor.Fantasia, 1, 20);
    lQuery.ParamByName('ENDERECO').AsString := copy(pFornecedor.Endereco, 1, 35);
    lQuery.ParamByName('BAIRRO').AsString := copy(pFornecedor.Bairro, 1, 20);
    lQuery.ParamByName('CIDADE').AsString := copy(pFornecedor.Cidade, 1, 30);
    lQuery.ParamByName('CEP').AsString := copy(pFornecedor.Cep, 1, 10);
    lQuery.ParamByName('UF').AsString := copy(pFornecedor.Uf, 1, 2);
    lQuery.ParamByName('FONE').AsString := copy(pFornecedor.Fone, 1, 15);
    lQuery.ParamByName('FAX').AsString := copy(pFornecedor.Fax, 1, 15);
    lQuery.ParamByName('CELULAR').AsString := copy(pFornecedor.Celular, 1, 15);
    lQuery.ParamByName('EMAIL').AsString := copy(pFornecedor.Email, 1, 50);
    lQuery.ParamByName('DTCADASTRO').AsDateTime := StrToDateTimedef(pFornecedor.data_cadastro, now);
    lQuery.ParamByName('FISJUR').AsString := tfunctions.GetSN(pFornecedor.pessoa_fisica);
    lQuery.ParamByName('ATIINATIVO').AsString := tfunctions.GetSN(pFornecedor.Ativo);
    lQuery.ParamByName('DTNASCTO').AsDate := StrToDatedef(pFornecedor.data_nascimento, now);
    lQuery.ParamByName('CPF').AsString := copy(pFornecedor.Cpf, 1, 11);
    lQuery.ParamByName('CI').AsString := copy(pFornecedor.carteira_identidade, 1, 10);
    lQuery.ParamByName('CGC').AsString := copy(pFornecedor.Cnpj, 1, 14);
    lQuery.ParamByName('IE').AsString := copy(pFornecedor.Ie, 1, 20);
    lQuery.ParamByName('ENDCOB').AsString := copy(pFornecedor.endereco_cobranca, 1, 35);
    lQuery.ParamByName('CIDADECOB').AsString := copy(pFornecedor.cidade_cobranca, 1, 30);
    lQuery.ParamByName('BAIRROCOB').AsString := copy(pFornecedor.bairro_cobranca, 1, 20);
    lQuery.ParamByName('UFCOB').AsString := copy(pFornecedor.uf_cobranca, 1, 2);
    lQuery.ParamByName('CONTATO').AsString := copy(pFornecedor.nome_representante, 1, 50);
    lQuery.ParamByName('OBSGERAL').AsString := pFornecedor.observacao_geral;
    lQuery.ParamByName('DTMOV').AsDate := StrToDatedef(pFornecedor.emissao_ultimo_movimento, now);
    lQuery.ParamByName('ULTIMANF').AsString := copy(pFornecedor.nota_fiscal_ultimo_movimento, 1, 10);
    lQuery.ParamByName('VALORNF').AsFloat := pFornecedor.valor_nota_fiscal_ultimo_movimento;
    lQuery.ParamByName('ATACADO').AsString := tfunctions.GetSN(pFornecedor.utilizar_rotina_atacado);
    lQuery.ParamByName('TBLOCAL').AsInteger := pFornecedor.Localizacao;
    lQuery.ParamByName('TBEXTRA').AsInteger := pFornecedor.Extra;
    lQuery.ParamByName('FONE_CONTATO').AsString := copy(pFornecedor.fone_representante, 1, 15);
    lQuery.ParamByName('EMAIL_CONTATO').AsString := copy(pFornecedor.email_representante, 1, 50);
    lQuery.ParamByName('SEQUENCIA').AsInteger := pFornecedor.Sequencia;
    lQuery.ParamByName('SITE').AsString := copy(pFornecedor.Site, 1, 100);
    lQuery.ParamByName('OBS1').AsString := copy(pFornecedor.Observacao1, 1, 150);
    lQuery.ParamByName('OBS2').AsString := copy(pFornecedor.Observacao2, 1, 150);
    lQuery.ParamByName('USU_CADASTRO').AsInteger := pFornecedor.usuario_cadastro;
    lQuery.ParamByName('SPED_SN').AsString := tfunctions.GetSN(pFornecedor.Sped);
    lQuery.ParamByName('COD_SEFAZ').AsString := copy(pFornecedor.codigo_cidade_ibge, 1, 14);
    lQuery.ParamByName('NR').AsString := copy(pFornecedor.Numero, 1, 15);
    lQuery.ParamByName('ALTERAR_CUSTOS').AsString := tfunctions.GetSN(pFornecedor.alterar_custos);
    lQuery.ParamByName('REGIME').AsInteger := pFornecedor.regime_tributario;
    lQuery.ParamByName('CNAE').AsString := copy(pFornecedor.CNAE, 1, 15);
    lQuery.ParamByName('CRT').AsInteger := pFornecedor.Crt;
    lQuery.ExecSQL;
    lQuery.Connection.commit;
  finally
    lQuery.Free;
  end;

end;

end.
