import 'dart:ui';

import 'package:async/async.dart';
import 'package:en_passant/logic/chess_piece_sprite.dart';
import 'package:en_passant/logic/move_calculation/ai_move_calculation.dart';
import 'package:en_passant/logic/move_calculation/move_calculation.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'chess_board.dart';
import 'chess_piece.dart';
import 'move_calculation/move_classes.dart';

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
    width = MediaQuery.of(context).size.width - 68;
    tileSize = width / 8;
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece] =
          ChessPieceSprite(piece, appModel.themePrefs.pieceTheme);
    }
    _initSpritePositions();
    if (appModel.gameData.isAIsTurn) {
      _aiMove();
    }
  }

  @override
  void onTapDown(TapDownInfo details) {
    if (appModel.gameData.gameOver || !(appModel.gameData.isAIsTurn)) {
      var tile = _vector2ToTile(details.eventPosition.widget);
      var touchedPiece = board.tiles[tile];
      if (touchedPiece == selectedPiece) {
        validMoves = [];
        selectedPiece = null;
      } else {
        if (selectedPiece != null &&
            touchedPiece != null &&
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
      if (piece.player == appModel.gameData.turn) {
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
      var move = Move(selectedPiece.tile, tile);
      push(move, board, getMeta: true);
      if (move.meta.flags.promotion) {
        appModel.gameData.requestPromotion();
      }
      _moveCompletion(move, changeTurn: !move.meta.flags.promotion);
    }
  }

  void _aiMove() async {
    await Future.delayed(Duration(milliseconds: 500));
    var args = Map();
    args['aiPlayer'] = appModel.gameData.aiTurn;
    args['aiDifficulty'] = appModel.gameData.aiDifficulty;
    args['board'] = board;
    aiOperation = CancelableOperation.fromFuture(
      compute(calculateAIMove, args),
    );
    aiOperation.value.then((move) {
      if (move == null || appModel.gameData.gameOver) {
        appModel.gameData.endGame();
      } else {
        validMoves = [];
        push(move, board, getMeta: true);
        _moveCompletion(move, changeTurn: !move.meta.flags.promotion);
        if (move.meta.flags.promotion) {
          promote(move.meta.promotionType);
        }
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
    if (board.moveStack.length > 1) {
      _moveCompletion(board.moveStack[board.moveStack.length - 2],
          clearRedo: false, undoing: true);
    } else {
      _undoOpeningMove();
      appModel.gameData.changeTurn();
    }
  }

  void undoTwoMoves() {
    board.redoStack.add(pop(board));
    board.redoStack.add(pop(board));
    appModel.jumpToEndOfMoveList();
    if (board.moveStack.length > 1) {
      _moveCompletion(board.moveStack[board.moveStack.length - 2],
          clearRedo: false, undoing: true, changeTurn: false);
    } else {
      _undoOpeningMove();
    }
  }

  void _undoOpeningMove() {
    selectedPiece = null;
    validMoves = [];
    latestMove = null;
    checkHintTile = null;
    appModel.jumpToEndOfMoveList();
  }

  void redoMove() {
    _moveCompletion(push(board.redoStack.removeLast(), board),
        clearRedo: false);
  }

  void redoTwoMoves() {
    _moveCompletion(push(board.redoStack.removeLast(), board),
        clearRedo: false, updateMetaList: true);
    _moveCompletion(push(board.redoStack.removeLast(), board),
        clearRedo: false, updateMetaList: true);
  }

  void promote(ChessPieceType type) {
    board.moveStack.last.meta.movedPiece.type = type;
    board.moveStack.last.meta.promotionType = type;
    addPromotedPiece(board, board.moveStack.last);
    _moveCompletion(board.moveStack.last, updateMetaList: false);
  }

  void _moveCompletion(
    Move move, {
    bool clearRedo = true,
    bool undoing = false,
    bool changeTurn = true,
    bool updateMetaList = true,
  }) {
    if (clearRedo) {
      board.redoStack = [];
    }
    validMoves = [];
    latestMove = move;
    checkHintTile = null;
    var oppositeTurn = oppositePlayer(appModel.gameData.turn);
    if (kingInCheck(oppositeTurn, board)) {
      move.meta.flags.isCheck = true;
      checkHintTile = kingForPlayer(oppositeTurn, board).tile;
    }
    if (kingInCheckmate(oppositeTurn, board)) {
      if (!move.meta.flags.isCheck) {
        appModel.gameData.stalemate = true;
        move.meta.flags.isStalemate = true;
      }
      move.meta.flags.isCheck = false;
      move.meta.flags.isCheckmate = true;
      appModel.gameData.endGame();
    }
    if (undoing) {
      appModel.jumpToEndOfMoveList();
      appModel.gameData.undoEndGame();
    } else if (updateMetaList) {
      appModel.jumpToEndOfMoveList();
    }
    if (changeTurn) {
      appModel.gameData.changeTurn();
    }
    selectedPiece = null;
    if (appModel.gameData.isAIsTurn && clearRedo && changeTurn) {
      _aiMove();
    }
  }

  int _vector2ToTile(Vector2 vector2) {
    if (appModel.flip &&
        appModel.gameData.playingWithAI &&
        appModel.gameData.playerSide == Player.player2) {
      return (7 - (vector2.y / tileSize).floor()) * 8 +
          (7 - (vector2.x / tileSize).floor());
    } else {
      return (vector2.y / tileSize).floor() * 8 +
          (vector2.x / tileSize).floor();
    }
  }

  void _drawBoard(Canvas canvas) {
    for (int tileNo = 0; tileNo < 64; tileNo++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (tileNo % 8) * tileSize,
          (tileNo / 8).floor() * tileSize,
          tileSize,
          tileSize,
        ),
        Paint()
          ..color = (tileNo + (tileNo / 8).floor()) % 2 == 0
              ? appModel.themePrefs.theme.lightTile
              : appModel.themePrefs.theme.darkTile,
      );
    }
  }

  void _drawPieces(Canvas canvas) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece].sprite.render(
            canvas,
            size: Vector2(tileSize - 12, tileSize - 12),
            position: Vector2(
              spriteMap[piece].spriteX + 6,
              spriteMap[piece].spriteY + 6,
            ),
          );
    }
  }

  void _drawMoveHints(Canvas canvas) {
    for (var tile in validMoves) {
      canvas.drawCircle(
        Offset(
          getXFromTile(tile, tileSize, appModel) + (tileSize / 2),
          getYFromTile(tile, tileSize, appModel) + (tileSize / 2),
        ),
        tileSize / 5,
        Paint()..color = appModel.themePrefs.theme.moveHint,
      );
    }
  }

  void _drawLatestMove(Canvas canvas) {
    if (latestMove != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(latestMove.from, tileSize, appModel),
          getYFromTile(latestMove.from, tileSize, appModel),
          tileSize,
          tileSize,
        ),
        Paint()..color = appModel.themePrefs.theme.latestMove,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(latestMove.to, tileSize, appModel),
          getYFromTile(latestMove.to, tileSize, appModel),
          tileSize,
          tileSize,
        ),
        Paint()..color = appModel.themePrefs.theme.latestMove,
      );
    }
  }

  void _drawCheckHint(Canvas canvas) {
    if (checkHintTile != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(checkHintTile, tileSize, appModel),
          getYFromTile(checkHintTile, tileSize, appModel),
          tileSize,
          tileSize,
        ),
        Paint()..color = appModel.themePrefs.theme.checkHint,
      );
    }
  }

  void _drawSelectedPieceHint(Canvas canvas) {
    if (selectedPiece != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(selectedPiece.tile, tileSize, appModel),
          getYFromTile(selectedPiece.tile, tileSize, appModel),
          tileSize,
          tileSize,
        ),
        Paint()..color = appModel.themePrefs.theme.moveHint,
      );
    }
  }
}
