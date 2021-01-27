import 'package:en_passant/logic/chess_game.dart';
import 'package:en_passant/logic/chess_piece.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flutter/cupertino.dart';

class PromotionDialog extends StatelessWidget {
  final AppModel appModel;
  final ChessGame game;

  PromotionDialog(this.appModel, this.game);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      actions: [
        Container(
          height: 66,
          child: Row(
            children: [
              CupertinoButton(
                child: Image(
                  image: AssetImage(
                    'assets/images/pieces/${pieceThemeFormat(appModel.pieceTheme)}/queen_${_playerColor()}.png',
                  ),
                ),
                onPressed: () {
                  game.promote(ChessPieceType.queen);
                  appModel.endPromotionRequest();
                  Navigator.pop(context);
                },
              ),
              Spacer(),
              CupertinoButton(
                child: Image(
                  image: AssetImage(
                    'assets/images/pieces/${pieceThemeFormat(appModel.pieceTheme)}/rook_${_playerColor()}.png',
                  ),
                ),
                onPressed: () {
                  game.promote(ChessPieceType.rook);
                  appModel.endPromotionRequest();
                  Navigator.pop(context);
                },
              ),
              Spacer(),
              CupertinoButton(
                child: Image(
                  image: AssetImage(
                    'assets/images/pieces/${pieceThemeFormat(appModel.pieceTheme)}/bishop_${_playerColor()}.png',
                  ),
                ),
                onPressed: () {
                  game.promote(ChessPieceType.bishop);
                  appModel.endPromotionRequest();
                  Navigator.pop(context);
                },
              ),
              Spacer(),
              CupertinoButton(
                child: Image(
                  image: AssetImage(
                    'assets/images/pieces/${pieceThemeFormat(appModel.pieceTheme)}/knight_${_playerColor()}.png',
                  ),
                ),
                onPressed: () {
                  game.promote(ChessPieceType.knight);
                  appModel.endPromotionRequest();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _playerColor() {
    return appModel.turn == Player.player1 ? 'white' : 'black';
  }
}
