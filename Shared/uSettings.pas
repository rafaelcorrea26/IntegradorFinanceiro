unit uSettings; // classe de configuração

interface

uses
  uInterfacesAPI,
  uQuery,
  System.SysUtils,
  uFunctions,
  Vcl.Dialogs,
  Vcl.ExtCtrls;

type
  TSettings = class;

  TSettings = class(TInterfacedObject, iSettings)
  private
    FUrl: String;
    FLogin: String;
    FPassword: String;
    FAccess_Token: string;
    FAccess_Token_Expires: TDateTime;
    FRefresh_Token: string;
    FRefresh_Token_Expires: TDateTime;
    FLiberadoUso: Boolean;
    FChaveEmpresa: string;
    FDataFormatada: string;
    FContadorIntegracao: integer;
    FUtilizaCP: Boolean;
    FUtilizaCR: Boolean;
    FUltimoSincCP: TDateTime;
    FUltimoSincCR: TDateTime;
    FIntervaloEnvioCP: integer;
    FIntervaloEnvioCR: integer;
    FPermiteAlterarDataSincronismoCP: Boolean;
    FPermiteAlterarDataSincronismoCR: Boolean;

    FRecebeuCR: Boolean;
    FRecebeuCP: Boolean;
    FEnviouCR: Boolean;
    FEnviouCP: Boolean;

    FTimerCP: TTimer;
    FTimerCR: TTimer;
    FTimerSt: TTimer;

    class var FSettings: TSettings;

  public
    destructor Destroy; override;
    constructor Create;
    // Geral
    property Url: String read FUrl write FUrl;
    property Login: string read FLogin write FLogin;
    property Password: string read FPassword write FPassword;
    property Access_Token: string read FAccess_Token write FAccess_Token;
    property Access_Token_Expires: TDateTime read FAccess_Token_Expires write FAccess_Token_Expires;
    property Refresh_Token: string read FRefresh_Token write FRefresh_Token;
    property Refresh_Token_Expires: TDateTime read FRefresh_Token_Expires write FRefresh_Token_Expires;
    property ChaveEmpresa: string read FChaveEmpresa write FChaveEmpresa;

    property LiberadoUso: Boolean read FLiberadoUso write FLiberadoUso;
    property ContadorIntegracao: integer read FContadorIntegracao write FContadorIntegracao;
    property DataFormatada: string read FDataFormatada write FDataFormatada;
    property UtilizaCP: Boolean read FUtilizaCP write FUtilizaCP;
    property UtilizaCR: Boolean read FUtilizaCR write FUtilizaCR;
    property IntervaloEnvioCP: integer read FIntervaloEnvioCP write FIntervaloEnvioCP;
    property IntervaloEnvioCR: integer read FIntervaloEnvioCR write FIntervaloEnvioCR;
    property UltimoSincCP: TDateTime read FUltimoSincCP write FUltimoSincCP;
    property UltimoSincCR: TDateTime read FUltimoSincCR write FUltimoSincCR;

    // Timer envio
    property TimerCP: TTimer read FTimerCP write FTimerCP;
    property TimerCR: TTimer read FTimerCR write FTimerCR;
    property TimerSt: TTimer read FTimerSt write FTimerSt;

    property PermiteAlterarDataSincronismoCP: Boolean read FPermiteAlterarDataSincronismoCP
      write FPermiteAlterarDataSincronismoCP;

    property PermiteAlterarDataSincronismoCR: Boolean read FPermiteAlterarDataSincronismoCR
      write FPermiteAlterarDataSincronismoCR;

    property RecebeuCR: Boolean read FRecebeuCR write FRecebeuCR;
    property RecebeuCP: Boolean read FRecebeuCP write FRecebeuCP;
    property EnviouCR: Boolean read FEnviouCR write FEnviouCR;
    property EnviouCP: Boolean read FEnviouCP write FEnviouCP;

    procedure Carrega;
    procedure Incluir(pEfetuarCommit: Boolean);
    procedure AlterarOuIncluir(pEfetuarCommit: Boolean);
    procedure AlterarRecebidoAPI;
    procedure Alterar(pEfetuarCommit: Boolean);
    procedure Excluir(pEfetuarCommit: Boolean);
    procedure RodaScriptTriggers;
    function ValidaCamposNecessarios: Boolean;

    // func singleton
    class procedure ReleaseMe;
    class function GetSettings: TSettings; static;
    class property Settings: TSettings read GetSettings write FSettings;
  end;

implementation

class function TSettings.GetSettings: TSettings;
begin
  if NOT Assigned(FSettings) then
  begin
    FSettings := TSettings.Create;
  end;

  result := FSettings;
end;

procedure TSettings.AlterarRecebidoAPI;
var
  lQuery: TQuery;
begin
  try
    lQuery := TQuery.Create(nil);
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' update or insert into TBL_CONFIGURACAO_FIN (       ');
      lQuery.SQL.Add('  ID                                                ');
      lQuery.SQL.Add(' ,ACCESS_TOKEN                                      ');
      lQuery.SQL.Add(' ,ACCESS_TOKEN_EXPIRES                              ');
      lQuery.SQL.Add(' ,LIBERADO_PARA_USO                                 ');
      lQuery.SQL.Add(' ,CHAVE_EMPRESA                                     ');
      lQuery.SQL.Add(' ,INTERVALO_ENVIO_CP                                ');
      lQuery.SQL.Add(' ,INTERVALO_ENVIO_CR                                ');
      lQuery.SQL.Add(' ,UTILIZA_CP                                        ');
      lQuery.SQL.Add(' ,UTILIZA_CR                                        ');
      lQuery.SQL.Add(' ) values (                                         ');
      lQuery.SQL.Add('  :ID                                               ');
      lQuery.SQL.Add(' ,:ACCESS_TOKEN                                     ');
      lQuery.SQL.Add(' ,:ACCESS_TOKEN_EXPIRES                             ');
      lQuery.SQL.Add(' ,:LIBERADO_PARA_USO                                ');
      lQuery.SQL.Add(' ,:CHAVE_EMPRESA                                    ');
      lQuery.SQL.Add(' ,:INTERVALO_ENVIO_CP                               ');
      lQuery.SQL.Add(' ,:INTERVALO_ENVIO_CR                               ');
      lQuery.SQL.Add(' ,:UTILIZA_CP                                       ');
      lQuery.SQL.Add(' ,:UTILIZA_CR                                       ');
      lQuery.SQL.Add(' ) MATCHING (ID)                                    ');
      lQuery.ParamByName('ID').AsInteger := 1;
      lQuery.ParamByName('ACCESS_TOKEN').AsString := FAccess_Token;
      lQuery.ParamByName('ACCESS_TOKEN_EXPIRES').AsDateTime := FAccess_Token_Expires;
      lQuery.ParamByName('LIBERADO_PARA_USO').AsString := TFunctions.GetSN(FLiberadoUso);
      lQuery.ParamByName('CHAVE_EMPRESA').AsString := FChaveEmpresa;
      lQuery.ParamByName('INTERVALO_ENVIO_CP').AsInteger := FIntervaloEnvioCP;
      lQuery.ParamByName('INTERVALO_ENVIO_CR').AsInteger := FIntervaloEnvioCR;
      lQuery.ParamByName('UTILIZA_CP').AsString := TFunctions.GetSN(FUtilizaCP);
      lQuery.ParamByName('UTILIZA_CR').AsString := TFunctions.GetSN(FUtilizaCR);
      lQuery.ExecSQL;

      lQuery.Connection.Commit;

    finally
      lQuery.Free;
    end;
  except
    on e: Exception do
  end;

end;

procedure TSettings.Alterar(pEfetuarCommit: Boolean);
begin

end;

procedure TSettings.AlterarOuIncluir(pEfetuarCommit: Boolean);
var
  lQuery: TQuery;
begin
  try
    lQuery := TQuery.Create(nil);
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' update or insert into TBL_CONFIGURACAO_FIN (       ');
      lQuery.SQL.Add('  ID                                                ');
      lQuery.SQL.Add(' ,ACCESS_TOKEN                                      ');
      lQuery.SQL.Add(' ,ACCESS_TOKEN_EXPIRES                              ');
      lQuery.SQL.Add(' ,LIBERADO_PARA_USO                                 ');
      lQuery.SQL.Add(' ,CHAVE_EMPRESA                                     ');
      lQuery.SQL.Add(' ,INTERVALO_ENVIO_CP                                ');
      lQuery.SQL.Add(' ,INTERVALO_ENVIO_CR                                ');
      lQuery.SQL.Add(' ,UTILIZA_CP                                        ');
      lQuery.SQL.Add(' ,UTILIZA_CR                                        ');
      lQuery.SQL.Add(' ) values (                                         ');
      lQuery.SQL.Add('  :ID                                               ');
      lQuery.SQL.Add(' ,:ACCESS_TOKEN                                     ');
      lQuery.SQL.Add(' ,:ACCESS_TOKEN_EXPIRES                             ');
      lQuery.SQL.Add(' ,:LIBERADO_PARA_USO                                ');
      lQuery.SQL.Add(' ,:CHAVE_EMPRESA                                    ');
      lQuery.SQL.Add(' ,:INTERVALO_ENVIO_CP                               ');
      lQuery.SQL.Add(' ,:INTERVALO_ENVIO_CR                               ');
      lQuery.SQL.Add(' ,:UTILIZA_CP                                       ');
      lQuery.SQL.Add(' ,:UTILIZA_CR                                       ');
      lQuery.SQL.Add(' ) MATCHING (ID)                                    ');
      lQuery.ParamByName('ID').AsInteger := 1;
      lQuery.ParamByName('ACCESS_TOKEN').AsString := FAccess_Token;
      lQuery.ParamByName('ACCESS_TOKEN_EXPIRES').AsDateTime := FAccess_Token_Expires;
      lQuery.ParamByName('LIBERADO_PARA_USO').AsString := TFunctions.GetSN(FLiberadoUso);
      lQuery.ParamByName('CHAVE_EMPRESA').AsString := FChaveEmpresa;
      lQuery.ParamByName('INTERVALO_ENVIO_CP').AsInteger := FIntervaloEnvioCP;
      lQuery.ParamByName('INTERVALO_ENVIO_CR').AsInteger := FIntervaloEnvioCR;
      lQuery.ParamByName('UTILIZA_CP').AsString := TFunctions.GetSN(FUtilizaCP);
      lQuery.ParamByName('UTILIZA_CR').AsString := TFunctions.GetSN(FUtilizaCR);
      lQuery.ExecSQL;

      if pEfetuarCommit then
      begin
        lQuery.Connection.Commit;
      end;

    finally
      lQuery.Free;
    end;
  except
    on e: Exception do
  end;

end;

procedure TSettings.Carrega;
var
  lQuery: TQuery;
begin
  try
    lQuery := TQuery.Create(nil);
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' select * from TBL_CONFIGURACAO_FIN ');
      lQuery.SQL.Add(' where id = 1                      ');
      lQuery.Open;
      lQuery.FetchAll;

      if lQuery.RecordCount = 0 then
      begin
        AlterarOuIncluir(true);
      end
      else
      begin
        // Geral
        FAccess_Token := lQuery.FieldByName('ACCESS_TOKEN').AsString;
        FAccess_Token_Expires := lQuery.FieldByName('ACCESS_TOKEN_EXPIRES').AsDateTime;
        FLiberadoUso := lQuery.FieldByName('LIBERADO_PARA_USO').AsString = 'S';
        FChaveEmpresa := lQuery.FieldByName('CHAVE_EMPRESA').AsString;
        FUltimoSincCR := lQuery.FieldByName('ULTIMA_SINC_CR').AsDateTime;
        FUltimoSincCP := lQuery.FieldByName('ULTIMA_SINC_CP').AsDateTime;
        FIntervaloEnvioCP := lQuery.FieldByName('INTERVALO_ENVIO_CP').AsInteger;
        FIntervaloEnvioCR := lQuery.FieldByName('INTERVALO_ENVIO_CR').AsInteger;
        FUtilizaCP := lQuery.FieldByName('UTILIZA_CP').AsString = 'S';
        FUtilizaCR := lQuery.FieldByName('UTILIZA_CR').AsString = 'S';
      end;

    finally
      lQuery.Free;
    end;

  except
    on e: Exception do
  end;
end;

constructor TSettings.Create;
begin
   Url := 'http://localhost:8080/api';      //  LOCAL
  Login := 'coloque_email_aqui@teste.com';
  Password := 'coloque_a_senha_aqui';

  TimerCP := TTimer.Create(nil);
  TimerCR := TTimer.Create(nil);
  TimerSt := TTimer.Create(nil);
end;

destructor TSettings.Destroy;
begin
  TimerCP.Free;
  TimerCR.Free;
  TimerSt.Free;
end;

procedure TSettings.Excluir(pEfetuarCommit: Boolean);
begin

end;

procedure TSettings.Incluir(pEfetuarCommit: Boolean);
var
  lQuery: TQuery;
begin
  try
    lQuery := TQuery.Create(nil);
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' insert into TBL_CONFIGURACAO_FIN (       ');
      lQuery.SQL.Add('  ID                                                ');
      lQuery.SQL.Add(' ,ACCESS_TOKEN                                      ');
      lQuery.SQL.Add(' ,ACCESS_TOKEN_EXPIRES                              ');
      lQuery.SQL.Add(' ,LIBERADO_PARA_USO                                 ');
      lQuery.SQL.Add(' ,CHAVE_EMPRESA                                     ');
      lQuery.SQL.Add(' ,INTERVALO_ENVIO_CP                                ');
      lQuery.SQL.Add(' ,INTERVALO_ENVIO_CR                                ');
      lQuery.SQL.Add(' ,ULTIMA_SINC_CP                                    ');
      lQuery.SQL.Add(' ,ULTIMA_SINC_CR                                    ');
      lQuery.SQL.Add(' ,UTILIZA_CP                                        ');
      lQuery.SQL.Add(' ,UTILIZA_CR                                        ');
      lQuery.SQL.Add(' ) values (                                         ');
      lQuery.SQL.Add(' :ID                                                ');
      lQuery.SQL.Add(' ,:ACCESS_TOKEN                                     ');
      lQuery.SQL.Add(' ,:ACCESS_TOKEN_EXPIRES                             ');
      lQuery.SQL.Add(' ,:LIBERADO_PARA_USO                                ');
      lQuery.SQL.Add(' ,:CHAVE_EMPRESA                                    ');
      lQuery.SQL.Add(' ,:INTERVALO_ENVIO_CP                               ');
      lQuery.SQL.Add(' ,:INTERVALO_ENVIO_CR                               ');
      lQuery.SQL.Add(' ,:ULTIMA_SINC_CP                                   ');
      lQuery.SQL.Add(' ,:ULTIMA_SINC_CR                                   ');
      lQuery.SQL.Add(' ,:UTILIZA_CP                                       ');
      lQuery.SQL.Add(' ,:UTILIZA_CR                                       ');
      lQuery.ParamByName('ID').AsInteger := 1;
      lQuery.ParamByName('ACCESS_TOKEN').AsString := FAccess_Token;
      lQuery.ParamByName('ACCESS_TOKEN_EXPIRES').AsDateTime := FAccess_Token_Expires;
      lQuery.ParamByName('LIBERADO_PARA_USO').AsString := TFunctions.GetSN(FLiberadoUso);
      lQuery.ParamByName('CHAVE_EMPRESA').AsString := FChaveEmpresa;
      lQuery.ParamByName('INTERVALO_ENVIO_CP').AsInteger := FIntervaloEnvioCP;
      lQuery.ParamByName('INTERVALO_ENVIO_CR').AsInteger := FIntervaloEnvioCR;
      lQuery.ParamByName('ULTIMA_SINC_CP').AsDateTime := FUltimoSincCP;
      lQuery.ParamByName('ULTIMA_SINC_CR').AsDateTime := FUltimoSincCR;
      lQuery.ParamByName('UTILIZA_CP').AsString := TFunctions.GetSN(FUtilizaCP);
      lQuery.ParamByName('UTILIZA_CR').AsString := TFunctions.GetSN(FUtilizaCR);
      lQuery.ExecSQL;

      if pEfetuarCommit then
      begin
        lQuery.Connection.Commit;
      end;

    finally
      lQuery.Free;
    end;
  except
    on e: Exception do
  end;
end;

class procedure TSettings.ReleaseMe;
begin
  if Assigned(FSettings) then
  begin
    FreeAndNil(FSettings);
  end;
end;

procedure TSettings.RodaScriptTriggers;
var
  lQuery: TQuery;
begin
  try
    lQuery := TQuery.Create(nil);
    try
      if not(TFunctions.TriggerValidation('TBL_INTEG_CP')) then
      begin
        lQuery.Close;
        lQuery.SQL.Clear;
        lQuery.SQL.Add('  CREATE OR ALTER TRIGGER TBL_INTEG_CP FOR CPAG                                          ');
        lQuery.SQL.Add('  ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 0                                         ');
        lQuery.SQL.Add('  AS                                                                                         ');
        lQuery.SQL.Add('  DECLARE ATUALIZAR CHAR(1);                                                                 ');
        lQuery.SQL.Add('  BEGIN                                                                                      ');
        lQuery.SQL.Add('        IF (INSERTING) THEN                                                                  ');
        lQuery.SQL.Add('        BEGIN                                                                                ');
        lQuery.SQL.Add('            UPDATE OR INSERT INTO TBL_INTEG_CP (TITULO, DATA_ATUALIZACAO, EXCLUIDO)          ');
        lQuery.SQL.Add('           VALUES (NEW.TIT, CURRENT_TIMESTAMP, ''N'') ;                                  ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('        ELSE  IF (UPDATING) THEN                                                             ');
        lQuery.SQL.Add('        BEGIN                                                                                ');
        lQuery.SQL.Add('        ATUALIZAR = ''N'';                                                                   ');
        lQuery.SQL.Add('        IF (OLD.TIT            IS NOT NULL) THEN                                         ');
        lQuery.SQL.Add('   	 BEGIN  IF  (OLD.TIT <> NEW.TIT )THEN                                            ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN IF (NEW.TIT IS NOT NULL) THEN                                                 ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.EMISSAO IS NOT NULL) THEN                                                ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.EMISSAO <> NEW.EMISSAO )THEN                                           ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN IF (NEW.EMISSAO IS NOT NULL) THEN                                             ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.VCTO IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.VCTO <> NEW.VCTO)THEN                                                  ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.VCTO IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.FLUXO IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.FLUXO <> NEW.FLUXO)THEN                                                ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.FLUXO IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.DTPGTO IS NOT NULL) THEN                                                 ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.DTPGTO <> NEW.DTPGTO)THEN                                              ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.DTPGTO IS NOT NULL)THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.ORIG IS NOT NULL)THEN                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (OLD.ORIG <> NEW.ORIG)THEN                                                   ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.ORIG IS NOT NULL)THEN                                                       ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.SIT IS NOT NULL)THEN                                                     ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.SIT <> NEW.SIT)THEN                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.SIT IS NOT NULL) THEN                                                       ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.FORNEC IS NOT NULL) THEN                                                 ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.FORNEC <> NEW.FORNEC)THEN                                              ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.FORNEC IS NOT NULL)THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.FRPGTO IS NOT NULL)THEN                                                  ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.FRPGTO <> NEW.FRPGTO)THEN                                              ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.FRPGTO IS NOT NULL)THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD._CTA IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD._CTA <> NEW._CTA)THEN                                                  ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW._CTA IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD._COD_BARRAS IS NOT NULL) THEN                                            ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD._COD_BARRAS <> NEW._COD_BARRAS)THEN                                    ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW._COD_BARRAS IS NOT NULL) THEN                                               ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.VALOR IS NOT NULL)THEN                                                   ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.VALOR <> NEW.VALOR)THEN                                                ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.VALOR IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.TOTALPAGO IS NOT NULL)THEN                                               ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.TOTALPAGO <> NEW.TOTALPAGO)THEN                                        ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.TOTALPAGO IS NOT NULL) THEN                                                 ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.VLPAGO IS NOT NULL) THEN                                                 ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.VLPAGO <> NEW.VLPAGO)THEN                                              ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.VLPAGO IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.DESC IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('   	 BEGIN  IF  (OLD.DESC <> NEW.DESC)THEN                                           ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.DESC IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.JUROS IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('   	 BEGIN  IF  (OLD.JUROS <> NEW.JUROS)THEN                                         ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.JUROS IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD._OBS1 IS NOT NULL)THEN                                                   ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD._OBS1 <> NEW._OBS1)THEN                                                ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW._OBS1 IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD._OBS2 IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD._OBS2 <> NEW._OBS2)THEN                                                ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW._OBS2 IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (ATUALIZAR = ''S'') THEN                                                          ');
        lQuery.SQL.Add('        BEGIN                                                                                ');
        lQuery.SQL.Add('        UPDATE OR INSERT INTO TBL_INTEG_CP (TITULO, DATA_ATUALIZACAO, EXCLUIDO)              ');
        lQuery.SQL.Add('        VALUES (OLD.TIT, CURRENT_TIMESTAMP, ''N'')                                       ');
        lQuery.SQL.Add('        MATCHING (TITULO);                                                                   ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('     END                                                                                     ');
        lQuery.SQL.Add('     ELSE IF (DELETING) THEN                                                                 ');
        lQuery.SQL.Add('     BEGIN                                                                                   ');
        lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CP (TITULO, DATA_ATUALIZACAO, EXCLUIDO,EMPRESA_TITULO)      ');
        lQuery.SQL.Add(' VALUES (OLD.TIT, CURRENT_TIMESTAMP, ''S'',OLD.EMP_TIT)                              ');
        lQuery.SQL.Add(' MATCHING (TITULO);                                                                          ');
        lQuery.SQL.Add(' END                                                                                         ');
        lQuery.SQL.Add(' END                                                                                         ');
        lQuery.ExecSQL;
        lQuery.Connection.Commit;
      end;

      if not(TFunctions.TriggerValidation('TBL_INTEG_CR')) then
      begin
        lQuery.Close;
        lQuery.SQL.Clear;
        lQuery.SQL.Add(' CREATE OR ALTER TRIGGER TBL_INTEG_CR FOR CREC                                           ');
        lQuery.SQL.Add('  ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 0                                         ');
        lQuery.SQL.Add('  AS                                                                                         ');
        lQuery.SQL.Add('  DECLARE ATUALIZAR CHAR(1);                                                                 ');
        lQuery.SQL.Add('  BEGIN                                                                                      ');
        lQuery.SQL.Add('      IF (INSERTING) THEN                                                                    ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      UPDATE OR INSERT INTO TBL_INTEG_CR (DUPLICATA, DATA_ATUALIZACAO, EXCLUIDO)             ');
        lQuery.SQL.Add('      VALUES (NEW.DUP, CURRENT_TIMESTAMP, ''N'') ;                                       ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      IF (UPDATING) THEN                                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''N'';                                                                     ');
        lQuery.SQL.Add('      IF (OLD.DUP IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.DUP <> NEW.DUP )THEN                                                  ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.DUP IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Cliente IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Cliente <> NEW.Cliente )THEN                                          ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Cliente IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Vend IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Vend <> NEW.Vend )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Vend IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.FrPgto IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.FrPgto <> NEW.FrPgto )THEN                                            ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.FrPgto IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.CTA IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.CTA <> NEW.CTA )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.CTA IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Emissao IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Emissao <> NEW.Emissao )THEN                                          ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Emissao IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Vcto IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Vcto <> NEW.Vcto )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Vcto IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Fluxo IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Fluxo <> NEW.Fluxo )THEN                                              ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Fluxo IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Dtpgto IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Dtpgto <> NEW.Dtpgto )THEN                                            ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Dtpgto IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.BcOr IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.BcOr <> NEW.BcOr )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.BcOr IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.BcPg IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.BcPg <> NEW.BcPg )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.BcPg IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Valor IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Valor <> NEW.Valor )THEN                                              ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Valor IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.VlPago IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.VlPago <> NEW.VlPago )THEN                                            ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.VlPago IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Juros IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Juros <> NEW.Juros )THEN                                              ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Juros IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Desc IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Desc <> NEW.Desc )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Desc IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.TotalPago IS NOT NULL) THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.TotalPago <> NEW.TotalPago )THEN                                      ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.TotalPago IS NOT NULL) THEN                                                ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.ORIG IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.ORIG <> NEW.ORIG )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.ORIG IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.SIT IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.SIT <> NEW.SIT )THEN                                                  ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.SIT IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.BxParcial IS NOT NULL) THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.BxParcial <> NEW.BxParcial )THEN                                      ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.BxParcial IS NOT NULL) THEN                                                ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (ATUALIZAR = ''S'') THEN                                                            ');
        lQuery.SQL.Add('          BEGIN                                                                              ');
        lQuery.SQL.Add('          UPDATE OR INSERT INTO TBL_INTEG_CR (DUPLICATA, DATA_ATUALIZACAO, EXCLUIDO)         ');
        lQuery.SQL.Add('          VALUES (OLD.DUP, CURRENT_TIMESTAMP, ''N'')                                     ');
        lQuery.SQL.Add('          MATCHING (DUPLICATA);                                                              ');
        lQuery.SQL.Add('          END                                                                                ');
        lQuery.SQL.Add('     END                                                                                     ');
        lQuery.SQL.Add('     ELSE IF (DELETING) THEN                                                                 ');
        lQuery.SQL.Add('     BEGIN                                                                                   ');
        lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CR (DUPLICATA,DATA_ATUALIZACAO,EXCLUIDO,DUPLICATA_EMPRESA)  ');
        lQuery.SQL.Add(' VALUES (OLD.DUP, CURRENT_TIMESTAMP, ''S'', OLD.EMP_DUP)                             ');
        lQuery.SQL.Add(' MATCHING (DUPLICATA);                                                                       ');
        lQuery.SQL.Add(' END                                                                                         ');
        lQuery.SQL.Add(' END                                                                                         ');
        lQuery.ExecSQL;
        lQuery.Connection.Commit;

      end;

      ShowMessage('Trigger CP e CR criadas com sucesso!');
    finally
      lQuery.Free;
    end;

  except
    on e: Exception do
      ShowMessage('Problemas ao salvar a configuração.');
  end;
end;

function TSettings.ValidaCamposNecessarios: Boolean;
var
  lUrl, lChave, lToken, lLiberado, lValidacod: Boolean;
begin
  lUrl := (trim(FUrl) <> '');
  lChave := (trim(FChaveEmpresa) <> '');
  lToken := (trim(FAccess_Token) <> '');
  lLiberado := (FLiberadoUso);
  lValidacod := (TFunctions.ValidaCodigoEChaveEmpresa);

  result := lUrl and lChave and lToken and lLiberado and lValidacod;
end;

end.
