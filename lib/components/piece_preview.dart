import 'package:en_passant/model/theme_preferences.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

import '../constants/view_constants.dart';
import '../logic/constants.dart';

class PiecePreview extends Game {
  ThemePreferences themePreferences;
  late List<Sprite> sprites;

  List<String> get pieceImages => [
        'pieces/${themeNameToAssetDir(themePreferences.pieceTheme)}/king_black.png',
        'pieces/${themeNameToAssetDir(themePreferences.pieceTheme)}/queen_white.png',
        'pieces/${themeNameToAssetDir(themePreferences.pieceTheme)}/rook_white.png',
        'pieces/${themeNameToAssetDir(themePreferences.pieceTheme)}/bishop_black.png',
        'pieces/${themeNameToAssetDir(themePreferences.pieceTheme)}/knight_black.png',
        'pieces/${themeNameToAssetDir(themePreferences.pieceTheme)}/pawn_white.png',
      ];

  PiecePreview(this.themePreferences) {
    loadSpriteImages();
  }

  loadSpriteImages() async => sprites = List.of(
        await Future.wait(
          pieceImages.map(
            (image) async => Sprite(
              await Flame.images.load(image),
            ),
          ),
        ),
      );

  @override
  void render(Canvas canvas) => sprites.asMap().forEach(
        (index, sprite) {
          canvas.drawRect(
            Rect.fromLTWH(
              (index % 2) * ViewConstants.piecePreviewTitleWidth,
              (index / 2).floor() * ViewConstants.piecePreviewTitleWidth,
              ViewConstants.piecePreviewTitleWidth,
              ViewConstants.piecePreviewTitleWidth,
            ),
            Paint()
              ..color = (index + (index / 2).floor()) % 2 == 0
                  ? themePreferences.theme.lightTile
                  : themePreferences.theme.darkTile,
          );
          sprite.render(
            canvas,
            size: Vector2(
              ViewConstants.piecePreviewTitleWidth -
                  ViewConstants.piecePreviewSpriteAdjust,
              ViewConstants.piecePreviewTitleWidth -
                  ViewConstants.piecePreviewSpriteAdjust,
            ),
            position: Vector2(
              (index % 2) * ViewConstants.piecePreviewTitleWidth +
                  ViewConstants.piece_preview_sprite_offset,
              (index / 2).floor() * ViewConstants.piecePreviewTitleWidth +
                  ViewConstants.piece_preview_sprite_offset,
            ),
          );
        },
      );

  @override
  void update(double t) {}
}
