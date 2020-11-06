$Modules = @(
  "Posh-Git",
  "PSAtera",
  "AzureAD",
  "MSOnline",
  "Microsoft.Online.SharePoint.PowerShell",
  "MicrosoftTeams",
  "psake",
  "Oh-My-Posh"
)
foreach ($module in $Modules) {
  Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber
}

# Run the rest as admin
Start-Process -Verb RunAs -Wait powershell.exe -Args "-executionpolicy bypass -command Set-location \`"$PWD\`"; .\install-admin.ps1"

$code = Join-Path $env:ProgramFiles "Microsoft VS Code/code"
if (Test-Path $code) {
  # PowerShell Code Plugin
  Install-Script Install-VSCode -Scope CurrentUser; Install-VSCode.ps1
  @(
    "vscode.vim",
    "slevesque.vscode-autohotkey",
    "yzhang.markdown-all-in-one",
    "ms-vscode-remote.remote-wsl",
    "ms-vscode.theme-tomorrowkit"
  ) | ForEach-Object { $code --install-extension $_ }
}
