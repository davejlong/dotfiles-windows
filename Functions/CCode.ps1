function CCode {
  $CodeLocation = Join-Path -Path ([Environment]::GetFolderPath("MyDocuments")) -ChildPath "Code"
  Set-Location -Path $CodeLocation
}