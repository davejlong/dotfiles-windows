Include ./Setup/Helpers.ps1

Task RequirePS7 {
  Assert (Get-PSMajorVersion -ge 7) "Task requires PowerShell 7+"
}

Task RequireAdmin {
  Assert Get-IsAdmin "Task requires admin"
}

Task Apps {
  $Apps = Get-Content "setup/wingetapps.txt"

  foreach($App in $Apps) {
    if ($App -like "#*" -or $App -eq "") { continue; }
    Exec { winget install $App --silent --accept-package-agreements }
  }
}

Task PSModules -Depends RequirePS7 {
  if (Get-IsAdmin) {
    $Mods = Get-Content "setup/psmodules.txt"

    foreach($Mod in $Mods) {
      if ($Mod -like "#*" -or $Mod -eq "") { continue; }
      Install-Module -Scope AllUsers -Name $Mod -AcceptLicense
    }
  } else {
    Invoke-TaskAsAdmin -TaskName "PSModules"
  }
}

Task VSCodeExtensions -PreCondition { Get-Command "code" } {
  $Extensions = Get-Content "setup/vscodeextensions.txt"

  foreach($Extension in $Extensions) {
    if ($Extension -like "#*" -or $Extension -eq "") { continue; }
    Exec { code --install-extension $Extension }
  }
}

Task Nvim {
  $NvimConfigPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "nvim"
  if (!(Test-Path -Path $NvimConfigPath)) {
    New-Item -Path $NvimConfigPath -ItemType Directory
  }

  if (Get-IsAdmin) {
    New-Item -Path "$NvimConfigPath/init.vim" -ItemType SymbolicLink -Value $PWD/nvim/init.vim
  } else {
    Invoke-TaskAsAdmin -TaskName "Nvim"
  }
}

Task AHK {
  Get-ChildItem -Path ahk -Filter *.ahk | ForEach-Object {
    New-StartupShortcut -TargetPath $_
  }
}

Task InstallProfile {
  $ProfilePaths = @(
    'PowerShell\Microsoft.VSCode_profile.ps1',
    'PowerShell\Microsoft.PowerShell_profile.ps1',
    'WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
  )
  $Documents = [System.Environment]::GetFolderPath('MyDocuments')
  $DotfilesProfile = Join-Path -Path "$PWD" -ChildPath "profile.ps1"
  foreach($ProfilePath in $ProfilePaths) {
    Add-Content -Path (Join-Path -Path "$Documents" -ChildPath "$ProfilePath") -Value ". $DotfilesProfile"
  }
}

Task default -depends Apps,PSModules,VSCodeExtensions,AHKScripts,InstallProfile