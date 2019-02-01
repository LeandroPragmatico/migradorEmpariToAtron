program EmperiToAtron;

uses
  Vcl.Forms,
  uFrmPrincipal in 'uFrmPrincipal.pas' {SIncronizador},
  uDm in 'uDm.pas' {dm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSIncronizador, SIncronizador);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
