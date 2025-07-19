$Helpers = Get-ChildItem -Path "$PSScriptRoot\Helpers" -Filter "*.ps1"

foreach ($import in @($Helpers)) {
  try {
    . $import.FullName
  } catch {
    Write-Error -Message "Failed to import function $($import.FullName): $_"
  }
}

Export-ModuleMember -Function $Helpers.BaseName -Alias *