$MyDocuments = [Environment]::GetFolderPath("MyDocuments")
$DotFilesPath = Join-Path -Path $MyDocuments -ChildPath "Code/dotfiles"
. "$DotFilesPath/profile.ps1" 