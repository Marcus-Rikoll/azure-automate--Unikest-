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

function kortstokkPrint {
    param (
        [Parameter()]
        [object[]]
        $cards
    )
    


    $kortstokk = @()
foreach ($card in $cards) {
    $kortstokk += $kortstokk + ($card.suit[0] + $card.value)
    }

    $kortstokk
}

Write-Host "Kortstokk: $(kortstokkPrint($cards))"
Write-Host "Poengsum: $sum"

$meg = $cards[0..1]
$cards = $cards[2..$cards.Length]
$Magnus = $cards[0..1]
$cards = $cards[2..$cards.Length]

Write-Host "meg $(kortstokkPrint($meg))"
Write-host "Magnus $(kortstokkPrint($Magnus))"
Write-host "Kortstokk: $(kortstokkPrint($cards))"