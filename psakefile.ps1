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

Task AHKScripts {
  
}

Task default -depends Apps,PSModules,VSCodeExtensions,AHKScripts