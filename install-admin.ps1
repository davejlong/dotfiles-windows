Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

$cinst = Join-Path -Path $env:ProgramData -ChildPath "chocolatey\bin\cinst.exe"

@(
  "7zip",
  "Cmder",
  "discord",
  "dropbox",
  "explorerplusplus",
  "firefox",
  "git",
  "microsoft-teams",
  "neovim",
  "networkmanager",
  "nmap",
  "office365proplus",
  "openssh",
  "powertoys",
  "putty.install",
  "spotify",
  "steam",
  "sysinternals",
  "tftpd32",
  "vlc",
  "vscode",
  "wireshark"
) | ForEach-Object { & $cinst --yes $_ }

@(
  "Microsoft-Windows-Subsystem-Linux",
  "Microsoft-Hyper-V-Tools-All",
  "TelnetClient"
) | ForEach-Object { Enable-WindowsOptionalFeature -FeatureName $_ -Online -NoRestart -All }

###
# Setup Nvim config
###
New-Item -ItemType Directory -Path "$env:LOCALAPPDATA/nvim"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA/nvim/init.vim" -Target "$PWD/nvim/init.vim"
