import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';
import '../model/app_model.dart';

class ChessBoardWidget extends StatelessWidget {
  final AppModel appModel;

  ChessBoardWidget(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: appModel.themePrefs.theme.name != 'Video Chess'
          ? BoxDecoration(
              border: Border.all(
                color: appModel.themePrefs.theme.border,
                width: ViewConstants.largeBorderWidth,
              ),
              borderRadius: BorderRadius.circular(
                ViewConstants.borderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: ViewConstants.blurRadius,
                  color: ViewConstants.SHADOW_COLOR,
                ),
              ],
            )
          : BoxDecoration(),
      child: ClipRRect(
        borderRadius: appModel.themePrefs.theme.name != 'Video Chess'
            ? BorderRadius.circular(
                ViewConstants.borderRadius - ViewConstants.largeBorderWidth,
              )
            : BorderRadius.zero,
        child: Container(
          child: GameWidget(game: appModel.gameData.game),
          width: MediaQuery.of(context).size.width -
              ViewConstants.gameWidgetSizeTrim,
          height: MediaQuery.of(context).size.width -
              ViewConstants.gameWidgetSizeTrim,
        ),
      ),
    );
  }
}
