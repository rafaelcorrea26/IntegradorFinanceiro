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
  Login := 'cloque_email_aqui@teste.com';
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
        lQuery.SQL.Add('  CREATE OR ALTER TRIGGER TBL_INTEG_CP FOR MC08CPAG                                          ');
        lQuery.SQL.Add('  ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 0                                         ');
        lQuery.SQL.Add('  AS                                                                                         ');
        lQuery.SQL.Add('  DECLARE ATUALIZAR CHAR(1);                                                                 ');
        lQuery.SQL.Add('  BEGIN                                                                                      ');
        lQuery.SQL.Add('        IF (INSERTING) THEN                                                                  ');
        lQuery.SQL.Add('        BEGIN                                                                                ');
        lQuery.SQL.Add('            UPDATE OR INSERT INTO TBL_INTEG_CP (TITULO, DATA_ATUALIZACAO, EXCLUIDO)          ');
        lQuery.SQL.Add('           VALUES (NEW.AC08TIT, CURRENT_TIMESTAMP, ''N'') ;                                  ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('        ELSE  IF (UPDATING) THEN                                                             ');
        lQuery.SQL.Add('        BEGIN                                                                                ');
        lQuery.SQL.Add('        ATUALIZAR = ''N'';                                                                   ');
        lQuery.SQL.Add('        IF (OLD.AC08TIT            IS NOT NULL) THEN                                         ');
        lQuery.SQL.Add('   	 BEGIN  IF  (OLD.AC08TIT <> NEW.AC08TIT )THEN                                            ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN IF (NEW.AC08TIT IS NOT NULL) THEN                                                 ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AD08EMISSAO IS NOT NULL) THEN                                                ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AD08EMISSAO <> NEW.AD08EMISSAO )THEN                                           ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN IF (NEW.AD08EMISSAO IS NOT NULL) THEN                                             ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AD08VCTO IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AD08VCTO <> NEW.AD08VCTO)THEN                                                  ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AD08VCTO IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AD08FLUXO IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AD08FLUXO <> NEW.AD08FLUXO)THEN                                                ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AD08FLUXO IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AD08DTPGTO IS NOT NULL) THEN                                                 ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AD08DTPGTO <> NEW.AD08DTPGTO)THEN                                              ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AD08DTPGTO IS NOT NULL)THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AC08ORIG IS NOT NULL)THEN                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (OLD.AC08ORIG <> NEW.AC08ORIG)THEN                                                   ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AC08ORIG IS NOT NULL)THEN                                                       ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AC08SIT IS NOT NULL)THEN                                                     ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AC08SIT <> NEW.AC08SIT)THEN                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AC08SIT IS NOT NULL) THEN                                                       ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AN08FORNEC IS NOT NULL) THEN                                                 ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AN08FORNEC <> NEW.AN08FORNEC)THEN                                              ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AN08FORNEC IS NOT NULL)THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AC08FRPGTO IS NOT NULL)THEN                                                  ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AC08FRPGTO <> NEW.AC08FRPGTO)THEN                                              ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AC08FRPGTO IS NOT NULL)THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AC08_CTA IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AC08_CTA <> NEW.AC08_CTA)THEN                                                  ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AC08_CTA IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AC08_COD_BARRAS IS NOT NULL) THEN                                            ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AC08_COD_BARRAS <> NEW.AC08_COD_BARRAS)THEN                                    ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AC08_COD_BARRAS IS NOT NULL) THEN                                               ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AN08VALOR IS NOT NULL)THEN                                                   ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AN08VALOR <> NEW.AN08VALOR)THEN                                                ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AN08VALOR IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AN08TOTALPAGO IS NOT NULL)THEN                                               ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AN08TOTALPAGO <> NEW.AN08TOTALPAGO)THEN                                        ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AN08TOTALPAGO IS NOT NULL) THEN                                                 ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AN08VLPAGO IS NOT NULL) THEN                                                 ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AN08VLPAGO <> NEW.AN08VLPAGO)THEN                                              ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AN08VLPAGO IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AN08DESC IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('   	 BEGIN  IF  (OLD.AN08DESC <> NEW.AN08DESC)THEN                                           ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AN08DESC IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AN08JUROS IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('   	 BEGIN  IF  (OLD.AN08JUROS <> NEW.AN08JUROS)THEN                                         ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AN08JUROS IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AC08_OBS1 IS NOT NULL)THEN                                                   ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AC08_OBS1 <> NEW.AC08_OBS1)THEN                                                ');
        lQuery.SQL.Add('   	 BEGIN ATUALIZAR = ''S'';                                                                ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AC08_OBS1 IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (OLD.AC08_OBS2 IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF  (OLD.AC08_OBS2 <> NEW.AC08_OBS2)THEN                                                ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('   	 ELSE                                                                                    ');
        lQuery.SQL.Add('   	 BEGIN                                                                                   ');
        lQuery.SQL.Add('   	 IF (NEW.AC08_OBS2 IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('   	 ATUALIZAR = ''S'';                                                                      ');
        lQuery.SQL.Add('   	 END                                                                                     ');
        lQuery.SQL.Add('        IF (ATUALIZAR = ''S'') THEN                                                          ');
        lQuery.SQL.Add('        BEGIN                                                                                ');
        lQuery.SQL.Add('        UPDATE OR INSERT INTO TBL_INTEG_CP (TITULO, DATA_ATUALIZACAO, EXCLUIDO)              ');
        lQuery.SQL.Add('        VALUES (OLD.AC08TIT, CURRENT_TIMESTAMP, ''N'')                                       ');
        lQuery.SQL.Add('        MATCHING (TITULO);                                                                   ');
        lQuery.SQL.Add('        END                                                                                  ');
        lQuery.SQL.Add('     END                                                                                     ');
        lQuery.SQL.Add('     ELSE IF (DELETING) THEN                                                                 ');
        lQuery.SQL.Add('     BEGIN                                                                                   ');
        lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CP (TITULO, DATA_ATUALIZACAO, EXCLUIDO,EMPRESA_TITULO)      ');
        lQuery.SQL.Add(' VALUES (OLD.AC08TIT, CURRENT_TIMESTAMP, ''S'',OLD.AC08EMP_TIT)                              ');
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
        lQuery.SQL.Add(' CREATE OR ALTER TRIGGER TBL_INTEG_CR FOR MC09CREC                                           ');
        lQuery.SQL.Add('  ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 0                                         ');
        lQuery.SQL.Add('  AS                                                                                         ');
        lQuery.SQL.Add('  DECLARE ATUALIZAR CHAR(1);                                                                 ');
        lQuery.SQL.Add('  BEGIN                                                                                      ');
        lQuery.SQL.Add('      IF (INSERTING) THEN                                                                    ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      UPDATE OR INSERT INTO TBL_INTEG_CR (DUPLICATA, DATA_ATUALIZACAO, EXCLUIDO)             ');
        lQuery.SQL.Add('      VALUES (NEW.AC09DUP, CURRENT_TIMESTAMP, ''N'') ;                                       ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      IF (UPDATING) THEN                                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''N'';                                                                     ');
        lQuery.SQL.Add('      IF (OLD.AC09DUP IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.AC09DUP <> NEW.AC09DUP )THEN                                                  ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.AC09DUP IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.An09Cliente IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.An09Cliente <> NEW.An09Cliente )THEN                                          ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.An09Cliente IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.An09Vend IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.An09Vend <> NEW.An09Vend )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.An09Vend IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Ac09FrPgto IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Ac09FrPgto <> NEW.Ac09FrPgto )THEN                                            ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Ac09FrPgto IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.AC09_CTA IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.AC09_CTA <> NEW.AC09_CTA )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.AC09_CTA IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Ad09Emissao IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Ad09Emissao <> NEW.Ad09Emissao )THEN                                          ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Ad09Emissao IS NOT NULL) THEN                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Ad09Vcto IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Ad09Vcto <> NEW.Ad09Vcto )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Ad09Vcto IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Ad09Fluxo IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Ad09Fluxo <> NEW.Ad09Fluxo )THEN                                              ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Ad09Fluxo IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Ad09Dtpgto IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Ad09Dtpgto <> NEW.Ad09Dtpgto )THEN                                            ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Ad09Dtpgto IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Ac09BcOr IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Ac09BcOr <> NEW.Ac09BcOr )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Ac09BcOr IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Ac09BcPg IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Ac09BcPg <> NEW.Ac09BcPg )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Ac09BcPg IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.An09Valor IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.An09Valor <> NEW.An09Valor )THEN                                              ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.An09Valor IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.An09VlPago IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.An09VlPago <> NEW.An09VlPago )THEN                                            ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.An09VlPago IS NOT NULL) THEN                                                   ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.An09Juros IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.An09Juros <> NEW.An09Juros )THEN                                              ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.An09Juros IS NOT NULL) THEN                                                    ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.An09Desc IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.An09Desc <> NEW.An09Desc )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.An09Desc IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.An09TotalPago IS NOT NULL) THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.An09TotalPago <> NEW.An09TotalPago )THEN                                      ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.An09TotalPago IS NOT NULL) THEN                                                ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.AC09ORIG IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.AC09ORIG <> NEW.AC09ORIG )THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.AC09ORIG IS NOT NULL) THEN                                                     ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.AC09SIT IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.AC09SIT <> NEW.AC09SIT )THEN                                                  ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.AC09SIT IS NOT NULL) THEN                                                      ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (OLD.Al09BxParcial IS NOT NULL) THEN                                                ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF  (OLD.Al09BxParcial <> NEW.Al09BxParcial )THEN                                      ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      ELSE                                                                                   ');
        lQuery.SQL.Add('      BEGIN                                                                                  ');
        lQuery.SQL.Add('      IF (NEW.Al09BxParcial IS NOT NULL) THEN                                                ');
        lQuery.SQL.Add('      ATUALIZAR = ''S'';                                                                     ');
        lQuery.SQL.Add('      END                                                                                    ');
        lQuery.SQL.Add('      IF (ATUALIZAR = ''S'') THEN                                                            ');
        lQuery.SQL.Add('          BEGIN                                                                              ');
        lQuery.SQL.Add('          UPDATE OR INSERT INTO TBL_INTEG_CR (DUPLICATA, DATA_ATUALIZACAO, EXCLUIDO)         ');
        lQuery.SQL.Add('          VALUES (OLD.AC09DUP, CURRENT_TIMESTAMP, ''N'')                                     ');
        lQuery.SQL.Add('          MATCHING (DUPLICATA);                                                              ');
        lQuery.SQL.Add('          END                                                                                ');
        lQuery.SQL.Add('     END                                                                                     ');
        lQuery.SQL.Add('     ELSE IF (DELETING) THEN                                                                 ');
        lQuery.SQL.Add('     BEGIN                                                                                   ');
        lQuery.SQL.Add(' UPDATE OR INSERT INTO TBL_INTEG_CR (DUPLICATA,DATA_ATUALIZACAO,EXCLUIDO,DUPLICATA_EMPRESA)  ');
        lQuery.SQL.Add(' VALUES (OLD.AC09DUP, CURRENT_TIMESTAMP, ''S'', OLD.AC09EMP_DUP)                             ');
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
