unit uFornecedor;

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
  TFornecedor = class;

  TFornecedor = class(TInterfacedObject, iFornecedor)
  private
    [JSONMarshalledAttribute(False)]
    Fcodigo: integer;

    Fnome: string;
    Ffantasia: string;
    Fendereco: string;
    Fnumero: string;
    Fbairro: string;
    Fcidade: string;
    Fcep: string;
    Fie: string;
    Ffone: string;
    Ffax: string;
    Fcelular: string;
    Femail: string;
    Fcodigo_cidade_ibge: string;
    Fuf: string;
    Fsped: boolean;
    Fusuario_cadastro: integer;
    Fusuario_alteracao: integer;
    Fdata_alteracao: String;
    Fdata_cadastro: String;
    Fativo: boolean;
    Fpessoa_fisica: boolean;
    Fcpf: string;
    fcnpj: string;
    fsite: string;
    fobservacao1: string;
    Fobservacao2: string;
    Fendereco_cobranca: string;
    Fbairro_cobranca: string;
    Fcidade_cobranca: string;
    Fcep_cobranca: string;
    Fuf_cobranca: string;
    Flocalizacao: integer;
    Fextra: integer;
    Futilizar_rotina_atacado: boolean;
    Fobservacao_geral: string;
    Fnome_representante: string;
    Ffone_representante: string;
    Femail_representante: string;
    Femissao_ultimo_movimento: String;
    Fnota_fiscal_ultimo_movimento: string;
    Fvalor_nota_fiscal_ultimo_movimento: double;
    Fdata_nascimento: String;
    Fcarteira_identidade: string;
    Fsequencia: integer;
    Falterar_custos: boolean;
    Fregime_tributario: integer;
    Fcrt: integer;
    fcnae: string;

  public
    property codigo: integer read Fcodigo write Fcodigo;
    property nome: string read Fnome write Fnome;
    property fantasia: string read Ffantasia write Ffantasia;
    property endereco: string read Fendereco write Fendereco;
    property numero: string read Fnumero write Fnumero;
    property bairro: string read Fbairro write Fbairro;
    property cidade: string read Fcidade write Fcidade;
    property cep: string read Fcep write Fcep;
    property ie: string read Fie write Fie;
    property fone: string read Ffone write Ffone;
    property fax: string read Ffax write Ffax;
    property celular: string read Fcelular write Fcelular;
    property email: string read Femail write Femail;
    property codigo_cidade_ibge: string read Fcodigo_cidade_ibge write Fcodigo_cidade_ibge;
    property uf: string read Fuf write Fuf;
    property sped: boolean read Fsped write Fsped;
    property usuario_cadastro: integer read Fusuario_cadastro write Fusuario_cadastro;
    property usuario_alteracao: integer read Fusuario_alteracao write Fusuario_alteracao;
    property data_cadastro: String read Fdata_cadastro write Fdata_cadastro;
    property data_alteracao: String read Fdata_alteracao write Fdata_alteracao;
    property ativo: boolean read Fativo write Fativo;
    property pessoa_fisica: boolean read Fpessoa_fisica write Fpessoa_fisica;
    property cpf: string read Fcpf write Fcpf;
    property cnpj: string read fcnpj write fcnpj;
    property site: string read fsite write fsite;
    property observacao1: string read fobservacao1 write fobservacao1;
    property observacao2: string read Fobservacao2 write Fobservacao2;
    property endereco_cobranca: string read Fendereco_cobranca write Fendereco_cobranca;
    property bairro_cobranca: string read Fbairro_cobranca write Fbairro_cobranca;
    property cidade_cobranca: string read Fcidade_cobranca write Fcidade_cobranca;
    property cep_cobranca: string read Fcep_cobranca write Fcep_cobranca;
    property uf_cobranca: string read Fuf_cobranca write Fuf_cobranca;
    property localizacao: integer read Flocalizacao write Flocalizacao;
    property extra: integer read Fextra write Fextra;
    property utilizar_rotina_atacado: boolean read Futilizar_rotina_atacado write Futilizar_rotina_atacado;
    property observacao_geral: string read Fobservacao_geral write Fobservacao_geral;
    property nome_representante: string read Fnome_representante write Fnome_representante;
    property fone_representante: string read Ffone_representante write Ffone_representante;
    property email_representante: string read Femail_representante write Femail_representante;
    property emissao_ultimo_movimento: String read Femissao_ultimo_movimento write Femissao_ultimo_movimento;
    property nota_fiscal_ultimo_movimento: string read Fnota_fiscal_ultimo_movimento
      write Fnota_fiscal_ultimo_movimento;
    property valor_nota_fiscal_ultimo_movimento: double read Fvalor_nota_fiscal_ultimo_movimento
      write Fvalor_nota_fiscal_ultimo_movimento;
    property data_nascimento: String read Fdata_nascimento write Fdata_nascimento;
    property carteira_identidade: string read Fcarteira_identidade write Fcarteira_identidade;
    property sequencia: integer read Fsequencia write Fsequencia;
    property alterar_custos: boolean read Falterar_custos write Falterar_custos;

    property regime_tributario: integer read Fregime_tributario write Fregime_tributario;
    property crt: integer read Fcrt write Fcrt;
    property cnae: string read fcnae write fcnae;

    destructor Destroy; override;
    constructor Create;

    function Get(pAll: boolean = False): string;
    function GetCNPJ(pCNPJ: string): integer;
    function Delete: string;
    function Put: string;
    function Post: string;
    function ToJson: TJSONObject;
  end;

implementation

function TFornecedor.ToJson: TJSONObject;
begin
  result := TJson.ObjectToJsonObject(self, [joIgnoreEmptyStrings]);
end;

constructor TFornecedor.Create;
begin

end;

function TFornecedor.Delete: string;
begin

end;

destructor TFornecedor.Destroy;
begin
end;

function TFornecedor.Get(pAll: boolean): string;
begin

end;

function TFornecedor.GetCNPJ(pCNPJ: string): integer;
begin

end;

function TFornecedor.Post: string;
begin

end;

function TFornecedor.Put: string;
begin

end;

end.
