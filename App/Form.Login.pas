unit Form.Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.ListBox,
  FMX.ComboEdit;

type
  TfrmLogin = class(TForm)
    LayoutBody: TLayout;
    rectLogin: TRectangle;
    LayoutRect: TLayout;
    lblSenha: TLabel;
    btnLogin: TRectangle;
    lblLogar: TLabel;
    laySenha: TLayout;
    Rectangle2: TRectangle;
    PasswordEdit: TEdit;
    layUsuario: TLayout;
    Rectangle1: TRectangle;
    NameEdit: TEdit;
    lblUsuario: TLabel;
    lblLOGIN: TLabel;
    Label4: TLabel;
    layEmpresa: TLayout;
    rectEmpresa: TRectangle;
    ComboBox1: TComboBox;
    procedure lblLogarClick(Sender: TObject);
    procedure NameEditKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure NameEditKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox1Exit(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
  private
    function getCodEmpresa :Integer;
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

uses FMX.Toast, Controller.API, uConfigINI, Form.Main, Loading;

procedure TfrmLogin.ComboBox1Enter(Sender: TObject);
var list :TStringList;
str : String;
begin
  if ComboBox1.Items.Count = 0 then
  begin
      list := objAPI.getEmprsas;
      for str in list do
        ComboBox1.Items.Add(str);
  end;
end;

procedure TfrmLogin.ComboBox1Exit(Sender: TObject);
var i :Integer;
begin

end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Action := TCloseAction.caFree;
end;

function TfrmLogin.getCodEmpresa: Integer;
var str :String;
begin
  str := Copy(ComboBox1.Items[ComboBox1.ItemIndex], 1, pos('-', ComboBox1.Items[ComboBox1.ItemIndex])-1);
  Result := StrToInt(Trim(str));
end;

procedure TfrmLogin.lblLogarClick(Sender: TObject);
begin
  if ComboBox1.ItemIndex = -1 then
  begin
    TToast.New(Self).Error('Selecione uma empresa');
    Exit;
  end;



  TLoading.Show(Self, 'Logando...');


  TThread.CreateAnonymousThread(procedure
  begin
      if objAPI.Login(NameEdit.Text, PasswordEdit.Text) then
      begin
        ConfigINI.AcessoBanco.OperadorNome := NameEdit.Text;
        ConfigINI.UpdateFile;
        frmMain.LoginSucessfull := True;
        frmMain.CodEmpresa := getCodEmpresa;
      end;

      TThread.Synchronize(nil, procedure
      begin
        TLoading.Hide;
       if frmMain.LoginSucessfull then
       begin
          frmMain.lblUsuario.Text := NameEdit.Text;
          Self.close;
        end;
      end);

  end).Start;
end;

procedure TfrmLogin.NameEditKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    PasswordEdit.SetFocus;
end;

procedure TfrmLogin.NameEditKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    PasswordEdit.SetFocus;
end;

end.
