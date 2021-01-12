import 'dart:ui';

import 'package:en_passant/model/app_model.dart';
import 'package:flame/game/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

class PiecePreview extends Game {
  AppModel appModel;
  Map<int, String> get imageMap {
    return {
      0: 'pieces/king_${appModel.pieceTheme.toLowerCase()}_black.png',
      1: 'pieces/queen_${appModel.pieceTheme.toLowerCase()}_white.png',
      2: 'pieces/rook_${appModel.pieceTheme.toLowerCase()}_white.png',
      3: 'pieces/bishop_${appModel.pieceTheme.toLowerCase()}_black.png',
      4: 'pieces/knight_${appModel.pieceTheme.toLowerCase()}_black.png',
      5: 'pieces/pawn_${appModel.pieceTheme.toLowerCase()}_white.png',
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
      canvas.drawRect(Rect.fromLTWH(
          (index % 2) * 40.0, (index / 2).floor() * 40.0, 40, 40
      ), Paint()..color = (index + (index / 2).floor()) % 2 == 0 ? 
          appModel.theme.lightTile : appModel.theme.darkTile
      );
      spriteMap[index].renderRect(canvas,
        Rect.fromLTWH(
          (index % 2) * 40.0 + 5,
          (index / 2).floor() * 40.0 + 5,
          30, 30
        )
      );
    }
  }
  
  @override
  void update(double t) {}
}