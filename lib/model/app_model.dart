import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game_data.dart';
import 'theme_preferences.dart';

class AppModel extends ChangeNotifier {
  GameData gameData = GameData();
  ThemePreferences themePrefs = ThemePreferences();

  bool showMoveHistory = true;
  bool allowUndoRedo = true;
  bool soundEnabled = true;
  bool showHints = true;
  bool flip = true;

  AppModel() {
    initListeners();
    loadSharedPrefs();
  }

  void initListeners() {
    gameData.addListener(() => notifyListeners());
    themePrefs.addListener(() => notifyListeners());
  }

  void loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    showMoveHistory = prefs.getBool('showMoveHistory') ?? true;
    soundEnabled = prefs.getBool('soundEnabled') ?? true;
    showHints = prefs.getBool('showHints') ?? true;
    flip = prefs.getBool('flip') ?? true;
    allowUndoRedo = prefs.getBool('allowUndoRedo') ?? true;
    notifyListeners();
  }

  void exitChessView() {
    gameData.game.cancelAIMove();
    gameData.timer.cancel();
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

  void update() => notifyListeners();
}
