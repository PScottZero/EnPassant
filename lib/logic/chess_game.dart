import 'dart:ui';

import 'package:en_passant/logic/move_calculation/ai_move_calculation.dart';
import 'package:en_passant/logic/move_calculation/move_calculation.dart';
import 'package:en_passant/logic/move_calculation/move_classes/move_meta.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'chess_board.dart';
import 'chess_piece.dart';
import 'move_calculation/move_classes/move.dart';

class ChessGame extends Game with TapDetector, ChangeNotifier {
  double width;
  double tileSize;
  AppModel appModel;
  ChessBoard board = ChessBoard();

  List<int> validMoves = [];
  ChessPiece selectedPiece;
  int checkHintTile;

  @override
  void onTapDown(TapDownDetails details) {
    if (appModel.gameOver || !(appModel.isAIsTurn)) {
      var tile = offsetToTile(details.localPosition);
      var touchedPiece = board.tiles[tile];
      if (selectedPiece != null && touchedPiece != null &&
        touchedPiece.player == selectedPiece.player) {
        if (validMoves.contains(tile)) {
          movePiece(tile);
        } else {
          validMoves = [];
          selectPiece(touchedPiece);
        }
      } else if (selectedPiece == null) {
        selectPiece(touchedPiece);
      } else {
        movePiece(tile);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    drawBoard(canvas);
    drawCheckHint(canvas);
    drawSelectedPieceHint(canvas);
    drawPieces(canvas);
    drawMoveHints(canvas);
  }

  @override
  void update(double t) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      piece.update(tileSize: tileSize, appModel: appModel);
    }
  }

  void initSpritePositions() {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      piece.initSpritePosition(tileSize, appModel);
    }
  }

  void selectPiece(ChessPiece piece) {
    if (piece != null) {
      if (piece.player == appModel.turn) {
        selectedPiece = piece;
        if (selectedPiece != null) {
          validMoves = movesForPiece(piece, board);
        }
        if (validMoves.isEmpty) {
          selectedPiece = null;
        }
      }
    }
  }

  void movePiece(int tile) {
    if (validMoves.contains(tile)) {
      validMoves = [];
      moveCompletion(push(Move(selectedPiece, tile), board));
    }
  }

  void aiMove() async {
    await Future.delayed(Duration(milliseconds: 500));
    var args = Map();
    args['aiPlayer'] = appModel.aiTurn;
    args['aiDifficulty'] = appModel.aiDifficulty;
    args['board'] = board;
    var move = calculateAIMove(args);
    if (move == null) {
      appModel.endGame();
    } else {
      validMoves = [];
      var meta = push(move, board);
      moveCompletion(meta);
    }
  }

  void moveCompletion(MoveMeta meta) {
    checkHintTile = null;
    var oppositeTurn = oppositePlayer(appModel.turn);
    if (kingInCheck(oppositeTurn, board)) {
      meta.isCheck = true;
      checkHintTile = kingForPlayer(oppositeTurn, board).tile;
    }
    if (kingInCheckmate(oppositeTurn, board)) {
      meta.isCheck = false;
      meta.isCheckmate = true;
      appModel.endGame();
    }
    appModel.addMoveMeta(meta);
    appModel.changeTurn();
    selectedPiece = null;
    if (appModel.isAIsTurn) {
      aiMove();
    }
  }

  int offsetToTile(Offset offset) {
    if (appModel.playingWithAI && appModel.playerSide == Player.player2) {
      return 7 - (offset.dy / tileSize).floor() * 8 +
        (offset.dx / tileSize).floor();
    } else {
      return (offset.dy / tileSize).floor() * 8 +
        (offset.dx / tileSize).floor();
    }
  }

  void setSize(Size screenSize) {
    width = screenSize.width - 68;
    tileSize = width / 8;
    resize(Size(width, width));
  }

  void setappModel(AppModel appModel) {
    this.appModel = appModel;
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
          appModel.theme.lightTile : appModel.theme.darkTile
      );
    }
  }

  void drawPieces(Canvas canvas) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      piece.sprite.renderRect(canvas, Rect.fromLTWH(
        piece.spriteX + 5,
        piece.spriteY + 5,
        tileSize - 10, tileSize - 10
      ));
    }
  }

  void drawMoveHints(Canvas canvas) {
    for (var tile in validMoves) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(tile, tileSize, appModel),
          getYFromTile(tile, tileSize, appModel),
          tileSize, tileSize
        ),
        Paint()..color = appModel.theme.moveHint
      );
    }
  }

  void drawCheckHint(Canvas canvas) {
    if (checkHintTile != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(checkHintTile, tileSize, appModel),
          getYFromTile(checkHintTile, tileSize, appModel),
          tileSize, tileSize
        ),
        Paint()..color = appModel.theme.checkHint
      );
    }
  }

  void drawSelectedPieceHint(Canvas canvas) {
    if (selectedPiece != null) {
      canvas.drawCircle(
        Offset(
          getXFromTile(selectedPiece.tile, tileSize,
            appModel) + (tileSize / 2),
          getYFromTile(selectedPiece.tile, tileSize,
            appModel) + (tileSize / 2)
        ),
        tileSize / 2,
        Paint()..color = appModel.theme.moveHint
      );
    }
  }
}
