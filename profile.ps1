$env:PSUserModulePath = Join-Path $env:LOCALAPPDATA "powershell/Modules"
if (!(Test-Path $env:PSUserModulePath)) {
  New-Item -Path $env:PSUserModulePath -ItemType Directory -InformationAction SilentlyContinue
}

$ProfileRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$env:path += ";$ProfileRoot;$ProfileRoot/Scripts"

Get-ChildItem -Path (Join-Path -Path $ProfileRoot -ChildPath "Functions/*.ps1") | ForEach-Object { . ($_.FullName)} | Out-Null
Get-ChildItem -Path (Join-Path -Path $ProfileRoot -ChildPath "Modules/**/*.psm1") | ForEach-Object { Import-Module $_ }

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# PowerToys Command Not Found
if (Get-Module -ListAvailable Microsoft.WinGet.CommandNotFound) {
  Import-Module -Name Microsoft.WinGet.CommandNotFound
}

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\robbyrussell.omp.json" | Invoke-Expression
