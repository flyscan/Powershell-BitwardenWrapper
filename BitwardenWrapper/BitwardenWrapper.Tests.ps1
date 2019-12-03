# Load SuT
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1'

Import-Module -Force $here/$sut

Describe "BitwardenWrapper" {

  It "should test the module" -Pending {
    # TODO
  }
}

Describe "Test-ContainsSensitiveWords" {

  Context "Edge cases" {

    It "should throw when null parameters are given" {
      { Test-ContainsSensitiveWords -InputString "" -SensitiveWords @() } | Should -Throw
    }

    It "should throw when inputString is null" {
      { Test-ContainsSensitiveWords -InputString "" -SensitiveWords "one", "two" } | Should -Throw
    }

    It "should throw when SensitiveWords is null" {
      { Test-ContainsSensitiveWords -InputString "string" -SensitiveWords @() } | Should -Throw
    }
  }

  Context "Normal Behaviour" {

    It "should return false if input string is not in the array" {
      Test-ContainsSensitiveWords -InputString "one" -SensitiveWords "two", "three" | Should -Be $false
    }

    It "should return true if input string is in the array" {
      Test-ContainsSensitiveWords -InputString "two" -SensitiveWords "one", "two" | Should -Be $true
    }

    It "should return false if input string is a partial match for any of the array items" {
      Test-ContainsSensitiveWords -InputString "on" -SensitiveWords "one", "two" | Should -Be $false
    }

    It "should return true if input string contains any of the array items" {
      Test-ContainsSensitiveWords -InputString "bone" -SensitiveWords "one", "two" | Should -Be $true
    }
  }
}
