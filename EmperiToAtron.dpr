program EmperiToAtron;

uses
  Vcl.Forms,
  uFrmPrincipal in 'uFrmPrincipal.pas' {SIncronizador},
  uDm in 'uDm.pas' {dm: TDataModule},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Aqua Light Slate');
  Application.CreateForm(TSIncronizador, SIncronizador);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
