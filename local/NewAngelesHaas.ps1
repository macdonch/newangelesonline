# Thomas Haas resolution


function SendGmail($to,$from,$subj,$body,$cred) {
    $smtp = 'smtp.gmail.com'
    $SMTPPort = 587

    Send-MailMessage -From $from -To $to -Subject $subj -Body $body -BodyAsHtml -SmtpServer $smtp -Port $SMTPPort -UseSsl -Credential $cred

}

function UnderBoardEmail($player, $rival, $numberOfPlayers, $cred) {

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
    $body += "<p>Hello $($player.name). You have chosen to use Thomas Haas to view the faction card that is hidden under the board.</p>"
    $body += "<table><tr><td>Your Faction: $($player.faction)</td></tr>"
    $body += "<table><tr><td>Under the Board: $($rival)</td></tr>"
    $body += "<tr><td>Your Win Condition if you Swap: $winCondition</td></tr>"
    $body += "</table>"

    $body += "<br><p>Annouce whether or not you choose to swap.</p>"

    $body += "<br><p>Please keep your rival information secret.</p></html>"
    
    SendGmail $player.email $cred.UserName 'Thomas Haas Action' $body $cred
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
        url="http:\\newangeles.hopto.org\globalsec"
    },
    [Faction]@{
        name="Haas-Bioroid";
        caption="Engineering the Future";
        text="When 1 or more android tokens are moved, gain 2 capital.";
        url="http:\\newangeles.hopto.org\hb"
    },
    [Faction]@{
        name="Jinteki";
        caption="Personal Evolution";
        text="When an illness token is removed from a district, gain 2 capital.";
        url="http:\\newangeles.hopto.org\jinteki"
    },
    [Faction]@{
        name="Melange Mining";
        caption="Powering Change";
        text="When an action card is resolved, if threat does not increase by at least 2, gain 3 capita.";
        url="http:\\newangeles.hopto.org\melange"
    },
    [Faction]@{
        name="NBN";
        caption="Making News";
        text="When unrest decreases, gain 1 capital for each stage decreased.";
        url="http:\\newangeles.hopto.org\nbn"
    },
    [Faction]@{
        name="Weyland Consortium";
        caption="Building a Better World";
        text="When an outage token is removed from a district, gain 2 capital.";
        url="http:\\newangeles.hopto.org\weyland"
    }
)

# global
$filePlayers = "players.txt"
$fileRivals = "rivals.txt"

Write-Host "Thomas Haas Script"
$arrPlayers = import-csv players.txt

$numberOfPlayers = $arrPlayers.length


Do {
    #prompt for the player number to get email
    $playerNumber = Read-Host "Provide Player # for Thomas Haas"

    #prompt for confirmation
    for ($i = 0; $i -lt $arrPlayers.length; $i++) {
        $player = $arrPlayers[$i]
        if ($playerNumber -eq $player.number) {
            Write-Host "Selected player is: $($player.name)"
            $confirm = Read-Host "Is this correct? (y/n)"
            $found = $true
            break
        }
    }

    if ($found -ne $true) {
        Write-Host "Player $playerNumber not found"
    }


} while($confirm -ne 'y')


# create credential for email
$GmailCred = Get-Credential

# get rivals
$arrRivals = import-csv rivals.txt

for ($i = 0; $i -lt $arrRivals.length; $i++) {
    if ($arrRivals[$i].player -eq '99') {
           $hiddenRival = $arrRivals[$i].rival
    }
}

UnderBoardEmail $player $hiddenRival $numberOfPlayers $GmailCred

# did they swap?
do {
    $swap = Read-Host "Swap (y/n)"

    if (($swap -eq 'y') -Or ($swap -eq 'n')) {

        $validEntry = $true

        if ($swap -eq 'y') {
            # swap rival in array
            for ($i = 0; $i -lt $arrRivals.length; $i++) {
                if ($arrRivals[$i].player -eq "$playernumber") {
                       $newHiddenRival = $arrRivals[$i].rival
                       $arrRivals[$i].rival = $hiddenRival
                }
            }
            for ($i = 0; $i -lt $arrRivals.length; $i++) {
                if ($arrRivals[$i].player -eq '99') {
                       $arrRivals[$i].rival = $newHiddenRival
                }
            }
            # create new rivals file
            "player,faction,rival" | Out-File $fileRivals | Out-Null
            # write rivals to file
            for ($i = 0; $i -lt $arrRivals.length; $i++) {
                $entry = $arrRivals[$i]
                "$($entry.player),$($entry.faction),$($entry.rival)" | Out-File $fileRivals -Append| Out-Null
            }
        }

    }

}
While ($validEntry -ne $true)




    