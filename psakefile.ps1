
Include ./Setup/Helpers.ps1

Task EnvVars {
  [System.Environment]::SetEnvironmentVariable("DotfilesPath", "$DotfilesPath", "User")
  $env:DotfilesPath = $DotfilesPath
}

Task WingetApps {
  Import-Module Microsoft.WinGet.Client
  $Apps = Get-Content "setup/wingetapps.txt"

  foreach($App in $Apps) {
    # Skip if commented out
    if ($App -like "#*" -or $App -eq "") { continue; }
    # Skip if already installed
    if (Get-WinGetPackage -Id $App) { Write-Output "$App already installed"; continue; }

    Exec { winget install $App --silent --accept-package-agreements }
  }
}

Task Git {
  $GitConfig = @"
[include]
  path = $($DotfilesPath -replace '\\', '/')/git/gitconfig
"@
  Add-Content -Path "$HOME/.gitconfig" -Value $GitConfig
}

Task Autohotkey {
  Get-ChildItem -Path autohotkey -Filter *.ahk | ForEach-Object {
    New-StartupShortcut -TargetPath $_
  }
}

Task MiscConfigs {
  New-Hardlink -LinkPath "$env:APPDATA/Greenshot/Greenshot.ini" -TargetPath "$DotfilesPath/greenshot/Greenshot.ini"
  New-Hardlink -LinkPath "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json" -TargetPath "$DotfilesPath/terminal/settings.json"
}

Task SubBuilds {
  $Files = Get-ChildItem -Path . -Filter "psakefile.ps1" -Recurse

  foreach($File in $Files) {
    if ($File.FullName -eq "$PSCommandPath") { continue; }
    Invoke-psake -buildFile $File
  }
}

Task default -Depends EnvVars, WingetApps, Git, Autohotkey, SubBuilds