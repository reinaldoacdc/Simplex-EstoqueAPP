unit Model.Entity.PRODUTOS;

interface


uses System.JSON,  REST.Json, REST.Json.Types, SimpleAttributes;

type
  [Tabela('VIEW_PRODUTOS')]
  TPRODUTOS = class
  private
    FCODPROFABR: String;
    FLOCAL_ESTOQUE: String;
    FDESCRICAO: String;
    FCODFABR: Integer;
    FCODEMPRESA: Integer;
    FESTOQUE: Double;
    [JsonName('CODIGO_PRODUTO')]
    FCODPRO: Integer;
    FREFERENCIAINTERNA: String;
    FUNIDADE: String;
    FINFORMACAO_COMPLEMENTAR: String;
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
