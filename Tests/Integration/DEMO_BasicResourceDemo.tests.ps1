Describe -Name "BasicResourceDemo integration tests" -Fixture {

    $TempLocation = [string]::Empty
    $MofPath = "$($env:SystemDrive)\Windows\Temp\MOF"

    BeforeEach {
        $TempLocation = Join-Path -Path "$($env:SystemDrive)\Windows\Temp" -ChildPath ([DateTime]::Now).ToString("yyyyMMddhhmmss")
        New-Item -Path $TempLocation -ItemType Directory
    }

    AfterEach {
        Remove-Item -Path $TempLocation -Force -Recurse -Confirm:$false
    }
    
    Context -Name "There is no file present" -Fixture {
        It "Should be able to create a new text file" {
            Configuration IntegrationTest1
            {
                Import-DscResource -ModuleName MOFBasedExampleDsc

                node localhost
                {
                    BasicResourceDemo Example 
                    {
                        Path = (Join-Path -Path $TempLocation -ChildPath "test.txt")
                    }
                }
            }

            IntegrationTest1 -OutputPath $MofPath
            Start-DscConfiguration -Path $MofPath -Wait -Force

            Test-DscConfiguration -Path $MofPath | Should Be $true
        }
    }
}
