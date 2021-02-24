unit Form.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Objects, FMX.StdCtrls,
  FMX.Layouts, System.Actions, FMX.ActnList, System.ImageList, FMX.ImgList,
  FMX.ListBox, FMX.Ani;

type
  TForm2 = class(TForm)
    MultiView1: TMultiView;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Rectangle1: TRectangle;
    lblLogin: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    ActionList1: TActionList;
    ListBox1: TListBox;
    ESTOQUE: TListBoxItem;
    ImageList1: TImageList;
    CONFIGURACAO: TListBoxItem;
    Image1: TImage;
    FloatAnimation1: TFloatAnimation;
    procedure lblLoginClick(Sender: TObject);
    procedure ESTOQUEClick(Sender: TObject);
    procedure CONFIGURACAOClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses Form.Login, Form.Estoque, Form.Configuracao;

procedure TForm2.CONFIGURACAOClick(Sender: TObject);
begin
  frmConfiguracao := TfrmConfiguracao.Create(Self);
  frmConfiguracao.Show;
end;

procedure TForm2.ESTOQUEClick(Sender: TObject);
begin
  frmEstoque := TfrmEstoque.Create(Self);
  frmEstoque.Show;
end;

procedure TForm2.lblLoginClick(Sender: TObject);
begin
  frmLogin := TfrmLogin.Create(Self);
  frmLogin.Show;
end;

end.
