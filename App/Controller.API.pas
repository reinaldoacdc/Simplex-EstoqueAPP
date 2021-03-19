unit Controller.API;

interface

uses  Model.Entity.PRODUTOS,
System.Classes, System.JSON, System.Net.HttpClient, System.Net.HttpClientComponent,
  Model.List.PRODUTOS;

type TApi = class
private
  FNetHTTPClient :TNetHTTPClient;
  FNetHTTPRequest :TNetHTTPRequest;
  FJSonObject :TJSONObject;
protected

public
  function Login(username, password :String) :Boolean;

  function getProdutoCodFabr(id :String; codempresa :Integer) :TListaProdutos;
  function getProdutoCodInterno(id :String; codempresa :Integer) :TListaProdutos;
  function getProdutoCodBarras(id :String; codempresa :Integer) :TPRODUTOS;
  function getEmprsas :TStringList;
  procedure postEstoque(codpro :Integer; qtdade :Double; codempresa :Integer);

  constructor Create; overload;
  destructor Destroy; override;
published

end;

var
  objAPI :TApi;

implementation

uses  REST.Json, System.SysUtils, uConfigINI, Model.Entity.ESTOQUE;

{ TApi }

function TApi.getEmprsas: TStringList;
var
  Url, JSonData   : String;
  JsonArray :TJSONArray;
  ArrayElement: TJSonValue;
  codempresa, nomefantasia :String;
begin
  Url := Format('http://%s/empresas', [ConfigINI.AcessoBanco.URL_API]);
  JSonData := FNetHTTPRequest.Get(Url).ContentAsString;
  JsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JsonData),0) as TJSONArray;
  Result := TStringList.Create;

  for ArrayElement in JsonArray do
  begin
    codempresa   := ArrayElement.GetValue<STRING>('CODEMPRESA');
    nomefantasia := ArrayElement.GetValue<STRING>('NOMEFANTASIA');

    Result.Add(Format('%s - %s', [codempresa, nomefantasia]));
  end;
end;

function TApi.getProdutoCodBarras(id: String; codempresa: Integer): TPRODUTOS;
var
  Url, JSonData   : String;
  item: TJSONObject;
begin
  Url := Format('http://%s/produto/codbarras/?codpro=%s&codempresa=%d', [ConfigINI.AcessoBanco.URL_API, id, codempresa]);
  JSonData := FNetHTTPRequest.Get(Url).ContentAsString;

  //FJSonObject := TJSONObject.ParseJSONValue(JsonData) as TJSONObject;
  FJSonObject := TJSONObject.ParseJSONValue( TEncoding.UTF8.GetBytes(JsonData),0) as TJSONObject;
  Result := Tjson.JsonToObject<TPRODUTOS>(FJSonObject);
end;

function TApi.getProdutoCodFabr(id :String; codempresa :Integer) :TListaProdutos;
var
  Url, JSonData   : String;
  item: TJSONObject;
begin
  Url := Format('http://%s/produto/codfabr/?codpro=%s&codempresa=%d', [ConfigINI.AcessoBanco.URL_API, id, codempresa]);
  JSonData := FNetHTTPRequest.Get(Url).ContentAsString;

  //FJSonObject := TJSONObject.ParseJSONValue(JsonData) as TJSONObject;
  FJSonObject := TJSONObject.ParseJSONValue( TEncoding.UTF8.GetBytes(JsonData),0) as TJSONObject;
  Result := Tjson.JsonToObject<TListaProdutos>(FJSonObject);
end;

function TApi.getProdutoCodInterno(id: String; codempresa: Integer): TListaProdutos;
var
  Url, JSonData   : String;
  item: TJSONObject;
begin
  Url := Format('http://%s/produto/codinterno/?codpro=%s&codempresa=%d', [ConfigINI.AcessoBanco.URL_API, id, codempresa]);
  JSonData := FNetHTTPRequest.Get(Url).ContentAsString;

  //FJSonObject := TJSONObject.ParseJSONValue(JsonData) as TJSONObject;
  FJSonObject := TJSONObject.ParseJSONValue( TEncoding.UTF8.GetBytes(JsonData),0) as TJSONObject;
  Result := Tjson.JsonToObject<TListaProdutos>(FJSonObject);
end;

function TApi.Login(username, password: String): Boolean;
var
  Url, JSonData   : String;
  resp :IHTTPResponse;
begin
  Result := False;
  Url := Format('http://%S/login?user=%s&password=%s', [ConfigINI.AcessoBanco.URL_API, username, password]);

  try
    resp := FNetHTTPRequest.Get(Url);


    if resp.GetStatusCode = 200 then
      Result := True;
  except
    Result := False;
  end;
end;

procedure TApi.postEstoque(codpro: Integer; qtdade: Double; codempresa :Integer);
var
  Url, JSonData   : String;
  estoque :TESTOQUE;
begin
  Url := Format('http://%s/estoque?codpro=%d&codempresa=%d', [ConfigINI.AcessoBanco.URL_API, codpro, codempresa]);
  JSonData := FNetHTTPRequest.Get(Url).ContentAsString;

  FJSonObject := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JsonData),0) as TJSONObject;
  estoque := Tjson.JsonToObject<TESTOQUE>(FJSonObject);
  estoque.USUARIO    := ConfigINI.AcessoBanco.OperadorNome;
  estoque.QUANTIDADE := qtdade;


  Url := Format('http://%s/estoque', [ConfigINI.AcessoBanco.URL_API]);
  FNetHTTPRequest.Post(Url, TstringStream.Create(estoque.ToJsonString)  );
end;

constructor TApi.Create;
begin
  inherited;
  FJSonObject := TJSonObject.Create;
  FNetHTTPClient  := TNetHTTPClient.Create(nil);
  FNetHTTPRequest := TNetHTTPRequest.Create(nil);
  FNetHTTPRequest.Client := FNetHTTPClient;
end;

destructor TApi.Destroy;
begin
  FNetHTTPRequest.Free;
  FNetHttpClient.Free;
  FJsonObject.Free;
  inherited;
end;


initialization
  objAPI := TApi.Create;

finalization
  objAPI.Free;


end.
