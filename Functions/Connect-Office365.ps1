###############################################################################
# This script creates a new Powershell session connected to Office365
###############################################################################

function Connect-Office365 {
    Param(
        [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$true)]
        [System.Management.Automation.PSCredential] $Office365Credential
    )

    if ($Office365Credential -eq $null) {
        $Office365Credential = Get-Credential -Message "Office365 Credentials"
    }
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $Office365Credential -Authentication Basic -AllowRedirection
    Import-PSSession $Session -DisableNameChecking
}