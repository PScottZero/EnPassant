import 'dart:ui';

import 'package:en_passant/settings/game_settings.dart';
import 'package:flame/game/game.dart';

import 'chess_board.dart';

class ChessGame extends Game {
  double width;
  double tileSize;
  GameSettings gameSettings;
  ChessBoard board = ChessBoard();

  void setSize(Size screenSize) {
    width = screenSize.width - 68;
    tileSize = width / 8;
    resize(Size(width, width));
    print(tileSize);
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
  
  @override
  void render(Canvas canvas) {
    drawBoard(canvas);
    drawPieces(canvas);
  }
  
  @override
  void update(double t) {
  // TODO: implement update
  }
}