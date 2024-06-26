unit uVendedor;

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
  TVendedor = class;

  TVendedor = class(TInterfacedObject, iVendedor)
  private
    [JSONMarshalledAttribute(False)]
    Fcodigo: integer;

    Fnome: string;
    Fcomissao_vista: double;
    Fcomissao_prazo: double;
    Fmodifica_preco_venda: boolean;
    Flimite_desconto: double;
    Fmeta_venda: double;
    Fparticipar_agenda: boolean;
    Ftipo_preco_venda: string;
    Fendereco: string;
    Fcpf_cnpj: string;
    Fcidade: string;
    Fcep: string;
    Ffone: string;
    Femail: string;
    Fobservacoes: string;
    Fsenha: string;

  public
    property codigo: integer read Fcodigo write Fcodigo;
    property nome: string read Fnome write Fnome;
    property comissao_vista: double read Fcomissao_vista write Fcomissao_vista;
    property comissao_prazo: double read Fcomissao_prazo write Fcomissao_prazo;
    property modifica_preco_venda: boolean read Fmodifica_preco_venda write Fmodifica_preco_venda;
    property limite_desconto: double read Flimite_desconto write Flimite_desconto;
    property meta_venda: double read Fmeta_venda write Fmeta_venda;
    property participar_agenda: boolean read Fparticipar_agenda write Fparticipar_agenda;
    property tipo_preco_venda: string read Ftipo_preco_venda write Ftipo_preco_venda;
    property endereco: string read Fendereco write Fendereco;
    property cpf_cnpj: string read Fcpf_cnpj write Fcpf_cnpj;
    property cidade: string read Fcidade write Fcidade;
    property cep: string read Fcep write Fcep;
    property fone: string read Ffone write Ffone;
    property email: string read Femail write Femail;
    property observacoes: string read Fobservacoes write Fobservacoes;
    property senha: string read Fsenha write Fsenha;

    destructor Destroy; override;
    constructor Create;
    function ToJson: string;
  end;

implementation

destructor TVendedor.Destroy;
begin

  inherited;
end;

function TVendedor.ToJson: string;
begin
  result := TJson.ObjectToJsonString(self, [joIgnoreEmptyStrings]);
end;

constructor TVendedor.Create;
begin

end;

end.
