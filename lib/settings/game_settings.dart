import 'package:en_passant/views/components/main_menu/ai_difficulty_picker.dart';
import 'package:en_passant/views/components/main_menu/piece_color_picker.dart';
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

  GameSettings() { getTheme(); }

  void getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    themeIndex = prefs.getInt("theme") ?? 0;
    notifyListeners();
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
    notifyListeners();
  }

  void setGameTheme(int index) async {
    themeIndex = index;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("theme", themeIndex);
    notifyListeners();
  }
}