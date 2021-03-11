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
    MultiView1: TMultiView;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Rectangle1: TRectangle;
    lblLogin: TLabel;
    Layout1: TLayout;
    lblSair: TLabel;
    ActionList1: TActionList;
    ListBox1: TListBox;
    ESTOQUE: TListBoxItem;
    ImageList1: TImageList;
    CONFIGURACAO: TListBoxItem;
    Image1: TImage;
    FloatAnimation1: TFloatAnimation;
    btnEntrar: TRectangle;
    btnSair: TRectangle;
    lblUsuario: TLabel;
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
  MultiView1.HideMaster;
  frmLogin := TfrmLogin.Create(Self);
  frmLogin.Show;
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmMain.btnSairClick(Sender: TObject);
begin
  MultiView1.HideMaster;
  Self.LoginSucessfull := False;
  lblUsuario.Text := '';

  frmEstoque := TfrmEstoque.Create(Self);
  frmEstoque.Show;
end;

procedure TfrmMain.Image2Click(Sender: TObject);
begin
  MultiView1.HideMaster;
  frmEstoque := TfrmEstoque.Create(Self);
  frmEstoque.Show;
end;

procedure TfrmMain.Image5Click(Sender: TObject);
begin
  MultiView1.HideMaster;
  frmConfiguracao := TfrmConfiguracao.Create(Self);
  frmConfiguracao.Show;
end;

end.
