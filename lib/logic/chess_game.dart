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
  
  CancelableOperation aiOperation;
  List<int> validMoves = [];
  ChessPiece selectedPiece;
  int checkHintTile;
  Move latestMove;

  ChessGame(this.appModel, this.context) {
    appModel.resetGame();
    width = MediaQuery.of(context).size.width - 68;
    tileSize = width / 8;
    resize(Size(width, width));
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece] = ChessPieceSprite(piece, appModel.pieceTheme);
    }
    _initSpritePositions();
    if (appModel.isAIsTurn) {
      _aiMove();
    }
  }

  @override
  void onTapDown(TapDownDetails details) {
    if (appModel.gameOver || !(appModel.isAIsTurn)) {
      var tile = _offsetToTile(details.localPosition);
      var touchedPiece = board.tiles[tile];
      if (selectedPiece != null && touchedPiece != null &&
        touchedPiece.player == selectedPiece.player) {
        if (validMoves.contains(tile)) {
          _movePiece(tile);
        } else {
          validMoves = [];
          _selectPiece(touchedPiece);
        }
      } else if (selectedPiece == null) {
        _selectPiece(touchedPiece);
      } else {
        _movePiece(tile);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (appModel != null) {
      _drawBoard(canvas);
      if (appModel.showHints) {
        _drawCheckHint(canvas);
        _drawLatestMove(canvas);
      }
      _drawSelectedPieceHint(canvas);
      _drawPieces(canvas);
      if (appModel.showHints) {
        _drawMoveHints(canvas);
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

  void _initSpritePositions() {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece].initSpritePosition(tileSize, appModel);
    }
  }

  void _selectPiece(ChessPiece piece) {
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

  void _movePiece(int tile) {
    if (validMoves.contains(tile)) {
      validMoves = [];
      _moveCompletion(push(Move(selectedPiece.tile, tile), board, getMeta: true));
    }
  }

  void _aiMove() async {
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
        _moveCompletion(meta);
      }
    });
  }

  void cancelAIMove() {
    if (aiOperation != null) {
      aiOperation.cancel();
    }
  }

  void undoMove() {
    board.redoStack.add(pop(board));
    if (appModel.moveMetaList.length > 1) {
      var meta = appModel.moveMetaList[appModel.moveMetaList.length - 2];
      _moveCompletion(meta, clearRedo: false, undoing: true);
    } else {
      _undoOpeningMove();
      appModel.changeTurn();
    }
  }

  void undoTwoMoves() {
    pop(board);
    pop(board);
    appModel.popMoveMeta();
    if (appModel.moveMetaList.length > 1) {
      _moveCompletion(appModel.moveMetaList[appModel.moveMetaList.length - 2],
        clearRedo: false, undoing: true);
      appModel.changeTurn();
    } else {
      _undoOpeningMove();
    }
  }

  void _undoOpeningMove() {
    selectedPiece = null;
    validMoves = [];
    latestMove = null;
    checkHintTile = null;
    appModel.popMoveMeta();
  }

  void redoMove() {
    _moveCompletion(push(board.redoStack.removeLast().move, board),
      clearRedo: false);
  }

  void _moveCompletion(MoveMeta meta, { bool clearRedo = true,
    bool undoing = false }) {
    if (clearRedo) {
      board.redoStack = [];
    }
    validMoves = [];
    latestMove = meta.move;
    checkHintTile = null;
    var oppositeTurn = oppositePlayer(appModel.turn);
    if (kingInCheck(oppositeTurn, board)) {
      meta.isCheck = true;
      checkHintTile = kingForPlayer(oppositeTurn, board).tile;
    }
    if (kingInCheckmate(oppositeTurn, board)) {
      if (!meta.isCheck) {
        appModel.stalemate = true;
        meta.isStalemate = true;
      }
      meta.isCheck = false;
      meta.isCheckmate = true;
      appModel.endGame();
    }
    if (undoing) {
      appModel.popMoveMeta();
      appModel.unendGame();
    } else {
      appModel.pushMoveMeta(meta);
    }
    appModel.changeTurn();
    selectedPiece = null;
    if (appModel.isAIsTurn && !undoing) {
      _aiMove();
    }
  }

  int _offsetToTile(Offset offset) {
    if (appModel.flip && appModel.playingWithAI && appModel.playerSide == Player.player2) {
      return (7 - (offset.dy / tileSize).floor()) * 8 +
        7 - (offset.dx / tileSize).floor();
    } else {
      return (offset.dy / tileSize).floor() * 8 +
        (offset.dx / tileSize).floor();
    }
  }

  void _drawBoard(Canvas canvas) {
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

  void _drawPieces(Canvas canvas) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece].sprite.renderRect(canvas, Rect.fromLTWH(
        spriteMap[piece].spriteX + 5,
        spriteMap[piece].spriteY + 5,
        tileSize - 10, tileSize - 10
      ));
    }
  }

  void _drawMoveHints(Canvas canvas) {
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

  void _drawLatestMove(Canvas canvas) {
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

  void _drawCheckHint(Canvas canvas) {
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

  void _drawSelectedPieceHint(Canvas canvas) {
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
