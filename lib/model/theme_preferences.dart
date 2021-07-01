import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_themes.dart';

const DEFAULT_APP_THEME = 'Oceanic';
const DEFAULT_PIECE_THEME = 'Classic';
const APP_THEME_PREF = 'themeName';
const PIECE_THEME_PREF = 'pieceTheme';
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
  String pieceTheme = DEFAULT_PIECE_THEME;
  String themeName = DEFAULT_APP_THEME;

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
    prefs.setString(APP_THEME_PREF, themeName);
    notifyListeners();
  }

  void setPieceTheme(int index) async {
    pieceTheme = pieceThemes[index];
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(PIECE_THEME_PREF, pieceTheme);
    notifyListeners();
  }

  void loadThemeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    themeName = prefs.getString(APP_THEME_PREF) ?? DEFAULT_APP_THEME;
    pieceTheme = prefs.getString(PIECE_THEME_PREF) ?? DEFAULT_PIECE_THEME;
    notifyListeners();
  }
}
