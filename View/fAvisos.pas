unit fAvisos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Samples.Gauges;

type
  TfrmAvisos = class(TForm)
    pnlTitulo: TPanel;
    pnlTopo: TPanel;
    pnlRodape: TPanel;
    gauge: TGauge;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAvisos: TfrmAvisos;

implementation

{$R *.dfm}
{ TfrmAvisos }

end.
