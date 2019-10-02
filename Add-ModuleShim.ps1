function Add-ModuleShim {
  [CmdletBinding()]
  param (
    [System.IO.DirectoryInfo]
    $ModuleFolder
  )

  $ModuleName = $ModuleFolder.Name

  $ShimPath = Join-Path "$HOME/Documents/PowerShell/Modules/" $ModuleName

  New-Item -ItemType Junction -Path $ShimPath -Value $ModuleFolder -Confirm
}
