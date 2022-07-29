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
  int checkHintTile;
  Move latestMove;

  BoardRenderer(this.game, this.boardSize) {
    tileSize = boardSize / TILE_COUNT_PER_ROW;
    for (var piece in game.board.player1Pieces + game.board.player2Pieces) {
      spriteMap[piece] =
          ChessPieceSprite(piece, game.model.themePrefs.pieceTheme);
    }
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

  void _initSpritePositions() {
    for (var piece in game.board.player1Pieces + game.board.player2Pieces) {
      spriteMap[piece].initSpritePosition(tileSize, game.model);
    }
  }

  void updateSpritePositions() {
    if (game.model != null) {
      for (var piece in game.board.player1Pieces + game.board.player2Pieces) {
        spriteMap[piece].update(tileSize, game.model, piece);
      }
    }
  }

  void _drawBoard(Canvas canvas) {
    for (int tileNo = 0; tileNo < TILE_COUNT; tileNo++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (tileNo % TILE_COUNT_PER_ROW) * tileSize,
          (tileNo / TILE_COUNT_PER_ROW).floor() * tileSize,
          tileSize,
          tileSize,
        ),
        Paint()
          ..color = (tileNo + (tileNo / TILE_COUNT_PER_ROW).floor()) % 2 == 0
              ? _game.model.themePrefs.theme.lightTile
              : _game.model.themePrefs.theme.darkTile,
      );
    }
  }

  void _drawPieces(Canvas canvas) {
    for (var piece in _game.board.player1Pieces + _game.board.player2Pieces) {
      _spriteMap[piece].sprite.render(
            canvas,
            size: Vector2(
              tileSize - spriteSizeAdjust,
              tileSize - spriteSizeAdjust,
            ),
            position: Vector2(
              _spriteMap[piece].spritePosition.x + spriteOffset,
              _spriteMap[piece].spritePosition.y + spriteOffset,
            ),
          );
    }
  }

  void _drawMoveHints(Canvas canvas) {
    for (var tile in _game.validMoves) {
      canvas.drawCircle(
        Offset(
          getXFromTile(tile, tileSize, _game.model) + (tileSize / 2),
          getYFromTile(tile, tileSize, _game.model) + (tileSize / 2),
        ),
        tileSize / circleRadiusDivisor,
        Paint()..color = _game.model.themePrefs.theme.moveHint,
      );
    }
  }

  void _drawLatestMove(Canvas canvas) {
    for (int tile in [latestMove.from, latestMove.to]) {
      _drawTileRect(canvas, tile, _game.model.themePrefs.theme.latestMove);
    }
  }

  void _drawCheckHint(Canvas canvas) {
    _drawTileRect(
      canvas,
      checkHintTile,
      _game.model.themePrefs.theme.checkHint,
    );
  }

  void _drawSelectedPieceHint(Canvas canvas) {
    _drawTileRect(
      canvas,
      selectedPiece.tile,
      _game.model.themePrefs.theme.moveHint,
    );
  }

  void _drawTileRect(Canvas canvas, int tile, Color color) {
    canvas.drawRect(
      Rect.fromLTWH(
        getXFromTile(tile, tileSize, _game.model),
        getYFromTile(tile, tileSize, _game.model),
        tileSize,
        tileSize,
      ),
      Paint()..color = color,
    );
  }

  void refreshSprites() {
    _spriteMap.forEach(
      (_, value) => value.initSprite(_game.model.themePrefs.pieceTheme),
    );
  }
}
