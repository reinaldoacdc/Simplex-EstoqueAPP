unit Controller.API;

interface

uses  Model.Entity.PRODUTOS,
 System.JSON, System.Net.HttpClientComponent;

type TApi = class
private
  FNetHTTPClient :TNetHTTPClient;
  FNetHTTPRequest :TNetHTTPRequest;
  FJSonObject :TJSONObject;
protected

public
  function getProduto(id :String) :TPRODUTOS;
  procedure postEstoque(codpro :Integer; qtdade :Double);

  constructor Create; overload;
  destructor Destroy; override;
published

end;

var
  objAPI :TApi;

implementation

uses System.Classes, REST.Json, System.SysUtils, uConfigINI, Model.Entity.ESTOQUE;

{ TApi }

function TApi.getProduto(id :String) :TPRODUTOS;
var
  Url, JSonData   : String;
  item: TJSONObject;
  a: TJSONArray;
  idx :Integer;
begin
  Url := Format('http://%s/produto?codpro=%s&codempresa=%s', [ConfigINI.AcessoBanco.URL_API, id, '1']);
  JSonData := FNetHTTPRequest.Get(Url).ContentAsString;

  FJSonObject := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JsonData),0) as TJSONObject;
  Result := Tjson.JsonToObject<TPRODUTOS>(FJSonObject);
end;

procedure TApi.postEstoque(codpro: Integer; qtdade: Double);
var
  Url, JSonData   : String;
  estoque :TESTOQUE;
begin
  Url := 'http://localhost:9000/estoque?codpro=25547&codempresa=1';
  JSonData := FNetHTTPRequest.Get(Url).ContentAsString;

  FJSonObject := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JsonData),0) as TJSONObject;
  estoque := Tjson.JsonToObject<TESTOQUE>(FJSonObject);
  estoque.USUARIO := 'SUPORTE';
  estoque.QUANTIDADE := qtdade;



  Url := Format('http://%s/estoque', [ConfigINI.AcessoBanco.URL_API]);
  FNetHTTPRequest.Post(Url, TstringStream.Create(estoque.ToJsonString)  );
end;

constructor TApi.Create;
begin
  inherited;
  FNetHTTPClient  := TNetHTTPClient.Create(nil);
  FNetHTTPRequest := TNetHTTPRequest.Create(nil);
  FNetHTTPRequest.Client := FNetHTTPClient;
end;

destructor TApi.Destroy;
begin
  FNetHTTPRequest.Free;
  FNetHttpClient.Free;
  inherited;
end;


initialization
  objAPI := TApi.Create;

finalization
  objAPI.Free;


end.
