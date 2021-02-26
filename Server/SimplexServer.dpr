program SimplexServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  Controller.Usuarios in 'Controller\Controller.Usuarios.pas',
  Model.Connection in 'Model\Connection\Model.Connection.pas',
  uConfigINI in 'Classes\uConfigINI.pas',
  Model.DaoGeneric in 'Model\Connection\Model.DaoGeneric.pas',
  Model.Entity.USUARIOS in 'Model\Entity\Model.Entity.USUARIOS.pas',
  Controller.Produtos in 'Controller\Controller.Produtos.pas',
  Model.Entity.PRODUTOS in 'Model\Entity\Model.Entity.PRODUTOS.pas',
  Controller.Estoque in 'Controller\Controller.Estoque.pas',
  Model.Entity.ESTOQUE in 'Model\Entity\Model.Entity.ESTOQUE.pas',
  Controller.API in '..\App\Controller.API.pas',
  Controller.Empresa in 'Controller\Controller.Empresa.pas',
  Model.Entity.EMPRESA in 'Model\Entity\Model.Entity.EMPRESA.pas';

var
  App : THorse;
begin
  App := THorse.Create;
  App.Port := ConfigINI.AcessoBanco.PORTA_API;
  App.Use(JHonson);
  App.Use(CORS);

  Controller.Usuarios.Registry(App);
  Controller.Produtos.Registry(App);
  Controller.Estoque.Registry(App);
  Controller.Empresa.Registry(App);

  App.Listen;
end.
