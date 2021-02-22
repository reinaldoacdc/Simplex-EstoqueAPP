unit Model.Entity.USUARIOS;

interface

uses System.JSON,  REST.Json, REST.Json.Types, SimpleAttributes;

type
  [Tabela('USUARIOS')]
  TUSUARIOS = class
private
    FUSUARIO: String;
    FSENHA: String;
    FNOMEUSU: String;
protected

public
    constructor Create;
    destructor Destroy; override;

    function ToJSONObject: TJsonObject;
    function ToJsonString: string;
published
  [Campo('USUARIO'), PK]
  property USUARIO :String  read FUSUARIO write FUSUARIO;
  [Campo('SENHA')]
  property SENHA :String read FSENHA write FSENHA;
  [Campo('NOMEUSU')]
  property NOMEUSU :String read FNOMEUSU write FNOMEUSU;
end;

implementation

{ TUSUARIOS }

{ TUSUARIOS }

constructor TUSUARIOS.Create;
begin

end;

destructor TUSUARIOS.Destroy;
begin

  inherited;
end;

function TUSUARIOS.ToJSONObject: TJsonObject;
begin
  Result := TJson.ObjectToJsonObject(Self);
end;

function TUSUARIOS.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

end.
