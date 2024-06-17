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
    lQuery.SQL.add(' UPDATE  CTA SET                         ');
    lQuery.SQL.add('   NOME = :NOME                      ');
    lQuery.SQL.add(' , TIPO = :TIPO                      ');
    lQuery.SQL.add(' , CC = :CC                          ');
    lQuery.SQL.add(' , DP = :DP                          ');
    lQuery.SQL.add(' , BCO = :BCO                        ');
    lQuery.SQL.add(' , CTA2 = :CTA2                      ');
    lQuery.SQL.add(' , HISTORICO = :HISTORICO          ');
    lQuery.SQL.add(' , DRE = :DRE                        ');
    lQuery.SQL.add(' , NIVELDRE = :NIVELDRE              ');
    lQuery.SQL.add(' , TIPOCUSTO = :TIPOCUSTO            ');
    lQuery.SQL.add(' , COMBUSTIVEL = :COMBUSTIVEL        ');
    lQuery.SQL.add(' , SBG = :SBG                        ');
    lQuery.SQL.add(' where (CTA = :CTA)                  ');
    lQuery.parambyname('CTA').asstring := Copy(pConta.codigo,1,3);
    lQuery.parambyname('NOME').asstring :=Copy( pConta.nome,1,25);
    lQuery.parambyname('TIPO').asstring := Copy(pConta.tipo,1,1);
    lQuery.parambyname('CC').asstring := Copy(pConta.centro_custo,1,3);
    lQuery.parambyname('DP').asstring := Copy(pConta.duplicar,1,1);
    lQuery.parambyname('BCO').asstring := Copy(pConta.caixa_dest,1,3);
    lQuery.parambyname('CTA2').asstring := Copy(pConta.conta_dest,1,3);
    lQuery.parambyname('HISTORICO').asstring := Copy(pConta.historico,1,6);
    lQuery.parambyname('DRE').asstring := Copy(pConta.dre,1,1);
    lQuery.parambyname('NIVELDRE').asinteger := pConta.nivel_dre;
    lQuery.parambyname('TIPOCUSTO').asstring := Copy(pConta.tipo_custo,1,1);
    lQuery.parambyname('COMBUSTIVEL').asstring := Copy(pConta.combustivel,1,1);
    lQuery.parambyname('SBG').asstring := Copy(pConta.subgrupo,1,6);
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
    lQuery.SQL.add(' select * from CTA          ');
    lQuery.SQL.add(' where CTA = :CTA  ');
    lQuery.parambyname('CTA').asstring := pConta.codigo;
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      // carrega dados
      pConta.nome := lQuery.FieldByName('NOME').asstring;
      pConta.tipo := lQuery.FieldByName('TIPO').asstring;
      pConta.centro_custo := lQuery.FieldByName('CC').asstring;
      pConta.duplicar := lQuery.FieldByName('DP').asstring;
      pConta.caixa_dest := lQuery.FieldByName('BCO').asstring;
      pConta.conta_dest := lQuery.FieldByName('CTA2').asstring;
      pConta.historico := lQuery.FieldByName('HISTORICO').asstring;
      pConta.dre := lQuery.FieldByName('DRE').asstring;
      pConta.nivel_dre := lQuery.FieldByName('NIVELDRE').asinteger;
      pConta.tipo_custo := lQuery.FieldByName('TIPOCUSTO').asstring;
      pConta.combustivel := lQuery.FieldByName('COMBUSTIVEL').asstring;
      pConta.subgrupo := lQuery.FieldByName('SBG').asstring;
    end;

    Result := (lQuery.RecordCount > 0) and (lQuery.FieldByName('NOME').AsString <> EmptyStr);

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
    lQuery.SQL.add(' DELETE FROM CTA             ');
    lQuery.SQL.add(' where CTA = :CTA   ');
    lQuery.parambyname('CTA').asstring := pCodigo;
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
    lQuery.SQL.Add('SELECT * FROM CTA WHERE CTA = :CTA');
    lQuery.ParamByName('CTA').AsString := pConta.Codigo;
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
    lQuery.SQL.add('    insert into CTA (          ');
    lQuery.SQL.add('    CTA                        ');
    lQuery.SQL.add('  , NOME                       ');
    lQuery.SQL.add('  , TIPO                       ');
    lQuery.SQL.add('  , CC                         ');
    lQuery.SQL.add('  , DP                         ');
    lQuery.SQL.add('  , BCO                        ');
    lQuery.SQL.add('  , CTA2                       ');
    lQuery.SQL.add('  , HISTORICO                 ');
    lQuery.SQL.add('  , DRE                        ');
    lQuery.SQL.add('  , NIVELDRE                   ');
    lQuery.SQL.add('  , TIPOCUSTO                  ');
    lQuery.SQL.add('  , COMBUSTIVEL                ');
    lQuery.SQL.add('  , SBG                        ');
    lQuery.SQL.add('  )values(                         ');
    lQuery.SQL.add('    :CTA                       ');
    lQuery.SQL.add('  , :NOME                      ');
    lQuery.SQL.add('  , :TIPO                      ');
    lQuery.SQL.add('  , :CC                        ');
    lQuery.SQL.add('  , :DP                        ');
    lQuery.SQL.add('  , :BCO                       ');
    lQuery.SQL.add('  , :CTA2                      ');
    lQuery.SQL.add('  , :HISTORICO                ');
    lQuery.SQL.add('  , :DRE                       ');
    lQuery.SQL.add('  , :NIVELDRE                  ');
    lQuery.SQL.add('  , :TIPOCUSTO                 ');
    lQuery.SQL.add('  , :COMBUSTIVEL               ');
    lQuery.SQL.add('  , :SBG                       ');
    lQuery.SQL.add(' )                                 ');
    lQuery.parambyname('CTA').asstring := Copy(pConta.codigo,1,3);
    lQuery.parambyname('NOME').asstring :=Copy( pConta.nome,1,25);
    lQuery.parambyname('TIPO').asstring := Copy(pConta.tipo,1,1);
    lQuery.parambyname('CC').asstring := Copy(pConta.centro_custo,1,3);
    lQuery.parambyname('DP').asstring := Copy(pConta.duplicar,1,1);
    lQuery.parambyname('BCO').asstring := Copy(pConta.caixa_dest,1,3);
    lQuery.parambyname('CTA2').asstring := Copy(pConta.conta_dest,1,3);
    lQuery.parambyname('HISTORICO').asstring := Copy(pConta.historico,1,6);
    lQuery.parambyname('DRE').asstring := Copy(pConta.dre,1,1);
    lQuery.parambyname('NIVELDRE').asinteger := pConta.nivel_dre;
    lQuery.parambyname('TIPOCUSTO').asstring := Copy(pConta.tipo_custo,1,1);
    lQuery.parambyname('COMBUSTIVEL').asstring := Copy(pConta.combustivel,1,1);
    lQuery.parambyname('SBG').asstring := Copy(pConta.subgrupo,1,6);
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
