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
    Label3: TLabel;
    btnLogin: TRectangle;
    lblLogar: TLabel;
    Layout4: TLayout;
    Rectangle2: TRectangle;
    PasswordEdit: TEdit;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    NameEdit: TEdit;
    Label2: TLabel;
    lblLOGIN: TLabel;
    Label1: TLabel;
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

//uses Controller.API, uConfigINI, Form.Main;


procedure TfrmLogin.ComboBox1Enter(Sender: TObject);
begin
  if ComboBox1.Items.Count = 0 then
  begin
      ComboBox1.Items.Add('1 - Empresa1');
      ComboBox1.Items.Add('2 - Empresa2');
      ComboBox1.Items.Add('3 - Empresa3');

//    ComboBox1.Items.AddObject('Empresa1',  TObject(1));
//    ComboBox1.Items.AddObject('Empresa2', TObject(2));
//    ComboBox1.Items.AddObject('Empresa3', TObject(3));
  end;
end;

procedure TfrmLogin.ComboBox1Exit(Sender: TObject);
var i :Integer;
begin
  //ShowMessage( ComboBox1.Items[ComboBOx1.ItemIndex] );
  //ShowMessage(IntToStr(i));
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




//  if objAPI.Login(NameEdit.Text, PasswordEdit.Text) then
//  begin
//    ConfigINI.AcessoBanco.OperadorNome := NameEdit.Text;
//    ConfigINI.UpdateFile;
//
//    frmMain.LoginSucessfull := True;
//    frmMain.lblUsuario.Text := NameEdit.Text;
//    TLoading.Hide;
//    Self.close;
//  end
//  else
//  begin
//    TLoading.Hide;
//    TToast.New(Self).Error('Login ou senha inválidos.');
//  end;
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
