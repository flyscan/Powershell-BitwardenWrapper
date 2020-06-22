[CmdletBinding()]
param (
  [Parameter(Mandatory)]
  [String]
  $Version
)

$wrapperPath = "gradle/wrapper/gradle-wrapper.jar"

if (-not (Test-Path $wrapperPath )) {
  throw "No wrapper found"
}

$expected = Invoke-RestMethod -Uri "https://services.gradle.org/distributions/gradle-$Version-wrapper.jar.sha256"
$actual = (Get-FileHash $wrapperPath -Algorithm SHA256).Hash.ToLower()
Write-Verbose "expected hash: $expected"
Write-Verbose "actual hash:   $actual"

@{$true = 'OK: Checksum match'; $false = "ERROR: Checksum mismatch!`nExpected: $expected`nActual:   $actual" }[$actual -eq $expected]
