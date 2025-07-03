function IsAdmin() {
  (
    [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
  ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Invoke-WinGetInstall([string]$App) {
  $ProcessDef = @{
    FilePath = "winget.exe"
    PassThru = $true
    Wait = $true
    ArgumentList = @("install", "$App", "--silent", "--accept-package-agreements")
  }
  Start-Process @ProcessDef
}

function Invoke-VSCodeExtInstall($Ext) {
  $ProcessDef = @{
    FilePath = "$env:ProgramFiles/Microsoft VS Code/code"
    PassThru = $true
    Wait = $true
    ArgumentList = @("--install-extension", "$Ext")

  }
  Start-Process @ProcessDef
}

Export-ModuleMember -Function Execute-WinGetInstall, IsAdmin