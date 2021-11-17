[CmdletBinding()]
param (
    [Parameter(HelpMessage = "Et navn", Mandatory = $true)]
    [string]
    $Navn
)

Write-Host "Hei $Navn!"
Write-Host 'God morgen $navn!'