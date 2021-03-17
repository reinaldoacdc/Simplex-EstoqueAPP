unit Model.Entity.PRODUTOS;

interface


uses System.JSON,  REST.Json, REST.Json.Types, SimpleAttributes;

type
  [Tabela('VIEW_PRODUTOS')]
  TPRODUTOS = class
  private
    [JsonName('CODPROFABR')]
    FCODPROFABR: String;
    [JsonName('lOCAL_ESTOQUE')]
    FLOCAL_ESTOQUE: String;
    [JsonName('DESCRICAO')]
    FDESCRICAO: String;
    [JsonName('CODFABR')]
    FCODFABR: Integer;
    [JsonName('CODEMPRESA')]
    FCODEMPRESA: Integer;
    [JsonName('ESTOQUE')]
    FESTOQUE: Double;
    [JsonName('CODIGO_PRODUTO')]
    FCODPRO: Integer;
    [JsonName('REFERENCIAINTERNA')]
    FREFERENCIAINTERNA: String;
    [JsonName('UNIDADE')]
    FUNIDADE: String;
    [JsonName('INFORMACAO_COMPLEMENTAR')]
    FINFORMACAO_COMPLEMENTAR: String;
    [JsonName('NOME_FABRICANTE')]
    FNOME_FABRICANTE: String;
    [JsonName('CODIGO_BARRAS')]
    FCODIGO_BARRAS: String;
  public
    function ToJSONObject: TJsonObject;
    function ToJsonString: string;
  published
  [Campo('CODPRO'), PK]
  property CODPRO :Integer read FCODPRO write FCODPRO;
  property CODFABR :Integer read FCODFABR write FCODFABR;
  property CODPROFABR :String read FCODPROFABR write FCODPROFABR;
  property REFERENCIAINTERNA :String read FREFERENCIAINTERNA write FREFERENCIAINTERNA;
  property DESCRICAO :String read FDESCRICAO write FDESCRICAO;
  property INFORMACAO_COMPLEMENTAR :String read FINFORMACAO_COMPLEMENTAR write FINFORMACAO_COMPLEMENTAR;
  property UNIDADE :String read FUNIDADE write FUNIDADE;
  property ESTOQUE :Double read FESTOQUE write FESTOQUE;
  property LOCAL_ESTOQUE :String read FLOCAL_ESTOQUE write FLOCAL_ESTOQUE;
  property CODEMPRESA :Integer read FCODEMPRESA write FCODEMPRESA;
  property NOME_FABRICANTE :String read FNOME_FABRICANTE write FNOME_FABRICANTE;
  property CODIGO_BARRAS :String read FCODIGO_BARRAS write FCODIGO_BARRAS;
end;

implementation

{ TPRODUTOS }

function TPRODUTOS.ToJSONObject: TJsonObject;
begin
  Result := TJson.ObjectToJsonObject(Self);
end;

function TPRODUTOS.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

end.
