from flask import Flask, render_template, request, jsonify, Response
import requests
import random

app = Flask(__name__)

class Offer:
    def __init__(self, category, name, text):
        self.category = category
        self.name = name
        self.text = text

global listBioTech
global deckBioTech
global listConstruction
global deckConstruction
global listLabor
global deckLabor
global listMedia
global deckMedia
global listSecurity
global deckSecurity
listBioTech = []
deckBioTech = []
listConstruction = []
deckConstruction = []
listLabor = []
deckLabor = []
listMedia = []
deckMedia = []
listSecurity = []
deckSecurity = []

listBioTech.append(Offer(
    "BioTech",
    "Clean Slate",
    "Remove up to 2 illness tokens from the city. Then place 1 outage\
    token in a district where you removed an illness token.\
    Illness tokens do not increase threat during this action."
))
listBioTech.append(Offer(
    "BioTech",
    "Clinical Trials",
    "Remove 1 illness token in any district.\
     Illness tokens do not increase threat during this action."
))
listBioTech.append(Offer(
    "BioTech",
    "Information Procurement",
    "Reduce threat by 2 if the players spend capital equal to or exceeding \
    the number of players in the game. Each playaer can spend any amount \
    of capital, starting with the active player and proceeding clockwise."
))
listBioTech.append(
    Offer("BioTech",
    "Unorthodox Knowledge",
    "Look at the top 3 cards of the event deck. Place 1 card on the bottom \
    of the deck and return the rest to the top of the deck in any order."
))

listConstruction.append(Offer(
    "Construction",
    "Ark Construction",
    "Place 1 development token in any district."
))
listConstruction.append(Offer(
    "Construction",
    "Budget Renovations",
    "Remove up to 2 outage tokens from the city. Then, increase unrest by 1 stage \
    in each district where you removed an outage token."
))
listConstruction.append(Offer(
    "Construction",
    "Gentrification",
    "Remove 1 outage token from any district. Then, place 1 prisec unit in that district \
    if it does not contain a prisec unit. Each enemy unit in that district moves."
))
listConstruction.append(Offer(
    "Construction",
    "Vanity Project",
    "Choose 1 player. That player gains 2 capital, or 4 if they supported this offer. Then, \
    discard 1 asset card belonging to that player, if possible."
))

listLabor.append(Offer(
    "Labor",
    "Efficiency Experts",
    "Move 1 android token to a district that does no contain an android token. Illness \
    tokens do not increase threat during this action."
))
listLabor.append(Offer(
    "Labor",
    "High-Risk Investments",
    "Choose 3 players. Ther first player you choose gains 3 capital, the second player \
    gains 2 capital, the third player gains 1 capital."
))
listLabor.append(Offer(
    "Labor",
    "Labor Solutions",
    "Move up to 3 android tokens to districts that do not contain android tokens. \
    Then, place 1 orgcrime unit in any district."
))
listLabor.append(Offer(
    "Labor",
    "Liquidation",
    "Choose a district that is not in strike or outage. That district immediately produces all of \
    its resources; orgcrime units do no affect this production. Then, increase that district's unrest to strike."
))

listMedia.append(Offer(
    "Media",
    "24/7 Live Feeds",
    "Decrease unrest by 1 stage in any district or remove 1 orgcrime unit."
))
listMedia.append(Offer(
    "Media",
    "Media Circus",
    "Decrease unrest by 2 stages in any district. Then, place 1 Human First unit in any district."
))
listMedia.append(Offer(
    "Media",
    "Puff Piece",
    "Each player may draw 2 action cards of a type of his choice, or 3 if they supported this offer, \
    starting with the active player an proceeding clockwise."
))
listMedia.append(Offer(
    "Media",
    "Spin Doctors",
    "Decrease unrest by 1 stage in up to 2 districts. Then, reduce credits in the supply by 1. \
    If credits are already at '0', increase threat by 1 instead."
))

listSecurity.append(Offer(
    "Security",
    "Arrest Orders",
    "Place 1 prisec unit in any district to remove all other units in that district."
))
listSecurity.append(Offer(
    "Security",
    "Full Deployment",
    "Choose another player and choose whether they draw 5 action cards of at type of your \
    choice or flips their emergency action card faceup."
))
listSecurity.append(Offer(
    "Security",
    "Riot Control",
    "Remove 1 prisec unit from any district to remove up to 2 enemy units from the city. \
    Then, increase unrest by 1 stage in 1 district not in strike or outage."
))
listSecurity.append(Offer(
    "Security",
    "Scorched Earth",
    "Place 1 outage token in any district no in outage to remove all enemy units in that district, \
    and in another district in that tier."
))

@app.route('/')
def hello_whale():
    return render_template("whale_hello.html")

# endpoint for GlobalSec
@app.route('/newangeles/globalsec')
def globalsec():
    return render_template("globalsec.html")

# endpoint for hb
@app.route('/newangeles/hb')
def hb():
    return render_template("hb.html")

# endpoint for jinteki
@app.route('/newangeles/jinteki')
def jinteki():
    return render_template("jinteki.html")

# endpoint for melange
@app.route('/newangeles/melange')
def melange():
    return render_template("melange.html")

# endpoint for nbn
@app.route('/newangeles/nbn')
def nbn():
    return render_template("nbn.html")

# endpoint for weyland
@app.route('/newangeles/weyland')
def weyland():
    return render_template("weyland.html")

# endpoint for BioTech deck
@app.route("/newangeles/decks/biotech", methods=["GET"])
def biotech():
    global listBioTech
    global deckBioTech

    if request.method == 'GET':
        try:
            if len(deckBioTech) > 0:
                card = deckBioTech[0]
                deckBioTech.pop(0)
            else:
                deckBioTech = listBioTech + listBioTech + listBioTech + listBioTech + listBioTech
                random.shuffle(deckBioTech)
                card = deckBioTech[0]
                deckBioTech.pop(0)

        except BaseException as e:
            #return jsonify({'ok': False, 'message': 'oops. could not fetch BioTech'}), 400
            return jsonify({'ok': False, 'message': str(e)}), 400

        return jsonify(category=card.category, name=card.name, text=card.text), 200

# endpoint for Construction deck
@app.route("/newangeles/decks/construction", methods=["GET"])
def construction():
    global listConstruction
    global deckConstruction

    if request.method == 'GET':
        try:
            if len(deckConstruction) > 0:
                card = deckConstruction[0]
                deckConstruction.pop(0)
            else:
                deckConstruction = listConstruction + listConstruction + listConstruction + listConstruction + listConstruction
                random.shuffle(deckConstruction)
                card = deckConstruction[0]
                deckConstruction.pop(0)

        except BaseException as e:
            #return jsonify({'ok': False, 'message': 'oops. could not fetch Construction'}), 400
            return jsonify({'ok': False, 'message': str(e)}), 400

        return jsonify(category=card.category, name=card.name, text=card.text), 200

# endpoint for Labor deck
@app.route("/newangeles/decks/labor", methods=["GET"])
def labor():
    global listLabor
    global deckLabor

    if request.method == 'GET':
        try:
            if len(deckLabor) > 0:
                card = deckLabor [0]
                deckLabor .pop(0)
            else:
                deckLabor  = listLabor + listLabor + listLabor + listLabor + listLabor
                random.shuffle(deckLabor)
                card = deckLabor[0]
                deckLabor.pop(0)

        except BaseException as e:
            #return jsonify({'ok': False, 'message': 'oops. could not fetch Labor'}), 400
            return jsonify({'ok': False, 'message': str(e)}), 400

        return jsonify(category=card.category, name=card.name, text=card.text), 200

# endpoint for Media deck
@app.route("/newangeles/decks/media", methods=["GET"])
def media():
    global listMedia
    global deckMedia

    if request.method == 'GET':
        try:
            if len(deckMedia) > 0:
                card = deckMedia[0]
                deckMedia.pop(0)
            else:
                deckMedia = listMedia + listMedia + listMedia + listMedia + listMedia
                random.shuffle(deckMedia)
                card = deckMedia[0]
                deckMedia.pop(0)

        except BaseException as e:
            #return jsonify({'ok': False, 'message': 'oops. could not fetch BioTech'}), 400
            return jsonify({'ok': False, 'message': str(e)}), 400

        return jsonify(category=card.category, name=card.name, text=card.text), 200

# endpoint for Security deck
@app.route("/newangeles/decks/security", methods=["GET"])
def security():
    global listSecurity
    global deckSecurity

    if request.method == 'GET':
        try:
            if len(deckSecurity) > 0:
                card = deckSecurity[0]
                deckSecurity.pop(0)
            else:
                deckSecurity = listSecurity + listSecurity + listSecurity + listSecurity + listSecurity
                random.shuffle(deckSecurity)
                card = deckSecurity[0]
                deckSecurity.pop(0)

        except BaseException as e:
            #return jsonify({'ok': False, 'message': 'oops. could not fetch BioTech'}), 400
            return jsonify({'ok': False, 'message': str(e)}), 400

        return jsonify(category=card.category, name=card.name, text=card.text), 200

# endpoint for viewing offers
# @app.route("/newangeles/offers", methods=["GET"])
# def offers():
#    global listBioTech
#    global listConstruction
#    global listLabor
#    global listMedia
#    global listSecurity
#
#    if request.method == 'GET':
#        try:
#            offerList
#            offerCategory= request.args.get('category')
#            offerName = requests.get.('offer')
#            if offerCategory == 'biotech':
#                offerList = listBioTech
#            elif offerCategory == 'construction':
#                offerList = listConstruction
#            elif offerCategory == 'labor':
#                offerList = listLabor
#            elif offerCategory == 'media':
#                offerList = listMedia
#            else offerCategory == 'security':
#                offerList = listSecurity
#
#            for i in in offerList:
#                if i.name == offerName:
#                    card = i
#
#        except BaseException as e:
#            return jsonify({'ok': False, 'message': str(e)}), 400
#
#        return jsonify(category=card.category, name=card.name, text=card.text), 200

if __name__ == '__main__':
    
    app.run(debug=True, host='0.0.0.0')