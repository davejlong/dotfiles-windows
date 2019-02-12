$ProfileRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$env:path += ";$ProfileRoot"

Get-ChildItem -Path (Join-Path -Path $ProfileRoot -ChildPath "Functions/*.ps1") | ForEach-Object { . ($_.FullName)} | Out-Null