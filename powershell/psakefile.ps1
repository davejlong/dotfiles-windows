Include ../Setup/Helpers.ps1

Task PSProfile {
  $Documents = [System.Environment]::GetFolderPath('MyDocuments')
  $DotfilesProfile = '$env:DotfilesPath/powershell/profile.ps1'
  $ProfilePaths = @(
    'PowerShell\Microsoft.VSCode_profile.ps1',
    'PowerShell\Microsoft.PowerShell_profile.ps1',
    'WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
  )

  New-Item -Path (Join-Path -Path "$Documents" -ChildPath "PowerShell") -ItemType Directory -ErrorAction SilentlyContinue
  New-Item -Path (Join-Path -Path "$Documents" -ChildPath "WindowsPowerShell") -ItemType Directory -ErrorAction SilentlyContinue
  $ProfileString = '. $env:DotfilesPath/powershell/profile.ps1'
  foreach($ProfilePath in $ProfilePaths) {
    $ProfilePath = Join-Path -Path "$Documents" -ChildPath "$ProfilePath"
    if ((Get-Content $ProfilePath) -contains "$ProfileString") { continue; }
    Add-Content -Path (Join-Path -Path "$Documents" -ChildPath "$ProfilePath") -Value ". $DotfilesProfile"
  }
}

Task PSModules -Precondition { Get-IsPS7 -and Get-IsAdmin } {
  # Installs modules to all users because PowerShell still doesn't have a way to store modules
  # outside of the MyDocuments folder which gets screwed up when MyDocuments points to a
  # OneDrive folder syncing with other computers.
  $Mods = Get-Content "$DotfilesPath/setup/psmodules.txt"
  $InstalledMods = Get-Module -ListAvailable
  $PSGallery = Get-PSRepository -Name PSGallery
  Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

  foreach($Mod in $Mods) {
    if ($Mod -like "#*" -or $Mod -eq "") { continue; }
    if ($InstalledMods.Name -contains $Mod) {
      Update-Module -Name $Mod -AcceptLicense
    }
    Install-Module -Name $Mod -Scope AllUsers -AcceptLicense
  }

  Set-PSRepository -Name PSGallery -InstallationPolicy $PSGallery.InstallationPolicy
}

Task default -Depends PSProfile, PSModules