import 'package:en_passant/logic/move_classes.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/views/components/main_menu_view/ai_difficulty_picker.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_themes.dart';

class AppModel extends ChangeNotifier {
  int playerCount = 1;
  AIDifficulty aiDifficulty = AIDifficulty.normal;
  PlayerID playerSide = PlayerID.player1;
  Duration timeLimit = Duration.zero;
  String themeName = 'Green';
  AppTheme get theme { return AppThemes.themeList[themeIndex]; }
  bool showMoveHistory = true;
  bool soundEnabled = true;

  bool gameOver = false;
  PlayerID turn = PlayerID.player1;
  bool initGame = true;
  List<Move> moves = [];
  Duration player1TimeLeft = Duration.zero;
  Duration player2TimeLeft = Duration.zero;

  int get themeIndex {
    var themeIndex = 0;
    AppThemes.themeList.asMap().forEach((index, theme) {
      if (theme.name == themeName) {
        themeIndex = index;
      }
    });
    return themeIndex;
  }

  PlayerID get aiTurn { return SharedFunctions.oppositePlayer(playerSide); }

  bool get isAIsTurn { return playingWithAI && (turn == aiTurn); }

  bool get playingWithAI { return playerCount == 1; }

  AppModel() { loadSharedPrefs(); }

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

  void finalizeGameInit() {
    initGame = false;
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

  void setTheme(int index) async {
    themeName = AppThemes.themeList[index].name;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeName', themeName);
    notifyListeners();
  }

  void setShowMoveHistory(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    showMoveHistory = show;
    prefs.setBool('showMoveHistory', show);
    notifyListeners();
  }

  void setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    soundEnabled = enabled;
    prefs.setBool('soundEnabled', enabled);
    notifyListeners();
  }

  void loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    themeName = prefs.getString('themeName') ?? 'Green';
    showMoveHistory = prefs.getBool('showMoveHistory') ?? true;
    soundEnabled = prefs.getBool('soundEnabled') ?? true;
    notifyListeners();
  }
}