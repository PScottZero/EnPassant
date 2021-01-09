import 'package:en_passant/logic/move_calculation/move_classes/move_stack_object.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';

import 'chess_piece.dart';
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
  List<ChessPiece> tiles = List(64);
  List<MoveStackObject> moveStack = [];
  List<ChessPiece> player1Pieces = [];
  List<ChessPiece> player2Pieces = [];
  List<ChessPiece> player1Rooks = [];
  List<ChessPiece> player2Rooks = [];
  List<ChessPiece> player1Queens = [];
  List<ChessPiece> player2Queens = [];
  ChessPiece player1King;
  ChessPiece player2King;
  bool player1KingInCheck = false;
  bool player2KingInCheck = false;

  ChessBoard() {
    _addPiecesForPlayer(Player.player1);
    _addPiecesForPlayer(Player.player2);
  }

  void _addPiecesForPlayer(Player player) {
    var kingRowOffset = player == Player.player1 ? 56 : 0;
    var pawnRowOffset = player == Player.player1 ? -8 : 8;
    var index = 0;
    for (var pieceType in KING_ROW_PIECES) {
      var piece = ChessPiece(pieceType, player, kingRowOffset + index);
      var pawn = ChessPiece(ChessPieceType.pawn, player, kingRowOffset + pawnRowOffset + index);
      setTile(piece.tile, piece, this);
      setTile(pawn.tile, pawn, this);
      piecesForPlayer(player, this).addAll([piece, pawn]);
      if (piece.type == ChessPieceType.king) {
        player == Player.player1 ? player1King = piece : player2King = piece;
      } else if (piece.type == ChessPieceType.queen) {
        queensForPlayer(player, this).add(piece);
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
    value += piece.value + squareValue(piece, false);
  }
  return value;
}

MoveMeta push(Move move, ChessBoard board) {
  var mso = MoveStackObject(move.piece.tile, move.tile, move.piece,
    board.tiles[move.tile]);
  var meta = MoveMeta(move.piece.tile, move.tile, move.piece.player,
    move.piece.type);
  if (castled(mso.movedPiece, mso.takenPiece)) {
    castle(board, mso, meta);
  } else {
    standardMove(board, mso, meta);
    if (mso.movedPiece.type == ChessPieceType.pawn) {
      if (promotion(mso.movedPiece)) {
        promote(board, mso, meta);
      }
    }
  }
  board.moveStack.add(mso);
  return meta;
}

void pop(ChessBoard board) {
  var mso = board.moveStack.removeLast();
  if (mso.castled) {
    undoCastle(board, mso);
  } else {
    undoStandardMove(board, mso);
    if (mso.promotion) {
      undoPromote(board, mso);
    }
  }
}

void standardMove(ChessBoard board, MoveStackObject mso, MoveMeta meta) {
  setTile(mso.to, mso.movedPiece, board);
  setTile(mso.from, null, board);
  mso.movedPiece.moveCount++;
  if (mso.takenPiece != null) {
    removePiece(mso.takenPiece, board);
    meta.took = true;
  }
}

void undoStandardMove(ChessBoard board, MoveStackObject mso) {
  setTile(mso.from, mso.movedPiece, board);
  setTile(mso.to, null, board);
  if (mso.takenPiece != null) {
    addPiece(mso.takenPiece, board);
    setTile(mso.to, mso.takenPiece, board);
  }
  mso.movedPiece.moveCount--;
}

void castle(ChessBoard board, MoveStackObject mso, MoveMeta meta) {
  var king = mso.movedPiece.type == ChessPieceType.king ?
    mso.movedPiece : mso.takenPiece;
  var rook = mso.movedPiece.type == ChessPieceType.rook ?
    mso.movedPiece : mso.takenPiece;
  setTile(king.tile, null, board);
  setTile(rook.tile, null, board);
  var kingCol = tileToCol(rook.tile) == 0 ? 2 : 6;
  var rookCol = tileToCol(rook.tile) == 0 ? 3 : 5;
  setTile(tileToRow(king.tile) * 8 + kingCol, king, board);
  setTile(tileToRow(rook.tile) * 8 + rookCol, rook, board);
  tileToCol(rook.tile) == 3 ? meta.queenCastle = true :
    meta.kingCastle = true;
  king.moveCount++;
  rook.moveCount++;
  mso.castled = true;
}

void undoCastle(ChessBoard board, MoveStackObject mso) {
  var king = mso.movedPiece.type == ChessPieceType.king ?
    mso.movedPiece : mso.takenPiece;
  var rook = mso.movedPiece.type == ChessPieceType.rook ?
    mso.movedPiece : mso.takenPiece;
  setTile(king.tile, null, board);
  setTile(rook.tile, null, board);
  var rookCol = tileToCol(rook.tile) == 3 ? 0 : 7;
  setTile(tileToRow(king.tile) * 8 + 4, king, board);
  setTile(tileToRow(rook.tile) * 8 + rookCol, rook, board);
  king.moveCount--;
  rook.moveCount--;
}

void promote(ChessBoard board, MoveStackObject mso, MoveMeta meta) {
  mso.movedPiece.type = ChessPieceType.queen;
  initSprite(mso.movedPiece);
  queensForPlayer(mso.movedPiece.player, board).add(mso.movedPiece);
  meta.promotion = true;
  mso.promotion = true;
}

void undoPromote(ChessBoard board, MoveStackObject mso) {
  mso.movedPiece.type = ChessPieceType.pawn;
  initSprite(mso.movedPiece);
  queensForPlayer(mso.movedPiece.player, board).remove(mso.movedPiece);
}

void setTile(int tile, ChessPiece piece, ChessBoard board) {
  board.tiles[tile] = piece;
  if (piece != null) {
    piece.tile = tile;
  }
}

void addPiece(ChessPiece piece, ChessBoard board) {
  piecesForPlayer(piece.player, board).add(piece);
  if (piece.type == ChessPieceType.rook) {
    rooksForPlayer(piece.player, board).add(piece);
  }
  if (piece.type == ChessPieceType.queen) {
    queensForPlayer(piece.player, board).add(piece);
  }
}

void removePiece(ChessPiece piece, ChessBoard board) {
  piecesForPlayer(piece.player, board).remove(piece);
  if (piece.type == ChessPieceType.rook) {
    rooksForPlayer(piece.player, board).remove(piece);
  }
  if (piece.type == ChessPieceType.queen) {
    queensForPlayer(piece.player, board).remove(piece);
  }
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

bool castled(ChessPiece movedPiece, ChessPiece takenPiece) {
  return takenPiece != null && takenPiece.player == movedPiece.player;
}

bool promotion(ChessPiece movedPiece) {
  return movedPiece.type == ChessPieceType.pawn &&
    (tileToRow(movedPiece.tile) == 7 || tileToRow(movedPiece.tile) == 0);
}
