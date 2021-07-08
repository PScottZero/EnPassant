import 'chess_piece.dart';
import 'constants.dart';
import 'move_calculation.dart';
import 'move_classes.dart';
import 'openings.dart';
import 'piece_square_tables.dart';
import 'player.dart';

const KING_ROW_PIECES = [
  ChessPieceType.rook,
  ChessPieceType.knight,
  ChessPieceType.bishop,
  ChessPieceType.queen,
  ChessPieceType.king,
  ChessPieceType.bishop,
  ChessPieceType.knight,
  ChessPieceType.rook
];

class ChessBoard {
  List<ChessPiece> tiles = List.filled(TILE_COUNT, null);
  List<Move> moveStack = [];
  List<Move> redoStack = [];
  List<ChessPiece> player1Pieces = [];
  List<ChessPiece> player2Pieces = [];
  List<ChessPiece> player1Rooks = [];
  List<ChessPiece> player2Rooks = [];
  List<ChessPiece> player1Queens = [];
  List<ChessPiece> player2Queens = [];
  ChessPiece player1King;
  ChessPiece player2King;
  ChessPiece enPassantPiece;
  bool player1KingInCheck = false;
  bool player2KingInCheck = false;
  List<List<Move>> possibleOpenings = List.from(openings);
  int moveCount = 0;

  ChessBoard() {
    _addPiecesForPlayer(Player.player1);
    _addPiecesForPlayer(Player.player2);
  }

  void _addPiecesForPlayer(Player player) {
    var kingRowOffset = player.isP1 ? TILE_COUNT - TILE_COUNT_PER_ROW : 0;
    var pawnRowOffset = player.isP1 ? -TILE_COUNT_PER_ROW : TILE_COUNT_PER_ROW;
    var index = 0;
    for (var pieceType in KING_ROW_PIECES) {
      var piece = ChessPiece(pieceType, player, kingRowOffset + index);
      var pawn = ChessPiece(
        ChessPieceType.pawn,
        player,
        kingRowOffset + pawnRowOffset + index,
      );
      _setTile(piece.tile, piece, this);
      _setTile(pawn.tile, pawn, this);
      piecesForPlayer(player, this).addAll([piece, pawn]);
      if (piece.isKing) {
        player.isP1 ? player1King = piece : player2King = piece;
      } else if (piece.isQueen) {
        _queensForPlayer(player, this).add(piece);
      } else if (piece.isRook) {
        rooksForPlayer(player, this).add(piece);
      }
      index++;
    }
  }
}

int boardValue(ChessBoard board) {
  int value = 0;
  for (var piece in board.player1Pieces + board.player2Pieces) {
    value += piece.value + squareValue(piece, _inEndGame(board));
  }
  return value;
}

void push(Move move, ChessBoard board, {bool getExtraMeta = false}) {
  move.meta.movedPiece = board.tiles[move.from];
  move.meta.takenPiece = board.tiles[move.to];
  move.meta.enPassantPiece = board.enPassantPiece;
  move.meta.possibleOpenings = board.possibleOpenings;
  if (board.possibleOpenings.isNotEmpty) _filterPossibleOpenings(board, move);
  if (getExtraMeta) _checkMoveAmbiguity(move, board);
  if (_castled(move.meta.movedPiece, move.meta.takenPiece)) {
    _castle(board, move);
  } else {
    _standardMove(board, move);
    if (move.meta.movedPiece.isPawn) {
      if (_canBePromoted(move.meta.movedPiece)) _promote(board, move);
      _checkEnPassant(board, move);
    }
  }
  board.enPassantPiece =
      _canTakeEnPassant(move.meta.movedPiece) ? move.meta.movedPiece : null;
  if ((move.meta.movedPiece.isPawn || move.meta.movedPiece.needsPromotion) &&
      move.meta.flags.took) {
    move.meta.flags.rowIsAmbiguous = true;
  }
  board.moveStack.add(move);
  board.moveCount++;
}

Move pop(ChessBoard board) {
  var move = board.moveStack.removeLast();
  board.enPassantPiece = move.meta.enPassantPiece;
  board.possibleOpenings = move.meta.possibleOpenings;
  if (move.meta.flags.castled) {
    _undoCastle(board, move);
  } else {
    _undoStandardMove(board, move);
    if (move.meta.flags.promotion) {
      _undoPromote(board, move);
    }
    if (move.meta.flags.enPassant) {
      _addPiece(move.meta.enPassantPiece, board);
      _setTile(move.meta.enPassantPiece.tile, move.meta.enPassantPiece, board);
    }
  }
  board.moveCount--;
  return move;
}

void _standardMove(ChessBoard board, Move move) {
  _setTile(move.to, move.meta.movedPiece, board);
  _setTile(move.from, null, board);
  move.meta.movedPiece.moveCount++;
  if (move.meta.takenPiece != null) {
    _removePiece(move.meta.takenPiece, board);
    move.meta.flags.took = true;
  }
}

void _undoStandardMove(ChessBoard board, Move move) {
  _setTile(move.from, move.meta.movedPiece, board);
  _setTile(move.to, null, board);
  if (move.meta.takenPiece != null) {
    _addPiece(move.meta.takenPiece, board);
    _setTile(move.to, move.meta.takenPiece, board);
  }
  move.meta.movedPiece.moveCount--;
}

void _castle(ChessBoard board, Move move) {
  var king =
      move.meta.movedPiece.isKing ? move.meta.movedPiece : move.meta.takenPiece;
  var rook =
      move.meta.movedPiece.isRook ? move.meta.movedPiece : move.meta.takenPiece;
  _setTile(king.tile, null, board);
  _setTile(rook.tile, null, board);
  var kingCol = tileToCol(rook.tile) == 0 ? 2 : 6;
  var rookCol = tileToCol(rook.tile) == 0 ? 3 : 5;
  _setTile(tileToRow(king.tile) * 8 + kingCol, king, board);
  _setTile(tileToRow(rook.tile) * 8 + rookCol, rook, board);
  tileToCol(rook.tile) == 3
      ? move.meta.flags.queenCastle = true
      : move.meta.flags.kingCastle = true;
  king.moveCount++;
  rook.moveCount++;
  move.meta.flags.castled = true;
}

void _undoCastle(ChessBoard board, Move move) {
  var king =
      move.meta.movedPiece.isKing ? move.meta.movedPiece : move.meta.takenPiece;
  var rook =
      move.meta.movedPiece.isRook ? move.meta.movedPiece : move.meta.takenPiece;
  _setTile(king.tile, null, board);
  _setTile(rook.tile, null, board);
  var rookCol = tileToCol(rook.tile) == 3 ? 0 : 7;
  _setTile(tileToRow(king.tile) * TILE_COUNT_PER_ROW + 4, king, board);
  _setTile(tileToRow(rook.tile) * TILE_COUNT_PER_ROW + rookCol, rook, board);
  king.moveCount--;
  rook.moveCount--;
}

void _promote(ChessBoard board, Move move) {
  move.meta.movedPiece.type = move.meta.promotionType;
  if (move.meta.promotionType != ChessPieceType.promotion) {
    addPromotedPiece(board, move);
  }
  move.meta.flags.promotion = true;
}

void addPromotedPiece(ChessBoard board, Move move) {
  switch (move.meta.promotionType) {
    case ChessPieceType.queen:
      {
        _queensForPlayer(move.meta.movedPiece.player, board)
            .add(move.meta.movedPiece);
      }
      break;
    case ChessPieceType.rook:
      {
        rooksForPlayer(move.meta.movedPiece.player, board)
            .add(move.meta.movedPiece);
      }
      break;
    default:
      {}
  }
}

void _undoPromote(ChessBoard board, Move move) {
  move.meta.movedPiece.type = ChessPieceType.pawn;
  switch (move.meta.promotionType) {
    case ChessPieceType.queen:
      {
        _queensForPlayer(move.meta.movedPiece.player, board)
            .remove(move.meta.movedPiece);
      }
      break;
    case ChessPieceType.rook:
      {
        rooksForPlayer(move.meta.movedPiece.player, board)
            .remove(move.meta.movedPiece);
      }
      break;
    default:
      {}
  }
}

void _checkEnPassant(ChessBoard board, Move move) {
  var offset = move.meta.movedPiece.player.isP1
      ? TILE_COUNT_PER_ROW
      : -TILE_COUNT_PER_ROW;
  var tile = move.meta.movedPiece.tile + offset;
  var takenPiece = board.tiles[tile];
  if (takenPiece != null && takenPiece == board.enPassantPiece) {
    _removePiece(takenPiece, board);
    _setTile(takenPiece.tile, null, board);
    move.meta.flags.enPassant = true;
  }
}

void _checkMoveAmbiguity(Move move, ChessBoard board) {
  var piece = board.tiles[move.from];
  for (var otherPiece
      in _piecesOfTypeForPlayer(piece.type, piece.player, board)) {
    if (piece != otherPiece) {
      if (movesForPiece(otherPiece, board).contains(move.to)) {
        if (tileToCol(otherPiece.tile) == tileToCol(piece.tile)) {
          move.meta.flags.colIsAmbiguous = true;
        } else {
          move.meta.flags.rowIsAmbiguous = true;
        }
      }
    }
  }
}

void _filterPossibleOpenings(ChessBoard board, Move move) {
  board.possibleOpenings = board.possibleOpenings
      .where((opening) =>
          opening[board.moveCount] == move &&
          opening.length > board.moveCount + 1)
      .toList();
}

void _setTile(int tile, ChessPiece piece, ChessBoard board) {
  board.tiles[tile] = piece;
  if (piece != null) {
    piece.tile = tile;
  }
}

void _addPiece(ChessPiece piece, ChessBoard board) {
  piecesForPlayer(piece.player, board).add(piece);
  if (piece.isRook) {
    rooksForPlayer(piece.player, board).add(piece);
  }
  if (piece.isQueen) {
    _queensForPlayer(piece.player, board).add(piece);
  }
}

void _removePiece(ChessPiece piece, ChessBoard board) {
  piecesForPlayer(piece.player, board).remove(piece);
  if (piece.isRook) {
    rooksForPlayer(piece.player, board).remove(piece);
  }
  if (piece.isQueen) {
    _queensForPlayer(piece.player, board).remove(piece);
  }
}

List<ChessPiece> piecesForPlayer(Player player, ChessBoard board) {
  return player.isP1 ? board.player1Pieces : board.player2Pieces;
}

ChessPiece kingForPlayer(Player player, ChessBoard board) {
  return player.isP1 ? board.player1King : board.player2King;
}

List<ChessPiece> rooksForPlayer(Player player, ChessBoard board) {
  return player.isP1 ? board.player1Rooks : board.player2Rooks;
}

List<ChessPiece> _queensForPlayer(Player player, ChessBoard board) {
  return player.isP1 ? board.player1Queens : board.player2Queens;
}

List<ChessPiece> _piecesOfTypeForPlayer(
    ChessPieceType type, Player player, ChessBoard board) {
  List<ChessPiece> pieces = [];
  for (var piece in piecesForPlayer(player, board)) {
    if (piece.hasType(type)) pieces.add(piece);
  }
  return pieces;
}

bool _castled(ChessPiece movedPiece, ChessPiece takenPiece) =>
    takenPiece != null && takenPiece.player == movedPiece.player;

bool _canBePromoted(ChessPiece movedPiece) =>
    movedPiece.isPawn &&
    equalToAny<int>(tileToRow(movedPiece.tile), END_TILE_INDICES);

bool _canTakeEnPassant(ChessPiece movedPiece) =>
    movedPiece.moveCount == 1 &&
    movedPiece.isPawn &&
    equalToAny(tileToRow(movedPiece.tile), MIDDLE_TILE_INDICES);

bool _inEndGame(ChessBoard board) =>
    (_queensForPlayer(Player.player1, board).isEmpty &&
        _queensForPlayer(Player.player2, board).isEmpty) ||
    piecesForPlayer(Player.player1, board).length <= 3 ||
    piecesForPlayer(Player.player2, board).length <= 3;
