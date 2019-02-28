<#
  .Synopsis
  Converts a list of Excel documents to CSV files

  .Description
  Converts a list of Excel documents to CSV files

  .Parameter FileList
  List of input files

  .Example
    # Convert all Excel docs in a folder to CSVs
    Get-ChildItem *.xlsx | ConvertTo-ExcelToCSV
  #>
function ConvertTo-ExcelToCsv {
  Param(
  [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
  [System.Array] $FileList
  )
  
  $FileList | ForEach-Object {
    $csv = ($_ | Get-Content)
    [IO.File]::WriteAllText($_.FullName, ($csv -join "`r`n"))
  }
}