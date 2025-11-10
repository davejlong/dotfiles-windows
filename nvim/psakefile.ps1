Include ../Setup/Helpers.ps1

properties {
  $NvimConfigDir = "$env:LOCALAPPDATA/nvim"
  $NvimConfigFile = "$NvimConfigDir/init.lua"
}

###
# Neovim Setup
###
Task NvimPluggedInstall {
  Invoke-NeovimPlugInstall
}

Task NvimPlugInstall {
  Exec { nvim --headless -c 'PlugInstall' -c 'q' -c 'q' }
}

Task NvimConfigDir -Precondition { !(Test-Path -Path "$NvimConfigDir") } {
  New-Item -Path "$NvimConfigDir" -ItemType Directory
}

Task NvimInit -Depends NvimConfigDir {
  $NvimConfig = Get-Content -Path "./install.lua"
  if ((Get-Content "$NvimConfigFile") -contains "$NvimConfig") {
    return
  }
  Set-Content -Path "$NvimConfigFile" -Value $NvimConfig
}

Task default -Depends NvimInit, NvimPluggedInstall, NvimPlugInstall