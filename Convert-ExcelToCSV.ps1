Param(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
    [System.Array] $FileList
)

$FileList | ForEach-Object {
    $csv = ($_ | Get-Content)
    [IO.File]::WriteAllText($_.FullName, ($csv -join "`r`n"))
}