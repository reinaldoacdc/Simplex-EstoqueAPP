unit Form.Estoque;

interface

uses
  Model.Entity.PRODUTOS,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Edit, FMX.ListBox,
  System.ImageList, FMX.ImgList;

type
  TfrmEstoque = class(TForm)
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    rectBottom: TRectangle;
    rectTop: TRectangle;
    Layout1: TLayout;
    btnPesquisar: TSpeedButton;
    SpeedButton3: TSpeedButton;
    rectSearch: TLayout;
    edtProduto: TEdit;
    Label2: TLabel;
    Layout2: TLayout;
    btnAtualizar: TButton;
    Layout3: TLayout;
    Label3: TLabel;
    Layout4: TLayout;
    edtQuantidade: TEdit;
    ListBox1: TListBox;
    CODIGO_INTERNO: TListBoxItem;
    REF_FABRICANTE: TListBoxItem;
    REF_INTERNA: TListBoxItem;
    DESCRICAO: TListBoxItem;
    ESTOQUE: TListBoxItem;
    FORNECEDOR: TListBoxItem;
    ImageList1: TImageList;
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
  private
    Fprod :Integer;

    procedure Clear;
    procedure Load(prod :TPRODUTOS);
  public
    { Public declarations }
  end;

var
  frmEstoque: TfrmEstoque;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses Form.Login, Loading, Controller.API;

procedure TfrmEstoque.btnAtualizarClick(Sender: TObject);
begin
  TLoading.Show(Self, 'Atualizando...');
  TThread.CreateAnonymousThread(procedure
  begin
      if Fprod = 0 then
        raise Exception.Create('Produto não informado.');

      try
        objAPI.postEstoque( StrToInt(edtProduto.Text), StrToFloat(edtQuantidade.Text)  );
        Clear;
      except on E :Exception do
        ShowMessage(E.Message);
      end;

      TThread.Synchronize(nil, procedure
      begin
        TLoading.Hide;
      end);

  end).Start;
end;

procedure TfrmEstoque.btnPesquisarClick(Sender: TObject);
var prod :TPRODUTOS;
begin
  TLoading.Show(Self, 'Consultando...');


  TThread.CreateAnonymousThread(procedure
  begin
      Fprod := 0;
      try
        prod := objAPI.getProduto(edtProduto.Text);
        Load(prod);
      except on E :Exception do
        ShowMessage(E.Message);
      end;

      TThread.Synchronize(nil, procedure
      begin
              TLoading.Hide;
      end);

  end).Start;
end;

procedure TfrmEstoque.Clear;
begin
  Fprod := 0;
  edtProduto.Text := '';
  edtQuantidade.Text := '';
  ListBox1.Visible := False;
end;

procedure TfrmEstoque.Load(prod :TPRODUTOS);
begin
  Fprod := prod.CODPRO;

  CODIGO_INTERNO.Text :=  'CODIGO_INTERNO: ' + IntToStr(prod.CODPRO);
  REF_FABRICANTE.Text := 'REF_FABRICANTE: ' + prod.CODPROFABR;
  REF_INTERNA.Text    := 'REF_INTERNA: ' + prod.REFERENCIAINTERNA;
  DESCRICAO.Text      := 'DESCRIÇÃO: ' + prod.DESCRICAO;
  ESTOQUE.Text        := 'ESTOQUE: ' + FloatToStr(prod.ESTOQUE);
  FORNECEDOR.Text     := 'FORNECEDOR: ' + prod.INFORMACAO_COMPLEMENTAR;
end;

end.
