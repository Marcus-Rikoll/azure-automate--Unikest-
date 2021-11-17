[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = 'stop'

$response = Invoke-WebRequest -Uri $UrlKortstokk

$cards = $response.Content | ConvertFrom-Json

$sum = 0
foreach ($card in $cards) {
    $sum += switch ($card.value) {
        'J' {10} 
        'Q' {10}
        'K' {10}
        'A' {11}
        Default { $card.value }

    }
}

    $kortstokk = @()
foreach ($card in $cards) {
    $kortstokk += $kortstokk + ($card.suit[0] + $card.value)
}

Write-Host "Kortstokk: $kortstokk"
Write-Host "Poengsum: $sum"