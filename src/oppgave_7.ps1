[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = 'stop'

$response = Invoke-WebRequest -Uri $UrlKortstokk

$cards = $response.Content | ConvertFrom-Json

function sum {
    
    param (
        [Parameter()]
        [object[]]
        $cards
    )
    
    $sum = 0
    foreach ($card in $cards) {
        $sum += switch ($card.value) {
    
            'J' { 10 } 
            'Q' { 10 }
            'K' { 10 }
            'A' { 11 }
            Default {
                $card.value
     
            }
        }
    }
    $sum
}

function kortstokkPrint {
    param (
        [Parameter()]
        [object[]]
        $cards
    )
    
    $kortstokk = @()
    foreach ($card in $cards) {
        $kortstokk = $kortstokk + ($card.suit[0] + $card.value)
    }

    $kortstokk
}


$meg = $cards[0..1]
$cards = $cards[2..$cards.Length]
$magnus = $cards[0..1]
$cards = $cards[2..$cards.Length]

function skrivUtResultat {
    param (
        [Parameter()]
        [System.Object[]]
        $meg,
        [Parameter()]
        [System.Object[]]
        $magnus

    )
    $megPoeng = sum($meg)
    $magnusPoeng = sum($magnus)

    if ( $megPoeng -eq 21 -and $magnusPoeng -eq 21) {
        #Draw
        Write-Host "Vinner: Uavgjort" 
    }

    elseif ($megPoeng -eq 21) {
        # Meg Vant
        Write-host "Vinner: Meg"
        Write-Host "Taper: Magnus"
       
    }       

    elseif ($magnusPoeng -eq 21) {
        # Magnus Vant
        Write-Host "Vinner: Magnus"
        Write-Host "Taper: Meg"
        
    }
    Write-Host "Meg:  $megPoeng | $(kortstokkPrint($meg))"
    Write-Host "Magnus: $magnusPoeng | $(kortstokkPrint($magnus))"
}

skrivUtResultat -meg $meg -magnus $magnus 

Write-Host "kortstokk: $(kortstokkPrint($cards))"
Write-Host "Poengsum: $(sum($cards))"





