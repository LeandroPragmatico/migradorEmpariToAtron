unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Menus;

type
  TSIncronizador = class(TForm)
    Panel1: TPanel;
    DBGrid: TDBGrid;
    Panel4: TPanel;
    dsLocal: TDataSource;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    endereco: TButton;
    Panel2: TPanel;
    pb: TProgressBar;
    Panel3: TPanel;
    Memo: TMemo;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure produtos;


    procedure log (txt: String);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    function zerarcodigo(codigo: Integer): string;
   
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SIncronizador: TSIncronizador;
  versao: String;
  sicReceber: Byte;

implementation

{$R *.dfm}

uses uDm;

function TSIncronizador.zerarcodigo(codigo: Integer): string;
var codString :String;
begin
codString := IntToStr(codigo);
  while length(codString) < 6 do codString := '0'+codString;
  result := codString;
end;

procedure TSIncronizador.Button2Click(Sender: TObject);
begin
produtos;
end;

procedure TSIncronizador.produtos;
begin
// with dm.qrCommonWeb do
//  begin
//    Close;
//    sql.Clear;
//    sql.Text:= 'delete from PUBLIC.produto_categoria';
//    ExecSQL;
//  end;
//
//  with dm.qrCommonWeb do
//  begin
//    Close;
//    sql.Clear;
//    sql.Text:= 'delete from PUBLIC.categoria';
//    ExecSQL;
//  end;

log('produtos iniciadas');

 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:=
    'INSERT INTO C000025 (CODIGO) '+
    'VALUES (:CODIGO)';
//    Open;
//    First;
  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT * FROM [hlpdados].[dbo].[produto]';
    Open;
    First;

  end;

  pb.Position:=0;
  pb.Max:= dm.qrCommonWeb.RecordCount;

  while not dm.qrCommonWeb.Eof do
  begin

//    ShowMessage(dm.qrCommonLoc.FieldByName('PRODUTO').Value);

    dm.qrCommonLoc.ParamByName('CODIGO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODPROD').Value);
//      ShowMessage( zerarcodigo(dm.qrCommonWeb.FieldByName('ID').Value));

//   dm.qrCommonLoc.ParamByName('CODCLIENTE').Value :=
//      zerarcodigo(dm.qrCommonWeb.FieldByName('CLIENTE_ID').Value);
//
//
//   dm.qrCommonLoc.ParamByName('DATA').Value :=
//      (dm.qrCommonWeb.FieldByName('INSTANTE').Value);

    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;

  log('produtos concluída');

end;








procedure TSIncronizador.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;

//desativa o fechamento do botao fechax(X)
//Action := caNone;
//minimizar;
end;

procedure TSIncronizador.FormCreate(Sender: TObject);
begin
//sicReceber:= 0;
versao:= '1.02';
Caption:= Caption+' - Versão: '+versao;
end;

procedure TSIncronizador.FormShow(Sender: TObject);
begin
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TSIncronizador.log(txt: String);
var tempo: string;
begin
tempo:= FormatDateTime('HH:mm:ss', Now);
Memo.Lines.Add(tempo+' '+txt);
//TrayIcon1.Hint:= txt;

end;

end.
