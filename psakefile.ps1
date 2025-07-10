Include ./Setup/Helpers.ps1

Task IsPS7 {
  Assert (Get-PSMajorVersion -ge 7) "Task requires PowerShell 7+"
}

Task IsAdmin {
  Assert Get-IsAdmin "Task requires admin"
}

###
# Winget Apps
###
Task WingetInstall {
  $Apps = Get-Content "setup/wingetapps.txt"

  foreach($App in $Apps) {
    if ($App -like "#*" -or $App -eq "") { continue; }
    Exec { winget install $App --silent --accept-package-agreements }
  }
}

###
# PowerShell setup
###
Task PSModules -Depends IsPS7,IsAdmin {
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
  $ProfilePaths = @(
    'PowerShell\Microsoft.VSCode_profile.ps1',
    'PowerShell\Microsoft.PowerShell_profile.ps1',
    'WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
  )
  $Documents = [System.Environment]::GetFolderPath('MyDocuments')
  $DotfilesProfile = Join-Path -Path "$PWD" -ChildPath "powershell/profile.ps1"

  New-Item -Path (Join-Path -Path "$Documents" -ChildPath "PowerShell") -ItemType Directory -ErrorAction SilentlyContinue
  New-Item -Path (Join-Path -Path "$Documents" -ChildPath "WindowsPowerShell") -ItemType Directory -ErrorAction SilentlyContinue
  foreach($ProfilePath in $ProfilePaths) {
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

Task _NvimInit {
  $VimConfig = @"
package.path = package.path .. ";$($PWD -replace '\\', '/')/nvim/init.lua"
require('nvim')
"@
  Set-Content -Path "$env:LOCALAPPDATA/nvim/init.lua" -Value $VimConfig
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

Task default -Depends WingetInstall, Neovim, PowerShell, VSCode, AHK, Git
Task AdminInstall -Depends PSModules