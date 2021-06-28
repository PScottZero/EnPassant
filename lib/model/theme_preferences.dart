import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_themes.dart';

const PIECE_THEMES = [
  'Classic',
  'Angular',
  '8-Bit',
  'Letters',
  'Video Chess',
  'Lewis Chessmen',
  'Mexico City'
];

class ThemePreferences extends ChangeNotifier {
  String pieceTheme = 'Classic';
  String themeName = 'Green';

  ThemePreferences() {
    loadThemeSharedPreferences();
  }

  List<String> get pieceThemes {
    var pieceThemes = List<String>.from(PIECE_THEMES);
    pieceThemes.sort();
    return pieceThemes;
  }

  AppTheme get theme {
    return themeList[themeIndex];
  }

  int get themeIndex {
    var themeIndex = 0;
    themeList.asMap().forEach((index, theme) {
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

  void setTheme(int index) async {
    themeName = themeList[index].name;
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

  void loadThemeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    themeName = prefs.getString('themeName') ?? 'Green';
    pieceTheme = prefs.getString('pieceTheme') ?? 'Classic';
    notifyListeners();
  }
}
