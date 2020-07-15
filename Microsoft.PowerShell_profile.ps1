$ProfileRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$env:path += ";$ProfileRoot"

Get-ChildItem -Path (Join-Path -Path $ProfileRoot -ChildPath "Functions/*.ps1") | ForEach-Object { . ($_.FullName)} | Out-Null

Set-Location -Path $env:USERPROFILE
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
