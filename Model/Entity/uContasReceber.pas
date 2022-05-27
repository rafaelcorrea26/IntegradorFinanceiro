unit uContasReceber;

interface

uses
  system.json,
  rest.json,
  system.generics.collections,
  firedac.comp.client,
  uconnection,
  system.sysutils,
  uinterfacesentity,
  ucliente,
  uvendedor,
  uformapagamento,
  ubanco,
  uConta,
  rest.json.Types;

type
  TContasReceber = class;

  TContasReceber = class(tinterfacedobject, icontasreceber)

  private
    [jsonmarshalledattribute(false)]
    Fempresa_duplicata: string;

    Fduplicata: string;
    Fchave_empresa: string;
    Fempresa: string;
    Femissao: String;
    Fvalor: double;
    Fvencimento: String;
    Ffluxo: String;
    Fvendedor: tvendedor;
    Flocal_cobranca: tbanco;
    Flocal_pagamento: tbanco;
    Fsituacao: string;
    Fforma_pagamento: tformapagamento;
    Fjuros: double;
    Fdesconto: double;
    Fdata_pagamento: String;
    Fvalor_pago: double;
    Ftotal_pago: double;
    Fdata_hora_cadastro: String;
    Fdata_hora_pagamento: String;
    Fusuario_cadastro: integer;
    Fusuario_pagamento: integer;
    Fdata_hora_alteracao: String;
    Fusuario_alteracao: integer;
    Forigem: string;
    Fvalor_origem: double;
    Fbaixa_parcial: string;
    Fano: string;
    Fmes: string;
    Fobs1: string;
    Fobs2: string;
    Fcomissao: double;
    Fvalor_original: double;
    Fvalor_principal: double;
    Ftotal_receber: double;
    Fconta: Tconta;
    Fforma_pagamento_baixar: tformapagamento;
    Fcliente: tcliente;
    Fdata_ultimo_sincronismo: String;

    procedure setcliente(const value: tcliente);
    procedure setvendedor(const value: tvendedor);
    procedure setformapagamento(const value: tformapagamento);
    procedure setformapagamentobaixar(const value: tformapagamento);
    procedure setconta(const value: Tconta);
    procedure setlocalcobranca(const value: tbanco);
    procedure setlocalpagamento(const value: tbanco);
  public
    property duplicata: string read Fduplicata write Fduplicata;
    property chave_empresa: string read Fchave_empresa write Fchave_empresa;
    property empresa: string read Fempresa write Fempresa;
    property emissao: String read Femissao write Femissao;
    property valor: double read Fvalor write Fvalor;
    property vencimento: String read Fvencimento write Fvencimento;
    property fluxo: String read Ffluxo write Ffluxo;
    property vendedor: tvendedor read Fvendedor write setvendedor;
    property local_cobranca: tbanco read Flocal_cobranca write setlocalcobranca;
    property local_pagamento: tbanco read Flocal_pagamento write setlocalpagamento;
    property situacao: string read Fsituacao write Fsituacao;
    property forma_pagamento: tformapagamento read Fforma_pagamento write setformapagamento;
    property juros: double read Fjuros write Fjuros;
    property desconto: double read Fdesconto write Fdesconto;
    property data_pagamento: string read Fdata_pagamento write Fdata_pagamento;
    property valor_pago: double read Fvalor_pago write Fvalor_pago;
    property total_pago: double read Ftotal_pago write Ftotal_pago;
    property data_hora_cadastro: String read Fdata_hora_cadastro write Fdata_hora_cadastro;
    property data_hora_pagamento: String read Fdata_hora_pagamento write Fdata_hora_pagamento;
    property usuario_cadastro: integer read Fusuario_cadastro write Fusuario_cadastro;
    property usuario_pagamento: integer read Fusuario_pagamento write Fusuario_pagamento;
    property data_hora_alteracao: String read Fdata_hora_alteracao write Fdata_hora_alteracao;
    property usuario_alteracao: integer read Fusuario_alteracao write Fusuario_alteracao;
    property origem: string read Forigem write Forigem;
    property valor_origem: double read Fvalor_origem write Fvalor_origem;
    property baixa_parcial: string read Fbaixa_parcial write Fbaixa_parcial;
    property ano: string read Fano write Fano;
    property mes: string read Fmes write Fmes;
    property obs1: string read Fobs1 write Fobs1;
    property obs2: string read Fobs2 write Fobs2;
    property comissao: double read Fcomissao write Fcomissao;
    property valor_original: double read Fvalor_original write Fvalor_original;
    property valor_principal: double read Fvalor_principal write Fvalor_principal;
    property total_receber: double read Ftotal_receber write Ftotal_receber;
    property conta: Tconta read Fconta write Fconta;
    property forma_pagamento_baixar: tformapagamento read Fforma_pagamento_baixar write setformapagamentobaixar;
    property cliente: tcliente read Fcliente write setcliente;
    property empresa_duplicata: string read Fempresa_duplicata write Fempresa_duplicata;
    property data_ultimo_sincronismo: String read Fdata_ultimo_sincronismo write Fdata_ultimo_sincronismo;

    destructor destroy; override;
    constructor create;
    function tojson: string;
    function tojsonWithEmpty: string;
  end;

implementation

function TContasReceber.tojson: string;
begin
  result := tjson.objecttojsonstring(self, [joignoreemptystrings]);
end;

function TContasReceber.tojsonWithEmpty: string;
begin
  result := tjson.objecttojsonstring(self);
end;

constructor TContasReceber.create;
begin
  Fcliente := tcliente.create;
  Fvendedor := tvendedor.create;
  Fforma_pagamento := tformapagamento.create;
  Fforma_pagamento_baixar := tformapagamento.create;
  Fconta := Tconta.create;
  Flocal_cobranca := tbanco.create;
  Flocal_pagamento := tbanco.create;
end;

destructor TContasReceber.destroy;
begin
  Fcliente.free;
  Fvendedor.free;
  Fforma_pagamento.free;
  Fforma_pagamento_baixar.free;
  Fconta.free;
  Flocal_cobranca.free;
  Flocal_pagamento.free;
  inherited;
end;

procedure TContasReceber.setlocalcobranca(const value: tbanco);
begin
  Flocal_cobranca := value;
end;

procedure TContasReceber.setlocalpagamento(const value: tbanco);
begin
  Flocal_pagamento := value;
end;

procedure TContasReceber.setcliente(const value: tcliente);
begin
  Fcliente := value;
end;

procedure TContasReceber.setconta(const value: Tconta);
begin
  Fconta := value;
end;

procedure TContasReceber.setformapagamento(const value: tformapagamento);
begin
  Fforma_pagamento := value;
end;

procedure TContasReceber.setformapagamentobaixar(const value: tformapagamento);
begin
  Fforma_pagamento_baixar := value;
end;

procedure TContasReceber.setvendedor(const value: tvendedor);
begin
  Fvendedor := value;
end;

end.
