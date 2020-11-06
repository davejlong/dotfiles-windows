# My Windows Dotfiles
This repo contains my Windows "dotfiles": the configuration for my shell (PowerShell).

## Install

Just checkout the code to wherever you'd like and run the install.ps1 script:

```
git clone https://github.com/davejlong/dotfiles-windows.git $HOME/.dotfiles
Set-Location $HOME/.dotfiles
./install.ps1
```

The install script runs through a number of processes:

1. Install all of my commonly used PowerShell modules
2. Install Chocolatey and all of my common software packages
3. Install a few Windows Optional FEatures
4. Install VSCode extensions that I use
5. Copy to the default PowerShell Profile a script that loads all of my profile when I start PowerShell
6. Install Powerline Fonts that I use in my shell