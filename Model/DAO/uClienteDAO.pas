unit uClienteDAO;

interface

uses

  uCidadeDAO,
  uQuery,
  System.SysUtils,
  Vcl.Dialogs,
  Data.DB,
  uFunctions,
  uCidade,
  uCliente,
  REST.JSON.Types,
  uInterfacesEntity;

type
  TClienteDAO = class(TInterfacedObject, iClienteDAO)
  public
    class function Carrega(pCliente: TCliente): Boolean;
    class function Incluir(pCliente: TCliente; pCommit : Boolean = true): Boolean;
    class function Alterar(pCliente: TCliente; pCommit : Boolean = true): Boolean;
    class function Excluir(pCodigo: Integer; pCommit : Boolean = true): Boolean;
    class function GeraCodigo: Integer;
    class function Limpar(pCliente: TCliente): Boolean;
    class function Existe(pCodigo: Integer): Boolean;
    class function ExisteCPF(pCPF: string): Integer;
    class function ExisteCNPJ(pCNPJ: String): Integer;

  end;

implementation

{ TClienteDAO }
class function TClienteDAO.Alterar(pCliente: TCliente; pCommit : Boolean = true): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('update MC01CLIENTE set                             ');
    lQuery.SQL.Add('  MC01NOME               =:MC01NOME,               ');
    lQuery.SQL.Add('  MC01FANTASIA           =:MC01FANTASIA,           ');
    lQuery.SQL.Add('  MC01ENDERECO           =:MC01ENDERECO,           ');
    lQuery.SQL.Add('  MC01BAIRRO             =:MC01BAIRRO,             ');
    lQuery.SQL.Add('  MC01CIDADE             =:MC01CIDADE,             ');
    lQuery.SQL.Add('  MC01CEP                =:MC01CEP,                ');
    lQuery.SQL.Add('  MC01UF                 =:MC01UF,                 ');
    lQuery.SQL.Add('  MC01FONE               =:MC01FONE,               ');
    lQuery.SQL.Add('  MC01FAX                =:MC01FAX,                ');
    lQuery.SQL.Add('  MC01CELULAR            =:MC01CELULAR,            ');
    lQuery.SQL.Add('  MC01EMAIL              =:MC01EMAIL,              ');
    lQuery.SQL.Add('  MC01DTCADASTRO         =:MC01DTCADASTRO,         ');
    lQuery.SQL.Add('  MC01FISJUR             =:MC01FISJUR,             ');
    lQuery.SQL.Add('  MC01ATIINATIVO         =:MC01ATIINATIVO,         ');
    lQuery.SQL.Add('  MC01DTNASCTO           =:MC01DTNASCTO,           ');
    lQuery.SQL.Add('  MC01CPF                =:MC01CPF,                ');
    lQuery.SQL.Add('  MC01CI                 =:MC01CI,                 ');
    lQuery.SQL.Add('  MC01CGC                =:MC01CGC,                ');
    lQuery.SQL.Add('  MC01IE                 =:MC01IE,                 ');
    lQuery.SQL.Add('  MC01SEXO               =:MC01SEXO,               ');
    lQuery.SQL.Add('  MC01ESTCIVIL           =:MC01ESTCIVIL,           ');
    lQuery.SQL.Add('  MC01NATURALIDADE       =:MC01NATURALIDADE,       ');
    lQuery.SQL.Add('  MC01PAI                =:MC01PAI,                ');
    lQuery.SQL.Add('  MC01MAE                =:MC01MAE,                ');
    lQuery.SQL.Add('  MC01ENDCOB             =:MC01ENDCOB,             ');
    lQuery.SQL.Add('  MC01CIDADECOB          =:MC01CIDADECOB,          ');
    lQuery.SQL.Add('  MC01BAIRROCOB          =:MC01BAIRROCOB,          ');
    lQuery.SQL.Add('  MC01CEPCOB             =:MC01CEPCOB,             ');
    lQuery.SQL.Add('  MC01UFCOB              =:MC01UFCOB,              ');
    lQuery.SQL.Add('  MC01CONTATO            =:MC01CONTATO,            ');
    lQuery.SQL.Add('  MC01ALUGUEL            =:MC01ALUGUEL,            ');
    lQuery.SQL.Add('  MC01VALORALUGUEL       =:MC01VALORALUGUEL,       ');
    lQuery.SQL.Add('  MC01TEMPOALUGUEL       =:MC01TEMPOALUGUEL,       ');
    lQuery.SQL.Add('  MC01EMPRESA            =:MC01EMPRESA,            ');
    lQuery.SQL.Add('  MC01FONEEMP            =:MC01FONEEMP,            ');
    lQuery.SQL.Add('  MC01FUNCAOEMP          =:MC01FUNCAOEMP,          ');
    lQuery.SQL.Add('  MC01ADMISSAO           =:MC01ADMISSAO,           ');
    lQuery.SQL.Add('  MC01SALARIO            =:MC01SALARIO,            ');
    lQuery.SQL.Add('  MC01REFCOM             =:MC01REFCOM,             ');
    lQuery.SQL.Add('  MC01REFBAN             =:MC01REFBAN,             ');
    lQuery.SQL.Add('  MC01DTSPC              =:MC01DTSPC,              ');
    lQuery.SQL.Add('  MC01OBSSPC             =:MC01OBSSPC,             ');
    lQuery.SQL.Add('  MC01OBSGERAL           =:MC01OBSGERAL,           ');
    lQuery.SQL.Add('  MC01SITSPC             =:MC01SITSPC,             ');
    lQuery.SQL.Add('  MC01CONJUGE            =:MC01CONJUGE,            ');
    lQuery.SQL.Add('  MC01REFPESSOAL         =:MC01REFPESSOAL,         ');
    lQuery.SQL.Add('  MC01DTORCI             =:MC01DTORCI,             ');
    lQuery.SQL.Add('  MC01DTMOV              =:MC01DTMOV,              ');
    lQuery.SQL.Add('  MC01LIMITECRED         =:MC01LIMITECRED,         ');
    lQuery.SQL.Add('  MC01SALDOCRED          =:MC01SALDOCRED,          ');
    lQuery.SQL.Add('  MC01ULTIMANF           =:MC01ULTIMANF,           ');
    lQuery.SQL.Add('  MC01VALORNF            =:MC01VALORNF,            ');
    lQuery.SQL.Add('  MC01TBLOCAL            =:MC01TBLOCAL,            ');
    lQuery.SQL.Add('  MC01TBEXTRA            =:MC01TBEXTRA,            ');
    lQuery.SQL.Add('  MC01LOCALCOB           =:MC01LOCALCOB,           ');
    lQuery.SQL.Add('  MC01REP                =:MC01REP,                ');
    lQuery.SQL.Add('  MC01TIPOCRED           =:MC01TIPOCRED,           ');
    lQuery.SQL.Add('  MC01NRDUPABE           =:MC01NRDUPABE,           ');
    lQuery.SQL.Add('  MC01VIP                =:MC01VIP,                ');
    lQuery.SQL.Add('  MC01CODVIP             =:MC01CODVIP,             ');
    lQuery.SQL.Add('  MC01VALIDVIP           =:MC01VALIDVIP,           ');
    lQuery.SQL.Add('  MC01_DT_ALTERACAO      =:MC01_DT_ALTERACAO,      ');
    lQuery.SQL.Add('  MC01_SALARIO_OK        =:MC01_SALARIO_OK,        ');
    lQuery.SQL.Add('  MC01_ENDERECO_OK       =:MC01_ENDERECO_OK,       ');
    lQuery.SQL.Add('  MC01_CONVENIO_OK       =:MC01_CONVENIO_OK,       ');
    lQuery.SQL.Add('  MC01_TAB_CONVENIO      =:MC01_TAB_CONVENIO,      ');
    lQuery.SQL.Add('  MC01_TAB_PROFISSAO     =:MC01_TAB_PROFISSAO,     ');
    lQuery.SQL.Add('  MC01_DIA_VCTO          =:MC01_DIA_VCTO,          ');
    lQuery.SQL.Add('  MC01_DT_COBRANCA       =:MC01_DT_COBRANCA,       ');
    lQuery.SQL.Add('  MC01_QTDE_COBRANCA     =:MC01_QTDE_COBRANCA,     ');
    lQuery.SQL.Add('  MC01_ICMS              =:MC01_ICMS,              ');
    lQuery.SQL.Add('  MC01_SUBST_TRIB        =:MC01_SUBST_TRIB,        ');
    lQuery.SQL.Add('  MC01FOTO               =:MC01FOTO,               ');
    lQuery.SQL.Add('  MC01_ATACADO           =:MC01_ATACADO,           ');
    lQuery.SQL.Add('  MC01_LIMITEDESCONTO    =:MC01_LIMITEDESCONTO,    ');
    lQuery.SQL.Add('  MC01_FRPGTO            =:MC01_FRPGTO,            ');
    lQuery.SQL.Add('  MC01_MUDAR_FRPGTO      =:MC01_MUDAR_FRPGTO,      ');
    lQuery.SQL.Add('  MC01_PRAZO_DIAS        =:MC01_PRAZO_DIAS,        ');
    lQuery.SQL.Add('  MC01DIVIDA             =:MC01DIVIDA,             ');
    lQuery.SQL.Add('  MC01TOL_SALDO          =:MC01TOL_SALDO,          ');
    lQuery.SQL.Add('  MC01ROTA               =:MC01ROTA,               ');
    lQuery.SQL.Add('  MC01ORD_VIS            =:MC01ORD_VIS,            ');
    lQuery.SQL.Add('  MC01_OBS1              =:MC01_OBS1,              ');
    lQuery.SQL.Add('  MC01_OBS2              =:MC01_OBS2,              ');
    lQuery.SQL.Add('  MC01SUPER_LIMITE_DIAS  =:MC01SUPER_LIMITE_DIAS,  ');
    lQuery.SQL.Add('  MC01_CARTORIO          =:MC01_CARTORIO,          ');
    lQuery.SQL.Add('  MC01_SERASA            =:MC01_SERASA,            ');
    lQuery.SQL.Add('  MC01_USU_ALTERACAO     =:MC01_USU_ALTERACAO,     ');
    lQuery.SQL.Add('  MC01_USU_CADASTRO      =:MC01_USU_CADASTRO,      ');
    lQuery.SQL.Add('  MC01_SPED_SN           =:MC01_SPED_SN,           ');
    lQuery.SQL.Add('  MC01_PISCOFINS_SN      =:MC01_PISCOFINS_SN,      ');
    lQuery.SQL.Add('  MC01_NR                =:MC01_NR,                ');
    lQuery.SQL.Add('  MC01_CONSUMIDOR_FINAL  =:MC01_CONSUMIDOR_FINAL,  ');
    lQuery.SQL.Add('  MC01_INDPRES           =:MC01_INDPRES,           ');
    lQuery.SQL.Add('  MC01_INDIEDEST         =:MC01_INDIEDEST,         ');
    lQuery.SQL.Add('  MC01_COMPLEMENTO       =:MC01_COMPLEMENTO,       ');
    lQuery.SQL.Add('  MC01_BOLETO_COM_TAXA   =:MC01_BOLETO_COM_TAXA,   ');
    lQuery.SQL.Add('  MC01_NOME_COMPLETO_NFE =:MC01_NOME_COMPLETO_NFE, ');
    lQuery.SQL.Add('  MC01OBS_INTERNA        =:MC01OBS_INTERNA         ');
    lQuery.SQL.Add('WHERE MC01CODIGO         =:MC01CODIGO              ');

    lQuery.ParamByName('MC01CODIGO').AsInteger := pCliente.Codigo;
    lQuery.ParamByName('MC01NOME').AsString := Copy(pCliente.Nome, 1, 35);
    lQuery.ParamByName('MC01FANTASIA').AsString := Copy(pCliente.Matricula, 1, 35);
    lQuery.ParamByName('MC01ENDERECO').AsString := Copy(pCliente.Endereco, 1, 35);
    lQuery.ParamByName('MC01BAIRRO').AsString := Copy(pCliente.Bairro, 1, 20);
    lQuery.ParamByName('MC01CIDADE').AsString := Copy(pCliente.Cidade, 1, 30);
    lQuery.ParamByName('MC01CEP').AsString := Copy(pCliente.Cep, 1, 10);
    lQuery.ParamByName('MC01UF').AsString := Copy(pCliente.Uf, 1, 2);
    lQuery.ParamByName('MC01FONE').AsString := Copy(pCliente.Fone, 1, 15);
    lQuery.ParamByName('MC01FAX').AsString := Copy(pCliente.Fax, 1, 15);
    lQuery.ParamByName('MC01CELULAR').AsString := Copy(pCliente.Celular, 1, 15);
    lQuery.ParamByName('MC01EMAIL').AsString := Copy(pCliente.Email, 1, 50);
    lQuery.ParamByName('MC01DTCADASTRO').AsDateTime := StrToDateTimedef(pCliente.data_cadastro, now);
    lQuery.ParamByName('MC01FISJUR').AsString := TFunctions.GetSn(pCliente.pessoa_fisica);
    lQuery.ParamByName('MC01ATIINATIVO').AsString := TFunctions.GetSn(pCliente.Ativo);
    lQuery.ParamByName('MC01DTNASCTO').AsDate := StrToDatedef(pCliente.data_nascimento, now);
    lQuery.ParamByName('MC01CPF').AsString := Copy(pCliente.CPF, 1, 11);
    lQuery.ParamByName('MC01CI').AsString := Copy(pCliente.Rg, 1, 10);
    lQuery.ParamByName('MC01CGC').AsString := Copy(pCliente.CNPJ, 1, 14);
    lQuery.ParamByName('MC01IE').AsString := Copy(pCliente.Ie, 1, 20);
    lQuery.ParamByName('MC01SEXO').AsString := Copy(pCliente.Sexo, 1, 1);
    lQuery.ParamByName('MC01ESTCIVIL').AsString := Copy(pCliente.estado_civil, 1, 1);
    lQuery.ParamByName('MC01NATURALIDADE').AsString := Copy(pCliente.Naturalidade, 1, 30);
    lQuery.ParamByName('MC01PAI').AsString := Copy(pCliente.Pai, 1, 35);
    lQuery.ParamByName('MC01MAE').AsString := Copy(pCliente.Mae, 1, 35);
    lQuery.ParamByName('MC01ENDCOB').AsString := Copy(pCliente.endereco_cobranca, 1, 35);
    lQuery.ParamByName('MC01CIDADECOB').AsString := Copy(pCliente.cidade_cobranca, 1, 30);
    lQuery.ParamByName('MC01BAIRROCOB').AsString := Copy(pCliente.bairro_cobranca, 1, 20);
    lQuery.ParamByName('MC01CEPCOB').AsString := Copy(pCliente.cep_cobranca, 1, 10);
    lQuery.ParamByName('MC01UFCOB').AsString := Copy(pCliente.uf_cobranca, 1, 2);
    lQuery.ParamByName('MC01CONTATO').AsString := Copy(pCliente.Contato, 1, 50);
    lQuery.ParamByName('MC01ALUGUEL').AsString := Copy(pCliente.Aluguel, 1, 1);
    lQuery.ParamByName('MC01VALORALUGUEL').AsFloat := pCliente.valor_aluguel;
    lQuery.ParamByName('MC01TEMPOALUGUEL').AsString := Copy(pCliente.tempo_aluguel, 1, 25);
    lQuery.ParamByName('MC01EMPRESA').AsString := Copy(pCliente.Empresa, 1, 35);
    lQuery.ParamByName('MC01FONEEMP').AsString := Copy(pCliente.fone_empresa, 1, 15);
    lQuery.ParamByName('MC01FUNCAOEMP').AsString := Copy(pCliente.funcao_empresa, 1, 15);
    lQuery.ParamByName('MC01ADMISSAO').AsString := pCliente.Admissao; // data em string?
    lQuery.ParamByName('MC01SALARIO').AsString := Copy(pCliente.Salario, 1, 25);
    lQuery.ParamByName('MC01REFCOM').AsString := Copy(pCliente.referencia_comercial, 1, 100);
    lQuery.ParamByName('MC01REFBAN').AsString := Copy(pCliente.referencia_banco, 1, 100);
    lQuery.ParamByName('MC01DTSPC').AsDate := StrToDatedef(pCliente.data_spc, now);
    lQuery.ParamByName('MC01OBSSPC').AsString := Copy(pCliente.observacao_spc, 1, 100);
    lQuery.ParamByName('MC01OBSGERAL').AsString := pCliente.observacao_geral; // blob
    lQuery.ParamByName('MC01SITSPC').AsString := TFunctions.GetSn(pCliente.ativo_no_spc);
    lQuery.ParamByName('MC01CONJUGE').AsString := Copy(pCliente.Conjuge, 1, 50);
    lQuery.ParamByName('MC01REFPESSOAL').AsString := Copy(pCliente.referencia_pessoal, 1, 50);
    lQuery.ParamByName('MC01DTORCI').AsString := Copy(pCliente.data_orci, 1, 25);
    lQuery.ParamByName('MC01DTMOV').AsDate := StrToDatedef(pCliente.data_movimento, now);
    lQuery.ParamByName('MC01LIMITECRED').AsFloat := pCliente.valor_limite_do_cliente;
    lQuery.ParamByName('MC01SALDOCRED').AsFloat := pCliente.saldo_credito;
    lQuery.ParamByName('MC01ULTIMANF').AsString := Copy(pCliente.Ultima_Nf, 1, 10);
    lQuery.ParamByName('MC01VALORNF').AsFloat := pCliente.Valor_Nf;
    lQuery.ParamByName('MC01TBLOCAL').AsInteger := pCliente.Tabela_Localizacao;
    lQuery.ParamByName('MC01TBEXTRA').AsInteger := pCliente.Tabela_Extra;
    lQuery.ParamByName('MC01LOCALCOB').AsString := Copy(pCliente.Local_Cobranca, 1, 3);
    lQuery.ParamByName('MC01REP').AsInteger := pCliente.Vendedor;
    lQuery.ParamByName('MC01TIPOCRED').AsString := Copy(pCliente.Tipo_De_Credito, 1, 1);
    lQuery.ParamByName('MC01NRDUPABE').AsInteger := pCliente.numero_duplicatas_abertas;
    lQuery.ParamByName('MC01VIP').AsString := Copy(pCliente.Vip, 1, 1);
    lQuery.ParamByName('MC01CODVIP').AsString := Copy(pCliente.cidade_ibge.Codigo, 1, 14);
    lQuery.ParamByName('MC01VALIDVIP').AsDate := StrToDatedef(pCliente.validade_vip, now);
    lQuery.ParamByName('MC01_SALARIO_OK').AsString := TFunctions.GetSn(pCliente.salario_ok);
    lQuery.ParamByName('MC01_ENDERECO_OK').AsString := TFunctions.GetSn(pCliente.endereco_ok);
    lQuery.ParamByName('MC01_CONVENIO_OK').AsString := TFunctions.GetSn(pCliente.convenio_ok);
    lQuery.ParamByName('MC01_TAB_CONVENIO').AsInteger := pCliente.tabela_convenio;
    lQuery.ParamByName('MC01_TAB_PROFISSAO').AsInteger := pCliente.tabela_profissao;
    lQuery.ParamByName('MC01_DIA_VCTO').AsInteger := pCliente.dia_fixo_de_vencimento;
    lQuery.ParamByName('MC01_DT_COBRANCA').AsDate := StrToDatedef(pCliente.data_cobranca, now);
    lQuery.ParamByName('MC01_QTDE_COBRANCA').AsInteger := pCliente.quantida_de_cobranca;
    lQuery.ParamByName('MC01_ICMS').AsFloat := pCliente.Icms;
    lQuery.ParamByName('MC01_SUBST_TRIB').AsString := TFunctions.GetSn(pCliente.substituicao_tributaria);
    lQuery.ParamByName('MC01FOTO').AsString := Copy(pCliente.foto_caminho, 1, 45);
    lQuery.ParamByName('MC01_ATACADO').AsString := Copy(pCliente.Atacado, 1, 1);
    lQuery.ParamByName('MC01_LIMITEDESCONTO').AsFloat := pCliente.limite_desconto;
    lQuery.ParamByName('MC01_FRPGTO').AsInteger := pCliente.forma_de_pagamento_padrao;
    lQuery.ParamByName('MC01_MUDAR_FRPGTO').AsString := Copy(pCliente.mudar_forma_pagamento, 1, 1);
    lQuery.ParamByName('MC01_PRAZO_DIAS').AsInteger := pCliente.prazo_maximo_em_dias;
    lQuery.ParamByName('MC01DIVIDA').AsFloat := pCliente.Divida;
    lQuery.ParamByName('MC01TOL_SALDO').AsFloat := pCliente.saldo_total;
    lQuery.ParamByName('MC01ROTA').AsString := Copy(pCliente.Rota, 1, 4);
    lQuery.ParamByName('MC01ORD_VIS').AsInteger := pCliente.ordem_visita;
    lQuery.ParamByName('MC01_OBS1').AsString := Copy(pCliente.Observacao1, 1, 75);
    lQuery.ParamByName('MC01_OBS2').AsString := Copy(pCliente.Observacao2, 1, 75);
    lQuery.ParamByName('MC01SUPER_LIMITE_DIAS').AsInteger := pCliente.super_limite_dias;
    lQuery.ParamByName('MC01_CARTORIO').AsString := Copy(pCliente.Cartorio, 1, 1);
    lQuery.ParamByName('MC01_SERASA').AsString := Copy(pCliente.Serasa, 1, 1);
    lQuery.ParamByName('MC01_USU_CADASTRO').AsInteger := pCliente.usuario_cadastro;
    lQuery.ParamByName('MC01_SPED_SN').AsString := TFunctions.GetSn(pCliente.Sped);
    lQuery.ParamByName('MC01_PISCOFINS_SN').AsString := TFunctions.GetSn(pCliente.Pis_Cofins);
    lQuery.ParamByName('MC01_NR').AsString := Copy(pCliente.Numero, 1, 15);
    lQuery.ParamByName('MC01_CONSUMIDOR_FINAL').AsString := Copy(pCliente.consumidor_final, 1, 1);
    lQuery.ParamByName('MC01_INDPRES').AsString := Copy(pCliente.indicador_presenca_comprador, 1, 1);
    lQuery.ParamByName('MC01_INDIEDEST').AsString := Copy(pCliente.indicador_destinatario, 1, 1);
    lQuery.ParamByName('MC01_COMPLEMENTO').AsString := Copy(pCliente.Complemento, 1, 50);
    lQuery.ParamByName('MC01_BOLETO_COM_TAXA').AsString := Copy(pCliente.boleto_com_taxa, 1, 1);
    lQuery.ParamByName('MC01_NOME_COMPLETO_NFE').AsString := Copy(pCliente.nome_completo_nfe, 1, 60);
    lQuery.ParamByName('MC01OBS_INTERNA').AsString := pCliente.observacao_interna; // blob
    lQuery.ExecSql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;

end;

class function TClienteDAO.Carrega(pCliente: TCliente): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT * FROM MC01CLIENTE WHERE MC01CODIGO = :MC01CODIGO ');
    lQuery.ParamByName('MC01CODIGO').AsInteger := pCliente.Codigo;
    lQuery.Open;

    pCliente.Codigo := lQuery.FieldByName('MC01CODIGO').AsInteger;
    pCliente.Nome := lQuery.FieldByName('MC01NOME').AsString;
    pCliente.forma_de_pagamento_padrao := lQuery.FieldByName('MC01_FRPGTO').AsInteger;
    pCliente.Tipo_De_Credito := lQuery.FieldByName('MC01TIPOCRED').AsString;
    pCliente.prazo_maximo_em_dias := lQuery.FieldByName('MC01_PRAZO_DIAS').AsInteger;
    pCliente.pessoa_fisica := (lQuery.FieldByName('MC01FISJUR').AsString = 'S');
    pCliente.CPF := lQuery.FieldByName('MC01CPF').AsString;
    pCliente.CNPJ := lQuery.FieldByName('MC01CGC').AsString;
    pCliente.valor_limite_do_cliente := lQuery.FieldByName('MC01LIMITECRED').AsFloat;

    pCliente.Ativo := (lQuery.FieldByName('MC01ATIINATIVO').AsString = 'S');
    pCliente.ativo_no_spc := (lQuery.FieldByName('MC01SITSPC').AsString = 'S');

    if not lQuery.FieldByName('MC01_DIA_VCTO').IsNull then
    begin
      pCliente.dia_fixo_de_vencimento := lQuery.FieldByName('MC01_DIA_VCTO').AsInteger;
    end;

    pCliente.Ie := lQuery.FieldByName('MC01IE').AsString;
    pCliente.Fone := lQuery.FieldByName('MC01FONE').AsString;
    pCliente.Email := lQuery.FieldByName('MC01EMAIL').AsString;
    pCliente.Bairro := lQuery.FieldByName('MC01BAIRRO').AsString;
    pCliente.Fax := lQuery.FieldByName('MC01FAX').AsString;
    pCliente.Uf := lQuery.FieldByName('MC01UF').AsString;
    pCliente.Cep := lQuery.FieldByName('MC01CEP').AsString;
    pCliente.Numero := lQuery.FieldByName('MC01_NR').AsString;
    pCliente.Complemento := lQuery.FieldByName('MC01_COMPLEMENTO').AsString;
    pCliente.Matricula := lQuery.FieldByName('MC01FANTASIA').AsString;
    pCliente.Cidade := lQuery.FieldByName('MC01CIDADE').AsString;
    pCliente.Endereco := lQuery.FieldByName('MC01ENDERECO').AsString;
    pCliente.Celular := lQuery.FieldByName('MC01CELULAR').AsString;
    pCliente.endereco_ok := lQuery.FieldByName('MC01_ENDERECO_OK').AsString = 'S';
    pCliente.convenio_ok := lQuery.FieldByName('MC01_CONVENIO_OK').AsString = 'S';
    pCliente.substituicao_tributaria := lQuery.FieldByName('MC01_SUBST_TRIB').AsString = 'S';
    pCliente.salario_ok := lQuery.FieldByName('MC01_SALARIO_OK').AsString = 'S';
    pCliente.Pis_Cofins := lQuery.FieldByName('MC01_PISCOFINS_SN').AsString = 'S';
    pCliente.Sped := lQuery.FieldByName('MC01_SPED_SN').AsString = 'S';
    pCliente.usuario_alteracao := lQuery.FieldByName('MC01_USU_ALTERACAO').AsInteger;
    pCliente.usuario_cadastro := lQuery.FieldByName('MC01_USU_CADASTRO').AsInteger;
    pCliente.data_cadastro := TFunctions.DecodeDateJson(lQuery.FieldByName('MC01DTCADASTRO').AsDateTime);
    pCliente.data_alteracao := TFunctions.DecodeDateHourJson(lQuery.FieldByName('MC01_DT_ALTERACAO').AsDateTime);
    pCliente.indicador_destinatario := lQuery.FieldByName('MC01_INDIEDEST').AsString;
    pCliente.consumidor_final := lQuery.FieldByName('MC01_CONSUMIDOR_FINAL').AsString;
    pCliente.indicador_presenca_comprador := lQuery.FieldByName('MC01_INDPRES').AsString;
    pCliente.saldo_credito := lQuery.FieldByName('MC01SALDOCRED').AsFloat;
    pCliente.numero_duplicatas_abertas := lQuery.FieldByName('MC01NRDUPABE').AsInteger;
    pCliente.data_nascimento := TFunctions.DecodeDateJson(lQuery.FieldByName('mc01dtnascto').AsDateTime);
    pCliente.Rg := lQuery.FieldByName('mc01ci').AsString;
    pCliente.Sexo := lQuery.FieldByName('mc01sexo').AsString;
    pCliente.estado_civil := lQuery.FieldByName('mc01estcivil').AsString;
    pCliente.Naturalidade := lQuery.FieldByName('mc01naturalidade').AsString;
    pCliente.Pai := lQuery.FieldByName('mc01pai').AsString;
    pCliente.Mae := lQuery.FieldByName('mc01mae').AsString;
    pCliente.endereco_cobranca := lQuery.FieldByName('mc01endcob').AsString;
    pCliente.cidade_cobranca := lQuery.FieldByName('mc01cidadecob').AsString;
    pCliente.bairro_cobranca := lQuery.FieldByName('mc01bairrocob').AsString;
    pCliente.cep_cobranca := lQuery.FieldByName('mc01cepcob').AsString;
    pCliente.uf_cobranca := lQuery.FieldByName('mc01ufcob').AsString;
    pCliente.Contato := lQuery.FieldByName('mc01contato').AsString;
    pCliente.Aluguel := lQuery.FieldByName('mc01aluguel').AsString;
    pCliente.valor_aluguel := lQuery.FieldByName('mc01valoraluguel').AsFloat;
    pCliente.tempo_aluguel := lQuery.FieldByName('mc01tempoaluguel').AsString;
    pCliente.Empresa := lQuery.FieldByName('mc01empresa').AsString;
    pCliente.fone_empresa := lQuery.FieldByName('mc01foneemp').AsString;
    pCliente.funcao_empresa := lQuery.FieldByName('mc01funcaoemp').AsString;
    pCliente.Admissao := TFunctions.DecodeStrDateForJson(lQuery.FieldByName('mc01admissao').AsString);
    pCliente.Salario := lQuery.FieldByName('mc01salario').AsString;
    pCliente.referencia_comercial := lQuery.FieldByName('mc01refcom').AsString;
    pCliente.referencia_banco := lQuery.FieldByName('mc01refban').AsString;
    pCliente.data_spc := TFunctions.DecodeDateJson(lQuery.FieldByName('mc01dtspc').AsDateTime);
    pCliente.observacao_spc := lQuery.FieldByName('mc01obsspc').AsString;
    pCliente.observacao_geral := lQuery.FieldByName('mc01obsgeral').AsString;
    pCliente.Conjuge := lQuery.FieldByName('mc01conjuge').AsString;
    pCliente.referencia_pessoal := lQuery.FieldByName('mc01refpessoal').AsString;
    pCliente.data_orci := lQuery.FieldByName('mc01dtorci').AsString;
    pCliente.data_movimento := TFunctions.DecodeDateJson(lQuery.FieldByName('mc01dtmov').AsDateTime);
    pCliente.Ultima_Nf := lQuery.FieldByName('mc01ultimanf').AsString;
    pCliente.Valor_Nf := lQuery.FieldByName('mc01valornf').AsFloat;
    pCliente.Tabela_Localizacao := lQuery.FieldByName('mc01tblocal').AsInteger;
    pCliente.Tabela_Extra := lQuery.FieldByName('mc01tbextra').AsInteger;
    pCliente.Local_Cobranca := lQuery.FieldByName('mc01localcob').AsString;
    pCliente.Vendedor := lQuery.FieldByName('mc01rep').AsInteger;
    pCliente.Vip := lQuery.FieldByName('mc01vip').AsString;
    pCliente.validade_vip := TFunctions.DecodeDateJson(lQuery.FieldByName('mc01validvip').AsDateTime);
    pCliente.tabela_convenio := lQuery.FieldByName('mc01_tab_convenio').AsInteger;
    pCliente.tabela_profissao := lQuery.FieldByName('mc01_tab_profissao').AsInteger;
    pCliente.data_cobranca := TFunctions.DecodeDateJson(lQuery.FieldByName('mc01_dt_cobranca').AsDateTime);
    pCliente.quantida_de_cobranca := lQuery.FieldByName('mc01_qtde_cobranca').AsInteger;
    pCliente.Icms := lQuery.FieldByName('mc01_icms').AsFloat;
    pCliente.foto_caminho := lQuery.FieldByName('mc01foto').AsString;
    pCliente.Atacado := lQuery.FieldByName('mc01_atacado').AsString;
    pCliente.limite_desconto := lQuery.FieldByName('mc01_limitedesconto').AsFloat;
    pCliente.mudar_forma_pagamento := lQuery.FieldByName('mc01_mudar_frpgto').AsString;
    pCliente.Divida := lQuery.FieldByName('mc01divida').AsFloat;
    pCliente.saldo_total := lQuery.FieldByName('mc01tol_saldo').AsFloat;
    pCliente.Rota := lQuery.FieldByName('mc01rota').AsString;
    pCliente.ordem_visita := lQuery.FieldByName('mc01ord_vis').AsInteger;
    pCliente.Observacao1 := lQuery.FieldByName('mc01_obs1').AsString;
    pCliente.Observacao2 := lQuery.FieldByName('mc01_obs2').AsString;
    pCliente.super_limite_dias := lQuery.FieldByName('mc01super_limite_dias').AsInteger;
    pCliente.Cartorio := lQuery.FieldByName('mc01_cartorio').AsString;
    pCliente.Serasa := lQuery.FieldByName('mc01_serasa').AsString;
    pCliente.boleto_com_taxa := lQuery.FieldByName('mc01_boleto_com_taxa').AsString;
    pCliente.nome_completo_nfe := lQuery.FieldByName('mc01_nome_completo_nfe').AsString;
    pCliente.observacao_interna := lQuery.FieldByName('mc01obs_interna').AsString;

    pCliente.cidade_ibge.Codigo := lQuery.FieldByName('MC01CODVIP').AsString;
    if (Length(Trim(pCliente.cidade_ibge.Codigo)) > 0) then
    begin
      TCidadeDAO.Carrega(pCliente.cidade_ibge);
    end;

    Result := (lQuery.RecordCount > 0) and (lQuery.FieldByName('MC01NOME').AsString <> EmptyStr);
  finally
    lQuery.free;
  end;

end;

class function TClienteDAO.Excluir(pCodigo: Integer; pCommit : Boolean = true): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try

    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM MC01CLIENTE          ');
    lQuery.SQL.Add('  WHERE MC01CODIGO = :MC01CODIGO ');
    lQuery.ParamByName('MC01CODIGO').AsInteger := pCodigo;
    lQuery.ExecSql;
    lQuery.connection.commit;

  finally
    lQuery.free;
  end;
end;

class function TClienteDAO.Existe(pCodigo: Integer): Boolean;
var
  lQuery: TQuery;
begin
  Result := false;
  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM MC01CLIENTE WHERE MC01CODIGO = :CODIGO');
    lQuery.ParamByName('CODIGO').AsInteger := pCodigo;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := True;
    end;
  finally
    lQuery.free;
  end;
end;

class function TClienteDAO.ExisteCNPJ(pCNPJ: String): Integer;
var
  lQuery: TQuery;
begin
  Result := 0;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM MC01CLIENTE WHERE MC01CGC = :MC01CGC');
    lQuery.ParamByName('MC01CGC').AsString := pCNPJ;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := lQuery.FieldByName('MC01CODIGO').AsInteger;
    end;
  finally
    lQuery.free;
  end;

end;

class function TClienteDAO.ExisteCPF(pCPF: string): Integer;
var
  lQuery: TQuery;
begin
  Result := 0;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM MC01CLIENTE WHERE MC01CPF = :MC01CPF');
    lQuery.ParamByName('MC01CPF').AsString := pCPF;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := lQuery.FieldByName('MC01CODIGO').AsInteger;
    end;
  finally
    lQuery.free;
  end;

end;

class function TClienteDAO.GeraCodigo: Integer;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT MAX(MC01CODIGO) + 1 CODIGO FROM MC01CLIENTE ');
    lQuery.Open;

    Result := lQuery.FieldByName('CODIGO').AsInteger;
  finally
    lQuery.free;
  end;
end;

class function TClienteDAO.Incluir(pCliente: TCliente; pCommit : Boolean = true): Boolean;
var
  lQuery: TQuery;
begin

  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('insert into MC01CLIENTE (      ');
    lQuery.SQL.Add('  MC01CODIGO,                  ');
    lQuery.SQL.Add('  MC01NOME,                    ');
    lQuery.SQL.Add('  MC01FANTASIA,                ');
    lQuery.SQL.Add('  MC01ENDERECO,                ');
    lQuery.SQL.Add('  MC01BAIRRO,                  ');
    lQuery.SQL.Add('  MC01CIDADE,                  ');
    lQuery.SQL.Add('  MC01CEP,                     ');
    lQuery.SQL.Add('  MC01UF,                      ');
    lQuery.SQL.Add('  MC01FONE,                    ');
    lQuery.SQL.Add('  MC01FAX,                     ');
    lQuery.SQL.Add('  MC01CELULAR,                 ');
    lQuery.SQL.Add('  MC01EMAIL,                   ');
    lQuery.SQL.Add('  MC01DTCADASTRO,              ');
    lQuery.SQL.Add('  MC01FISJUR,                  ');
    lQuery.SQL.Add('  MC01ATIINATIVO,              ');
    lQuery.SQL.Add('  MC01DTNASCTO,                ');
    lQuery.SQL.Add('  MC01CPF,                     ');
    lQuery.SQL.Add('  MC01CI,                      ');
    lQuery.SQL.Add('  MC01CGC,                     ');
    lQuery.SQL.Add('  MC01IE,                      ');
    lQuery.SQL.Add('  MC01SEXO,                    ');
    lQuery.SQL.Add('  MC01ESTCIVIL,                ');
    lQuery.SQL.Add('  MC01NATURALIDADE,            ');
    lQuery.SQL.Add('  MC01PAI,                     ');
    lQuery.SQL.Add('  MC01MAE,                     ');
    lQuery.SQL.Add('  MC01ENDCOB,                  ');
    lQuery.SQL.Add('  MC01CIDADECOB,               ');
    lQuery.SQL.Add('  MC01BAIRROCOB,               ');
    lQuery.SQL.Add('  MC01CEPCOB,                  ');
    lQuery.SQL.Add('  MC01UFCOB,                   ');
    lQuery.SQL.Add('  MC01CONTATO,                 ');
    lQuery.SQL.Add('  MC01ALUGUEL,                 ');
    lQuery.SQL.Add('  MC01VALORALUGUEL,            ');
    lQuery.SQL.Add('  MC01TEMPOALUGUEL,            ');
    lQuery.SQL.Add('  MC01EMPRESA,                 ');
    lQuery.SQL.Add('  MC01FONEEMP,                 ');
    lQuery.SQL.Add('  MC01FUNCAOEMP,               ');
    lQuery.SQL.Add('  MC01ADMISSAO,                ');
    lQuery.SQL.Add('  MC01SALARIO,                 ');
    lQuery.SQL.Add('  MC01REFCOM,                  ');
    lQuery.SQL.Add('  MC01REFBAN,                  ');
    lQuery.SQL.Add('  MC01DTSPC,                   ');
    lQuery.SQL.Add('  MC01OBSSPC,                  ');
    lQuery.SQL.Add('  MC01OBSGERAL,                ');
    lQuery.SQL.Add('  MC01SITSPC,                  ');
    lQuery.SQL.Add('  MC01CONJUGE,                 ');
    lQuery.SQL.Add('  MC01REFPESSOAL,              ');
    lQuery.SQL.Add('  MC01DTORCI,                  ');
    lQuery.SQL.Add('  MC01DTMOV,                   ');
    lQuery.SQL.Add('  MC01LIMITECRED,              ');
    lQuery.SQL.Add('  MC01SALDOCRED,               ');
    lQuery.SQL.Add('  MC01ULTIMANF,                ');
    lQuery.SQL.Add('  MC01VALORNF,                 ');
    lQuery.SQL.Add('  MC01TBLOCAL,                 ');
    lQuery.SQL.Add('  MC01TBEXTRA,                 ');
    lQuery.SQL.Add('  MC01LOCALCOB,                ');
    lQuery.SQL.Add('  MC01REP,                     ');
    lQuery.SQL.Add('  MC01TIPOCRED,                ');
    lQuery.SQL.Add('  MC01NRDUPABE,                ');
    lQuery.SQL.Add('  MC01VIP,                     ');
    lQuery.SQL.Add('  MC01CODVIP,                  ');
    lQuery.SQL.Add('  MC01VALIDVIP,                ');
    lQuery.SQL.Add('  MC01_SALARIO_OK,             ');
    lQuery.SQL.Add('  MC01_ENDERECO_OK,            ');
    lQuery.SQL.Add('  MC01_CONVENIO_OK,            ');
    lQuery.SQL.Add('  MC01_TAB_CONVENIO,           ');
    lQuery.SQL.Add('  MC01_TAB_PROFISSAO,          ');
    lQuery.SQL.Add('  MC01_DIA_VCTO,               ');
    lQuery.SQL.Add('  MC01_DT_COBRANCA,            ');
    lQuery.SQL.Add('  MC01_QTDE_COBRANCA,          ');
    lQuery.SQL.Add('  MC01_ICMS,                   ');
    lQuery.SQL.Add('  MC01_SUBST_TRIB,             ');
    lQuery.SQL.Add('  MC01FOTO,                    ');
    lQuery.SQL.Add('  MC01_ATACADO,                ');
    lQuery.SQL.Add('  MC01_LIMITEDESCONTO,         ');
    lQuery.SQL.Add('  MC01_FRPGTO,                 ');
    lQuery.SQL.Add('  MC01_MUDAR_FRPGTO,           ');
    lQuery.SQL.Add('  MC01_PRAZO_DIAS,             ');
    lQuery.SQL.Add('  MC01DIVIDA,                  ');
    lQuery.SQL.Add('  MC01TOL_SALDO,               ');
    lQuery.SQL.Add('  MC01ROTA,                    ');
    lQuery.SQL.Add('  MC01ORD_VIS,                 ');
    lQuery.SQL.Add('  MC01_OBS1,                   ');
    lQuery.SQL.Add('  MC01_OBS2,                   ');
    lQuery.SQL.Add('  MC01SUPER_LIMITE_DIAS,       ');
    lQuery.SQL.Add('  MC01_CARTORIO,               ');
    lQuery.SQL.Add('  MC01_SERASA,                 ');
    lQuery.SQL.Add('  MC01_USU_CADASTRO,           ');
    lQuery.SQL.Add('  MC01_SPED_SN,                ');
    lQuery.SQL.Add('  MC01_PISCOFINS_SN,           ');
    lQuery.SQL.Add('  MC01_NR,                     ');
    lQuery.SQL.Add('  MC01_CONSUMIDOR_FINAL,       ');
    lQuery.SQL.Add('  MC01_INDPRES,                ');
    lQuery.SQL.Add('  MC01_INDIEDEST,              ');
    lQuery.SQL.Add('  MC01_COMPLEMENTO,            ');
    lQuery.SQL.Add('  MC01_BOLETO_COM_TAXA,        ');
    lQuery.SQL.Add('  MC01_NOME_COMPLETO_NFE,      ');
    lQuery.SQL.Add('  MC01OBS_INTERNA              ');
    lQuery.SQL.Add('  ) values (                   ');
    lQuery.SQL.Add('  :MC01CODIGO,                 ');
    lQuery.SQL.Add('  :MC01NOME,                   ');
    lQuery.SQL.Add('  :MC01FANTASIA,               ');
    lQuery.SQL.Add('  :MC01ENDERECO,               ');
    lQuery.SQL.Add('  :MC01BAIRRO,                 ');
    lQuery.SQL.Add('  :MC01CIDADE,                 ');
    lQuery.SQL.Add('  :MC01CEP,                    ');
    lQuery.SQL.Add('  :MC01UF,                     ');
    lQuery.SQL.Add('  :MC01FONE,                   ');
    lQuery.SQL.Add('  :MC01FAX,                    ');
    lQuery.SQL.Add('  :MC01CELULAR,                ');
    lQuery.SQL.Add('  :MC01EMAIL,                  ');
    lQuery.SQL.Add('  :MC01DTCADASTRO,             ');
    lQuery.SQL.Add('  :MC01FISJUR,                 ');
    lQuery.SQL.Add('  :MC01ATIINATIVO,             ');
    lQuery.SQL.Add('  :MC01DTNASCTO,               ');
    lQuery.SQL.Add('  :MC01CPF,                    ');
    lQuery.SQL.Add('  :MC01CI,                     ');
    lQuery.SQL.Add('  :MC01CGC,                    ');
    lQuery.SQL.Add('  :MC01IE,                     ');
    lQuery.SQL.Add('  :MC01SEXO,                   ');
    lQuery.SQL.Add('  :MC01ESTCIVIL,               ');
    lQuery.SQL.Add('  :MC01NATURALIDADE,           ');
    lQuery.SQL.Add('  :MC01PAI,                    ');
    lQuery.SQL.Add('  :MC01MAE,                    ');
    lQuery.SQL.Add('  :MC01ENDCOB,                 ');
    lQuery.SQL.Add('  :MC01CIDADECOB,              ');
    lQuery.SQL.Add('  :MC01BAIRROCOB,              ');
    lQuery.SQL.Add('  :MC01CEPCOB,                 ');
    lQuery.SQL.Add('  :MC01UFCOB,                  ');
    lQuery.SQL.Add('  :MC01CONTATO,                ');
    lQuery.SQL.Add('  :MC01ALUGUEL,                ');
    lQuery.SQL.Add('  :MC01VALORALUGUEL,           ');
    lQuery.SQL.Add('  :MC01TEMPOALUGUEL,           ');
    lQuery.SQL.Add('  :MC01EMPRESA,                ');
    lQuery.SQL.Add('  :MC01FONEEMP,                ');
    lQuery.SQL.Add('  :MC01FUNCAOEMP,              ');
    lQuery.SQL.Add('  :MC01ADMISSAO,               ');
    lQuery.SQL.Add('  :MC01SALARIO,                ');
    lQuery.SQL.Add('  :MC01REFCOM,                 ');
    lQuery.SQL.Add('  :MC01REFBAN,                 ');
    lQuery.SQL.Add('  :MC01DTSPC,                  ');
    lQuery.SQL.Add('  :MC01OBSSPC,                 ');
    lQuery.SQL.Add('  :MC01OBSGERAL,               ');
    lQuery.SQL.Add('  :MC01SITSPC,                 ');
    lQuery.SQL.Add('  :MC01CONJUGE,                ');
    lQuery.SQL.Add('  :MC01REFPESSOAL,             ');
    lQuery.SQL.Add('  :MC01DTORCI,                 ');
    lQuery.SQL.Add('  :MC01DTMOV,                  ');
    lQuery.SQL.Add('  :MC01LIMITECRED,             ');
    lQuery.SQL.Add('  :MC01SALDOCRED,              ');
    lQuery.SQL.Add('  :MC01ULTIMANF,               ');
    lQuery.SQL.Add('  :MC01VALORNF,                ');
    lQuery.SQL.Add('  :MC01TBLOCAL,                ');
    lQuery.SQL.Add('  :MC01TBEXTRA,                ');
    lQuery.SQL.Add('  :MC01LOCALCOB,               ');
    lQuery.SQL.Add('  :MC01REP,                    ');
    lQuery.SQL.Add('  :MC01TIPOCRED,               ');
    lQuery.SQL.Add('  :MC01NRDUPABE,               ');
    lQuery.SQL.Add('  :MC01VIP,                    ');
    lQuery.SQL.Add('  :MC01CODVIP,                 ');
    lQuery.SQL.Add('  :MC01VALIDVIP,               ');
    lQuery.SQL.Add('  :MC01_SALARIO_OK,            ');
    lQuery.SQL.Add('  :MC01_ENDERECO_OK,           ');
    lQuery.SQL.Add('  :MC01_CONVENIO_OK,           ');
    lQuery.SQL.Add('  :MC01_TAB_CONVENIO,          ');
    lQuery.SQL.Add('  :MC01_TAB_PROFISSAO,         ');
    lQuery.SQL.Add('  :MC01_DIA_VCTO,              ');
    lQuery.SQL.Add('  :MC01_DT_COBRANCA,           ');
    lQuery.SQL.Add('  :MC01_QTDE_COBRANCA,         ');
    lQuery.SQL.Add('  :MC01_ICMS,                  ');
    lQuery.SQL.Add('  :MC01_SUBST_TRIB,            ');
    lQuery.SQL.Add('  :MC01FOTO,                   ');
    lQuery.SQL.Add('  :MC01_ATACADO,               ');
    lQuery.SQL.Add('  :MC01_LIMITEDESCONTO,        ');
    lQuery.SQL.Add('  :MC01_FRPGTO,                ');
    lQuery.SQL.Add('  :MC01_MUDAR_FRPGTO,          ');
    lQuery.SQL.Add('  :MC01_PRAZO_DIAS,            ');
    lQuery.SQL.Add('  :MC01DIVIDA,                 ');
    lQuery.SQL.Add('  :MC01TOL_SALDO,              ');
    lQuery.SQL.Add('  :MC01ROTA,                   ');
    lQuery.SQL.Add('  :MC01ORD_VIS,                ');
    lQuery.SQL.Add('  :MC01_OBS1,                  ');
    lQuery.SQL.Add('  :MC01_OBS2,                  ');
    lQuery.SQL.Add('  :MC01SUPER_LIMITE_DIAS,      ');
    lQuery.SQL.Add('  :MC01_CARTORIO,              ');
    lQuery.SQL.Add('  :MC01_SERASA,                ');
    lQuery.SQL.Add('  :MC01_USU_CADASTRO,          ');
    lQuery.SQL.Add('  :MC01_SPED_SN,               ');
    lQuery.SQL.Add('  :MC01_PISCOFINS_SN,          ');
    lQuery.SQL.Add('  :MC01_NR,                    ');
    lQuery.SQL.Add('  :MC01_CONSUMIDOR_FINAL,      ');
    lQuery.SQL.Add('  :MC01_INDPRES,               ');
    lQuery.SQL.Add('  :MC01_INDIEDEST,             ');
    lQuery.SQL.Add('  :MC01_COMPLEMENTO,           ');
    lQuery.SQL.Add('  :MC01_BOLETO_COM_TAXA,       ');
    lQuery.SQL.Add('  :MC01_NOME_COMPLETO_NFE,     ');
    lQuery.SQL.Add('  :MC01OBS_INTERNA             ');
    lQuery.SQL.Add('        );                     ');
    lQuery.ParamByName('MC01CODIGO').AsInteger := pCliente.Codigo;
    lQuery.ParamByName('MC01NOME').AsString := Copy(pCliente.Nome, 1, 35);
    lQuery.ParamByName('MC01FANTASIA').AsString := Copy(pCliente.Matricula, 1, 35);
    lQuery.ParamByName('MC01ENDERECO').AsString := Copy(pCliente.Endereco, 1, 35);
    lQuery.ParamByName('MC01BAIRRO').AsString := Copy(pCliente.Bairro, 1, 20);
    lQuery.ParamByName('MC01CIDADE').AsString := Copy(pCliente.Cidade, 1, 30);
    lQuery.ParamByName('MC01CEP').AsString := Copy(pCliente.Cep, 1, 10);
    lQuery.ParamByName('MC01UF').AsString := Copy(pCliente.Uf, 1, 2);
    lQuery.ParamByName('MC01FONE').AsString := Copy(pCliente.Fone, 1, 15);
    lQuery.ParamByName('MC01FAX').AsString := Copy(pCliente.Fax, 1, 15);
    lQuery.ParamByName('MC01CELULAR').AsString := Copy(pCliente.Celular, 1, 15);
    lQuery.ParamByName('MC01EMAIL').AsString := Copy(pCliente.Email, 1, 50);
    lQuery.ParamByName('MC01DTCADASTRO').AsDateTime := StrToDateTimedef(pCliente.data_cadastro, now);
    lQuery.ParamByName('MC01FISJUR').AsString := TFunctions.GetSn(pCliente.pessoa_fisica);
    lQuery.ParamByName('MC01ATIINATIVO').AsString := TFunctions.GetSn(pCliente.Ativo);
    lQuery.ParamByName('MC01DTNASCTO').AsDate := StrToDatedef(pCliente.data_nascimento, now);
    lQuery.ParamByName('MC01CPF').AsString := Copy(pCliente.CPF, 1, 11);
    lQuery.ParamByName('MC01CI').AsString := Copy(pCliente.Rg, 1, 10);
    lQuery.ParamByName('MC01CGC').AsString := Copy(pCliente.CNPJ, 1, 14);
    lQuery.ParamByName('MC01IE').AsString := Copy(pCliente.Ie, 1, 20);
    lQuery.ParamByName('MC01SEXO').AsString := Copy(pCliente.Sexo, 1, 1);
    lQuery.ParamByName('MC01ESTCIVIL').AsString := Copy(pCliente.estado_civil, 1, 1);
    lQuery.ParamByName('MC01NATURALIDADE').AsString := Copy(pCliente.Naturalidade, 1, 30);
    lQuery.ParamByName('MC01PAI').AsString := Copy(pCliente.Pai, 1, 35);
    lQuery.ParamByName('MC01MAE').AsString := Copy(pCliente.Mae, 1, 35);
    lQuery.ParamByName('MC01ENDCOB').AsString := Copy(pCliente.endereco_cobranca, 1, 35);
    lQuery.ParamByName('MC01CIDADECOB').AsString := Copy(pCliente.cidade_cobranca, 1, 30);
    lQuery.ParamByName('MC01BAIRROCOB').AsString := Copy(pCliente.bairro_cobranca, 1, 20);
    lQuery.ParamByName('MC01CEPCOB').AsString := Copy(pCliente.cep_cobranca, 1, 10);
    lQuery.ParamByName('MC01UFCOB').AsString := Copy(pCliente.uf_cobranca, 1, 2);
    lQuery.ParamByName('MC01CONTATO').AsString := Copy(pCliente.Contato, 1, 50);
    lQuery.ParamByName('MC01ALUGUEL').AsString := Copy(pCliente.Aluguel, 1, 1);
    lQuery.ParamByName('MC01VALORALUGUEL').AsFloat := pCliente.valor_aluguel;
    lQuery.ParamByName('MC01TEMPOALUGUEL').AsString := Copy(pCliente.tempo_aluguel, 1, 25);
    lQuery.ParamByName('MC01EMPRESA').AsString := Copy(pCliente.Empresa, 1, 35);
    lQuery.ParamByName('MC01FONEEMP').AsString := Copy(pCliente.fone_empresa, 1, 15);
    lQuery.ParamByName('MC01FUNCAOEMP').AsString := Copy(pCliente.funcao_empresa, 1, 15);
    lQuery.ParamByName('MC01ADMISSAO').AsString := pCliente.Admissao; // data em string?
    lQuery.ParamByName('MC01SALARIO').AsString := Copy(pCliente.Salario, 1, 25);
    lQuery.ParamByName('MC01REFCOM').AsString := Copy(pCliente.referencia_comercial, 1, 100);
    lQuery.ParamByName('MC01REFBAN').AsString := Copy(pCliente.referencia_banco, 1, 100);
    lQuery.ParamByName('MC01DTSPC').AsDate := StrToDatedef(pCliente.data_spc, now);
    lQuery.ParamByName('MC01OBSSPC').AsString := Copy(pCliente.observacao_spc, 1, 100);
    lQuery.ParamByName('MC01OBSGERAL').AsString := pCliente.observacao_geral; // blob
    lQuery.ParamByName('MC01SITSPC').AsString := TFunctions.GetSn(pCliente.ativo_no_spc);
    lQuery.ParamByName('MC01CONJUGE').AsString := Copy(pCliente.Conjuge, 1, 50);
    lQuery.ParamByName('MC01REFPESSOAL').AsString := Copy(pCliente.referencia_pessoal, 1, 50);
    lQuery.ParamByName('MC01DTORCI').AsString := Copy(pCliente.data_orci, 1, 25);
    lQuery.ParamByName('MC01DTMOV').AsDate := StrToDatedef(pCliente.data_movimento, now);
    lQuery.ParamByName('MC01LIMITECRED').AsFloat := pCliente.valor_limite_do_cliente;
    lQuery.ParamByName('MC01SALDOCRED').AsFloat := pCliente.saldo_credito;
    lQuery.ParamByName('MC01ULTIMANF').AsString := Copy(pCliente.Ultima_Nf, 1, 10);
    lQuery.ParamByName('MC01VALORNF').AsFloat := pCliente.Valor_Nf;
    lQuery.ParamByName('MC01TBLOCAL').AsInteger := pCliente.Tabela_Localizacao;
    lQuery.ParamByName('MC01TBEXTRA').AsInteger := pCliente.Tabela_Extra;
    lQuery.ParamByName('MC01LOCALCOB').AsString := Copy(pCliente.Local_Cobranca, 1, 3);
    lQuery.ParamByName('MC01REP').AsInteger := pCliente.Vendedor;
    lQuery.ParamByName('MC01TIPOCRED').AsString := Copy(pCliente.Tipo_De_Credito, 1, 1);
    lQuery.ParamByName('MC01NRDUPABE').AsInteger := pCliente.numero_duplicatas_abertas;
    lQuery.ParamByName('MC01VIP').AsString := Copy(pCliente.Vip, 1, 1);
    lQuery.ParamByName('MC01CODVIP').AsString := Copy(pCliente.cidade_ibge.Codigo, 1, 14);
    lQuery.ParamByName('MC01VALIDVIP').AsDate := StrToDatedef(pCliente.validade_vip, now);
    lQuery.ParamByName('MC01_SALARIO_OK').AsString := TFunctions.GetSn(pCliente.salario_ok);
    lQuery.ParamByName('MC01_ENDERECO_OK').AsString := TFunctions.GetSn(pCliente.endereco_ok);
    lQuery.ParamByName('MC01_CONVENIO_OK').AsString := TFunctions.GetSn(pCliente.convenio_ok);
    lQuery.ParamByName('MC01_TAB_CONVENIO').AsInteger := pCliente.tabela_convenio;
    lQuery.ParamByName('MC01_TAB_PROFISSAO').AsInteger := pCliente.tabela_profissao;
    lQuery.ParamByName('MC01_DIA_VCTO').AsInteger := pCliente.dia_fixo_de_vencimento;
    lQuery.ParamByName('MC01_DT_COBRANCA').AsDate := StrToDatedef(pCliente.data_cobranca, now);
    lQuery.ParamByName('MC01_QTDE_COBRANCA').AsInteger := pCliente.quantida_de_cobranca;
    lQuery.ParamByName('MC01_ICMS').AsFloat := pCliente.Icms;
    lQuery.ParamByName('MC01_SUBST_TRIB').AsString := TFunctions.GetSn(pCliente.substituicao_tributaria);
    lQuery.ParamByName('MC01FOTO').AsString := Copy(pCliente.foto_caminho, 1, 45);
    lQuery.ParamByName('MC01_ATACADO').AsString := Copy(pCliente.Atacado, 1, 1);
    lQuery.ParamByName('MC01_LIMITEDESCONTO').AsFloat := pCliente.limite_desconto;
    lQuery.ParamByName('MC01_FRPGTO').AsInteger := pCliente.forma_de_pagamento_padrao;
    lQuery.ParamByName('MC01_MUDAR_FRPGTO').AsString := Copy(pCliente.mudar_forma_pagamento, 1, 1);
    lQuery.ParamByName('MC01_PRAZO_DIAS').AsInteger := pCliente.prazo_maximo_em_dias;
    lQuery.ParamByName('MC01DIVIDA').AsFloat := pCliente.Divida;
    lQuery.ParamByName('MC01TOL_SALDO').AsFloat := pCliente.saldo_total;
    lQuery.ParamByName('MC01ROTA').AsString := Copy(pCliente.Rota, 1, 4);
    lQuery.ParamByName('MC01ORD_VIS').AsInteger := pCliente.ordem_visita;
    lQuery.ParamByName('MC01_OBS1').AsString := Copy(pCliente.Observacao1, 1, 75);
    lQuery.ParamByName('MC01_OBS2').AsString := Copy(pCliente.Observacao2, 1, 75);
    lQuery.ParamByName('MC01SUPER_LIMITE_DIAS').AsInteger := pCliente.super_limite_dias;
    lQuery.ParamByName('MC01_CARTORIO').AsString := Copy(pCliente.Cartorio, 1, 1);
    lQuery.ParamByName('MC01_SERASA').AsString := Copy(pCliente.Serasa, 1, 1);
    lQuery.ParamByName('MC01_USU_CADASTRO').AsInteger := pCliente.usuario_cadastro;
    lQuery.ParamByName('MC01_SPED_SN').AsString := TFunctions.GetSn(pCliente.Sped);
    lQuery.ParamByName('MC01_PISCOFINS_SN').AsString := TFunctions.GetSn(pCliente.Pis_Cofins);
    lQuery.ParamByName('MC01_NR').AsString := Copy(pCliente.Numero, 1, 15);
    lQuery.ParamByName('MC01_CONSUMIDOR_FINAL').AsString := Copy(pCliente.consumidor_final, 1, 1);
    lQuery.ParamByName('MC01_INDPRES').AsString := Copy(pCliente.indicador_presenca_comprador, 1, 1);
    lQuery.ParamByName('MC01_INDIEDEST').AsString := Copy(pCliente.indicador_destinatario, 1, 1);
    lQuery.ParamByName('MC01_COMPLEMENTO').AsString := Copy(pCliente.Complemento, 1, 50);
    lQuery.ParamByName('MC01_BOLETO_COM_TAXA').AsString := Copy(pCliente.boleto_com_taxa, 1, 1);
    lQuery.ParamByName('MC01_NOME_COMPLETO_NFE').AsString := Copy(pCliente.nome_completo_nfe, 1, 60);
    lQuery.ParamByName('MC01OBS_INTERNA').AsString := pCliente.observacao_interna; // blob
    lQuery.ExecSql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;
end;

class function TClienteDAO.Limpar(pCliente: TCliente): Boolean;
begin
  pCliente.Codigo := 0;
  pCliente.Nome := '';
  pCliente.forma_de_pagamento_padrao := 0;
  pCliente.Tipo_De_Credito := '';
  pCliente.Ativo := false;
  pCliente.prazo_maximo_em_dias := 0;
  pCliente.pessoa_fisica := false;
  pCliente.saldo_calculado := 0;
  pCliente.CPF := '';
  pCliente.CNPJ := '';
  pCliente.ativo_no_spc := false;
  pCliente.valor_limite_do_cliente := 0;
  pCliente.dia_fixo_de_vencimento := 0;
  pCliente.Ie := '';
  pCliente.Fone := '';
  pCliente.Email := '';
  pCliente.Bairro := '';
  pCliente.Fax := '';
  pCliente.Uf := '';
  pCliente.Cep := '';
  pCliente.Numero := '';
  pCliente.Complemento := '';
  pCliente.data_cadastro := '';
  pCliente.Matricula := '';
  pCliente.Cidade := '';
  pCliente.Endereco := '';
  pCliente.Celular := '';
  pCliente.endereco_ok := false;
  pCliente.convenio_ok := false;
  pCliente.substituicao_tributaria := false;
  pCliente.salario_ok := false;
  pCliente.Pis_Cofins := false;
  pCliente.Sped := false;
  pCliente.usuario_alteracao := 0;
  pCliente.usuario_cadastro := 0;
  pCliente.indicador_destinatario := '';
  pCliente.consumidor_final := '';
  pCliente.indicador_presenca_comprador := '';
  pCliente.data_alteracao := '';
  pCliente.saldo_credito := 0;
  pCliente.numero_duplicatas_abertas := 0;
  pCliente.data_nascimento := '';
  pCliente.Rg := '';
  pCliente.Sexo := '';
  pCliente.estado_civil := '';
  pCliente.Naturalidade := '';
  pCliente.Pai := '';
  pCliente.Mae := '';
  pCliente.endereco_cobranca := '';
  pCliente.cidade_cobranca := '';
  pCliente.bairro_cobranca := '';
  pCliente.cep_cobranca := '';
  pCliente.uf_cobranca := '';
  pCliente.Contato := '';
  pCliente.Aluguel := '';
  pCliente.valor_aluguel := 0;
  pCliente.tempo_aluguel := '';
  pCliente.Empresa := '';
  pCliente.fone_empresa := '';
  pCliente.funcao_empresa := '';
  pCliente.Admissao := '';
  pCliente.Salario := '';
  pCliente.referencia_comercial := '';
  pCliente.referencia_banco := '';
  pCliente.data_spc := '';
  pCliente.observacao_spc := '';
  pCliente.observacao_geral := '';
  pCliente.Conjuge := '';
  pCliente.referencia_pessoal := '';
  pCliente.data_orci := '';
  pCliente.data_movimento := '';
  pCliente.Ultima_Nf := '';
  pCliente.Valor_Nf := 0;
  pCliente.Tabela_Localizacao := 0;
  pCliente.Tabela_Extra := 0;
  pCliente.Local_Cobranca := '';
  pCliente.Vendedor := 0;
  pCliente.Vip := '';
  pCliente.validade_vip := '';
  pCliente.tabela_convenio := 0;
  pCliente.tabela_profissao := 0;
  pCliente.data_cobranca := '';
  pCliente.quantida_de_cobranca := 0;
  pCliente.Icms := 0;
  pCliente.foto_caminho := '';
  pCliente.Atacado := '';
  pCliente.limite_desconto := 0;
  pCliente.mudar_forma_pagamento := '';
  pCliente.Divida := 0;
  pCliente.saldo_total := 0;
  pCliente.Rota := '';
  pCliente.ordem_visita := 0;
  pCliente.Observacao1 := '';
  pCliente.Observacao2 := '';
  pCliente.super_limite_dias := 0;
  pCliente.Cartorio := '';
  pCliente.Serasa := '';
  pCliente.boleto_com_taxa := '';
  pCliente.nome_completo_nfe := '';
  pCliente.observacao_interna := '';
end;

end.
