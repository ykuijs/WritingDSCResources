using module "..\..\Modules\ClassBasedExampleDsc\DSCResources\BasicClassResourceDemo.psm1"

Describe -Name "BasicClassResourceDemo unit tests" -Fixture {
    InModuleScope -ModuleName "BasicClassResourceDemo" -ScriptBlock {
        Context "The text file at 'Path' exists" {
            $resource = [BasicClassResourceDemo]::new()
            $resource.Path = "C:\somepath.txt"
            
            Mock -CommandName Test-Path -MockWith {
                return $true
            }

            It "Should return a value from the get method" {
                $resource.Get() | Should Not BeNullOrEmpty 
            }

            It "Should return true from the test method" {
                $resource.Test() | Should Be $true
            }
        }

        Context "The text file at 'Path' does not exist" {
            $resource = [BasicClassResourceDemo]::new()
            $resource.Path = "C:\somepath.txt"

            Mock -CommandName Test-Path -MockWith {
                return $false
            }

            Mock -CommandName Out-File -MockWith {}

            It "Should return a value from the get method" {
                $resource.Get() | Should Not BeNullOrEmpty 
            }

            It "Should return false from the test method" {
                $resource.Test() | Should Be $false
            }

            It "Should write the text to a file" {
                $resource.Set()
                Assert-MockCalled -CommandName "Out-File"
            }
        }

        Context "The value for 'Path' is not a valid file path" {
            $resource = [BasicClassResourceDemo]::new()
            $resource.Path = "Not a valid file path"

            Mock -CommandName Test-Path -MockWith {
                return $false
            }

            It "Should return a value from the get method" {
                $resource.Get() | Should Not BeNullOrEmpty 
            }

            It "Should return false from the test method" {
                $resource.Test() | Should Be $false
            }

            It "Should write the text to a file" {
                { $resource.Set()} | Should throw 
            }
        }

        Context "The value for 'Path' has an incorrect file extension" {
            $resource = [BasicClassResourceDemo]::new()
            $resource.Path = "C:\something.wrong"

            Mock -CommandName Test-Path -MockWith {
                return $false
            }

            It "Should return a value from the get method" {
                $resource.Get() | Should Not BeNullOrEmpty 
            }

            It "Should return false from the test method" {
                $resource.Test() | Should Be $false
            }

            It "Should write the text to a file" {
                { $resource.Set()} | Should throw 
            }
        }
    }
}
