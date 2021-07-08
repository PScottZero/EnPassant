import 'package:en_passant/logic/chess_piece.dart';
import 'package:en_passant/logic/constants.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/logic/player.dart';
import 'package:flutter/cupertino.dart';

class PromotionOption extends StatelessWidget {
  final AppModel appModel;
  final ChessPieceType promotionType;

  String get _playerColor => appModel.gameData.turn.isP1 ? 'white' : 'black';

  PromotionOption(this.appModel, this.promotionType);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Image(
        image: AssetImage(
          'assets/images/pieces/${themeNameToAssetDir(appModel.themePrefs.pieceTheme)}' +
              '/${pieceTypeToString(promotionType)}_$_playerColor.png',
        ),
      ),
      onPressed: () {
        appModel.gameData.game.promote(promotionType);
        appModel.update();
        Navigator.pop(context);
      },
    );
  }
}
