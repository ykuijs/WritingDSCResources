function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Path
    )
    Write-Verbose -Message "Getting BasicResourceDemo for $Path"
    return @{
        Path = $Path
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Path
    )
    Write-Verbose -Message "Setting BasicResourceDemo for $Path"

    if ($Path -match "[c-z]:\\" -and $Path -match ".txt$") 
    {
        "This file was created by $($env:USERNAME) at $([DateTime]::Now.ToString('hh:mm:ss'))" | Out-File -FilePath $Path
    } 
    else 
    {
        throw "A full and valid file path ending in '.txt' must be specified"
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Path
    )
    Write-Verbose -Message "Testing BasicResourceDemo for $Path"
    return (Test-Path -Path $Path)
}

Export-ModuleMember -Function *-TargetResource
