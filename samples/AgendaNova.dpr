program AgendaNova;

uses
  Vcl.Forms,
  principal in 'principal.pas' {frmPrincipal};


{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
