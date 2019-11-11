#Requires -RunAsAdministrator

function Set-CorrectDnsServer {
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
  param()

  throw "FIXME"

  $network = Get-NetConnectionProfile | Select-Object Name, InterfaceAlias

  if ($network.Name -match "eduroam") {
    $Interface = "Wi-Fi"
    $ServerName = "Default"

    Write-Output "Changing WiFi DNS Server to defaults"
  }
  elseif ($network.Name -eq "ThereThere") {
    $Interface = "Both"
    $ServerName = "Google"

    Write-Output "Changing WiFi and Ethernet DNS Server to Google"
  }
  else {
    throw "Unknown network $network"
  }

  if ($PSCmdlet.ShouldProcess("Set DNS Server automatically")) {
    Start-Process "pwsh" -Verb runAs -ArgumentList @(
      "-NoLogo"
      "-Command"
      "& ""D:\Projects\powershell-utils\Scripts\Set-DnsServer.ps1"" -Interface $Interface -ServerName $ServerName; Start-Sleep -Seconds 5"
    )
  }
}
