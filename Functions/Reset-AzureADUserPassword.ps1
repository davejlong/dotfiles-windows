function Reset-AzureADUserPassword {
  Param(
    # Email address of the user who's password is being changed
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
    [string] $ObjectId
  )
  Import-Module AzureAD

  Connect-AzureAD
  $password = Generate-TemporaryPassword
  Write-Host "Setting password for $ObjectId to: $password"
  $password = ConvertTo-SecureString $password -AsPlainText -Force
  Set-AzureADUserPassword -ObjectId $ObjectId -ForceChangePasswordNextLogin $true -Password $password
}