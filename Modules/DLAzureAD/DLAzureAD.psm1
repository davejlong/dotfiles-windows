$ModuleRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)

Get-ChildItem -Path $ModuleRoot -Filter *.ps1 | ForEach-Object {
  . $_.FullName
}

Export-ModuleMember -Function Connect-Office365
Export-ModuleMember -Function Get-LicensedAzureADUsers
Export-ModuleMember -Function Get-Office365Report
Export-ModuleMember -Function Reset-AzureADUserPassword
Export-ModuleMember -Function Sync-Office365ToADDS