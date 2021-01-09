import 'dart:math';

import 'package:en_passant/logic/move_calculation/move_classes/piece_move_value.dart';
import 'package:en_passant/views/components/main_menu_view/ai_difficulty_picker.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';

import '../chess_board.dart';
import 'move_calculation.dart';
import '../shared_functions.dart';

const INITIAL_ALPHA = -20000;
const INITIAL_BETA = 20000;

class AIMoveCalculation {
  static PieceMoveValue move(Player aiPlayer, AIDifficulty aiDifficulty,
    ChessBoard board) {
    return _alphaBeta(
      board, aiPlayer, null, 0,
      _maxDepth(aiDifficulty), INITIAL_ALPHA, INITIAL_BETA
    );
  }

  static PieceMoveValue _alphaBeta(ChessBoard board, Player player, PieceMoveValue pmv,
    int depth, int maxDepth, int alpha, int beta) {
    if (depth == maxDepth) {
      pmv.value = boardValue(board);
      return pmv;
    }
    var bestMove = PieceMoveValue(null, -1, 
      value: player == Player.player1 ? INITIAL_ALPHA : INITIAL_BETA);
    for (var possibleMove in allMoves(player, board)) {
      push(possibleMove.piece, possibleMove.tile, board);
      var result = _alphaBeta(
        board, oppositePlayer(player), possibleMove,
        depth + 1, maxDepth, alpha, beta
      );
      result.tile = possibleMove.tile;
      pop(board);
      if (player == Player.player1) {
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
