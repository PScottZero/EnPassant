import 'dart:math';

import 'package:en_passant/logic/move_calculation/move_classes/move_meta.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_themes.dart';

const TIMER_ACCURACY_MS = 100;
const PIECE_THEMES = [
  'Classic', 'Angular', '8-Bit', 'Letters', 'Video Chess', 'Lewis Chessmen'
];

class AppModel extends ChangeNotifier {
  int playerCount = 1;
  int aiDifficulty = 3;
  Player selectedSide = Player.player1;
  Player playerSide = Player.player1;
  Duration timeLimit = Duration.zero;
  String pieceTheme = 'Classic';
  String themeName = 'Green';
  List<String> get pieceThemes {
    var pieceThemes = List<String>.from(PIECE_THEMES);
    pieceThemes.sort();
    return pieceThemes;
  }
  AppTheme get theme { return AppThemes.themeList[themeIndex]; }
  bool showMoveHistory = true;
  bool allowUndoRedo = true;
  bool soundEnabled = true;
  bool showHints = true;
  bool flip = true;

  bool gameOver = false;
  bool stalemate = false;
  Player turn = Player.player1;
  List<MoveMeta> moveMetaList = [];
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

  int get pieceThemeIndex {
    var pieceThemeIndex = 0;
    pieceThemes.asMap().forEach((index, theme) {
      if (theme == pieceTheme) {
        pieceThemeIndex = index;
      }
    });
    return pieceThemeIndex;
  }

  Player get aiTurn { return oppositePlayer(playerSide); }

  bool get isAIsTurn { return playingWithAI && (turn == aiTurn); }

  bool get playingWithAI { return playerCount == 1; }

  AppModel() { loadSharedPrefs(); }

  void pushMoveMeta(MoveMeta meta) {
    moveMetaList.add(meta);
    notifyListeners();
  }

  void popMoveMeta() {
    moveMetaList.removeLast();
    notifyListeners();
  }

  void endGame() {
    gameOver = true;
    notifyListeners();
  }

  void unendGame() {
    gameOver = false;
    notifyListeners();
  }

  void changeTurn() {
    turn = oppositePlayer(turn);
    notifyListeners();
  }

  void resetGame() {
    gameOver = false;
    stalemate = false;
    turn = Player.player1;
    moveMetaList = [];
    player1TimeLeft = timeLimit;
    player2TimeLeft = timeLimit;
    if (selectedSide == Player.random) {
      playerSide = Random.secure().nextInt(2) == 0 ? Player.player1 : Player.player2;
    }
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

  void setTimeLimit(Duration duration) {
    timeLimit = duration;
    player1TimeLeft = duration;
    player2TimeLeft = duration;
    notifyListeners();
  }

  void decrementPlayer1Timer() async {
    if (player1TimeLeft.inSeconds > 0 && !gameOver) {
      player1TimeLeft = Duration(
        milliseconds: player1TimeLeft.inMilliseconds - TIMER_ACCURACY_MS);
      notifyListeners();
    }
  }

  void decrementPlayer2Timer() async {
    if (player2TimeLeft.inSeconds > 0 && !gameOver) {
      player2TimeLeft = Duration(
        milliseconds: player2TimeLeft.inMilliseconds - TIMER_ACCURACY_MS);
      notifyListeners();
    }
  }

  void setTheme(int index) async {
    themeName = AppThemes.themeList[index].name;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeName', themeName);
    notifyListeners();
  }

  void setPieceTheme(int index) async {
    pieceTheme = pieceThemes[index];
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('pieceTheme', pieceTheme);
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

  void setShowHints(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    showHints = show;
    prefs.setBool('showHints', show);
    notifyListeners();
  }

  void setFlipBoard(bool flip) async {
    final prefs = await SharedPreferences.getInstance();
    this.flip = flip;
    prefs.setBool('flip', flip);
    notifyListeners();
  }

  void setAllowUndoRedo(bool allow) async {
    final prefs = await SharedPreferences.getInstance();
    this.allowUndoRedo = allow;
    prefs.setBool('allowUndoRedo', allow);
    notifyListeners();
  }

  void loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    themeName = prefs.getString('themeName') ?? 'Green';
    pieceTheme = prefs.getString('pieceTheme') ?? 'Classic';
    showMoveHistory = prefs.getBool('showMoveHistory') ?? true;
    soundEnabled = prefs.getBool('soundEnabled') ?? true;
    showHints = prefs.getBool('showHints') ?? true;
    flip = prefs.getBool('flip') ?? true;
    allowUndoRedo = prefs.getBool('allowUndoRedo') ?? true;
    notifyListeners();
  }

  void update() { notifyListeners(); }
}