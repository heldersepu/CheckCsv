program CheckCSV;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

procedure printHelp;
begin
  WriteLn(' This Tool checks a CSV file for Errors ');
  WriteLn(' It assumes text qualifier = " ');
  WriteLn('  ');
end;

function fixCsvLine(csvLine: String): string;
var
  i: integer;
begin

  for i := 2 to length(csvLine) - 1 do
    if csvLine[i] = '"' then
      if not ((csvLine[i-1] = ',') or (csvLine[i+1] = ',')) then
        csvLine[i] := '*';
  fixCsvLine := csvLine;
end;


function isGoodCsvLine(csvLine: String): boolean;
var
  i: integer;
begin
  isGoodCsvLine := True;
  csvLine := StringReplace(csvLine, ' ', '', [rfReplaceAll]);
  csvLine := StringReplace(csvLine, #9 , '', [rfReplaceAll]);

  for i := 2 to length(csvLine) - 1 do
    if csvLine[i] = '"' then
      if not ((csvLine[i-1] = ',') or (csvLine[i+1] = ',')) then
      begin
        csvLine[i] := '*';
        isGoodCsvLine := False;
      end;
end;


procedure checkCsvFile(csvFile: String);
var
  fileData, outPutData, correctFileData : TStringList;
  i: integer;
begin
  correctFileData := TStringList.Create;
  outPutData := TStringList.Create;
  fileData := TStringList.Create;
  fileData.LoadFromFile(csvFile);
  for i := 0 to fileData.Count - 1 do
  begin
    If not isGoodCsvLine(fileData[i]) then
    begin
      outPutData.Add(fileData[i]);
      correctFileData.Add(fixCsvLine(fileData[i]));
    end
    else
      correctFileData.Add(fileData[i])
  end;

  if (outPutData.Count > 0) then
  begin
    correctFileData.SaveToFile(csvFile + '.fix.csv');
    outPutData.SaveToFile(csvFile + '.txt');
    WriteLn('File with potential errors created: ' + #13#10 +  csvFile + '.txt');
  end
  else
    WriteLn('No errors Found!');
end;


begin
  If (ParamCount > 0) then
  begin
    If FileExists(ParamStr(1)) then
      checkCsvFile(ParamStr(1))
    else
      WriteLn('"' + ParamStr(1) + '" is NOT a valid file!');
  end
  else
    printHelp;
end.
