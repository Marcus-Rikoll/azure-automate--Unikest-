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
        [string]
        $vinner,        
        [object[]]
        $kortStokkMagnus,
        [object[]]
        $kortStokkMeg   

    )
    $megPoeng = sum($meg)
    $magnusPoeng = sum($magnus)

    $blackjack = 21

    if ( $megPoeng -eq $blackjack -and $magnusPoeng -eq $blackjack) {
        #Draw
        Write-Host "Uavgjort" 
    }
    elseif ($megPoeng -eq $blackjack) {
        # Meg Vant
        Write-host "Vinner: Meg"
        Write-Host "Taper: Magnus"
    }       
    elseif ($magnusPoeng -eq $blackjack) {
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

while ((sum -cards $meg) -lt 17) {
    $meg += $kortstokk[0]
    $kortstokk = $kortstokk[1..$cards.Length]
}

if ((sum -cards $meg) -gt $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}

while ((sum -cards $magnus) -le (sum -cards $meg)) {
    $magnus += $kortstokk[0]
    $kortstokk = $kortstokk[1..$cards.Length]
}

### Magnus taper spillet dersom poengsummen er høyere enn 21
if ((sum -cards $magnus) -gt $blackjack) {
    skrivUtResultat -vinner "Meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}


skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg


