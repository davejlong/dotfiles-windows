<#
.NOTES
===========================================================================
Updated on:   	2019-02-18
Created by:   	davejlong	
===========================================================================
AzureAD Module is required
Install-Module -Name AzureAD
https://www.powershellgallery.com/packages/azuread/
.DESCRIPTION
Gets only licensed users from Office 365 tenant.
#>
function Get-LicensedAzureADUsers {
  Connect-AzureAD
  $LicensedUsers = @()
  Get-AzureADUser | ForEach-Object {
    if ($_.AssignedLicenses.Count -gt 0) {
      $LicensedUsers += $_
    }
  }
  return $LicensedUsers
}