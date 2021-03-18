unit Form.Estoque;

interface

uses
  Model.Entity.PRODUTOS,
  FMX.platform, androidapi.JNI.GraphicsContentViewText,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Edit, FMX.ListBox,
  FMX.Ani, u99Permissions, uConfigINI;

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
  private
    Fprod :Integer;
    foco : TControl;
    permissao : T99Permissions;

    ClipService: IFMXClipboardService;
    Elapsed: integer;

    procedure Clear;
    procedure Load(prod :TPRODUTOS);

    procedure Ajustar_Scroll;

    procedure PesquisaCodFabr;
    procedure PesquisaCodInterno;
    procedure PesquisaCodBarras;
  public
    { Public declarations }
  end;

var
  frmEstoque: TfrmEstoque;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses Androidapi.Helpers, FMX.Toast, Form.Login, Loading, Controller.API, Form.Main, UnitCamera;

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
    TToast.New(Self).Error('Produto n�o infomado.');
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

procedure TfrmEstoque.Load(prod :TPRODUTOS);
begin
  Fprod := prod.CODPRO;

  CODIGO_INTERNO.Text := 'CODIGO_INTERNO: ' + IntToStr(prod.CODPRO);
  REF_FABRICANTE.Text := 'REF_FABRICANTE: ' + prod.CODPROFABR;
  REF_INTERNA.Text    := 'REF_INTERNA: ' + prod.REFERENCIAINTERNA;
  DESCRICAO.Text      := 'DESCRI��O: ' + prod.DESCRICAO;
  FORNECEDOR.Text     := 'FORNECEDOR: ' + prod.NOME_FABRICANTE;
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
          TToast.New(Self).Error('Produto n�o encontrado');
      end);

  end).Start;
end;

procedure TfrmEstoque.PesquisaCodFabr;
var
  idPesquisa, error :String;
  prod :TPRODUTOS;
begin
  idPesquisa := edtCodFabr.Text;
  error := '';
  TLoading.Show(Self, 'Consultando...');

  TThread.CreateAnonymousThread(procedure
  begin
      Fprod := 0;
      try
        prod := objAPI.getProdutoCodFabr(idPesquisa, frmMain.CodEmpresa);
        Load(prod);
      except on E :Exception do
        begin
         error := E.Message;
         TToast.New(Self).Error('Erro: ' + E.Message);
         TLoading.Hide;
        end;
      end;

      TThread.Synchronize(nil, procedure
      begin
        TLoading.Hide;
        if error <> '' then
           TToast.New(Self).Error('Erro: ' + error);
        if Fprod = 0 then
          TToast.New(Self).Error('Produto n�o encontrado');
      end);

  end).Start;
end;

procedure TfrmEstoque.PesquisaCodInterno;
var
  idPesquisa, error :String;
  prod :TPRODUTOS;
begin
  idPesquisa := edtCodInterno.Text;
  error := '';
  TLoading.Show(Self, 'Consultando...');

  TThread.CreateAnonymousThread(procedure
  begin
      Fprod := 0;
      try
        prod := objAPI.getProdutoCodInterno(idPesquisa, frmMain.CodEmpresa);
        Load(prod);
      except on E :Exception do
        begin
         error := E.Message;
         TToast.New(Self).Error('Erro: ' + E.Message);
         TLoading.Hide;
        end;
      end;

      TThread.Synchronize(nil, procedure
      begin
        TLoading.Hide;
        if error <> '' then
           TToast.New(Self).Error('Erro: ' + error);
        if Fprod = 0 then
          TToast.New(Self).Error('Produto n�o encontrado');
      end);

  end).Start;
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
