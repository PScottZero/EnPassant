import 'dart:ui';

import 'package:en_passant/logic/tile.dart';
import 'package:en_passant/settings/game_settings.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';

import 'chess_board.dart';

class ChessGame extends Game with TapDetector {
  double width;
  double tileSize;
  GameSettings gameSettings;
  ChessBoard board = ChessBoard();

  @override
  void onTapDown(TapDownDetails details) {
    var tile = offsetToTile(details.localPosition);
    print("${tile.row} - ${tile.col}");
  }

  @override
  void render(Canvas canvas) {
    drawBoard(canvas);
    drawPieces(canvas);
  }

  @override
  void update(double t) {
    // TODO: implement update
  }

  Tile offsetToTile(Offset offset) {
    return Tile(row: 7 - (offset.dy / tileSize).floor(), col: (offset.dx / tileSize).floor());
  }

  void setSize(Size screenSize) {
    width = screenSize.width - 68;
    tileSize = width / 8;
    resize(Size(width, width));
  }

  void setGameSettings(GameSettings gameSettings) {
    this.gameSettings = gameSettings;
  }

  void drawBoard(Canvas canvas) {
    for (int tileNo = 0; tileNo < 64; tileNo++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (tileNo % 8) * tileSize,
          (tileNo / 8).floor() * tileSize, 
          tileSize, tileSize
        ),
        Paint()..color = (tileNo + (tileNo / 8).floor()) % 2 == 0 ? 
          gameSettings.theme.lightTile : gameSettings.theme.darkTile
      );
    }
  }

  void drawPieces(Canvas canvas) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      piece.sprite.renderRect(canvas, Rect.fromLTWH(
        piece.tile.col * tileSize + 5,
        (7 - piece.tile.row) * tileSize + 5,
        tileSize - 10, tileSize - 10
      ));
    }
  }
}