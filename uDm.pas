unit uDm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef,  Vcl.Dialogs;

type
  Tdm = class(TDataModule)
    connWeb_OLD: TFDConnection;
    connLocal: TFDConnection;
    qrCommonWeb: TFDQuery;
    qrCommonLoc: TFDQuery;
    qrAuxLoc: TFDQuery;
    connWeb: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


procedure Tdm.DataModuleCreate(Sender: TObject);
begin

with connWeb do begin
  Close;
  DriverName:='MSSQL';
   with Params do begin
      Clear;
      Add('DriverID=MSSQL');
      Add('Server=(local)');
      Add('User_Name=sa');
      Add('Database=hlpdados');
      Add('port=1433');
      Add('Password=8895');
    end;

  Connected:=True;
//  Open;
end;



//if connWeb.Connected then ShowMessage('conectatado') else ShowMessage('desconectatado');

//#### local
with connLocal do begin
  Close;
  // create temporary connection definition
  DriverName:='FB';
  with Params do begin
    Clear;
    Add('DriverID=FB');
    Add('Server=localhost');
    Add('Database=C:\Atron\gestor\BD\base.fdb');
    Add('User_Name=sysdba');
    Add('Password=masterkey');
  end;
  Connected:=True;
  Open;
end;

qrCommonWeb.Active:=True;
qrCommonLoc.Active:=True;

end;

end.
