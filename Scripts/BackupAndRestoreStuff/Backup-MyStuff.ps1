# Export Windows package manager programs
function Export-Scoop {
  function Read-RawLine {
    Param(
      [String]
      $line
    )
    $MatchPattern = "^(?<Name>.+) \(v\:(?<Version>.*?)\) (?<Global>\*global\* ){0,1}\[(?<Bucket>.*?)\]$"

    $MatchFound = $line -match $MatchPattern
    if (-not $MatchFound) {
      Write-Error "line was not parsed correctly: $line"
    }

    return [PSCustomObject]@{
      Name     = $Matches["Name"]
      Version  = $Matches["Version"]
      IsGlobal = if ($Matches["Global"]) {
        $true
      }
      else {
        $false
      }
      Bucket   = $Matches["Bucket"]
    }
  }

  $parsed = scoop.ps1 export | ForEach-Object { Read-RawLine $_ }

  $programs = $parsed | Select-Object -ExcludeProperty Bucket
  $buckets = $parsed | Select-Object -Unique -ExpandProperty Bucket

  # ConvertTo-Json ([ordered]@{
  #  when     = (Get-Date -Format "o")
  #  buckets  = $buckets
  #  programs = $programs
  #})

  [ordered]@{
    when     = (Get-Date -Format "o")
    buckets  = $buckets
    programs = $programs
  } | ConvertTo-Json

}

## npm globals
# "npm install" takes multiple arguments separated by space
function Export-NpmGlobalPackages {
  $rawList = (npm.cmd list -g --depth=0 --parseable)

  $baseFolder, $packages = $rawList
  $basePath = (Join-Path $baseFolder "node_modules\")

  ($packages | ForEach-Object { $_ -replace [regex]::Escape($basePath) -replace "\\", "/" }) -join " "
}

## python globals.
# "pip install" can parse a file
function Export-PythonGlobalPackages {
  # pipdeptree.exe -f | Where-Object { $_ -notmatch "^ +" } | ForEach-Object { $_ -replace "==.+" }
  pipx.exe list | Where-Object { $_ -match "package (.*), Python" }
}

function Export-EnvironmentVariables {
  $user = [Environment]::GetEnvironmentVariables("User")
  $machine = [Environment]::GetEnvironmentVariables("Machine")

  ConvertTo-Json ([ordered]@{
      when    = (Get-Date -Format "o")
      user    = $user
      machine = $machine
    }) # > EnvironmentVariables.json
}

function Get-ReadableEnvPath {
  ($env:Path).Split(";")
}

# others????
# XXX how to export settings?
# TODO check if i need to backup something else
