unit uBanco;

interface

uses
  System.JSON,
  REST.JSON,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  uConnection,
  System.SysUtils,
  uInterfacesEntity,
  REST.JSON.Types;

type
  TBanco = class;

  TBanco = class(TInterfacedObject, iBanco)

  private
    Fcodigo: string;
    Fbanco: string;
    Farquivo: string;
    Flocal: string;
    Fnumero_arquivo: string;
    Fdigito_banco: string;
    Fdata_hora_arquivo_sn: string;

  public
    property codigo: string read Fcodigo write Fcodigo;
    property banco: string read Fbanco write Fbanco;
    property arquivo: string read Farquivo write Farquivo;
    property local: string read Flocal write Flocal;
    property numero_arquivo: string read Fnumero_arquivo write Fnumero_arquivo;
    property digito_banco: string read Fdigito_banco write Fdigito_banco;
    property data_hora_arquivo_sn: string read Fdata_hora_arquivo_sn write Fdata_hora_arquivo_sn;

    destructor Destroy; override;
    constructor Create;
    function ToJson: string;
  end;

implementation

destructor TBanco.Destroy;
begin
  inherited;
end;

function TBanco.ToJson: string;
begin
  result := TJson.ObjectToJsonString(self, [joIgnoreEmptyStrings]);
end;

constructor TBanco.Create;
begin
end;

end.
