<#
  .Synopsis
    Removes a user account from Office 365
  
  .Description
    Runs through the following for a user account in Office 365:
      * Converts milabox into Shared mailbox (if needed)
      * Removes all licenses from user account
      * Disables login for user
  
  .Parameter ObjectId
    User account to remove
  
  .Parameter SharedMailboxMember
    User who should have full access to the Shared Mailbox
  
  .Example
    # Removes a user forwarding all mail to someone else
    Remove-Office365User -ObjectId john@example.com -SharedMailboxMember jen@example.com
#>
function Remove-Office365User {
  Param(
    # User account to remove
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
    [string] $ObjectId,
    # User who should have full access to Shared mailbox
    [Parameter(Mandatory=$false)]
    [string] $SharedMailboxMember
  )

  # Convert account to Shared Mailbox
  Connect-Office365
  Set-Mailbox -Identity $ObjectId -Type Shared
  if($SharedMailboxMember -ne $null) {
    Add-MailboxPermission -Identity $ObjectId -User $SharedMailboxMember `
      -AccessRights FullAccess -InheritanceType All
  }

  # Remove licenses from user
  Import-Module AzureAD
  Connect-AzureAD
  $User = Get-AzureADUserLicenseDetail -ObjectId $ObjectId
  $Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
  $Licenses.RemoveLicenses = $User.SkuId
  Set-AzureADUserLicense -ObjectId $ObjectId -AssignedLicenses $Licenses

  # Disable account
  Set-AzureADUser -ObjectId $ObjectId -AccountEnabled $false
}