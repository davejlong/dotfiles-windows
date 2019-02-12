$Modules = @(
  "Posh-Git",
  "ReportHTML",
  "AzureAD",
  "UniversalDashboard",
  "AzureRM"
)
foreach ($module in $Modules) {
  Install-Module -Force -AllowClobber -Name $module
}