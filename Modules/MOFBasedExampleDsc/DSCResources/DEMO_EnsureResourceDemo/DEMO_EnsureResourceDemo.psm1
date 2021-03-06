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
        $Ensure = "Present"
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
        $Ensure = "Present"
    )

    Write-Verbose -Message "Setting EnsureResourceDemo for $Path"

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
        $Ensure = "Present"
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
