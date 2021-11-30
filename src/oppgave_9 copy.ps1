[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = 'stop'

$response = Invoke-WebRequest -Uri $UrlKortstokk

$kortstokk = $response.Content | ConvertFrom-Json

function sum {
    param (
        [Parameter()]
        [object[]]
        $kortstokk
    )
    $sum = 0
    foreach ($kort in $kortstokk) {
        $sum += switch ($kort.value) {
            'J' { 10 } 
            'Q' { 10 }
            'K' { 10 }
            'A' { 11 }
            Default {
                $kort.value
            }
        }
    }
    $sum
}
function kortstokkPrint {
    param (
        [Parameter()]
        [object[]]
        $kortstokk
    )

    $kortstokk = @()
    foreach ($kort in $kortstokk) {
        $kortstokk = $kortstokk + ($kort.suit[0] + $kort.value)
    }
    $kortstokk
}
$meg = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Length]
$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Length]

function skrivUtResultat {
    param (
        [string]
        $vinner,        
        [object[]]
        $kortStokkMagnus,
        [object[]]
        $kortStokkMeg   

    )
    $kortStokkMeg =sum($meg)

    Write-Output "Vinner: $vinner"
    Write-Output "magnus | $(sum -kortstokk $magnus) | $(kortstokkPrint -kortstokk $kortStokkMagnus)"    
    Write-Output "meg    | $(sum -kortstokk $meg) | $(kortstokkPrint -kortstokk $kortStokkMeg)"
}

# bruker 'blackjack' som et begrep - er 21
$blackjack = 21

if ((sum -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif ((sum -kortstokk $magnus) -eq $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}

# Hva er om begge har blackjack? Kanskje det kalles draw?
# frivillig - kan du endre koden til å ta hensyn til draw?


while ((sum -kortstokk $meg) -lt 17) {
    $meg += $kortstokk[0]
    $kortstokk = $kortstokk[1..$kortstokk.Length]
}

if ((sum -kortstokk $magnus) -gt $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}

while ((sum -kortstokk $magnus) -le (sum -kortstokk $meg)) {
    $magnus += $kortstokk[0]
    $kortstokk = $kortstokk[1..$kortstokk.Length]
}

### Magnus taper spillet dersom poengsummen er høyere enn 21
if ((sum -kortstokk $magnus) -gt $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg


