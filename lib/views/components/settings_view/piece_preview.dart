import 'dart:ui';

import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

class PiecePreview extends Game {
  AppModel appModel;

  Map<int, String> get imageMap {
    return {
      0: 'pieces/${formatPieceTheme(appModel.pieceTheme)}/king_black.png',
      1: 'pieces/${formatPieceTheme(appModel.pieceTheme)}/queen_white.png',
      2: 'pieces/${formatPieceTheme(appModel.pieceTheme)}/rook_white.png',
      3: 'pieces/${formatPieceTheme(appModel.pieceTheme)}/bishop_black.png',
      4: 'pieces/${formatPieceTheme(appModel.pieceTheme)}/knight_black.png',
      5: 'pieces/${formatPieceTheme(appModel.pieceTheme)}/pawn_white.png',
    };
  }

  Map<int, Sprite> spriteMap = Map();
  bool rendered = false;

  PiecePreview(this.appModel) {
    loadSpriteImages();
  }

  loadSpriteImages() async {
    for (var index = 0; index < 6; index++) {
      spriteMap[index] = Sprite(await Flame.images.load(imageMap[index]));
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
      spriteMap[index].render(
        canvas,
        size: Vector2(30, 30),
        position: Vector2(
          (index % 2) * 40.0 + 5,
          (index / 2).floor() * 40.0 + 5,
        ),
      );
    }
  }

  @override
  void update(double t) {}
}
