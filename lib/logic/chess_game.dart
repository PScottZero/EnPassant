import 'dart:ui';

import 'package:async/async.dart';
import 'package:en_passant/logic/board_renderer.dart';
import 'package:en_passant/logic/move_calculation/ai_move_calculation.dart';
import 'package:en_passant/logic/move_calculation/move_calculation.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/model/player.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'chess_board.dart';
import 'chess_piece.dart';
import 'move_calculation/move_classes.dart';

class ChessGame extends Game with TapDetector {
  AppModel model;
  BoardRenderer renderer;
  ChessBoard board = ChessBoard();

  CancelableOperation aiOperation;
  List<int> validMoves = [];

  ChessGame(this.model, BuildContext context) {
    renderer = BoardRenderer(this, context);
    if (model.gameData.isAIsTurn) _aiMove();
  }

  @override
  void onTapDown(TapDownInfo details) {
    if (model.gameData.gameOver || !(model.gameData.isAIsTurn)) {
      var tile = _vector2ToTile(details.eventPosition.widget);
      var touchedPiece = board.tiles[tile];
      if (touchedPiece == renderer.selectedPiece) {
        validMoves = [];
        renderer.selectedPiece = null;
      } else {
        if (renderer.selectedPiece != null &&
            touchedPiece != null &&
            touchedPiece.player == renderer.selectedPiece.player) {
          if (validMoves.contains(tile)) {
            _movePiece(tile);
          } else {
            validMoves = [];
            _selectPiece(touchedPiece);
          }
        } else if (renderer.selectedPiece == null) {
          _selectPiece(touchedPiece);
        } else {
          _movePiece(tile);
        }
      }
    }
  }

  void _selectPiece(ChessPiece piece) {
    if (piece != null) {
      if (piece.player == model.gameData.turn) {
        renderer.selectedPiece = piece;
        if (renderer.selectedPiece != null) {
          validMoves = movesForPiece(piece, board);
        }
        if (validMoves.isEmpty) {
          renderer.selectedPiece = null;
        }
      }
    }
  }

  void _movePiece(int tile) {
    if (validMoves.contains(tile)) {
      validMoves = [];
      var move = Move(renderer.selectedPiece.tile, tile);
      push(move, board, getMeta: true);
      if (move.meta.flags.promotion) {
        model.gameData.requestPromotion();
      }
      _moveCompletion(move, changeTurn: !move.meta.flags.promotion);
    }
  }

  void _aiMove() async {
    await Future.delayed(Duration(milliseconds: 500));
    var args = Map();
    args['aiPlayer'] = model.gameData.aiTurn;
    args['aiDifficulty'] = model.gameData.aiDifficulty;
    args['board'] = board;
    aiOperation = CancelableOperation.fromFuture(
      compute(calculateAIMove, args),
    );
    aiOperation.value.then((move) {
      if (move == null || model.gameData.gameOver) {
        model.gameData.endGame();
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
      model.gameData.changeTurn();
    }
  }

  void undoTwoMoves() {
    board.redoStack.add(pop(board));
    board.redoStack.add(pop(board));
    model.gameData.jumpToEndOfMoveList();
    if (board.moveStack.length > 1) {
      _moveCompletion(board.moveStack[board.moveStack.length - 2],
          clearRedo: false, undoing: true, changeTurn: false);
    } else {
      _undoOpeningMove();
    }
  }

  void _undoOpeningMove() {
    validMoves = [];
    renderer.selectedPiece = null;
    renderer.latestMove = null;
    renderer.checkHintTile = null;
    model.gameData.jumpToEndOfMoveList();
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
    renderer.latestMove = move;
    renderer.checkHintTile = null;
    var oppositeTurn = model.gameData.turn.opposite;
    if (kingInCheck(oppositeTurn, board)) {
      move.meta.flags.isCheck = true;
      renderer.checkHintTile = kingForPlayer(oppositeTurn, board).tile;
    }
    if (kingInCheckmate(oppositeTurn, board)) {
      if (!move.meta.flags.isCheck) {
        model.gameData.stalemate = true;
        move.meta.flags.isStalemate = true;
      }
      move.meta.flags.isCheck = false;
      move.meta.flags.isCheckmate = true;
      model.gameData.endGame();
    }
    if (undoing) {
      model.gameData.jumpToEndOfMoveList();
      model.gameData.undoEndGame();
    } else if (updateMetaList) {
      model.gameData.jumpToEndOfMoveList();
    }
    if (changeTurn) {
      model.gameData.changeTurn();
    }
    renderer.selectedPiece = null;
    if (model.gameData.isAIsTurn && clearRedo && changeTurn) {
      _aiMove();
    }
  }

  int _vector2ToTile(Vector2 vector2) {
    if (model.flip &&
        model.gameData.playingWithAI &&
        model.gameData.playerSide == Player.player2) {
      return (7 - (vector2.y / renderer.tileSize).floor()) * 8 +
          (7 - (vector2.x / renderer.tileSize).floor());
    } else {
      return (vector2.y / renderer.tileSize).floor() * 8 +
          (vector2.x / renderer.tileSize).floor();
    }
  }

  @override
  void render(Canvas canvas) {
    renderer.render(canvas);
  }

  @override
  void update(double t) {
    renderer.updateSpritePositions();
  }
}
