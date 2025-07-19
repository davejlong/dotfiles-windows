properties {
  $NvimConfigDir = "$env:LOCALAPPDATA/nvim"
  $NvimConfig = Get-Content -Path "$PWD/nvim/install.lua"
  $ProfilePaths = @(
    'PowerShell\Microsoft.VSCode_profile.ps1',
    'PowerShell\Microsoft.PowerShell_profile.ps1',
    'WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
  )
}

Include ./Setup/Helpers.ps1

Task IsPS7 {
  Assert (Get-PSMajorVersion -ge 7) "Task requires PowerShell 7+"
}

Task IsAdmin {
  Assert Get-IsAdmin "Task requires admin"
}

###
# Environment Variables
###
Task EnvVars {
  [System.Environment]::SetEnvironmentVariable("DotfilesPath", "$PWD", "User")
  $env:DotfilesPath = $PWD
}

###
# Winget Apps
###
Task WingetInstall {
  Import-Module Microsoft.WinGet.Client
  $Apps = Get-Content "setup/wingetapps.txt"

  foreach($App in $Apps) {
    # Skip if commented out
    if ($App -like "#*" -or $App -eq "") { continue; }
    # Skip if already installed
    if (Get-WinGetPackage -Id $App) { continue; }

    Exec { winget install $App --silent --accept-package-agreements }
  }
}

###
# PowerShell setup
###
Task PSModules -Precondition { IsPS7 -and IsAdmin } {
  # Installs modules to all users because PowerShell still doesn't have a way to store modules
  # outside of the MyDocuments folder which gets screwed up when MyDocuments points to a
  # OneDrive folder syncing with other computers.
  $Mods = Get-Content "setup/psmodules.txt"
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

Task PowerShell {
  $Documents = [System.Environment]::GetFolderPath('MyDocuments')
  $DotfilesProfile = '$env:DotfilesPath/powershell/profile.ps1'

  New-Item -Path (Join-Path -Path "$Documents" -ChildPath "PowerShell") -ItemType Directory -ErrorAction SilentlyContinue
  New-Item -Path (Join-Path -Path "$Documents" -ChildPath "WindowsPowerShell") -ItemType Directory -ErrorAction SilentlyContinue
  $ProfileString = '. $env:DotfilesPath/powershell/profile.ps1'
  foreach($ProfilePath in $ProfilePaths) {
    $ProfilePath = Join-Path -Path "$Documents" -ChildPath "$ProfilePath"
    if ((Get-Content $ProfilePath) -contains "$ProfileString") { continue; }
    Add-Content -Path (Join-Path -Path "$Documents" -ChildPath "$ProfilePath") -Value ". $DotfilesProfile"
  }
}

###
# VSCode Setup
###
Task VSCode -PreCondition { Get-Command "code" } {
  $Extensions = Get-Content "setup/vscodeextensions.txt"

  foreach($Extension in $Extensions) {
    if ($Extension -like "#*" -or $Extension -eq "") { continue; }
    Exec { code --install-extension $Extension }
  }
}

###
# Neovim Setup
###
Task _NvimPluggedInstall {
  Invoke-NeovimPlugInstall
}

Task _NvimPlugInstall {
  Exec { nvim --headless -c 'PlugInstall' -c 'q' -c 'q' }
}

Task _NvimConfigDir -Precondition { !(Test-Path -Path "$NvimConfigDir") } {
  New-Item -Path "$NvimConfigDir" -ItemType Directory
}

Task _NvimInit -Depends _NvimConfigDir -PreCondition { (Get-Content "$NvimConfigDir/init.lua") -notcontains "$NvimConfig" }{
  Set-Content -Path "$NvimConfigDir/init.lua" -Value $NvimConfig
}

Task Neovim -Depends _NvimInit,_NvimPluggedInstall,_NvimPlugInstall

###
# Autohotkey shortcuts
###
Task AHK {
  Get-ChildItem -Path ahk -Filter *.ahk | ForEach-Object {
    New-StartupShortcut -TargetPath $_
  }
}

###
# Git
###
Task Git {
  $GitConfig = @"
[include]
  path = $($PWD -replace '\\', '/')/git/gitconfig
"@
  Add-Content -Path ~/.gitconfig -Value $GitConfig
}

Task default -Depends EnvVars, Powershell, WingetInstall, Neovim, VSCode, AHK, Git
Task AdminInstall -Depends PSModules
