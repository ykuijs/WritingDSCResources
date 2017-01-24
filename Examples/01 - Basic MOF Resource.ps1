Configuration DemoConfig
{
    Import-DscResource -ModuleName MOFBasedExampleDsc

    node localhost
    {
        BasicResourceDemo Example 
        {
            Path = "test"
        }
    }
}

DemoConfig -OutputPath "C:\temp\MOF"
Start-DscConfiguration -Path "C:\temp\MOF" -Verbose -Wait -Force
