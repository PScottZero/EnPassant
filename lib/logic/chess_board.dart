import 'package:en_passant/logic/move_calculation/move_classes/move_stack_object.dart';
import 'package:en_passant/logic/move_calculation/openings.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/views/components/main_menu_view/game_options/side_picker.dart';

import 'chess_piece.dart';
import 'move_calculation/move_calculation.dart';
import 'move_calculation/move_classes/move.dart';
import 'move_calculation/move_classes/move_meta.dart';
import 'move_calculation/piece_square_tables.dart';

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
  List<ChessPiece> tiles = List.filled(64, null);
  List<MoveStackObject> moveStack = [];
  List<MoveStackObject> redoStack = [];
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
    var kingRowOffset = player == Player.player1 ? 56 : 0;
    var pawnRowOffset = player == Player.player1 ? -8 : 8;
    var index = 0;
    for (var pieceType in KING_ROW_PIECES) {
      var id = player == Player.player1 ? index * 2 : index * 2 + 16;
      var piece = ChessPiece(id, pieceType, player, kingRowOffset + index);
      var pawn = ChessPiece(id + 1, ChessPieceType.pawn, player,
          kingRowOffset + pawnRowOffset + index);
      _setTile(piece.tile, piece, this);
      _setTile(pawn.tile, pawn, this);
      piecesForPlayer(player, this).addAll([piece, pawn]);
      if (piece.type == ChessPieceType.king) {
        player == Player.player1 ? player1King = piece : player2King = piece;
      } else if (piece.type == ChessPieceType.queen) {
        _queensForPlayer(player, this).add(piece);
      } else if (piece.type == ChessPieceType.rook) {
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

MoveMeta push(Move move, ChessBoard board,
    {bool getMeta = false,
    ChessPieceType promotionType = ChessPieceType.promotion}) {
  var mso = MoveStackObject(move, board.tiles[move.from], board.tiles[move.to],
      board.enPassantPiece, List.from(board.possibleOpenings));
  var meta = MoveMeta(move, mso.movedPiece.player, mso.movedPiece.type);
  if (board.possibleOpenings.isNotEmpty) {
    _filterPossibleOpenings(board, move);
  }
  if (getMeta) {
    _checkMoveAmbiguity(move, meta, board);
  }
  if (_castled(mso.movedPiece, mso.takenPiece)) {
    _castle(board, mso, meta);
  } else {
    _standardMove(board, mso, meta);
    if (mso.movedPiece.type == ChessPieceType.pawn) {
      if (_promotion(mso.movedPiece)) {
        mso.promotionType = promotionType;
        meta.promotionType = promotionType;
        _promote(board, mso, meta);
      }
      _checkEnPassant(board, mso, meta);
    }
  }
  if (_canTakeEnPassant(mso.movedPiece)) {
    board.enPassantPiece = mso.movedPiece;
  } else {
    board.enPassantPiece = null;
  }
  if (meta.type == ChessPieceType.pawn && meta.took) {
    meta.rowIsAmbiguous = true;
  }
  board.moveStack.add(mso);
  board.moveCount++;
  return meta;
}

MoveMeta pushMSO(MoveStackObject mso, ChessBoard board) {
  return push(mso.move, board, promotionType: mso.promotionType);
}

MoveStackObject pop(ChessBoard board) {
  var mso = board.moveStack.removeLast();
  board.enPassantPiece = mso.enPassantPiece;
  board.possibleOpenings = mso.possibleOpenings;
  if (mso.castled) {
    _undoCastle(board, mso);
  } else {
    _undoStandardMove(board, mso);
    if (mso.promotion) {
      _undoPromote(board, mso);
    }
    if (mso.enPassant) {
      _addPiece(mso.enPassantPiece, board);
      _setTile(mso.enPassantPiece.tile, mso.enPassantPiece, board);
    }
  }
  board.moveCount--;
  return mso;
}

void _standardMove(ChessBoard board, MoveStackObject mso, MoveMeta meta) {
  _setTile(mso.move.to, mso.movedPiece, board);
  _setTile(mso.move.from, null, board);
  mso.movedPiece.moveCount++;
  if (mso.takenPiece != null) {
    _removePiece(mso.takenPiece, board);
    meta.took = true;
  }
}

void _undoStandardMove(ChessBoard board, MoveStackObject mso) {
  _setTile(mso.move.from, mso.movedPiece, board);
  _setTile(mso.move.to, null, board);
  if (mso.takenPiece != null) {
    _addPiece(mso.takenPiece, board);
    _setTile(mso.move.to, mso.takenPiece, board);
  }
  mso.movedPiece.moveCount--;
}

void _castle(ChessBoard board, MoveStackObject mso, MoveMeta meta) {
  var king = mso.movedPiece.type == ChessPieceType.king
      ? mso.movedPiece
      : mso.takenPiece;
  var rook = mso.movedPiece.type == ChessPieceType.rook
      ? mso.movedPiece
      : mso.takenPiece;
  _setTile(king.tile, null, board);
  _setTile(rook.tile, null, board);
  var kingCol = tileToCol(rook.tile) == 0 ? 2 : 6;
  var rookCol = tileToCol(rook.tile) == 0 ? 3 : 5;
  _setTile(tileToRow(king.tile) * 8 + kingCol, king, board);
  _setTile(tileToRow(rook.tile) * 8 + rookCol, rook, board);
  tileToCol(rook.tile) == 3 ? meta.queenCastle = true : meta.kingCastle = true;
  king.moveCount++;
  rook.moveCount++;
  mso.castled = true;
}

void _undoCastle(ChessBoard board, MoveStackObject mso) {
  var king = mso.movedPiece.type == ChessPieceType.king
      ? mso.movedPiece
      : mso.takenPiece;
  var rook = mso.movedPiece.type == ChessPieceType.rook
      ? mso.movedPiece
      : mso.takenPiece;
  _setTile(king.tile, null, board);
  _setTile(rook.tile, null, board);
  var rookCol = tileToCol(rook.tile) == 3 ? 0 : 7;
  _setTile(tileToRow(king.tile) * 8 + 4, king, board);
  _setTile(tileToRow(rook.tile) * 8 + rookCol, rook, board);
  king.moveCount--;
  rook.moveCount--;
}

void _promote(ChessBoard board, MoveStackObject mso, MoveMeta meta) {
  mso.movedPiece.type = mso.promotionType;
  if (mso.promotionType != ChessPieceType.promotion) {
    addPromotedPiece(board, mso);
  }
  meta.promotion = true;
  mso.promotion = true;
}

void addPromotedPiece(ChessBoard board, MoveStackObject mso) {
  switch (mso.promotionType) {
    case ChessPieceType.queen:
      {
        _queensForPlayer(mso.movedPiece.player, board).add(mso.movedPiece);
      }
      break;
    case ChessPieceType.rook:
      {
        rooksForPlayer(mso.movedPiece.player, board).add(mso.movedPiece);
      }
      break;
    default:
      {}
  }
}

void _undoPromote(ChessBoard board, MoveStackObject mso) {
  mso.movedPiece.type = ChessPieceType.pawn;
  switch (mso.promotionType) {
    case ChessPieceType.queen:
      {
        _queensForPlayer(mso.movedPiece.player, board).remove(mso.movedPiece);
      }
      break;
    case ChessPieceType.rook:
      {
        rooksForPlayer(mso.movedPiece.player, board).remove(mso.movedPiece);
      }
      break;
    default:
      {}
  }
}

void _checkEnPassant(ChessBoard board, MoveStackObject mso, MoveMeta meta) {
  var offset = mso.movedPiece.player == Player.player1 ? 8 : -8;
  var tile = mso.movedPiece.tile + offset;
  var takenPiece = board.tiles[tile];
  if (takenPiece != null && takenPiece == board.enPassantPiece) {
    _removePiece(takenPiece, board);
    _setTile(takenPiece.tile, null, board);
    mso.enPassant = true;
  }
}

void _checkMoveAmbiguity(Move move, MoveMeta moveMeta, ChessBoard board) {
  var piece = board.tiles[move.from];
  for (var otherPiece
      in _piecesOfTypeForPlayer(piece.type, piece.player, board)) {
    if (piece != otherPiece) {
      if (movesForPiece(otherPiece, board).contains(move.to)) {
        if (tileToCol(otherPiece.tile) == tileToCol(piece.tile)) {
          moveMeta.colIsAmbiguous = true;
        } else {
          moveMeta.rowIsAmbiguous = true;
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
  if (piece.type == ChessPieceType.rook) {
    rooksForPlayer(piece.player, board).add(piece);
  }
  if (piece.type == ChessPieceType.queen) {
    _queensForPlayer(piece.player, board).add(piece);
  }
}

void _removePiece(ChessPiece piece, ChessBoard board) {
  piecesForPlayer(piece.player, board).remove(piece);
  if (piece.type == ChessPieceType.rook) {
    rooksForPlayer(piece.player, board).remove(piece);
  }
  if (piece.type == ChessPieceType.queen) {
    _queensForPlayer(piece.player, board).remove(piece);
  }
}

List<ChessPiece> piecesForPlayer(Player player, ChessBoard board) {
  return player == Player.player1 ? board.player1Pieces : board.player2Pieces;
}

ChessPiece kingForPlayer(Player player, ChessBoard board) {
  return player == Player.player1 ? board.player1King : board.player2King;
}

List<ChessPiece> rooksForPlayer(Player player, ChessBoard board) {
  return player == Player.player1 ? board.player1Rooks : board.player2Rooks;
}

List<ChessPiece> _queensForPlayer(Player player, ChessBoard board) {
  return player == Player.player1 ? board.player1Queens : board.player2Queens;
}

List<ChessPiece> _piecesOfTypeForPlayer(
    ChessPieceType type, Player player, ChessBoard board) {
  List<ChessPiece> pieces = [];
  for (var piece in piecesForPlayer(player, board)) {
    if (piece.type == type) {
      pieces.add(piece);
    }
  }
  return pieces;
}

bool _castled(ChessPiece movedPiece, ChessPiece takenPiece) {
  return takenPiece != null && takenPiece.player == movedPiece.player;
}

bool _promotion(ChessPiece movedPiece) {
  return movedPiece.type == ChessPieceType.pawn &&
      (tileToRow(movedPiece.tile) == 7 || tileToRow(movedPiece.tile) == 0);
}

bool _canTakeEnPassant(ChessPiece movedPiece) {
  return movedPiece.moveCount == 1 &&
      movedPiece.type == ChessPieceType.pawn &&
      (tileToRow(movedPiece.tile) == 3 || tileToRow(movedPiece.tile) == 4);
}

bool _inEndGame(ChessBoard board) {
  return (_queensForPlayer(Player.player1, board).isEmpty &&
          _queensForPlayer(Player.player2, board).isEmpty) ||
      piecesForPlayer(Player.player1, board).length <= 3 ||
      piecesForPlayer(Player.player2, board).length <= 3;
}
