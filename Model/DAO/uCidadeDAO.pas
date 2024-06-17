unit uCidadeDAO;

interface

uses
  Data.DB,
  uQuery,
  uCidade,
  REST.JSON.Types, uInterfacesEntity;

type
  TCidadeDAO = class(TInterfacedObject, iCidadeDAO)
  private
  public

    class function Carrega(pCidade: TCidade): boolean;
    class function Incluir(pCidade: TCidade; pCommit : Boolean = true): boolean;
    class function Alterar(pCidade: TCidade; pCommit : Boolean = true): boolean;
    class function Excluir(pCodigo: string; pCommit : Boolean = true): boolean;
    class function Limpar: boolean;
    class function Existe(pCidade: TCidade): boolean;
  end;

  {

    CREATE TABLE CIDSEFAZ (
    CODIGO        VARCHAR(14) NOT NULL,
    NOME          NOME /* NOME = VARCHAR(35) */,
    UF            UF /* UF = CHAR(2) */,
    CEP           CEP /* CEP = VARCHAR(10) */,
    ALIQUOTA_ISS  DINHEIRO /* DINHEIRO = NUMERIC(15,4) DEFAULT 0 */
    );

  }
implementation

{ TCidadeDAO }

class function TCidadeDAO.Existe(pCidade: TCidade): boolean;
var
  lQuery: TQuery;
begin
  Result := false;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM CIDSEFAZ WHERE CODIGO = :CODIGO');
    lQuery.ParamByName('CODIGO').AsString := pCidade.Codigo;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := True;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TCidadeDAO.Alterar(pCidade: TCidade; pCommit : Boolean = true): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('UPDATE CIDSEFAZ SET                  ');
    lQuery.SQL.Add('     NOME         =:NOME         ');
    lQuery.SQL.Add('   , UF           =:UF           ');
    lQuery.SQL.Add('   , CEP          =:CEP          ');
    lQuery.SQL.Add('   , ALIQUOTA_ISS =:ALIQUOTA_ISS ');
    lQuery.SQL.Add('WHERE CODIGO      =:CODIGO       ');
    lQuery.ParamByName('NOME').AsString := copy(pCidade.Nome,1,35);
    lQuery.ParamByName('UF').AsString := copy(pCidade.Uf,1,2);
    lQuery.ParamByName('CEP').AsString := copy(pCidade.Cep,1,10);
    lQuery.ParamByName('ALIQUOTA_ISS').AsFloat := pCidade.Aliquota;
    lQuery.ParamByName('CODIGO').AsString := copy(pCidade.Codigo,1,14);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TCidadeDAO.Carrega(pCidade: TCidade): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('select * from CIDSEFAZ where CODIGO = :CODIGO ');
    lQuery.ParamByName('CODIGO').AsString := pCidade.Codigo;
    lQuery.Open;

    pCidade.Nome := lQuery.FieldByName('NOME').AsString;
    pCidade.Uf := lQuery.FieldByName('UF').AsString;
    pCidade.Cep := lQuery.FieldByName('CEP').AsString;
    pCidade.Aliquota := lQuery.FieldByName('ALIQUOTA_ISS').AsFloat;
  finally
    lQuery.Free;
  end;
end;

class function TCidadeDAO.Excluir(pCodigo: string; pCommit : Boolean = true): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM CIDSEFAZ       ');
    lQuery.SQL.Add('WHERE CODIGO =:CODIGO  ');
    lQuery.ParamByName('CODIGO').AsString := pCodigo;
    lQuery.ExecSQL;

    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TCidadeDAO.Incluir(pCidade: TCidade; pCommit : Boolean = true): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('INSERT INTO CIDSEFAZ( ');
    lQuery.SQL.Add('     CODIGO             ');
    lQuery.SQL.Add('   , NOME               ');
    lQuery.SQL.Add('   , UF                 ');
    lQuery.SQL.Add('   , CEP                ');
    lQuery.SQL.Add('   , ALIQUOTA_ISS       ');
    lQuery.SQL.Add('   ) VALUES (                 ');
    lQuery.SQL.Add('     :CODIGO            ');
    lQuery.SQL.Add('   , :NOME              ');
    lQuery.SQL.Add('   , :UF                ');
    lQuery.SQL.Add('   , :CEP               ');
    lQuery.SQL.Add('   , :ALIQUOTA_ISS      ');
    lQuery.SQL.Add('   )                              ');
    lQuery.ParamByName('NOME').AsString := copy(pCidade.Nome,1,35);
    lQuery.ParamByName('UF').AsString := copy(pCidade.Uf,1,2);
    lQuery.ParamByName('CEP').AsString := copy(pCidade.Cep,1,10);
    lQuery.ParamByName('ALIQUOTA_ISS').AsFloat := pCidade.Aliquota;
    lQuery.ParamByName('CODIGO').AsString := copy(pCidade.Codigo,1,14);

    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TCidadeDAO.Limpar: boolean;
begin

end;
end.
