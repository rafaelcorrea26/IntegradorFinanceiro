unit fConfiguracao;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  uConnection,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  System.ImageList,
  Vcl.ImgList,
  Vcl.ComCtrls,
  fModoADM,
  fManipulaRegistrosTabelaAux,
  uFunctions,
  uQuery, System.DateUtils;

type
  TfrmConfiguracao = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel5: TPanel;
    btnSairStatus: TButton;
    btnSalvaConfiguracao: TButton;
    btnCarregaConfiguracao: TButton;
    Panel6: TPanel;
    Panel7: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    imlIconsBlack24dp: TImageList;
    edtToken: TMemo;
    Button1: TButton;
    pnlModoAdm: TPanel;
    dtpDataExpirarToken: TDateTimePicker;
    edtCodigoEmpresa: TEdit;
    lblCodigoEmpresa: TLabel;
    pgcConfiguracao: TPageControl;
    tbsCP: TTabSheet;
    tbsCR: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    cbxIntervaloEnvioCP: TComboBox;
    Panel3: TPanel;
    chkEnvioAutomaticoCP: TCheckBox;
    chkEmpresaPrincipalCP: TCheckBox;
    edtChaveEmpresaCP: TEdit;
    dtpUltimaSincCP: TDateTimePicker;
    Label6: TLabel;
    edtChaveEmpresaCR: TEdit;
    Panel4: TPanel;
    chkEnvioAutomaticoCR: TCheckBox;
    Label7: TLabel;
    dtpUltimaSincCR: TDateTimePicker;
    Label8: TLabel;
    cbxIntervaloEnvioCR: TComboBox;
    chkEmpresaPrincipalCR: TCheckBox;
    chkLiberadoParaUso: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSairClick(Sender: TObject);
    procedure btnSalvaConfiguracaoClick(Sender: TObject);
    procedure btnSairStatusClick(Sender: TObject);
    procedure btnCarregaConfiguracaoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure pnlModoAdmClick(Sender: TObject);
  private
    { Private declarations }
    procedure SalvaConfiguracao;
    procedure CarregaConfiguracao;
  public
    { Public declarations }
    FID: string;
    FDesc: string;
  end;

var
  frmConfiguracao: TfrmConfiguracao;

implementation

{$R *.dfm}

procedure TfrmConfiguracao.SalvaConfiguracao;
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
      lQuery.SQL.Add(' ,CODIGO_EMPRESA                                    ');
      lQuery.SQL.Add(' ,LIBERADO_PARA_USO                                 ');
      lQuery.SQL.Add(' ,CHAVE_EMPRESA_CP                                  ');
      lQuery.SQL.Add(' ,CHAVE_EMPRESA_CR                                  ');
      lQuery.SQL.Add(' ,EMPRESA_PRINCIPAL_CP                              ');
      lQuery.SQL.Add(' ,EMPRESA_PRINCIPAL_CR                              ');
      lQuery.SQL.Add(' ,ENVIO_AUTOMATICO_CP                               ');
      lQuery.SQL.Add(' ,ENVIO_AUTOMATICO_CR                               ');
      lQuery.SQL.Add(' ,INTERVALO_ENVIO_CP                                ');
      lQuery.SQL.Add(' ,INTERVALO_ENVIO_CR                                ');
      lQuery.SQL.Add(' ,ULTIMA_SINC_CP                                    ');
      lQuery.SQL.Add(' ,ULTIMA_SINC_CR                                    ');
      lQuery.SQL.Add(' ) values (                                         ');
      lQuery.SQL.Add('  :ID                                               ');
      lQuery.SQL.Add(' ,:ACCESS_TOKEN                                     ');
      lQuery.SQL.Add(' ,:ACCESS_TOKEN_EXPIRES                             ');
      lQuery.SQL.Add(' ,:CODIGO_EMPRESA                                   ');
      lQuery.SQL.Add(' ,:LIBERADO_PARA_USO                                ');
      lQuery.SQL.Add(' ,:CHAVE_EMPRESA_CP                                 ');
      lQuery.SQL.Add(' ,:CHAVE_EMPRESA_CR                                 ');
      lQuery.SQL.Add(' ,:EMPRESA_PRINCIPAL_CP                             ');
      lQuery.SQL.Add(' ,:EMPRESA_PRINCIPAL_CR                             ');
      lQuery.SQL.Add(' ,:ENVIO_AUTOMATICO_CP                              ');
      lQuery.SQL.Add(' ,:ENVIO_AUTOMATICO_CR                              ');
      lQuery.SQL.Add(' ,:INTERVALO_ENVIO_CP                               ');
      lQuery.SQL.Add(' ,:INTERVALO_ENVIO_CR                               ');
      lQuery.SQL.Add(' ,:ULTIMA_SINC_CP                                   ');
      lQuery.SQL.Add(' ,:ULTIMA_SINC_CR                                   ');
      lQuery.SQL.Add(' ) MATCHING (ID)                                    ');
      lQuery.ParamByName('ID').AsInteger := 1;
      lQuery.ParamByName('ACCESS_TOKEN').AsString := edtToken.Text;
      lQuery.ParamByName('ACCESS_TOKEN_EXPIRES').AsDateTime := dtpDataExpirarToken.DateTime;
      lQuery.ParamByName('CODIGO_EMPRESA').AsInteger := StrToIntdef(edtCodigoEmpresa.Text,0);
      lQuery.ParamByName('LIBERADO_PARA_USO').AsString := TFunctions.GetSN(chkLiberadoParaUso.Checked);
      lQuery.ParamByName('CHAVE_EMPRESA_CP').AsString := edtChaveEmpresaCP.Text;
      lQuery.ParamByName('CHAVE_EMPRESA_CR').AsString := edtChaveEmpresaCR.Text;
      lQuery.ParamByName('EMPRESA_PRINCIPAL_CP').AsString := TFunctions.GetSN(chkEmpresaPrincipalCP.Checked);
      lQuery.ParamByName('EMPRESA_PRINCIPAL_CR').AsString := TFunctions.GetSN(chkEmpresaPrincipalCR.Checked);
      lQuery.ParamByName('ENVIO_AUTOMATICO_CP').AsString := TFunctions.GetSN(chkEnvioAutomaticoCP.Checked);
      lQuery.ParamByName('ENVIO_AUTOMATICO_CR').AsString := TFunctions.GetSN(chkEnvioAutomaticoCR.Checked);
      lQuery.ParamByName('INTERVALO_ENVIO_CP').AsInteger := cbxIntervaloEnvioCP.ItemIndex;
      lQuery.ParamByName('INTERVALO_ENVIO_CR').AsInteger := cbxIntervaloEnvioCR.ItemIndex;
      lQuery.ParamByName('ULTIMA_SINC_CP').AsDateTime := dtpUltimaSincCP.DateTime;
      lQuery.ParamByName('ULTIMA_SINC_CR').AsDateTime := dtpUltimaSincCR.DateTime;
      lQuery.ExecSQL;
      lQuery.Connection.Commit;

      // TConnectionAPI.ConnectionAPI.ConfigAPI;
      showmessage('Configuração salva com sucesso. ');

    finally
      lQuery.Free;
    end;

  except
    on e: Exception do
      showmessage('Problemas ao salvar a configuração.');
  end;
end;

procedure TfrmConfiguracao.btnCarregaConfiguracaoClick(Sender: TObject);
begin
  CarregaConfiguracao;
end;

procedure TfrmConfiguracao.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConfiguracao.btnSairStatusClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConfiguracao.btnSalvaConfiguracaoClick(Sender: TObject);
begin
  SalvaConfiguracao;
  Close;
end;

procedure TfrmConfiguracao.Button1Click(Sender: TObject);
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
        lQuery.SQL.Add(' CREATE OR ALTER TRIGGER TBL_INTEG_CP FOR MC08CPAG                                        ');
        lQuery.SQL.Add(' ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 0                                       ');
        lQuery.SQL.Add(' AS                                                                                       ');
        lQuery.SQL.Add(' DECLARE ATUALIZAR CHAR(1);                                                               ');
        lQuery.SQL.Add(' BEGIN                                                                                    ');
        lQuery.SQL.Add('     IF (INSERTING) THEN                                                                  ');
        lQuery.SQL.Add('     BEGIN                                                                                ');
        lQuery.SQL.Add('         INSERT INTO TBL_INTEG_CP (TITULO, DATA_ATUALIZACAO, EXCLUIDO)                    ');
        lQuery.SQL.Add('         VALUES (NEW.AC08TIT, CURRENT_TIMESTAMP, ''N'') ;                                 ');
        lQuery.SQL.Add('     END                                                                                  ');
        lQuery.SQL.Add('     ELSE  IF (UPDATING) THEN                                                             ');
        lQuery.SQL.Add('     BEGIN                                                                                ');
        lQuery.SQL.Add('     ATUALIZAR = ''N'';                                                                   ');
        lQuery.SQL.Add('     IF (OLD.AC08TIT            IS NOT NULL) THEN  BEGIN  IF  (OLD.AC08TIT                ');
        lQuery.SQL.Add('     <> NEW.AC08TIT )         THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AC08TIT IS NOT NULL) THEN ATUALIZAR = ''S'';    END      ');
        lQuery.SQL.Add('     IF (OLD.AD08EMISSAO        IS NOT NULL) THEN  BEGIN  IF  (OLD.AD08EMISSAO            ');
        lQuery.SQL.Add('     <> NEW.AD08EMISSAO )     THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AD08EMISSAO IS NOT NULL) THEN ATUALIZAR = ''S''; END     ');
        lQuery.SQL.Add('     IF (OLD.AD08VCTO           IS NOT NULL) THEN  BEGIN  IF  (OLD.AD08VCTO               ');
        lQuery.SQL.Add('     <> NEW.AD08VCTO)         THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AD08VCTO IS NOT NULL) THEN ATUALIZAR = ''S'';    END     ');
        lQuery.SQL.Add('     IF (OLD.AD08FLUXO          IS NOT NULL) THEN  BEGIN  IF  (OLD.AD08FLUXO              ');
        lQuery.SQL.Add('     <> NEW.AD08FLUXO)        THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AD08FLUXO IS NOT NULL) THEN ATUALIZAR = ''S'';  END      ');
        lQuery.SQL.Add('     IF (OLD.AD08DTPGTO         IS NOT NULL) THEN  BEGIN  IF  (OLD.AD08DTPGTO             ');
        lQuery.SQL.Add('     <> NEW.AD08DTPGTO)       THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AD08DTPGTO IS NOT NULL) THEN ATUALIZAR = ''S''; END      ');
        lQuery.SQL.Add('     IF (OLD.AC08ORIG           IS NOT NULL) THEN  BEGIN  IF  (OLD.AC08ORIG               ');
        lQuery.SQL.Add('     <> NEW.AC08ORIG)         THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AC08ORIG IS NOT NULL) THEN ATUALIZAR = ''S'';   END      ');
        lQuery.SQL.Add('     IF (OLD.AC08SIT            IS NOT NULL) THEN  BEGIN  IF  (OLD.AC08SIT                ');
        lQuery.SQL.Add('     <> NEW.AC08SIT)          THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AC08SIT IS NOT NULL) THEN ATUALIZAR = ''S'';    END      ');
        lQuery.SQL.Add('     IF (OLD.AN08FORNEC         IS NOT NULL) THEN  BEGIN  IF  (OLD.AN08FORNEC             ');
        lQuery.SQL.Add('     <> NEW.AN08FORNEC)       THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AN08FORNEC IS NOT NULL) THEN ATUALIZAR = ''S''; END      ');
        lQuery.SQL.Add('     IF (OLD.AC08FRPGTO         IS NOT NULL) THEN  BEGIN  IF  (OLD.AC08FRPGTO             ');
        lQuery.SQL.Add('     <> NEW.AC08FRPGTO)       THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AC08FRPGTO IS NOT NULL) THEN ATUALIZAR = ''S''; END      ');
        lQuery.SQL.Add('     IF (OLD.AC08_CTA           IS NOT NULL) THEN  BEGIN  IF  (OLD.AC08_CTA               ');
        lQuery.SQL.Add('     <> NEW.AC08_CTA)         THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AC08_CTA IS NOT NULL) THEN ATUALIZAR = ''S'';   END      ');
        lQuery.SQL.Add('     IF (OLD.AC08_COD_BARRAS    IS NOT NULL) THEN  BEGIN  IF  (OLD.AC08_COD_BARRAS        ');
        lQuery.SQL.Add('     <> NEW.AC08_COD_BARRAS)  THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AC08_COD_BARRAS IS NOT NULL) THEN ATUALIZAR = ''S''; END ');
        lQuery.SQL.Add('     IF (OLD.AN08VALOR          IS NOT NULL) THEN  BEGIN  IF  (OLD.AN08VALOR              ');
        lQuery.SQL.Add('     <> NEW.AN08VALOR)        THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AN08VALOR IS NOT NULL) THEN ATUALIZAR = ''S'';       END ');
        lQuery.SQL.Add('     IF (OLD.AN08TOTALPAGO      IS NOT NULL) THEN  BEGIN  IF  (OLD.AN08TOTALPAGO          ');
        lQuery.SQL.Add('     <> NEW.AN08TOTALPAGO)    THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AN08TOTALPAGO IS NOT NULL) THEN ATUALIZAR = ''S'';   END ');
        lQuery.SQL.Add('     IF (OLD.AN08VLPAGO         IS NOT NULL) THEN  BEGIN  IF  (OLD.AN08VLPAGO             ');
        lQuery.SQL.Add('     <> NEW.AN08VLPAGO)       THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AN08VLPAGO IS NOT NULL) THEN ATUALIZAR = ''S'';      END ');
        lQuery.SQL.Add('     IF (OLD.AN08DESC           IS NOT NULL) THEN  BEGIN  IF  (OLD.AN08DESC               ');
        lQuery.SQL.Add('     <> NEW.AN08DESC)         THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AN08DESC IS NOT NULL) THEN ATUALIZAR = ''S'';        END ');
        lQuery.SQL.Add('     IF (OLD.AN08JUROS          IS NOT NULL) THEN  BEGIN  IF  (OLD.AN08JUROS              ');
        lQuery.SQL.Add('     <> NEW.AN08JUROS)        THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AN08JUROS IS NOT NULL) THEN ATUALIZAR = ''S'';       END ');
        lQuery.SQL.Add('     IF (OLD.AC08_OBS1          IS NOT NULL) THEN  BEGIN  IF  (OLD.AC08_OBS1              ');
        lQuery.SQL.Add('     <> NEW.AC08_OBS1)        THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AC08_OBS1 IS NOT NULL) THEN ATUALIZAR = ''S'';       END ');
        lQuery.SQL.Add('     IF (OLD.AC08_OBS2          IS NOT NULL) THEN  BEGIN  IF  (OLD.AC08_OBS2              ');
        lQuery.SQL.Add('     <> NEW.AC08_OBS2)        THEN  BEGIN ATUALIZAR = ''S'';                              ');
        lQuery.SQL.Add('     END  END ELSE BEGIN IF (NEW.AC08_OBS2 IS NOT NULL) THEN ATUALIZAR = ''S'';       END ');
        lQuery.SQL.Add('     IF (ATUALIZAR = ''S'') THEN                                                          ');
        lQuery.SQL.Add('         BEGIN                                                                            ');
        lQuery.SQL.Add('          UPDATE OR INSERT INTO TBL_INTEG_CP (TITULO, DATA_ATUALIZACAO, EXCLUIDO)         ');
        lQuery.SQL.Add('          VALUES (OLD.AC08TIT, CURRENT_TIMESTAMP, ''N'')                                  ');
        lQuery.SQL.Add('          MATCHING (TITULO);                                                              ');
        lQuery.SQL.Add('         END                                                                              ');
        lQuery.SQL.Add('    END                                                                                   ');
        lQuery.SQL.Add('    ELSE IF (DELETING) THEN                                                               ');
        lQuery.SQL.Add('    BEGIN                                                                                 ');
        lQuery.SQL.Add('    UPDATE OR INSERT INTO TBL_INTEG_CP (TITULO, DATA_ATUALIZACAO, EXCLUIDO,EMPRESA_TITULO)');
        lQuery.SQL.Add('    VALUES (OLD.AC08TIT, CURRENT_TIMESTAMP, ''S'',OLD.AC08EMP_TIT)                        ');
        lQuery.SQL.Add('    MATCHING (TITULO);                                                                    ');
        lQuery.SQL.Add('   END                                                                                    ');
        lQuery.SQL.Add(' END                                                                                      ');
        lQuery.ExecSQL;
        lQuery.Connection.Commit;
      end;

      if not(TFunctions.TriggerValidation('TBL_INTEG_FN')) then
      begin
        lQuery.Close;
        lQuery.SQL.Clear;
        lQuery.SQL.Add(' CREATE OR ALTER TRIGGER TBL_INTEG_FN FOR MC02FORNEC                                      ');
        lQuery.SQL.Add(' ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 0                                       ');
        lQuery.SQL.Add(' AS                                                                                       ');
        lQuery.SQL.Add(' DECLARE ATUALIZAR CHAR(1);                                                               ');
        lQuery.SQL.Add(' BEGIN                                                                                    ');
        lQuery.SQL.Add('     IF (INSERTING) THEN                                                                  ');
        lQuery.SQL.Add('     BEGIN                                                                                ');
        lQuery.SQL.Add('         INSERT INTO TBL_INTEG_FN (CODIGO, DATA_ATUALIZACAO, EXCLUIDO,ENVIADO)            ');
        lQuery.SQL.Add('         VALUES (NEW.MC02CODIGO, CURRENT_TIMESTAMP, ''N'',''N'') ;                        ');
        lQuery.SQL.Add('     END                                                                                  ');
        lQuery.SQL.Add('     ELSE  IF (UPDATING) THEN                                                             ');
        lQuery.SQL.Add('     BEGIN                                                                                ');
        lQuery.SQL.Add('         ATUALIZAR = ''N'';                                                               ');
        lQuery.SQL.Add('         IF (OLD.MC02CODIGO          IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02CODIGO        ');
        lQuery.SQL.Add(' 		<> NEW.MC02CODIGO )         THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02CODIGO IS NOT NULL) THEN ATUALIZAR = ''S'';           END          ');
        lQuery.SQL.Add('         IF (OLD.MC02CGC             IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02CGC           ');
        lQuery.SQL.Add(' 		<> NEW.MC02CGC )            THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02CGC IS NOT NULL) THEN ATUALIZAR = ''S'';              END          ');
        lQuery.SQL.Add('         IF (OLD.MC02CPF             IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02CPF           ');
        lQuery.SQL.Add(' 		<> NEW.MC02CPF)             THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02CPF IS NOT NULL) THEN ATUALIZAR = ''S'';              END          ');
        lQuery.SQL.Add('         IF (OLD.MC02NOME            IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02NOME          ');
        lQuery.SQL.Add(' 		<> NEW.MC02NOME)            THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02NOME IS NOT NULL) THEN ATUALIZAR = ''S'';             END          ');
        lQuery.SQL.Add('         IF (OLD.MC02FANTASIA        IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02FANTASIA      ');
        lQuery.SQL.Add(' 		<> NEW.MC02FANTASIA)        THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02FANTASIA IS NOT NULL) THEN ATUALIZAR = ''S'';         END          ');
        lQuery.SQL.Add('         IF (OLD.MC02FISJUR          IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02FISJUR        ');
        lQuery.SQL.Add(' 		<> NEW.MC02FISJUR)          THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02FISJUR IS NOT NULL) THEN ATUALIZAR = ''S'';           END          ');
        lQuery.SQL.Add('         IF (OLD.MC02ATIINATIVO      IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02ATIINATIVO    ');
        lQuery.SQL.Add(' 		<> NEW.MC02ATIINATIVO)      THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02ATIINATIVO IS NOT NULL) THEN ATUALIZAR = ''S'';       END          ');
        lQuery.SQL.Add('         IF (OLD.MC02ENDERECO        IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02ENDERECO      ');
        lQuery.SQL.Add(' 		<> NEW.MC02ENDERECO)        THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02ENDERECO IS NOT NULL) THEN ATUALIZAR = ''S'';         END          ');
        lQuery.SQL.Add('         IF (OLD.MC02_NR             IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02_NR           ');
        lQuery.SQL.Add(' 		<> NEW.MC02_NR)             THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02_NR IS NOT NULL) THEN ATUALIZAR = ''S'';              END          ');
        lQuery.SQL.Add('         IF (OLD.MC02BAIRRO          IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02BAIRRO        ');
        lQuery.SQL.Add(' 		<> NEW.MC02BAIRRO)          THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02BAIRRO IS NOT NULL) THEN ATUALIZAR = ''S'';           END          ');
        lQuery.SQL.Add('         IF (OLD.MC02CIDADE          IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02CIDADE        ');
        lQuery.SQL.Add(' 		<> NEW.MC02CIDADE)          THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02CIDADE IS NOT NULL) THEN ATUALIZAR = ''S'';           END          ');
        lQuery.SQL.Add('         IF (OLD.MC02UF              IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02UF            ');
        lQuery.SQL.Add(' 		<> NEW.MC02UF)              THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02UF IS NOT NULL) THEN ATUALIZAR = ''S'';               END          ');
        lQuery.SQL.Add('         IF (OLD.MC02CEP             IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02CEP           ');
        lQuery.SQL.Add(' 		<> NEW.MC02CEP)             THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02CEP IS NOT NULL) THEN ATUALIZAR = ''S'';              END          ');
        lQuery.SQL.Add('         IF (OLD.MC02_COD_SEFAZ      IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02_COD_SEFAZ    ');
        lQuery.SQL.Add(' 		<> NEW.MC02_COD_SEFAZ)      THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02_COD_SEFAZ IS NOT NULL) THEN ATUALIZAR = ''S'';       END          ');
        lQuery.SQL.Add('         IF (OLD.MC02FONE            IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02FONE          ');
        lQuery.SQL.Add(' 		<> NEW.MC02FONE)            THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02FONE IS NOT NULL) THEN ATUALIZAR = ''S'';             END          ');
        lQuery.SQL.Add('         IF (OLD.MC02CELULAR         IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02CELULAR       ');
        lQuery.SQL.Add(' 		<> NEW.MC02CELULAR)         THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02CELULAR IS NOT NULL) THEN ATUALIZAR = ''S'';          END          ');
        lQuery.SQL.Add('         IF (OLD.MC02EMAIL           IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02EMAIL         ');
        lQuery.SQL.Add(' 		<> NEW.MC02EMAIL)           THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02EMAIL IS NOT NULL) THEN ATUALIZAR = ''S'';            END          ');
        lQuery.SQL.Add('         IF (OLD.MC02CI              IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02CI            ');
        lQuery.SQL.Add(' 		<> NEW.MC02CI)              THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02CI IS NOT NULL) THEN ATUALIZAR = ''S'';               END          ');
        lQuery.SQL.Add('         IF (OLD.MC02IE              IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02IE            ');
        lQuery.SQL.Add(' 		<> NEW.MC02IE)              THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02IE IS NOT NULL) THEN ATUALIZAR = ''S'';               END          ');
        lQuery.SQL.Add('         IF (OLD.MC02_OBS1           IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02_OBS1         ');
        lQuery.SQL.Add(' 		<> NEW.MC02_OBS1)           THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02_OBS1 IS NOT NULL) THEN ATUALIZAR = ''S'';            END          ');
        lQuery.SQL.Add('         IF (OLD.MC02_OBS2           IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02_OBS2         ');
        lQuery.SQL.Add(' 		<> NEW.MC02_OBS2)           THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02_OBS2 IS NOT NULL) THEN ATUALIZAR = ''S'';            END          ');
        lQuery.SQL.Add('         IF (OLD.MC02_ALTERAR_CUSTOS IS NOT NULL) THEN  BEGIN  IF (OLD.MC02_ALTERAR_CUSTOS');
        lQuery.SQL.Add(' 		<> NEW.MC02_ALTERAR_CUSTOS) THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02_ALTERAR_CUSTOS IS NOT NULL) THEN ATUALIZAR = ''S'';  END          ');
        lQuery.SQL.Add('         IF (OLD.MC02_SPED_SN        IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02_SPED_SN      ');
        lQuery.SQL.Add(' 		<> NEW.MC02_SPED_SN)        THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02_SPED_SN IS NOT NULL) THEN ATUALIZAR = ''S'';         END          ');
        lQuery.SQL.Add('         IF (OLD.MC02REGIME          IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02REGIME        ');
        lQuery.SQL.Add(' 		<> NEW.MC02REGIME)          THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02REGIME IS NOT NULL) THEN ATUALIZAR = ''S'';           END          ');
        lQuery.SQL.Add('         IF (OLD.MC02CRT             IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02CRT           ');
        lQuery.SQL.Add(' 		<> NEW.MC02CRT)             THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02CRT IS NOT NULL) THEN ATUALIZAR = ''S'';              END          ');
        lQuery.SQL.Add('         IF (OLD.MC02CNAE            IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02CNAE          ');
        lQuery.SQL.Add(' 		<> NEW.MC02CNAE)            THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02CNAE IS NOT NULL) THEN ATUALIZAR = ''S'';             END          ');
        lQuery.SQL.Add('         IF (OLD.MC02CONTATO         IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02CONTATO       ');
        lQuery.SQL.Add(' 		<> NEW.MC02CONTATO)         THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02CONTATO IS NOT NULL) THEN ATUALIZAR = ''S'';          END          ');
        lQuery.SQL.Add('         IF (OLD.MC02FONE_CONTATO    IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02FONE_CONTATO  ');
        lQuery.SQL.Add(' 		<> NEW.MC02FONE_CONTATO)    THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02FONE_CONTATO IS NOT NULL) THEN ATUALIZAR = ''S'';     END          ');
        lQuery.SQL.Add('         IF (OLD.MC02EMAIL_CONTATO   IS NOT NULL) THEN  BEGIN  IF  (OLD.MC02EMAIL_CONTATO ');
        lQuery.SQL.Add(' 		<> NEW.MC02EMAIL_CONTATO)   THEN  BEGIN ATUALIZAR = ''S'';  END  END ELSE            ');
        lQuery.SQL.Add(' 		BEGIN IF (NEW.MC02EMAIL_CONTATO IS NOT NULL) THEN ATUALIZAR = ''S'';    END          ');
        lQuery.SQL.Add('         IF (ATUALIZAR = ''S'') THEN                                                      ');
        lQuery.SQL.Add('         BEGIN                                                                            ');
        lQuery.SQL.Add('          UPDATE OR INSERT INTO TBL_INTEG_FN (CODIGO, DATA_ATUALIZACAO, EXCLUIDO,ENVIADO) ');
        lQuery.SQL.Add('          VALUES (OLD.MC02CODIGO, CURRENT_TIMESTAMP, ''N'',''N'')                         ');
        lQuery.SQL.Add('          MATCHING (CODIGO);                                                              ');
        lQuery.SQL.Add('         END                                                                              ');
        lQuery.SQL.Add('     END                                                                                  ');
        lQuery.SQL.Add('     ELSE IF (DELETING) THEN                                                              ');
        lQuery.SQL.Add('     BEGIN                                                                                ');
        lQuery.SQL.Add('         UPDATE OR INSERT INTO TBL_INTEG_FN (CODIGO, DATA_ATUALIZACAO, EXCLUIDO)          ');
        lQuery.SQL.Add('         VALUES (OLD.MC02CODIGO, CURRENT_TIMESTAMP, ''S'')                                ');
        lQuery.SQL.Add('         MATCHING (CODIGO);                                                               ');
        lQuery.SQL.Add('     END                                                                                  ');
        lQuery.SQL.Add(' END                                                                                     ');
        lQuery.ExecSQL;
        lQuery.Connection.Commit;
      end;
    finally
      lQuery.Free;
    end;

  except
    on e: Exception do
      showmessage('Problemas ao salvar a configuração.');
  end;
end;

procedure TfrmConfiguracao.CarregaConfiguracao;
var
  lQuery: TQuery;
begin
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
      dtpDataExpirarToken.Date := IncYear(Now - 22);
      dtpUltimaSincCP.Date := Now;
      dtpUltimaSincCR.Date := Now;
      SalvaConfiguracao;
    end
    else
    begin
      edtToken.Text := lQuery.ParamByName('ACCESS_TOKEN').AsString;
      dtpDataExpirarToken.DateTime := lQuery.ParamByName('ACCESS_TOKEN_EXPIRES').AsDateTime;
      edtCodigoEmpresa.Text := lQuery.ParamByName('CODIGO_EMPRESA').AsString;
      edtChaveEmpresaCP.Text := lQuery.ParamByName('CHAVE_EMPRESA_CP').AsString;
      edtChaveEmpresaCR.Text := lQuery.ParamByName('CHAVE_EMPRESA_CR').AsString;
      chkLiberadoParaUso.Checked := lQuery.ParamByName('LIBERADO_PARA_USO').AsString = 'S';
      chkEmpresaPrincipalCP.Checked := lQuery.ParamByName('EMPRESA_PRINCIPAL_CP').AsString = 'S';
      chkEmpresaPrincipalCR.Checked := lQuery.ParamByName('EMPRESA_PRINCIPAL_CR').AsString = 'S';
      chkEnvioAutomaticoCP.Checked := lQuery.ParamByName('ENVIO_AUTOMATICO_CP').AsString = 'S';
      chkEnvioAutomaticoCR.Checked := lQuery.ParamByName('ENVIO_AUTOMATICO_CR').AsString = 'S';
      cbxIntervaloEnvioCP.ItemIndex := lQuery.ParamByName('INTERVALO_ENVIO_CP').AsInteger;
      cbxIntervaloEnvioCR.ItemIndex := lQuery.ParamByName('INTERVALO_ENVIO_CR').AsInteger;
      dtpUltimaSincCP.DateTime := lQuery.ParamByName('ULTIMA_SINC_CP').AsDateTime;
      dtpUltimaSincCR.DateTime := lQuery.ParamByName('ULTIMA_SINC_CR').AsDateTime;
    end;
  finally
    lQuery.Free;
  end;

  // TConnectionAPI.ConnectionAPI.ConfigAPI;
end;

procedure TfrmConfiguracao.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmConfiguracao.FormShow(Sender: TObject);
begin
  CarregaConfiguracao;
end;

procedure TfrmConfiguracao.pnlModoAdmClick(Sender: TObject);
var
  lFormulario: TfrmModoADM;
  lFormularioAlt: TfrmManipularegistrostabelaaux;
begin
  lFormulario := TfrmModoADM.Create(nil);
  try
    lFormulario.ShowModal;
    if lFormulario.PermiteModoADM then
    begin
      lFormularioAlt := TfrmManipularegistrostabelaaux.Create(nil);
      try
        lFormularioAlt.ShowModal;
      finally
        lFormularioAlt.Free;
      end;
    end;
  finally
    lFormulario.Free;
  end;
end;

end.
