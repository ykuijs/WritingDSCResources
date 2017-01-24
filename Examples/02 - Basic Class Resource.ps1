Configuration DemoConfig
{
    Import-DscResource -ModuleName ClassBasedExampleDsc

    node localhost
    {
        BasicClassResourceDemo Example 
        {
            Path = "C:\temp\example2.txt"
        }
    }
}

DemoConfig -OutputPath "C:\temp\MOF"
Start-DscConfiguration -Path "C:\temp\MOF" -Verbose -Wait -Force
