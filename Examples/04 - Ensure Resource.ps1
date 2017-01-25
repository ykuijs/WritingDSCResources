Configuration DemoConfig
{
    Import-DscResource -ModuleName MOFBasedExampleDsc

    node localhost
    {
        EnsureResourceDemo Example 
        {
            Path = "C:\temp\example4.txt"
            Ensure = "Present"
        }
    }
}

DemoConfig -OutputPath "C:\temp\MOF"
Start-DscConfiguration -Path "C:\temp\MOF" -Verbose -Wait -Force
