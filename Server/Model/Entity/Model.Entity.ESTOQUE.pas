unit Model.Entity.ESTOQUE;

interface

uses System.JSON,  REST.Json, REST.Json.Types, SimpleAttributes;

type
  [Tabela('PRODUTOSMOV')]
  TESTOQUE = class(TObject)
    private
    [JsonName('CODIGO_PRODUTO')]
    FCODPRO: Integer;
    [JsonName('CODIGO_EMPRESA')]
    FCODEMPRESA: Integer;
    [JsonName('CODIGO_MOVIMENTO')]
    FCODMOV: Integer;
    [JsonName('DATA')]
    FDATA: TDate;
    [JsonName('QUANTIDADE')]
    FQTDMOV: Double;
    [JsonName('ESTOQUE_ANTERIOR')]
    FQTDANTERIOR: Double;
    [JsonName('ESTOQUE_ATUAL')]
    FQTDATUAL: Double;
    [JsonName('HISTORICO')]
    FHISTORICO: String;
    [JsonName('USUARIO')]
    FUSUARIO: String;
    public

    constructor Create;
    destructor Destroy; override;

    function ToJSONObject: TJsonObject;
    function ToJsonString: string;
    published
      [Campo('CODPRO'), PK]
      property CODIGO_PRODUTO :Integer read FCODPRO write FCODPRO;
      [Campo('CODEMPRESA')]
      property CODIGO_EMPRESA :Integer read FCODEMPRESA write FCODEMPRESA;
      [Campo('CODMOV')]
      property CODIGO_MOVIMENTO :Integer read FCODMOV write FCODMOV;
      [Campo('DATA')]
      property DATA :TDate read FDATA write FDATA;
      [Campo('QTDMOV')]
      property QUANTIDADE :Double read FQTDMOV write FQTDMOV;
      [Campo('QTDANTERIOR')]
      property ESTOQUE_ANTERIOR :Double read FQTDANTERIOR write FQTDANTERIOR;
      [Campo('QTDATUAL')]
      property ESTOQUE_ATUAL :Double read FQTDATUAL write FQTDATUAL;
      [Campo('HISTORICO')]
      property HISTORICO :String read FHISTORICO  write FHISTORICO;
      [Campo('USUARIO')]
      property USUARIO :String read FUSUARIO write FUSUARIO;
  end;

implementation

{ TESTOQUE }

constructor TESTOQUE.Create;
begin

end;

destructor TESTOQUE.Destroy;
begin

  inherited;
end;

function TESTOQUE.ToJSONObject: TJsonObject;
begin
  Result := TJson.ObjectToJsonObject(Self);
end;

function TESTOQUE.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

end.
