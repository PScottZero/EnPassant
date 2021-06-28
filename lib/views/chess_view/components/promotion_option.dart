import 'package:en_passant/logic/chess_piece.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/model/player.dart';
import 'package:en_passant/views/constants/view_constants.dart';
import 'package:flutter/cupertino.dart';

class PromotionOption extends StatelessWidget {
  final AppModel appModel;
  final ChessPieceType promotionType;

  PromotionOption(this.appModel, this.promotionType);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Image(
        image: AssetImage(
          'assets/images/pieces/${themeNameToDir(appModel.themePrefs.pieceTheme)}' +
              '/${pieceTypeToString(promotionType)}_${_playerColor()}.png',
        ),
      ),
      onPressed: () {
        appModel.gameData.game.promote(promotionType);
        appModel.update();
        Navigator.pop(context);
      },
    );
  }

  String _playerColor() {
    return appModel.gameData.turn == Player.player1
        ? ViewConstants.WHITE_STRING
        : ViewConstants.BLACK_STRING;
  }
}
