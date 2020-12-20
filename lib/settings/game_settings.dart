import 'package:en_passant/views/components/main_menu/ai_difficulty_picker.dart';
import 'package:en_passant/views/components/main_menu/piece_color_picker.dart';
import 'package:flutter/material.dart';
import 'game_themes.dart';

class GameSettings extends ChangeNotifier {
  int playerCount = 1;
  AIDifficulty aiDifficulty = AIDifficulty.normal;
  PlayerID playerSide = PlayerID.player1;
  Duration timeLimit = Duration.zero;
  int themeIndex = 0;
  GameTheme theme = GameThemes.themeList[0];

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

  void setGameTheme(int index) {
    themeIndex = index;
    theme = GameThemes.themeList[index];
    notifyListeners();
  }
}