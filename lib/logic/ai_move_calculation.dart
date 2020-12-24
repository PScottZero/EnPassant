import 'dart:math';

import 'package:en_passant/views/components/main_menu_view/piece_color_picker.dart';

import 'chess_board.dart';
import 'move_calculation.dart';
import 'shared_functions.dart';
import 'move_classes.dart';

const INITIAL_ALPHA = -10000;
const INITIAL_BETA = 10000;

class AIMoveCalculation {
  static int aiDifficulty = 2;
  static PlayerID aiPlayer = PlayerID.player2;

  static Future<Move> move({PlayerID aiPlayer, int aiDifficulty, ChessBoard board}) async {
    AIMoveCalculation.aiPlayer = aiPlayer;
    AIMoveCalculation.aiDifficulty = aiDifficulty;
    return minMaxStart(aiPlayer: aiPlayer, board: board);
  }

  static Future<Move> minMaxStart({PlayerID aiPlayer, ChessBoard board}) async {
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
          alpha: INITIAL_ALPHA,
          beta: INITIAL_BETA,
        ));
      }
      List<int> values = await Future.wait(futures);
      List<MoveAndValue> movesAndValues = [];
      for (var index = 0; index < values.length; index++) {
        movesAndValues.add(MoveAndValue(move: moves[index], value: values[index]));
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
    ChessBoard board,
    PlayerID player,
    int depth,
    int alpha,
    int beta
  }) async {
    if (depth == aiDifficulty) {
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

  static List<Move> getInitialMoves({PlayerID aiPlayer, ChessBoard board}) {
    List<Move> allMoves = [];
    for (var piece in board.piecesForPlayer(aiPlayer)) {
      for (var move in MoveCalculation.movesFor(piece: piece, board: board)) {
        allMoves.add(Move(from: piece.tile, to: move));
      }
    }
    return allMoves;
  }
}
