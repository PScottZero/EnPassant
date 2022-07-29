import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../logic/chess_game.dart';
import '../logic/player.dart';

const timerAccuracyMilliseconds = 100;

class GameData extends ChangeNotifier {
  late ChessGame game;
  late Timer timer;
  bool gameOver = false;
  bool stalemate = false;
  bool promotionRequested = false;
  bool moveListUpdated = false;
  int playerCount = 1;
  int aiDifficulty = 3;
  Player selectedSide = Player.player1;
  Player playerSide = Player.player1;
  Player turn = Player.player1;
  Duration player1TimeLeft = Duration.zero;
  Duration player2TimeLeft = Duration.zero;
  int timeLimit = 0;
  bool timersPaused = false;

  Player get aiTurn => playerSide.opposite;
  bool get isP1Turn => playerSide == Player.player1;
  bool get isP2Turn => playerSide == Player.player2;
  bool get isAIsTurn => playingWithAI && (turn == aiTurn);
  bool get playingWithAI => playerCount == 1;

  GameData() {
    newGame();
  }

  void newGame({bool notify = true}) {
    game.cancelAIMove();
    timer.cancel();

    gameOver = false;
    stalemate = false;
    timersPaused = false;
    turn = Player.player1;
    player1TimeLeft = Duration(minutes: timeLimit);
    player2TimeLeft = Duration(minutes: timeLimit);

    if (selectedSide.isRandom) {
      playerSide =
          Random.secure().nextInt(2) == 0 ? Player.player1 : Player.player2;
    }

    game = ChessGame();
    timer = Timer.periodic(Duration(milliseconds: timerAccuracyMilliseconds),
        (timer) {
      turn.isP1 ? decrementPlayer1Timer() : decrementPlayer2Timer();
      if ((player1TimeLeft == Duration.zero ||
              player2TimeLeft == Duration.zero) &&
          timeLimit != 0) {
        endGame();
      }
    });
    if (notify) notifyListeners();
  }

  void decrementPlayer1Timer() {
    if (player1TimeLeft.inMilliseconds > 0 && !gameOver && !timersPaused) {
      player1TimeLeft = Duration(
        milliseconds:
            player1TimeLeft.inMilliseconds - timerAccuracyMilliseconds,
      );
      notifyListeners();
    }
  }

  void decrementPlayer2Timer() {
    if (player2TimeLeft.inMilliseconds > 0 && !gameOver && !timersPaused) {
      player2TimeLeft = Duration(
        milliseconds:
            player2TimeLeft.inMilliseconds - timerAccuracyMilliseconds,
      );
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
    turn = turn.opposite;
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

  void jumpToEndOfMoveList() {
    moveListUpdated = true;
    notifyListeners();
  }

  void pauseTimers() => timersPaused = true;

  void resumeTimers() => timersPaused = false;
}
