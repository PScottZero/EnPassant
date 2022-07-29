import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../logic/chess_piece.dart';
import '../logic/constants.dart';
import '../model/app_model.dart';

class PromotionOption extends StatelessWidget {
  final ChessPieceType promotionType;

  PromotionOption({Key? key, required this.promotionType});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, model, child) => CupertinoButton(
        child: Image(
          image: AssetImage(
            'assets/images/pieces/${themeNameToAssetDir(model.themePrefs.pieceTheme)}/'
            '${pieceTypeToString(promotionType)}_${model.gameData.isP1Turn ? "white" : "black"}.png',
          ),
        ),
        onPressed: () {
          model.gameData.game.promote(promotionType);
          model.update();
          Navigator.pop(context);
        },
      ),
    );
  }
}
