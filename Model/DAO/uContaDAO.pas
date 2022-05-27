unit uContaDAO;

interface

uses
  System.Classes,
  uQuery,
  pcnconversao,
  System.SysUtils,
  uFunctions,
  uConta,
  Vcl.Dialogs,
  uInterfacesEntity;

type
  TContaDAO= class(TInterfacedObject, iContaDAO)
  private

  public
    class function Limpar(pConta: Tconta): boolean;
    class function Carrega(pConta: Tconta): boolean;
    class function Incluir(pConta: Tconta; pCommit : Boolean = true): boolean;
    class function Alterar(pConta: Tconta; pCommit : Boolean = true): boolean;
    class function Excluir(pCodigo: string; pCommit : Boolean = true): boolean;
    class function Existe(pConta: Tconta): boolean;
  end;

implementation

{ TFormaDePagamento }

{ TFormaDePagamento }

class function TContaDAO.Alterar(pConta: Tconta; pCommit : Boolean = true): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;;
    lQuery.SQL.add(' UPDATE  MC07CTA SET                         ');
    lQuery.SQL.add('   AC07NOME = :AC07NOME                      ');
    lQuery.SQL.add(' , AC07TIPO = :AC07TIPO                      ');
    lQuery.SQL.add(' , AC07CC = :AC07CC                          ');
    lQuery.SQL.add(' , AC07DP = :AC07DP                          ');
    lQuery.SQL.add(' , AC07BCO = :AC07BCO                        ');
    lQuery.SQL.add(' , AC07CTA2 = :AC07CTA2                      ');
    lQuery.SQL.add(' , AC07_HISTORICO = :AC07_HISTORICO          ');
    lQuery.SQL.add(' , AC07DRE = :AC07DRE                        ');
    lQuery.SQL.add(' , AN07NIVELDRE = :AN07NIVELDRE              ');
    lQuery.SQL.add(' , AC07TIPOCUSTO = :AC07TIPOCUSTO            ');
    lQuery.SQL.add(' , AC07COMBUSTIVEL = :AC07COMBUSTIVEL        ');
    lQuery.SQL.add(' , AC07SBG = :AC07SBG                        ');
    lQuery.SQL.add(' where (AC07CTA = :AC07CTA)                  ');
    lQuery.parambyname('AC07CTA').asstring := Copy(pConta.codigo,1,3);
    lQuery.parambyname('AC07NOME').asstring :=Copy( pConta.nome,1,25);
    lQuery.parambyname('AC07TIPO').asstring := Copy(pConta.tipo,1,1);
    lQuery.parambyname('AC07CC').asstring := Copy(pConta.centro_custo,1,3);
    lQuery.parambyname('AC07DP').asstring := Copy(pConta.duplicar,1,1);
    lQuery.parambyname('AC07BCO').asstring := Copy(pConta.caixa_dest,1,3);
    lQuery.parambyname('AC07CTA2').asstring := Copy(pConta.conta_dest,1,3);
    lQuery.parambyname('AC07_HISTORICO').asstring := Copy(pConta.historico,1,6);
    lQuery.parambyname('AC07DRE').asstring := Copy(pConta.dre,1,1);
    lQuery.parambyname('AN07NIVELDRE').asinteger := pConta.nivel_dre;
    lQuery.parambyname('AC07TIPOCUSTO').asstring := Copy(pConta.tipo_custo,1,1);
    lQuery.parambyname('AC07COMBUSTIVEL').asstring := Copy(pConta.combustivel,1,1);
    lQuery.parambyname('AC07SBG').asstring := Copy(pConta.subgrupo,1,6);
    lQuery.execsql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;

end;

class function TContaDAO.Carrega(pConta: Tconta): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.add(' select * from MC07CTA          ');
    lQuery.SQL.add(' where AC07CTA = :AC07CTA  ');
    lQuery.parambyname('AC07CTA').asstring := pConta.codigo;
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      // carrega dados
      pConta.nome := lQuery.FieldByName('AC07NOME').asstring;
      pConta.tipo := lQuery.FieldByName('AC07TIPO').asstring;
      pConta.centro_custo := lQuery.FieldByName('AC07CC').asstring;
      pConta.duplicar := lQuery.FieldByName('AC07DP').asstring;
      pConta.caixa_dest := lQuery.FieldByName('AC07BCO').asstring;
      pConta.conta_dest := lQuery.FieldByName('AC07CTA2').asstring;
      pConta.historico := lQuery.FieldByName('AC07_HISTORICO').asstring;
      pConta.dre := lQuery.FieldByName('AC07DRE').asstring;
      pConta.nivel_dre := lQuery.FieldByName('AN07NIVELDRE').asinteger;
      pConta.tipo_custo := lQuery.FieldByName('AC07TIPOCUSTO').asstring;
      pConta.combustivel := lQuery.FieldByName('AC07COMBUSTIVEL').asstring;
      pConta.subgrupo := lQuery.FieldByName('AC07SBG').asstring;
    end;

    Result := (lQuery.RecordCount > 0) and (lQuery.FieldByName('AC07NOME').AsString <> EmptyStr);

  finally
    lQuery.free;
  end;

end;

class function TContaDAO.Excluir(pCodigo: string; pCommit : Boolean = true): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.add(' DELETE FROM MC07CTA             ');
    lQuery.SQL.add(' where AC07CTA = :AC07CTA   ');
    lQuery.parambyname('AC07CTA').asstring := pCodigo;
    lQuery.execsql;
    lQuery.connection.commit;

  finally
    lQuery.free;
  end;

end;

class function TContaDAO.Existe(pConta: Tconta): boolean;
var
  lQuery: TQuery;
begin
  Result := false;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM MC07CTA WHERE AC07CTA = :AC07CTA');
    lQuery.ParamByName('AC07CTA').AsString := pConta.Codigo;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := True;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TContaDAO.Incluir(pConta: Tconta; pCommit : Boolean = true): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;;
    lQuery.SQL.add('    insert into MC07CTA (          ');
    lQuery.SQL.add('    AC07CTA                        ');
    lQuery.SQL.add('  , AC07NOME                       ');
    lQuery.SQL.add('  , AC07TIPO                       ');
    lQuery.SQL.add('  , AC07CC                         ');
    lQuery.SQL.add('  , AC07DP                         ');
    lQuery.SQL.add('  , AC07BCO                        ');
    lQuery.SQL.add('  , AC07CTA2                       ');
    lQuery.SQL.add('  , AC07_HISTORICO                 ');
    lQuery.SQL.add('  , AC07DRE                        ');
    lQuery.SQL.add('  , AN07NIVELDRE                   ');
    lQuery.SQL.add('  , AC07TIPOCUSTO                  ');
    lQuery.SQL.add('  , AC07COMBUSTIVEL                ');
    lQuery.SQL.add('  , AC07SBG                        ');
    lQuery.SQL.add('  )values(                         ');
    lQuery.SQL.add('    :AC07CTA                       ');
    lQuery.SQL.add('  , :AC07NOME                      ');
    lQuery.SQL.add('  , :AC07TIPO                      ');
    lQuery.SQL.add('  , :AC07CC                        ');
    lQuery.SQL.add('  , :AC07DP                        ');
    lQuery.SQL.add('  , :AC07BCO                       ');
    lQuery.SQL.add('  , :AC07CTA2                      ');
    lQuery.SQL.add('  , :AC07_HISTORICO                ');
    lQuery.SQL.add('  , :AC07DRE                       ');
    lQuery.SQL.add('  , :AN07NIVELDRE                  ');
    lQuery.SQL.add('  , :AC07TIPOCUSTO                 ');
    lQuery.SQL.add('  , :AC07COMBUSTIVEL               ');
    lQuery.SQL.add('  , :AC07SBG                       ');
    lQuery.SQL.add(' )                                 ');
    lQuery.parambyname('AC07CTA').asstring := Copy(pConta.codigo,1,3);
    lQuery.parambyname('AC07NOME').asstring :=Copy( pConta.nome,1,25);
    lQuery.parambyname('AC07TIPO').asstring := Copy(pConta.tipo,1,1);
    lQuery.parambyname('AC07CC').asstring := Copy(pConta.centro_custo,1,3);
    lQuery.parambyname('AC07DP').asstring := Copy(pConta.duplicar,1,1);
    lQuery.parambyname('AC07BCO').asstring := Copy(pConta.caixa_dest,1,3);
    lQuery.parambyname('AC07CTA2').asstring := Copy(pConta.conta_dest,1,3);
    lQuery.parambyname('AC07_HISTORICO').asstring := Copy(pConta.historico,1,6);
    lQuery.parambyname('AC07DRE').asstring := Copy(pConta.dre,1,1);
    lQuery.parambyname('AN07NIVELDRE').asinteger := pConta.nivel_dre;
    lQuery.parambyname('AC07TIPOCUSTO').asstring := Copy(pConta.tipo_custo,1,1);
    lQuery.parambyname('AC07COMBUSTIVEL').asstring := Copy(pConta.combustivel,1,1);
    lQuery.parambyname('AC07SBG').asstring := Copy(pConta.subgrupo,1,6);
    lQuery.execsql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;

end;

class function TContaDAO.Limpar(pConta: Tconta): boolean;
begin
  pConta.codigo := EmptyStr;
  pConta.nome := EmptyStr;
  pConta.tipo := EmptyStr;
  pConta.centro_custo := EmptyStr;
  pConta.duplicar := EmptyStr;
  pConta.caixa_dest := EmptyStr;
  pConta.conta_dest := EmptyStr;
  pConta.historico := EmptyStr;
  pConta.dre := EmptyStr;
  pConta.nivel_dre := 0;
  pConta.tipo_custo := EmptyStr;
  pConta.combustivel := EmptyStr;
  pConta.subgrupo := EmptyStr;
end;

end.
