import 'dart:ui';

import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:flame/game/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

class PiecePreview extends Game {
  AppModel appModel;
  Map<int, String> get imageMap {
    return {
      0: 'pieces/${pieceThemeFormat(appModel.pieceTheme)}/king_black.png',
      1: 'pieces/${pieceThemeFormat(appModel.pieceTheme)}/queen_white.png',
      2: 'pieces/${pieceThemeFormat(appModel.pieceTheme)}/rook_white.png',
      3: 'pieces/${pieceThemeFormat(appModel.pieceTheme)}/bishop_black.png',
      4: 'pieces/${pieceThemeFormat(appModel.pieceTheme)}/knight_black.png',
      5: 'pieces/${pieceThemeFormat(appModel.pieceTheme)}/pawn_white.png',
    };
  }

  Map<int, Sprite> spriteMap = Map();
  bool rendered = false;

  PiecePreview(this.appModel) {
    resize(Size(80, 120));
    for (var index = 0; index < 6; index++) {
      spriteMap[index] = Sprite(imageMap[index]);
    }
  }

  @override
  void render(Canvas canvas) {
    for (var index = 0; index < 6; index++) {
      canvas.drawRect(
        Rect.fromLTWH((index % 2) * 40.0, (index / 2).floor() * 40.0, 40, 40),
        Paint()
          ..color = (index + (index / 2).floor()) % 2 == 0
              ? appModel.theme.lightTile
              : appModel.theme.darkTile,
      );
      spriteMap[index].renderRect(
        canvas,
        Rect.fromLTWH(
            (index % 2) * 40.0 + 5, (index / 2).floor() * 40.0 + 5, 30, 30),
      );
    }
  }

  @override
  void update(double t) {}
}
