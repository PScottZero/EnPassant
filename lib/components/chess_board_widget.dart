import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';
import '../logic/chess_game.dart';
import '../model/theme_preferences.dart';

class ChessBoardWidget extends StatelessWidget {
  final ChessGame game;
  final ThemePreferences themePreferences;

  const ChessBoardWidget({
    Key? key,
    required this.game,
    required this.themePreferences,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: themePreferences.theme.name != 'Video Chess'
          ? BoxDecoration(
              border: Border.all(
                color: themePreferences.theme.border,
                width: ViewConstants.largeBorderWidth,
              ),
              borderRadius: BorderRadius.circular(
                ViewConstants.borderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: ViewConstants.blurRadius,
                  color: ViewConstants.shadowColor,
                ),
              ],
            )
          : BoxDecoration(),
      child: ClipRRect(
        borderRadius: themePreferences.theme.name != 'Video Chess'
            ? BorderRadius.circular(
                ViewConstants.borderRadius - ViewConstants.largeBorderWidth,
              )
            : BorderRadius.zero,
        child: Container(
          child: GameWidget(game: game),
          width: MediaQuery.of(context).size.width -
              ViewConstants.gameWidgetSizeTrim,
          height: MediaQuery.of(context).size.width -
              ViewConstants.gameWidgetSizeTrim,
        ),
      ),
    );
  }
}
