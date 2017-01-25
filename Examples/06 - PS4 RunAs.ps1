$password = ConvertTo-SecureString -String "Pass@word1" -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential `
                         -ArgumentList @("$($env:COMPUTERNAME)\DemoUser", $password)

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
        PS4CredentialDemo Example 
        {
            Path = "C:\temp\example6.txt"
            Ensure = "Present"
            Credential = $RunAsUser
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
