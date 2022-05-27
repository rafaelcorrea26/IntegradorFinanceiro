unit fManipulaRegistrosTabelaAux;

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
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  System.ImageList,
  Vcl.ImgList,
  Vcl.ComCtrls,
  fModoADM, uQuery;

type
  TfrmManipulaRegistrosTabelaAux = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel5: TPanel;
    btnSair: TButton;
    Panel6: TPanel;
    Panel7: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    imlIconsBlack24dp: TImageList;
    dtpDataFiltroCR: TDateTimePicker;
    pnlModoAdm: TPanel;
    btnAttParaEnvioFN: TButton;
    btnAttParaEnvioCP: TButton;
    dtpDataFiltroCP: TDateTimePicker;
    Label1: TLabel;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSairClick(Sender: TObject);
    procedure btnSairStatusClick(Sender: TObject);
    procedure btnAttParaEnvioFNClick(Sender: TObject);
    procedure btnAttParaEnvioCPClick(Sender: TObject);
  private
    { Private declarations }
    procedure AtualizaContasReceber;
    procedure AtualizaContasPagar;
    procedure CarregaConfiguracao;

  public
    { Public declarations }
    FID: string;
    FDesc: string;
  end;

var
  frmManipulaRegistrosTabelaAux: TfrmManipulaRegistrosTabelaAux;

implementation

{$R *.dfm}

procedure TfrmManipulaRegistrosTabelaAux.AtualizaContasPagar;
var
  lTotalAlterados: Integer;
  lQuery, lQuerySalva: TQuery;
begin
  lTotalAlterados := 0;
  try
    lQuery := TQuery.Create(nil);
    lQuerySalva := TQuery.Create(nil);
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' select AC08TIT from MC08CPAG   ');
      lQuery.SQL.Add(' where AD08EMISSAO >= :AD08EMISSAO ');
      lQuery.ParamByName('AD08EMISSAO').AsDateTime := dtpDataFiltroCP.DateTime;
      lQuery.open;
      lQuery.FetchAll;

      if lQuery.RecordCount > 0 then
      begin
        while not(lQuery.Eof) do
        begin
          lQuerySalva.Close;
          lQuerySalva.SQL.Clear;
          lQuerySalva.SQL.Add(' update or insert into tbl_integ_cp (              ');
          lQuerySalva.SQL.Add('  TITULO                                           ');
          lQuerySalva.SQL.Add(' ,DATA_ATUALIZACAO                                 ');
          lQuerySalva.SQL.Add(' ,EXCLUIDO                                         ');
          lQuerySalva.SQL.Add(' ,ENVIADO                                          ');
          lQuerySalva.SQL.Add(' ) VALUES(                                         ');
          lQuerySalva.SQL.Add('  :TITULO                                          ');
          lQuerySalva.SQL.Add(' ,:DATA_ATUALIZACAO                                ');
          lQuerySalva.SQL.Add(' ,''N''                                            ');
          lQuerySalva.SQL.Add(' ,''N''                                            ');
          lQuerySalva.SQL.Add(' ) MATCHING (TITULO)                               ');
          lQuerySalva.ParamByName('TITULO').AsString := lQuery.FieldByName('AC08TIT').AsString;
          lQuerySalva.ParamByName('DATA_ATUALIZACAO').AsDateTime := now;
          lQuerySalva.ExecSQL;
          inc(lTotalAlterados);
          lQuery.Next;
        end;
        lQuerySalva.Connection.Commit;
      end;
      ShowMessage('Total de: ' + lTotalAlterados.ToString +
        ' Contas alteradas apartir dos filtros selecionados, tente enviar na tela inicial. ');

    finally
      lQuerySalva.Free;
      lQuery.Free;
    end;

  except
    on e: Exception do
      ShowMessage('Problemas ao alterar as  contas.');
  end;
end;

procedure TfrmManipulaRegistrosTabelaAux.AtualizaContasReceber;
var
  lTotalAlterados: Integer;
  lQuery, lQuerySalva: TQuery;
begin
  lTotalAlterados := 0;
  try
    lQuery := TQuery.Create(nil);
    lQuerySalva := TQuery.Create(nil);
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' select AC09DUP from MC09CREC   ');
      lQuery.SQL.Add(' where AD09EMISSAO >= :AD09EMISSAO ');
      lQuery.ParamByName('AD09EMISSAO').AsDateTime := dtpDataFiltroCR.DateTime;
      lQuery.open;
      lQuery.FetchAll;

      if lQuery.RecordCount > 0 then
      begin
        while not(lQuery.Eof) do
        begin
          lQuerySalva.Close;
          lQuerySalva.SQL.Clear;
          lQuerySalva.SQL.Add(' update or insert into tbl_integ_cr (              ');
          lQuerySalva.SQL.Add('  duplicata                                           ');
          lQuerySalva.SQL.Add(' ,DATA_ATUALIZACAO                                 ');
          lQuerySalva.SQL.Add(' ,EXCLUIDO                                         ');
          lQuerySalva.SQL.Add(' ,ENVIADO                                          ');
          lQuerySalva.SQL.Add(' ) VALUES(                                         ');
          lQuerySalva.SQL.Add('  :duplicata                                          ');
          lQuerySalva.SQL.Add(' ,:DATA_ATUALIZACAO                                ');
          lQuerySalva.SQL.Add(' ,''N''                                            ');
          lQuerySalva.SQL.Add(' ,''N''                                            ');
          lQuerySalva.SQL.Add(' ) MATCHING (duplicata)                               ');
          lQuerySalva.ParamByName('duplicata').AsString := lQuery.FieldByName('AC09DUP').AsString;
          lQuerySalva.ParamByName('DATA_ATUALIZACAO').AsDateTime := now;
          lQuerySalva.ExecSQL;
          inc(lTotalAlterados);
          lQuery.Next;
        end;
        lQuerySalva.Connection.Commit;
      end;
      ShowMessage('Total de: ' + lTotalAlterados.ToString +
        ' Contas alteradas apartir dos filtros selecionados, tente enviar na tela inicial. ');

    finally
      lQuerySalva.Free;
      lQuery.Free;
    end;

  except
    on e: Exception do
      ShowMessage('Problemas ao alterar as  contas.');
  end;
end;

procedure TfrmManipulaRegistrosTabelaAux.btnAttParaEnvioCPClick(Sender: TObject);
begin
  AtualizaContasPagar;
end;

procedure TfrmManipulaRegistrosTabelaAux.btnAttParaEnvioFNClick(Sender: TObject);
begin
  AtualizaContasReceber;
end;

procedure TfrmManipulaRegistrosTabelaAux.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmManipulaRegistrosTabelaAux.btnSairStatusClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmManipulaRegistrosTabelaAux.CarregaConfiguracao;
begin
end;

procedure TfrmManipulaRegistrosTabelaAux.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmManipulaRegistrosTabelaAux.FormShow(Sender: TObject);
begin
  dtpDataFiltroCP.SetFocus;
end;

end.
