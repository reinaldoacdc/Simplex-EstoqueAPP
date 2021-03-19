unit Form.Estoque;

interface

uses
  Model.Entity.PRODUTOS,  System.Generics.Collections,
  FMX.platform, androidapi.JNI.GraphicsContentViewText,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Edit, FMX.ListBox,
  FMX.Ani, u99Permissions, uConfigINI, Model.List.PRODUTOS, SubjectStand,
  FrameStand, Data.DB, Datasnap.DBClient;

type
  TfrmEstoque = class(TForm)
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    lblCodFabr: TLabel;
    ListBox1: TListBox;
    layoutContagem: TLayout;
    VScroll: TVertScrollBox;
    layoutTop: TLayout;
    rectEdits: TRectangle;
    rectButtons: TRectangle;
    rectBottom: TRectangle;
    layoutCodFabr: TLayout;
    rectTop: TRectangle;
    layoutEditCodFabr: TLayout;
    rectEditCodFabr: TRectangle;
    edtCodFabr: TEdit;
    layoutCodInterno: TLayout;
    lblCodInterno: TLabel;
    layoutEditCodInterno: TLayout;
    rectCodInterno: TRectangle;
    edtCodInterno: TEdit;
    layoutCodBarras: TLayout;
    lblCodBarras: TLabel;
    layoutEditCodBarras: TLayout;
    rectBgCodBarras: TRectangle;
    edtCodBarras: TEdit;
    lblContagem: TLabel;
    layoutQuantidade: TLayout;
    rectQuantidade: TRectangle;
    edtQuantidade: TEdit;
    btnVoltar: TRectangle;
    lblSair: TLabel;
    Image1: TImage;
    Image2: TImage;
    CODIGO_INTERNO: TListBoxItem;
    REF_FABRICANTE: TListBoxItem;
    REF_INTERNA: TListBoxItem;
    DESCRICAO: TListBoxItem;
    FORNECEDOR: TListBoxItem;
    Timer1: TTimer;
    FrameStand1: TFrameStand;
    StyleBook1: TStyleBook;
    cdsProdutos: TClientDataSet;
    cdsProdutosCODPROFABR: TStringField;
    cdsProdutosCODIGO_PRODUTO: TIntegerField;
    cdsProdutosDESCRICAO: TStringField;
    cdsProdutosREF_INTERNA: TStringField;
    cdsProdutosFORNECEDOR: TStringField;
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure edtQuantidadeEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtCodBarrasEnter(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FrameStand1BeforeShow(const ASender: TSubjectStand;
      const ASubjectInfo: TSubjectInfo);
  private
    foco : TControl;
    permissao : T99Permissions;

    ClipService: IFMXClipboardService;
    Elapsed: integer;

    procedure Clear;
    procedure Load(prod :TPRODUTOS);

    procedure Ajustar_Scroll;
    procedure AddProdToDataset(produto :TPRODUTOS);

    procedure PesquisaCodFabr;
    procedure PesquisaCodInterno;
    procedure PesquisaCodBarras;

    procedure SelecaoItem(produtos :TObjectList<TPRODUTOS>);
  public
    Fprod :Integer;
    procedure LoadFromFrame;
  end;

var
  frmEstoque: TfrmEstoque;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses Androidapi.Helpers, FMX.Toast,
     Frames.Dataset,
     Form.Login, Loading, Controller.API, Form.Main, UnitCamera;

procedure TfrmEstoque.AddProdToDataset(produto: TPRODUTOS);
begin
  cdsProdutos.Insert;
  cdsProdutosCODPROFABR.AsString := produto.CODPROFABR;
  cdsProdutosCODIGO_PRODUTO.AsInteger := produto.CODPRO;
  cdsProdutosDESCRICAO.AsString := produto.DESCRICAO;
  cdsProdutosREF_INTERNA.AsString := produto.REFERENCIAINTERNA;
  cdsProdutosFORNECEDOR.AsString := produto.NOME_FABRICANTE;
  cdsProdutos.Post;
end;

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
var
  error :String;
begin
  if Fprod = 0 then
  begin
    TToast.New(Self).Error('Produto não infomado.');
    Exit;
  end;

  error := '';
  TLoading.Show(Self, 'Atualizando...');
  TThread.CreateAnonymousThread(procedure
  begin

      try
        objAPI.postEstoque( Fprod, StrToFloat(edtQuantidade.Text), frmMain.CodEmpresa  );
      except on E :Exception do
        error := E.Message;
      end;

      TThread.Synchronize(nil, procedure
      begin
        TLoading.Hide;

        if error = '' then
          TToast.New(Self).Success('"Quantidade atualizada!')
        else
          TToast.New(Self).Error('Erro ao atualizar: ' + error);


        Clear;
      end);

  end).Start;
end;

procedure TfrmEstoque.btnPesquisarClick(Sender: TObject);
begin
  if edtCodFabr.Text <> '' then
    PesquisaCodFabr
  else if edtCodInterno.Text <> '' then
    PesquisaCodInterno
  else if edtCodBarras.Text <>'' then
    PesquisaCodBarras;
end;

procedure TfrmEstoque.Clear;
begin
  Fprod := 0;
  edtCodFabr.Text := '';
  edtCodBarras.Text := '';
  edtCodInterno.Text := '';
  edtQuantidade.Text := '';
  //ListBox1.Visible := False;
end;

procedure TfrmEstoque.edtCodBarrasEnter(Sender: TObject);
var
 Intent : JIntent;
begin
  if ConfigINI.UsaAppLeitorCodBarras then
  begin
    if assigned(ClipService) then
    begin
      clipservice.SetClipboard('nil');
      intent := tjintent.Create;
      intent.setAction( stringtojstring('com.google.zxing.client.android.SCAN'));
      SharedActivity.startActivityForResult(intent,0);
      Elapsed := 0;
      Timer1.Enabled := True;
    end;
  end
  else
  begin
    if NOT permissao.VerifyCameraAccess then
        permissao.Camera(nil, nil)
    else
    begin
        FrmCamera.ShowModal(procedure(ModalResult: TModalResult)
        begin
            edtCodBarras.Text := FrmCamera.codigo;
        end);
    end;
  end;
end;

procedure TfrmEstoque.edtQuantidadeEnter(Sender: TObject);
begin
  foco := TControl(TEdit(sender).Parent);
  Ajustar_Scroll();
end;

procedure TfrmEstoque.FormActivate(Sender: TObject);
begin
 ClipService.SetClipboard('nil');
end;

procedure TfrmEstoque.FormCreate(Sender: TObject);
begin
  permissao := T99Permissions.Create;
  if not TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, IInterface(ClipService)) then
    ClipService := nil;

  Elapsed := 0;
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

procedure TfrmEstoque.FrameStand1BeforeShow(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
var
  LContentBackground: TRectangle;
  LTenPercent: Single;
begin
  LTenPercent := 0;
  if ASubjectInfo.Parent is TCustomForm then
    LTenPercent := TCustomForm(ASubjectInfo.Parent).Width / 10
  else if ASubjectInfo.Parent is TControl then
    LTenPercent := TControl(ASubjectInfo.Parent).Width / 10;

  LContentBackground := ASubjectInfo.Stand.FindStyleResource('content_background') as TRectangle;

  if Assigned(LContentBackground) then
    LContentBackground.Margins.Rect := TRectF.Create(LTenPercent, LTenPercent
    , LTenPercent, LTenPercent);

end;

procedure TfrmEstoque.Load(prod :TPRODUTOS);
begin
  Fprod := prod.CODPRO;

  CODIGO_INTERNO.Text := 'CODIGO_INTERNO: ' + IntToStr(prod.CODPRO);
  REF_FABRICANTE.Text := 'REF_FABRICANTE: ' + prod.CODPROFABR;
  REF_INTERNA.Text    := 'REF_INTERNA: ' + prod.REFERENCIAINTERNA;
  DESCRICAO.Text      := 'DESCRIÇÃO: ' + prod.DESCRICAO;
  FORNECEDOR.Text     := 'FORNECEDOR: ' + prod.NOME_FABRICANTE;
  ListBox1.Visible := True;
end;

procedure TfrmEstoque.LoadFromFrame;
begin
  Fprod := cdsProdutosCODIGO_PRODUTO.AsInteger;

  CODIGO_INTERNO.Text := 'CODIGO_INTERNO: ' + cdsProdutosCODIGO_PRODUTO.AsString;
  REF_FABRICANTE.Text := 'REF_FABRICANTE: ' + cdsProdutosCODPROFABR.AsString;
  REF_INTERNA.Text    := 'REF_INTERNA: '    + cdsProdutosREF_INTERNA.AsString;
  DESCRICAO.Text      := 'DESCRIÇÃO: ' + cdsProdutosDESCRICAO.AsString;
  FORNECEDOR.Text     := 'FORNECEDOR: ' + cdsProdutosFORNECEDOR.AsString;
  ListBox1.Visible := True;
end;

procedure TfrmEstoque.PesquisaCodBarras;
var
  idPesquisa, error :String;
  prod :TPRODUTOS;
begin
  idPesquisa := edtCodBarras.Text;
  error := '';
  TLoading.Show(Self, 'Consultando...');

  TThread.CreateAnonymousThread(procedure
  begin
      Fprod := 0;
      try
        prod := objAPI.getProdutoCodBarras(idPesquisa, frmMain.CodEmpresa);
        Load(prod);
      except on E :Exception do
        begin
         error := E.Message;
        end;
      end;

      TThread.Synchronize(nil, procedure
      begin
        TLoading.Hide;
        if error <> '' then
           TToast.New(Self).Error('Erro: ' + error);
        if Fprod = 0 then
          TToast.New(Self).Error('Produto não encontrado');
      end);

  end).Start;
end;

procedure TfrmEstoque.PesquisaCodFabr;
var
  idPesquisa, error :String;
  produtos :TListaProdutos;
begin
  idPesquisa := edtCodFabr.Text;
  error := '';
  TLoading.Show(Self, 'Consultando...');

  TThread.CreateAnonymousThread(procedure
  begin
      Fprod := 0;
      try
        produtos := objAPI.getProdutoCodFabr(idPesquisa, frmMain.CodEmpresa);
      except on E :Exception do
        begin
         error := E.Message;
        end;
      end;

      TThread.Synchronize(nil, procedure
      begin
        TLoading.Hide;

        if produtos.FLista.Count > 1 then
          SelecaoItem(produtos.Flista)
        else if produtos.FLista.Count = 1 then
          Load(produtos.FLista.Items[0])
        else
        begin
          if error <> '' then
             TToast.New(Self).Error('Erro: ' + error);
          if Fprod = 0 then
            TToast.New(Self).Error('Produto não encontrado');
        end;
      end);

  end).Start;
end;

procedure TfrmEstoque.PesquisaCodInterno;
var
  idPesquisa, error :String;
  produtos :TListaProdutos;
begin
  idPesquisa := edtCodInterno.Text;
  error := '';
  TLoading.Show(Self, 'Consultando...');

  TThread.CreateAnonymousThread(procedure
  begin
      Fprod := 0;
      try
        produtos := objAPI.getProdutoCodInterno(idPesquisa, frmMain.CodEmpresa);
      except on E :Exception do
        begin
         error := E.Message;
        end;
      end;

      TThread.Synchronize(nil, procedure
      begin
        TLoading.Hide;

        if produtos.FLista.Count > 1 then
          SelecaoItem(produtos.Flista)
        else if produtos.FLista.Count = 1 then
          Load(produtos.FLista.Items[0])
        else
        begin
          if error <> '' then
             TToast.New(Self).Error('Erro: ' + error);
          if Fprod = 0 then
            TToast.New(Self).Error('Produto não encontrado');
        end;
      end);

  end).Start;
end;

procedure TfrmEstoque.SelecaoItem(produtos :TObjectList<TPRODUTOS>);
var
  LFrameInfo: TFrameInfo<TDatasetFrame>;
  produto :TPRODUTOS;
begin
  cdsProdutos.EmptyDataSet;
  for produto in produtos do
    AddProdToDataset(produto);

  LFrameInfo := FrameStand1.New<TDatasetFrame>();

  LFrameInfo.Frame.DataSet := cdsProdutos;
  LFrameInfo.Frame.ItemTextField := 'DESCRICAO';
  LFrameInfo.Frame.DetailField := 'CODIGO_PRODUTO';

  LFrameInfo.Show;
end;

procedure TfrmEstoque.SpeedButton1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmEstoque.Timer1Timer(Sender: TObject);
begin
  if (ClipService.GetClipboard.ToString <> 'nil') then
  begin
    timer1.Enabled := false;
    Elapsed := 0;
    edtCodBarras.Text := ClipService.GetClipboard.ToString;
  end
  else
    begin
      if Elapsed > 9 then
        begin
          timer1.Enabled := false;
          Elapsed := 0;
        end
      else
          Elapsed := Elapsed +1;
    end;
end;

end.
