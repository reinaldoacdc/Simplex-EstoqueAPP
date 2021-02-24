program SimplexAPP;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.Main in 'Form.Main.pas' {Form2},
  Form.Login in 'Form.Login.pas' {frmLogin},
  Form.Estoque in 'Form.Estoque.pas' {frmEstoque},
  Form.Configuracao in 'Form.Configuracao.pas' {frmConfiguracao},
  uConfigINI in '..\Server\Classes\uConfigINI.pas',
  Loading in 'Loading.pas',
  Controller.API in 'Controller.API.pas',
  Model.Entity.PRODUTOS in '..\Server\Model\Entity\Model.Entity.PRODUTOS.pas',
  Model.Entity.ESTOQUE in '..\Server\Model\Entity\Model.Entity.ESTOQUE.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TfrmEstoque, frmEstoque);
  Application.CreateForm(TfrmConfiguracao, frmConfiguracao);
  Application.Run;
end.
