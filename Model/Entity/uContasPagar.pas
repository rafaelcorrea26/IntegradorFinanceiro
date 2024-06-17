unit uContasPagar;

interface

uses
  System.JSON,
  REST.JSON,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  uConnection,
  System.SysUtils,
  uInterfacesEntity,
  uFormaPagamento,
  uFornecedor,
  uBanco,
  uVendedor,
  REST.JSON.Types;

type
  TContasPagar = class;

  TContasPagar = class(TInterfacedObject, iContasPagar)
  private
    [jsonmarshalledattribute(false)]
    Fempresa_titulo: string;

    Ftitulo: string;
    Fchave_empresa: string;
    Femissao: String;
    Fempresa: integer;
    Fvendedor: TVendedor;
    Ffornecedor: TFornecedor;
    Fvalor: Double;
    Fvencimento: String;
    Ffluxo_caixa: String;
    Fbanco_cobranca: TBanco;
    Fbanco_pagamento: TBanco;
    Fsituacao: string;
    Fforma_pagamento: TFormaPagamento;
    Fjuros: Double;
    Fdesconto: Double;
    Fdata_pagamento: String;
    Fvalor_pago: Double;
    Ftotal_pago: Double;
    Fdata_hora_cadastro: String;
    Fdata_hora_pagamento: String;
    Fusuario_cadastro: integer;
    Fusuario_pagamento: integer;
    Fdata_hora_alteracao: String;
    Fusuario_alteracao: integer;
    Forigem: string;
    Fano: string;
    Fmes: string;
    Fobs1: string;
    Fobs2: string;
    Fparcial: string;
    Fconta: string;
    Fcodigo_barras: string;
    Fforma_pagamento_baixar: TFormaPagamento;
    Fdata_ultimo_sincronismo: String;

  public
    property titulo: string read Ftitulo write Ftitulo;
    property chave_empresa: string read Fchave_empresa write Fchave_empresa;
    property emissao: String read Femissao write Femissao;
    property empresa: integer read Fempresa write Fempresa;
    property vendedor: TVendedor read Fvendedor write Fvendedor;
    property fornecedor: TFornecedor read Ffornecedor write Ffornecedor;
    property valor: Double read Fvalor write Fvalor;
    property vencimento: String read Fvencimento write Fvencimento;
    property fluxo_caixa: String read Ffluxo_caixa write Ffluxo_caixa;
    property banco_cobranca: TBanco read Fbanco_cobranca write Fbanco_cobranca;
    property banco_pagamento: TBanco read Fbanco_pagamento write Fbanco_pagamento;
    property situacao: string read Fsituacao write Fsituacao;
    property forma_pagamento: TFormaPagamento read Fforma_pagamento write Fforma_pagamento;
    property juros: Double read Fjuros write Fjuros;
    property desconto: Double read Fdesconto write Fdesconto;
    property data_pagamento: String read Fdata_pagamento write Fdata_pagamento;
    property valor_pago: Double read Fvalor_pago write Fvalor_pago;
    property total_pago: Double read Ftotal_pago write Ftotal_pago;
    property data_hora_cadastro: String read Fdata_hora_cadastro write Fdata_hora_cadastro;
    property data_hora_pagamento: String read Fdata_hora_pagamento write Fdata_hora_pagamento;
    property usuario_cadastro: integer read Fusuario_cadastro write Fusuario_cadastro;
    property usuario_pagamento: integer read Fusuario_pagamento write Fusuario_pagamento;
    property data_hora_alteracao: String read Fdata_hora_alteracao write Fdata_hora_alteracao;
    property usuario_alteracao: integer read Fusuario_alteracao write Fusuario_alteracao;
    property origem: string read Forigem write Forigem;
    property ano: string read Fano write Fano;
    property mes: string read Fmes write Fmes;
    property obs1: string read Fobs1 write Fobs1;
    property obs2: string read Fobs2 write Fobs2;
    property parcial: string read Fparcial write Fparcial;
    property conta: string read Fconta write Fconta;
    property codigo_barras: string read Fcodigo_barras write Fcodigo_barras;
    property forma_pagamento_baixar: TFormaPagamento read Fforma_pagamento_baixar write Fforma_pagamento_baixar;
    property empresa_titulo: string read Fempresa_titulo write Fempresa_titulo;
    property data_ultimo_sincronismo: String read Fdata_ultimo_sincronismo write Fdata_ultimo_sincronismo;

    destructor Destroy; override;
    constructor Create;
    function ToJson: string;
    function tojsonWithEmpty: string;
  end;

implementation

destructor TContasPagar.Destroy;
begin
  Fvendedor.Free;
  Ffornecedor.Free;
  Fbanco_cobranca.Free;
  Fbanco_pagamento.Free;
  Fforma_pagamento.Free;
  Fforma_pagamento_baixar.Free;
  inherited;
end;

function TContasPagar.ToJson: string;
begin
  result := TJson.ObjectToJsonString(self, [joIgnoreEmptyStrings]);
end;

function TContasPagar.tojsonWithEmpty: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

constructor TContasPagar.Create;
begin
  Fvendedor := TVendedor.Create;
  Ffornecedor := TFornecedor.Create;
  Fbanco_cobranca := TBanco.Create;
  Fbanco_pagamento := TBanco.Create;
  Fforma_pagamento := TFormaPagamento.Create;
  Fforma_pagamento_baixar := TFormaPagamento.Create;
end;

end.