unit Controller.Usuarios;

interface

uses Horse, System.JSON, REST.Json;

procedure Registry(App : THorse);
procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);


function CriptografaSenha (Senha : String) : String;

implementation

uses System.SysUtils, Model.DaoGeneric, Model.Entity.USUARIOS;

procedure Registry(App : THorse);
begin
  App.Get('/login', Login);
end;


procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Usuario :TUSUARIOS;
  user, password :String;
  FDAO : iDAOGeneric<TUSUARIOS>;
begin
  user := Req.Query.ExtractPair('user').Value;
  password := Req.Query.ExtractPair('password').Value;
  password := CriptografaSenha(password);

  Usuario := TUSUARIOS.Create;
  FDAO := TDAOGeneric<TUSUARIOS>.New;
  try
    FDAO.DAO
      .SQL
        .Fields('*')
        .Where( Format('usuario = ''%s'' and senha = ''%s'' ', [user, password]) )
      .&End
    .Find(TObject(Usuario));


   if Usuario.NOMEUSU <> '' then
     Res.Send<TJSONObject>(Usuario.ToJSONObject)
   else
     Res.Status(404).Send('Usuário ou senha incorretos');
  except on E :Exception do
    Res.Status(500).Send('Error: ' + E.Message);
  end;
end;


function CriptografaSenha (Senha : String) : String;
var i : Integer;
    sSenhaCript, sLetra : String;
begin
   sSenhaCript := '';
   for i := 1 to Length(Senha) do
   begin
       sLetra := Copy(Senha,i,1);
       sSenhaCript := sSenhaCript + CHR(ORD(sLetra[1]) + i);
   end;
   Result := sSenhaCript;
end;

end.
