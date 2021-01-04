# Set players, factions, rivals


function SendGmail($to,$from,$subj,$body,$cred) {
    $smtp = 'smtp.gmail.com'
    $SMTPPort = 587

    Send-MailMessage -From $from -To $to -Subject $subj -Body $body -BodyAsHtml -SmtpServer $smtp -Port $SMTPPort -UseSsl -Credential $cred

}

function RivalEmail($player, $rival, $numberOfPlayers, $cred) {

    switch ("$rival") {

        "$($player.faction)" {
                    if ($numberOfPlayers -eq 4) {
                        $winCondition = "You have your own rival card. You must have more capital than two other players."
                    } else {
                        $winCondition = "You have your own rival card. You must have more capital than three other players."
                    }
                }

        "Federalist" {$winCondition = "You are the federalist. You do not win normally. Instead, you must have at least 25 capital when threat reaches 25."}

        default {$winCondition = "You must have more capital than $rival."}
    }


    $body = "<html>"
    $body += "<p>Hello $($player.name)</p>"
    $body += "<table><tr><td>Your Faction: $($player.faction)</td></tr>"
    $body += "<tr><td>Your Win Condition: $winCondition</td></tr>"
    $body += "<tr><td>Your Tracking Site: <a href='$($player.url)'>$($player.url)</a></td></tr>"
    $body += "</table>"

    $body += "<br><p>Please keep your rival information secret.</p></html>"
    
    SendGmail $player.email $cred.UserName 'New Angeles Rival' $body $cred
}

class Player {
    [string]$number;
    [string]$name;
    [string]$email;
    [string]$faction;
    [string]$url
}

class Faction {
    [string]$name;
    [string]$caption;
    [string]$text;
    [string]$url
}


$arrFactions = @(
    [Faction]@{
        name="GlobalSec";
        caption="The Conflict Solution";
        text="When an enemy unit is removed from a district, gain 1 capital.";
        url="http:\\newangeles.hopto.org\newangeles\globalsec"
    },
    [Faction]@{
        name="Haas-Bioroid";
        caption="Engineering the Future";
        text="When 1 or more android tokens are moved, gain 2 capital.";
        url="http:\\newangeles.hopto.org\newangeles\hb"
    },
    [Faction]@{
        name="Jinteki";
        caption="Personal Evolution";
        text="When an illness token is removed from a district, gain 2 capital.";
        url="http:\\newangeles.hopto.org\newangeles\jinteki"
    },
    [Faction]@{
        name="Melange Mining";
        caption="Powering Change";
        text="When an action card is resolved, if threat does not increase by at least 2, gain 3 capita.";
        url="http:\\newangeles.hopto.org\newangeles\melange"
    },
    [Faction]@{
        name="NBN";
        caption="Making News";
        text="When unrest decreases, gain 1 capital for each stage decreased.";
        url="http:\\newangeles.hopto.org\newangeles\nbn"
    },
    [Faction]@{
        name="Weyland Consortium";
        caption="Building a Better World";
        text="When an outage token is removed from a district, gain 2 capital.";
        url="http:\\newangeles.hopto.org\newangeles\weyland"
    }
)

# global
$filePlayers = "players.txt"
$fileRivals = "rivals.txt"

Write-Host "New Angeles Setup"
do {
    $numberOfPlayers = Read-Host "Enter the number of players (4/5/6)"
    if ($numberOfPlayers -ge 4 -and $numberOfPlayers -le 6) {
        $validPlayerCount = $true
    } else {
        $validPlayerCount = $false
    }
}
While ($validPlayerCount = $false)

$arrPlayers = @()

for ($i = 1; $i -le $numberOfPlayers; $i++) {
    $player = [Player]::New()
    $player.name = Read-Host "Player $i Name"
    $player.email = Read-Host "Player $i email"
    $arrPlayers += $player
}

Write-Host "Randomizing Faction Choice Order..."
$randomPlayerOrder = $arrPlayers | Sort-Object {Get-Random}

$arrPlayers = @()
$arrFactionsInPlay = @()

for ($i = 0; $i -lt $randomPlayerOrder.length; $i++) {
    $validFaction = $false
    do {
        $player = $randomPlayerOrder[$i]
        $faction = Read-Host "Player $($player.name) picks a faction (g/h/j/m/n/w)"
        if ($faction -match 'g|h|j|m|n|w') {
            $validFaction = $true
        } else {
            Write-Host "Try harder"
        }
    }
    while ($validFaction -ne $true)

    switch ($faction) {
        'g' {$player.faction = ($arrFactions[0]).name; $player.url = ($arrFactions[0]).url}
        'h' {$player.faction = ($arrFactions[1]).name; $player.url = ($arrFactions[1]).url}
        'j' {$player.faction = ($arrFactions[2]).name; $player.url = ($arrFactions[2]).url}
        'm' {$player.faction = ($arrFactions[3]).name; $player.url = ($arrFactions[3]).url}
        'n' {$player.faction = ($arrFactions[4]).name; $player.url = ($arrFactions[4]).url}
        'w' {$player.faction = ($arrFactions[5]).name; $player.url = ($arrFactions[5]).url}
    }

    $player.number = "$($i + 1)"
    $arrFactionsInPlay += $player.faction
    $arrPlayers += $player
}


Write-Host "Randominzing Play Order and Rivals..."

# create credential for email
$GmailCred = Get-Credential

#assign rival
$arrFactionsInPlay += "Federalist"
$randomRivalOrder = $arrFactionsInPlay | Sort-Object {Get-Random}

#randomize players to assign order and rival
$randomPlayerOrder = $arrPlayers | Sort-Object {Get-Random}
$arrPlayers = @()

# create players file
"number,name,email,faction" | Out-File $filePlayers | Out-Null

# create rivals file
"player,faction,rival" | Out-File $fileRivals | Out-Null

for ($i = 0; $i -lt $randomPlayerOrder.length; $i++) {
    $player = $randomPlayerOrder[$i]
    #renumber players
    $player.number = "$($i + 1)"
    $arrPlayers += $player
    Write-Host "Player $($player.number): $($player.name) - $($player.faction)"
    # write player to file
    "$($player.number),$($player.name),$($player.email),$($player.faction)" | Out-File $filePlayers -Append | Out-Null
    # get rival
    $rival = $randomRivalOrder[$i]
    # write rival to file
    "$($player.number),$($player.faction),$rival" | Out-File $fileRivals -Append| Out-Null
    # mail result to player
    RivalEmail $player $rival $numberOfPlayers $GmailCred
}

# add under the board faction to rivals
"99,underboard,$($randomRivalOrder[-1])" | Out-File $fileRivals -Append | Out-Null



    