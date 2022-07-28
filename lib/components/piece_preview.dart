import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';
import '../logic/constants.dart';
import '../model/app_model.dart';

class PiecePreview extends Game {
  AppModel appModel;

  Map<int, String> get imageMap {
    return {
      0: 'pieces/${themeNameToAssetDir(appModel.themePrefs.pieceTheme)}/king_black.png',
      1: 'pieces/${themeNameToAssetDir(appModel.themePrefs.pieceTheme)}/queen_white.png',
      2: 'pieces/${themeNameToAssetDir(appModel.themePrefs.pieceTheme)}/rook_white.png',
      3: 'pieces/${themeNameToAssetDir(appModel.themePrefs.pieceTheme)}/bishop_black.png',
      4: 'pieces/${themeNameToAssetDir(appModel.themePrefs.pieceTheme)}/knight_black.png',
      5: 'pieces/${themeNameToAssetDir(appModel.themePrefs.pieceTheme)}/pawn_white.png',
    };
  }

  Map<int, Sprite> spriteMap = Map();
  bool rendered = false;

  PiecePreview(this.appModel) {
    loadSpriteImages();
  }

  loadSpriteImages() async {
    for (var index = 0; index < imageMap.length; index++) {
      spriteMap[index] = Sprite(await Flame.images.load(imageMap[index]));
    }
  }

  @override
  void render(Canvas canvas) {
    for (var index = 0; index < spriteMap.length; index++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (index % 2) * ViewConstants.PIECE_PREVIEW_TILE_WIDTH,
          (index / 2).floor() * ViewConstants.PIECE_PREVIEW_TILE_WIDTH,
          ViewConstants.PIECE_PREVIEW_TILE_WIDTH,
          ViewConstants.PIECE_PREVIEW_TILE_WIDTH,
        ),
        Paint()
          ..color = (index + (index / 2).floor()) % 2 == 0
              ? appModel.themePrefs.theme.lightTile
              : appModel.themePrefs.theme.darkTile,
      );
      spriteMap[index].render(
        canvas,
        size: Vector2(
          ViewConstants.PIECE_PREVIEW_TILE_WIDTH -
              ViewConstants.PIECE_PREVIEW_SPRITE_ADJUST,
          ViewConstants.PIECE_PREVIEW_TILE_WIDTH -
              ViewConstants.PIECE_PREVIEW_SPRITE_ADJUST,
        ),
        position: Vector2(
          (index % 2) * ViewConstants.PIECE_PREVIEW_TILE_WIDTH +
              ViewConstants.PIECE_PREVIEW_SPRITE_OFFSET,
          (index / 2).floor() * ViewConstants.PIECE_PREVIEW_TILE_WIDTH +
              ViewConstants.PIECE_PREVIEW_SPRITE_OFFSET,
        ),
      );
    }
  }

  @override
  void update(double t) {}
}
