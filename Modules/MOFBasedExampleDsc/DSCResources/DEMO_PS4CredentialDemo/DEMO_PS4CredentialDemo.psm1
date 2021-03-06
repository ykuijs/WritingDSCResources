function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Getting EnsureResourceDemo for $Path"
    if (Test-Path -Path $Path)
    {
        $localEnsure = "Present"
    }
    else 
    {
        $localEnsure = "Absent"
    }

    return @{
        Path = $Path
        Ensure = $localEnsure
    }
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Setting EnsureResourceDemo for $Path"

    $session = New-PSSession -ComputerName $env:COMPUTERNAME `
                             -Credential $Credential `
                             -Authentication CredSSP

    Invoke-Command -Session $session -ArgumentList @($Path, $Ensure) -ScriptBlock {
        $Path = $args[0]
        $Ensure = $args[1]

        Write-Verbose -Message "I will not be seen in the logs"

        if ($Path -notmatch "[c-z]:\\" -and $Path -notmatch ".txt$") 
        {
            throw "A full and valid file path ending in '.txt' must be specified"
        }

        if ($Ensure -eq "Present")
        {
            "This file was created by $($env:USERNAME) at $([DateTime]::Now.ToString('hh:mm:ss'))" | Out-File -FilePath $Path
        }
        else 
        {
            Remove-Item -Path $Path -Force -Confirm:$false
        }
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Testing EnsureResourceDemo for $Path"

    $currentState = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq $currentState.Ensure) 
    {
        return $true
    }
    else 
    {
        return $false    
    }
}

Export-ModuleMember -Function *-TargetResource
