if ($null -eq (Get-Module xDscResourceDesigner -ListAvailable))
{
    Find-Module -Name xDscResourceDesigner -Repository PSGallery | Install-Module
}

Import-Module -Name xDSCResourceDesigner 

$attributes = @()
$attributes += New-xDscResourceProperty -Name "Path" `
                                        -Type "String" `
                                        -Attribute "Key"
$attributes += New-xDscResourceProperty -Name "Credential" `
                                        -Type "PSCredential" `
                                        -Attribute "Required"
$attributes += New-xDscResourceProperty -Name "Ensure" `
                                        -Type "String" `
                                        -Attribute "Write" `
                                        -ValidateSet "Present", "Absent"

$outputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("..\Modules\GeneratedExamplesDsc")

if ((Test-Path -Path $outputPath -ErrorAction SilentlyContinue) -eq $true)
{
    Remove-Item -Path $outputPath -Recurse -Confirm:$false -Force
}
New-xDscResource -Name GeneratedDSCResource -Property $attributes -Path $outputPath
