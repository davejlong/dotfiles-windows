$ProfileRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$env:path += ";$ProfileRoot;$ProfileRoot/Scripts"

Get-ChildItem -Path (Join-Path -Path $ProfileRoot -ChildPath "Functions/*.ps1") | ForEach-Object { . ($_.FullName)} | Out-Null
Get-ChildItem -Path (Join-Path -Path $ProfileRoot -ChildPath "Modules/**/*.psm1") | ForEach-Object { Import-Module $_ }

# Set-Location -Path $env:USERPROFILE
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
Set-Theme AgnosterPlus
Set-Prompt