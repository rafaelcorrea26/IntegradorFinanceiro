unit uBancoDAO;

interface

uses
  System.Classes,
  uQuery,
  pcnconversao,
  System.SysUtils,
  uFunctions,
  uBanco,
  Vcl.Dialogs,
  REST.JSON.Types,
  uInterfacesEntity;

type
  TBancoDAO = class(TInterfacedObject, iBancoDAO)
  private

  public
    class function Limpar(pBanco: TBanco): boolean;
    class function Carrega(pBanco: TBanco): boolean;
    class function Incluir(pBanco: TBanco; pCommit: boolean = true): boolean;
    class function Alterar(pBanco: TBanco; pCommit: boolean = true): boolean;
    class function Excluir(pCodigo: string; pCommit: boolean = true): boolean;
    class function Existe(pBanco: TBanco): boolean;
  end;

implementation

{ TBanco }

class function TBancoDAO.Alterar(pBanco: TBanco; pCommit : Boolean = true): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;;
    lQuery.SQL.add(' UPDATE  BANCO SET                              ');
    lQuery.SQL.add('   AC09_CODIGO = :AC09_CODIGO                        ');
    lQuery.SQL.add(' , AC09_BANCO = :AC09_BANCO                          ');
    lQuery.SQL.add(' , AC09_ARQUIVO = :AC09_ARQUIVO                      ');
    lQuery.SQL.add(' , AC09_LOCAL = :AC09_LOCAL                          ');
    lQuery.SQL.add(' , AN09_NARQUIVO = :AN09_NARQUIVO                    ');
    lQuery.SQL.add(' , AN09_DIGITO_BANCO = :AN09_DIGITO_BANCO            ');
    lQuery.SQL.add(' , AC09_DTHORA_ARQUIVO_SN = :AC09_DTHORA_ARQUIVO_SN  ');
    lQuery.parambyname('AC09_CODIGO').asstring := pBanco.Codigo;
    lQuery.parambyname('AC09_BANCO').asstring := pBanco.banco;
    lQuery.parambyname('AC09_ARQUIVO').asstring := pBanco.arquivo;
    lQuery.parambyname('AC09_LOCAL').asstring := pBanco.local;
    lQuery.parambyname('AN09_NARQUIVO').AsInteger := StrToIntDef(pBanco.numero_arquivo, 0);
    lQuery.parambyname('AN09_DIGITO_BANCO').AsInteger := StrToIntDef(pBanco.digito_banco, 0);
    lQuery.parambyname('AC09_DTHORA_ARQUIVO_SN').asstring := pBanco.data_hora_arquivo_sn;
    lQuery.execsql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;

end;

class function TBancoDAO.Carrega(pBanco: TBanco): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.add(' select * from BANCO          ');
    lQuery.SQL.add(' where CODIGO = :CODIGO  ');
    lQuery.parambyname('CODIGO').asstring := pBanco.Codigo;
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      // carrega dados
      pBanco.Codigo := lQuery.FieldByName('CODIGO').asstring;
      pBanco.banco := lQuery.FieldByName('BANCO').asstring;
      pBanco.arquivo := lQuery.FieldByName('ARQUIVO').asstring;
      pBanco.local := lQuery.FieldByName('LOCAL').asstring;
      pBanco.numero_arquivo := lQuery.FieldByName('NARQUIVO').asstring;
      pBanco.digito_banco := lQuery.FieldByName('DIGITO_BANCO').asstring;
      pBanco.data_hora_arquivo_sn := lQuery.FieldByName('DTHORA_ARQUIVO_SN').asstring;
    end;

    Result := (lQuery.RecordCount > 0) and (lQuery.FieldByName('BANCO').asstring <> EmptyStr);

  finally
    lQuery.free;
  end;

end;

class function TBancoDAO.Excluir(pCodigo: string; pCommit : Boolean = true): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.add(' DELETE FROM BANCO             ');
    lQuery.SQL.add(' where CODIGO = :CODIGO   ');
    lQuery.parambyname('CODIGO').asstring := pCodigo;
    lQuery.execsql;
    lQuery.connection.commit;

  finally
    lQuery.free;
  end;

end;

class function TBancoDAO.Existe(pBanco: TBanco): boolean;
var
  lQuery: TQuery;
begin
  Result := false;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.add('SELECT * FROM BANCO WHERE CODIGO = :CODIGO');
    lQuery.parambyname('CODIGO').asstring := pBanco.Codigo;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := true;
    end;
  finally
    lQuery.free;
  end;

end;

class function TBancoDAO.Incluir(pBanco: TBanco; pCommit : Boolean = true): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;;
    lQuery.SQL.add(' INSERT INTO BANCO(           ');
    lQuery.SQL.add('    CODIGO                    ');
    lQuery.SQL.add('  , BANCO                     ');
    lQuery.SQL.add('  , ARQUIVO                   ');
    lQuery.SQL.add('  , LOCAL                     ');
    lQuery.SQL.add('  , NARQUIVO                  ');
    lQuery.SQL.add('  , DIGITO_BANCO              ');
    lQuery.SQL.add('  , DTHORA_ARQUIVO_SN         ');
    lQuery.SQL.add('  ) values(                        ');
    lQuery.SQL.add('   :CODIGO                    ');
    lQuery.SQL.add('  ,:BANCO                     ');
    lQuery.SQL.add('  ,:ARQUIVO                   ');
    lQuery.SQL.add('  ,:LOCAL                     ');
    lQuery.SQL.add('  ,:NARQUIVO                  ');
    lQuery.SQL.add('  ,:DIGITO_BANCO              ');
    lQuery.SQL.add('  ,:DTHORA_ARQUIVO_SN         ');
    lQuery.SQL.add(' )                                 ');
    lQuery.parambyname('CODIGO').asstring := pBanco.Codigo;
    lQuery.parambyname('BANCO').asstring := pBanco.banco;
    lQuery.parambyname('ARQUIVO').asstring := pBanco.arquivo;
    lQuery.parambyname('LOCAL').asstring := pBanco.local;
    lQuery.parambyname('NARQUIVO').AsInteger := StrToIntDef(pBanco.numero_arquivo, 0);
    lQuery.parambyname('DIGITO_BANCO').AsInteger := StrToIntDef(pBanco.digito_banco, 0);
    lQuery.parambyname('DTHORA_ARQUIVO_SN').asstring := pBanco.data_hora_arquivo_sn;
    lQuery.execsql;
    lQuery.connection.commit;

  finally
    lQuery.free;
  end;

end;

class function TBancoDAO.Limpar(pBanco: TBanco): boolean;
begin

end;

end.
