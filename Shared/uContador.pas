unit uContador; // classe contadora de envios

interface

uses
  uInterfacesAPI, System.SysUtils;

type

  TContador = class;

  TContador = class(TInterfacedObject, iErro)
  private
    FSucesso: integer;
    FExcluido: integer;
    FErro: integer;

    FRecebimentoCP: integer;
    FRecebimentoCR: integer;
    FEnvioCP: integer;
    FEnvioCR: integer;

    FTotalRecebimentoCP: integer;
    FTotalRecebimentoCR: integer;
    FTotalEnvioCP: integer;
    FTotalEnvioCR: integer;

    class var FContador: TContador;

  public
    destructor Destroy; override;
    constructor Create;

    property Sucesso: integer read FSucesso write FSucesso;
    property Excluido: integer read FExcluido write FExcluido;
    property Erro: integer read FErro write FErro;

    property RecebimentoCP: integer read FRecebimentoCP write FRecebimentoCP;
    property RecebimentoCR: integer read FRecebimentoCR write FRecebimentoCR;
    property EnvioCP: integer read FEnvioCP write FEnvioCP;
    property EnvioCR: integer read FEnvioCR write FEnvioCR;

    property TotalRecebimentoCP: integer read FTotalRecebimentoCP write FTotalRecebimentoCP;
    property TotalRecebimentoCR: integer read FTotalRecebimentoCR write FTotalRecebimentoCR;
    property TotalEnvioCP: integer read FTotalEnvioCP write FTotalEnvioCP;
    property TotalEnvioCR: integer read FTotalEnvioCR write FTotalEnvioCR;

    class procedure ReleaseMe;
    class function GetContador: TContador; static;
    class property Contador: TContador read GetContador write FContador;
  end;

implementation

{ TContador }

constructor TContador.Create;
begin

end;

destructor TContador.Destroy;
begin

  inherited;
end;

class function TContador.GetContador: TContador;
begin
  if NOT Assigned(FContador) then
  begin
    FContador := TContador.Create;
  end;

  result := FContador;
end;

class procedure TContador.ReleaseMe;
begin
  if Assigned(FContador) then
  begin
    FreeAndNil(FContador);
  end;
end;

end.
