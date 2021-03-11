unit uConfigINI;

interface

uses Classes, SysUtils, IniFiles;

type
  TConfigIni = Class;

  TConfigIniBase = Class(TObject)
    private
      FOwner :TConfigIni;
    public
      constructor Create(AOwner :TConfigIni);
      property Owner :TconfigIni read FOwner;
  end;

  TConfigIniAcessoBanco = class(TConfigIniBase)
    private
      function getPathDB: String;
      procedure setPathDB(const Value: String);
    function getUsername: String;
    procedure setUsername(const Value: String);
    function getPassword: String;
    procedure setPassword(const Value: String);
    function getServidor: String;
    procedure setServidor(const Value: String);
    function getURL_API: String;
    procedure setURL_API(const Value: String);
    function getOperador: String;
    procedure setOperador(const Value: String);
    function getOperadorCodigo: Integer;
    procedure setOperadorCodigo(const Value: Integer);
    function getPORTA_API: Integer;
    procedure setPORTA_API(const Value: Integer);
    public
    published
        property URL_API :String read getURL_API write setURL_API;
        property PORTA_API :Integer read getPORTA_API write setPORTA_API;
        property Servidor :String read getServidor write setServidor;
        property Caminho :String read getPathDB write setPathDB;
        property Usuario :String read getUsername write setUsername;
        { TODO : Encrypt get and setter }
        property Senha :String read getPassword write setPassword;
        property OperadorNome :String read getOperador write setOperador;
        property OperadorCodigo :Integer read getOperadorCodigo write setOperadorCodigo;
  end;


  TConfigIni = Class(TIniFile)
      private
        FAcessoBanco :TConfigIniAcessoBanco;
    function getAcessoBanco: TConfigIniAcessoBanco;
    function getUsaAppLeitorCodBarras: Boolean;
    procedure setUsaAppLeitorCodBarras(const Value: Boolean);
      public
      published
        property AcessoBanco :TConfigIniAcessoBanco read getAcessoBanco;
        property UsaAppLeitorCodBarras :Boolean read getUsaAppLeitorCodBarras write setUsaAppLeitorCodBarras;
  end;

var ConfigINI :TConfigIni;


implementation

uses System.IOUtils;

{ TConfigIniBase }

constructor TConfigIniBase.Create(AOwner: TConfigIni);
begin
  FOwner := AOwner;
end;

{ TConfigIniAcessoBanco }


function TConfigIniAcessoBanco.getOperador: String;
begin
  Result := Owner.ReadString('AcessoBanco', 'OperadorNome', '');
end;

function TConfigIniAcessoBanco.getOperadorCodigo: Integer;
begin
  Result := Owner.ReadInteger('AcessoBanco', 'OperadorCodigo', 0);
end;

function TConfigIniAcessoBanco.getPassword: String;
begin
  Result := Owner.ReadString('AcessoBanco', 'Password', '');
end;

function TConfigIniAcessoBanco.getPathDB: String;
begin
  Result := Owner.ReadString('AcessoBanco', 'PathDB', '');
end;

function TConfigIniAcessoBanco.getPORTA_API: Integer;
begin
  Result := Owner.ReadInteger('AcessoBanco', 'PORTA_API', 9000);
end;

function TConfigIniAcessoBanco.getServidor: String;
begin
  Result := Owner.ReadString('AcessoBanco', 'Servidor', '');
end;

function TConfigIniAcessoBanco.getURL_API: String;
begin
  Result := Owner.ReadString('AcessoBanco', 'URL_API', '');
end;

function TConfigIniAcessoBanco.getUsername: String;
begin
  Result := Owner.ReadString('AcessoBanco', 'Username', '');
end;

procedure TConfigIniAcessoBanco.setOperador(const Value: String);
begin
  Owner.WriteString('AcessoBanco', 'OperadorNome', Value);
end;

procedure TConfigIniAcessoBanco.setOperadorCodigo(const Value: Integer);
begin
  Owner.WriteInteger('AcessoBanco', 'OperadorCodigo', Value);
end;

procedure TConfigIniAcessoBanco.setPassword(const Value: String);
begin
  Owner.WriteString('AcessoBanco', 'Password', Value);
end;

procedure TConfigIniAcessoBanco.setPathDB(const Value: String);
begin
  Owner.WriteString('AcessoBanco', 'PathDB', Value);
end;

procedure TConfigIniAcessoBanco.setPORTA_API(const Value: Integer);
begin
  Owner.WriteInteger('AcessoBanco', 'PORTA_API', Value);
end;

procedure TConfigIniAcessoBanco.setServidor(const Value: String);
begin
  Owner.WriteString('AcessoBanco', 'Servidor', Value);
end;

procedure TConfigIniAcessoBanco.setURL_API(const Value: String);
begin
  Owner.WriteString('AcessoBanco', 'URL_API', Value);
end;

procedure TConfigIniAcessoBanco.setUsername(const Value: String);
begin
  Owner.WriteString('AcessoBanco', 'Username', Value);
end;

{ TConfigIni }

function TConfigIni.getAcessoBanco: TConfigIniAcessoBanco;
begin
  Result := TConfigIniAcessoBanco.Create(Self);
end;

function TConfigIni.getUsaAppLeitorCodBarras: Boolean;
begin
  Result := Self.ReadBool('Config', 'UsaAppLeitorCodBarras', False);
end;

procedure TConfigIni.setUsaAppLeitorCodBarras(const Value: Boolean);
begin
  Self.WriteBool('Config', 'UsaAppLeitorCodBarras', Value);
end;

initialization
{$IFDEF Android}
  //ConfigINI := TConfigINI.Create(System.IOUtils.TPath.GetDocumentsPath + System.SysUtils.PathDelim + 'config.ini');
  ConfigINI := TConfigINI.Create(TPath.Combine(TPath.GetDocumentsPath, 'config.ini'));

{$ELSE}
  ConfigINI := TConfigINI.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
{$ENDIF}
//ConfigINI.AcessoBanco.URL_API := 'http://192.168.15.184:9000';
//ConfigINI.UpdateFile;

finalization
  FreeAndNil(ConfigINI);

end.
