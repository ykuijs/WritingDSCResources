Import-Module (Join-Path -Path $PSScriptRoot -ChildPath "..\..\Modules\MOFBasedExampleDsc\DSCResources\DEMO_BasicResourceDemo\DEMO_BasicResourceDemo.psm1" -Resolve)

Describe -Name "BasicResourceDemo tests" -Fixture {
    InModuleScope -ModuleName "DEMO_BasicResourceDemo" -ScriptBlock {
        Context "The text file at 'Path' exists" {
            $testParams = @{
                Path = "C:\somepath.txt"
            }

            Mock -CommandName Test-Path -MockWith {
                return $true
            }

            It "Should return a value from the get method" {
                Get-TargetResource @testParams | Should Not BeNullOrEmpty 
            }

            It "Should return true from the test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context "The text file at 'Path' does not exist" {
            $testParams = @{
                Path = "C:\somepath.txt"
            }

            Mock -CommandName Test-Path -MockWith {
                return $false
            }

            Mock -CommandName Out-File -MockWith {}

            It "Should return a value from the get method" {
                Get-TargetResource @testParams | Should Not BeNullOrEmpty 
            }

            It "Should return false from the test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should write the text to a file" {
                Set-TargetResource @testParams 
                Assert-MockCalled -CommandName "Out-File"
            }
        }

        Context "The value for 'Path' is not a valid file path" {
            $testParams = @{
                Path = "Not a valid file path"
            }

            Mock -CommandName Test-Path -MockWith {
                return $false
            }

            It "Should return a value from the get method" {
                Get-TargetResource @testParams | Should Not BeNullOrEmpty 
            }

            It "Should return false from the test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should write the text to a file" {
                { Set-TargetResource @testParams } | Should throw 
            }
        }

        Context "The value for 'Path' has an incorrect file extension" {
            $testParams = @{
                Path = "C:\something.wrong"
            }

            Mock -CommandName Test-Path -MockWith {
                return $false
            }

            It "Should return a value from the get method" {
                Get-TargetResource @testParams | Should Not BeNullOrEmpty 
            }

            It "Should return false from the test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should write the text to a file" {
                { Set-TargetResource @testParams } | Should throw 
            }
        }
    }
}
