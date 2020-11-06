$DotfilesRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

###
# Install all the nice modules I use
###
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

###
# Run any pieces of the install that need admin rights
###
Start-Process -Verb RunAs -Wait pwsh.exe -Args "-executionpolicy bypass -command Set-location \`"$DotfilesRoot\`"; .\install-admin.ps1"

###
# Install VSCode extensions
###
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
  ) | ForEach-Object { Start-Process -Wait $code -Args "--install-extension $_" }
}

###
# Deploy the PowerShell profile file
###
(Get-Content Microsoft.PowerShell_profile.tmpl.ps1 -Raw) -replace "<<DOTFILES_ROOT>>", "$DotfilesRoot" | Set-Content $Profile

###
# Download and install Powerline Fonts
###
Set-Location $env:TEMP
git clone https://github.com/powerline/fonts.git
Set-Location fonts
Start-Process -Wait pwsh.exe -Args "-executionpolicy bypass -command .\install.ps1"
Set-Location $DotfilesRoot