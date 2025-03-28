$InstallerRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$DotfilesRoot = Split-Path -Parent $InstallerRoot

###
# Winget
###

$Apps = @(
  "Mozilla.Firefox"
  "Spotify.Sportify"
  "VideoLAN.VLC"
  "9NMPJ99VJBWV" # Phone Link

  # Tools
  "7zip.7zip"
  "AutoHotkey.AutoHotkey"
  "CPUID.CPU-Z"
  "Git.Git"
  "JanDeDobbeleer.OhMyPosh"
  "Microsoft.PowerToys"
  "Ookla.Speedtest"

  # Productivity
  "Dropbox.Dropbox"
  "Microsoft.Office"
  "XPDLPKWG9SW2WD" # Adobe Creative Cloud

  # Communication
  "Discord.Discord"
  "SlackTechnologies.Slack"
  "WhatsApp.WhatsApp"

  # IT
  "BornToBeRoot.NETworkManager"
  "Insecure.Nmap"
  "Microsoft.PowerShell"
  "Microsoft.Sysinternals.Autoruns"
  "Microsoft.Sysinternals.ProcessExplorer"
  "Microsoft.Sysinternals.ProcessMonitor"
  "Microsoft.VisualStudioCode"
  "Neovim.Neovim"
  "Splashtop.SplashtopBusiness"
  "WiresharkFoundation.Wireshark"
  
  # Gaming
  "EpicGames.EpicGamesLauncher"
  "Valve.Steam"

  # 3D Printing
  "OpenSCAD.OpenSCAD"
  "Prusa3D.PrusaSlicer"
  "PTRTECH.UVtools"
)

$Apps | ForEach-Object {
    winget install $_ --silent --accept-package-agreements
}

###
# Font install
###
& (Join-Path -Path $DotfilesRoot -ChildPath "fonts/install.ps1")

###
# PowerShell Modules
###
$Modules = @(
  "AzureAD"
  "Microsoft.Online.SharePoint.PowerShell"
  "MicrosoftTeams"
  "MSOnline"
  "Posh-Git"
  "psake"
)
foreach ($module in $Modules) {
  Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber
}

###
# VSCode extensions
###
$code = Join-Path $env:ProgramFiles "Microsoft VS Code/code"
if (Test-Path $code) {
  # PowerShell Code Plugin
  Install-Script Install-VSCode -Scope CurrentUser; Install-VSCode.ps1
  @(
    "antyos.openscad"
    "MarlinFirmware.auto-build"
    "ms-vscode-remote.remote-wsl"
    "ms-vscode.theme-tomorrowkit"
    "platformio.platformio-ide"
    "slevesque.vscode-autohotkey"
    "vscodevim.vim",
    "yzhang.markdown-all-in-one"
  ) | ForEach-Object { Start-Process -Wait $code -Args "--install-extension $_" }
}

###
# Deploy the PowerShell profile file
###
(Get-Content Microsoft.PowerShell_profile.tmpl.ps1 -Raw) -replace "<<DOTFILES_ROOT>>", "$DotfilesRoot" | Set-Content $Profile

###
# Install all AutoHotkey Startup scripts
###
$Startup = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup"
$WshShell = New-Object -ComObject WScript.Shell
Get-ChildItem -Path ahk -Filter *.ahk | ForEach-Object {
  $Shortcut = $WshShell.CreateShortcut("$Startup\$($_.Name).lnk")
  $Shortcut.TargetPath = $_.FullName
  $Shortcut.Save()
}