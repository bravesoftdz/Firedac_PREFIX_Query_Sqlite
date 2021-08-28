program PREFIX_SELECT;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FrmMain},
  Udm in 'Udm.pas' {dm: TDataModule},
  Query_API in 'Query_API.pas',
  UPARAMS in 'UPARAMS.pas',
  UFunctions in 'UFunctions.pas';

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := True;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
