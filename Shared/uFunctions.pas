unit uFunctions; // classe geral de funções

interface

uses
  System.SysUtils,
  Winapi.Windows,
  Vcl.Forms,
  uQuery,
  uConnection,
  System.Win.Registry,
  Vcl.Dialogs,
  System.Classes,
  System.NetEncoding,
  System.DateUtils,
  System.StrUtils,
  System.IniFiles;

type
  TFunctions = class;

  TFunctions = class
  private

  public
    destructor Destroy; override;
    constructor Create;

    // Func API/Integrador
    class procedure AtualizaDataUltimaConexaoCP(pDateTime: TDateTime);
    class procedure AtualizaDataUltimaConexaoCR(pDateTime: TDateTime);
    class procedure AtualizaComoEnviadaTabelaAuxCP(pTitle: string; pLastDateAtt: TDateTime);
    class procedure AtualizaComoEnviadaTabelaAuxCR(pDuplicata: string; pLastDateAtt: TDateTime);
    class function AtualizaCPParaReenvio(pTitle: string): Boolean;
    class function AtualizaCRParaReenvio(pDuplicata: String): Boolean;

    class function VersaoSistema: string;
    class function RetornaNomeEmpresa: string;
    class function RetornaChaveEmpresa(pCodigoEmp: string): string;
    class function RetornaCodigoEmpresa: string;
    class function RetornaChaveEmpresaTitulo(pTitulo: String): string;
    class function RetornaChaveEmpresaDuplicata(pDuplicata: String): string;
    class function RetornaUltimoSincCP: TDateTime;
    class function RetornaUltimoSincCR: TDateTime;
    class function RetornaChavePelaConfig2000: String;

    class function AtualizaContaPagarComoEnviado(pTitulo: string; pLastDateAtt: TDateTime): Boolean;
    class function AtualizaContaReceberComoEnviado(pDuplicata: string; pLastDateAtt: TDateTime): Boolean;
    class function AtualizaTituloEmpresaCP(pTitulo: string): Boolean;
    class function AtualizaDuplicataEmpresaCR(pDuplicata: string): Boolean;
    class function GravaCodigoEChaveEmpresa(pCNPJ, pCodigoEmpresa, pChave: string): Boolean;
    class function ValidaCodigoEChaveEmpresa: Boolean;

    // Func Decodificar Datas
    class function DecodeDateHour: string;
    class function DecodeDateHourJson(pDate: TDateTime): string;
    class function DecodeDateJson(pDate: TDateTime): string;
    class function DecodeStrDateForJson(pDate: string): string;
    class function DecodeStringToDate(pDate: string): TDateTime;

    // func gerais
    class procedure CreateFileTxtLog(pJson, pNameTXT: string);
    class procedure RegisterAppOnWindows(pProgram: string);

    class function DateServer: TDateTime;
    class function IsDigit(pString: string): Boolean;

    class function LengthString(pString: string; pLength: Integer): string;
    class function ReturnAutorizationBase64String(pPassword: String): string;
    class function FormatDateToString(pData: TDateTime): string;
    class function TriggerValidation(pNameTrigger: string): Boolean;

    class function RemoveCharac(aText: string; aOld: String = ''; aNew: String = '';
      aRemoveTrim: Boolean = false): string;

    class function CheckItsOkConfigAPI: Boolean;
    class function ThereWasMovementInTheAPIConnection: Boolean;
    class function GetSN(pBoolean: Boolean): string;
    class function readJson(pType: string = 'cr'): String;
    class function writeJson(pType: string = 'cr'; pJson: String = ''): Boolean;
    class function ColumnExists(pColumn, pJson: string): Boolean;
    class function ObjectIsNull(pObject, pJson: string): Boolean;
    class function RemoveCaracteres(aTexto: string): string;

  end;

implementation

class procedure TFunctions.CreateFileTxtLog(pJson, pNameTXT: string);
var
  FBackupTxt: TStringList;
  lPublicAppDirectory, lFileNameTxt, lFullPathFile: string;
begin
  FBackupTxt := TStringList.Create;
  try
    FBackupTxt.Text := pJson;
    lPublicAppDirectory := ExtractFilePath(application.exeName) + 'Log_Erros\';
    lFileNameTxt := pNameTXT + '_' + DecodeDateHour + '.txt';
    lFullPathFile := lPublicAppDirectory + lFileNameTxt;

    if not DirectoryExists(lPublicAppDirectory) then
    begin
      ForceDirectories(lPublicAppDirectory);
    end;

    if DirectoryExists(lPublicAppDirectory) then
    begin
      FBackupTxt.SaveToFile(lFullPathFile);
    end;
  finally
    FBackupTxt.Free;
  end;
end;

class procedure TFunctions.RegisterAppOnWindows(pProgram: string);
var
  REG: TRegistry;
begin
  REG := TRegistry.Create;
  try
    REG.RootKey := HKEY_CURRENT_USER;
    REG.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\', true);
    REG.WriteString(pProgram, ParamStr(0));
    REG.CloseKey;
    ShowMessage('Programa adicionado na inicialização do Windows com sucesso!');
  finally
    REG.Free;
  end;
end;

class function TFunctions.RemoveCaracteres(aTexto: string): string;
const
  // Lista de Caracteres Extras
  xCarExt: array [1 .. 55] of string = ('<', '>', '!', '@', '#', '$', '%', '¨', '&', '*', '(', ')', '_', '+', '=', '{',
    '}', '[', ']', '?', ';', ':', ',', '|', '*', '"', '~', '^', '´', '`', '¨', 'æ', 'Æ', 'ø', '£', 'Ø', 'ƒ', 'ª', 'º',
    '¿', '®', '½', '¼', 'ß', 'µ', 'þ', 'ý', 'Ý', '÷', '×', '€', '-', '\', '/', '.');
var
  xTexto: string;
  i: Integer;
begin
  xTexto := aTexto;

  for i := 1 to 55 do
  begin
    xTexto := StringReplace(xTexto, xCarExt[i], '', [rfReplaceAll]);
  end;

  result := xTexto;

end;

class function TFunctions.RemoveCharac(aText, aOld, aNew: String; aRemoveTrim: Boolean): string;
const
  xCarExt: array [1 .. 55] of string = ('<', '>', '!', '@', '#', '$', '%', '¨', '&', '*', '(', ')', '_', '+', '=', '{',
    '}', '[', ']', '?', ';', ':', ',', '|', '*', '"', '~', '^', '´', '`', '¨', 'æ', 'Æ', 'ø', '£', 'Ø', 'ƒ', 'ª', 'º',
    '¿', '®', '½', '¼', 'ß', 'µ', 'þ', 'ý', 'Ý', '÷', '×', '€', '-', '\', '/', '.');
var
  xTexto: string;
  i: Integer;
begin
  xTexto := aText;

  for i := 1 to 55 do
  begin
    xTexto := UpperCase(StringReplace(xTexto, UpperCase(xCarExt[i]), '', [rfReplaceAll]));
  end;

  if (aOld <> EmptyStr) and (aNew <> EmptyStr) then
  begin
    xTexto := UpperCase(StringReplace(xTexto, UpperCase(aOld), aNew, [rfReplaceAll]));
  end;

  if aRemoveTrim then
  begin
    xTexto := StringReplace(xTexto, ' ', '', [rfReplaceAll]);
  end;

  result := UpperCase(xTexto);

end;

class function TFunctions.CheckItsOkConfigAPI: Boolean;
begin

end;

constructor TFunctions.Create;
begin
end;

class function TFunctions.FormatDateToString(pData: TDateTime): string;
var
  lData: string;
begin
  lData := FormatDateTime('mm/dd/yyyy', (pData));
  result := lData;

end;

class function TFunctions.GetSN(pBoolean: Boolean): string;
begin
  result := IfThen(pBoolean, 'S', 'N');
end;

class function TFunctions.GravaCodigoEChaveEmpresa(pCNPJ, pCodigoEmpresa, pChave: string): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE PROP  SET           ');
    lQuery.SQL.Add('  CHAVE = :CHAVE      ');
    lQuery.SQL.Add(' ,CODI_INT = :CODI_INT  ');
    lQuery.SQL.Add(' WHERE CNPJ = :CNPJ     ');
    lQuery.ParamByName('CHAVE').AsSTRING := pChave;
    lQuery.ParamByName('CNPJ').AsSTRING := pCNPJ;
    lQuery.ParamByName('CODI_INT').AsSTRING := pCodigoEmpresa;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.DateServer: TDateTime;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT ');
    lQuery.SQL.Add('   CURRENT_TIMESTAMP ');
    lQuery.SQL.Add(' FROM RDB$DATABASE ');
    lQuery.Open;

    result := lQuery.FieldByName('CURRENT_TIMESTAMP').AsDateTime;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.DecodeDateHour: string;
var
  lYear, lMonth, lDay, lHour, lMin, lSec, lMilisec: Word;
begin
  // "2021-11-17 20:21:56"
  decodedatetime(now, lYear, lMonth, lDay, lHour, lMin, lSec, lMilisec);
  result := lYear.ToString + FormatFloat('00', lMonth) + FormatFloat('00', lDay) + FormatFloat('00', lHour) +
    FormatFloat('00', lMin) + FormatFloat('00', lSec);

end;

class function TFunctions.DecodeDateHourJson(pDate: TDateTime): string;
var
  lYear, lMonth, lDay, lHour, lMin, lSec, lMilisec: Word;
begin
  // "2021-11-17 20:21:56"
  decodedatetime(pDate, lYear, lMonth, lDay, lHour, lMin, lSec, lMilisec);
  result := lYear.ToString + '-' + FormatFloat('00', lMonth) + '-' + FormatFloat('00', lDay) + ' ' +
    FormatFloat('00', lHour) + ':' + FormatFloat('00', lMin) + ':' + FormatFloat('00', lSec);

end;

class function TFunctions.DecodeStrDateForJson(pDate: string): string;
var
  lYear, lMonth, lDay: Word;
  lData: TDate;
begin
  if trim(pDate) <> EmptyStr then
  begin
    lData := StrToDatedef(pDate, now);
    DecodeDate(lData, lYear, lMonth, lDay);
    result := lYear.ToString + '-' + FormatFloat('00', lMonth) + '-' + FormatFloat('00', lDay);
  end;

end;

class function TFunctions.DecodeDateJson(pDate: TDateTime): string;
var
  lYear, lMonth, lDay: Word;
begin
  DecodeDate(pDate, lYear, lMonth, lDay);
  result := lYear.ToString + '-' + FormatFloat('00', lMonth) + '-' + FormatFloat('00', lDay);

end;

class function TFunctions.DecodeStringToDate(pDate: string): TDateTime;
var
  lDate, lDay, lMonth, lYear, lTime: string;
begin
  // "date_expiration_access_token": "2021-03-04 18:26:01",
  // "date_expiration_refresh_token": "2021-04-03 15:26:01",
  // "date_activated": "2021-03-04 15:26:01",

  pDate := StringReplace(pDate, '-', '', [rfReplaceAll]);

  lDay := Copy(pDate, 7, 2);
  lMonth := Copy(pDate, 5, 2);
  lYear := Copy(pDate, 1, 4);
  lTime := Copy(pDate, 9, 9);
  lDate := lDay + '/' + lMonth + '/' + lYear + ' ' + lTime;
  result := StrToDateTimedef(lDate, now);

end;

destructor TFunctions.Destroy;
begin
  inherited;
end;

class function TFunctions.IsDigit(pString: string): Boolean;
begin
  result := true;
  Try
    strtoint(pString);
  Except
    result := false;
  end;
end;

class function TFunctions.LengthString(pString: string; pLength: Integer): string;
begin
  result := Copy(pString, 1, pLength);
end;

class function TFunctions.ObjectIsNull(pObject, pJson: string): Boolean;
var
  lObjeto: string;
begin
  lObjeto := '"' + pObject + '":{';
  result := not(Pos(trim(lObjeto), trim(pJson)) > 0);
end;

class function TFunctions.readJson(pType: string = 'cr'): String;
var
  lArquivoIni: TIniFile;
  lFullNameFile, lNameFile: string;
begin
  lNameFile := 'json.ini';
  lFullNameFile := ExtractFilePath(application.exeName) + lNameFile;

  if FileExists(lFullNameFile) then
  begin
    lArquivoIni := TIniFile.Create(lFullNameFile);

    try
      result := lArquivoIni.ReadString('json', pType, result);
    finally
      lArquivoIni.Free;
    end;
  end;
end;

class function TFunctions.ReturnAutorizationBase64String(pPassword: String): string;
var
  lTexto, lResult: string;
  Base64: TBase64Encoding;
begin

  try
    Base64 := TBase64Encoding.Create;
    lResult := Base64.decode(lTexto);
    lResult := Copy(lResult, 35, lResult.Length);

    result := lResult;
  except
    on E: Exception do
    begin
      result := pPassword;
    end;
  end;

end;

class function TFunctions.RetornaChaveEmpresa(pCodigoEmp: string): string;
var
  lQuery: TQuery;
begin

  if trim(pCodigoEmp) <> EmptyStr then
  begin
    lQuery := TQuery.Create(nil);
    try

      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' SELECT * FROM PROP              ');
      lQuery.SQL.Add(' WHERE CODI_INT = :CODI_INT  ');
      lQuery.ParamByName('CODI_INT').AsSTRING := pCodigoEmp;
      lQuery.Open;

      if (lQuery.recordcount) > 0 then
      begin
        result := lQuery.FieldByName('CHAVE').AsSTRING;
      end;

    finally
      lQuery.Free;
    end;
  end;

end;

class function TFunctions.RetornaChavePelaConfig2000: String;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT * FROM CONFIG      ');
    lQuery.Open;
    result := lQuery.FieldByName('MC_CHAVE_REGISTRO').AsSTRING;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.RetornaCodigoEmpresa: string;
var
  lQuery: TQuery;
  lChave: string;
begin
  lQuery := TQuery.Create(nil);
  try
    result := EmptyStr;
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('  SELECT CHAVE_EMPRESA FROM TBL_CONFIGURACAO_FIN  ');
    lQuery.Open;
    lQuery.FetchAll;

    if lQuery.recordcount > 0 then
    begin
      lChave := lQuery.FieldByName('CHAVE_EMPRESA').AsSTRING;
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add('  SELECT CODI_INT FROM PROP    ');
      lQuery.SQL.Add('  where   CHAVE = :CHAVE     ');
      lQuery.ParamByName('CHAVE').AsSTRING := lChave;
      lQuery.Open;
      lQuery.FetchAll;

      result := lQuery.FieldByName('CODI_INT').AsSTRING;
    end;
  finally
    lQuery.Free;
  end;
end;

class function TFunctions.RetornaChaveEmpresaDuplicata(pDuplicata: String): string;
var
  lQuery: TQuery;
  lChave: string;
  lNovaChave: string;
begin
  lQuery := TQuery.Create(nil);

  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT CHAVE_EMPRESA from TBL_CONFIGURACAO_FIN ');
    lQuery.SQL.Add(' where ID = 1                                   ');
    lQuery.Open;
    lChave := lQuery.FieldByName('CHAVE_EMPRESA').AsSTRING;

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT DUP from CREC ');
    lQuery.SQL.Add(' where DUP = :DUP     ');
    lQuery.ParamByName('DUP').AsSTRING := pDuplicata;
    lQuery.Open;

    if lQuery.recordcount > 0 then
    begin
      if (Copy(lQuery.FieldByName('DUP').AsSTRING, 1, 3) = 'INT') then
      begin
        lNovaChave := RetornaChaveEmpresa(Copy(lQuery.FieldByName('DUP').AsSTRING, 4, 1));
      end
    end;

    if trim(lNovaChave) <> EmptyStr then
    begin
      lChave := lNovaChave;
    end;

    result := lChave;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.RetornaChaveEmpresaTitulo(pTitulo: String): string;
var
  lQuery: TQuery;
  lChave, lNovaChave: string;
begin
  lQuery := TQuery.Create(nil);

  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT CHAVE_EMPRESA from TBL_CONFIGURACAO_FIN ');
    lQuery.SQL.Add(' where ID = 1                                   ');
    lQuery.Open;
    lChave := lQuery.FieldByName('CHAVE_EMPRESA').AsSTRING;

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT TIT from CPAG ');
    lQuery.SQL.Add(' where TIT = :TIT     ');
    lQuery.ParamByName('TIT').AsSTRING := pTitulo;
    lQuery.Open;

    if lQuery.recordcount > 0 then
    begin
      if (Copy(lQuery.FieldByName('TIT').AsSTRING, 1, 3) = 'INT') then
      begin
        lNovaChave := RetornaChaveEmpresa(Copy(lQuery.FieldByName('TIT').AsSTRING, 4, 1));
      end
    end;

    if trim(lNovaChave) <> EmptyStr then
    begin
      lChave := lNovaChave;
    end;

    result := lChave;
  finally
    lQuery.Free;
  end;
end;

class function TFunctions.RetornaNomeEmpresa: string;
var
  lQuery: TQuery;
  lCodigo: string;
begin

  lCodigo := RetornaCodigoEmpresa;

  if trim(lCodigo) <> EmptyStr then
  begin
    lQuery := TQuery.Create(nil);
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' SELECT * FROM PROP      ');
      lQuery.SQL.Add(' WHERE CODI_INT = :CODI_INT  ');
      lQuery.ParamByName('CODI_INT').AsSTRING := lCodigo;
      lQuery.Open;

      result := 'Empresa: ' + lQuery.FieldByName('CODI').AsSTRING + ' - ' + lQuery.FieldByName('NOME').AsSTRING;
    finally
      lQuery.Free;
    end;
  end;
end;

class function TFunctions.RetornaUltimoSincCP: TDateTime;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Open(' SELECT * FROM TBL_CONFIGURACAO_FIN WHERE ID = 1');
    result := lQuery.FieldByName('ULTIMA_SINC_CP').AsDateTime;
  finally
    lQuery.Free;
  end;
end;

class function TFunctions.RetornaUltimoSincCR: TDateTime;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Open(' SELECT * FROM TBL_CONFIGURACAO_FIN WHERE ID = 1');
    result := lQuery.FieldByName('ULTIMA_SINC_CR').AsDateTime;
  finally
    lQuery.Free;
  end;
end;

class function TFunctions.ValidaCodigoEChaveEmpresa: Boolean;
var
  lQuery: TQuery;
begin
  try
    lQuery := TQuery.Create(nil);
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT * FROM PROP                                                        ');
    lQuery.SQL.Add('where ((CHAVE is null) or (CHAVE = '''') or (CODI_INT is null)) ');
    lQuery.Open;
    result := lQuery.recordcount = 0;
  finally
    lQuery.Free;
  end;
end;

class function TFunctions.VersaoSistema: string;
var
  VerInfoSize, VerValueSize, Dummy: DWORD;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
  V1, V2, V3: Word;
  cV1, cV2, cV3: string;
  FileName: string;
begin
  FileName := application.exeName;
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    V1 := dwFileVersionMS shr 16;
    V2 := dwFileVersionMS and $FFFF;
    V3 := dwFileVersionLS shr 16;
    // V4 := dwFileVersionLS and $FFFF;
  end;
  FreeMem(VerInfo, VerInfoSize);

  cV1 := IntToStr(V1);
  cV2 := IntToStr(V2);
  cV3 := IntToStr(V3);
  result := cV1 + '.' + cV2 + '.' + cV3;

end;

class function TFunctions.ThereWasMovementInTheAPIConnection: Boolean;
begin

end;

class function TFunctions.TriggerValidation(pNameTrigger: string): Boolean;
var
  lQuery: TQuery;
begin

  lQuery := TQuery.Create(nil);
  try
    result := false;

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT * FROM RDB$TRIGGERS                                            ');
    lQuery.SQL.Add(' WHERE UPPER(RDB$TRIGGER_NAME) = UPPER(' + QuotedStr(pNameTrigger) + ')');
    lQuery.Open;
    lQuery.FetchAll;

    if lQuery.recordcount > 0 then
    begin
      result := true;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.AtualizaContaPagarComoEnviado(pTitulo: string; pLastDateAtt: TDateTime): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Connection := TConnection.ObjectConnection.Connection;
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CP (       ');
    lQuery.SQL.Add(' TITULO,EXCLUIDO,ENVIADO, DATA_ATUALIZACAO  ');
    lQuery.SQL.Add(' )VALUES(                                   ');
    lQuery.SQL.Add(' :TITULO,''N'' ,''S'',:DATA_ATUALIZACAO)    ');
    lQuery.SQL.Add(' MATCHING (TITULO);                         ');
    lQuery.ParamByName('TITULO').AsSTRING := pTitulo;
    lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime := IncMinute(pLastDateAtt, -1);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.AtualizaContaReceberComoEnviado(pDuplicata: string; pLastDateAtt: TDateTime): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CR (       ');
    lQuery.SQL.Add(' DUPLICATA,EXCLUIDO,ENVIADO, DATA_ATUALIZACAO  ');
    lQuery.SQL.Add(' )VALUES(                                   ');
    lQuery.SQL.Add(' :DUPLICATA,''N'' ,''S'',:DATA_ATUALIZACAO)    ');
    lQuery.SQL.Add(' MATCHING (DUPLICATA);                         ');
    lQuery.ParamByName('DUPLICATA').AsSTRING := pDuplicata;
    lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime := IncMinute(pLastDateAtt, -1);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.AtualizaCPParaReenvio(pTitle: string): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CP (       ');
    lQuery.SQL.Add(' TITULO,EXCLUIDO,ENVIADO,DATA_ATUALIZACAO)  ');
    lQuery.SQL.Add(' VALUES (                                   ');
    lQuery.SQL.Add(' :TITULO,''N'' ,''N'',:DATA_ATUALIZACAO)    ');
    lQuery.SQL.Add(' MATCHING (TITULO);                         ');
    lQuery.ParamByName('TITULO').AsSTRING := pTitle;
    lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime := IncMinute(RetornaUltimoSincCP, 1);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.AtualizaTituloEmpresaCP(pTitulo: string): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' update CPAG                               ');
    lQuery.SQL.Add(' set EMP_TIT = :EMP_TIT                ');
    lQuery.SQL.Add(' WHERE TIT = :TIT                      ');
    lQuery.ParamByName('TIT').AsSTRING := pTitulo;
    lQuery.ParamByName('EMP_TIT').AsSTRING := RetornaCodigoEmpresa + '-' + pTitulo;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.AtualizaDuplicataEmpresaCR(pDuplicata: string): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' update CREC                               ');
    lQuery.SQL.Add(' set EMP_DUP = :EMP_DUP                ');
    lQuery.SQL.Add(' WHERE DUP = :DUP                      ');
    lQuery.ParamByName('DUP').AsSTRING := pDuplicata;
    lQuery.ParamByName('EMP_DUP').AsSTRING := RetornaCodigoEmpresa + '-' + pDuplicata;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class function TFunctions.AtualizaCRParaReenvio(pDuplicata: String): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CR (       ');
    lQuery.SQL.Add(' DUPLICATA,EXCLUIDO,ENVIADO,DATA_ATUALIZACAO)  ');
    lQuery.SQL.Add(' VALUES (                                   ');
    lQuery.SQL.Add(' :DUPLICATA,''N'' ,''N'',:DATA_ATUALIZACAO)    ');
    lQuery.SQL.Add(' MATCHING (DUPLICATA);                         ');
    lQuery.ParamByName('DUPLICATA').AsSTRING := pDuplicata;
    lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime := IncMinute(RetornaUltimoSincCR, 1);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class procedure TFunctions.AtualizaDataUltimaConexaoCP(pDateTime: TDateTime);
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_CONFIGURACAO_FIN    ');
    lQuery.SQL.Add(' (ID, ULTIMA_SINC_CP)                          ');
    lQuery.SQL.Add(' VALUES (1 , :ULTIMA_SINC_CP)                  ');
    lQuery.SQL.Add(' MATCHING (ID)                                 ');
    lQuery.ParamByName('ULTIMA_SINC_CP').AsDateTime := pDateTime;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class procedure TFunctions.AtualizaDataUltimaConexaoCR(pDateTime: TDateTime);
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_CONFIGURACAO_FIN    ');
    lQuery.SQL.Add(' (ID, ULTIMA_SINC_CR)                          ');
    lQuery.SQL.Add(' VALUES (1 , :ULTIMA_SINC_CR)                  ');
    lQuery.SQL.Add(' MATCHING (ID)                                 ');
    lQuery.ParamByName('ULTIMA_SINC_CR').AsDateTime := pDateTime;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;

end;

class procedure TFunctions.AtualizaComoEnviadaTabelaAuxCP(pTitle: string; pLastDateAtt: TDateTime);
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Connection := TConnection.ObjectConnection.Connection;
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' update TBL_INTEG_CP set               ');
    lQuery.SQL.Add(' ENVIADO = ''S'',                      ');
    lQuery.SQL.Add(' DATA_ATUALIZACAO = :DATA_ATUALIZACAO  ');
    lQuery.SQL.Add(' where (TITULO = :TITULO)              ');
    lQuery.ParamByName('TITULO').AsSTRING := pTitle;
    lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime := IncMinute(pLastDateAtt, -1);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class procedure TFunctions.AtualizaComoEnviadaTabelaAuxCR(pDuplicata: string; pLastDateAtt: TDateTime);
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Connection := TConnection.ObjectConnection.Connection;
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' update TBL_INTEG_CR set               ');
    lQuery.SQL.Add(' ENVIADO = ''S'',                      ');
    lQuery.SQL.Add(' DATA_ATUALIZACAO = :DATA_ATUALIZACAO  ');
    lQuery.SQL.Add(' where (DUPLICATA = :DUPLICATA)              ');
    lQuery.ParamByName('DUPLICATA').AsSTRING := pDuplicata;
    lQuery.ParamByName('DATA_ATUALIZACAO').AsDateTime := IncMinute(pLastDateAtt, -1);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TFunctions.ColumnExists(pColumn, pJson: string): Boolean;
begin
  result := Pos('"' + pColumn + '":', pJson) > 0
end;

class function TFunctions.writeJson(pType: string = 'cr'; pJson: String = ''): Boolean;
var
  lArquivoIni: TIniFile;
  lFullNameFile, lNameFile: string;
begin
  lNameFile := 'json.ini';
  lFullNameFile := ExtractFilePath(application.exeName) + lNameFile;

  lArquivoIni := TIniFile.Create(lFullNameFile);
  try
    lArquivoIni.WriteString('json', pType, pJson);
  finally
    lArquivoIni.Free;
  end;

end;

end.
