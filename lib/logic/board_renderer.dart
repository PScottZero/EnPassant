import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import 'chess_game.dart';
import 'chess_piece.dart';
import 'chess_piece_sprite.dart';
import 'move_classes.dart';
import 'constants.dart';

const boardSizeAdjust = 68;
const spriteOffset = 6;
const spriteSizeAdjust = spriteOffset * 2;
const circleRadiusDivisor = 5;

class BoardRenderer {
  ChessGame game;
  double boardSize;
  late double tileSize;
  late Map<ChessPiece, ChessPieceSprite> spriteMap;
  ChessPiece? selectedPiece;
  int? checkHintTile;
  Move? latestMove;

  BoardRenderer(this.game, this.boardSize) {
    tileSize = boardSize / tileCountPerRow;
    (game.board.player1Pieces + game.board.player2Pieces).forEach(
      (piece) => spriteMap[piece] = ChessPieceSprite(
        piece,
        game.model.themePrefs.pieceTheme,
      ),
    );
    _initSpritePositions();
  }

  void render(Canvas canvas) {
    _drawBoard(canvas);
    if (game.model.showHints) {
      _drawCheckHint(canvas);
      _drawLatestMove(canvas);
    }
    _drawSelectedPieceHint(canvas);
    _drawPieces(canvas);
    if (game.model.showHints) _drawMoveHints(canvas);
  }

  void _initSpritePositions() => spriteMap.forEach(
        (_, sprite) => sprite.initSpritePosition(tileSize, game.model),
      );

  void updateSpritePositions() => spriteMap.forEach(
        (piece, sprite) => sprite.update(tileSize, game.model, piece),
      );

  void _drawBoard(Canvas canvas) {
    for (int tileNo = 0; tileNo < tileCount; tileNo++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (tileNo % tileCountPerRow) * tileSize,
          (tileNo / tileCountPerRow).floor() * tileSize,
          tileSize,
          tileSize,
        ),
        Paint()
          ..color = (tileNo + (tileNo / tileCountPerRow).floor()) % 2 == 0
              ? game.model.themePrefs.theme.lightTile
              : game.model.themePrefs.theme.darkTile,
      );
    }
  }

  void _drawPieces(Canvas canvas) {
    spriteMap.forEach(
      (_, sprite) => sprite.render(
        canvas,
        size: Vector2(
          tileSize - spriteSizeAdjust,
          tileSize - spriteSizeAdjust,
        ),
        position: Vector2(
          sprite.spritePosition.x + spriteOffset,
          sprite.spritePosition.y + spriteOffset,
        ),
      ),
    );
  }

  void _drawMoveHints(Canvas canvas) {
    for (var tile in game.validMoves) {
      canvas.drawCircle(
        Offset(
          getXFromTile(tile, tileSize, game.model) + (tileSize / 2),
          getYFromTile(tile, tileSize, game.model) + (tileSize / 2),
        ),
        tileSize / circleRadiusDivisor,
        Paint()..color = game.model.themePrefs.theme.moveHint,
      );
    }
  }

  void _drawLatestMove(Canvas canvas) {
    for (int tile in [latestMove!.from, latestMove!.to]) {
      _drawTileRect(canvas, tile, game.model.themePrefs.theme.latestMove);
    }
  }

  void _drawCheckHint(Canvas canvas) {
    _drawTileRect(
      canvas,
      checkHintTile!,
      game.model.themePrefs.theme.checkHint,
    );
  }

  void _drawSelectedPieceHint(Canvas canvas) {
    _drawTileRect(
      canvas,
      selectedPiece!.tile,
      game.model.themePrefs.theme.moveHint,
    );
  }

  void _drawTileRect(Canvas canvas, int tile, Color color) {
    canvas.drawRect(
      Rect.fromLTWH(
        getXFromTile(tile, tileSize, game.model),
        getYFromTile(tile, tileSize, game.model),
        tileSize,
        tileSize,
      ),
      Paint()..color = color,
    );
  }

  void refreshSprites() {
    spriteMap.forEach(
      (_, value) => value.initSprite(game.model.themePrefs.pieceTheme),
    );
  }
}
