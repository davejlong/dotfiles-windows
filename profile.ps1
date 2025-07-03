Invoke-Expression (&starship init powershell)

$ProfileRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)
# $env:path += ";$ProfileRoot;$ProfileRoot/Scripts"

Get-ChildItem -Path (Join-Path -Path $ProfileRoot -ChildPath "Functions/*.ps1") | ForEach-Object { . ($_.FullName)} | Out-Null

# PowerToys Command Not Found
if (Get-Module -ListAvailable Microsoft.WinGet.CommandNotFound) {
  Import-Module -Name Microsoft.WinGet.CommandNotFound
}

if (Get-Module -ListAvailable -Name gsudoModule) {
  Import-Module -Name gsudoModule
}

if (Get-Module -ListAvailable -Name SyncroRMM) {
  Import-Module -Name SyncroRMM
  if ($env:SYNCRO_SUBDOMAIN) { Set-SyncroSubdomain -Subdomain $env:SYNCRO_SUBDOMAIN }
  if ($env:SYNCRO_API_KEY) { Set-SyncroApiKey -ApiKey $env:SYNCRO_API_KEY }
}

# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\robbyrussell.omp.json" | Invoke-Expression
