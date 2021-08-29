unit UUtils;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.DBGrids,
  Data.DB;

    procedure DBGridAutoSizeColumn(Grid: TDBGrid; Column: integer);
    procedure DBGridAutoSizeAllColumns(Grid: TDBGrid; aTitleAlign: TAlignment = taLeftJustify; aRowAlign: TAlignment = taLeftJustify);
    procedure FixDBGridColumnsWidth(const DBGrid: TDBGrid; aTitleAlign: TAlignment = taLeftJustify; aRowAlign: TAlignment = taLeftJustify);

implementation

procedure DBGridAutoSizeAllColumns(Grid: TDBGrid; aTitleAlign: TAlignment = taLeftJustify; aRowAlign: TAlignment = taLeftJustify);
// autosizes all columns of the DBGrid
var
  Column, W, WMax: integer;
  ds: TDataSet;
begin
  ds := Grid.DataSource.DataSet;

  if not Assigned(ds) then
    exit;

  if not ds.Active then
    exit;

  if ds.RecordCount = 0 then
    exit;

  if Grid.Columns.Count = 0 then
    exit;

  // disable controls in order to speed up screen update
  Grid.DataSource.DataSet.DisableControls;
  // loop through all colums and adkust width
  for Column:= 0 to (Grid.Columns.Count-1) do
  begin
    DBGridAutoSizeColumn(Grid, Column);
    Grid.Columns[Column].Title.Alignment := aTitleAlign;
    Grid.Columns[Column].Alignment := aRowAlign;
  end;
  // enable controls again
  Grid.DataSource.DataSet.EnableControls;
end;

procedure DBGridAutoSizeColumn(Grid: TDBGrid; Column: integer);
// determines the longest string in Column of the DBGrid
// and adjusts the Column Width accordingly
var
  W, WMax, WTitle: integer;
  ds: TDataSet;
begin
  ds := Grid.DataSource.DataSet;

  if not Assigned(ds) then
    exit;

  if not ds.Active then
    exit;

  if ds.RecordCount = 0 then
    exit;

  if Grid.Columns.Count = 0 then
    exit;

  WMax := 0;
  // set datasource to teh first record
  Grid.DataSource.DataSet.First;
  // loop through all records and get longest string of all records of this column
  while not Grid.DataSource.DataSet.EOF do
  begin
    W := Grid.Canvas.TextWidth(Grid.Columns[Column].Field.AsString);
    if W > WMax then WMax := W;
    Grid.DataSource.DataSet.Next;
  end;
  // Column width has to be at least the width of the title
  WTitle := Grid.Canvas.TextWidth(Grid.Columns[Column].Title.Caption);
  //ShowMessage(Grid.Columns[Column].Title.Caption);
  if (WMax + 10) < WTitle then WMax := WTitle;
  Grid.Columns[Column].Width:= WMax + 10;
end;

procedure FixDBGridColumnsWidth(const DBGrid: TDBGrid; aTitleAlign: TAlignment = taLeftJustify; aRowAlign: TAlignment = taLeftJustify);
var
  i,W,WMax, WTitle, TotWidth, VarWidth, ResizableColumnCount, colCount : integer;
  AColumn : TColumn;
  percentChange: Single;
  ds: TDataSet;
begin
  ds := DBGrid.DataSource.DataSet;

  if not Assigned(ds) then
    exit;

  if not ds.Active then
    exit;

  if ds.RecordCount = 0 then
    exit;

  if DBGrid.Columns.Count = 0 then
    exit;

  i := 0;
  DBGrid.DataSource.DataSet.DisableControls;
  //total width of all columns before resize
  TotWidth := 1;
  //how to divide any extra space in the grid
  VarWidth := 1;
  //how many columns need to be auto-resized
  colCount := DBGrid.Columns.Count;
  //calculate total with of all colums according to the text width within the columns
  ResizableColumnCount := 0;

  for i := 0 to colCount -1 do begin
    // find max text-width of this column
    WMax := 0;
    DBGrid.DataSource.DataSet.First;
    while not DBGrid.DataSource.DataSet.EOF do begin
      W := DBGrid.Canvas.TextWidth(DBGrid.Columns[i].Field.AsString);
      if W > WMax then WMax := W;
      DBGrid.DataSource.DataSet.Next;
    end;
    // find with of the column title
    WTitle := DBGrid.Canvas.TextWidth(DBGrid.Columns[i].Title.Caption);
    // if column title is larger than column content then use width of the column title
    if WMax < WTitle then WMax := WTitle;
    // set with of the column to max width of the text or title caption
    DBGrid.Columns[i].Width:= WMax;
    // count total with of all columns
    TotWidth := TotWidth + DBGrid.Columns[i].Width;
    if DBGrid.Columns[i].Field.Tag=0 then // tag could be used to define a minimu width
     Inc(ResizableColumnCount);
  end;

//  LogWindow.addLogEntry('FixDBGridColumnsWidth: Colums to Resize = ' + inttostr(ResizableColumnCount));
  //add 1px for the column separator lineif dgColLines in DBGrid.Options then
  TotWidth := TotWidth + colCount;
//  LogWindow.addLogEntry('FixDBGridColumnsWidth: TotalWidth = ' + inttostr(TotWidth));
  //add indicator column width if dgIndicator in DBGrid.Options then
  TotWidth := TotWidth + IndicatorWidth;
//  LogWindow.addLogEntry('FixDBGridColumnsWidth: TotalWidth with Indicators = ' + inttostr(TotWidth));
  //width value "left"
  VarWidth := DBGrid.ClientWidth - TotWidth;
  //Equally distribute percentChange
  //to all auto-resizable columnsif ResizableColumnCount > 0 then
  percentChange := (TotWidth/DBGrid.ClientWidth);
//  LogWindow.addLogEntry('FixDBGridColumnsWidth: Percentage change of column widths = ' + floattostr(percentChange));
  // showmessage('percentChange = '+ floattostr(percentChange));
  VarWidth := varWidth div ResizableColumnCount;
  // resize all colums according to its percentage change
//  LogWindow.addLogEntry('FixDBGridColumnsWidth: start resizing columns');

  for i := 0 to colCount -1 do
  begin
    AColumn := DBGrid.Columns[i];
    if AColumn.Field.Tag = 0 then
    begin
      AColumn.Width := Round(AColumn.Width/percentChange);
      //AColumn.Width := AColumn.Width + VarWidth;
      if AColumn.Width = 0 then
        AColumn.Width := AColumn.Field.Tag;
    end;
    AColumn.Title.Alignment := aTitleAlign;
    AColumn.Alignment := aRowAlign;
  end;
  DBGrid.DataSource.DataSet.EnableControls;
end;

end.
