unit Query_API;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
//+++++++++++++
  FireDAC.Stan.Error, // This very Imortant to catch Firedac Errors
  FireDAC.Stan.Param,
  FireDAC.DApt,
  FireDAC.Comp.Client;

type
  TQuery_API = class
  strict private
    fTempFdQuery : TFDQuery;
    fTableName,
    fPrefix: string;
  private
    { Private declarations }
    procedure MyQryError(ASender, AInitiator: TObject; var AException: Exception);
    function Get_PrefixQuery: string;
    function IsPrefix_Query(aTableFieldsNames: TStrings): Boolean;
  public
    fQry: TFDQuery;
    constructor Create(aFdConnection: TFDConnection; aTableName: string);
    destructor destroy; override;
    function Execute(aSql: string; aParams: TFDParams = nil): Boolean;
  end;

var
  Qry: TQuery_API;

implementation

uses
  System.RegularExpressions,
  FireDAC.Stan.Intf,
  System.StrUtils,
  UFunctions;

{ TLoginAPI }

constructor TQuery_API.Create(aFdConnection: TFDConnection; aTableName: string);
begin
  fQry := nil;
  fQry := TFDQuery.Create(aFdConnection);
  try
    fQry.Connection := aFdConnection;
    fQry.SQL.Clear;
  finally
    fQry.OnError := MyQryError;
    fTableName := aTableName;
  end;

  fTempFdQuery := nil;
  fTempFdQuery := TFDQuery.Create(aFdConnection);
  try
    fTempFdQuery.Connection := aFdConnection;
    fTempFdQuery.SQL.Clear;
  finally
//
  end;
end;

destructor TQuery_API.destroy;
begin
{$IFDEF MSWINDOWS}
// Kill the Object & Empty the RAM .
  if Assigned(fQry) then begin
    fQry.Close;
    FreeAndNil(fQry);
  end;
  if Assigned(fTempFdQuery) then begin
    fTempFdQuery.Close;
    FreeAndNil(fTempFdQuery);
  end;
{$ELSE}
// Kill the Object & Empty the RAM .
  if Assigned(fFdQuery) then begin
    fFdQuery.Close;
    fFdQuery.DisposeOf;
  end;
  if Assigned(fTempFdQuery) then begin
    fTempFdQuery.Close;
    FreeAndNil(fTempFdQuery);
  end;
{$ENDIF}

  inherited;
end;

function TQuery_API.Execute(aSql: string; aParams: TFDParams = nil): Boolean;
begin
  aSql := StringReplace(StringReplace(aSql, #10, ' ', [rfReplaceAll]), #13, ' ', [rfReplaceAll]).Trim;

  with fQry do begin
    Connection.StartTransaction;
    try
      Close;
      SQL.Clear;
      if GetSubStr(aSql, 'SELECT', '\.\*', fPrefix) then begin // if Query start like that (Select WhateverType.* From) (if is there a (Positive LookBehind = 'SELECT') and a (Positive LookAhead = '.*'))
        if fPrefix <> fTableName then begin
          SQL.Text := Get_PrefixQuery +' '+ #13#10 + TrimedString(aSql, 'SELECT', 'FROM '+ fTableName); // Cocatenate between them [SELECT PREFIX.* FROM TABLE] + [whatever Condition or even None]
          fTempFdQuery.Close;
        end else SQL.Text := aSql; // This Means is just a normal Query(Select TableName.* From)
      end else SQL.Text := aSql;  // This Means is just a normal Query(Select * From) or (Select FieldName From)
      if Assigned(aParams) then begin
        Params := aParams;
        Prepare;
      end;

      try
        Open;
      except
        on E: EFDDBEngineException do
        raise Exception.Create('Error: ' + E.Message);
      end;

    finally
      Connection.Commit;
    end;
  end;
  Result := fQry.RecordCount > 0;
end;

function TQuery_API.Get_PrefixQuery: string;
var
  aTable_FieldsNames: TStringList;
  I: Byte;
begin
  with fTempFdQuery do begin
    Connection.StartTransaction;
    try
      Close;
      SQL.Clear;
      SQL.Text := 'PRAGMA Table_Info("' + fTableName +'")';
      try
        Open;
      except
        on E: EFDDBEngineException do
        raise Exception.Create('Error: ' + E.Message);
      end;
      aTable_FieldsNames := TStringList.Create;
      try
        First;
        for I := 0 to RecordCount -1 do begin
          aTable_FieldsNames.Add(Fields[1].AsString);
          Next;
        end;
      finally
        Close;
        SQL.Clear;
      end;
      if IsPrefix_Query(aTable_FieldsNames) then begin
        SQL.Text :=
        'SELECT ' + #13#10 +
        '"SELECT " || GROUP_CONCAT(NAME) || "  FROM ' + fTableName +'" ' + #13#10 +
        ' FROM' + #13#10 +
        ' PRAGMA_TABLE_INFO("' + fTableName +'")' + #13#10 +
        ' WHERE SUBSTR(NAME, 1, '+ fPrefix.Length.ToString +')= "' + fPrefix +'"';
        try
          Open;
        except on E: EFDDBEngineException do begin
            aTable_FieldsNames.Free; // Best Place to free the TStringList ..if there was an Exception !!!
            raise Exception.Create('Error: ' + E.Message);
          end;
        end;
      end else begin
        aTable_FieldsNames.Free; // Best Place to free the TStringList ..if there was an Exception !!!
        raise Exception.Create('Wrong ' + fPrefix + ': Please Specify a Correct Prefix for your Query !!');
      end;
      aTable_FieldsNames.Free; // Best Place to free the TStringList ..
    finally
      Connection.Commit;
    end;
  end;
  Result := fTempFdQuery.Fields[0].AsString;
end;

function TQuery_API.IsPrefix_Query(aTableFieldsNames: TStrings): Boolean;
var
  I: Byte;
  Correct: Boolean;
begin
  Correct := False;
  for I := 0 to aTableFieldsNames.Count -1 do begin
    if StartsText(fPrefix, aTableFieldsNames[I]) then begin // , [coIgnoreSymbols,coIgnoreCase]
      Correct := True;
      GetSubStr(aTableFieldsNames[I], '', '_', fPrefix);
      Break;
    end else Correct := False;
  end;
  Result := Correct;
end;

procedure TQuery_API.MyQryError(ASender, AInitiator: TObject;
  var AException: Exception);
begin
  if AException is EFDDBArrayExecuteError then begin
    // Check EFDDBArrayExecuteError(AException).Exception for original
    // EFDDBEngineException exception object.

    // Fix bad value
    fQry.Params[0].AsIntegers[EFDDBArrayExecuteError(AException).Offset] :=
      EFDDBArrayExecuteError(AException).Offset;

    // Ask to retry last operation
    EFDDBArrayExecuteError(AException).Action := eaRetry;
    // Possible values:
    // eaApplied - skip row, but add +1 to the number of updated records
    // eaSkip - just skip this row
    // eaRetry - retry this row
    // eaFail = eaDefault - just raise original exception
    // eaExitSuccess - exit from Execute
    // eaExitFailure - exit from Execute, and do something other
  end;
end;


end.
