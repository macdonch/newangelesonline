# distribute Investments and Demand by email

function Show-Menu
{
    param (
        [string]$Title = 'Investments Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' for First Investments."
    Write-Host "2: Press '2' for Second Investments"
    Write-Host "3: Press '3' for Third Investments"
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

class Demand {
    [int]$pk;
    [string]$name;
    [string]$energy;
    [string]$consumables;
    [string]$tech;
    [string]$entertainment;
    [string]$credits;
    [string]$failResult
}

class Quote {
    [string]$quote;
    [string]$source
}

$arrRivals

$arrInvestments = @(
[Investment]@{name="Healthcare Initiative";target="Gain capital based on the number of illness tokens in the city:<table><tr><td>2 illnesses: 3 capital</td></tr><tr><td>3 illnesses: 5 capital</td></tr><tr><td>4+ illnesses: 7 capital</td></tr></table>"},
[Investment]@{name="Power Siphoning";target="Gain capital based on the number of outage tokens in the city:<table><tr><td>1 outage: 3 capital</td></tr><tr><td>2 outages: 5 capital</td></tr><tr><td>3+ outages: 7 capital</td></tr></table>"},
[Investment]@{name="Union Agreement";target="Gain capital based on the number of Human First units in the city:<table><tr><td>2 Human First: 3 capital</td></tr><tr><td>3 Human First: 5 capital</td></tr><tr><td>4+ Human First: 7 capital</td></tr></table>"},
[Investment]@{name="Laundering Scheme";target="Gain capital based on the number of Org Crime units in the city:<table><tr><td>2 Org Crime: 3 capital</td></tr><tr><td>3 Org Crime: 5 capital</td></tr><tr><td>4+ Org Crime: 7 capital</td></tr></table>"},
[Investment]@{name="Militarized Police";target="Gain capital based on the number of PriSec units in the city:<table><tr><td>1 PriSec: 3 capital</td></tr><tr><td>2 PriSec: 6 capital</td></tr><tr><td>3+ PriSec: 8 capital</td></tr></table>"},
[Investment]@{name="Short Sale";target="Gain capital based on the number of resources at 1 or less in the supply:<table><tr><td>1 resource: 3 capital</td></tr><tr><td>2 resources: 5 capital</td></tr><tr><td>3+ resources: 7 capital</td></tr></table>"},
[Investment]@{name="Retail Sector";target="If consumables in the supply meets demand, gain 2 capital and then gain 2 additional capital for each consumable in the supply. You cannot gain more than 6 capital from this card"},
[Investment]@{name="Energy Sector";target="If energy in the supply meets demand, gain 3 capital and then gain 2 additional capital for each energy in the supply. You cannot gain more than 7 capital from this card"},
[Investment]@{name="Banking Sector";target="If credits in the supply meets demand, gain 2 capital and then gain 1 additional capital for each credit in the supply. You cannot gain more than 6 capital from this card"},
[Investment]@{name="Technology Sector";target="If tech in the supply meets demand, gain 3 capital and then gain 1 additional capital for each tech in the supply. You cannot gain more than 6 capital from this card"},
[Investment]@{name="Entertainment Sector";target="If entertainment in the supply meets demand, gain 2 capital and then gain 1 additional capital for each entertainment in the supply. You cannot gain more than 6 capital from this card"},
[Investment]@{name="Populist Dismissal";target="Gain 1 capital for each district in protest or strike"}
)

$arrDemands = @(
    [Demand]@{
        pk=0;
        name="Hosting World's Cup";
        energy="0";
        consumables="1";
        tech="3";
        entertainment="4";
        credits="2";
        failResult="Increase threat by 5."
    },
    [Demand]@{
        pk=1;
        name="Increased Martion Violence";
        energy="1";
        consumables="2";
        tech="0";
        entertainment="2";
        credits="6";
        failResult="Increase threat by 6."
    },
    [Demand]@{
        pk=2;
        name="Network Disruption";
        energy="0";
        consumables="0";
        tech="4";
        entertainment="4";
        credits="3";
        failResult="Increase threat by 7."
    },
    [Demand]@{
        pk=3;
        name="Power Grid Overload";
        energy="2";
        consumables="0";
        tech="1";
        entertainment="2";
        credits="2";
        failResult="Increase threat by 6."
    },
    [Demand]@{
        pk=4;
        name="Recreational Drug Ban";
        energy="0";
        consumables="1";
        tech="0";
        entertainment="6";
        credits="6";
        failResult="Increase threat by 7."
    },
        [Demand]@{
        pk=5;
        name="Refugee Influx";
        energy="0";
        consumables="3";
        tech="1";
        entertainment="3";
        credits="2";
        failResult="Increase threat by 5."
    },
    [Demand]@{
        pk=6;
        name="Retail Shortage";
        energy="1";
        consumables="1";
        tech="0";
        entertainment="5";
        credits="1";
        failResult="Increase threat by 7."
    },
    [Demand]@{
        pk=7;
        name="Space Elevator Malfunction";
        energy="1";
        consumables="0";
        tech="2";
        entertainment="2";
        credits="6";
        failResult="Increase threat by 6."
    },
        [Demand]@{
        pk=8;
        name="Tourism Spike";
        energy="2";
        consumables="0";
        tech="0";
        entertainment="5";
        credits="5";
        failResult="Increase threat by 5."
    }
)

$arrQuotes = @(
[Quote]@{quote="'They see our business as a puzzle because they only see the pieces. We see the whole picture. That is why we succeed.'";source="Chairman Hiro"},
[Quote]@{quote="'What does it do?' Whatever I bloody want it to do.'";source="Director Haas"},
[Quote]@{quote="'It is my job to ensure our creations are the perfect companions and edutainment for tomorrow's consumers.'";source="Jackson Howard"},
[Quote]@{quote="'This is a one-of-a-kind opportunity...'";source="Mark Yale"},
[Quote]@{quote="'I'd like to remind the ladies and gentlemen of the press that several of the buildings damaged in the blast were owned by Weyland Consortium subsidiaries...'";source="Elizabeth Mills"},
[Quote]@{quote="'It's not personal. Urban renewal is a necessity of the modern world. It's always someone's home, yours is no different.'";source="Elizabeth Mills"},
[Quote]@{quote="'We're raising state-of-the-art facilities in close proximity to cozy residential neighborhoods, fantastic ethnic cuisine, and convenient mass transit. This renovation is going to bring high-end jobs, as well as highly skilled workers, and it’s going to improve our quality of life in this city.'";source="Elizabeth Mills"},
[Quote]@{quote="'It is only by taking advantage of our natural resources that humankind can achieve its true potential.'";source="Elizabeth Mills"},
[Quote]@{quote="'The real mission? We’re going to save the human race.'";source="Jack Weyland"},
[Quote]@{quote=“'The stakes have gotten higher than you might have anticipated, Mr. Santiago. We’ll continue to support you as long as this partnership remains profitable, but we strongly recommend that you watch your step.'";source="Mr. Li”},
[Quote]@{quote=“'The corporations do what they do because they have the money and will to shape the future. Profiting from the advances they make is no crime. Who would seek to disrupt such a future?'";source="Caprice Nisei"}
)

$arrPlayers = import-csv players.txt

Show-Menu

$selection = Read-Host "Please make a selection"

$fileDemands = "demands.txt"

switch ($selection)
{
    '1' {
            $round = "First"
            $intRound = 1
            # create demand file
            # shuffle Demand
            $MyShuffledDemand = $arrDemands | Sort-Object {Get-Random}

            # create file
            "order,pk" | Out-File $fileDemands | Out-Null
            # write today's demamd order to file
            for ($i=0; $i -le 2; $i++) {
                "$($i),$($MyShuffledDemand[$i].pk)" | Out-File $fileDemands -Append | Out-Null
            }
            break
        }
    '2' {$round = "Second"; $intRound = 2; break}
    '3' {$round = "Third"; $intRound = 3; break}
    default {Show-Menu}
}

# create credential for email
$GmailCred = Get-Credential

# import demand
$myDemands = import-csv $fileDemands
$demandIndex = ($myDemands[$intRound - 1]).pk

# demand html
$demandHtml = "<table style='border: solid black 1px;border-collapse: collapse'><tr><th style='border: solid black 1px'>Demand</th><th style='border: solid black 1px'>$($arrDemands[$demandIndex].name)</th></tr>"
$demandHtml += "<tr><td style='border: solid black 1px'>Energy</td><td style='border: solid black 1px'>$($arrDemands[$demandIndex].energy)</td></tr>"
$demandHtml += "<tr><td style='border: solid black 1px'>Consumables</td><td style='border: solid black 1px'>$($arrDemands[$demandIndex].consumables)</td></tr>"
$demandHtml += "<tr><td style='border: solid black 1px'>Tech</td><td style='border: solid black 1px'>$($arrDemands[$demandIndex].tech)</td></tr>"
$demandHtml += "<tr><td style='border: solid black 1px'>Entertainment></td><td style='border: solid black 1px'>$($arrDemands[$demandIndex].entertainment)</td></tr>"
$demandHtml += "<tr><td style='border: solid black 1px'>Credits</td><td style='border: solid black 1px'>$($arrDemands[$demandIndex].credits)</td></tr>"
$demandHtml += "<tr><td style='border: solid black 1px'>Fail Result</td><td style='border: solid black 1px'>$($arrDemands[$demandIndex].failResult)</td></tr>"
$demandHtml += "</table>"

# shuffle player
$MyShuffledPlayers = $arrPlayers | Sort-Object{Get-Random} 

# shuffle Investment Deck
$MyShuffledInvestments = $arrInvestments | Sort-Object {Get-Random}

# shuffle Quotes
$MyShuffledQuotes = $arrQuotes| Sort-Object {Get-Random}


$topCard = 0
$topQuote = 0
$Date = Get-Date -Format "dddd MMM dd, yyyy"

Write-Host "Randomizing Demand and Investments"

foreach($player in $MyShuffledPlayers) {
    $html = ''
    $html+= "<html><p>Your randomly generated $($round) Investment for $($Date):</p>"
    $html += "<table style='border: solid black 1px;border-collapse: collapse'><tr><th style='border: solid black 1px'>Name</th><th style='border: solid black 1px'>Title</th></tr>"
    $Card = $MyShuffledInvestments[$topCard]
    $html += "<tr><td style='border: solid black 1px'>$($Card.Name)</td><td style='border: solid black 1px'>$($Card.Target)</td></tr>"
    # increment card
    $topCard++
    $Card = $MyShuffledInvestments[$topCard]
    $html += "<tr><td style='border: solid black 1px'>$($Card.Name)</td><td style='border: solid black 1px'>$($Card.Target)</td></tr>"
    $html += "</table>"

    # add demand
    $html += "<br>"
    $html += $demandHtml

    $Quote = $MyShuffledQuotes[$topQuote];
    $html += "<br>"
    $html += "<p><i>$($Quote.quote)</i> -$($Quote.source)</p>"
    $html += "</html>"
    # increment card
    $topCard++
    $topQuote++

    SendGmail $player.email $GmailCred.UserName "New Angeles $($round) Investment" $html $GmailCred
}

# display demand
Write-Host "--------"
Write-Host "$round Demand: $($arrDemands[$demandIndex].name)"
Write-Host "Energy: $($arrDemands[$demandIndex].energy)"
Write-Host "Consumables: $($arrDemands[$demandIndex].consumables)"
Write-Host "Tech: $($arrDemands[$demandIndex].tech)"
Write-Host "Entertainment $($arrDemands[$demandIndex].entertainment)"
Write-Host "Credits $($arrDemands[$demandIndex].credits)"
Write-Host "Fail Result: $($arrDemands[$demandIndex].failResult)"
Write-Host "--------"

    