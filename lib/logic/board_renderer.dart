import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import 'chess_game.dart';
import 'chess_piece.dart';
import 'chess_piece_sprite.dart';
import 'move_calculation/move_classes.dart';
import 'shared_functions.dart';

const TILE_COUNT = 8;
const BOARD_SIZE_ADJUST = 68;

class BoardRenderer {
  ChessGame game;
  double boardSize;
  double tileSize;
  Map<ChessPiece, ChessPieceSprite> spriteMap = Map();
  ChessPiece selectedPiece;
  int checkHintTile;
  Move latestMove;
  bool showHints;

  BoardRenderer(this.game, BuildContext context) {
    boardSize = MediaQuery.of(context).size.width - BOARD_SIZE_ADJUST;
    tileSize = boardSize / TILE_COUNT;
    for (var piece in game.board.player1Pieces + game.board.player2Pieces) {
      spriteMap[piece] =
          ChessPieceSprite(piece, game.model.themePrefs.pieceTheme);
    }
    _initSpritePositions();
  }

  void render(Canvas canvas) {
    if (game.model != null) {
      _drawBoard(canvas);
      if (game.model.showHints) {
        if (checkHintTile != null) _drawCheckHint(canvas);
        if (latestMove != null) _drawLatestMove(canvas);
      }
      if (selectedPiece != null) _drawSelectedPieceHint(canvas);
      _drawPieces(canvas);
      if (game.model.showHints) _drawMoveHints(canvas);
    }
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
    for (int tileNo = 0; tileNo < 64; tileNo++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (tileNo % TILE_COUNT) * tileSize,
          (tileNo / TILE_COUNT).floor() * tileSize,
          tileSize,
          tileSize,
        ),
        Paint()
          ..color = (tileNo + (tileNo / TILE_COUNT).floor()) % 2 == 0
              ? game.model.themePrefs.theme.lightTile
              : game.model.themePrefs.theme.darkTile,
      );
    }
  }

  void _drawPieces(Canvas canvas) {
    for (var piece in game.board.player1Pieces + game.board.player2Pieces) {
      spriteMap[piece].sprite.render(
            canvas,
            size: Vector2(
              tileSize - 12,
              tileSize - 12,
            ),
            position: Vector2(
              spriteMap[piece].spritePosition.x + 6,
              spriteMap[piece].spritePosition.y + 6,
            ),
          );
    }
  }

  void _drawMoveHints(Canvas canvas) {
    for (var tile in game.validMoves) {
      canvas.drawCircle(
        Offset(
          getXFromTile(tile, tileSize, game.model) + (tileSize / 2),
          getYFromTile(tile, tileSize, game.model) + (tileSize / 2),
        ),
        tileSize / 5,
        Paint()..color = game.model.themePrefs.theme.moveHint,
      );
    }
  }

  void _drawLatestMove(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(
        getXFromTile(latestMove.from, tileSize, game.model),
        getYFromTile(latestMove.from, tileSize, game.model),
        tileSize,
        tileSize,
      ),
      Paint()..color = game.model.themePrefs.theme.latestMove,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        getXFromTile(latestMove.to, tileSize, game.model),
        getYFromTile(latestMove.to, tileSize, game.model),
        tileSize,
        tileSize,
      ),
      Paint()..color = game.model.themePrefs.theme.latestMove,
    );
  }

  void _drawCheckHint(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(
        getXFromTile(checkHintTile, tileSize, game.model),
        getYFromTile(checkHintTile, tileSize, game.model),
        tileSize,
        tileSize,
      ),
      Paint()..color = game.model.themePrefs.theme.checkHint,
    );
  }

  void _drawSelectedPieceHint(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(
        getXFromTile(selectedPiece.tile, tileSize, game.model),
        getYFromTile(selectedPiece.tile, tileSize, game.model),
        tileSize,
        tileSize,
      ),
      Paint()..color = game.model.themePrefs.theme.moveHint,
    );
  }
}
