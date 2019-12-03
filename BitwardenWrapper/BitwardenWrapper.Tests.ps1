# Load SuT
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1'

Import-Module -Force $here/$sut

Describe "BitwardenWrapper" {

  It "should test the module" -Pending {
    # TODO
  }
}

Describe "Test-HasSensitiveWords" {

  Context "Edge cases" {

    It "should throw when null parameters are given" {
      { Test-HasSensitiveWords -InputString "" -SensitiveWords @() } | Should -Throw
    }

    It "should throw when inputstring is null" {
      { Test-HasSensitiveWords -InputString "" -SensitiveWords "one", "two" } | Should -Throw
    }

    It "should throw when SensitiveWords is null" {
      { Test-HasSensitiveWords -InputString "string" -SensitiveWords @() } | Should -Throw
    }
  }

  Context "Normal Behaviour" {

    It "returns false if input string is not in the array" {
      Test-HasSensitiveWords -InputString "one" -SensitiveWords "two", "three" | Should -Be $false
    }

    It "returns true if input string is in the array" {
      Test-HasSensitiveWords -InputString "one" -SensitiveWords "one", "two" | Should -Be $true
    }

    It "returns false if input string is a partial match for any of the array items" {
      Test-HasSensitiveWords -InputString "on" -SensitiveWords "one", "two" | Should -Be $false
    }

    It "returns true if input string contains any of the array items" {
      Test-HasSensitiveWords -InputString "bone" -SensitiveWords "one", "two" | Should -Be $true
    }
  }
}
