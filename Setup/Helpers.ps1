function Get-IsAdmin() {
  (
    [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
  ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-PSMajorVersion() {
  $PSVersionTable.PSVersion.Major
}

function Invoke-TaskAsAdmin($TaskName) {
  Start-Process -Wait -PassThru -Verb runas -FilePath "pwsh" -WorkingDirectory "." -ArgumentList '-Command', "Invoke-psake -taskList $TaskName"
}

function New-StartupShortcut($TargetPath) {
  $Startup = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup"
  $WshShell = New-Object -ComObject WScript.Shell

  $Shortcut = $WshShell.CreateShortcut("$Startup\$($TargetPath.Name).lnk")
  $Shortcut.TargetPath = $TargetPath.FullName
  $Shortcut.Save()
}

function Invoke-NeovimPlugInstall {
  $AutoloadDir = Join-Path -Path $env:LOCALAPPDATA -ChildPath "nvim/autoload"
  $PlugFile = Join-Path -Path $AutoloadDir -ChildPath "plug.vim"

  if (Test-Path -Path $PlugFile) { return }

  if (!(Test-Path -Path "$AutoloadDir")) {
    New-Item -Path $AutoloadDir -ItemType Directory
  }

  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -OutFile "$AutoloadDir/plug.vim"
}