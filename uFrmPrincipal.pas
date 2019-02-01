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

    procedure produtoSimilares;
    procedure clientes;
    procedure Button4Click(Sender: TObject);

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
  with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:= 'delete from C000025';
    ExecSQL;
  end;

log('produtos iniciadas');

 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:=
    'INSERT INTO C000025 (CODIGO, PRODUTO, UNIDADE, REFERENCIA, CODBARRA, CODFORNECEDOR, PRECOCUSTO, SITUACAO,CFOP,CSOSN,CST, '+
    'CLASSIFICACAO_FISCAL, CEST, CODIGO_ANP, CODMARCA, CODGRUPO, CODSUBGRUPO, TIPO, USA_BALANCA, USA_SERIAL,USA_GRADE  ) '+
    'VALUES (:CODIGO, :PRODUTO, :UNIDADE, :REFERENCIA, :CODBARRA, :CODFORNECEDOR, :PRECOCUSTO, 0,''5102'',''102'',''000'', '+
    ':CLASSIFICACAO_FISCAL, :CEST, :CODIGO_ANP, :CODMARCA, :CODGRUPO, :CODSUBGRUPO, ''VENDA'',2,0,0 )';

  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT TOP 20 [CODPROD], [DESCRICAO], [UNIDADE], [CODFAB],[CODBARRAS], [CODFOR], [CUSTO], '+
      '[CODPRODCLASSIFICACAO], [CEST], [CODANP], [CODFABI], [CODGRUPO], [CODSUBGRUPO]  '+
      ' FROM [hlpdados].[dbo].[produto]';
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

   dm.qrCommonLoc.ParamByName('PRODUTO').Value :=
      (dm.qrCommonWeb.FieldByName('DESCRICAO').Value);

   dm.qrCommonLoc.ParamByName('UNIDADE').Value :=
      (dm.qrCommonWeb.FieldByName('UNIDADE').Value);


//   dm.qrCommonLoc.ParamByName('REFERENCIA').Value :=
//      (dm.qrCommonWeb.FieldByName('CODFAB').Value);


   dm.qrCommonLoc.ParamByName('CODBARRA').Value :=
      (dm.qrCommonWeb.FieldByName('CODBARRAS').Value);


   dm.qrCommonLoc.ParamByName('CODFORNECEDOR').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODFOR').Value);


   dm.qrCommonLoc.ParamByName('PRECOCUSTO').Value :=
      (dm.qrCommonWeb.FieldByName('CUSTO').Value);


   dm.qrCommonLoc.ParamByName('CLASSIFICACAO_FISCAL').Value :=
      (dm.qrCommonWeb.FieldByName('CODPRODCLASSIFICACAO').Value);


   dm.qrCommonLoc.ParamByName('CEST').Value :=
      (dm.qrCommonWeb.FieldByName('CEST').Value);


   dm.qrCommonLoc.ParamByName('CODIGO_ANP').Value :=
      (dm.qrCommonWeb.FieldByName('CODANP').Value);
//

   dm.qrCommonLoc.ParamByName('CODMARCA').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODFABI').Value);


   dm.qrCommonLoc.ParamByName('CODGRUPO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODGRUPO').Value);

//
   dm.qrCommonLoc.ParamByName('CODSUBGRUPO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODSUBGRUPO').Value);

    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;

  log('produtos concluída : '+IntToStr(pb.Position));

end;








procedure TSIncronizador.produtoSimilares;
begin
// with dm.qrCommonWeb do
//  begin
//    Close;
//    sql.Clear;
//    sql.Text:= 'delete from PUBLIC.produto_categoria';
//    ExecSQL;
//  end;
//
  with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:= 'delete from C000025';
    ExecSQL;
  end;

log('produtos iniciadas');

 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:=
    'INSERT INTO C000025 (CODIGO, PRODUTO, UNIDADE, REFERENCIA, CODBARRA, CODFORNECEDOR, PRECOCUSTO '+
    '  ) '+
    'VALUES (:CODIGO, :PRODUTO, :UNIDADE, :REFERENCIA, :CODBARRA, :CODFORNECEDOR, :PRECOCUSTO '+
    '  )';

  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT TOP 10 [CODPROD], [DESCRICAO], [UNIDADE], [CODFAB],[CODBARRAS], [CODFOR], [CUSTO] '+
      '  '+
      ' FROM [hlpdados].[dbo].[produto]';
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

   dm.qrCommonLoc.ParamByName('PRODUTO').Value :=
      (dm.qrCommonWeb.FieldByName('DESCRICAO').Value);

   dm.qrCommonLoc.ParamByName('UNIDADE').Value :=
      (dm.qrCommonWeb.FieldByName('UNIDADE').Value);


   dm.qrCommonLoc.ParamByName('REFERENCIA').Value :=
      (dm.qrCommonWeb.FieldByName('CODFAB').Value);


   dm.qrCommonLoc.ParamByName('CODBARRA').Value :=
      (dm.qrCommonWeb.FieldByName('CODBARRAS').Value);


   dm.qrCommonLoc.ParamByName('CODFORNECEDOR').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODFOR').Value);


   dm.qrCommonLoc.ParamByName('PRECOCUSTO').Value :=
      (dm.qrCommonWeb.FieldByName('CUSTO').Value);

//
//   dm.qrCommonLoc.ParamByName('PRODUTO').Value :=
//      (dm.qrCommonWeb.FieldByName('DESCRICAO').Value);
//
//
//   dm.qrCommonLoc.ParamByName('PRODUTO').Value :=
//      (dm.qrCommonWeb.FieldByName('DESCRICAO').Value);
//
//
//   dm.qrCommonLoc.ParamByName('PRODUTO').Value :=
//      (dm.qrCommonWeb.FieldByName('DESCRICAO').Value);
//
//
//   dm.qrCommonLoc.ParamByName('PRODUTO').Value :=
//      (dm.qrCommonWeb.FieldByName('DESCRICAO').Value);
//
//
//   dm.qrCommonLoc.ParamByName('PRODUTO').Value :=
//      (dm.qrCommonWeb.FieldByName('DESCRICAO').Value);





    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;

  log('produtos concluída');

end;
procedure TSIncronizador.Button4Click(Sender: TObject);
begin
clientes;
end;

procedure TSIncronizador.clientes;
begin
 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:= 'delete from C000007';
    ExecSQL;
  end;

log('clientes iniciados');

 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:=
    'INSERT INTO C000007 (CODIGO  '+
    '   ) '+
    'VALUES (:CODIGO  '+
    ' )';

  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT TOP 20 * '+
      '  '+
      ' FROM [hlpdados].[dbo].[cliente]';
    Open;
    First;

  end;

  pb.Position:=0;
  pb.Max:= dm.qrCommonWeb.RecordCount;

  while not dm.qrCommonWeb.Eof do
  begin

//    ShowMessage(dm.qrCommonLoc.FieldByName('PRODUTO').Value);

    dm.qrCommonLoc.ParamByName('CODIGO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CodCli').Value);
//      ShowMessage( zerarcodigo(dm.qrCommonWeb.FieldByName('ID').Value));




//   dm.qrCommonLoc.ParamByName('REFERENCIA').Value :=
//      (dm.qrCommonWeb.FieldByName('CODFAB').Value);


//   dm.qrCommonLoc.ParamByName('CODBARRA').Value :=
//      (dm.qrCommonWeb.FieldByName('CODBARRAS').Value);
//
//
//   dm.qrCommonLoc.ParamByName('CODFORNECEDOR').Value :=
//      zerarcodigo(dm.qrCommonWeb.FieldByName('CODFOR').Value);
//
//
//   dm.qrCommonLoc.ParamByName('PRECOCUSTO').Value :=
//      (dm.qrCommonWeb.FieldByName('CUSTO').Value);
//
//
//   dm.qrCommonLoc.ParamByName('CLASSIFICACAO_FISCAL').Value :=
//      (dm.qrCommonWeb.FieldByName('CODPRODCLASSIFICACAO').Value);
//
//
//   dm.qrCommonLoc.ParamByName('CEST').Value :=
//      (dm.qrCommonWeb.FieldByName('CEST').Value);
//
//
//   dm.qrCommonLoc.ParamByName('CODIGO_ANP').Value :=
//      (dm.qrCommonWeb.FieldByName('CODANP').Value);
////
//
//   dm.qrCommonLoc.ParamByName('CODMARCA').Value :=
//      zerarcodigo(dm.qrCommonWeb.FieldByName('CODFABI').Value);
//
//
//   dm.qrCommonLoc.ParamByName('CODGRUPO').Value :=
//      zerarcodigo(dm.qrCommonWeb.FieldByName('CODGRUPO').Value);
//
////
//   dm.qrCommonLoc.ParamByName('CODSUBGRUPO').Value :=
//      zerarcodigo(dm.qrCommonWeb.FieldByName('CODSUBGRUPO').Value);

    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;

  log(IntToStr(pb.Position)+' Clientes migrados');
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
