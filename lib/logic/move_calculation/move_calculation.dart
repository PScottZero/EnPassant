import 'package:en_passant/logic/move_calculation/move_classes/direction.dart';
import 'package:en_passant/logic/move_calculation/move_classes/move_and_value.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/views/components/chess_view/promotion_dialog.dart';
import 'package:en_passant/views/components/main_menu_view/game_options/side_picker.dart';

import '../chess_board.dart';
import '../chess_piece.dart';
import 'move_classes/move.dart';

const PAWN_DIAGONALS_1 = [DOWN_LEFT, DOWN_RIGHT];
const PAWN_DIAGONALS_2 = [UP_LEFT, UP_RIGHT];
const KNIGHT_MOVES = [
  Direction(1, 2),
  Direction(-1, 2),
  Direction(1, -2),
  Direction(-1, -2),
  Direction(2, 1),
  Direction(-2, 1),
  Direction(2, -1),
  Direction(-2, -1)
];
const BISHOP_MOVES = [UP_RIGHT, DOWN_RIGHT, DOWN_LEFT, UP_LEFT];
const ROOK_MOVES = [UP, RIGHT, DOWN, LEFT];
const KING_QUEEN_MOVES = [
  UP,
  UP_RIGHT,
  RIGHT,
  DOWN_RIGHT,
  DOWN,
  DOWN_LEFT,
  LEFT,
  UP_LEFT
];

List<Move> allMoves(Player player, ChessBoard board, int aiDifficulty) {
  List<MoveAndValue> moves = [];
  var pieces = List.from(piecesForPlayer(player, board));
  for (var piece in pieces) {
    var tiles = movesForPiece(piece, board);
    for (var tile in tiles) {
      if (piece.type == ChessPieceType.pawn &&
          (tileToRow(tile) == 0 || tileToRow(tile) == 7)) {
        for (var promotion in PROMOTIONS) {
          var move =
              MoveAndValue(Move(piece.tile, tile, promotionType: promotion), 0);
          push(move.move, board, promotionType: promotion);
          move.value = boardValue(board);
          pop(board);
          moves.add(move);
        }
      } else {
        var move = MoveAndValue(Move(piece.tile, tile), 0);
        push(move.move, board);
        move.value = boardValue(board);
        pop(board);
        moves.add(move);
      }
    }
  }
  moves.sort((a, b) => _compareMoves(a, b, player, board));
  return moves.map((move) => move.move).toList();
}

int _compareMoves(
    MoveAndValue a, MoveAndValue b, Player player, ChessBoard board) {
  return player == Player.player1
      ? b.value.compareTo(a.value)
      : a.value.compareTo(b.value);
}

List<int> movesForPiece(ChessPiece piece, ChessBoard board,
    {bool legal = true}) {
  List<int> moves;
  switch (piece.type) {
    case ChessPieceType.pawn:
      {
        moves = _pawnMoves(piece, board);
      }
      break;
    case ChessPieceType.knight:
      {
        moves = _knightMoves(piece, board);
      }
      break;
    case ChessPieceType.bishop:
      {
        moves = _bishopMoves(piece, board);
      }
      break;
    case ChessPieceType.rook:
      {
        moves = _rookMoves(piece, board, legal);
      }
      break;
    case ChessPieceType.queen:
      {
        moves = _queenMoves(piece, board);
      }
      break;
    case ChessPieceType.king:
      {
        moves = _kingMoves(piece, board, legal);
      }
      break;
    default:
      {
        moves = [];
      }
  }
  if (legal) {
    moves.removeWhere((move) => _movePutsKingInCheck(piece, move, board));
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
  var diagonals =
      pawn.player == Player.player1 ? PAWN_DIAGONALS_1 : PAWN_DIAGONALS_2;
  for (var diagonal in diagonals) {
    var row = tileToRow(pawn.tile) + diagonal.up;
    var col = tileToCol(pawn.tile) + diagonal.right;
    if (_inBounds(row, col)) {
      var takenPiece = board.tiles[_rowColToTile(row, col)];
      if ((takenPiece != null &&
              takenPiece.player == oppositePlayer(pawn.player)) ||
          _canTakeEnPassant(pawn.player, _rowColToTile(row, col), board)) {
        moves.add(_rowColToTile(row, col));
      }
    }
  }
  return moves;
}

bool _canTakeEnPassant(Player pawnPlayer, int diagonal, ChessBoard board) {
  var offset = (pawnPlayer == Player.player1) ? 8 : -8;
  var takenPiece = board.tiles[diagonal + offset];
  return takenPiece != null &&
      takenPiece.player != pawnPlayer &&
      takenPiece == board.enPassantPiece;
}

List<int> _knightMoves(ChessPiece knight, ChessBoard board) {
  return _movesFromDirections(knight, board, KNIGHT_MOVES, false);
}

List<int> _bishopMoves(ChessPiece bishop, ChessBoard board) {
  return _movesFromDirections(bishop, board, BISHOP_MOVES, true);
}

List<int> _rookMoves(ChessPiece rook, ChessBoard board, bool legal) {
  return _movesFromDirections(rook, board, ROOK_MOVES, true) +
      _rookCastleMove(rook, board, legal);
}

List<int> _queenMoves(ChessPiece queen, ChessBoard board) {
  return _movesFromDirections(queen, board, KING_QUEEN_MOVES, true);
}

List<int> _kingMoves(ChessPiece king, ChessBoard board, bool legal) {
  return _movesFromDirections(king, board, KING_QUEEN_MOVES, false) +
      _kingCastleMoves(king, board, legal);
}

List<int> _rookCastleMove(ChessPiece rook, ChessBoard board, bool legal) {
  if (!legal || !kingInCheck(rook.player, board)) {
    var king = kingForPlayer(rook.player, board);
    if (_canCastle(king, rook, board, legal)) {
      return [king.tile];
    }
  }
  return [];
}

List<int> _kingCastleMoves(ChessPiece king, ChessBoard board, bool legal) {
  List<int> moves = [];
  if (!legal || !kingInCheck(king.player, board)) {
    for (var rook in rooksForPlayer(king.player, board)) {
      if (_canCastle(king, rook, board, legal)) {
        moves.add(rook.tile);
      }
    }
  }
  return moves;
}

bool _canCastle(
    ChessPiece king, ChessPiece rook, ChessBoard board, bool legal) {
  if (rook.moveCount == 0 && king.moveCount == 0) {
    var offset = king.tile - rook.tile > 0 ? 1 : -1;
    var tile = rook.tile;
    while (tile != king.tile) {
      tile += offset;
      if ((board.tiles[tile] != null && tile != king.tile) ||
          (legal && _kingInCheckAtTile(tile, king.player, board))) {
        return false;
      }
    }
    return true;
  }
  return false;
}

List<int> _movesFromDirections(ChessPiece piece, ChessBoard board,
    List<Direction> directions, bool repeat) {
  List<int> moves = [];
  for (var direction in directions) {
    var row = tileToRow(piece.tile);
    var col = tileToCol(piece.tile);
    do {
      row += direction.up;
      col += direction.right;
      if (_inBounds(row, col)) {
        var possiblePiece = board.tiles[_rowColToTile(row, col)];
        if (possiblePiece != null) {
          if (possiblePiece.player != piece.player) {
            moves.add(_rowColToTile(row, col));
          }
          break;
        } else {
          moves.add(_rowColToTile(row, col));
        }
      }
      if (!repeat) {
        break;
      }
    } while (_inBounds(row, col));
  }
  return moves;
}

bool _movePutsKingInCheck(ChessPiece piece, int move, ChessBoard board) {
  push(Move(piece.tile, move), board);
  var check = kingInCheck(piece.player, board);
  pop(board);
  return check;
}

bool _kingInCheckAtTile(int tile, Player player, ChessBoard board) {
  for (var piece in piecesForPlayer(oppositePlayer(player), board)) {
    if (movesForPiece(piece, board, legal: false).contains(tile)) {
      return true;
    }
  }
  return false;
}

bool kingInCheck(Player player, ChessBoard board) {
  for (var piece in piecesForPlayer(oppositePlayer(player), board)) {
    if (movesForPiece(piece, board, legal: false)
        .contains(kingForPlayer(player, board).tile)) {
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

bool _inBounds(int row, int col) {
  return row >= 0 && row < 8 && col >= 0 && col < 8;
}

int _rowColToTile(int row, int col) {
  return row * 8 + col;
}
