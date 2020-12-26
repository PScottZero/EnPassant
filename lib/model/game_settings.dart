import 'package:en_passant/logic/move_classes.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/views/components/main_menu_view/ai_difficulty_picker.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_themes.dart';

class GameSettings extends ChangeNotifier {
  int playerCount = 1;
  AIDifficulty aiDifficulty = AIDifficulty.normal;
  PlayerID playerSide = PlayerID.player1;
  Duration timeLimit = Duration.zero;
  int themeIndex = 0;
  GameTheme get theme { return GameThemes.themeList[themeIndex]; }
  bool showMoveHistory = true;

  bool gameOver = false;
  PlayerID turn = PlayerID.player1;
  bool initGame = true;
  List<Move> moves = [];
  Duration player1TimeLeft = Duration.zero;
  Duration player2TimeLeft = Duration.zero;

  int get defaultThemeIndex {
    var defaultIndex = 0;
    GameThemes.themeList.asMap().forEach((index, theme) {
      if (theme.name == 'Classic Green') {
        defaultIndex = index;
      }
    });
    return defaultIndex;
  }

  PlayerID get aiTurn {
    return SharedFunctions.oppositePlayer(playerSide);
  }

  bool get isAIsTurn {
    return playingWithAI && (turn == aiTurn);
  }

  bool get playingWithAI {
    return playerCount == 1;
  }

  GameSettings() { 
    loadTheme();
    loadShouldShowMoveHistory();
  }

  void addMove(Move move) {
    moves.add(move);
    notifyListeners();
  }

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
    moves = [];
    player1TimeLeft = timeLimit;
    player2TimeLeft = timeLimit;
  }

  void setPlayerCount(int count) {
    playerCount = count;
    notifyListeners();
  }

  void setAIDifficulty(AIDifficulty difficulty) {
    aiDifficulty = difficulty;
    notifyListeners();
  }

  void setPlayerSize(PlayerID side) {
    playerSide = side;
    notifyListeners();
  }

  void setTimeLimit(Duration duration) {
    timeLimit = duration;
    player1TimeLeft = duration;
    player2TimeLeft = duration;
    notifyListeners();
  }

  void setGameTheme(int index) async {
    themeIndex = index;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('theme', themeIndex);
    notifyListeners();
  }

  void decrementPlayer1Timer() async {
    if (player1TimeLeft.inSeconds > 0 && !gameOver) {
      player1TimeLeft = Duration(seconds: player1TimeLeft.inSeconds - 1);
      notifyListeners();
    }
  }

  void decrementPlayer2Timer() async {
    if (player2TimeLeft.inSeconds > 0 && !gameOver) {
      player2TimeLeft = Duration(seconds: player2TimeLeft.inSeconds - 1);
      notifyListeners();
    }
  }

  void loadShouldShowMoveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    showMoveHistory = prefs.getBool('showMoveHistory') ?? true;
    notifyListeners();
  }

  void shouldShowMoveHistory(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    showMoveHistory = show;
    prefs.setBool('showMoveHistory', show);
    notifyListeners();
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    themeIndex = prefs.getInt('theme') ?? defaultThemeIndex;
    notifyListeners();
  }
}