import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../model/app_model.dart';
import 'ai_move_calculation.dart';
import 'board_renderer.dart';
import 'chess_board.dart';
import 'chess_piece.dart';
import 'constants.dart';
import 'move_calculation.dart';
import 'move_classes.dart';

const _AI_WAIT_TIME_MS = 500;

class ChessGame extends Game with TapDetector {
  AppModel model;
  BuildContext context;
  BoardRenderer renderer;
  ChessBoard board = ChessBoard();

  CancelableOperation aiOperation;
  List<int> validMoves = [];

  bool get noPieceSelected => renderer.selectedPiece == null;

  ChessGame(this.model) {
    renderer = BoardRenderer(
        this, MediaQuery.of(context).size.width - boardSizeAdjust);
    if (model.gameData.isAIsTurn) _aiMove();
  }

  @override
  void onTapDown(TapDownInfo details) {
    if (model.gameData.gameOver || !(model.gameData.isAIsTurn)) {
      var tile = _vector2ToTile(details.eventPosition.widget);
      var touchedPiece = board.tiles[tile];
      if (_touchedSamePiece(touchedPiece)) {
        validMoves = [];
        renderer.selectedPiece = null;
      } else {
        if (_touchedAnotherPiece(touchedPiece)) {
          if (validMoves.contains(tile)) {
            _movePiece(tile);
          } else {
            validMoves = [];
            _selectPiece(touchedPiece);
          }
        } else if (noPieceSelected) {
          _selectPiece(touchedPiece);
        } else {
          _movePiece(tile);
        }
      }
    }
  }

  bool _touchedSamePiece(ChessPiece touchedPiece) =>
      touchedPiece == renderer.selectedPiece;

  bool _touchedAnotherPiece(ChessPiece touchedPiece) =>
      !noPieceSelected &&
      touchedPiece != null &&
      touchedPiece.player == renderer.selectedPiece.player;

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
      push(move, board, getExtraMeta: true);
      if (move.meta.flags.promotion) {
        model.gameData.requestPromotion();
      }
      _moveCompletion(move, changeTurn: !move.meta.flags.promotion);
    }
  }

  void _aiMove() async {
    await Future.delayed(Duration(milliseconds: _AI_WAIT_TIME_MS));
    var args = Map();
    args[AI_PLAYER_ARG] = model.gameData.aiTurn;
    args[AI_DIFFICULTY_ARG] = model.gameData.aiDifficulty;
    args[AI_BOARD_ARG] = board;
    aiOperation = CancelableOperation.fromFuture(
      compute(calculateAIMove, args),
    );
    aiOperation.value.then((move) {
      if (move == null || model.gameData.gameOver) {
        model.gameData.endGame();
      } else {
        validMoves = [];
        push(move, board, getExtraMeta: true);
        _moveCompletion(move, changeTurn: !move.meta.flags.promotion);
        if (move.meta.flags.promotion) {
          promote(move.meta.promotionType);
        }
      }
    });
  }

  void cancelAIMove() {
    if (aiOperation != null) aiOperation.cancel();
  }

  void undoMove() {
    board.redoStack.add(pop(board));
    if (board.moveStack.isNotEmpty) {
      _moveCompletion(
        board.moveStack.last,
        clearRedo: false,
        undoing: true,
      );
    } else {
      _undoOpeningMove();
      model.gameData.changeTurn();
    }
  }

  void undoTwoMoves() {
    board.redoStack.add(pop(board));
    board.redoStack.add(pop(board));
    model.gameData.jumpToEndOfMoveList();
    if (board.moveStack.isNotEmpty) {
      _moveCompletion(
        board.moveStack.last,
        clearRedo: false,
        undoing: true,
        changeTurn: false,
      );
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
    var move = board.redoStack.removeLast();
    push(move, board);
    _moveCompletion(move, clearRedo: false, updateMoveList: true);
  }

  void redoTwoMoves() {
    redoMove();
    redoMove();
  }

  void promote(ChessPieceType type) {
    board.moveStack.last.meta.movedPiece.type = type;
    board.moveStack.last.meta.promotionType = type;
    addPromotedPiece(board, board.moveStack.last);
    _moveCompletion(board.moveStack.last, updateMoveList: false);
  }

  void _moveCompletion(
    Move move, {
    bool clearRedo = true,
    bool undoing = false,
    bool changeTurn = true,
    bool updateMoveList = true,
  }) {
    if (clearRedo) board.redoStack = [];
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
    } else if (updateMoveList) {
      model.gameData.jumpToEndOfMoveList();
    }
    renderer.selectedPiece = null;
    if (changeTurn) model.gameData.changeTurn();
    if (model.gameData.isAIsTurn && clearRedo && changeTurn) _aiMove();
  }

  int _vector2ToTile(Vector2 vector2) {
    if (model.flip &&
        model.gameData.playingWithAI &&
        model.gameData.playerSide.isP2) {
      return ((TILE_COUNT_PER_ROW - 1) -
                  (vector2.y / renderer.tileSize).floor()) *
              TILE_COUNT_PER_ROW +
          ((TILE_COUNT_PER_ROW - 1) - (vector2.x / renderer.tileSize).floor());
    } else {
      return (vector2.y / renderer.tileSize).floor() * TILE_COUNT_PER_ROW +
          (vector2.x / renderer.tileSize).floor();
    }
  }

  @override
  void render(Canvas canvas) => renderer.render(canvas);

  @override
  void update(double t) => renderer.updateSpritePositions();
}
