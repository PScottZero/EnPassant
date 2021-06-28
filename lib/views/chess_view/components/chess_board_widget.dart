import 'package:en_passant/model/app_model.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

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
                width: 4,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Color(0x88000000),
                ),
              ],
            )
          : BoxDecoration(),
      child: ClipRRect(
        borderRadius: appModel.themePrefs.theme.name != 'Video Chess'
            ? BorderRadius.circular(26)
            : BorderRadius.zero,
        child: Container(
          child: GameWidget(game: appModel.gameData.game),
          width: MediaQuery.of(context).size.width - 68,
          height: MediaQuery.of(context).size.width - 68,
        ),
      ),
    );
  }
}