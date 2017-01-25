Describe -Name "EnsureResourceDemo integration tests" -Fixture {

    $TempLocation = [string]::Empty
    $MofPath = "$($env:SystemDrive)\Windows\Temp\MOF"

    BeforeEach {
        $TempLocation = Join-Path -Path "$($env:SystemDrive)\Windows\Temp" -ChildPath ([DateTime]::Now).ToString("yyyyMMddhhmmss")
        New-Item -Path $TempLocation -ItemType Directory
    }

    AfterEach {
        Remove-Item -Path $TempLocation -Force -Recurse -Confirm:$false
    }
    
    Context -Name "There is no file present and there should be" -Fixture {
        It "Should be able to create a new text file" {
            Configuration IntegrationTest1
            {
                Import-DscResource -ModuleName MOFBasedExampleDsc

                node localhost
                {
                    EnsureResourceDemo Example 
                    {
                        Path = (Join-Path -Path $TempLocation -ChildPath "test.txt")
                        Ensure = "Present"
                    }
                }
            }

            IntegrationTest1 -OutputPath $MofPath
            Start-DscConfiguration -Path $MofPath -Wait -Force

            Test-DscConfiguration -Path $MofPath | Should Be $true
        }
    }

    Context -Name "There is a file present and there should not be" -Fixture {
        It "Should be able to delete an existing text file" {
            Configuration IntegrationTest2
            {
                Import-DscResource -ModuleName MOFBasedExampleDsc

                node localhost
                {
                    EnsureResourceDemo Example 
                    {
                        Path = (Join-Path -Path $TempLocation -ChildPath "test.txt")
                        Ensure = "Absent"
                    }
                }
            }

            IntegrationTest2 -OutputPath $MofPath
            Start-DscConfiguration -Path $MofPath -Wait -Force

            Test-DscConfiguration -Path $MofPath | Should Be $true
        }
    }
}
