$password = ConvertTo-SecureString -String "Pass@word1" -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential `
                         -ArgumentList @("DemoUser", $password)

Configuration DemoConfig
{
    param(
        [Parameter(Mandatory = $true)]
        [pscredential]
        $RunAsUser
    )

    Import-DscResource -ModuleName MOFBasedExampleDsc

    node localhost
    {
        EnsureResourceDemo Example 
        {
            Path = "C:\temp\example5.txt"
            Ensure = "Present"
            PsDscRunAsCredential = $RunAsUser
        }
    }
}

DemoConfig -OutputPath "C:\temp\MOF" -RunAsUser $credential -ConfigurationData @{
    AllNodes = @(
        @{
            NodeName = "localhost"
            PsDscAllowPlainTextPassword = $true
        }
    )
}
Start-DscConfiguration -Path "C:\temp\MOF" -Verbose -Wait -Force
