# Load SuT
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

Describe "Remove-EmptyFolders" {
  # Arrange
  $testFolder = "$TestDrive/root folder"
  New-Item -ItemType Directory $testFolder

  # create some folders and files

  New-Item -ItemType Directory @(
    "$testFolder/non empty1"
    "$testFolder/nested non empty1/"
    "$testFolder/nested non empty1/non empty2"
  )

  New-Item -ItemType File @(
    "$testFolder/non empty1/a file.ext"
    "$testFolder/nested non empty1/non empty2/another file.ext"
  )

  New-Item -ItemType Directory @(
    "$testFolder/empty1"
    "$testFolder/nested empty 1/empty2"
    "$testFolder/nested non empty1/empty3"
  )

  # Act
  . "$here\$sut" -Confirm:$false $testFolder

  It "does not remove non empty folders" {
    @(
      "$testFolder/non empty1/"
      "$testFolder/nested non empty1/"
      "$testFolder/nested non empty1/non empty2"
    ) | ForEach-Object { Test-Path $_ | Should -Be $true }
  }

  It "removes empty folders" {
    Test-Path @(
      "$testFolder/empty1"
      "$testFolder/nested empty 1/empty2"
      "$testFolder/nested non empty1/empty3"
    ) | ForEach-Object { Test-Path $_ | Should -Be $false }
  }
}
