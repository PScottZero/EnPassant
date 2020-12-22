import 'dart:ui';

import 'package:en_passant/logic/move_calculation.dart';
import 'package:en_passant/logic/tile.dart';
import 'package:en_passant/settings/game_settings.dart';
import 'package:en_passant/views/components/main_menu/piece_color_picker.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';

import 'chess_board.dart';
import 'chess_piece.dart';

class ChessGame extends Game with TapDetector, ChangeNotifier {
  double width;
  double tileSize;
  GameSettings gameSettings;
  ChessBoard board = ChessBoard();

  PlayerID turn = PlayerID.player1;
  bool gameOver = false;
  bool isFirstMove = true;

  List<Tile> validMoves = [];
  bool movingPiece = false;
  ChessPiece selectedPiece;

  @override
  void onTapDown(TapDownDetails details) {
    if (!gameOver && !movingPiece) {
      var tile = offsetToTile(details.localPosition);
      var touchedPiece = board.pieceAtTile(tile);
      if (selectedPiece != null && touchedPiece != null &&
        touchedPiece.player == selectedPiece.player) {
        validMoves = [];
        selectPiece(touchedPiece);
      } else if (selectedPiece == null) {
        selectPiece(touchedPiece);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    drawBoard(canvas);
    drawPieces(canvas);
    drawMoveHints(canvas);
  }

  @override
  void update(double t) {}

  void selectPiece(ChessPiece piece) {
    if (piece.player == turn) {
      selectedPiece = piece;
      if (selectedPiece != null) {
        validMoves = MoveCalculation.movesFor(piece: piece, board: board);
      }
      if (validMoves.isEmpty) {
        selectedPiece = null;
      }
    }
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

  void drawMoveHints(Canvas canvas) {
    for (var move in validMoves) {
      canvas.drawRect(
        Rect.fromLTWH(
          move.col * tileSize,
          (7 - move.row) * tileSize,
          tileSize, tileSize
        ),
        Paint()..color = gameSettings.theme.moveHint
      );
    }
  }
}