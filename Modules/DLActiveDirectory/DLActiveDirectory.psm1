$ModuleRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)

Get-ChildItem -Path $ModuleRoot -Filter *.ps1 | ForEach-Object {
  . $_.FullName
}

Export-ModuleMember -Function Get-ADReport