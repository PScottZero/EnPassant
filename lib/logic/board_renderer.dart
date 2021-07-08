import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import 'chess_game.dart';
import 'chess_piece.dart';
import 'chess_piece_sprite.dart';
import 'move_classes.dart';
import 'constants.dart';

const BOARD_SIZE_ADJUST = 68;
const SPRITE_OFFSET = 6;
const SPRITE_SIZE_ADJUST = SPRITE_OFFSET * 2;
const CIRCLE_RADIUS_DIVISOR = 5;

class BoardRenderer {
  ChessGame _game;
  double _boardSize;
  double tileSize;
  Map<ChessPiece, ChessPieceSprite> _spriteMap = Map();
  ChessPiece selectedPiece;
  int checkHintTile;
  Move latestMove;

  BoardRenderer(this._game, BuildContext context) {
    _boardSize = MediaQuery.of(context).size.width - BOARD_SIZE_ADJUST;
    tileSize = _boardSize / TILE_COUNT_PER_ROW;
    for (var piece in _game.board.player1Pieces + _game.board.player2Pieces) {
      _spriteMap[piece] =
          ChessPieceSprite(piece, _game.model.themePrefs.pieceTheme);
    }
    _initSpritePositions();
  }

  void render(Canvas canvas) {
    if (_game.model != null) {
      _drawBoard(canvas);
      if (_game.model.showHints) {
        if (checkHintTile != null) _drawCheckHint(canvas);
        if (latestMove != null) _drawLatestMove(canvas);
      }
      if (selectedPiece != null) _drawSelectedPieceHint(canvas);
      _drawPieces(canvas);
      if (_game.model.showHints) _drawMoveHints(canvas);
    }
  }

  void _initSpritePositions() {
    for (var piece in _game.board.player1Pieces + _game.board.player2Pieces) {
      _spriteMap[piece].initSpritePosition(tileSize, _game.model);
    }
  }

  void updateSpritePositions() {
    if (_game.model != null) {
      for (var piece in _game.board.player1Pieces + _game.board.player2Pieces) {
        _spriteMap[piece].update(tileSize, _game.model, piece);
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
              tileSize - SPRITE_SIZE_ADJUST,
              tileSize - SPRITE_SIZE_ADJUST,
            ),
            position: Vector2(
              _spriteMap[piece].spritePosition.x + SPRITE_OFFSET,
              _spriteMap[piece].spritePosition.y + SPRITE_OFFSET,
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
        tileSize / CIRCLE_RADIUS_DIVISOR,
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
