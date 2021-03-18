unit Form.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Objects, FMX.StdCtrls,
  FMX.Layouts, System.Actions, FMX.ActnList, System.ImageList, FMX.ImgList,
  FMX.ListBox, FMX.Ani;

type
  TfrmMain = class(TForm)
    ToolBar1: TToolBar;
    ActionList1: TActionList;
    ImageList1: TImageList;
    FloatAnimation1: TFloatAnimation;
    Rectangle2: TRectangle;
    Label1: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    Layout7: TLayout;
    Image5: TImage;
    Label5: TLabel;
    Layout2: TLayout;
    Image2: TImage;
    Label2: TLabel;
    btnExit: TRectangle;
    lbSair: TLabel;
    procedure btnEntrarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private

  public
    CodEmpresa :Integer;
    LoginSucessfull :Boolean;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses Form.Login, Form.Estoque, Form.Configuracao, Controller.API;

procedure TfrmMain.btnEntrarClick(Sender: TObject);
begin
  frmLogin := TfrmLogin.Create(Self);
  frmLogin.Show;
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmMain.btnSairClick(Sender: TObject);
begin
  Self.LoginSucessfull := False;

  frmEstoque := TfrmEstoque.Create(Self);
  frmEstoque.Show;
end;

procedure TfrmMain.Image2Click(Sender: TObject);
begin
  frmEstoque := TfrmEstoque.Create(Self);
  frmEstoque.Show;
end;

procedure TfrmMain.Image5Click(Sender: TObject);
begin
  frmConfiguracao := TfrmConfiguracao.Create(Self);
  frmConfiguracao.Show;
end;

end.
