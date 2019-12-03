function Unlock-BitwardenDatabase {
  [CmdletBinding()]

  $WRONG_MASTER_PASSWORD = 'Invalid master password.'
  $EMPTY_MASTER_PASSWORD = 'Master password is required.'

  if ($env:BW_SESSION) {
    Write-Output "Bitwarden database was already unlocked"
    return
  }

  $SESSION = bw.exe unlock --raw

  if (Get-Module PSReadLine) {
    Write-Verbose "Removing PSReadline module"
    Remove-Module PSReadLine
  }

  if ($SESSION -match $WRONG_MASTER_PASSWORD -or $SESSION -match $EMPTY_MASTER_PASSWORD) {
    Throw "Unlock failed"
  }

  Write-Output "Bitwarden database unlocked"

  # remember current session
  Write-Verbose "Saving session key to environment variable"
  $env:BW_SESSION = $SESSION
}

. "$PSScriptRoot/Classes/Item.ps1"

function Get-BitwardenDatabase {
  [CmdletBinding()]

  $lastSync = (Get-Date) - (Get-Date (bw.exe sync --last))
  if ($lastSync -ge [timespan]::FromMinutes(5)) {
    Write-Verbose "Syncing db"
    bw.exe sync | Out-Null
  }
  else {
    Write-Verbose "Using cached db"
  }

  $rawOutput = bw.exe list items
  return "{`"root`":$rawOutput}" | ConvertFrom-Json | Select-Object -ExpandProperty root
}

function Test-ContainsSensitiveWords {
  [CmdletBinding()]
  [OutputType([bool])]
  param (
    [Parameter(Mandatory, ValueFromPipeline)]
    [String]
    $InputString,
    [Parameter(Mandatory)]
    [String[]]
    $SensitiveWords
  )

  $null -ne ($SensitiveWords | Where-Object { $InputString -match $_ } | Select-Object -First 1)
}

# Unlock-BitwardenDatabase
