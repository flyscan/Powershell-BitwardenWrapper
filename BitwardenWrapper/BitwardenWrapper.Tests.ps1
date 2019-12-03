# Load SuT
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1'

Describe "BitwardenWrapper" {
  Import-Module -Force $here/$sut

  It "should have imported the module" {
    { Get-Command Unlock-BitwardenDatabase } | Should -Not -Throw "not recognized as the name of a cmdlet, function, script file, or operable program."
  }
}

Describe "function Test-ContainsSensitiveWords" {
  Import-Module -Force $here/$sut

  Context "Edge cases" {
    $testCases = @(
      @{
        inputString    = ""
        sensitiveWords = @()
      },
      @{
        inputString    = ""
        sensitiveWords = "one", "two"
      },
      @{
        inputString    = "string"
        sensitiveWords = @()
      }
    )

    It "should throw when given <inputString> and <sensitiveWords>" -TestCases $testCases {
      param(
        [String]$inputString,
        [String[]]$sensitiveWords
      )

      { Test-ContainsSensitiveWords -InputString $inputString -SensitiveWords $sensitiveWords } |
        Should -Throw "Cannot bind argument to parameter"
    }
  }

  Context "Normal Behaviour" {

    $testCases = @(
      @{
        inputString    = "one"
        sensitiveWords = "two", "three"
        expectedResult = $false
      },
      @{
        inputString    = "two"
        sensitiveWords = "one", "two"
        expectedResult = $true
      },
      @{
        # false when input string is a partial match
        inputString    = "on"
        sensitiveWords = "one", "two"
        expectedResult = $false
      },
      @{
        # true when input string contains any of the sensitive words
        inputString    = "bone"
        sensitiveWords = "one", "two"
        expectedResult = $true
      }
    )

    It "should be <expectedResult> when given <inputString> and <sensitiveWords>" -TestCases $testCases {
      param(
        [String]$inputString,
        [String[]]$sensitiveWords,
        [bool]$expectedResult
      )

      Test-ContainsSensitiveWords -InputString $inputString -SensitiveWords $sensitiveWords | Should -be $expectedResult
    }
  }
}
