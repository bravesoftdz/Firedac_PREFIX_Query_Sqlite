unit UFunctions;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.RegularExpressions;

  function GetSubStr(aStr, ABeforeSubstr, aAfterSubStr: string; out aSubstr: string): Boolean;
  function TrimedString(aStr, ABeforeSubstr, aAfterSubStr: string): string;

implementation

function TrimedString(aStr, ABeforeSubstr, aAfterSubStr: string): string;
var
  Match: TMatch;
begin
  Match := TRegEx.Match(aStr, ABeforeSubstr + '(.*?)'+ aAfterSubStr, [roIgnoreCase, roMultiLine]);
  if Match.Success then
    Result := StringReplace(aStr.Trim, Match.Value.Trim, '', [rfReplaceAll, rfIgnoreCase]).Trim;
end;

function GetSubStr(aStr, ABeforeSubstr, aAfterSubStr: string; out aSubstr: string): Boolean;
var
  Match: TMatch;
  IsExist: Boolean;
begin
  IsExist := False;
  // Remove break lines and spaces
  aStr := StringReplace(StringReplace(aStr, #10, ' ', [rfReplaceAll]), #13, ' ', [rfReplaceAll]).Trim;

  Match := TRegEx.Match(aStr,'(?<='+ ABeforeSubstr + ')(.*?)(?=' + aAfterSubStr + ')', [roIgnoreCase]); // is ABeforeSubstr and aAfterSubStr exist even is concatenated with others.. and of course roIgnoreCase
  if Match.Success then begin
    IsExist := True;
    aSubstr := Match.Value.Trim;
  end; // else raise Exception.Create('No MATCH'); // No need for the exception (it was uses just for a test )..
  Result := IsExist;
end;

end.
