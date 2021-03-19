unit Model.List.PRODUTOS;

interface

uses
  System.JSON, Data.DB, Datasnap.DBclient,
  Model.Entity.PRODUTOS, System.Generics.Collections;

type
  TListaProdutos = class
    private

    public
      FLista :TObjectList<TPRODUTOS>;

      function Find(codpro :Integer) :Integer;

      constructor Create;
      destructor Destroy;

      function ToJSONObject: TJsonObject;
      function ToDataset :TClientDataset;
  end;

implementation

{ TListaProdutos }
uses System.Rtti, REST.Json;

constructor TListaProdutos.Create;
begin
  FLista := TObjectList<TPRODUTOS>.Create;
end;

destructor TListaProdutos.Destroy;
begin
  FLista.Destroy
end;

function TListaProdutos.Find(codpro: Integer): Integer;
var prod :TPRODUTOS;
begin
  for Result := 0 to Self.FLista.Count -1 do
    if Self.FLista[Result].codpro = codpro then
      exit;
  Result := -1;
end;

function TListaProdutos.ToDataset: TClientDataset;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  PropriedadeNome: TRttiProperty;
  Produto: TPRODUTOS;
begin
  Result := TClientDataSet.Create(nil);
  Result.CreateDataSet;
  //Result.Open;
  // Cria o contexto do RTTI
  Contexto := TRttiContext.Create;
  try
    // Obtém as informações de RTTI da classe TFuncionario
    Tipo := Contexto.GetType(TPRODUTOS.ClassInfo);

    // Obtém um objeto referente à propriedade "Nome" da classe TFuncionario
    PropriedadeNome := Tipo.GetProperty('CODPROFABR');

    // Percorre a lista de objetos, inserindo o valor da propriedade "Nome" do ClientDataSet
    for Produto in FLista do
      Result.AppendRecord([PropriedadeNome.GetValue(Produto).AsString]);

    Result.First;
  finally
    Contexto.Free;
  end;
end;

function TListaProdutos.ToJSONObject: TJsonObject;
begin
  Result := TJson.ObjectToJsonObject(Self);
end;

end.
