<#
 .Synopsis
  Resets the password for an AzureAD user

 .Description
  Resets the password for an AzureAD user. By default generates a random
  password to use and sets the account to have password changed at
  next login. Password will be printed to the screen. Requires AzureAD
  Module
 
 .Parameter ObjectId
  The AzureAD object ID, which can be obtained from Get-AzureADUser.
  Alternatively can be the email address for the user.
 
 .Parameter Password
  Password to set on the user. It not passed in, will be generated using Get-RandomPassword

 .Example
    # Set the password for a user to a random string
    Reset-AzureADUserPassword -ObjectId john@example.com

    # Provide a password to set on a user
    Reset-AzureADUserPassword -ObjectId jenn@example.com -Password Foobar123

#>
function Reset-AzureADUserPassword {
  Param(
    # Email address of the user who's password is being changed
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
    [string] $ObjectId,
    # Password to set on the user
    [Parameter(Mandatory=$false)]
    [string] $Password
  )

  Import-Module AzureAD
  Connect-AzureAD

  if ($Password -eq $null) {
    $Password = Generate-TemporaryPassword
    Write-Host "Setting password for $ObjectId to: $Password"
  }
  $Password = ConvertTo-SecureString $password -AsPlainText -Force
  Set-AzureADUserPassword -ObjectId $ObjectId -ForceChangePasswordNextLogin $true -Password $Password
}