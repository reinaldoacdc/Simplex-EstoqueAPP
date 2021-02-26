unit Controller.Empresa;

interface

uses Horse, System.JSON,  REST.Json, System.Generics.Collections;

procedure Registry(App : THorse);
procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses System.SysUtils, Model.DaoGeneric, Model.Entity.EMPRESA;


procedure Registry(App : THorse);
begin
  App.Get('/empresas', Get);
  //App.Post('/estoque', PostId)
end;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Empresas :TObjectList<TEMPRESA>;
  FDAO : iDAOGeneric<TEMPRESA>;
begin
  Empresas := TObjectList<TEMPRESA>.Create;
  FDAO := TDAOGeneric<TEMPRESA>.New;
  try
    FDAO.Find;

    Res.Send<TJSONArray>(FDAO.DataSetAsJsonArray);
  except on E :Exception do
    Res.Status(500).Send('Error: ' + E.Message);
  end;

end;

end.
