Invoke-Expression (&starship init powershell)

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

Invoke-WebRequest -Uri "http://wttr.in/hvn?0" | Select-Object -ExpandProperty Content
