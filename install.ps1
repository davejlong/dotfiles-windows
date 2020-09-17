$Modules = @(
  "Posh-Git",
  "PSAtera",
  "AzureAD",
  "MSOnline",
  "Microsoft.Online.SharePoint.PowerShell",
  "MicrosoftTeams",
  "psake"
)
foreach ($module in $Modules) {
  Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber
}

# Run the rest as admin
Start-Process -Verb RunAs powershell.exe -Args "-executionpolicy bypass -command Set-location \`"$PWD\`"; .\install-admin.ps1"
