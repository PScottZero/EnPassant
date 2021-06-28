import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/constants/view_constants.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

class ChessBoardWidget extends StatelessWidget {
  final AppModel appModel;

  ChessBoardWidget(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          appModel.themePrefs.theme.name != ViewConstants.VIDEO_CHESS_THEME_NAME
              ? BoxDecoration(
                  border: Border.all(
                    color: appModel.themePrefs.theme.border,
                    width: ViewConstants.BORDER_WIDTH_LARGE,
                  ),
                  borderRadius: BorderRadius.circular(
                    ViewConstants.BORDER_RADIUS,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: ViewConstants.BLUR_RADIUS,
                      color: ViewConstants.SHADOW_COLOR,
                    ),
                  ],
                )
              : BoxDecoration(),
      child: ClipRRect(
        borderRadius: appModel.themePrefs.theme.name !=
                ViewConstants.VIDEO_CHESS_THEME_NAME
            ? BorderRadius.circular(
                ViewConstants.BORDER_RADIUS - ViewConstants.BORDER_WIDTH_LARGE,
              )
            : BorderRadius.zero,
        child: Container(
          child: GameWidget(game: appModel.gameData.game),
          width: MediaQuery.of(context).size.width -
              ViewConstants.GAME_WIDGET_SIZE_TRIM,
          height: MediaQuery.of(context).size.width -
              ViewConstants.GAME_WIDGET_SIZE_TRIM,
        ),
      ),
    );
  }
}
