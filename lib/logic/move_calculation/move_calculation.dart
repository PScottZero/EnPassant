import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';

import '../chess_board.dart';
import '../chess_piece.dart';

enum Direction {
  up, upright, right, downright, down, downleft, left, upleft,
  knight1, knight2, knight3, knight4, knight5, knight6, knight7, knight8
}

List<int> movesForPiece(ChessPiece piece, ChessBoard board, {bool legal = true}) {
  List<int> moves;
  switch (piece.type) {
    case ChessPieceType.pawn: { moves = _pawnMoves(piece, board); }
    break;
    case ChessPieceType.knight: { moves = _knightMoves(piece, board); }
    break;
    case ChessPieceType.bishop: { moves = _bishopMoves(piece, board); }
    break;
    case ChessPieceType.rook: { moves = _rookMoves(piece, board); }
    break;
    case ChessPieceType.queen: { moves = _queenMoves(piece, board); }
    break;
    case ChessPieceType.king: { moves = _kingMoves(piece, board); }
    break;
    default: { moves = []; }
  }
  return moves;
}

List<int> _pawnMoves(ChessPiece pawn, ChessBoard board) {

}

List<int> _knightMoves(ChessPiece knight, ChessBoard board) {
  return _movesFromOffsets(knight, board,
    [-6, 6, -10, 10, -15, 15, -17, 17], false);
}

List<int> _bishopMoves(ChessPiece bishop, ChessBoard board) {
  return _movesFromOffsets(bishop, board, [-7, 7, -9, 9], true);
}

List<int> _rookMoves(ChessPiece rook, ChessBoard board) {
  return _movesFromOffsets(rook, board, [-1, 1, -8, 8], true) +
    _rookCastleMove(rook, board);
}

List<int> _queenMoves(ChessPiece queen, ChessBoard board) {
  return _movesFromOffsets(queen, board, [-1, 1, -7, 7, -8, 8, -9, 9], true);
}

List<int> _kingMoves(ChessPiece king, ChessBoard board) {
  return _movesFromOffsets(king, board, [-1, 1, -7, 7, -8, 8, -9, 9], false) +
    _kingCastleMoves(king, board);
}

List<int> _rookCastleMove(ChessPiece rook, ChessBoard board) {
  if (!kingInCheck(rook.player, board)) {
    var king = kingForPlayer(rook.player, board);
    if (_canCastle(king, rook, board)) {
      return [king.tile];
    }
  }
  return [];
}

List<int> _kingCastleMoves(ChessPiece king, ChessBoard board) {
  List<int> moves = [];
  if (!kingInCheck(king.player, board)) {
    for (var rook in rooksForPlayer(king.player, board)) {
      if (_canCastle(king, rook, board)) {
        moves.add(rook.tile);
      }
    }
  }
  return [];
}

bool _canCastle(ChessPiece king, ChessPiece rook, ChessBoard board) {
  if (!rook.hasMoved && !king.hasMoved) {
    var offset = king.tile - rook.tile > 0 ? 1 : -1;
    var tile = rook.tile;
    while (tile != king.tile) {
      tile += offset;
      if (board.tiles[tile] != null && tile != king.tile) {
        return false;
      }
    }
  }
  return true;
}

List<int> _movesFromOffsets(
  ChessPiece piece, ChessBoard board, List<int> offsets, bool repeat
) {
  List<int> moves = [];
  for (var offset in offsets) {
    var tile = piece.tile;
    while (tileInBounds(tile)) {
      tile += offset;
      if (tileInBounds(tile)) {
        var possiblePiece = board.tiles[tile];
        if (possiblePiece != null) {
          if (possiblePiece.player != piece.player) {
            moves.add(tile);
          }
          break;
        } else {
          moves.add(tile);
        }
      }
      if (!repeat) {
        break;
      }
    }
  }
  return moves;
}

List<ChessPiece> piecesForPlayer(Player player, ChessBoard board) {
  return player == Player.player1 ? board.player1Pieces : board.player2Pieces;
}

ChessPiece kingForPlayer(Player player, ChessBoard board) {
  return player == Player.player1 ? board.player1King : board.player2King;
}

List<ChessPiece> queensForPlayer(Player player, ChessBoard board) {
  return player == Player.player1 ? board.player1Queens : board.player2Queens;
}

List<ChessPiece> rooksForPlayer(Player player, ChessBoard board) {
  return player == Player.player1 ? board.player1Rooks : board.player2Rooks;
}

bool kingInCheck(Player player, ChessBoard board) {
  return player == Player.player1 ? board.player1KingInCheck :
    board.player2KingInCheck;
}
