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