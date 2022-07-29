import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';
import '../logic/chess_piece.dart';
import '../model/app_model.dart';
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
          height: ViewConstants.promotionDialogHeight,
          child: Row(
            children: PROMOTIONS
                .map(
                  (promotionType) => PromotionOption(
                    promotionType: promotionType,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
