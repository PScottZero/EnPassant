import 'dart:async';
import 'dart:math';

import 'package:en_passant/logic/chess_game.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:flutter/cupertino.dart';

import 'app_model.dart';

const TIMER_ACCURACY_MS = 100;

class GameData extends ChangeNotifier {
  ChessGame game;
  Timer timer;
  bool gameOver = false;
  bool stalemate = false;
  bool promotionRequested = false;
  int playerCount = 1;
  int aiDifficulty = 3;
  Player selectedSide = Player.player1;
  Player playerSide = Player.player1;
  Player turn = Player.player1;
  Duration player1TimeLeft = Duration.zero;
  Duration player2TimeLeft = Duration.zero;
  int timeLimit = 0;

  Player get aiTurn {
    return oppositePlayer(playerSide);
  }

  bool get isAIsTurn {
    return playingWithAI && (turn == aiTurn);
  }

  bool get playingWithAI {
    return playerCount == 1;
  }

  void newGame(AppModel model, BuildContext context, {bool notify = true}) {
    if (game != null) {
      game.cancelAIMove();
    }
    if (timer != null) {
      timer.cancel();
    }
    gameOver = false;
    stalemate = false;
    turn = Player.player1;
    player1TimeLeft = Duration(minutes: timeLimit);
    player2TimeLeft = Duration(minutes: timeLimit);
    if (selectedSide == Player.random) {
      playerSide =
          Random.secure().nextInt(2) == 0 ? Player.player1 : Player.player2;
    }
    game = ChessGame(model, context);
    timer = Timer.periodic(Duration(milliseconds: TIMER_ACCURACY_MS), (timer) {
      turn == Player.player1
          ? decrementPlayer1Timer()
          : decrementPlayer2Timer();
      if ((player1TimeLeft == Duration.zero ||
              player2TimeLeft == Duration.zero) &&
          timeLimit != 0) {
        endGame();
      }
    });
    if (notify) {
      notifyListeners();
    }
  }

  void decrementPlayer1Timer() {
    if (player1TimeLeft.inMilliseconds > 0 && !gameOver) {
      player1TimeLeft = Duration(
          milliseconds: player1TimeLeft.inMilliseconds - TIMER_ACCURACY_MS);
      notifyListeners();
    }
  }

  void decrementPlayer2Timer() {
    if (player2TimeLeft.inMilliseconds > 0 && !gameOver) {
      player2TimeLeft = Duration(
          milliseconds: player2TimeLeft.inMilliseconds - TIMER_ACCURACY_MS);
      notifyListeners();
    }
  }

  void endGame() {
    gameOver = true;
    notifyListeners();
  }

  void undoEndGame() {
    gameOver = false;
    notifyListeners();
  }

  void changeTurn() {
    turn = oppositePlayer(turn);
    notifyListeners();
  }

  void requestPromotion() {
    promotionRequested = true;
    notifyListeners();
  }

  void setPlayerCount(int count) {
    playerCount = count;
    notifyListeners();
  }

  void setAIDifficulty(int difficulty) {
    aiDifficulty = difficulty;
    notifyListeners();
  }

  void setPlayerSide(Player side) {
    selectedSide = side;
    if (side != Player.random) {
      playerSide = side;
    }
    notifyListeners();
  }

  void setTimeLimit(int duration) {
    timeLimit = duration;
    player1TimeLeft = Duration(minutes: timeLimit);
    player2TimeLeft = Duration(minutes: timeLimit);
    notifyListeners();
  }
}
