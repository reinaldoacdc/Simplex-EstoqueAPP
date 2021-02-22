unit Controller.Produtos;

interface

uses
  Horse, System.JSON,  REST.Json,
  Model.Entity.PRODUTOS, System.Generics.Collections;

procedure Registry(App : THorse);
procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);

//
function GetByCodFabricante(codfabr, codempresa :String) :TPRODUTOS;
function GetByCodInterno(codfabr, codempresa :String) :TPRODUTOS;

implementation

uses System.SysUtils, SimpleInterface, SimpleDAO, Model.DaoGeneric;

procedure Registry(App : THorse);
begin
  App.Get('/produto', GetID);
end;

procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Produto :TPRODUTOS;
  FDAO : iDAOGeneric<TPRODUTOS>;
  codpro, codempresa :String;
begin
  codpro := Req.Query.ExtractPair('codpro').Value;
  codempresa := Req.Query.ExtractPair('codempresa').Value;


  Produto := GetByCodFabricante(codpro, codempresa);
  if Produto.CODPRO = 0 then
  begin
    Produto := GetByCodInterno(codpro, codempresa)
  end;

  if Produto.CODPRO = 0 then
    Res.Status(404).Send('Produto não encontrado')
  else
    Res.Send<TJSONObject>(Produto.ToJSONObject);
end;



function GetByCodFabricante(codfabr, codempresa :String) :TPRODUTOS;
var
  FDAO : iDAOGeneric<TPRODUTOS>;
begin
  Result := TPRODUTOS.Create;
  FDAO := TDAOGeneric<TPRODUTOS>.New;
  FDAO.DAO
    .SQL
      .Fields('*')
      .Where( Format('codprofabr = ''%s'' and codempresa = %s', [codfabr, codempresa]) )
    .&End
  .Find(TObject(Result));
  Result := Result;
end;

function GetByCodInterno(codfabr, codempresa :String) :TPRODUTOS;
var
  FDAO : iDAOGeneric<TPRODUTOS>;
begin
  Result := TPRODUTOS.Create;
  FDAO := TDAOGeneric<TPRODUTOS>.New;
  FDAO.DAO
    .SQL
      .Fields('*')
      .Where( Format('codpro = %s and codempresa = %s', [codfabr, codempresa]) )
    .&End
  .Find(TObject(Result));
  Result := Result;
end;

end.
