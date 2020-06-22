########################################################################################################################
####################################### Scoop utils
########################################################################################################################

function Get-ScoopSize {
  $cache = Get-ChildItem -Recurse $env:SCOOP/cache |
    Measure-Object -Sum Length |
    Select-Object -ExpandProperty Sum

  $persisted = Get-ChildItem -Recurse $env:SCOOP/persist |
    Measure-Object -Sum Length |
    Select-Object -ExpandProperty Sum

  $installed = Get-ChildItem -Recurse $env:SCOOP/apps |
    Measure-Object -Sum Length |
    Select-Object -ExpandProperty Sum


  [PSCustomObject]@{
    "cache size (MB)"          = [math]::Round($cache / 1MB, 2)
    "persisted data size (MB)" = [math]::Round($persisted / 1MB, 2)
    "installed apps size (GB)" = [math]::Round($installed / 1GB, 2)
  }
}

function Update-ScoopAndCleanAfter {
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
  param ()

  scoop update
  scoop status

  if ($PSCmdlet.ShouldProcess("Update apps")) {
    scoop update *
  }

  Write-Output "Running scoop cleanup..."
  scoop cleanup *

  Write-Output "Clearing cache..."
  scoop cache show
  scoop cache rm *
}

########################################################################################################################
####################################### JSCPD
########################################################################################################################

function Invoke-CopyPasteDetectorDefaultConfig {
  [CmdletBinding()]
  param (
    # path
    [Parameter(Mandatory = $true)]
    [System.IO.DirectoryInfo]
    $Folder
  )

  jscpd --config "$($env:PROJECTS_FOLDER)/_CONFIGS/.jscpd.json" $Folder
}

########################################################################################################################
####################################### File utils
########################################################################################################################

function Test-ContainsBOM {
  [CmdletBinding()]
  [OutputType([bool])]
  param (
    [Parameter(Mandatory, ValueFromPipeline)]
    [System.IO.FileInfo]
    $file
  )

  process {
    $contents = New-Object byte[] 3
    $stream = [System.IO.File]::OpenRead($file.FullName)
    $stream.Read($contents, 0, 3) | Out-Null
    $stream.Close()

    return $contents[0] -eq 0xEF -and $contents[1] -eq 0xBB -and $contents[2] -eq 0xBF
  }
}

function Test-HasCrlfEndings {
  [CmdletBinding()]
  [OutputType([bool])]
  param (
    [Parameter(Mandatory, ValueFromPipeline)]
    [System.IO.FileInfo]
    $file
  )

  process {
    (Get-Content -Raw -LiteralPath $file.FullName) -match "`r`n"
  }
}

function Test-BomHereRecursive {

  Get-ChildItem -File -Recurse |
    Where-Object FullName -NotMatch ".zip" |
    Where-Object FullName -NotMatch ".git" |
    Where-Object FullName -NotMatch ".mypy_cache" |
    Where-Object FullName -NotMatch "node_modules" |
    Where-Object FullName -NotMatch "vendor" |
    Where-Object { -not (Test-ContainsBOM $_) } |
    Select-Object FullName
}
function Find-Duplicates {
  [CmdletBinding()]
  param (
    [Parameter()]
    [String[]]
    $Paths = "."
  )
  python D:/Projects/_LIBRARIES-WHEELS-ETC/find_duplicates.py $Paths
}

function New-TemporaryDirectory {
  $parent = [System.IO.Path]::GetTempPath()
  [string] $name = [System.Guid]::NewGuid()
  New-Item -ItemType Directory -Path (Join-Path $parent $name)
}

function New-FastTemporaryDirectory {
  [string] $name = [System.Guid]::NewGuid()
  New-Item -ItemType Directory -Path ("C:/TEMP-$name")
}

########################################################################################################################
####################################### Hardlinks utils
########################################################################################################################

function New-HardLink {
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
  Param(
    [parameter(position = 0)] [String] $Name,
    [parameter(position = 1)] [Object] $Value
  )

  if ($PSCmdlet.ShouldProcess("Create new HardLink")) {
    New-Item -ItemType HardLink -Name $Name -Value $Value
  }
}

function Find-HardLinks {
  Get-ChildItem . -Recurse -Force |
    Where-Object { $_.LinkType } |
    Select-Object FullName, LinkType, Target
}
