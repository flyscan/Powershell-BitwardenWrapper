[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param (
  [System.IO.DirectoryInfo]
  $Path = "."
)

Get-ChildItem -Recurse -Directory $Path |
  Where-Object { -not $_.GetFiles("*", "AllDirectories") } | ForEach-Object {
    if ($PSCmdlet.ShouldProcess($_.Name)) {
      Remove-Item -Recurse $_
    }
  }
