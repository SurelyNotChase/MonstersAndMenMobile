// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'dart:math';
import 'data.dart';
import 'package:flame/input.dart';


//display variables
double cardSize = 80;
double cardSpacing = 50;
double playerCardsY = 300;
double opponentCardsY = 100;
double stagger = 2;
double offsetX = 10;
double offsetY = -20;

List<CardButton> playerCardParty = [];
List<CardButton> opponentCardParty = [];
Map currentDefender = {};
double characterSize = 120.0;

var playerPoints;
var opponentPoints;

List<Map<String, dynamic>> getRandomHand() {
  // Create an empty list to hold the random cards
  List<Map<String, dynamic>> randomCards = [];
  // Create a random number generator
  final random = Random();
  // Loop until the list has 5 unique cards
  while (randomCards.length <= 5) {
    // Generate a random index between 0 and the length of the card list
    int index = random.nextInt(cardData.length);
    // Get the Map at the random index
    Map<String, dynamic> map = cardData[index];
    // Check if the Map is already in the list
    if (!randomCards.contains(map)) {
      // If not, add it to the list
      randomCards.add(map);
    }
  }
  return randomCards;
}

class PlayGame extends FlameGame with HasTappables {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    //initial hands
    List playerHand = getRandomHand();
    List opponentHand = getRandomHand();

    //create sprites and add them to the game
    for (var i = 0; i <= 5; i++) {
      var playerCardSprite = CardButton(playerHand[i]['id'], 'player');
      playerCardSprite
        ..sprite = await loadSprite('${playerHand[i]['name']}.png')
        ..size = Vector2(cardSize, cardSize)
        ..x = cardSpacing * i + offsetX
        ..y = playerCardsY + (stagger * i) + offsetY;
      playerCardParty.add(playerCardSprite);
      add(playerCardSprite);

      var opponentCardSprite = CardButton(opponentHand[i]['id'], 'opponent');
      opponentCardSprite
        ..sprite = await loadSprite('${opponentHand[i]['name']}.png')
        ..size = Vector2(cardSize, cardSize)
        ..x = cardSpacing * i + offsetX
        ..y = opponentCardsY + (stagger * i) + offsetY;
      opponentCardParty.add(opponentCardSprite);
      add(opponentCardSprite);
    }
  }
}

class CardButton extends SpriteComponent with Tappable {
  Object? cardID;
  String? owner;

  CardButton(this.cardID, this.owner);

  @override
  bool onTapDown(TapDownInfo info) {
    try {
      attackCard();

      return true;
    } catch (error) {
      return false;
    }
  }

    void attackCard() {
    // Find the attacker card in the cardData list
    Map attacker = cardData.where((card) => card['id'] == cardID).toList()[0];

    // Check if the currentDefender map is null or if its value is 0
    if (!currentDefender['value'] || currentDefender['value'] <= 0) {
      // If so, set the currentDefender to the attacker
      currentDefender = attacker;
    }
    // Check if the attacker's value is greater than the currentDefender's value
    else if (attacker['value'] > currentDefender['value']) {
      // If so, find the defeated card in the player or opponent card party list
      for (CardButton card in playerCardParty) {
        if (card.cardID == currentDefender['id']) {
          // Cast the defeated card to a SpriteComponent and remove it from the game
          (card as SpriteComponent).remove(card);
          currentDefender = attacker;

          // Move the attacking card to the correct position on the screen
          if (owner == 'player') {
            y += 100;
          }
          if (owner == 'opponent') {
            y -= 100;
          }
        }
      }

      for (CardButton card in opponentCardParty) {
        if (card.cardID == currentDefender['id']) {
          // Cast the defeated card to a SpriteComponent and remove it from the game
          (card as SpriteComponent).remove(card);
          currentDefender = attacker;

          // Move the attacking card to the correct position on the screen
          if (owner == 'player') {
            y += 100;
          }
          if (owner == 'opponent') {
            y -= 100;
          }
        }
      }
    }
  }
}
