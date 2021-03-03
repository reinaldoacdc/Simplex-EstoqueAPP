unit Controller.Estoque;

interface

uses Horse, System.JSON,  REST.Json, System.Generics.Collections;

procedure Registry(App : THorse);
procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure PostID(Req: THorseRequest; Res: THorseResponse; Next: TProc);

function getUltimoCodigoMovimento(codpro, codempresa :String) :Integer;
function getUltimoEstoque(codpro, codempresa :String) :Double;

implementation

uses System.SysUtils, SimpleInterface, SimpleDAO, Model.DaoGeneric,
  Model.Entity.ESTOQUE;

procedure Registry(App : THorse);
begin
  App.Get('/estoque', GetId);
  App.Post('/estoque', PostId)
end;

procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Estoque :TESTOQUE;
  FDAO : iDAOGeneric<TESTOQUE>;
  codpro, codempresa :String;
  codmov :Integer;
begin
  codpro := Req.Query.ExtractPair('codpro').Value;
  codempresa := Req.Query.ExtractPair('codempresa').Value;
  codmov := getUltimoCodigoMovimento(codpro, codempresa);

  Estoque := TESTOQUE.Create;
  FDAO := TDAOGeneric<TESTOQUE>.New;
  try
    FDAO.DAO
      .SQL
        .Fields('*')
        .Where( Format('codpro = %s and codempresa = %s and codmov = %d', [codpro, codempresa, codmov]) )
      .&End
    .Find(TObject(Estoque));


    Estoque.CODIGO_PRODUTO := StrToInt(codpro);
    Estoque.CODIGO_EMPRESA := StrToInt(codempresa);

    Res.Send<TJSONObject>(Estoque.ToJSONObject);
  except on E :Exception do
    Res.Status(500).Send('Error: ' + E.Message);
  end;
end;

procedure PostID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO : iDAOGeneric<TESTOQUE>;
  Json :TJSONObject;
  carga :TESTOQUE;
  codpro, codempresa :String;
  quantidade, qtd_anterior, qtd_atual :Double;
begin
  FDAO := TDAOGeneric<TESTOQUE>.New;
  json := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) as TJSONObject;
  carga := TESTOQUE.Create;

  codpro := json.GetValue('CODIGO_PRODUTO').Value;
  codempresa := json.GetValue('CODIGO_EMPRESA').Value;

  quantidade := StrToFloat(json.GetValue('QUANTIDADE').Value);
  qtd_anterior := getUltimoEstoque(codpro, codempresa);
  qtd_atual := quantidade + qtd_anterior;

  carga.CODIGO_MOVIMENTO := getUltimoCodigoMovimento(codpro, codempresa) +1;
  carga.DATA := Date;
  carga.HISTORICO := 'Atualização via APP de contagem';
  carga.CODIGO_PRODUTO := StrToInt(codpro);
  carga.CODIGO_EMPRESA := StrToInt(codempresa);

  //
  carga.USUARIO := json.GetValue('USUARIO').Value;

  carga.QUANTIDADE := quantidade;
  carga.ESTOQUE_ANTERIOR := qtd_anterior;
  carga.ESTOQUE_ATUAL := qtd_atual;
  try
    FDAO.Insert(carga);
    Res.Status(200).Send('OK');
  except on E :Exception do
    Res.Status(500).Send('Error: ' + E.Message);
  end;
end;

function getUltimoCodigoMovimento(codpro, codempresa :String) :Integer;
var
  Estoque :TESTOQUE;
  FDAO : iDAOGeneric<TESTOQUE>;
begin
  Estoque := TESTOQUE.Create;
  FDAO := TDAOGeneric<TESTOQUE>.New;
  FDAO.DAO
    .SQL
      .Fields(' max(codmov) as codmov ')
      .Where( Format('codpro = %s and codempresa = %s', [codpro, codempresa]) )
    .&End
  .Find(TObject(Estoque));
  Result := Estoque.CODIGO_MOVIMENTO;
end;

function getUltimoEstoque(codpro, codempresa :String) :Double;
var
  Estoque :TESTOQUE;
  FDAO : iDAOGeneric<TESTOQUE>;
  codmov :Integer;
begin
  codmov := getUltimoCodigoMovimento(codpro, codempresa);

  Estoque := TESTOQUE.Create;
  FDAO := TDAOGeneric<TESTOQUE>.New;
  FDAO.DAO
    .SQL
      .Fields(' * ')
      .Where( Format('codpro = %s and codempresa = %s and codmov = %d ', [codpro, codempresa, codmov]) )
    .&End
  .Find(TObject(Estoque));
  Result := Estoque.ESTOQUE_ATUAL;
end;

end.
