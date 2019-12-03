# Load SuT
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1'

Import-Module $here/$sut

Describe "BitwardenWrapper" {
  #FIXME fix me
  It "fails" -Pending {
    $true | Should -Be $false
  }
}
