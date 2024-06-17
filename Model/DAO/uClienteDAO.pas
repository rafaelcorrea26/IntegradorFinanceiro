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
    lQuery.SQL.Add('update CLIENTE set                             ');
    lQuery.SQL.Add('  NOME               =:NOME,               ');
    lQuery.SQL.Add('  FANTASIA           =:FANTASIA,           ');
    lQuery.SQL.Add('  ENDERECO           =:ENDERECO,           ');
    lQuery.SQL.Add('  BAIRRO             =:BAIRRO,             ');
    lQuery.SQL.Add('  CIDADE             =:CIDADE,             ');
    lQuery.SQL.Add('  CEP                =:CEP,                ');
    lQuery.SQL.Add('  UF                 =:UF,                 ');
    lQuery.SQL.Add('  FONE               =:FONE,               ');
    lQuery.SQL.Add('  FAX                =:FAX,                ');
    lQuery.SQL.Add('  CELULAR            =:CELULAR,            ');
    lQuery.SQL.Add('  EMAIL              =:EMAIL,              ');
    lQuery.SQL.Add('  DTCADASTRO         =:DTCADASTRO,         ');
    lQuery.SQL.Add('  FISJUR             =:FISJUR,             ');
    lQuery.SQL.Add('  ATIINATIVO         =:ATIINATIVO,         ');
    lQuery.SQL.Add('  DTNASCTO           =:DTNASCTO,           ');
    lQuery.SQL.Add('  CPF                =:CPF,                ');
    lQuery.SQL.Add('  CI                 =:CI,                 ');
    lQuery.SQL.Add('  CGC                =:CGC,                ');
    lQuery.SQL.Add('  IE                 =:IE,                 ');
    lQuery.SQL.Add('  SEXO               =:SEXO,               ');
    lQuery.SQL.Add('  ESTCIVIL           =:ESTCIVIL,           ');
    lQuery.SQL.Add('  NATURALIDADE       =:NATURALIDADE,       ');
    lQuery.SQL.Add('  PAI                =:PAI,                ');
    lQuery.SQL.Add('  MAE                =:MAE,                ');
    lQuery.SQL.Add('  ENDCOB             =:ENDCOB,             ');
    lQuery.SQL.Add('  CIDADECOB          =:CIDADECOB,          ');
    lQuery.SQL.Add('  BAIRROCOB          =:BAIRROCOB,          ');
    lQuery.SQL.Add('  CEPCOB             =:CEPCOB,             ');
    lQuery.SQL.Add('  UFCOB              =:UFCOB,              ');
    lQuery.SQL.Add('  CONTATO            =:CONTATO,            ');
    lQuery.SQL.Add('  ALUGUEL            =:ALUGUEL,            ');
    lQuery.SQL.Add('  VALORALUGUEL       =:VALORALUGUEL,       ');
    lQuery.SQL.Add('  TEMPOALUGUEL       =:TEMPOALUGUEL,       ');
    lQuery.SQL.Add('  EMPRESA            =:EMPRESA,            ');
    lQuery.SQL.Add('  FONEEMP            =:FONEEMP,            ');
    lQuery.SQL.Add('  FUNCAOEMP          =:FUNCAOEMP,          ');
    lQuery.SQL.Add('  ADMISSAO           =:ADMISSAO,           ');
    lQuery.SQL.Add('  SALARIO            =:SALARIO,            ');
    lQuery.SQL.Add('  REFCOM             =:REFCOM,             ');
    lQuery.SQL.Add('  REFBAN             =:REFBAN,             ');
    lQuery.SQL.Add('  DTSPC              =:DTSPC,              ');
    lQuery.SQL.Add('  OBSSPC             =:OBSSPC,             ');
    lQuery.SQL.Add('  OBSGERAL           =:OBSGERAL,           ');
    lQuery.SQL.Add('  SITSPC             =:SITSPC,             ');
    lQuery.SQL.Add('  CONJUGE            =:CONJUGE,            ');
    lQuery.SQL.Add('  REFPESSOAL         =:REFPESSOAL,         ');
    lQuery.SQL.Add('  DTORCI             =:DTORCI,             ');
    lQuery.SQL.Add('  DTMOV              =:DTMOV,              ');
    lQuery.SQL.Add('  LIMITECRED         =:LIMITECRED,         ');
    lQuery.SQL.Add('  SALDOCRED          =:SALDOCRED,          ');
    lQuery.SQL.Add('  ULTIMANF           =:ULTIMANF,           ');
    lQuery.SQL.Add('  VALORNF            =:VALORNF,            ');
    lQuery.SQL.Add('  TBLOCAL            =:TBLOCAL,            ');
    lQuery.SQL.Add('  TBEXTRA            =:TBEXTRA,            ');
    lQuery.SQL.Add('  LOCALCOB           =:LOCALCOB,           ');
    lQuery.SQL.Add('  REP                =:REP,                ');
    lQuery.SQL.Add('  TIPOCRED           =:TIPOCRED,           ');
    lQuery.SQL.Add('  NRDUPABE           =:NRDUPABE,           ');
    lQuery.SQL.Add('  VIP                =:VIP,                ');
    lQuery.SQL.Add('  CODVIP             =:CODVIP,             ');
    lQuery.SQL.Add('  VALIDVIP           =:VALIDVIP,           ');
    lQuery.SQL.Add('  DT_ALTERACAO      =:DT_ALTERACAO,      ');
    lQuery.SQL.Add('  SALARIO_OK        =:SALARIO_OK,        ');
    lQuery.SQL.Add('  ENDERECO_OK       =:ENDERECO_OK,       ');
    lQuery.SQL.Add('  CONVENIO_OK       =:CONVENIO_OK,       ');
    lQuery.SQL.Add('  TAB_CONVENIO      =:TAB_CONVENIO,      ');
    lQuery.SQL.Add('  TAB_PROFISSAO     =:TAB_PROFISSAO,     ');
    lQuery.SQL.Add('  DIA_VCTO          =:DIA_VCTO,          ');
    lQuery.SQL.Add('  DT_COBRANCA       =:DT_COBRANCA,       ');
    lQuery.SQL.Add('  QTDE_COBRANCA     =:QTDE_COBRANCA,     ');
    lQuery.SQL.Add('  ICMS              =:ICMS,              ');
    lQuery.SQL.Add('  SUBST_TRIB        =:SUBST_TRIB,        ');
    lQuery.SQL.Add('  FOTO               =:FOTO,               ');
    lQuery.SQL.Add('  ATACADO           =:ATACADO,           ');
    lQuery.SQL.Add('  LIMITEDESCONTO    =:LIMITEDESCONTO,    ');
    lQuery.SQL.Add('  FRPGTO            =:FRPGTO,            ');
    lQuery.SQL.Add('  MUDAR_FRPGTO      =:MUDAR_FRPGTO,      ');
    lQuery.SQL.Add('  PRAZO_DIAS        =:PRAZO_DIAS,        ');
    lQuery.SQL.Add('  DIVIDA             =:DIVIDA,             ');
    lQuery.SQL.Add('  TOL_SALDO          =:TOL_SALDO,          ');
    lQuery.SQL.Add('  ROTA               =:ROTA,               ');
    lQuery.SQL.Add('  ORD_VIS            =:ORD_VIS,            ');
    lQuery.SQL.Add('  OBS1              =:OBS1,              ');
    lQuery.SQL.Add('  OBS2              =:OBS2,              ');
    lQuery.SQL.Add('  SUPER_LIMITE_DIAS  =:SUPER_LIMITE_DIAS,  ');
    lQuery.SQL.Add('  CARTORIO          =:CARTORIO,          ');
    lQuery.SQL.Add('  SERASA            =:SERASA,            ');
    lQuery.SQL.Add('  USU_ALTERACAO     =:USU_ALTERACAO,     ');
    lQuery.SQL.Add('  USU_CADASTRO      =:USU_CADASTRO,      ');
    lQuery.SQL.Add('  SPED_SN           =:SPED_SN,           ');
    lQuery.SQL.Add('  PISCOFINS_SN      =:PISCOFINS_SN,      ');
    lQuery.SQL.Add('  NR                =:NR,                ');
    lQuery.SQL.Add('  CONSUMIDOR_FINAL  =:CONSUMIDOR_FINAL,  ');
    lQuery.SQL.Add('  INDPRES           =:INDPRES,           ');
    lQuery.SQL.Add('  INDIEDEST         =:INDIEDEST,         ');
    lQuery.SQL.Add('  COMPLEMENTO       =:COMPLEMENTO,       ');
    lQuery.SQL.Add('  BOLETO_COM_TAXA   =:BOLETO_COM_TAXA,   ');
    lQuery.SQL.Add('  NOME_COMPLETO_NFE =:NOME_COMPLETO_NFE, ');
    lQuery.SQL.Add('  OBS_INTERNA        =:OBS_INTERNA         ');
    lQuery.SQL.Add('WHERE CODIGO         =:CODIGO              ');

    lQuery.ParamByName('CODIGO').AsInteger := pCliente.Codigo;
    lQuery.ParamByName('NOME').AsString := Copy(pCliente.Nome, 1, 35);
    lQuery.ParamByName('FANTASIA').AsString := Copy(pCliente.Matricula, 1, 35);
    lQuery.ParamByName('ENDERECO').AsString := Copy(pCliente.Endereco, 1, 35);
    lQuery.ParamByName('BAIRRO').AsString := Copy(pCliente.Bairro, 1, 20);
    lQuery.ParamByName('CIDADE').AsString := Copy(pCliente.Cidade, 1, 30);
    lQuery.ParamByName('CEP').AsString := Copy(pCliente.Cep, 1, 10);
    lQuery.ParamByName('UF').AsString := Copy(pCliente.Uf, 1, 2);
    lQuery.ParamByName('FONE').AsString := Copy(pCliente.Fone, 1, 15);
    lQuery.ParamByName('FAX').AsString := Copy(pCliente.Fax, 1, 15);
    lQuery.ParamByName('CELULAR').AsString := Copy(pCliente.Celular, 1, 15);
    lQuery.ParamByName('EMAIL').AsString := Copy(pCliente.Email, 1, 50);
    lQuery.ParamByName('DTCADASTRO').AsDateTime := StrToDateTimedef(pCliente.data_cadastro, now);
    lQuery.ParamByName('FISJUR').AsString := TFunctions.GetSn(pCliente.pessoa_fisica);
    lQuery.ParamByName('ATIINATIVO').AsString := TFunctions.GetSn(pCliente.Ativo);
    lQuery.ParamByName('DTNASCTO').AsDate := StrToDatedef(pCliente.data_nascimento, now);
    lQuery.ParamByName('CPF').AsString := Copy(pCliente.CPF, 1, 11);
    lQuery.ParamByName('CI').AsString := Copy(pCliente.Rg, 1, 10);
    lQuery.ParamByName('CGC').AsString := Copy(pCliente.CNPJ, 1, 14);
    lQuery.ParamByName('IE').AsString := Copy(pCliente.Ie, 1, 20);
    lQuery.ParamByName('SEXO').AsString := Copy(pCliente.Sexo, 1, 1);
    lQuery.ParamByName('ESTCIVIL').AsString := Copy(pCliente.estado_civil, 1, 1);
    lQuery.ParamByName('NATURALIDADE').AsString := Copy(pCliente.Naturalidade, 1, 30);
    lQuery.ParamByName('PAI').AsString := Copy(pCliente.Pai, 1, 35);
    lQuery.ParamByName('MAE').AsString := Copy(pCliente.Mae, 1, 35);
    lQuery.ParamByName('ENDCOB').AsString := Copy(pCliente.endereco_cobranca, 1, 35);
    lQuery.ParamByName('CIDADECOB').AsString := Copy(pCliente.cidade_cobranca, 1, 30);
    lQuery.ParamByName('BAIRROCOB').AsString := Copy(pCliente.bairro_cobranca, 1, 20);
    lQuery.ParamByName('CEPCOB').AsString := Copy(pCliente.cep_cobranca, 1, 10);
    lQuery.ParamByName('UFCOB').AsString := Copy(pCliente.uf_cobranca, 1, 2);
    lQuery.ParamByName('CONTATO').AsString := Copy(pCliente.Contato, 1, 50);
    lQuery.ParamByName('ALUGUEL').AsString := Copy(pCliente.Aluguel, 1, 1);
    lQuery.ParamByName('VALORALUGUEL').AsFloat := pCliente.valor_aluguel;
    lQuery.ParamByName('TEMPOALUGUEL').AsString := Copy(pCliente.tempo_aluguel, 1, 25);
    lQuery.ParamByName('EMPRESA').AsString := Copy(pCliente.Empresa, 1, 35);
    lQuery.ParamByName('FONEEMP').AsString := Copy(pCliente.fone_empresa, 1, 15);
    lQuery.ParamByName('FUNCAOEMP').AsString := Copy(pCliente.funcao_empresa, 1, 15);
    lQuery.ParamByName('ADMISSAO').AsString := pCliente.Admissao; // data em string?
    lQuery.ParamByName('SALARIO').AsString := Copy(pCliente.Salario, 1, 25);
    lQuery.ParamByName('REFCOM').AsString := Copy(pCliente.referencia_comercial, 1, 100);
    lQuery.ParamByName('REFBAN').AsString := Copy(pCliente.referencia_banco, 1, 100);
    lQuery.ParamByName('DTSPC').AsDate := StrToDatedef(pCliente.data_spc, now);
    lQuery.ParamByName('OBSSPC').AsString := Copy(pCliente.observacao_spc, 1, 100);
    lQuery.ParamByName('OBSGERAL').AsString := pCliente.observacao_geral; // blob
    lQuery.ParamByName('SITSPC').AsString := TFunctions.GetSn(pCliente.ativo_no_spc);
    lQuery.ParamByName('CONJUGE').AsString := Copy(pCliente.Conjuge, 1, 50);
    lQuery.ParamByName('REFPESSOAL').AsString := Copy(pCliente.referencia_pessoal, 1, 50);
    lQuery.ParamByName('DTORCI').AsString := Copy(pCliente.data_orci, 1, 25);
    lQuery.ParamByName('DTMOV').AsDate := StrToDatedef(pCliente.data_movimento, now);
    lQuery.ParamByName('LIMITECRED').AsFloat := pCliente.valor_limite_do_cliente;
    lQuery.ParamByName('SALDOCRED').AsFloat := pCliente.saldo_credito;
    lQuery.ParamByName('ULTIMANF').AsString := Copy(pCliente.Ultima_Nf, 1, 10);
    lQuery.ParamByName('VALORNF').AsFloat := pCliente.Valor_Nf;
    lQuery.ParamByName('TBLOCAL').AsInteger := pCliente.Tabela_Localizacao;
    lQuery.ParamByName('TBEXTRA').AsInteger := pCliente.Tabela_Extra;
    lQuery.ParamByName('LOCALCOB').AsString := Copy(pCliente.Local_Cobranca, 1, 3);
    lQuery.ParamByName('REP').AsInteger := pCliente.Vendedor;
    lQuery.ParamByName('TIPOCRED').AsString := Copy(pCliente.Tipo_De_Credito, 1, 1);
    lQuery.ParamByName('NRDUPABE').AsInteger := pCliente.numero_duplicatas_abertas;
    lQuery.ParamByName('VIP').AsString := Copy(pCliente.Vip, 1, 1);
    lQuery.ParamByName('CODVIP').AsString := Copy(pCliente.cidade_ibge.Codigo, 1, 14);
    lQuery.ParamByName('VALIDVIP').AsDate := StrToDatedef(pCliente.validade_vip, now);
    lQuery.ParamByName('SALARIO_OK').AsString := TFunctions.GetSn(pCliente.salario_ok);
    lQuery.ParamByName('ENDERECO_OK').AsString := TFunctions.GetSn(pCliente.endereco_ok);
    lQuery.ParamByName('CONVENIO_OK').AsString := TFunctions.GetSn(pCliente.convenio_ok);
    lQuery.ParamByName('TAB_CONVENIO').AsInteger := pCliente.tabela_convenio;
    lQuery.ParamByName('TAB_PROFISSAO').AsInteger := pCliente.tabela_profissao;
    lQuery.ParamByName('DIA_VCTO').AsInteger := pCliente.dia_fixo_de_vencimento;
    lQuery.ParamByName('DT_COBRANCA').AsDate := StrToDatedef(pCliente.data_cobranca, now);
    lQuery.ParamByName('QTDE_COBRANCA').AsInteger := pCliente.quantida_de_cobranca;
    lQuery.ParamByName('ICMS').AsFloat := pCliente.Icms;
    lQuery.ParamByName('SUBST_TRIB').AsString := TFunctions.GetSn(pCliente.substituicao_tributaria);
    lQuery.ParamByName('FOTO').AsString := Copy(pCliente.foto_caminho, 1, 45);
    lQuery.ParamByName('ATACADO').AsString := Copy(pCliente.Atacado, 1, 1);
    lQuery.ParamByName('LIMITEDESCONTO').AsFloat := pCliente.limite_desconto;
    lQuery.ParamByName('FRPGTO').AsInteger := pCliente.forma_de_pagamento_padrao;
    lQuery.ParamByName('MUDAR_FRPGTO').AsString := Copy(pCliente.mudar_forma_pagamento, 1, 1);
    lQuery.ParamByName('PRAZO_DIAS').AsInteger := pCliente.prazo_maximo_em_dias;
    lQuery.ParamByName('DIVIDA').AsFloat := pCliente.Divida;
    lQuery.ParamByName('TOL_SALDO').AsFloat := pCliente.saldo_total;
    lQuery.ParamByName('ROTA').AsString := Copy(pCliente.Rota, 1, 4);
    lQuery.ParamByName('ORD_VIS').AsInteger := pCliente.ordem_visita;
    lQuery.ParamByName('OBS1').AsString := Copy(pCliente.Observacao1, 1, 75);
    lQuery.ParamByName('OBS2').AsString := Copy(pCliente.Observacao2, 1, 75);
    lQuery.ParamByName('SUPER_LIMITE_DIAS').AsInteger := pCliente.super_limite_dias;
    lQuery.ParamByName('CARTORIO').AsString := Copy(pCliente.Cartorio, 1, 1);
    lQuery.ParamByName('SERASA').AsString := Copy(pCliente.Serasa, 1, 1);
    lQuery.ParamByName('USU_CADASTRO').AsInteger := pCliente.usuario_cadastro;
    lQuery.ParamByName('SPED_SN').AsString := TFunctions.GetSn(pCliente.Sped);
    lQuery.ParamByName('PISCOFINS_SN').AsString := TFunctions.GetSn(pCliente.Pis_Cofins);
    lQuery.ParamByName('NR').AsString := Copy(pCliente.Numero, 1, 15);
    lQuery.ParamByName('CONSUMIDOR_FINAL').AsString := Copy(pCliente.consumidor_final, 1, 1);
    lQuery.ParamByName('INDPRES').AsString := Copy(pCliente.indicador_presenca_comprador, 1, 1);
    lQuery.ParamByName('INDIEDEST').AsString := Copy(pCliente.indicador_destinatario, 1, 1);
    lQuery.ParamByName('COMPLEMENTO').AsString := Copy(pCliente.Complemento, 1, 50);
    lQuery.ParamByName('BOLETO_COM_TAXA').AsString := Copy(pCliente.boleto_com_taxa, 1, 1);
    lQuery.ParamByName('NOME_COMPLETO_NFE').AsString := Copy(pCliente.nome_completo_nfe, 1, 60);
    lQuery.ParamByName('OBS_INTERNA').AsString := pCliente.observacao_interna; // blob
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
    lQuery.SQL.Add(' SELECT * FROM CLIENTE WHERE CODIGO = :CODIGO ');
    lQuery.ParamByName('CODIGO').AsInteger := pCliente.Codigo;
    lQuery.Open;

    pCliente.Codigo := lQuery.FieldByName('CODIGO').AsInteger;
    pCliente.Nome := lQuery.FieldByName('NOME').AsString;
    pCliente.forma_de_pagamento_padrao := lQuery.FieldByName('FRPGTO').AsInteger;
    pCliente.Tipo_De_Credito := lQuery.FieldByName('TIPOCRED').AsString;
    pCliente.prazo_maximo_em_dias := lQuery.FieldByName('PRAZO_DIAS').AsInteger;
    pCliente.pessoa_fisica := (lQuery.FieldByName('FISJUR').AsString = 'S');
    pCliente.CPF := lQuery.FieldByName('CPF').AsString;
    pCliente.CNPJ := lQuery.FieldByName('CGC').AsString;
    pCliente.valor_limite_do_cliente := lQuery.FieldByName('LIMITECRED').AsFloat;

    pCliente.Ativo := (lQuery.FieldByName('ATIINATIVO').AsString = 'S');
    pCliente.ativo_no_spc := (lQuery.FieldByName('SITSPC').AsString = 'S');

    if not lQuery.FieldByName('DIA_VCTO').IsNull then
    begin
      pCliente.dia_fixo_de_vencimento := lQuery.FieldByName('DIA_VCTO').AsInteger;
    end;

    pCliente.Ie := lQuery.FieldByName('IE').AsString;
    pCliente.Fone := lQuery.FieldByName('FONE').AsString;
    pCliente.Email := lQuery.FieldByName('EMAIL').AsString;
    pCliente.Bairro := lQuery.FieldByName('BAIRRO').AsString;
    pCliente.Fax := lQuery.FieldByName('FAX').AsString;
    pCliente.Uf := lQuery.FieldByName('UF').AsString;
    pCliente.Cep := lQuery.FieldByName('CEP').AsString;
    pCliente.Numero := lQuery.FieldByName('NR').AsString;
    pCliente.Complemento := lQuery.FieldByName('COMPLEMENTO').AsString;
    pCliente.Matricula := lQuery.FieldByName('FANTASIA').AsString;
    pCliente.Cidade := lQuery.FieldByName('CIDADE').AsString;
    pCliente.Endereco := lQuery.FieldByName('ENDERECO').AsString;
    pCliente.Celular := lQuery.FieldByName('CELULAR').AsString;
    pCliente.endereco_ok := lQuery.FieldByName('ENDERECO_OK').AsString = 'S';
    pCliente.convenio_ok := lQuery.FieldByName('CONVENIO_OK').AsString = 'S';
    pCliente.substituicao_tributaria := lQuery.FieldByName('SUBST_TRIB').AsString = 'S';
    pCliente.salario_ok := lQuery.FieldByName('SALARIO_OK').AsString = 'S';
    pCliente.Pis_Cofins := lQuery.FieldByName('PISCOFINS_SN').AsString = 'S';
    pCliente.Sped := lQuery.FieldByName('SPED_SN').AsString = 'S';
    pCliente.usuario_alteracao := lQuery.FieldByName('USU_ALTERACAO').AsInteger;
    pCliente.usuario_cadastro := lQuery.FieldByName('USU_CADASTRO').AsInteger;
    pCliente.data_cadastro := TFunctions.DecodeDateJson(lQuery.FieldByName('DTCADASTRO').AsDateTime);
    pCliente.data_alteracao := TFunctions.DecodeDateHourJson(lQuery.FieldByName('DT_ALTERACAO').AsDateTime);
    pCliente.indicador_destinatario := lQuery.FieldByName('INDIEDEST').AsString;
    pCliente.consumidor_final := lQuery.FieldByName('CONSUMIDOR_FINAL').AsString;
    pCliente.indicador_presenca_comprador := lQuery.FieldByName('INDPRES').AsString;
    pCliente.saldo_credito := lQuery.FieldByName('SALDOCRED').AsFloat;
    pCliente.numero_duplicatas_abertas := lQuery.FieldByName('NRDUPABE').AsInteger;
    pCliente.data_nascimento := TFunctions.DecodeDateJson(lQuery.FieldByName('dtnascto').AsDateTime);
    pCliente.Rg := lQuery.FieldByName('ci').AsString;
    pCliente.Sexo := lQuery.FieldByName('sexo').AsString;
    pCliente.estado_civil := lQuery.FieldByName('estcivil').AsString;
    pCliente.Naturalidade := lQuery.FieldByName('naturalidade').AsString;
    pCliente.Pai := lQuery.FieldByName('pai').AsString;
    pCliente.Mae := lQuery.FieldByName('mae').AsString;
    pCliente.endereco_cobranca := lQuery.FieldByName('endcob').AsString;
    pCliente.cidade_cobranca := lQuery.FieldByName('cidadecob').AsString;
    pCliente.bairro_cobranca := lQuery.FieldByName('bairrocob').AsString;
    pCliente.cep_cobranca := lQuery.FieldByName('cepcob').AsString;
    pCliente.uf_cobranca := lQuery.FieldByName('ufcob').AsString;
    pCliente.Contato := lQuery.FieldByName('contato').AsString;
    pCliente.Aluguel := lQuery.FieldByName('aluguel').AsString;
    pCliente.valor_aluguel := lQuery.FieldByName('valoraluguel').AsFloat;
    pCliente.tempo_aluguel := lQuery.FieldByName('tempoaluguel').AsString;
    pCliente.Empresa := lQuery.FieldByName('empresa').AsString;
    pCliente.fone_empresa := lQuery.FieldByName('foneemp').AsString;
    pCliente.funcao_empresa := lQuery.FieldByName('funcaoemp').AsString;
    pCliente.Admissao := TFunctions.DecodeStrDateForJson(lQuery.FieldByName('admissao').AsString);
    pCliente.Salario := lQuery.FieldByName('salario').AsString;
    pCliente.referencia_comercial := lQuery.FieldByName('refcom').AsString;
    pCliente.referencia_banco := lQuery.FieldByName('refban').AsString;
    pCliente.data_spc := TFunctions.DecodeDateJson(lQuery.FieldByName('dtspc').AsDateTime);
    pCliente.observacao_spc := lQuery.FieldByName('obsspc').AsString;
    pCliente.observacao_geral := lQuery.FieldByName('obsgeral').AsString;
    pCliente.Conjuge := lQuery.FieldByName('conjuge').AsString;
    pCliente.referencia_pessoal := lQuery.FieldByName('refpessoal').AsString;
    pCliente.data_orci := lQuery.FieldByName('dtorci').AsString;
    pCliente.data_movimento := TFunctions.DecodeDateJson(lQuery.FieldByName('dtmov').AsDateTime);
    pCliente.Ultima_Nf := lQuery.FieldByName('ultimanf').AsString;
    pCliente.Valor_Nf := lQuery.FieldByName('valornf').AsFloat;
    pCliente.Tabela_Localizacao := lQuery.FieldByName('tblocal').AsInteger;
    pCliente.Tabela_Extra := lQuery.FieldByName('tbextra').AsInteger;
    pCliente.Local_Cobranca := lQuery.FieldByName('localcob').AsString;
    pCliente.Vendedor := lQuery.FieldByName('rep').AsInteger;
    pCliente.Vip := lQuery.FieldByName('vip').AsString;
    pCliente.validade_vip := TFunctions.DecodeDateJson(lQuery.FieldByName('validvip').AsDateTime);
    pCliente.tabela_convenio := lQuery.FieldByName('tab_convenio').AsInteger;
    pCliente.tabela_profissao := lQuery.FieldByName('tab_profissao').AsInteger;
    pCliente.data_cobranca := TFunctions.DecodeDateJson(lQuery.FieldByName('dt_cobranca').AsDateTime);
    pCliente.quantida_de_cobranca := lQuery.FieldByName('qtde_cobranca').AsInteger;
    pCliente.Icms := lQuery.FieldByName('icms').AsFloat;
    pCliente.foto_caminho := lQuery.FieldByName('foto').AsString;
    pCliente.Atacado := lQuery.FieldByName('atacado').AsString;
    pCliente.limite_desconto := lQuery.FieldByName('limitedesconto').AsFloat;
    pCliente.mudar_forma_pagamento := lQuery.FieldByName('mudar_frpgto').AsString;
    pCliente.Divida := lQuery.FieldByName('divida').AsFloat;
    pCliente.saldo_total := lQuery.FieldByName('tol_saldo').AsFloat;
    pCliente.Rota := lQuery.FieldByName('rota').AsString;
    pCliente.ordem_visita := lQuery.FieldByName('ord_vis').AsInteger;
    pCliente.Observacao1 := lQuery.FieldByName('obs1').AsString;
    pCliente.Observacao2 := lQuery.FieldByName('obs2').AsString;
    pCliente.super_limite_dias := lQuery.FieldByName('super_limite_dias').AsInteger;
    pCliente.Cartorio := lQuery.FieldByName('cartorio').AsString;
    pCliente.Serasa := lQuery.FieldByName('serasa').AsString;
    pCliente.boleto_com_taxa := lQuery.FieldByName('boleto_com_taxa').AsString;
    pCliente.nome_completo_nfe := lQuery.FieldByName('nome_completo_nfe').AsString;
    pCliente.observacao_interna := lQuery.FieldByName('obs_interna').AsString;

    pCliente.cidade_ibge.Codigo := lQuery.FieldByName('CODVIP').AsString;
    if (Length(Trim(pCliente.cidade_ibge.Codigo)) > 0) then
    begin
      TCidadeDAO.Carrega(pCliente.cidade_ibge);
    end;

    Result := (lQuery.RecordCount > 0) and (lQuery.FieldByName('NOME').AsString <> EmptyStr);
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
    lQuery.SQL.Add('DELETE FROM CLIENTE          ');
    lQuery.SQL.Add('  WHERE CODIGO = :CODIGO ');
    lQuery.ParamByName('CODIGO').AsInteger := pCodigo;
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
    lQuery.SQL.Add('SELECT * FROM CLIENTE WHERE CODIGO = :CODIGO');
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
    lQuery.SQL.Add('SELECT * FROM CLIENTE WHERE CGC = :CGC');
    lQuery.ParamByName('CGC').AsString := pCNPJ;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := lQuery.FieldByName('CODIGO').AsInteger;
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
    lQuery.SQL.Add('SELECT * FROM CLIENTE WHERE CPF = :CPF');
    lQuery.ParamByName('CPF').AsString := pCPF;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := lQuery.FieldByName('CODIGO').AsInteger;
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
    lQuery.SQL.Add('SELECT MAX(CODIGO) + 1 CODIGO FROM CLIENTE ');
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
    lQuery.SQL.Add('insert into CLIENTE (      ');
    lQuery.SQL.Add('  CODIGO,                  ');
    lQuery.SQL.Add('  NOME,                    ');
    lQuery.SQL.Add('  FANTASIA,                ');
    lQuery.SQL.Add('  ENDERECO,                ');
    lQuery.SQL.Add('  BAIRRO,                  ');
    lQuery.SQL.Add('  CIDADE,                  ');
    lQuery.SQL.Add('  CEP,                     ');
    lQuery.SQL.Add('  UF,                      ');
    lQuery.SQL.Add('  FONE,                    ');
    lQuery.SQL.Add('  FAX,                     ');
    lQuery.SQL.Add('  CELULAR,                 ');
    lQuery.SQL.Add('  EMAIL,                   ');
    lQuery.SQL.Add('  DTCADASTRO,              ');
    lQuery.SQL.Add('  FISJUR,                  ');
    lQuery.SQL.Add('  ATIINATIVO,              ');
    lQuery.SQL.Add('  DTNASCTO,                ');
    lQuery.SQL.Add('  CPF,                     ');
    lQuery.SQL.Add('  CI,                      ');
    lQuery.SQL.Add('  CGC,                     ');
    lQuery.SQL.Add('  IE,                      ');
    lQuery.SQL.Add('  SEXO,                    ');
    lQuery.SQL.Add('  ESTCIVIL,                ');
    lQuery.SQL.Add('  NATURALIDADE,            ');
    lQuery.SQL.Add('  PAI,                     ');
    lQuery.SQL.Add('  MAE,                     ');
    lQuery.SQL.Add('  ENDCOB,                  ');
    lQuery.SQL.Add('  CIDADECOB,               ');
    lQuery.SQL.Add('  BAIRROCOB,               ');
    lQuery.SQL.Add('  CEPCOB,                  ');
    lQuery.SQL.Add('  UFCOB,                   ');
    lQuery.SQL.Add('  CONTATO,                 ');
    lQuery.SQL.Add('  ALUGUEL,                 ');
    lQuery.SQL.Add('  VALORALUGUEL,            ');
    lQuery.SQL.Add('  TEMPOALUGUEL,            ');
    lQuery.SQL.Add('  EMPRESA,                 ');
    lQuery.SQL.Add('  FONEEMP,                 ');
    lQuery.SQL.Add('  FUNCAOEMP,               ');
    lQuery.SQL.Add('  ADMISSAO,                ');
    lQuery.SQL.Add('  SALARIO,                 ');
    lQuery.SQL.Add('  REFCOM,                  ');
    lQuery.SQL.Add('  REFBAN,                  ');
    lQuery.SQL.Add('  DTSPC,                   ');
    lQuery.SQL.Add('  OBSSPC,                  ');
    lQuery.SQL.Add('  OBSGERAL,                ');
    lQuery.SQL.Add('  SITSPC,                  ');
    lQuery.SQL.Add('  CONJUGE,                 ');
    lQuery.SQL.Add('  REFPESSOAL,              ');
    lQuery.SQL.Add('  DTORCI,                  ');
    lQuery.SQL.Add('  DTMOV,                   ');
    lQuery.SQL.Add('  LIMITECRED,              ');
    lQuery.SQL.Add('  SALDOCRED,               ');
    lQuery.SQL.Add('  ULTIMANF,                ');
    lQuery.SQL.Add('  VALORNF,                 ');
    lQuery.SQL.Add('  TBLOCAL,                 ');
    lQuery.SQL.Add('  TBEXTRA,                 ');
    lQuery.SQL.Add('  LOCALCOB,                ');
    lQuery.SQL.Add('  REP,                     ');
    lQuery.SQL.Add('  TIPOCRED,                ');
    lQuery.SQL.Add('  NRDUPABE,                ');
    lQuery.SQL.Add('  VIP,                     ');
    lQuery.SQL.Add('  CODVIP,                  ');
    lQuery.SQL.Add('  VALIDVIP,                ');
    lQuery.SQL.Add('  SALARIO_OK,             ');
    lQuery.SQL.Add('  ENDERECO_OK,            ');
    lQuery.SQL.Add('  CONVENIO_OK,            ');
    lQuery.SQL.Add('  TAB_CONVENIO,           ');
    lQuery.SQL.Add('  TAB_PROFISSAO,          ');
    lQuery.SQL.Add('  DIA_VCTO,               ');
    lQuery.SQL.Add('  DT_COBRANCA,            ');
    lQuery.SQL.Add('  QTDE_COBRANCA,          ');
    lQuery.SQL.Add('  ICMS,                   ');
    lQuery.SQL.Add('  SUBST_TRIB,             ');
    lQuery.SQL.Add('  FOTO,                    ');
    lQuery.SQL.Add('  ATACADO,                ');
    lQuery.SQL.Add('  LIMITEDESCONTO,         ');
    lQuery.SQL.Add('  FRPGTO,                 ');
    lQuery.SQL.Add('  MUDAR_FRPGTO,           ');
    lQuery.SQL.Add('  PRAZO_DIAS,             ');
    lQuery.SQL.Add('  DIVIDA,                  ');
    lQuery.SQL.Add('  TOL_SALDO,               ');
    lQuery.SQL.Add('  ROTA,                    ');
    lQuery.SQL.Add('  ORD_VIS,                 ');
    lQuery.SQL.Add('  OBS1,                   ');
    lQuery.SQL.Add('  OBS2,                   ');
    lQuery.SQL.Add('  SUPER_LIMITE_DIAS,       ');
    lQuery.SQL.Add('  CARTORIO,               ');
    lQuery.SQL.Add('  SERASA,                 ');
    lQuery.SQL.Add('  USU_CADASTRO,           ');
    lQuery.SQL.Add('  SPED_SN,                ');
    lQuery.SQL.Add('  PISCOFINS_SN,           ');
    lQuery.SQL.Add('  NR,                     ');
    lQuery.SQL.Add('  CONSUMIDOR_FINAL,       ');
    lQuery.SQL.Add('  INDPRES,                ');
    lQuery.SQL.Add('  INDIEDEST,              ');
    lQuery.SQL.Add('  COMPLEMENTO,            ');
    lQuery.SQL.Add('  BOLETO_COM_TAXA,        ');
    lQuery.SQL.Add('  NOME_COMPLETO_NFE,      ');
    lQuery.SQL.Add('  OBS_INTERNA              ');
    lQuery.SQL.Add('  ) values (                   ');
    lQuery.SQL.Add('  :CODIGO,                 ');
    lQuery.SQL.Add('  :NOME,                   ');
    lQuery.SQL.Add('  :FANTASIA,               ');
    lQuery.SQL.Add('  :ENDERECO,               ');
    lQuery.SQL.Add('  :BAIRRO,                 ');
    lQuery.SQL.Add('  :CIDADE,                 ');
    lQuery.SQL.Add('  :CEP,                    ');
    lQuery.SQL.Add('  :UF,                     ');
    lQuery.SQL.Add('  :FONE,                   ');
    lQuery.SQL.Add('  :FAX,                    ');
    lQuery.SQL.Add('  :CELULAR,                ');
    lQuery.SQL.Add('  :EMAIL,                  ');
    lQuery.SQL.Add('  :DTCADASTRO,             ');
    lQuery.SQL.Add('  :FISJUR,                 ');
    lQuery.SQL.Add('  :ATIINATIVO,             ');
    lQuery.SQL.Add('  :DTNASCTO,               ');
    lQuery.SQL.Add('  :CPF,                    ');
    lQuery.SQL.Add('  :CI,                     ');
    lQuery.SQL.Add('  :CGC,                    ');
    lQuery.SQL.Add('  :IE,                     ');
    lQuery.SQL.Add('  :SEXO,                   ');
    lQuery.SQL.Add('  :ESTCIVIL,               ');
    lQuery.SQL.Add('  :NATURALIDADE,           ');
    lQuery.SQL.Add('  :PAI,                    ');
    lQuery.SQL.Add('  :MAE,                    ');
    lQuery.SQL.Add('  :ENDCOB,                 ');
    lQuery.SQL.Add('  :CIDADECOB,              ');
    lQuery.SQL.Add('  :BAIRROCOB,              ');
    lQuery.SQL.Add('  :CEPCOB,                 ');
    lQuery.SQL.Add('  :UFCOB,                  ');
    lQuery.SQL.Add('  :CONTATO,                ');
    lQuery.SQL.Add('  :ALUGUEL,                ');
    lQuery.SQL.Add('  :VALORALUGUEL,           ');
    lQuery.SQL.Add('  :TEMPOALUGUEL,           ');
    lQuery.SQL.Add('  :EMPRESA,                ');
    lQuery.SQL.Add('  :FONEEMP,                ');
    lQuery.SQL.Add('  :FUNCAOEMP,              ');
    lQuery.SQL.Add('  :ADMISSAO,               ');
    lQuery.SQL.Add('  :SALARIO,                ');
    lQuery.SQL.Add('  :REFCOM,                 ');
    lQuery.SQL.Add('  :REFBAN,                 ');
    lQuery.SQL.Add('  :DTSPC,                  ');
    lQuery.SQL.Add('  :OBSSPC,                 ');
    lQuery.SQL.Add('  :OBSGERAL,               ');
    lQuery.SQL.Add('  :SITSPC,                 ');
    lQuery.SQL.Add('  :CONJUGE,                ');
    lQuery.SQL.Add('  :REFPESSOAL,             ');
    lQuery.SQL.Add('  :DTORCI,                 ');
    lQuery.SQL.Add('  :DTMOV,                  ');
    lQuery.SQL.Add('  :LIMITECRED,             ');
    lQuery.SQL.Add('  :SALDOCRED,              ');
    lQuery.SQL.Add('  :ULTIMANF,               ');
    lQuery.SQL.Add('  :VALORNF,                ');
    lQuery.SQL.Add('  :TBLOCAL,                ');
    lQuery.SQL.Add('  :TBEXTRA,                ');
    lQuery.SQL.Add('  :LOCALCOB,               ');
    lQuery.SQL.Add('  :REP,                    ');
    lQuery.SQL.Add('  :TIPOCRED,               ');
    lQuery.SQL.Add('  :NRDUPABE,               ');
    lQuery.SQL.Add('  :VIP,                    ');
    lQuery.SQL.Add('  :CODVIP,                 ');
    lQuery.SQL.Add('  :VALIDVIP,               ');
    lQuery.SQL.Add('  :SALARIO_OK,            ');
    lQuery.SQL.Add('  :ENDERECO_OK,           ');
    lQuery.SQL.Add('  :CONVENIO_OK,           ');
    lQuery.SQL.Add('  :TAB_CONVENIO,          ');
    lQuery.SQL.Add('  :TAB_PROFISSAO,         ');
    lQuery.SQL.Add('  :DIA_VCTO,              ');
    lQuery.SQL.Add('  :DT_COBRANCA,           ');
    lQuery.SQL.Add('  :QTDE_COBRANCA,         ');
    lQuery.SQL.Add('  :ICMS,                  ');
    lQuery.SQL.Add('  :SUBST_TRIB,            ');
    lQuery.SQL.Add('  :FOTO,                   ');
    lQuery.SQL.Add('  :ATACADO,               ');
    lQuery.SQL.Add('  :LIMITEDESCONTO,        ');
    lQuery.SQL.Add('  :FRPGTO,                ');
    lQuery.SQL.Add('  :MUDAR_FRPGTO,          ');
    lQuery.SQL.Add('  :PRAZO_DIAS,            ');
    lQuery.SQL.Add('  :DIVIDA,                 ');
    lQuery.SQL.Add('  :TOL_SALDO,              ');
    lQuery.SQL.Add('  :ROTA,                   ');
    lQuery.SQL.Add('  :ORD_VIS,                ');
    lQuery.SQL.Add('  :OBS1,                  ');
    lQuery.SQL.Add('  :OBS2,                  ');
    lQuery.SQL.Add('  :SUPER_LIMITE_DIAS,      ');
    lQuery.SQL.Add('  :CARTORIO,              ');
    lQuery.SQL.Add('  :SERASA,                ');
    lQuery.SQL.Add('  :USU_CADASTRO,          ');
    lQuery.SQL.Add('  :SPED_SN,               ');
    lQuery.SQL.Add('  :PISCOFINS_SN,          ');
    lQuery.SQL.Add('  :NR,                    ');
    lQuery.SQL.Add('  :CONSUMIDOR_FINAL,      ');
    lQuery.SQL.Add('  :INDPRES,               ');
    lQuery.SQL.Add('  :INDIEDEST,             ');
    lQuery.SQL.Add('  :COMPLEMENTO,           ');
    lQuery.SQL.Add('  :BOLETO_COM_TAXA,       ');
    lQuery.SQL.Add('  :NOME_COMPLETO_NFE,     ');
    lQuery.SQL.Add('  :OBS_INTERNA             ');
    lQuery.SQL.Add('        );                     ');
    lQuery.ParamByName('CODIGO').AsInteger := pCliente.Codigo;
    lQuery.ParamByName('NOME').AsString := Copy(pCliente.Nome, 1, 35);
    lQuery.ParamByName('FANTASIA').AsString := Copy(pCliente.Matricula, 1, 35);
    lQuery.ParamByName('ENDERECO').AsString := Copy(pCliente.Endereco, 1, 35);
    lQuery.ParamByName('BAIRRO').AsString := Copy(pCliente.Bairro, 1, 20);
    lQuery.ParamByName('CIDADE').AsString := Copy(pCliente.Cidade, 1, 30);
    lQuery.ParamByName('CEP').AsString := Copy(pCliente.Cep, 1, 10);
    lQuery.ParamByName('UF').AsString := Copy(pCliente.Uf, 1, 2);
    lQuery.ParamByName('FONE').AsString := Copy(pCliente.Fone, 1, 15);
    lQuery.ParamByName('FAX').AsString := Copy(pCliente.Fax, 1, 15);
    lQuery.ParamByName('CELULAR').AsString := Copy(pCliente.Celular, 1, 15);
    lQuery.ParamByName('EMAIL').AsString := Copy(pCliente.Email, 1, 50);
    lQuery.ParamByName('DTCADASTRO').AsDateTime := StrToDateTimedef(pCliente.data_cadastro, now);
    lQuery.ParamByName('FISJUR').AsString := TFunctions.GetSn(pCliente.pessoa_fisica);
    lQuery.ParamByName('ATIINATIVO').AsString := TFunctions.GetSn(pCliente.Ativo);
    lQuery.ParamByName('DTNASCTO').AsDate := StrToDatedef(pCliente.data_nascimento, now);
    lQuery.ParamByName('CPF').AsString := Copy(pCliente.CPF, 1, 11);
    lQuery.ParamByName('CI').AsString := Copy(pCliente.Rg, 1, 10);
    lQuery.ParamByName('CGC').AsString := Copy(pCliente.CNPJ, 1, 14);
    lQuery.ParamByName('IE').AsString := Copy(pCliente.Ie, 1, 20);
    lQuery.ParamByName('SEXO').AsString := Copy(pCliente.Sexo, 1, 1);
    lQuery.ParamByName('ESTCIVIL').AsString := Copy(pCliente.estado_civil, 1, 1);
    lQuery.ParamByName('NATURALIDADE').AsString := Copy(pCliente.Naturalidade, 1, 30);
    lQuery.ParamByName('PAI').AsString := Copy(pCliente.Pai, 1, 35);
    lQuery.ParamByName('MAE').AsString := Copy(pCliente.Mae, 1, 35);
    lQuery.ParamByName('ENDCOB').AsString := Copy(pCliente.endereco_cobranca, 1, 35);
    lQuery.ParamByName('CIDADECOB').AsString := Copy(pCliente.cidade_cobranca, 1, 30);
    lQuery.ParamByName('BAIRROCOB').AsString := Copy(pCliente.bairro_cobranca, 1, 20);
    lQuery.ParamByName('CEPCOB').AsString := Copy(pCliente.cep_cobranca, 1, 10);
    lQuery.ParamByName('UFCOB').AsString := Copy(pCliente.uf_cobranca, 1, 2);
    lQuery.ParamByName('CONTATO').AsString := Copy(pCliente.Contato, 1, 50);
    lQuery.ParamByName('ALUGUEL').AsString := Copy(pCliente.Aluguel, 1, 1);
    lQuery.ParamByName('VALORALUGUEL').AsFloat := pCliente.valor_aluguel;
    lQuery.ParamByName('TEMPOALUGUEL').AsString := Copy(pCliente.tempo_aluguel, 1, 25);
    lQuery.ParamByName('EMPRESA').AsString := Copy(pCliente.Empresa, 1, 35);
    lQuery.ParamByName('FONEEMP').AsString := Copy(pCliente.fone_empresa, 1, 15);
    lQuery.ParamByName('FUNCAOEMP').AsString := Copy(pCliente.funcao_empresa, 1, 15);
    lQuery.ParamByName('ADMISSAO').AsString := pCliente.Admissao; // data em string?
    lQuery.ParamByName('SALARIO').AsString := Copy(pCliente.Salario, 1, 25);
    lQuery.ParamByName('REFCOM').AsString := Copy(pCliente.referencia_comercial, 1, 100);
    lQuery.ParamByName('REFBAN').AsString := Copy(pCliente.referencia_banco, 1, 100);
    lQuery.ParamByName('DTSPC').AsDate := StrToDatedef(pCliente.data_spc, now);
    lQuery.ParamByName('OBSSPC').AsString := Copy(pCliente.observacao_spc, 1, 100);
    lQuery.ParamByName('OBSGERAL').AsString := pCliente.observacao_geral; // blob
    lQuery.ParamByName('SITSPC').AsString := TFunctions.GetSn(pCliente.ativo_no_spc);
    lQuery.ParamByName('CONJUGE').AsString := Copy(pCliente.Conjuge, 1, 50);
    lQuery.ParamByName('REFPESSOAL').AsString := Copy(pCliente.referencia_pessoal, 1, 50);
    lQuery.ParamByName('DTORCI').AsString := Copy(pCliente.data_orci, 1, 25);
    lQuery.ParamByName('DTMOV').AsDate := StrToDatedef(pCliente.data_movimento, now);
    lQuery.ParamByName('LIMITECRED').AsFloat := pCliente.valor_limite_do_cliente;
    lQuery.ParamByName('SALDOCRED').AsFloat := pCliente.saldo_credito;
    lQuery.ParamByName('ULTIMANF').AsString := Copy(pCliente.Ultima_Nf, 1, 10);
    lQuery.ParamByName('VALORNF').AsFloat := pCliente.Valor_Nf;
    lQuery.ParamByName('TBLOCAL').AsInteger := pCliente.Tabela_Localizacao;
    lQuery.ParamByName('TBEXTRA').AsInteger := pCliente.Tabela_Extra;
    lQuery.ParamByName('LOCALCOB').AsString := Copy(pCliente.Local_Cobranca, 1, 3);
    lQuery.ParamByName('REP').AsInteger := pCliente.Vendedor;
    lQuery.ParamByName('TIPOCRED').AsString := Copy(pCliente.Tipo_De_Credito, 1, 1);
    lQuery.ParamByName('NRDUPABE').AsInteger := pCliente.numero_duplicatas_abertas;
    lQuery.ParamByName('VIP').AsString := Copy(pCliente.Vip, 1, 1);
    lQuery.ParamByName('CODVIP').AsString := Copy(pCliente.cidade_ibge.Codigo, 1, 14);
    lQuery.ParamByName('VALIDVIP').AsDate := StrToDatedef(pCliente.validade_vip, now);
    lQuery.ParamByName('SALARIO_OK').AsString := TFunctions.GetSn(pCliente.salario_ok);
    lQuery.ParamByName('ENDERECO_OK').AsString := TFunctions.GetSn(pCliente.endereco_ok);
    lQuery.ParamByName('CONVENIO_OK').AsString := TFunctions.GetSn(pCliente.convenio_ok);
    lQuery.ParamByName('TAB_CONVENIO').AsInteger := pCliente.tabela_convenio;
    lQuery.ParamByName('TAB_PROFISSAO').AsInteger := pCliente.tabela_profissao;
    lQuery.ParamByName('DIA_VCTO').AsInteger := pCliente.dia_fixo_de_vencimento;
    lQuery.ParamByName('DT_COBRANCA').AsDate := StrToDatedef(pCliente.data_cobranca, now);
    lQuery.ParamByName('QTDE_COBRANCA').AsInteger := pCliente.quantida_de_cobranca;
    lQuery.ParamByName('ICMS').AsFloat := pCliente.Icms;
    lQuery.ParamByName('SUBST_TRIB').AsString := TFunctions.GetSn(pCliente.substituicao_tributaria);
    lQuery.ParamByName('FOTO').AsString := Copy(pCliente.foto_caminho, 1, 45);
    lQuery.ParamByName('ATACADO').AsString := Copy(pCliente.Atacado, 1, 1);
    lQuery.ParamByName('LIMITEDESCONTO').AsFloat := pCliente.limite_desconto;
    lQuery.ParamByName('FRPGTO').AsInteger := pCliente.forma_de_pagamento_padrao;
    lQuery.ParamByName('MUDAR_FRPGTO').AsString := Copy(pCliente.mudar_forma_pagamento, 1, 1);
    lQuery.ParamByName('PRAZO_DIAS').AsInteger := pCliente.prazo_maximo_em_dias;
    lQuery.ParamByName('DIVIDA').AsFloat := pCliente.Divida;
    lQuery.ParamByName('TOL_SALDO').AsFloat := pCliente.saldo_total;
    lQuery.ParamByName('ROTA').AsString := Copy(pCliente.Rota, 1, 4);
    lQuery.ParamByName('ORD_VIS').AsInteger := pCliente.ordem_visita;
    lQuery.ParamByName('OBS1').AsString := Copy(pCliente.Observacao1, 1, 75);
    lQuery.ParamByName('OBS2').AsString := Copy(pCliente.Observacao2, 1, 75);
    lQuery.ParamByName('SUPER_LIMITE_DIAS').AsInteger := pCliente.super_limite_dias;
    lQuery.ParamByName('CARTORIO').AsString := Copy(pCliente.Cartorio, 1, 1);
    lQuery.ParamByName('SERASA').AsString := Copy(pCliente.Serasa, 1, 1);
    lQuery.ParamByName('USU_CADASTRO').AsInteger := pCliente.usuario_cadastro;
    lQuery.ParamByName('SPED_SN').AsString := TFunctions.GetSn(pCliente.Sped);
    lQuery.ParamByName('PISCOFINS_SN').AsString := TFunctions.GetSn(pCliente.Pis_Cofins);
    lQuery.ParamByName('NR').AsString := Copy(pCliente.Numero, 1, 15);
    lQuery.ParamByName('CONSUMIDOR_FINAL').AsString := Copy(pCliente.consumidor_final, 1, 1);
    lQuery.ParamByName('INDPRES').AsString := Copy(pCliente.indicador_presenca_comprador, 1, 1);
    lQuery.ParamByName('INDIEDEST').AsString := Copy(pCliente.indicador_destinatario, 1, 1);
    lQuery.ParamByName('COMPLEMENTO').AsString := Copy(pCliente.Complemento, 1, 50);
    lQuery.ParamByName('BOLETO_COM_TAXA').AsString := Copy(pCliente.boleto_com_taxa, 1, 1);
    lQuery.ParamByName('NOME_COMPLETO_NFE').AsString := Copy(pCliente.nome_completo_nfe, 1, 60);
    lQuery.ParamByName('OBS_INTERNA').AsString := pCliente.observacao_interna; // blob
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
