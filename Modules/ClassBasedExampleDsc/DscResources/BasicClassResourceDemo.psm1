[DscResource()]
class BasicClassResourceDemo
{
    [DscProperty(Key)]
    [string]
    $Path

    [BasicClassResourceDemo]Get()
    {
        Write-Verbose -Message "Getting BasicClassResourceDemo for $($this.Path)"
        return $this
    }

    [void] Set()
    {
        Write-Verbose -Message "Setting BasicClassResourceDemo for $($this.Path)"

        if ($this.Path -match "[c-z]:\\" -and $this.Path -match ".txt$") 
        {
            "This file was created by $($env:USERNAME) at $([DateTime]::Now.ToString('hh:mm:ss'))" | Out-File -FilePath $this.Path
        } 
        else 
        {
            throw "A full and valid file path ending in '.txt' must be specified"
        }
    }

    [bool] Test()
    {
        Write-Verbose -Message "Testing BasicClassResourceDemo for $($this.Path)"
        return (Test-Path -Path $this.Path)
    }
}
