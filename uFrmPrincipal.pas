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
    function zerarNcm(codigo: string): string;
   
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);

    procedure produtoFornecedor;
    procedure produtoSimilar;
    procedure clientes;
    procedure Button4Click(Sender: TObject);
    procedure estoque;
    procedure Button1Click(Sender: TObject);
    procedure precovenda;
    procedure contasReceber;
    procedure fornececores;
    procedure subgrupos;
    procedure grupos;
    procedure sequencia(tabela : string);
    procedure enderecoClick(Sender: TObject);
    function FormataCNPJ(CNPJ: string): string;



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

procedure TSIncronizador.grupos;
begin
log('deletando grupo');
  with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:= 'delete from C000017';
    ExecSQL;
  end;

log('subgrupo iniciadas');

 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:=
    'INSERT INTO C000017 (CODIGO, GRUPO '+
    '  ) '+
    'VALUES (:CODIGO, :GRUPO '+
    '  )';

  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT * '+
      '  '+
      ' FROM [hlpdados].[dbo].[grupo]';
    Open;
    First;

  end;

  pb.Position:=0;
  pb.Max:= dm.qrCommonWeb.RecordCount;

  while not dm.qrCommonWeb.Eof do
  begin


    dm.qrCommonLoc.ParamByName('CODIGO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CodGrupo').Value);

   dm.qrCommonLoc.ParamByName('GRUPO').Value :=
     (dm.qrCommonWeb.FieldByName('Nome').Value);


    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;
  sequencia('000017');

  log('grupo concluída : '+IntToStr(pb.Position));

end;

function TSIncronizador.zerarcodigo(codigo: Integer): string;
var codString :String;
begin
codString := IntToStr(codigo);
  while length(codString) < 6 do codString := '0'+codString;
  result := codString;
end;

function TSIncronizador.zerarNcm(codigo: string): string;
var codString :String;
begin
codString := '';
  if codigo='' then Result := '00000000'
  else
    begin
      while Length(codigo) < 8 do codString := '0'+codigo;
      result := codString;
    end;
end;

procedure TSIncronizador.Button1Click(Sender: TObject);
begin
fornececores;
end;

procedure TSIncronizador.Button2Click(Sender: TObject);
begin
  try
    produtos;
    estoque;
    precovenda;
    produtoSimilar;
    produtoFornecedor;
    grupos;
    subgrupos;
  finally
//    ShowMessage('Produtos concluido');
  end;
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
log('produtos deletados');
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
    'CLASSIFICACAO_FISCAL, CEST, CODIGO_ANP, CODGRUPO, CODSUBGRUPO, TIPO, USA_BALANCA, USA_SERIAL,USA_GRADE  ) '+
    'VALUES (:CODIGO, :PRODUTO, :UNIDADE, :REFERENCIA, :CODBARRA, :CODFORNECEDOR, :PRECOCUSTO, 0,:CFOP,:CSOSN,:CST, '+
    ':CLASSIFICACAO_FISCAL, :CEST, :CODIGO_ANP, :CODGRUPO, :CODSUBGRUPO, ''VENDA'',2,0,0 )';

  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT  * '+
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


   dm.qrCommonLoc.ParamByName('REFERENCIA').Value :=
      (dm.qrCommonWeb.FieldByName('CODFAB').Value);


   if (dm.qrCommonWeb.FieldByName('CODBARRAS').Value = 'SEM GTIN') or (dm.qrCommonWeb.FieldByName('CODBARRAS').Value = '' )
   then
     dm.qrCommonLoc.ParamByName('CODBARRA').Value :=
     zerarcodigo(dm.qrCommonWeb.FieldByName('CODPROD').Value)
   else
      dm.qrCommonLoc.ParamByName('CODBARRA').Value :=
      dm.qrCommonWeb.FieldByName('CODBARRAS').Value;

   dm.qrCommonLoc.ParamByName('CODFORNECEDOR').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODFOR').Value);


   dm.qrCommonLoc.ParamByName('PRECOCUSTO').Value :=
      (dm.qrCommonWeb.FieldByName('CUSTO').Value);


//   dm.qrCommonLoc.ParamByName('CLASSIFICACAO_FISCAL').Value :=
//      zerarNcm(dm.qrCommonWeb.FieldByName('CODCLASSEFISCAL').Value);

   if (dm.qrCommonWeb.FieldByName('CODCLASSEFISCAL').Value = '')
   then
     dm.qrCommonLoc.ParamByName('CODBARRA').Value :='00000000'
   else
      dm.qrCommonLoc.ParamByName('CLASSIFICACAO_FISCAL').Value :=
      dm.qrCommonWeb.FieldByName('CODCLASSEFISCAL').Value;


//   dm.qrCommonLoc.ParamByName('CEST').Value :=
//      (dm.qrCommonWeb.FieldByName('CEST').Value);
   if (dm.qrCommonWeb.FieldByName('CEST').Value = '')
   then
     begin
       dm.qrCommonLoc.ParamByName('CEST').Value :='';
       dm.qrCommonLoc.ParamByName('CSOSN').Value :='102';
       dm.qrCommonLoc.ParamByName('CFOP').Value :='5102';
       dm.qrCommonLoc.ParamByName('CST').Value :='000';
     end
   else
     begin
       dm.qrCommonLoc.ParamByName('CEST').Value := dm.qrCommonWeb.FieldByName('CEST').Value ;
       dm.qrCommonLoc.ParamByName('CSOSN').Value :='500';
       dm.qrCommonLoc.ParamByName('CFOP').Value :='5405';
       dm.qrCommonLoc.ParamByName('CST').Value :='060';
     end ;


   dm.qrCommonLoc.ParamByName('CODIGO_ANP').Value :=
      (dm.qrCommonWeb.FieldByName('CODANP').Value);
//

//   dm.qrCommonLoc.ParamByName('CODMARCA').Value :=
//      zerarcodigo(dm.qrCommonWeb.FieldByName('CODFABI').Value);


   dm.qrCommonLoc.ParamByName('CODGRUPO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODGRUPO').Value);

//
   dm.qrCommonLoc.ParamByName('CODSUBGRUPO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODSUBGRUPO').Value);

    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;
  sequencia('000025');
  log('produtos concluída : '+IntToStr(pb.Position));

end;








procedure TSIncronizador.produtoSimilar;
begin
// with dm.qrCommonWeb do
//  begin
//    Close;
//    sql.Clear;
//    sql.Text:= 'delete from PUBLIC.produto_categoria';
//    ExecSQL;
//  end;
//
log('deletando produto similar');
  with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:= 'delete from SIMILARES';
    ExecSQL;
  end;

log('produto similar iniciadas');

 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:=
    'INSERT INTO SIMILARES (CODPRODUTO, CODSIMILAR '+
    '  ) '+
    'VALUES (:CODPRODUTO, :CODSIMILAR '+
    '  )';

  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT [CodProd], [CodProd2]'+
      '  '+
      ' FROM [hlpdados].[dbo].[prodsimilar]';
    Open;
    First;

  end;

  pb.Position:=0;
  pb.Max:= dm.qrCommonWeb.RecordCount;

  while not dm.qrCommonWeb.Eof do
  begin


    dm.qrCommonLoc.ParamByName('CODPRODUTO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CodProd').Value);


   dm.qrCommonLoc.ParamByName('CODSIMILAR').Value :=
     zerarcodigo(dm.qrCommonWeb.FieldByName('CodProd2').Value);


    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;

  log('produto similar concluída : '+IntToStr(pb.Position));

end;

procedure TSIncronizador.sequencia(tabela : string);
begin
//dsLoca
  with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:=  'select CODIGO from c'+tabela+' order by CODIGO';
//     'SELECT max(['+id+']) as maior FROM [hlpdados].[dbo].['+tabelaOrigem+']';
    open;
    Last;
  end;

//  ShowMessage('qrCommonWeb');
//  ShowMessage(dm.qrCommonLoc.SQL.Text);

  with dm.qrAuxLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:= 'update c000000 c set c.sequencia = :sequencia where c.codigo ='+ QuotedStr(tabela) ;
  end;

//    ShowMessage('qrCommonLoc');
//    ShowMessage(dm.qrAuxLoc.SQL.Text);

       dm.qrAuxLoc.ParamByName('sequencia').Value :=
      StrToInt(dm.qrCommonLoc.FieldByName('CODIGO').Value);

    dm.qrAuxLoc.ExecSQL;
end;

procedure TSIncronizador.subgrupos;
begin
// with dm.qrCommonWeb do
//  begin
//    Close;
//    sql.Clear;
//    sql.Text:= 'delete from PUBLIC.produto_categoria';
//    ExecSQL;
//  end;
//
log('deletando subgrupo');
  with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:= 'delete from C000018';
    ExecSQL;
  end;

log('subgrupo iniciadas');

 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:=
    'INSERT INTO C000018 (CODIGO, CODGRUPO, SUBGRUPO '+
    '  ) '+
    'VALUES (:CODIGO, :CODGRUPO, :SUBGRUPO '+
    '  )';

  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT * '+
      '  '+
      ' FROM [hlpdados].[dbo].[subgrupo]';
    Open;
    First;

  end;

  pb.Position:=0;
  pb.Max:= dm.qrCommonWeb.RecordCount;

  while not dm.qrCommonWeb.Eof do
  begin


    dm.qrCommonLoc.ParamByName('CODIGO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CodSubGrupo').Value);


   dm.qrCommonLoc.ParamByName('CODGRUPO').Value :=
     zerarcodigo(dm.qrCommonWeb.FieldByName('CodGrupo').Value);

   dm.qrCommonLoc.ParamByName('SUBGRUPO').Value :=
     (dm.qrCommonWeb.FieldByName('Nome').Value);


    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;

  sequencia('000018');

  log('subgrupo concluída : '+IntToStr(pb.Position));

end;

procedure TSIncronizador.produtoFornecedor;
begin
// with dm.qrCommonWeb do
//  begin
//    Close;
//    sql.Clear;
//    sql.Text:= 'delete from PUBLIC.produto_categoria';
//    ExecSQL;
//  end;
//
log('deletando codigo fornecodor');
  with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:= 'delete from PRODUTOS_CODFORNECEDOR';
    ExecSQL;
  end;

log('codigo fornecodor iniciadas');

 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:=
    'INSERT INTO PRODUTOS_CODFORNECEDOR (ID, CODPRODUTO, CODFORNECEDOR '+
    '  ) '+
    'VALUES (:ID, :CODPRODUTO, :CODFORNECEDOR '+
    '  )';

  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT [CodProd], [CodBarras]'+
      '  '+
      ' FROM [hlpdados].[dbo].[prodcodbarras]';
    Open;
    First;

  end;

  pb.Position:=0;
  pb.Max:= dm.qrCommonWeb.RecordCount;

  while not dm.qrCommonWeb.Eof do
  begin

//    ShowMessage(dm.qrCommonLoc.FieldByName('PRODUTO').Value);

    dm.qrCommonLoc.ParamByName('ID').Value := PB.Position;

    dm.qrCommonLoc.ParamByName('CODPRODUTO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CodProd').Value);


   dm.qrCommonLoc.ParamByName('CODFORNECEDOR').Value :=
     (dm.qrCommonWeb.FieldByName('CodBarras').Value);


    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;

  log('codigo fornecodor concluída : '+IntToStr(pb.Position));

end;


procedure TSIncronizador.Button4Click(Sender: TObject);
begin
clientes;
//fornececores;
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
      FormataCNPJ(dm.qrCommonWeb.FieldByName('CNPJCPF').Value);
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
  sequencia('000007');

  log(' Clientes migrados:'+ IntToStr(pb.Position));
end;

procedure TSIncronizador.contasReceber;
begin
//  with dm.qrCommonLoc do
//  begin
//    Close;
//    sql.Clear;
//    sql.Text:= 'delete from C000100';
//    ExecSQL;
//  end;

log('contas a receber iniciadas');

 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:=
    'INSERT INTO C000049 (CODIGO, CODCLIENTE, VALOR_ORIGINAL, VALOR_DESCONTO '+
    '  ) '+
    'VALUES (:CODIGO, :CODCLIENTE, :VALOR_ORIGINAL, :VALOR_DESCONTO '+
    '  )';

  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT * '+
      '  '+
      ' FROM [hlpdados].[dbo].[contasreceber] where SITUACAO = 0';
    Open;
    First;

  end;

  pb.Position:=0;
  pb.Max:= dm.qrCommonWeb.RecordCount;

  while not dm.qrCommonWeb.Eof do
  begin

//    ShowMessage(dm.qrCommonLoc.FieldByName('PRODUTO').Value);

    dm.qrCommonLoc.ParamByName('CODIGO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('cod').Value);
//      ShowMessage( zerarcodigo(dm.qrCommonWeb.FieldByName('ID').Value));

    dm.qrCommonLoc.ParamByName('CODCLIENTE').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODCLI').Value);

    dm.qrCommonLoc.ParamByName('VALOR_ORIGINAL').Value :=
      (dm.qrCommonWeb.FieldByName('valor').Value);


    dm.qrCommonLoc.ParamByName('VALOR_DESCONTO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('DESCONTOVALOR').Value);
  {

    dm.qrCommonLoc.ParamByName('CODCLIENTE').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODCLI').Value);


    dm.qrCommonLoc.ParamByName('CODCLIENTE').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODCLI').Value);


    dm.qrCommonLoc.ParamByName('CODCLIENTE').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODCLI').Value);


    dm.qrCommonLoc.ParamByName('CODCLIENTE').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODCLI').Value);


    dm.qrCommonLoc.ParamByName('CODCLIENTE').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODCLI').Value);


    dm.qrCommonLoc.ParamByName('CODCLIENTE').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODCLI').Value);


    dm.qrCommonLoc.ParamByName('CODCLIENTE').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODCLI').Value);


    dm.qrCommonLoc.ParamByName('CODCLIENTE').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODCLI').Value);


    dm.qrCommonLoc.ParamByName('CODCLIENTE').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CODCLI').Value);

     }



    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;

  log('contas a receber : '+IntToStr(pb.Position));
end;

procedure TSIncronizador.enderecoClick(Sender: TObject);
begin
subgrupos;
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

function TSIncronizador.FormataCNPJ(CNPJ: string): string;
begin
if Length(CNPJ)> 11
then
  Result := Copy(CNPJ,1,2)+'.'+Copy(CNPJ,3,3)+'.'+Copy(CNPJ,6,3)+'/'+Copy(CNPJ,9,4)+'-'+Copy(CNPJ,13,2)
else
  Result := Copy(CNPJ,1,3)+'.'+Copy(CNPJ,3,3)+'.'+Copy(CNPJ,6,3)+'-'+Copy(CNPJ,9,2);

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
versao:= '1.05';
Caption:= Caption+' - Versão: '+versao;
end;

procedure TSIncronizador.FormShow(Sender: TObject);
begin
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TSIncronizador.fornececores;
begin
  log('deletando fornecedores existentes');

 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:= 'delete from C000009';
    ExecSQL;
  end;

log('fornecedores iniciadas');

 with dm.qrCommonLoc do
  begin
    Close;
    sql.Clear;
    sql.Text:=
    'INSERT INTO C000009 (CODIGO, NOME, Fantasia, ENDERECO, BAIRRO, CIDADE, UF, CEP, COMPLEMENTO, TELEFONE1, EMAIL, IE, CNPJ, TIPO '+
    '  ) '+
    'VALUES (:CODIGO, :NOME, :Fantasia, :ENDERECO, :BAIRRO,  :CIDADE, :UF, :CEP, :COMPLEMENTO, :TELEFONE1, :EMAIL, :IE, :CNPJ, :TIPO '+
    '  )';

  end;



  with dm.qrCommonWeb do
  begin
      Close;
      sql.Clear;
      sql.Text :=
      'SELECT * '+
      '  '+
      ' FROM [hlpdados].[dbo].[fornecedor]';
    Open;
    First;

  end;

  pb.Position:=0;
  pb.Max:= dm.qrCommonWeb.RecordCount;

  while not dm.qrCommonWeb.Eof do
  begin

//    ShowMessage(dm.qrCommonLoc.FieldByName('PRODUTO').Value);

    dm.qrCommonLoc.ParamByName('CODIGO').Value :=
      zerarcodigo(dm.qrCommonWeb.FieldByName('CodFor').Value);
//      ShowMessage( zerarcodigo(dm.qrCommonWeb.FieldByName('ID').Value));

    dm.qrCommonLoc.ParamByName('NOME').Value :=
      (dm.qrCommonWeb.FieldByName('Razao').Value);

    dm.qrCommonLoc.ParamByName('Fantasia').Value :=
      (dm.qrCommonWeb.FieldByName('Fantasia').Value);

    dm.qrCommonLoc.ParamByName('ENDERECO').Value :=
      (dm.qrCommonWeb.FieldByName('ENDERECO').Value)+' N.'+
      IntToStr(dm.qrCommonWeb.FieldByName('Numero').Value);

    dm.qrCommonLoc.ParamByName('BAIRRO').Value :=
      copy(dm.qrCommonWeb.FieldByName('BAIRRO').Value,0,30);

    dm.qrCommonLoc.ParamByName('CIDADE').Value :=
      (dm.qrCommonWeb.FieldByName('CIDADE').Value);

    dm.qrCommonLoc.ParamByName('UF').Value :=
      (dm.qrCommonWeb.FieldByName('UF').Value);

    dm.qrCommonLoc.ParamByName('CEP').Value :=
      (dm.qrCommonWeb.FieldByName('CEP').Value);

    dm.qrCommonLoc.ParamByName('COMPLEMENTO').Value :=
      copy(dm.qrCommonWeb.FieldByName('COMPLEMENTO').Value,0,40);

    dm.qrCommonLoc.ParamByName('TELEFONE1').Value :=
      (dm.qrCommonWeb.FieldByName('Telefone').Value);

    dm.qrCommonLoc.ParamByName('CNPJ').Value :=
      FormataCNPJ(dm.qrCommonWeb.FieldByName('CNPJCPF').Value);

    dm.qrCommonLoc.ParamByName('IE').Value :=
      (dm.qrCommonWeb.FieldByName('IERG').Value);

    dm.qrCommonLoc.ParamByName('EMAIL').Value :=
      (dm.qrCommonWeb.FieldByName('EMAIL').Value);

//    dm.qrCommonLoc.ParamByName('NOME').Value :=
//      (dm.qrCommonWeb.FieldByName('Razao').Value);

    if  (dm.qrCommonWeb.FieldByName('TipoPessoa').Value) = 'J'
   then dm.qrCommonLoc.ParamByName('TIPO').Value := 2
   else dm.qrCommonLoc.ParamByName('TIPO').Value := 1;


    dm.qrCommonLoc.ExecSQL;
    pb.Position:= pb.Position+1;
    dm.qrCommonWeb.Next;
  end;

  sequencia('000009');

  log('fornecedores concluída: '+IntToStr(pb.Position));
end;

procedure TSIncronizador.log(txt: String);
var tempo: string;
begin
tempo:= FormatDateTime('HH:mm:ss', Now);
Memo.Lines.Add(tempo+' '+txt);
//TrayIcon1.Hint:= txt;

end;

end.
