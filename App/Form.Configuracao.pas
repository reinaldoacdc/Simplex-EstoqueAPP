unit Form.Configuracao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.ImageList, FMX.ImgList, FMX.StdCtrls, FMX.Edit,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TfrmConfiguracao = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    URL_API: TEdit;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfiguracao: TfrmConfiguracao;

implementation

{$R *.fmx}

uses uConfigINI;

procedure TfrmConfiguracao.FormShow(Sender: TObject);
begin
  URL_API.Text := ConfigINI.AcessoBanco.URL_API;
end;

procedure TfrmConfiguracao.SpeedButton1Click(Sender: TObject);
begin
  ConfigINI.AcessoBanco.URL_API := URL_API.Text;
  ConfigINI.UpdateFile;

  Self.Close;
end;

end.
