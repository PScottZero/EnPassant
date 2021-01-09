import 'dart:math';

import 'package:en_passant/views/components/main_menu_view/ai_difficulty_picker.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flutter/cupertino.dart';

import 'chess_board.dart';
import 'move_calculation.dart';
import 'shared_functions.dart';
import 'move_classes.dart';

const INITIAL_ALPHA = -20000;
const INITIAL_BETA = 20000;

class AIMoveCalculation {
  static Future<Move> move({
    @required PlayerID aiPlayer,
    @required AIDifficulty aiDifficulty,
    @required ChessBoard board
  }) async {
    return await minMaxStart(
      aiPlayer: aiPlayer,
      aiDifficulty: aiDifficulty,
      board: board
    );
  }

  static Future<Move> minMaxStart({
    @required PlayerID aiPlayer,
    @required AIDifficulty aiDifficulty,
    @required ChessBoard board
  }) async {
    var moves = getInitialMoves(aiPlayer: aiPlayer, board: board);
    if (moves.isEmpty) {
      return Move(from: Tile(row: -1, col: -1), to: Tile(row: -1, col: -1));
    } else {
      List<Future<int>> futures = [];
      for (var move in moves) {
        var boardCopy = board.copy();
        boardCopy.movePiece(from: move.from, to: move.to);
        futures.add(alphaBeta(
          board: boardCopy,
          player: SharedFunctions.oppositePlayer(aiPlayer),
          depth: 1,
          maxDepth: maxDepth(aiDifficulty),
          alpha: INITIAL_ALPHA,
          beta: INITIAL_BETA,
        ));
      }
      List<int> values = await Future.wait(futures);
      List<MoveAndValue> movesAndValues = [];
      for (var index = 0; index < values.length; index++) {
        movesAndValues.add(
          MoveAndValue(move: moves[index], value: values[index])
        );
      }
      movesAndValues.shuffle();
      if (aiPlayer == PlayerID.player1) {
        MoveAndValue bestMove;
        for (var moveAndValue in movesAndValues) {
          if (bestMove == null || moveAndValue.value > bestMove.value) {
            bestMove = moveAndValue;
          }
        }
        return bestMove.move;
      } else {
        MoveAndValue bestMove;
        for (var moveAndValue in movesAndValues) {
          if (bestMove == null || moveAndValue.value < bestMove.value) {
            bestMove = moveAndValue;
          }
        }
        return bestMove.move;
      }
    }
  }

  static Future<int> alphaBeta({
    @required ChessBoard board,
    @required PlayerID player,
    @required int depth,
    @required int maxDepth,
    @required int alpha,
    @required int beta
  }) async {
    if (depth == maxDepth) {
      return board.value;
    }
    if (player == PlayerID.player1) {
      int bestValue = INITIAL_ALPHA;
      outerLoop: for (var piece in board.piecesForPlayer(player)) {
        for (var move in MoveCalculation.movesFor(piece: piece, board: board)) {
          var boardCopy = board.copy();
          boardCopy.movePiece(from: piece.tile, to: move);
          bestValue = max(bestValue, await alphaBeta(
            board: boardCopy,
            player: PlayerID.player2,
            depth: depth + 1,
            maxDepth: maxDepth,
            alpha: alpha,
            beta: beta
          ));
          alpha = max(alpha, bestValue);
          if (alpha >= beta) {
            break outerLoop;
          }
        }
      }
      return bestValue;
    } else {
      int bestValue = INITIAL_BETA;
      outerLoop: for (var piece in board.piecesForPlayer(player)) {
        for (var move in MoveCalculation.movesFor(piece: piece, board: board)) {
          var boardCopy = board.copy();
          boardCopy.movePiece(from: piece.tile, to: move);
          bestValue = min(bestValue, await alphaBeta(
            board: boardCopy,
            player: PlayerID.player1,
            depth: depth + 1,
            maxDepth: maxDepth,
            alpha: alpha,
            beta: beta
          ));
          beta = min(beta, bestValue);
          if (beta <= alpha) {
            break outerLoop;
          }
        }
      }
      return bestValue;
    }
  }

  static List<Move> getInitialMoves({
    @required PlayerID aiPlayer,
    @required ChessBoard board
  }) {
    List<Move> allMoves = [];
    for (var piece in board.piecesForPlayer(aiPlayer)) {
      for (var move in MoveCalculation.movesFor(piece: piece, board: board)) {
        allMoves.add(Move(from: piece.tile, to: move));
      }
    }
    return allMoves;
  }

  static int maxDepth(AIDifficulty aiDifficulty) {
    switch (aiDifficulty) {
      case AIDifficulty.easy: { return 1; }
      case AIDifficulty.normal: { return 2; }
      case AIDifficulty.hard: { return 3; }
      case AIDifficulty.master: { return 4; }
      default: { return 0; }
    }
  }
}
