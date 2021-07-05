import 'dart:math';

import 'package:en_passant/logic/constants.dart';
import 'package:en_passant/logic/move_calculation/move_classes.dart';
import 'package:en_passant/logic/player.dart';

import '../chess_board.dart';
import 'move_calculation.dart';

const _INITIAL_ALPHA = -_INITIAL_BETA;
const _INITIAL_BETA = 40000;
const _STALEMATE_ALPHA = _INITIAL_ALPHA ~/ 2;
const _STALEMATE_BETA = _INITIAL_BETA ~/ 2;

Move _alphaBeta(
  ChessBoard board,
  Player player,
  Move move,
  int depth,
  int maxDepth,
  int alpha,
  int beta,
) {
  if (depth == maxDepth) {
    move.meta.value = boardValue(board);
    return move;
  }
  var bestMove = Move.invalidMove();
  bestMove.meta.value = player.isP1 ? _INITIAL_ALPHA : _INITIAL_BETA;
  for (var move in allMoves(player, board, maxDepth)) {
    push(move, board);
    var result = _alphaBeta(
        board, player.opposite, move, depth + 1, maxDepth, alpha, beta);
    pop(board);
    result.setEqualTo(move);
    if (player.isP1) {
      if (result.meta.value > bestMove.meta.value) bestMove = result;
      alpha = max(alpha, bestMove.meta.value);
      if (alpha >= beta) break;
    } else {
      if (result.meta.value < bestMove.meta.value) bestMove = result;
      beta = min(beta, bestMove.meta.value);
      if (beta <= alpha) break;
    }
  }
  if (_isStalemate(bestMove, player, board)) {
    bestMove.meta.value = player.isP1 ? _STALEMATE_ALPHA : _STALEMATE_BETA;
    if (piecesForPlayer(player, board).length == 1) bestMove.meta.value *= -1;
  }
  return bestMove;
}

Move calculateAIMove(Map args) => args[AI_BOARD_ARG].possibleOpenings.isNotEmpty
    ? _openingMove(args[AI_BOARD_ARG], args[AI_PLAYER_ARG])
    : _alphaBeta(args[AI_BOARD_ARG], args[AI_PLAYER_ARG], null, 0,
        args[AI_DIFFICULTY_ARG], _INITIAL_ALPHA, _INITIAL_BETA);

Move _openingMove(ChessBoard board, Player aiPlayer) {
  List<Move> possibleMoves = board.possibleOpenings
      .map((opening) => opening[board.moveCount])
      .toList();
  return possibleMoves[Random.secure().nextInt(possibleMoves.length)];
}

bool _isStalemate(Move bestMove, Player player, ChessBoard board) =>
    bestMove.meta.value.abs() == _INITIAL_BETA && !kingInCheck(player, board);
