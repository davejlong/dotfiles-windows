$InstallerRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

. "$InstallerRoot/Install-Winget.ps1"

# Make sure PowerShell 7 is installed
. winget install "Microsoft.PowerShell" --silent --accept-package-agreements

. "$InstallerRoot/Execute-Setup.ps1"
