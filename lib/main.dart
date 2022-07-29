import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/view_constants.dart';
import 'logic/constants.dart';
import 'model/app_model.dart';
import 'model/theme_preferences.dart';
import 'views/main_menu_view.dart';

const PIECE_NAMES = ['king', 'queen', 'rook', 'bishop', 'knight', 'pawn'];
const PIECE_COLORS = ['black', 'white'];

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
      title: 'En Passant',
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: 'Jura',
            fontSize: ViewConstants.textDialog,
          ),
          pickerTextStyle: TextStyle(
            fontFamily: 'Jura',
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
    for (var color in PIECE_COLORS) {
      for (var piece in PIECE_NAMES) {
        pieceImages
            .add('pieces/${themeNameToAssetDir(theme)}/${piece}_$color.png');
      }
    }
  }
  await Flame.images.loadAll(pieceImages);
}
