import 'package:en_passant/logic/constants.dart';
import 'package:en_passant/logic/player.dart';
import 'package:en_passant/views/chess_view/components/promotion_dialog.dart';

import '../chess_board.dart';
import '../chess_piece.dart';
import 'move_classes.dart';

const CASTLE_PIECES = [ChessPieceType.rook, ChessPieceType.king];
const _MOVE_FUNCTIONS = <ChessPieceType, Function>{
  ChessPieceType.pawn: _pawnMoves,
  ChessPieceType.knight: _knightMoves,
  ChessPieceType.bishop: _bishopMoves,
  ChessPieceType.rook: _rookMoves,
  ChessPieceType.queen: _queenMoves,
  ChessPieceType.king: _kingMoves
};

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
  List<Move> moves = [];
  var pieces = List.from(piecesForPlayer(player, board));
  for (var piece in pieces) {
    var tiles = movesForPiece(piece, board);
    for (var tile in tiles) {
      if (_canPromote(piece, tile)) {
        for (var promotion in PROMOTIONS) {
          var move = Move(piece.tile, tile);
          move.meta.promotionType = promotion;
          push(move, board);
          move.meta.value = boardValue(board);
          pop(board);
          moves.add(move);
        }
      } else {
        var move = Move(piece.tile, tile);
        push(move, board);
        move.meta.value = boardValue(board);
        pop(board);
        moves.add(move);
      }
    }
  }
  moves.sort((a, b) => _compareMoves(a, b, player));
  return moves;
}

List<int> movesForPiece(
  ChessPiece piece,
  ChessBoard board, {
  bool legal = true,
}) {
  List<int> moves = equalToAny<ChessPieceType>(piece.type, CASTLE_PIECES)
      ? _MOVE_FUNCTIONS[piece.type](piece, board, legal)
      : _MOVE_FUNCTIONS[piece.type](piece, board);
  if (legal)
    moves.removeWhere((move) => _movePutsKingInCheck(piece, move, board));
  return moves;
}

List<int> _pawnMoves(ChessPiece pawn, ChessBoard board) {
  List<int> moves = [];
  var offset = pawn.player.isP1 ? -TILE_COUNT_PER_ROW : TILE_COUNT_PER_ROW;
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
  var diagonals = pawn.player.isP1 ? PAWN_DIAGONALS_1 : PAWN_DIAGONALS_2;
  for (var diagonal in diagonals) {
    var row = tileToRow(pawn.tile) + diagonal.up;
    var col = tileToCol(pawn.tile) + diagonal.right;
    if (_inBounds(row, col)) {
      var takenPiece = board.tiles[_rowColToTile(row, col)];
      if ((takenPiece != null && takenPiece.player == pawn.player.opposite) ||
          _canTakeEnPassant(pawn.player, _rowColToTile(row, col), board)) {
        moves.add(_rowColToTile(row, col));
      }
    }
  }
  return moves;
}

bool _canTakeEnPassant(Player pawnPlayer, int diagonal, ChessBoard board) {
  var offset = pawnPlayer.isP1 ? TILE_COUNT_PER_ROW : -TILE_COUNT_PER_ROW;
  var takenPiece = board.tiles[diagonal + offset];
  return takenPiece != null &&
      takenPiece.player != pawnPlayer &&
      takenPiece == board.enPassantPiece;
}

List<int> _knightMoves(ChessPiece knight, ChessBoard board) =>
    _movesFromDirections(knight, board, KNIGHT_MOVES, false);

List<int> _bishopMoves(ChessPiece bishop, ChessBoard board) =>
    _movesFromDirections(bishop, board, BISHOP_MOVES, true);

List<int> _rookMoves(ChessPiece rook, ChessBoard board, bool legal) =>
    _movesFromDirections(rook, board, ROOK_MOVES, true) +
    _rookCastleMove(rook, board, legal);

List<int> _queenMoves(ChessPiece queen, ChessBoard board) =>
    _movesFromDirections(queen, board, KING_QUEEN_MOVES, true);

List<int> _kingMoves(ChessPiece king, ChessBoard board, bool legal) =>
    _movesFromDirections(king, board, KING_QUEEN_MOVES, false) +
    _kingCastleMoves(king, board, legal);

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
  ChessPiece king,
  ChessPiece rook,
  ChessBoard board,
  bool legal,
) {
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

List<int> _movesFromDirections(
  ChessPiece piece,
  ChessBoard board,
  List<Direction> directions,
  bool repeat,
) {
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
  for (var piece in piecesForPlayer(player.opposite, board)) {
    if (movesForPiece(piece, board, legal: false).contains(tile)) return true;
  }
  return false;
}

bool kingInCheck(Player player, ChessBoard board) {
  for (var piece in piecesForPlayer(player.opposite, board)) {
    if (movesForPiece(piece, board, legal: false)
        .contains(kingForPlayer(player, board).tile)) return true;
  }
  return false;
}

bool kingInCheckmate(Player player, ChessBoard board) {
  for (var piece in piecesForPlayer(player, board)) {
    if (movesForPiece(piece, board).isNotEmpty) return false;
  }
  return true;
}

bool _inBounds(int row, int col) =>
    row >= MIN_DIM_INDEX &&
    row <= MAX_DIM_INDEX &&
    col >= MIN_DIM_INDEX &&
    col <= MAX_DIM_INDEX;

int _rowColToTile(int row, int col) => row * TILE_COUNT_PER_ROW + col;

bool _canPromote(ChessPiece piece, int tile) =>
    piece.isPawn && equalToAny<int>(tileToRow(tile), END_TILE_INDICES);

int _compareMoves(Move a, Move b, Player player) => player.isP1
    ? b.meta.value.compareTo(a.meta.value)
    : a.meta.value.compareTo(b.meta.value);
