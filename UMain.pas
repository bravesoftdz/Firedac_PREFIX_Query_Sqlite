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
    procedure FormResize(Sender: TObject);
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
  Udm, UUtils;

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
    aParam.AsString := Edt_pUSER.Text; //'User' Input;

    aParam := aParams.Add;
    aParam.DataType := TFieldType(TFDDataType.dtAnsiString);
    aParam.ParamType := TParamType.ptInput;
    aParam.Name := 'PASSWORD';
    aParam.AsString := Edt_pPASSWORD.Text; //'User' Input;

    ds_TEST.DataSet := Qry_Users.fQry;

    Qry_Users.fQry.ResourceOptions.ParamCreate := False;
    Qry_Users.Execute(Log_Sql.Text, aParams);
  finally
    aParams.Free;
    FixDBGridColumnsWidth(DBGrid_TEST, taCenter, taCenter);
  end;
end;
//procedure FixDBGridColumnsWidth(const DBGrid: TDBGrid);
//var i : integer; TotWidth : integer; VarWidth : integer; ResizableColumnCount : integer; AColumn : TColumn;
//begin
//  //total width of all columns before resize
//  TotWidth := 0;
//  //how to divide any extra space in the grid
//  VarWidth := 0;
//  //how many columns need to be auto-resized
//  ResizableColumnCount := 0;
//
//  for i := 0 to -1 + DBGrid.Columns.Count do begin
//    TotWidth := TotWidth + DBGrid.Columns[i].Width;
//    if DBGrid.Columns[i].Field.Tag <> 0 then
//      Inc(ResizableColumnCount);
//  end;
//
//  //add 1px for the column separator lineif dgColLines in DBGrid.Options then
//  TotWidth := TotWidth + DBGrid.Columns.Count;
//  //add indicator column widthif dgIndicator in DBGrid.Options then
//  TotWidth := TotWidth + IndicatorWidth;
//  //width vale "left"
//  VarWidth := DBGrid.ClientWidth - TotWidth;
//  //Equally distribute VarWidth
//  //to all auto-resizable columnsif ResizableColumnCount > 0 then
//  VarWidth := varWidth div ResizableColumnCount;
//
//  for i := 0 to -1 + DBGrid.Columns.Count do begin
//    AColumn := DBGrid.Columns[i];
//    if AColumn.Field.Tag <> 0 then begin
//      AColumn.Width := AColumn.Width + VarWidth;
//      if AColumn.Width then AColumn.Width := AColumn.Field.Tag;
//    end;
//  end;
//end; (*FixDBGridColumnsWidth*)
procedure TFrmMain.FormResize(Sender: TObject);
begin
  FixDBGridColumnsWidth(DBGrid_TEST, taCenter, taCenter);
end;

end.
