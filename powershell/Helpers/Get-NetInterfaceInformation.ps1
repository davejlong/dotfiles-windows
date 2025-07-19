function Get-NetInterfaceInformation {
  [CmdletBinding()]
  param (
    [ValidateSet("IPv4","IPv6")]
    [String]$AddressFamily
  )
  
  Get-NetIPInterface @PSBoundParameters | Sort-Object InterfaceMetric | ForEach-Object {
    if($_.ifIndex -eq 1) { return; }
    $adapter = $_ | Get-NetAdapter
    $address = $_ | Get-NetIPAddress
    [PSCustomObject]@{
      InterfaceAlias=$_.InterfaceAlias;
      InterfaceIndex=$_.ifIndex;
      InterfaceDescription=$adapter.InterfaceDescription;
      Address="$($address.IPAddress)/$($address.PrefixLength)"
      Metric=$_.InterfaceMetric;
      Speed=$adapter.LinkSpeed;
    }
  }
}