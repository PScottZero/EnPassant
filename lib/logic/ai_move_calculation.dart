import 'dart:math';

import 'chess_board.dart';
import 'constants.dart';
import 'move_calculation.dart';
import 'move_classes.dart';
import 'player.dart';

const initialAlpha = -initialBeta;
const initialBeta = 40000;
const stalemateAlpha = initialAlpha ~/ 2;
const stalemateBeta = initialBeta ~/ 2;

Move? _alphaBeta(
  ChessBoard board,
  Player player,
  Move? move,
  int depth,
  int maxDepth,
  int alpha,
  int beta,
) {
  if (depth == maxDepth) {
    move?.meta.value = boardValue(board);
    return move;
  }
  var bestMove = Move.invalidMove();
  bestMove.meta.value = player.isP1 ? initialAlpha : initialBeta;
  for (var move in allMoves(player, board, maxDepth)) {
    push(move, board);
    var result = _alphaBeta(
      board,
      player.opposite,
      move,
      depth + 1,
      maxDepth,
      alpha,
      beta,
    )!;
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
    bestMove.meta.value = player.isP1 ? stalemateAlpha : stalemateBeta;
    if (piecesForPlayer(player, board).length == 1) bestMove.meta.value *= -1;
  }
  return bestMove;
}

Move calculateAIMove(Map args) => args[aiBoardArg].possibleOpenings.isNotEmpty
    ? _openingMove(args[aiBoardArg], args[aiPlayerArg])
    : _alphaBeta(
        args[aiBoardArg],
        args[aiPlayerArg],
        null,
        0,
        args[aiDifficultyArg],
        initialAlpha,
        initialBeta,
      )!;

Move _openingMove(ChessBoard board, Player aiPlayer) {
  List<Move> possibleMoves = board.possibleOpenings
      .map((opening) => opening[board.moveCount])
      .toList();
  return possibleMoves[Random.secure().nextInt(possibleMoves.length)];
}

bool _isStalemate(Move bestMove, Player player, ChessBoard board) =>
    bestMove.meta.value.abs() == initialBeta && !kingInCheck(player, board);
