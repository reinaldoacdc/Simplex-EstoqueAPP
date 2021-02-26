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
    procedure ESTOQUEClick(Sender: TObject);
    procedure CONFIGURACAOClick(Sender: TObject);
    procedure btnEntrarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
  private

  public
    CodEmpresa :Integer;
    LoginSucessfull :Boolean;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses Form.Login, Form.Estoque, Form.Configuracao, Controller.API;

procedure TfrmMain.btnEntrarClick(Sender: TObject);
begin
  MultiView1.HideMaster;
  frmLogin := TfrmLogin.Create(Self);
  frmLogin.Show;
end;

procedure TfrmMain.btnSairClick(Sender: TObject);
begin
  MultiView1.HideMaster;
  Self.LoginSucessfull := False;
  lblUsuario.Text := '';

  frmEstoque := TfrmEstoque.Create(Self);
  frmEstoque.Show;
end;

procedure TfrmMain.CONFIGURACAOClick(Sender: TObject);
begin
  MultiView1.HideMaster;
  frmConfiguracao := TfrmConfiguracao.Create(Self);
  frmConfiguracao.Show;
end;

procedure TfrmMain.ESTOQUEClick(Sender: TObject);
begin
  MultiView1.HideMaster;
  frmEstoque := TfrmEstoque.Create(Self);
  frmEstoque.Show;
end;

end.
