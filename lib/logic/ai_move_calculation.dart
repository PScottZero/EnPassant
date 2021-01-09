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
    return _alphaBeta(
      board, aiPlayer, Move.invalid(), 0,
      _maxDepth(aiDifficulty), INITIAL_ALPHA, INITIAL_BETA
    ).move;
  }

  static MoveAndValue _alphaBeta(ChessBoard board, PlayerID player, Move move,
    int depth, int maxDepth, int alpha, int beta) {
    if (depth == maxDepth) {
      return MoveAndValue(move, board.value);
    }
    var bestMove = MoveAndValue(Move.invalid(),
      player == PlayerID.player1 ? INITIAL_ALPHA : INITIAL_BETA);
    outerLoop: for (var piece in board.piecesForPlayer(player)) {
      for (var tile in MoveCalculation.movesFor(piece: piece, board: board)) {
        var move = Move(piece.tile, tile);
        var boardCopy = board.copy();
        boardCopy.movePiece(from: move.from, to: move.to);
        var result = _alphaBeta(
          boardCopy, SharedFunctions.oppositePlayer(player), move,
          depth + 1, maxDepth, alpha, beta);
        result.move = move;
        if (player == PlayerID.player1) {
          if (result.value > bestMove.value) { bestMove = result; }
          alpha = max(alpha, bestMove.value);
          if (alpha >= beta) { break outerLoop; }
        } else {
          if (result.value < bestMove.value) { bestMove = result; }
          beta = min(beta, bestMove.value);
          if (beta <= alpha) { break outerLoop; }
        }
      }
    }
    return bestMove;
  }

  static int _maxDepth(AIDifficulty aiDifficulty) {
    switch (aiDifficulty) {
      case AIDifficulty.easy: { return 2; }
      case AIDifficulty.normal: { return 3; }
      case AIDifficulty.hard: { return 4; }
      default: { return 0; }
    }
  }
}
