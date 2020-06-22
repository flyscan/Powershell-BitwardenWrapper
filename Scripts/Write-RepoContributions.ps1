
[CmdletBinding()]
param (
  [System.IO.DirectoryInfo]
  $TargetRepo = ".",
  # comma-separated string with folder/file names
  [System.IO.DirectoryInfo[]]
  $Include,
  [System.IO.DirectoryInfo[]]
  $Exclude,
  [Switch]
  $Quiet
)
$repoName = Split-Path -Leaf $TargetRepo
Write-Output "------------------------------------------------"
Write-Output "- $repoName"
Write-Output "------------------------------------------------"
Write-Output ""

$cmdArgs = @(
  if ($Quiet) {
    "--silent-progress"
  }
  "-C" # Detect inter-file line moves and copies
  "-M" # Detect intra-file line moves and copies
  "--ignore-whitespace"
  "--cost"; "cocomo,hours"
  "--branch"; "master"
  if ($Include) {
    "--incl"
    (( $Include | Resolve-Path -Relative ) -join "," -replace "\\", "/" )
  }
  if ($Exclude) {
    "--excl"
    (( $Exclude | Resolve-Path -Relative ) -join "," -replace "\\", "/" )
  }
  $TargetRepo
)
Write-Verbose "git-fame $cmdArgs"
git-fame @cmdArgs

Write-Output ""
