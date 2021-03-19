unit Controller.Produtos;

interface

uses
  Horse, System.JSON,  REST.Json,
  Model.Entity.PRODUTOS, System.Generics.Collections, Model.List.PRODUTOS;

procedure Registry(App : THorse);
procedure GetCodFabr(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetCodInterno(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetCodBarras(Req: THorseRequest; Res: THorseResponse; Next: TProc);

//
function GetByCodFabricante(codfabr, codempresa :String) :TObjectList<TPRODUTOS>;
function GetByCodInterno(codfabr, codempresa :String) :TObjectList<TPRODUTOS>;
function GetByCodBarras(codfabr, codempresa :String) :TPRODUTOS;

implementation

uses System.SysUtils, SimpleInterface, SimpleDAO, Model.DaoGeneric;

procedure Registry(App : THorse);
begin
  App.Get('/produto/codfabr/', GetCodFabr);
  App.Get('/produto/codinterno/', GetCodInterno);
  App.Get('/produto/codbarras/', GetCodBarras);
end;



procedure GetCodInterno(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Produtos :TListaProdutos;
  lista :TObjectList<TPRODUTOS>;

  prod :TPRODUTOS;
  FDAO : iDAOGeneric<TPRODUTOS>;
  codpro, codempresa :String;
begin
  Produtos := TListaProdutos.Create;

  codpro := Req.Query.ExtractPair('codpro').Value;
  codempresa := Req.Query.ExtractPair('codempresa').Value;

  lista := GetByCodInterno(codpro, codempresa);

  for prod in lista do
    Produtos.FLista.Add(prod);

  if Produtos.FLista.count  = 0 then
    Res.Status(404).Send('Produto não encontrado')
  else
  begin
    Res.Send<TJSONObject>(Produtos.ToJSONObject);
  end;
end;


procedure GetCodBarras(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Produto :TPRODUTOS;
  FDAO : iDAOGeneric<TPRODUTOS>;
  codpro, codempresa :String;
begin
  codpro := Req.Query.ExtractPair('codpro').Value;
  codempresa := Req.Query.ExtractPair('codempresa').Value;

  Produto := GetByCodBarras(codpro, codempresa);
  if Produto.CODPRO = 0 then
    Res.Status(404).Send('Produto não encontrado')
  else
    Res.Send<TJSONObject>(Produto.ToJSONObject);

end;


procedure GetCodFabr(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Produtos :TListaProdutos;
  lista :TObjectList<TPRODUTOS>;
  prod :TPRODUTOS;
  FDAO : iDAOGeneric<TPRODUTOS>;
  codpro, codempresa :String;
begin
  Produtos := TListaProdutos.Create;

  codpro := Req.Query.ExtractPair('codpro').Value;
  codempresa := Req.Query.ExtractPair('codempresa').Value;

  lista := GetByCodFabricante(codpro, codempresa);

  for prod in lista do
    Produtos.FLista.Add(prod);

  if Produtos.FLista.count  = 0 then
    Res.Status(404).Send('Produto não encontrado')
  else
  begin
    Res.Send<TJSONObject>(Produtos.ToJSONObject);
  end;
end;



function GetByCodFabricante(codfabr, codempresa :String)  :TObjectList<TPRODUTOS>;
var
  FDAO : iDAOGeneric<TPRODUTOS>;
begin
  Result := TObjectList<TPRODUTOS>.Create;
  FDAO := TDAOGeneric<TPRODUTOS>.New;
  FDAO.DAO
    .SQL
      .Fields('*')
      .Where( Format('codprofabr = ''%s'' and codempresa = %s', [codfabr, codempresa]) )
    .&End
  .Find( Result );
end;

function GetByCodInterno(codfabr, codempresa :String) :TObjectList<TPRODUTOS>;
var
  FDAO : iDAOGeneric<TPRODUTOS>;
begin
  Result := TObjectList<TPRODUTOS>.Create;
  FDAO := TDAOGeneric<TPRODUTOS>.New;
  FDAO.DAO
    .SQL
      .Fields('*')
      .Where( Format('codpro = %s and codempresa = %s', [codfabr, codempresa]) )
    .&End
  .Find(Result);
end;

function GetByCodBarras(codfabr, codempresa :String) :TPRODUTOS;
var
  FDAO : iDAOGeneric<TPRODUTOS>;
begin
  Result := TPRODUTOS.Create;
  FDAO := TDAOGeneric<TPRODUTOS>.New;
  FDAO.DAO
    .SQL
      .Fields('*')
      .Where( Format('codigo_barras = %s and codempresa = %s', [codfabr, codempresa]) )
    .&End
  .Find(TObject(Result));
  Result := Result;

end;

end.
