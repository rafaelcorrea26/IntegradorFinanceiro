unit uFormaPagamento;

interface

uses
  System.JSON,
  REST.JSON,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  uConnection,
  System.SysUtils,
  uInterfacesEntity,
  REST.JSON.Types,
  uConta;

type
  TFormaPagamento = class;

  TFormaPagamento = class(TInterfacedObject, iFormaPagamento)
  private
    Fcodigo: integer;
    Fdescricao: string;
    Ftipo: string;
    Fcodigo_ecf: string;
    Forigem: string;
    Fnome_fiscal: string;
    Fpermite_desconto: string;
    Ftipo_da_comissao: string;
    Ftipo_de_movimentacao: string;
    Fqtde_dias_para_primeiro_vencimento: integer;
    Fagrupar: string;
    Fmultiplas_formas_de_pagamento: string;
    Fforma_de_fechamento: integer;
    Fimprimir_boleto: string;
    Flancar_no_caixa: string;
    Fbanco_de_lancamento_no_caixa: integer;
    Fconta_de_lancamento_no_caixa: TConta;
    Fpermite_sped_fiscal: string;
    Fpermite_carne_no_final_da_ecf: string;
    Fvalida_se_e_branrisul: boolean;

    Fadministradora_tef: integer;
    Fmaximo_parcelas: integer;
    Fgerar_contas_receber: boolean;
    Fcodigo_scanntech: integer;
    Fprazo_medio: integer;
    Fimprime_duas_vias: boolean;
    Fconfissao_divida: boolean;

    [jsonmarshalledattribute(false)]

  public
    property codigo: integer read Fcodigo write Fcodigo;
    property descricao: string read Fdescricao write Fdescricao;
    property tipo: string read Ftipo write Ftipo;
    property codigo_ecf: string read Fcodigo_ecf write Fcodigo_ecf;
    property origem: string read Forigem write Forigem;
    property nome_fiscal: string read Fnome_fiscal write Fnome_fiscal;
    property permite_desconto: string read Fpermite_desconto write Fpermite_desconto;
    property permite_carne_no_final_da_ecf: string read Fpermite_carne_no_final_da_ecf
      write Fpermite_carne_no_final_da_ecf;
    property tipo_da_comissao: string read Ftipo_da_comissao write Ftipo_da_comissao;
    property tipo_de_movimentacao: string read Ftipo_de_movimentacao write Ftipo_de_movimentacao;
    property qtde_dias_para_primeiro_vencimento: integer read Fqtde_dias_para_primeiro_vencimento
      write Fqtde_dias_para_primeiro_vencimento;
    property agrupar: string read Fagrupar write Fagrupar;
    property multiplas_formas_de_pagamento: string read Fmultiplas_formas_de_pagamento write Fmultiplas_formas_de_pagamento;
    property forma_de_fechamento: integer read Fforma_de_fechamento write Fforma_de_fechamento;
    property imprimir_boleto: string read Fimprimir_boleto write Fimprimir_boleto;
    property lancar_no_caixa: string read Flancar_no_caixa write Flancar_no_caixa;
    property banco_de_lancamento_no_caixa: integer read Fbanco_de_lancamento_no_caixa
      write Fbanco_de_lancamento_no_caixa;
    property conta_de_lancamento_no_caixa: TConta read Fconta_de_lancamento_no_caixa
      write Fconta_de_lancamento_no_caixa;
    property permite_sped_fiscal: string read Fpermite_sped_fiscal write Fpermite_sped_fiscal;
    property valida_se_e_banrisul: boolean read Fvalida_se_e_branrisul write Fvalida_se_e_branrisul;
    property imprime_duas_vias: boolean read Fimprime_duas_vias write Fimprime_duas_vias;
    property maximo_parcelas: integer read Fmaximo_parcelas write Fmaximo_parcelas;
    property prazo_medio: integer read Fprazo_medio write Fprazo_medio;
    property confissao_divida: boolean read Fconfissao_divida write Fconfissao_divida;
    property administradora_tef: integer read Fadministradora_tef write Fadministradora_tef;
    property gerar_contas_receber: boolean read Fgerar_contas_receber write Fgerar_contas_receber;
    property codigo_scanntech: integer read Fcodigo_scanntech write Fcodigo_scanntech;

    destructor destroy; override;
    constructor create;

    function ToJson: string;
  end;

implementation

function TFormaPagamento.ToJson: string;
begin
  result := TJson.ObjectToJsonString(self, [joIgnoreEmptyStrings]);
end;

constructor TFormaPagamento.create;
begin
  Fconta_de_lancamento_no_caixa := TConta.create;
end;

destructor TFormaPagamento.destroy;
begin
  Fconta_de_lancamento_no_caixa.Free;
end;

end.
