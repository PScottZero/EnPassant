import 'dart:ui';

import 'package:async/async.dart';
import 'package:en_passant/logic/move_calculation/ai_move_calculation.dart';
import 'package:en_passant/logic/chess_piece_sprite.dart';
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

class ChessGame extends Game with TapDetector {
  double width;
  double tileSize;
  AppModel appModel;
  BuildContext context;
  ChessBoard board = ChessBoard();
  Map<ChessPiece, ChessPieceSprite> spriteMap = Map();
  Move latestMove;

  CancelableOperation aiOperation;
  List<int> validMoves = [];
  ChessPiece selectedPiece;
  int checkHintTile;

  ChessGame(this.appModel, this.context) {
    appModel.resetGame();
    width = MediaQuery.of(context).size.width - 68;
    tileSize = width / 8;
    resize(Size(width, width));
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece] = ChessPieceSprite(piece, appModel.pieceTheme);
    }
    initSpritePositions();
    if (appModel.isAIsTurn) {
      aiMove();
    }
  }

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
    if (appModel != null) {
      drawBoard(canvas);
      if (appModel.showHints) {
        drawCheckHint(canvas);
        drawLatestMove(canvas);
      }
      drawSelectedPieceHint(canvas);
      drawPieces(canvas);
      if (appModel.showHints) {
        drawMoveHints(canvas);
      }
    }
  }

  @override
  void update(double t) {
    if (appModel != null) {
      for (var piece in board.player1Pieces + board.player2Pieces) {
        spriteMap[piece].update(tileSize, appModel, piece);
      }
    }
  }

  void initSpritePositions() {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece].initSpritePosition(tileSize, appModel);
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
      moveCompletion(push(Move(selectedPiece.tile, tile), board, getMeta: true));
    }
  }

  void aiMove() async {
    await Future.delayed(Duration(milliseconds: 500));
    var args = Map();
    args['aiPlayer'] = appModel.aiTurn;
    args['aiDifficulty'] = appModel.aiDifficulty;
    args['board'] = board;
    aiOperation = CancelableOperation.fromFuture(compute(calculateAIMove, args));
    aiOperation.value.then((move) {
      if (move == null || appModel.gameOver) {
        appModel.endGame();
      } else {
        validMoves = [];
        var meta = push(move, board, getMeta: true);
        moveCompletion(meta);
      }
    });
  }

  void cancelAIMove() {
    if (aiOperation != null) {
      aiOperation.cancel();
    }
  }

  void moveCompletion(MoveMeta meta) {
    latestMove = meta.move;
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
      return (7 - (offset.dy / tileSize).floor()) * 8 +
        7 - (offset.dx / tileSize).floor();
    } else {
      return (offset.dy / tileSize).floor() * 8 +
        (offset.dx / tileSize).floor();
    }
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
      spriteMap[piece].sprite.renderRect(canvas, Rect.fromLTWH(
        spriteMap[piece].spriteX + 5,
        spriteMap[piece].spriteY + 5,
        tileSize - 10, tileSize - 10
      ));
    }
  }

  void drawMoveHints(Canvas canvas) {
    for (var tile in validMoves) {
      canvas.drawCircle(
        Offset(
          getXFromTile(tile, tileSize,
            appModel) + (tileSize / 2),
          getYFromTile(tile, tileSize,
            appModel) + (tileSize / 2)
        ),
        tileSize / 5,
        Paint()..color = appModel.theme.moveHint
      );
    }
  }

  void drawLatestMove(Canvas canvas) {
    if (latestMove != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(latestMove.from, tileSize, appModel),
          getYFromTile(latestMove.from, tileSize, appModel),
          tileSize, tileSize
        ),
        Paint()..color = appModel.theme.latestMove
      );
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(latestMove.to, tileSize, appModel),
          getYFromTile(latestMove.to, tileSize, appModel),
          tileSize, tileSize
        ),
        Paint()..color = appModel.theme.latestMove
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
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(selectedPiece.tile, tileSize, appModel),
          getYFromTile(selectedPiece.tile, tileSize, appModel),
          tileSize, tileSize
        ),
        Paint()..color = appModel.theme.moveHint
      );
    }
  }
}
