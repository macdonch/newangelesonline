# Manage Events deck

function Show-Menu
{
    param (
        [string]$Title = 'Investments Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' to create events for the game."
    Write-Host "2: Press '2' flip current event and display next card back"
    Write-Host "3: Press '3' for Unorthodox Predictions"
}



function SendGmail($to,$from,$subj,$body,$cred) {
    $smtp = 'smtp.gmail.com'
    $SMTPPort = 587

    Send-MailMessage -From $from -To $to -Subject $subj -Body $body -BodyAsHtml -SmtpServer $smtp -Port $SMTPPort -UseSsl -Credential $cred
}


class Investment {
    [string]$name;
    [string]$target
}

class Event {
    [int]$pk;
    [string]$name;
    [string]$text;
    [string]$humanFirst;
    [string]$orgCrime;
    [string]$outage;
    [string]$illness;
    [string]$assets;
    [string]$category
}

$arrEvents = @(
    [Event]@{
        pk=0;
        name="Activist Cells Awaken";
        text="Starting with the highest-numbered district, each Human First unit moves twice.";
        humanfirst="La Costa (3)";
        orgCrime="Nihongai (7)";
        outage="";
        illness="Quinde (2)";
        assets=4;
        category="Human First"
    },
    [Event]@{
        pk=1;
        name="Beanstalk Beset By Protesters";
        text="If there is a Human First unit in a tier-3 district, increase threat by 4. Otherwise, starting with the highest-numbered district, each Human First unit moves.";
        humanfirst="Nihongai (7)";
        orgCrime="";
        outage="";
        illness="Rutherford (9), Base de Cayambe (10)";
        assets="3";
        category="Human First"
    },
    [Event]@{
        pk=2;
        name="Human First Starts Riot";
        text="If there is a Human First unit in a tier-2 district, increase threat by 2. Otherwise, starting with the highest-numbered district, each Human First unit moves.";
        humanfirst="Quinde (2)";
        orgCrime="";
        outage="Rabatgorod (5)";
        illness="Guayaquil (1)";
        assets="4";
        category="Human First"
    },
    [Event]@{
        pk=3;
        name="Humanity Labor Hosts Union Heads";
        text="Increase threat by 1 for each Human First unit in the city.";
        humanfirst="Manta (4)";
        orgCrime="";
        outage="";
        illness="Guayaquil (1)";
        assets="3";
        category="Human First"
    },
    [Event]@{
        pk=4;
        name="Beanstalk Owned By Mob?";
        text="If there is an Org Crime unit in a tier-3 district, increase threat by 4. Otherwise, starting with the highest-numbered district, each Org Crime unit moves.";
        humanfirst="La Costa (3)";
        orgCrime="Legunsa Velasco (6)";
        outage="";
        illness="Manta (4)";
        assets="";
        category="Org Crime"
    },
    [Event]@{
        pk=5;
        name="Gang Wars at All-Time High!";
        text="Increase threat by 1 for each Org Crime unit in the city.";
        humanfirst="";
        orgCrime="Base de Cayambe (10)";
        outage="Guayaquil (1)";
        illness="La Costa (3)";
        assets="3";
        category="Org Crime"
    },
    [Event]@{
        pk=6;
        name="Pistoleros Hit Squads Strike!";
        text="If there is an Org Crime unit in a tier-2 district, increase threat by 3. Otherwise, starting with the highest-numbered district, each Org Crime unit moves.";
        humanfirst="Esmeraldas (8)";
        orgCrime="La Costa (3)";
        outage="";
        illness="Quinde (2)";
        assets="w";
        category="Org Crime"
    },
    [Event]@{
        pk=7;
        name="Tri-Maf Leaders Unite!";
        text="Increase threat by 1 for each Org Crime unit in the city.";
        humanfirst="Guayaquil (1), Quinde (2)";
        orgCrime="";
        outage="Nihongai (7)";
        illness="La Costa (3)";
        assets="5";
        category="Org Crime"
    },
    [Event]@{
        pk=8;
        name="Crumbling Infrastructure";
        text="Increase threat by 1 for each district in outage.";
        humanfirst="Nihongai (7)";
        orgCrime="Quinde (2)";
        outage="";
        illness="Rabatgorod (5), Base de Cayambe (10)";
        assets="5";
        category="Outage"
    },
    [Event]@{
        pk=9;
        name="Earthquake Rocks City";
        text="If there are 3 or more districts in outage, increase threat by 5.";
        humanfirst="Esmeraldas (8)";
        orgCrime="";
        outage="Quinde (2)";
        illness="Nihongai (7), Rutherford (9)";
        assets="4";
        category="Outage"
    },
    [Event]@{
        pk=10;
        name="Helium-3 Transport Threatened";
        text="If there is an outage in a tier-3 district, increase threat by 5. Otherwise, if there is an outage in a tier-2 district, increase threat by 3.";
        humanfirst="Rabatgorod (5)";
        orgCrime="";
        outage="";
        illness="Esmeraldas (8)";
        assets="33";
        category="Outage"
    },
    [Event]@{
        pk=11;
        name="Rolling Outages Increase";
        text="Increase threat by 1 for each district in outage.";
        humanfirst="";
        orgCrime="Manta (4)";
        outage="Esmeraldas (8)";
        illness="Rabatgorod (5)";
        assets="3";
        category="Outage"
    },
    [Event]@{
        pk=12;
        name="Average Wage Falls Again";
        text="If ther are 3 or more districts in strike, increase threat by 4.";
        humanfirst="Rutherford (9)";
        orgCrime="Esmeraldas (8)";
        outage="";
        illness="Esmeraldas (8)";
        assets="4";
        category="Protest/Strike"
    },
    [Event]@{
        pk=13;
        name="Report: Record Unemployment";
        text="If there are 6 or more districts in protest or strike, increase threat by 4.";
        humanfirst="Guayaquil (1)";
        orgCrime="Rutherford (9)";
        outage="";
        illness="Legunsa Velasco (6)";
        assets="4";
        category="Protest/Strike"
    },
       [Event]@{
        pk=14;
        name="Social Apps Spark Revolution";
        text="Increase threat by 1 for each district in protest or strike.";
        humanfirst="Legunsa Velasco (6)";
        orgCrime="";
        outage="";
        illness="Manta (4), Legunsa Velasco (6)";
        assets="5";
        category="Protest/Strike"
    },
    [Event]@{
        pk=15;
        name="Welfare Programs Slashed";
        text="Increase threat by 1 for each district in strike.";
        humanfirst="";
        orgCrime="Guayaquil (1), Quinde (2)";
        outage="";
        illness="Base de Cayambe (10), Guayaquil (1)";
        assets="3";
        category="Protest/Strike"
    }
)

# global
$fileEvents = "events.txt"


Show-Menu

$selection = Read-Host "Please make a selection"

switch ($selection)
{
    '1' {
            # create event deck
            # shuffle Events Deck
            $MyShuffledEvents = $arrEvents | Sort-Object {Get-Random}
            # create file
            "order,pk" | Out-File $fileEvents | Out-Null
            # write today's event order to file
            for ($i=0; $i -lt $MyShuffledEvents.length; $i++) {
                "$($i),$($MyShuffledEvents[$i].pk)" | Out-File $fileEvents -Append | Out-Null
            }
            # display first event cardback
            Write-Host "Top Event: $($MyShuffledEvents[0].category)"
            break
        }
    '2' {
            # display current event and next card back
            $arrTodaysEvents = import-csv $fileEvents
            # display current event
            $currentEventIndex = $arrTodaysEvents[0].pk
            $currentEvent = $arrEvents[$currentEventIndex]
            $nextEventIndex = $arrTodaysEvents[1].pk
            $nextEvent = $arrEvents[$nextEventIndex]
            Write-Host "Current Event: $($currentEvent.name)"
            Write-Host "$($currentEvent.text)"
            Write-Host "Human First: $($currentEvent.humanFirst)"
            Write-Host "Org Crime: $($currentEvent.orgCrime)"
            Write-Host "Outage: $($currentEvent.outage)"
            Write-Host "Illness: $($currentEvent.illness)"
            Write-Host "Assets: $($currentEvent.assets)"
            Write-Host ""
            Write-Host "Next Event: $($nextEvent.category)"
            # move top card to bottom
            "order,pk" | Out-File $fileEvents | Out-Null
            for ($i=0; $i -lt $arrTodaysEvents.length - 1; $i++) {
                "$($i),$($arrTodaysEvents[$i + 1].pk)" | Out-File $fileEvents -Append | Out-Null
            }
            "$($arrTodaysEvents.length - 1),$($arrTodaysEvents[0].pk)" | Out-File $fileEvents -Append
            break
        }
    '3' {

            $arrPlayers = import-csv players.txt

            Do {
                #prompt for the player number to get email
                $playerNumber = Read-Host "Provide Player # for Unorthodox Predictions"

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
            
            # start html
            $html = ''
            $html += "<html>"
            $html += "<p>Precognition:</p>"
            $html += "<table style='border: solid black 1px;border-collapse: collapse'><tr><th style='border: solid black 1px'>Order</th><th style='border: solid black 1px'>Event Card</th></tr>"

            # get the top three cards
            for ( $i=0; $i -lt 3; $i++) {
                # get events add to html string
                $arrTodaysEvents = import-csv $fileEvents
                # display current event
                $currentEventIndex = $arrTodaysEvents[$i].pk
                $currentEvent = $arrEvents[$currentEventIndex]
                $hf = $currentEvent.humanFirst -replace ', ', '<br>'
                $oc = $currentEvent.orgCrime  -replace ', ', '<br>'
                $outage = $currentEvent.outage  -replace ', ', '<br>'
                $illness = $currentEvent.illness  -replace ', ', '<br>'
                $html += "<tr><td style='border: solid black 1px'>$($i + 1)</td>"
                $html += "<td style='border: solid black 1px'><table style='border: solid black 1px;border-collapse: collapse'>"
                $html += "<tr><td colspan='2' style='border: solid black 1px'>$($currentEvent.name)</td></tr>"
                $html += "<tr><td colspan='2' style='border: solid black 1px'>$($currentEvent.text)</td></tr>"
                $html += "<tr><td style='border: solid black 1px'>Human First</td><td style='border: solid black 1px'>$hf</td></tr>"
                $html += "<tr><td style='border: solid black 1px'>Org Crime</td><td style='border: solid black 1px'>$oc</td></tr>"
                $html += "<tr><td style='border: solid black 1px'>Outage</td><td style='border: solid black 1px'>$outage</td></tr>"
                $html += "<tr><td style='border: solid black 1px'>Illness</td><td style='border: solid black 1px'>$illness</td></tr>"
                $html += "<tr><td style='border: solid black 1px'>Card Back</td><td style='border: solid black 1px'>$category</td></tr>"
                $html += "<tr><td style='border: solid black 1px'>Assets</td><td style='border: solid black 1px'>$assets</td></tr>"
                $html += "</table></td></tr>"
            }

            $html += "</table>"
            
            $html += "<p>Let the game organizer know which card is going to the bottom, and the order of the other two cards</p>"
            $html += "</html>"

            # send email
            # create credential for email
            $GmailCred = Get-Credential
    
            SendGmail $player.email $GmailCred.UserName 'Unorthodox Predictions' $html $GmailCred

            Do {
                # prompt for changing card order
                $bottomCard = Read-Host "Card to add to bottom (1/2/3)"
                $topCard = Read-Host "Top Card (1/2/3)"

                if ($bottomCard -ne $topCard -and ($bottomCard -eq 1 -or $bottomCard -eq 2 -or $bottomCard -eq 3) -and ($topCard -eq 1 -or $topCard -eq 2 -or $topCard -eq 3)) {
                    $valid = $true
                }
            }
            While ($valid -ne $true)

            $secondCard = 6 - $topCard - $bottomCard
            write-host "Second card: $secondCard"

            # reorder deck
            "order,pk" | Out-File $fileEvents | Out-Null
            #top card
            "0,$($arrTodaysEvents[$topCard - 1].pk)" | Out-File $fileEvents -Append | Out-Null
            #second card
            "1,$($arrTodaysEvents[$secondCard - 1].pk)" | Out-File $fileEvents -Append | Out-Null
            # rest fo the cards
            for ( $i=2; $i -lt $arrTodaysEvents.length - 1; $i++) {
                "$($i),$($arrTodaysEvents[$i + 1].pk)" | Out-File $fileEvents -Append | Out-Null
            }
            # bottom card
            "$($arrTodaysEvents.length - 1),$($arrTodaysEvents[$bottomCard - 1].pk)" | Out-File $fileEvents -Append | Out-Null

            Write-Host "New Top Card: $($arrEvents[$arrTodaysEvents[$topCard - 1].pk].category)"

            break
        }

    default {Show-Menu}
}


    