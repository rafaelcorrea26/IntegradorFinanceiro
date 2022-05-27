unit fModoADM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.ImageList, Vcl.ImgList, Vcl.ExtCtrls;

type
  TfrmModoADM = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    edtSenha: TEdit;
    imlIconsBlack24dp: TImageList;
    btnIniciarServico: TButton;
    btnPararServico: TButton;
    procedure btnPararServicoClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnIniciarServicoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FPermiteModoADM: Boolean;

  const
    FSenha: string = '196320';
  public
    { Public declarations }

    property PermiteModoADM: Boolean read FPermiteModoADM write FPermiteModoADM;
  end;

var
  frmModoADM: TfrmModoADM;

implementation

{$R *.dfm}

procedure TfrmModoADM.btnIniciarServicoClick(Sender: TObject);
begin
  FPermiteModoADM := false;

  if trim(edtSenha.Text) <> '' then
  begin
    if trim(edtSenha.Text) = FSenha then
    begin
      FPermiteModoADM := true;
    end;
  end;
  Close;
end;

procedure TfrmModoADM.btnPararServicoClick(Sender: TObject);
begin
  FPermiteModoADM := false;
  Close;
end;

procedure TfrmModoADM.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmModoADM.FormShow(Sender: TObject);
begin
  edtSenha.SetFocus;
end;

end.
