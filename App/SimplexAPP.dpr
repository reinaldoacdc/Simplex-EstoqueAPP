program SimplexAPP;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.Main in 'Form.Main.pas' {frmMain},
  Form.Login in 'Form.Login.pas' {frmLogin},
  Form.Estoque in 'Form.Estoque.pas' {frmEstoque},
  Form.Configuracao in 'Form.Configuracao.pas' {frmConfiguracao},
  uConfigINI in '..\Server\Classes\uConfigINI.pas',
  Loading in 'Loading.pas',
  Controller.API in 'Controller.API.pas',
  Model.Entity.PRODUTOS in '..\Server\Model\Entity\Model.Entity.PRODUTOS.pas',
  Model.Entity.ESTOQUE in '..\Server\Model\Entity\Model.Entity.ESTOQUE.pas',
  u99Permissions in 'u99Permissions.pas',
  UnitCamera in 'UnitCamera.pas' {FrmCamera};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmEstoque, frmEstoque);
  Application.CreateForm(TfrmConfiguracao, frmConfiguracao);
  Application.CreateForm(TFrmCamera, FrmCamera);
  Application.Run;
end.
