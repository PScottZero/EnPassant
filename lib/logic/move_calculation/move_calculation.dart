import 'package:en_passant/logic/move_calculation/move_classes/move_and_value.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';

import '../chess_board.dart';
import '../chess_piece.dart';
import 'move_classes/move.dart';

List<Move> allMoves(Player player, ChessBoard board) {
  List<MoveAndValue> moves = [];
  for (var piece in List.from(piecesForPlayer(player, board))) {
    var tiles = movesForPiece(piece, board);
    for (var tile in tiles) {
      var move = MoveAndValue(Move(piece, tile), 0);
      push(move.move, board);
      move.value = boardValue(board);
      pop(board);
      moves.add(move);
    }
  }
  moves.sort((a, b) => compareMoves(a, b, player, board));
  return moves.map((move) => move.move);
}

int compareMoves(MoveAndValue a, MoveAndValue b, Player player, ChessBoard board) {
  return player == Player.player1 ?
    b.value.compareTo(a.value) : a.value.compareTo(b.value);
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
    case ChessPieceType.rook: { moves = _rookMoves(piece, board, legal); }
    break;
    case ChessPieceType.queen: { moves = _queenMoves(piece, board); }
    break;
    case ChessPieceType.king: { moves = _kingMoves(piece, board, legal); }
    break;
    default: { moves = []; }
  }
  if (legal) {
    moves.removeWhere((move) => movePutsKingInCheck(piece, move, board));
  }
  return moves;
}

List<int> _pawnMoves(ChessPiece pawn, ChessBoard board) {
  List<int> moves = [];
  var offset = pawn.player == Player.player1 ? -8 : 8;
  var firstTile = pawn.tile + offset;
  if (board.tiles[firstTile] == null) {
    moves.add(firstTile);
    if (pawn.moveCount == 0) {
      var secondTile = firstTile + offset;
      if (board.tiles[secondTile] == null) {
        moves.add(secondTile);
      }
    }
  }
  return moves + _pawnDiagonalAttacks(pawn, board);
}

List<int> _pawnDiagonalAttacks(ChessPiece pawn, ChessBoard board) {
  List<int> moves = [];
  var diagonals = pawn.player == Player.player1 ? 
    [pawn.tile - 7, pawn.tile - 9] : [pawn.tile + 7, pawn.tile + 9];
  for (var diagonal in diagonals) {
    var takenPiece = board.tiles[diagonal];
    if (takenPiece != null && takenPiece.player == oppositePlayer(pawn.player)) {
      moves.add(diagonal);
    }
  }
  return moves;
}

List<int> _knightMoves(ChessPiece knight, ChessBoard board) {
  return _movesFromOffsets(knight, board,
    [-6, 6, -10, 10, -15, 15, -17, 17], false);
}

List<int> _bishopMoves(ChessPiece bishop, ChessBoard board) {
  return _movesFromOffsets(bishop, board, [-7, 7, -9, 9], true);
}

List<int> _rookMoves(ChessPiece rook, ChessBoard board, bool legal) {
  return _movesFromOffsets(rook, board, [-1, 1, -8, 8], true) +
    _rookCastleMove(rook, board, legal);
}

List<int> _queenMoves(ChessPiece queen, ChessBoard board) {
  return _movesFromOffsets(queen, board, [-1, 1, -7, 7, -8, 8, -9, 9], true);
}

List<int> _kingMoves(ChessPiece king, ChessBoard board, bool legal) {
  return _movesFromOffsets(king, board, [-1, 1, -7, 7, -8, 8, -9, 9], false) +
    _kingCastleMoves(king, board, legal);
}

List<int> _rookCastleMove(ChessPiece rook, ChessBoard board, bool legal) {
  if (!legal || !kingInCheck(rook.player, board)) {
    var king = kingForPlayer(rook.player, board);
    if (_canCastle(king, rook, board)) {
      return [king.tile];
    }
  }
  return [];
}

List<int> _kingCastleMoves(ChessPiece king, ChessBoard board, bool legal) {
  List<int> moves = [];
  if (!legal || !kingInCheck(king.player, board)) {
    for (var rook in rooksForPlayer(king.player, board)) {
      if (_canCastle(king, rook, board)) {
        moves.add(rook.tile);
      }
    }
  }
  return [];
}

bool _canCastle(ChessPiece king, ChessPiece rook, ChessBoard board) {
  if (rook.moveCount == 0 && king.moveCount == 0) {
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

bool movePutsKingInCheck(ChessPiece piece, int move, ChessBoard board) {
  push(Move(piece, move), board);
  var check = kingInCheck(piece.player, board);
  pop(board);
  return check;
}

bool kingInCheck(Player player, ChessBoard board) {
  for (var piece in piecesForPlayer(oppositePlayer(player), board)) {
    if (movesForPiece(piece, board, legal: false).contains(kingForPlayer(player, board).tile)) {
      return true;
    }
  }
  return false;
}

bool kingInCheckmate(Player player, ChessBoard board) {
  for (var piece in piecesForPlayer(player, board)) {
    if (movesForPiece(piece, board).isNotEmpty) {
      return false;
    }
  }
  return true;
}

bool tileIsOnEdge(int tile) {
  return (tile >= 52 && tile < 64) || (tile >= 0 && tile < 8) ||
    (tile % 8 == 0) || (tile % 8 == 7);
}
