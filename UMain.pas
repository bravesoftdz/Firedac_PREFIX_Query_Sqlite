unit UMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Data.DB,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids;

type
  TFrmMain = class(TForm)
    DBGrid_TEST: TDBGrid;
    Lbl_SQL: TLabel;
    Btn_RUN: TButton;
    ds_TEST: TDataSource;
    Log_Sql: TMemo;
    Edt_pUSER: TEdit;
    Edt_pPASSWORD: TEdit;
    Lbl_P1: TLabel;
    Lbl_P2: TLabel;
    procedure Btn_RUNClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  FireDAC.Stan.Param,
  FireDAC.Stan.Intf,
  Query_API,
  Udm;

{$R *.dfm}

procedure TFrmMain.Btn_RUNClick(Sender: TObject);
var
  aParams: TFDParams;
  aParam : TFDParam;
begin
  aParams := TFDParams.Create;
  try
    aParam := aParams.Add;
    aParam.DataType := TFieldType(TFDDataType.dtAnsiString);
    aParam.ParamType := TParamType.ptInput;
    aParam.Name := 'USER';
    aParam.AsString := Edt_pUSER.Text; //'User';

    aParam := aParams.Add;
    aParam.DataType := TFieldType(TFDDataType.dtAnsiString);
    aParam.ParamType := TParamType.ptInput;
    aParam.Name := 'PASSWORD';
    aParam.AsString := Edt_pPASSWORD.Text; //'User';

    ds_TEST.DataSet := Qry_Users.fQry;

    Qry_Users.fQry.ResourceOptions.ParamCreate := False;
    Qry_Users.Execute(Log_Sql.Text, aParams);
  finally
    aParams.Free;
  end;
end;

end.
