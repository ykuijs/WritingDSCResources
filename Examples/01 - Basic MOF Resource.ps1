Configuration DemoConfig
{
    Import-DscResource -ModuleName MOFBasedExampleDsc

    node localhost
    {
        BasicResourceDemo Example 
        {
            Path = "C:\temp\example1.txt"
        }
    }
}

DemoConfig -OutputPath "C:\temp\MOF"
Start-DscConfiguration -Path "C:\temp\MOF" -Verbose -Wait -Force
