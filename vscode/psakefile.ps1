Include ../Setup/Helpers.ps1

###
# VSCode Setup
###
Task VSCExtensions -PreCondition { Get-Command "code" } {
  $Extensions = Get-Content "../setup/vscodeextensions.txt"

  foreach($Extension in $Extensions) {
    if ($Extension -like "#*" -or $Extension -eq "") { continue; }
    Exec { code --install-extension $Extension }
  }
}

Task VSCSetup {
  New-Hardlink -LinkPath $VSCodeConfig -TargetPath "$DotfilesPath/vscode/settings.json"
}

Task default -Depends VSCSetup, VSCExtensions