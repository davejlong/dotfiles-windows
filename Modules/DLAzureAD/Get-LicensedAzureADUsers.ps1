<#
 .Synopsis
  Collects all licensed users in AzureAD

 .Description
  Collects all licensed users in AzureAD. Leaves off users
  which do not have licenses assigned.
 
 .Example
    # Get licensed users
    Get-LicensedAzureADUsers
#>
function Get-LicensedAzureADUsers {
  Import-Module AzureAD
  Connect-AzureAD
  $LicensedUsers = @()
  Get-AzureADUser | ForEach-Object {
    if ($_.AssignedLicenses.Count -gt 0) {
      $LicensedUsers += $_
    }
  }
  return $LicensedUsers
}