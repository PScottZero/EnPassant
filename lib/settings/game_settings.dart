import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/views/components/main_menu_view/piece_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_themes.dart';

class GameSettings extends ChangeNotifier {
  int playerCount = 1;
  int aiDifficulty = 2;
  PlayerID playerSide = PlayerID.player1;
  Duration timeLimit = Duration.zero;
  int themeIndex = 0;
  GameTheme get theme { return GameThemes.themeList[themeIndex]; }

  bool gameOver = false;
  PlayerID turn = PlayerID.player1;
  bool initGame = true;

  PlayerID get aiTurn {
    return SharedFunctions.oppositePlayer(playerSide);
  }

  bool get isAIsTurn {
    return playingWithAI && (turn == aiTurn);
  }

  bool get playingWithAI {
    return playerCount == 1;
  }

  GameSettings() { getTheme(); }

  void endGame() {
    gameOver = true;
    notifyListeners();
  }

  void changeTurn() {
    turn = SharedFunctions.oppositePlayer(turn);
    notifyListeners();
  }

  void resetGame() {
    gameOver = false;
    turn = PlayerID.player1;
    initGame = true;
  }

  void getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    themeIndex = prefs.getInt("theme") ?? 0;
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

  void setPlayerSize(PlayerID side) {
    playerSide = side;
    notifyListeners();
  }

  void setTimeLimit(Duration duration) {
    timeLimit = duration;
    notifyListeners();
  }

  void setGameTheme(int index) async {
    themeIndex = index;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("theme", themeIndex);
    notifyListeners();
  }
}