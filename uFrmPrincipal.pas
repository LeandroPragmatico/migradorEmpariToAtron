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
    procedure estoque;
    procedure Button1Click(Sender: TObject);
    procedure precovenda;

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

procedure TSIncronizador.Button1Click(Sender: TObject);
begin
precovenda;
end;

procedure TSIncronizador.Button2Click(Sender: TObject);
begin
produtos;
estoque;
precovenda;
end;

procedure TSIncronizador.precovenda;
begin

log('preço venda iniciadas');

 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:=
    'update C000025 set PRECOVENDA = :PRECOVENDA '+
    'where codigo = :codigo ';

  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT [CODPROD], [PRECO] '+
      '  '+
      ' FROM [hlpdados].[dbo].[prodtabelaprecos]';
    Open;
    First;

  end;

  pb.Position:=0;
  pb.Max:= dm.qrCommonWeb.RecordCount;

  while not dm.qrCommonWeb.Eof do
  begin

//    ShowMessage(dm.qrCommonLoc.FieldByName('PRODUTO').Value);

    dm.qrCommonLoc.ParamByName('codigo').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODPROD').Value);
//      ShowMessage( zerarcodigo(dm.qrCommonWeb.FieldByName('ID').Value));

    dm.qrCommonLoc.ParamByName('PRECOVENDA').Value :=
      (dm.qrCommonWeb.FieldByName('PRECO').Value);
//      ShowMessage( zerarcodigo(dm.qrCommonWeb.FieldByName('ID').Value));


    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;

  log('preço venda concluída : '+IntToStr(pb.Position));
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
      'SELECT [CODPROD], [DESCRICAO], [UNIDADE], [CODFAB],[CODBARRAS], [CODFOR], [CUSTO], '+
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
      Copy((dm.qrCommonWeb.FieldByName('DESCRICAO').Value),0,60);

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
     Copy((dm.qrCommonWeb.FieldByName('DESCRICAO').AsString),0,59);

//     ShowMessage(dm.qrCommonWeb.FieldByName('DESCRICAO').Value);
//     ShowMessage(Copy((dm.qrCommonWeb.FieldByName('DESCRICAO').Value),0,59));

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
    'INSERT INTO C000007 (CODIGO,NOME, APELIDO, TIPO, CPF,RG, Endereco, NUMERO, BAIRRO, UF, CIDADE, COD_MUNICIPIO_IBGE, IBGE, CEP, COMPLEMENTO, SITUACAO, EMAIL, TELEFONE1, TELEFONE2, CELULAR, OBS1, LIMITE '+
    '   ) '+
    'VALUES (:CODIGO, :NOME, :APELIDO, :TIPO, :CPF, :RG, :Endereco, :NUMERO, :BAIRRO, :UF, :CIDADE, ''1100288'', ''00288'', :CEP, :COMPLEMENTO, 1, :EMAIL, :TELEFONE1, :TELEFONE2, :CELULAR, :OBS1, :LIMITE  '+
    ' )';

  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT * '+
      '  '+
      ' FROM [hlpdados].[dbo].[cliente]';
    Open;
    First;

  end;

    with dm.qrAuxLoc do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'select *  from c000006 cid where cid.cidade like :cidade';
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

   dm.qrCommonLoc.ParamByName('NOME').Value :=
      (dm.qrCommonWeb.FieldByName('Razao').Value);

//
   dm.qrCommonLoc.ParamByName('APELIDO').Value :=
      (dm.qrCommonWeb.FieldByName('Fantasia').Value);

//

   if   (dm.qrCommonWeb.FieldByName('TipoPessoa').Value) = 'J'
   then dm.qrCommonLoc.ParamByName('TIPO').Value := 2
   else dm.qrCommonLoc.ParamByName('TIPO').Value := 1;
//
//
   dm.qrCommonLoc.ParamByName('CPF').Value :=
      (dm.qrCommonWeb.FieldByName('CNPJCPF').Value);
//
//
   dm.qrCommonLoc.ParamByName('RG').Value :=
      (dm.qrCommonWeb.FieldByName('IERG').Value);
//
//
   dm.qrCommonLoc.ParamByName('Cep').Value :=
      (dm.qrCommonWeb.FieldByName('Cep').Value);


   dm.qrCommonLoc.ParamByName('Endereco').Value :=
      (dm.qrCommonWeb.FieldByName('Endereco').Value);
//

   dm.qrCommonLoc.ParamByName('Numero').Value :=
      IntToStr(dm.qrCommonWeb.FieldByName('Numero').Value);
//
//
   dm.qrCommonLoc.ParamByName('Complemento').Value :=
      (dm.qrCommonWeb.FieldByName('Complemento').Value);

   dm.qrCommonLoc.ParamByName('Bairro').Value :=
      (dm.qrCommonWeb.FieldByName('Bairro').Value);

   dm.qrCommonLoc.ParamByName('Cidade').Value :=
      (dm.qrCommonWeb.FieldByName('Cidade').Value);

//   dm.qrAuxLoc.ParamByName('Cidade').Value :=
//      (dm.qrCommonWeb.FieldByName('Cidade').Value);
//
//   dm.qrCommonLoc.ParamByName('COD_MUNICIPIO_IBGE').Value :=
//      (dm.qrAuxLoc.FieldByName('MUNICIPIO').Value);
//
//   dm.qrCommonLoc.ParamByName('IBGE').Value :=
//      (dm.qrAuxLoc.FieldByName('IBGE').Value);

   dm.qrCommonLoc.ParamByName('UF').Value :=
      (dm.qrCommonWeb.FieldByName('UF').Value);

   dm.qrCommonLoc.ParamByName('EMAIL').Value :=
      (dm.qrCommonWeb.FieldByName('EMAIL').Value);

   dm.qrCommonLoc.ParamByName('TELEFONE1').Value :=
      (dm.qrCommonWeb.FieldByName('TELEFONE').Value);

   dm.qrCommonLoc.ParamByName('TELEFONE2').Value :=
      (dm.qrCommonWeb.FieldByName('FAX').Value);

   dm.qrCommonLoc.ParamByName('CELULAR').Value :=
      (dm.qrCommonWeb.FieldByName('CELULAR').Value);

   dm.qrCommonLoc.ParamByName('OBS1').Value :=
      copy(dm.qrCommonWeb.FieldByName('OBS').Value,0,80);

   dm.qrCommonLoc.ParamByName('LIMITE').Value :=
      (dm.qrCommonWeb.FieldByName('LIMITE').Value);

    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;

  log(' Clientes migrados:'+ IntToStr(pb.Position));
end;

procedure TSIncronizador.estoque;
begin
  with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:= 'delete from C000100';
    ExecSQL;
  end;

log('estoque iniciadas');

 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:=
    'INSERT INTO C000100 (CODPRODUTO, ESTOQUE_ATUAL '+
    '  ) '+
    'VALUES (:CODPRODUTO, :ESTOQUE_ATUAL '+
    '  )';

  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT [CODPROD], [ESTOQUE] '+
      '  '+
      ' FROM [hlpdados].[dbo].[prodestoque]';
    Open;
    First;

  end;

  pb.Position:=0;
  pb.Max:= dm.qrCommonWeb.RecordCount;

  while not dm.qrCommonWeb.Eof do
  begin

//    ShowMessage(dm.qrCommonLoc.FieldByName('PRODUTO').Value);

    dm.qrCommonLoc.ParamByName('CODPRODUTO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODPROD').Value);
//      ShowMessage( zerarcodigo(dm.qrCommonWeb.FieldByName('ID').Value));

    dm.qrCommonLoc.ParamByName('ESTOQUE_ATUAL').Value :=
      (dm.qrCommonWeb.FieldByName('estoque').Value);
//      ShowMessage( zerarcodigo(dm.qrCommonWeb.FieldByName('ID').Value));

    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;

  log('estoque concluída');
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
versao:= '1.03';
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
