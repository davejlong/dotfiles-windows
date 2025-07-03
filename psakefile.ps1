Import-Module ./Setup/Helpers.psm1

Task RequirePS7 {
  Assert ($PSVersionTable.PSVersion.Major -ge 7) "Task requires PowerShell 7+"
}

Task RequireAdmin {
  Assert IsAdmin "Task requires admin"
}

Task Apps {
  $Apps = Get-Content "setup/wingetapps.txt"

  foreach($App in $Apps) {
    if ($App -like "#*" -or $App -eq "") { continue; }
    Invoke-WinGetInstall -App $App
  }
}

Task PSModules -Depends RequirePS7,RequireAdmin {
  $Mods = Get-Content "setup/psmodules.txt"

  foreach($Mod in $Mods) {
    if ($Mod -like "#*" -or $Mod -eq "") { continue; }
    Install-Module -Scope AllUsers -Name $Mod -AcceptLicense
  }
}

Task VSCodeExtensions -PreCondition { Test-Path "$env:ProgramFiles/Microsoft VS Code/code" } {
  $Extensions = Get-Content "setup/vscodeextensions.txt"

  foreach($Extension in $Extensions) {
    if ($Extension -like "#*" -or $Extension -eq "") { continue; }
    Invoke-VSCodeExtInstall -Ext $Extension
  }
}

Task AHKScripts {
  
}


Task default -depends Apps,PSModules,VSCodeExtensions,AHKScripts