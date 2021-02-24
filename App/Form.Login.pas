unit Form.Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TfrmLogin = class(TForm)
    LayoutTop: TLayout;
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
    procedure lblLogarClick(Sender: TObject);
    procedure NameEditKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure NameEditKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

//uses Controller.API, uConfigINI, Form.Main;


procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Action := TCloseAction.caFree;
end;

procedure TfrmLogin.lblLogarClick(Sender: TObject);
begin
//  if objAPI.Login(NameEdit.Text, PasswordEdit.Text) then
//  begin
//    ConfigINI.AcessoBanco.OperadorNome := NameEdit.Text;
//    ConfigINI.UpdateFile;
//
//    FormMain.LoginSucessfull := True;
//    Self.close;
//  end
//  else
//    label1.Text := 'Login ou senha inválidos.';
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
