import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/constants/view_constants.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'logic/shared_functions.dart';
import 'model/theme_preferences.dart';
import 'views/main_menu_view/main_menu_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppModel(),
      child: EnPassantApp(),
    ),
  );
  _cachePieceImages();
}

class EnPassantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return CupertinoApp(
      title: ViewConstants.APP_NAME,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: ViewConstants.FONT_NAME,
            fontSize: ViewConstants.TEXT_DIALOG,
          ),
          pickerTextStyle: TextStyle(
            fontFamily: ViewConstants.FONT_NAME,
          ),
        ),
      ),
      home: MainMenuView(),
    );
  }
}

void _cachePieceImages() async {
  List<String> pieceImages = [];
  for (var theme in PIECE_THEMES) {
    for (var color in ['black', 'white']) {
      for (var piece in ['king', 'queen', 'rook', 'bishop', 'knight', 'pawn']) {
        pieceImages.add('pieces/${themeNameToDir(theme)}/${piece}_$color.png');
      }
    }
  }
  await Flame.images.loadAll(pieceImages);
}
