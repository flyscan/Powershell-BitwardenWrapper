#Requires -RunAsAdministrator
[CmdletBinding()]
Param (
  # interface selected
  [Parameter()]
  [ValidateSet('Ethernet', 'Wi-Fi', 'Both')]
  [String]
  $Interface = 'Both',
  # Values
  [Parameter(Mandatory)]
  [ValidateSet('Default', 'Google')]
  [String]
  $ServerName
)

$CmdArgs = @{ }

if ($Interface -eq 'Both') {
  $CmdArgs.InterfaceAlias = "Ethernet", "Wi-Fi"
}
else {
  $CmdArgs.InterfaceAlias = $Interface
}

if ($ServerName -eq 'Google') {
  $CmdArgs.ServerAddresses = "8.8.8.8", "8.8.8.4", "2001:4860:4860::8888", "2001:4860:4860::8844"
}
elseif ($ServerName -eq 'Default') {
  $CmdArgs.ResetServerAddresses = $true
}

Set-DnsClientServerAddress @CmdArgs

Clear-DnsClientCache
Get-DnsClientServerAddress -InterfaceAlias $CmdArgs.InterfaceAlias
