[CmdletBinding()]
param (
  [System.IO.DirectoryInfo]$RootFolder = $env:PROJECTS_FOLDER
)

Get-ChildItem -Force -Recurse $RootFolder -Include ".git" | ForEach-Object {
  $gitDir = $_
  $workTree = Split-Path -Path $_ -Parent

  $dirtyIndex = $null -ne (git.exe --git-dir $gitDir --work-tree $workTree status -s)
  $unpushedCommits = $null -ne (git.exe --git-dir $gitDir --work-tree $workTree log --branches --not --remotes --oneline)
  $forgottenStashes = $null -ne (git.exe --git-dir $gitDir stash list)

  if ($dirtyIndex -or $unpushedCommits -or $forgottenStashes) {
    Write-Output "found local stuff in $workTree"
  }
  else {
    Write-Output "all backed up in     $workTree"
  }
}
