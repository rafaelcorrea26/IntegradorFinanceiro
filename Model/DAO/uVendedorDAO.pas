unit uVendedorDAO;

interface

uses
  uQuery,
  uFunctions,
  uVendedor,
  REST.JSON.Types,
  uInterfacesEntity, System.SysUtils;

type
  TVendedorDAO = class(TInterfacedObject, iVendedorDAO)
  private

  public
    class function Limpar(pVendedor: Tvendedor): Boolean;
    class function Carrega(pVendedor: Tvendedor): Boolean;
    class function Incluir(pVendedor: Tvendedor; pCommit : Boolean = true): Boolean;
    class function Alterar(pVendedor: Tvendedor; pCommit : Boolean = true): Boolean;
    class function Excluir(pCodigo: Integer; pCommit : Boolean = true): Boolean;

    class function GetLimitePermitidoParaDescontoNaVenda(pVendedor, pCliente: Integer): Double;
    class function Existe(pCodigo: Integer): Boolean;
    class function ExisteCPFouCNPJ(pCPFouCNPJ: string): Integer;
    class function GeraProximoCodigo: Integer;
  end;

implementation

{ TVendedor }

class function TVendedorDAO.Alterar(pVendedor: Tvendedor; pCommit : Boolean = true): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('UPDATE REP SET                       ');
    lQuery.SQL.Add('    NOME         = :NOME         ');
    lQuery.SQL.Add('  , CMAV         = :CMAV         ');
    lQuery.SQL.Add('  , CMAP         = :CMAP         ');
    lQuery.SQL.Add('  , PRECO        = :PRECO        ');
    lQuery.SQL.Add('  , LMDESC       = :LMDESC       ');
    lQuery.SQL.Add('  , PART_AGENDA = :PART_AGENDA ');
    lQuery.SQL.Add('  , VLMETA       = :VLMETA       ');
    lQuery.SQL.Add('  , ENDERECO     = :ENDERECO     ');
    lQuery.SQL.Add('  , CIDADE       = :CIDADE       ');
    lQuery.SQL.Add('  , CEP          = :CEP          ');
    lQuery.SQL.Add('  , EMAIL        = :EMAIL        ');
    lQuery.SQL.Add('  , TELEFONE     = :TELEFONE     ');
    lQuery.SQL.Add('  , CNPJ         = :CNPJ         ');
    lQuery.SQL.Add('  , OBS          = :OBS          ');
    lQuery.SQL.Add('  , SENHA        = :SENHA        ');
    lQuery.SQL.Add('  , TIPO_PRECO  = :TIPO_PRECO  ');
    lQuery.SQL.Add('WHERE CODIGO     = :CODIGO       ');

    lQuery.ParamByName('NOME').AsString := Copy(pVendedor.Nome, 1, 25);
    lQuery.ParamByName('CMAV').AsFloat := pVendedor.comissao_vista;
    lQuery.ParamByName('CMAP').AsFloat := pVendedor.comissao_prazo;
    lQuery.ParamByName('PRECO').AsString := Tfunctions.GetSN(pVendedor.modifica_preco_venda);
    lQuery.ParamByName('LMDESC').AsFloat := pVendedor.limite_desconto;
    lQuery.ParamByName('PART_AGENDA').AsString := Tfunctions.GetSN(pVendedor.participar_agenda);
    lQuery.ParamByName('VLMETA').AsFloat := pVendedor.meta_venda;
    lQuery.ParamByName('ENDERECO').AsString := Copy(pVendedor.Endereco, 1, 35);
    lQuery.ParamByName('CIDADE').AsString := Copy(pVendedor.Cidade, 1, 30);
    lQuery.ParamByName('CEP').AsString := Copy(pVendedor.Cep, 1, 10);
    lQuery.ParamByName('EMAIL').AsString := Copy(pVendedor.Email, 1, 50);
    lQuery.ParamByName('TELEFONE').AsString := Copy(pVendedor.Fone, 1, 15);
    lQuery.ParamByName('CNPJ').AsString := Copy(pVendedor.Cpf_Cnpj, 1, 14);
    lQuery.ParamByName('OBS').AsString := Copy(pVendedor.Observacoes, 1, 80);
    lQuery.ParamByName('SENHA').AsString := Copy(pVendedor.Senha, 1, 5);
    lQuery.ParamByName('TIPO_PRECO').AsString := Copy(pVendedor.tipo_preco_venda, 1, 1);
    lQuery.ParamByName('CODIGO').AsInteger := pVendedor.Codigo;

    lQuery.ExecSQL;
    lQuery.connection.commit;
  finally
    lQuery.Free;
  end;

end;

class function TVendedorDAO.Carrega(pVendedor: Tvendedor): Boolean;
var
  lConsulta: TQuery;
begin

  lConsulta := TQuery.Create(nil);
  try
    lConsulta.Close;
    lConsulta.SQL.Clear;
    lConsulta.SQL.Add('SELECT * FROM REP WHERE CODIGO = :CODIGO ');
    lConsulta.ParamByName('CODIGO').AsInteger := pVendedor.Codigo;
    lConsulta.Open;

    if lConsulta.RecordCount > 0 then
    begin

      pVendedor.Codigo := lConsulta.FieldByName('CODIGO').AsInteger;
      pVendedor.Nome := lConsulta.FieldByName('NOME').AsString;
      pVendedor.comissao_vista := lConsulta.FieldByName('CMAV').AsFloat;
      pVendedor.comissao_prazo := lConsulta.FieldByName('CMAP').AsFloat;
      pVendedor.modifica_preco_venda := lConsulta.FieldByName('PRECO').AsString = 'S';
      pVendedor.limite_desconto := lConsulta.FieldByName('LMDESC').AsInteger;
      pVendedor.meta_venda := lConsulta.FieldByName('VLMETA').AsFloat;
      pVendedor.participar_agenda := lConsulta.FieldByName('PART_AGENDA').AsString = 'S';
      pVendedor.tipo_preco_venda := lConsulta.FieldByName('TIPO_PRECO').AsString;
      pVendedor.Endereco := lConsulta.FieldByName('ENDERECO').AsString;
      pVendedor.Cpf_Cnpj := lConsulta.FieldByName('CNPJ').AsString;
      pVendedor.Cidade := lConsulta.FieldByName('CIDADE').AsString;
      pVendedor.Cep := lConsulta.FieldByName('CEP').AsString;
      pVendedor.Fone := lConsulta.FieldByName('TELEFONE').AsString;
      pVendedor.Email := lConsulta.FieldByName('EMAIL').AsString;
      pVendedor.Observacoes := lConsulta.FieldByName('OBS').AsString;
      pVendedor.Senha := lConsulta.FieldByName('SENHA').AsString;
    end;

    Result := (lConsulta.RecordCount > 0) and (lConsulta.FieldByName('NOME').AsString <> EmptyStr);
  finally
    lConsulta.Free;
  end;

end;

class function TVendedorDAO.Excluir(pCodigo: Integer; pCommit : Boolean = true): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM REP WHERE CODIGO = :CODIGO ');
    lQuery.ParamByName('CODIGO').AsInteger := pCodigo;
    lQuery.ExecSQL;
    lQuery.connection.commit;
  finally
    lQuery.Free;
  end;

end;

class function TVendedorDAO.Existe(pCodigo: Integer): Boolean;
var
  lQuery: TQuery;
begin
  Result := false;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM REP WHERE CODIGO = :CODIGO');
    lQuery.ParamByName('CODIGO').AsInteger := pCodigo;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := True;
    end;
  finally
    lQuery.Free;
  end;
end;

class function TVendedorDAO.ExisteCPFouCNPJ(pCPFouCNPJ: string): Integer;
var
  lQuery: TQuery;
begin
  Result := 0;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM REP WHERE CNPJ = :CNPJ');
    lQuery.ParamByName('CNPJ').AsString := pCPFouCNPJ;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := lQuery.FieldByName('CODIGO').AsInteger;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TVendedorDAO.GeraProximoCodigo: Integer;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT max(CODIGO) +1 codigo FROM REP');
    lQuery.Open;
    Result := lQuery.FieldByName('codigo').AsInteger;
  finally
    lQuery.Free;
  end;
end;

class function TVendedorDAO.GetLimitePermitidoParaDescontoNaVenda(pVendedor, pCliente: Integer): Double;
var
  lPercentualLimiteDescontoVendedor, lPercentualLimiteDescontoCliente: Double;
var
  lQuery: TQuery;
begin
  Result := 0;
  lPercentualLimiteDescontoVendedor := 0;
  lPercentualLimiteDescontoCliente := 0;

  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT LMDESC FROM REP    ');
    lQuery.SQL.Add('  WHERE CODIGO = :CODIGO  ');
    lQuery.ParamByName('CODIGO').AsInteger := pVendedor;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      lPercentualLimiteDescontoVendedor := lQuery.FieldByName('LMDESC').AsFloat;
    end;

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT LIMITEDESCONTO FROM CLIENTE ');
    lQuery.SQL.Add('  WHERE CODIGO = :CODIGO            ');
    lQuery.ParamByName('CODIGO').AsInteger := pCliente;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      lPercentualLimiteDescontoCliente := lQuery.FieldByName('LIMITEDESCONTO').AsFloat;
    end;

    // if (TSistema.Usuario.LimiteDeDesconto > lPercentualLimiteDescontoVendedor) then
    // begin
    // lPercentualLimiteDescontoVendedor := TSistema.Usuario.LimiteDeDesconto;
    // end;

    Result := lPercentualLimiteDescontoVendedor + lPercentualLimiteDescontoCliente;
  finally
    lQuery.Free;
  end;
end;

class function TVendedorDAO.Incluir(pVendedor: Tvendedor; pCommit : Boolean = true): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('INSERT INTO REP (    ');
    lQuery.SQL.Add('    CODIGO           ');
    lQuery.SQL.Add('  , NOME             ');
    lQuery.SQL.Add('  , CMAV             ');
    lQuery.SQL.Add('  , CMAP             ');
    lQuery.SQL.Add('  , PRECO            ');
    lQuery.SQL.Add('  , LMDESC           ');
    lQuery.SQL.Add('  , PART_AGENDA     ');
    lQuery.SQL.Add('  , VLMETA           ');
    lQuery.SQL.Add('  , ENDERECO         ');
    lQuery.SQL.Add('  , CIDADE           ');
    lQuery.SQL.Add('  , CEP              ');
    lQuery.SQL.Add('  , EMAIL            ');
    lQuery.SQL.Add('  , TELEFONE         ');
    lQuery.SQL.Add('  , CNPJ             ');
    lQuery.SQL.Add('  , OBS              ');
    lQuery.SQL.Add('  , SENHA            ');
    lQuery.SQL.Add('  , TIPO_PRECO      ');
    lQuery.SQL.Add('  ) VALUES (             ');
    lQuery.SQL.Add('    :CODIGO          ');
    lQuery.SQL.Add('  , :NOME            ');
    lQuery.SQL.Add('  , :CMAV            ');
    lQuery.SQL.Add('  , :CMAP            ');
    lQuery.SQL.Add('  , :PRECO           ');
    lQuery.SQL.Add('  , :LMDESC          ');
    lQuery.SQL.Add('  , :PART_AGENDA    ');
    lQuery.SQL.Add('  , :VLMETA          ');
    lQuery.SQL.Add('  , :ENDERECO        ');
    lQuery.SQL.Add('  , :CIDADE          ');
    lQuery.SQL.Add('  , :CEP             ');
    lQuery.SQL.Add('  , :EMAIL           ');
    lQuery.SQL.Add('  , :TELEFONE        ');
    lQuery.SQL.Add('  , :CNPJ            ');
    lQuery.SQL.Add('  , :OBS             ');
    lQuery.SQL.Add('  , :SENHA           ');
    lQuery.SQL.Add('  , :TIPO_PRECO     ');
    lQuery.SQL.Add('  ) ;                    ');
    lQuery.ParamByName('NOME').AsString := Copy(pVendedor.Nome, 1, 25);
    lQuery.ParamByName('CMAV').AsFloat := pVendedor.comissao_vista;
    lQuery.ParamByName('CMAP').AsFloat := pVendedor.comissao_prazo;
    lQuery.ParamByName('PRECO').AsString := Tfunctions.GetSN(pVendedor.modifica_preco_venda);
    lQuery.ParamByName('LMDESC').AsFloat := pVendedor.limite_desconto;
    lQuery.ParamByName('PART_AGENDA').AsString := Tfunctions.GetSN(pVendedor.participar_agenda);
    lQuery.ParamByName('VLMETA').AsFloat := pVendedor.meta_venda;
    lQuery.ParamByName('ENDERECO').AsString := Copy(pVendedor.Endereco, 1, 35);
    lQuery.ParamByName('CIDADE').AsString := Copy(pVendedor.Cidade, 1, 30);
    lQuery.ParamByName('CEP').AsString := Copy(pVendedor.Cep, 1, 10);
    lQuery.ParamByName('EMAIL').AsString := Copy(pVendedor.Email, 1, 50);
    lQuery.ParamByName('TELEFONE').AsString := Copy(pVendedor.Fone, 1, 15);
    lQuery.ParamByName('CNPJ').AsString := Copy(pVendedor.Cpf_Cnpj, 1, 14);
    lQuery.ParamByName('OBS').AsString := Copy(pVendedor.Observacoes, 1, 80);
    lQuery.ParamByName('SENHA').AsString := Copy(pVendedor.Senha, 1, 5);
    lQuery.ParamByName('TIPO_PRECO').AsString := Copy(pVendedor.tipo_preco_venda, 1, 1);
    lQuery.ParamByName('CODIGO').AsInteger := pVendedor.Codigo;

    lQuery.ExecSQL;
    lQuery.connection.commit;
  finally
    lQuery.Free;
  end;

end;

class function TVendedorDAO.Limpar(pVendedor: Tvendedor): Boolean;
begin
  pVendedor.Codigo := 0;
  pVendedor.Nome := '';
  pVendedor.comissao_vista := 0;
  pVendedor.comissao_prazo := 0;
  pVendedor.modifica_preco_venda := false;
  pVendedor.limite_desconto := 0;
  pVendedor.meta_venda := 0;
  pVendedor.participar_agenda := false;
  pVendedor.tipo_preco_venda := '';
  pVendedor.Endereco := '';
  pVendedor.Cpf_Cnpj := '';
  pVendedor.Cidade := '';
  pVendedor.Cep := '';
  pVendedor.Fone := '';
  pVendedor.Email := '';
  pVendedor.Observacoes := '';
  pVendedor.Senha := '';
end;

end.
