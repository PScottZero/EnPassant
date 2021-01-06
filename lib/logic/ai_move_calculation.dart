import 'dart:math';

import 'package:en_passant/views/components/main_menu_view/ai_difficulty_picker.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';

import 'chess_board.dart';
import 'move_calculation.dart';
import 'shared_functions.dart';
import 'move_classes.dart';

const INITIAL_ALPHA = -20000;
const INITIAL_BETA = 20000;

class AIMoveCalculation {
  static Move move(PlayerID aiPlayer, AIDifficulty aiDifficulty,
    ChessBoard board) {
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
    for (var possibleMove in MoveCalculation.allMoves(player, board)) {
      board.push(possibleMove);
      var result = _alphaBeta(
        board, SharedFunctions.oppositePlayer(player), possibleMove,
        depth + 1, maxDepth, alpha, beta
      );
      result.move = possibleMove;
      board.pop();
      if (player == PlayerID.player1) {
        if (result.value > bestMove.value) { bestMove = result; }
        alpha = max(alpha, bestMove.value);
        if (alpha >= beta) { break; }
      } else {
        if (result.value < bestMove.value) { bestMove = result; }
        beta = min(beta, bestMove.value);
        if (beta <= alpha) { break; }
      }
    }
    return bestMove;
  }

  static int _maxDepth(AIDifficulty aiDifficulty) {
    switch (aiDifficulty) {
      case AIDifficulty.easy: { return 1; }
      case AIDifficulty.normal: { return 3; }
      case AIDifficulty.hard: { return 5; }
      default: { return 0; }
    }
  }
}
