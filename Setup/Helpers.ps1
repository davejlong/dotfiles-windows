properties {
  $DotfilesPath = (Join-Path -Path $PSScriptRoot -ChildPath "..")
}

function Get-IsAdmin {
  (
    [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
  ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-IsPS7 {
  Assert (Get-PSMajorVersion -ge 7) "Task requires PowerShell 7+"
}

function Get-PSMajorVersion {
  $PSVersionTable.PSVersion.Major
}

function Invoke-TaskAsAdmin($TaskName) {
  Start-Process -Wait -PassThru -Verb runas -FilePath "pwsh" -WorkingDirectory "." -ArgumentList '-Command', "Invoke-psake -taskList $TaskName"
}

function New-Hardlink($LinkPath, $TargetPath) {
  $Link = Resolve-Path $LinkPath
  $Target = Resolve-Path $TargetPath

  if (Test-Path -Path $Link) {
    $FileName = Split-Path $Link -Leaf
    Rename-Item $Link -NewName "$FileName.orig"
  }

  Exec { cmd /C mklink /H "$($Link.Path)" "$($Target.Path)" }
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