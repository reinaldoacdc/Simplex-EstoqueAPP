unit Form.Estoque;

interface

uses
  Model.Entity.PRODUTOS,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Edit, FMX.ListBox,
  System.ImageList, FMX.ImgList, FMX.Ani, u99Permissions;

type
  TfrmEstoque = class(TForm)
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    rectBottom: TRectangle;
    btnPesquisar: TSpeedButton;
    btnCodBarras: TSpeedButton;
    edtProduto: TEdit;
    Label2: TLabel;
    layQtd: TLayout;
    lblQuantidade: TLabel;
    layEdit: TLayout;
    edtQuantidade: TEdit;
    ListBox1: TListBox;
    CODIGO_INTERNO: TListBoxItem;
    REF_FABRICANTE: TListBoxItem;
    REF_INTERNA: TListBoxItem;
    DESCRICAO: TListBoxItem;
    ESTOQUE: TListBoxItem;
    FORNECEDOR: TListBoxItem;
    ImageList1: TImageList;
    AnimaBottom: TFloatAnimation;
    layButton: TLayout;
    btnAtualizar: TButton;
    Layout3: TLayout;
    Layout4: TLayout;
    Circle1: TCircle;
    SpeedButton2: TSpeedButton;
    Layout5: TLayout;
    VScroll: TVertScrollBox;
    layTop: TLayout;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure edtQuantidadeEnter(Sender: TObject);
    procedure btnCodBarrasClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Fprod :Integer;
    foco : TControl;
    permissao : T99Permissions;
    procedure Clear;
    procedure Load(prod :TPRODUTOS);

    procedure Ajustar_Scroll;
  public
    { Public declarations }
  end;

var
  frmEstoque: TfrmEstoque;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses FMX.Toast, Form.Login, Loading, Controller.API, Form.Main, UnitCamera;

procedure TfrmEstoque.Ajustar_Scroll;
var
  x : integer;
begin
  with Self do
  begin
    VScroll.Margins.Bottom := 250;
    VScroll.ViewportPosition := PointF(VScroll.ViewportPosition.X,
                                TControl(foco).Position.Y - 90);

  end;
end;

procedure TfrmEstoque.btnAtualizarClick(Sender: TObject);
begin
  if Fprod = 0 then
  begin
    TToast.New(Self).Error('Produto não infomado.');
    Exit;
  end;

  TLoading.Show(Self, 'Atualizando...');
  TThread.CreateAnonymousThread(procedure
  begin

      try
        objAPI.postEstoque( Fprod, StrToFloat(edtQuantidade.Text), frmMain.CodEmpresa  );
        Clear;
      except on E :Exception do
        begin
         TToast.New(Self).Error('Erro: ' + E.Message);
         TLoading.Hide;
        end;
      end;

      TThread.Synchronize(nil, procedure
      begin
        TLoading.Hide;
        //Clear;
      end);

  end).Start;
end;

procedure TfrmEstoque.btnCodBarrasClick(Sender: TObject);
begin
    if NOT permissao.VerifyCameraAccess then
        permissao.Camera(nil, nil)
    else
    begin
        FrmCamera.ShowModal(procedure(ModalResult: TModalResult)
        begin
            edtProduto.Text := FrmCamera.codigo;
        end);
    end;
end;

procedure TfrmEstoque.btnPesquisarClick(Sender: TObject);
var
  idPesquisa :String;
  prod :TPRODUTOS;
begin
  idPesquisa := edtProduto.Text;
  TLoading.Show(Self, 'Consultando...');


  TThread.CreateAnonymousThread(procedure
  begin
      Fprod := 0;
      try
        prod := objAPI.getProduto(idPesquisa, frmMain.CodEmpresa);
        Load(prod);
      except on E :Exception do
//        begin
//         TToast.New(Self).Error('Erro: ' + E.Message);
//         TLoading.Hide;
//        end;
      end;

      TThread.Synchronize(nil, procedure
      begin
        TLoading.Hide;
        if Fprod = 0 then
          TToast.New(Self).Error('Produto não encontrado');
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

procedure TfrmEstoque.edtQuantidadeEnter(Sender: TObject);
begin
  foco := TControl(TEdit(sender).Parent);
  Ajustar_Scroll();
end;

procedure TfrmEstoque.FormCreate(Sender: TObject);
begin
  permissao := T99Permissions.Create;
end;

procedure TfrmEstoque.FormDestroy(Sender: TObject);
begin
  permissao.DisposeOf;
end;

procedure TfrmEstoque.FormShow(Sender: TObject);
begin
  Clear;
end;

procedure TfrmEstoque.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  VScroll.Margins.Bottom := 0;
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
  ListBox1.Visible := True;
end;

procedure TfrmEstoque.SpeedButton1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmEstoque.SpeedButton2Click(Sender: TObject);
begin
  rectBottom.Visible := not(rectBottom.Visible);
  AnimaBottom.StartValue := Self.Width + 100;
  AnimaBottom.StopValue := 0;
  AnimaBottom.Start;

  edtQuantidade.SetFocus;
end;

end.
