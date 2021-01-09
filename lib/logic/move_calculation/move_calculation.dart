import 'package:en_passant/logic/shared_functions.dart';

import '../chess_board.dart';
import '../chess_piece.dart';

enum Direction {
  up, upright, right, downright, down, downleft, left, upleft,
  knight1, knight2, knight3, knight4, knight5, knight6, knight7, knight8
}

List<int> movesForPiece(ChessPiece piece, ChessBoard board, {bool legal = true}) {
  List<int> moves;
  switch (piece.type) {
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

List<int> _knightMoves(ChessPiece knight, ChessBoard board) {
  return _kingKnightPawnHelper(knight, board, [-6, 6, -10, 10, -15, 15, -17, 17]);
}

List<int> _bishopMoves(ChessPiece bishop, ChessBoard board) {
  return _bishopQueenRookHelper(bishop, board, [-7, 7, -9, 9]);
}

List<int> _rookMoves(ChessPiece rook, ChessBoard board) {
  return _bishopQueenRookHelper(rook, board, [-1, 1, -8, 8]);
}

List<int> _queenMoves(ChessPiece queen, ChessBoard board) {
  return _bishopQueenRookHelper(queen, board, [-1, 1, -7, 7, -8, 8, -9, 9]);
}

List<int> _kingMoves(ChessPiece king, ChessBoard board) {
  return _kingKnightPawnHelper(king, board, [-1, 1, -7, 7, -8, 8, -9, 9]);
}

List<int> _kingKnightPawnHelper(ChessPiece piece, ChessBoard board, List<int> offsets) {
  List<int> moves = [];
  for (var offset in offsets) {
    var tile = piece.tile + offset;
    if (tileInBounds(tile)) {
      var possiblePiece = board.tiles[tile];
      if (possiblePiece == null ||
        (board.tiles[tile].player != piece.player &&
        piece.type != ChessPieceType.pawn)) {
        moves.add(tile);
      }
    }
  }
  return moves;
}

List<int> _bishopQueenRookHelper(ChessPiece piece, ChessBoard board, List<int> offsets) {
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
    }
  }
  return moves;
}