Configuration DemoConfig
{
    Import-DscResource -ModuleName MOFBasedExampleDsc

    node localhost
    {
        ComplexTypeDemo Example 
        {
            Path = "C:\temp\example7.txt"
            ComplexObjects = @(
                DEMO_ChildDataType {
                    Username           = "contoso\user1"
                    PermissionLevel    = "Full Control"
                    ActAsSystemAccount = $true
                }
                DEMO_ChildDataType {
                    Username           = "contoso\Group 1"
                    PermissionLevel    = "Full Read"
                    ActAsSystemAccount = $false
                }
            )
        }
    }
}

DemoConfig -OutputPath "C:\temp\MOF"
Start-DscConfiguration -Path "C:\temp\MOF" -Verbose -Wait -Force
