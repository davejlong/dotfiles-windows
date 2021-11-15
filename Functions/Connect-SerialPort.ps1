function Connect-SerialPort {
  [CmdletBinding()]
  param (
      [String]$SerialPort,
      [Int]$BaudRate=115200,
      [Int]$DataBits=8,
      [Int]$StopBits=1,
      [ValidateSet("N","O","E","M","S")]
      [String]$Parity = "N",
      [ValidateSet("N","X","R","D")]
      [String]$FlowControl = "N"
  )
  $COMPort = $SerialPort
  if (!$SerialPort) { $COMPort = Find-COMPort }
  Write-Host "Connection to Serial Port"
  Write-Host "Port: $COMPort"
  Write-Host "Baud Rate: $BaudRate"
  Write-Host "Data Bits: $DataBits"
  Write-Host "Parity: $Parity"
  Write-Host "Flow Control: $FlowControl"

  & plink.exe -serial $COMPort -sercfg $BaudRate,$DataBits,$StopBits,$Parity,$FlowControl
}

function Find-COMPort {
  # Get a list of the local USB COM serial ports
  $Query = 'Service like "%ser%" AND PNPClass = "Ports" AND DeviceID like "USB%"'
  $Ports = Get-CimInstance win32_pnpentity -Filter $Query
  
  # Try to find a Serial Device
  $Port = $Ports
  if ($Ports.count -gt 1) {
    $Port = Read-SerialPortFromUser -Ports $Ports
  }
  $Port.Name -match "\((?<COMPort>COM\d+)\)" | Out-Null
  $PortMatches = $Matches
  if ($PortMatches -eq $null) { return "COM1" }
  else { return $PortMatches["COMPort"] }
}

function Read-SerialPortFromUser($ports) {
  for($index=0; $index -lt $ports.Length; $index++) {
    Write-Host "$($index+1). $($ports[$index].Name)"
  }
  $selectedport = Read-Host "Which serial port do you want to connect to?"
  return $ports[$selectedport-1]
}
