import 'package:en_passant/logic/chess_piece.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/view_constants.dart';
import 'package:flutter/cupertino.dart';

import 'promotion_option.dart';

const PROMOTIONS = [
  ChessPieceType.queen,
  ChessPieceType.rook,
  ChessPieceType.bishop,
  ChessPieceType.knight
];

class PromotionDialog extends StatelessWidget {
  final AppModel appModel;

  PromotionDialog(this.appModel);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      actions: [
        Container(
          height: ViewConstants.PROMOTION_DIALOG_HEIGHT,
          child: Row(
            children: PROMOTIONS
                .map(
                  (promotionType) => PromotionOption(
                    appModel,
                    promotionType,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
