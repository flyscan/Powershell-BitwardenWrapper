[CmdletBinding()]
param (
  # Folder to search for dirty repositories
  [System.IO.DirectoryInfo]
  $RootFolder = $env:PROJECTS_FOLDER,
  [string]
  $SaveToVariable
)

$forEachArguments = @{
  OutVariable = if ($SaveToVariable) {
    "OutVariable"
  }
  else {
    $null
  }
}

Get-ChildItem -Force -Recurse $RootFolder -Include ".git" |
  ForEach-Object {
    $gitDir = $_
    $workTree = Split-Path -Path $_ -Parent

    $dirtyIndex = $null -ne (git.exe --git-dir $gitDir --work-tree $workTree status -s)
    $unpushedCommits = $null -ne (git.exe --git-dir $gitDir --work-tree $workTree log --branches --not --remotes --oneline)
    $forgottenStashes = $null -ne (git.exe --git-dir $gitDir stash list)

    [pscustomobject]@{
      PSTypename          = "GitRepo"
      Repo                = $workTree
      AllGood             = -not ($dirtyIndex -or $unpushedCommits -or $forgottenStashes)
      "Changes to commit" = $dirtyIndex
      "Commits to push"   = $unpushedCommits
      "Stashes to clear"  = $forgottenStashes
    }
  } @forEachArguments |
  Format-Table

if ($SaveToVariable) {
  Write-Verbose "setting variable $SaveToVariable in parent scope"
  Set-Variable -Scope 1 -Name $SaveToVariable -Value $OutVariable
}
