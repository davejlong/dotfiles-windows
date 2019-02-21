<#
 .Synopsis
  Connects to a Powershell session in Office 365

 .Description
  Connects to a Powershell session in Office 365 for managing Office 365
  resources such as mailboxes, users, groups, etc.
 
 .Parameter Credentials
  The credentials for connecting to Office 365

 .Example
    # Get prompted for credentials when connecting to Office 365
    Connect-Office365

    # Pass in a credential object to use when connecting to OFfice 365
    Connect-Office365 -Credentials $Creds
#>
function Connect-Office365 {
    Param(
        [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$true)]
        [System.Management.Automation.PSCredential] $Credentials
    )

    if ($Credentials -eq $null) {
        $Credentials = Get-Credential -Message "Office365 Credentials"
    }
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $Credentials -Authentication Basic -AllowRedirection
    Import-PSSession $Session -DisableNameChecking -AllowClobber
}