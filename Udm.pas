unit Udm;

interface

uses
  System.SysUtils,
  System.Classes,
//++++++++++
  Data.DB,
//+++++++++
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error, // This very Imortant to catch Firedac Errors
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Stan.Param,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.Intf,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
// Our Custom Query
  Query_API;

type
  Tdm = class(TDataModule)
    FdCon_Sqlite: TFDConnection;
    Phys_Sqlite: TFDPhysSQLiteDriverLink;
    GUIx_Wait: TFDGUIxWaitCursor;
    procedure FdCon_SqliteAfterConnect(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure SetDataPath;

const
  DataName = 'BasicData.s3db';

var
  dm: Tdm;
  DataFullPath: string;
  Qry_Users: TQuery_API;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure SetDataPath;
begin
  DataFullPath := ExtractFileDir(ParamStr(0)) + '\BasicData\' + DataName;
end;

{ Tdm }

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  with FdCon_Sqlite do begin
    Params.add('DriverID=SQLite');  // Our Exemple use Sqlite for the Moment
    Params.add('Database=' + DataFullPath);
    //++++++<< Try Connect >>++++++
    Connected := True;
  end;
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(Qry_Users);
end;

procedure Tdm.FdCon_SqliteAfterConnect(Sender: TObject);
begin
  Qry_Users := TQuery_API.Create(FdCon_Sqlite, 'USERS');
end;

initialization
  SetDataPath; // Make sure to Get the DataBase Path in First of ALL...

end.
