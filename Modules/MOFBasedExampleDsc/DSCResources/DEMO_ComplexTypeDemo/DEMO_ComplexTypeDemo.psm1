function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Path,

        [parameter(Mandatory = $true)] 
        [Microsoft.Management.Infrastructure.CimInstance[]] 
        $ComplexObjects
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
        $Path,

        [parameter(Mandatory = $true)] 
        [Microsoft.Management.Infrastructure.CimInstance[]] 
        $ComplexObjects
    )
    Write-Verbose -Message "Setting BasicResourceDemo for $Path"

    if ($Path -match "[c-z]:\\" -and $Path -match ".txt$") 
    {
        $complexTypeString = ""
        foreach($complexObject in $ComplexObjects)
        {
            $complexTypeString += "Username: $($complexObject.Username), Permission: $($complexObject.PermissionLevel), Act as system: $($complexObject.ActAsSystemAccount)"
            $complexTypeString += [Environment]::NewLine
        }
        $complexTypeString += [Environment]::NewLine

        $complexTypeString + "This file was created by $($env:USERNAME) at $([DateTime]::Now.ToString('hh:mm:ss'))" | Out-File -FilePath $Path
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
        $Path,

        [parameter(Mandatory = $true)] 
        [Microsoft.Management.Infrastructure.CimInstance[]] 
        $ComplexObjects
    )
    Write-Verbose -Message "Testing BasicResourceDemo for $Path"
    return (Test-Path -Path $Path)
}

Export-ModuleMember -Function *-TargetResource
