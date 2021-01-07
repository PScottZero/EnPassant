import 'package:en_passant/logic/move_calculation/move_calculation.dart';
import 'package:en_passant/logic/move_calculation/piece_square_tables.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chess_piece.dart';
import 'move_calculation/move_classes/move.dart';
import 'move_calculation/move_classes/move_stack_object.dart';
import 'move_calculation/move_classes/tile.dart';

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
  List<List<ChessPiece>> board;
  List<ChessPiece> player1Pieces = [];
  List<ChessPiece> player2Pieces = [];
  ChessPiece player1King;
  ChessPiece player2King;
  List<ChessPiece> player1Rooks = [];
  List<ChessPiece> player2Rooks = [];
  List<ChessPiece> player1Queens = [];
  List<ChessPiece> player2Queens = [];
  ChessPiece enPassantPiece;
  
  List<MoveStackObject> moveStack = [];

  int get value {
    int value = 0;
    for (var piece in player1Pieces + player2Pieces) {
      value += piece.value + squareValue(piece, inEndGame);
    }
    return value;
  }

  bool get inEndGame {
    return (queensForPlayer(PlayerID.player1).isEmpty && 
      queensForPlayer(PlayerID.player2).isEmpty) ||
      piecesForPlayer(PlayerID.player1).length <= 3 ||
      piecesForPlayer(PlayerID.player2).length <= 3;
  }

  ChessBoard() {
    this.board = List.generate(8, (index) => List.generate(8, (index) => null));
    addPiecesFor(player: PlayerID.player1);
    addPiecesFor(player: PlayerID.player2);
  }

  void addPiecesFor({@required PlayerID player}) {
    for (var index = 0; index < 8; index++) {
      var pawn = ChessPiece(
        type: ChessPieceType.pawn,
        belongsTo: player,
        tile: Tile(player == PlayerID.player1 ? 1 : 6, index)
      );
      var piece = ChessPiece(
        type: KING_ROW_PIECES[index],
        belongsTo: player,
        tile: Tile(player == PlayerID.player1 ? 0 : 7, index)
      );
      addPiece(pawn);
      addPiece(piece);
      if (piece.type == ChessPieceType.king) {
        piece.player == PlayerID.player1 ?
          player1King = piece : player2King = piece;
      }
    }
  }

  void addPiece(ChessPiece piece) {
    board[piece.tile.row][piece.tile.col] = piece;
    piecesForPlayer(piece.player).add(piece);
    if (piece.type == ChessPieceType.rook) {
      rooksForPlayer(piece.player).add(piece);
    }
    if (piece.type == ChessPieceType.queen) {
      queensForPlayer(piece.player).add(piece);
    }
  }

  void removePiece(ChessPiece piece) {
    piecesForPlayer(piece.player).remove(piece);
    if (piece.type == ChessPieceType.rook) {
      rooksForPlayer(piece.player).remove(piece);
    }
    if (piece.type == ChessPieceType.queen) {
      queensForPlayer(piece.player).remove(piece);
    }
  }

  void push(Move move, { bool getMoveMeta = false }) {
    var movedPiece = board[move.from.row][move.from.col];
    var takenPiece = board[move.to.row][move.to.col];
    var obj = MoveStackObject(move.from, movedPiece, takenPiece);
    move.meta.player = movedPiece.player;
    move.meta.type = movedPiece.type;
    if (getMoveMeta) { checkMoveAmbiguity(move); }
    movedPiece.moveCount++;
    if (castled(movedPiece, takenPiece)) {
      movedPiece.type == ChessPieceType.king ?
        castling(takenPiece, movedPiece, move) :
        castling(movedPiece, takenPiece, move);
      obj.castling = true;
    } else {
      board[move.to.row][move.to.col] = movedPiece;
      board[move.from.row][move.from.col] = null;
      movedPiece.tile = move.to;
      if (takenPiece != null) {
        removePiece(takenPiece);
        move.meta.took = true;
      }
      if (promotion(movedPiece)) {
        movedPiece.promote();
        queensForPlayer(movedPiece.player).add(movedPiece);
        move.meta.promotion = true;
        obj.promotion = true;
      } else if (movedPiece.type == ChessPieceType.pawn) {
        checkEnPassant(movedPiece, obj);
        if (canTakeEnPassant(movedPiece)) { enPassantPiece = movedPiece; }
      }
    }
    moveStack.add(obj);
  }

  void pop() {
    var obj = moveStack.last;
    if (obj.castling) {
      obj.movedPiece.type == ChessPieceType.rook ?
        undoCastling(obj.takenPiece, obj.movedPiece) :
        undoCastling(obj.movedPiece, obj.takenPiece);
      obj.takenPiece.moveCount--;
    } else {
      board[obj.from.row][obj.from.col] = obj.movedPiece;
      if (obj.enPassant) {
        board[obj.movedPiece.tile.row][obj.movedPiece.tile.col] = null;
        board[obj.takenPiece.tile.row][obj.takenPiece.tile.col] = obj.takenPiece;
        enPassantPiece = obj.takenPiece;
      } else {
        board[obj.movedPiece.tile.row][obj.movedPiece.tile.col] = obj.takenPiece;
      }
      if (obj.takenPiece != null) { addPiece(obj.takenPiece); }
      obj.movedPiece.tile = obj.from;
      if (obj.promotion) {
        queensForPlayer(obj.movedPiece.player).remove(obj.movedPiece);
        obj.movedPiece.demote();
      }
    }
    obj.movedPiece.moveCount--;
    moveStack.removeLast();
  }

  void checkMoveAmbiguity(Move move) {
    var piece = board[move.from.row][move.from.col];
    for (var otherPiece in piecesOfTypeForPlayer(piece.type, piece.player)) {
      if (piece != otherPiece) {
        if (SharedFunctions.tileIsInTileList(move.to,
          MoveCalculation.movesForPiece(otherPiece, this))) {
          if (otherPiece.tile.col == piece.tile.col) {
            move.meta.colIsAmbiguous = true;
          } else {
            move.meta.rowIsAmbiguous = true;
          }
        }
      }
    }
  }

  void castling(ChessPiece king, ChessPiece rook, Move move) {
    board[king.tile.row][king.tile.col] = null;
    board[rook.tile.row][rook.tile.col] = null;
    var rookCol = rook.tile.col == 0 ? 3 : 5;
    var kingCol = rook.tile.col == 0 ? 2 : 6;
    rookCol == 3 ? move.meta.queenCastle = true : move.meta.kingCastle = true;
    board[rook.tile.row][rookCol] = rook;
    board[rook.tile.row][kingCol] = king;
    rook.tile = Tile(rook.tile.row, rookCol);
    king.tile = Tile(rook.tile.row, kingCol);
    king.moveCount++;
  }

  void undoCastling(ChessPiece king, ChessPiece rook) {
    board[king.tile.row][king.tile.col] = null;
    board[rook.tile.row][rook.tile.col] = null;
    var rookCol = rook.tile.col == 3 ? 0 : 7;
    board[rook.tile.row][rookCol] = rook;
    board[rook.tile.row][4] = king;
    rook.tile = Tile(rook.tile.row, rookCol);
    king.tile = Tile(rook.tile.row, 4);
  }

  void checkEnPassant(ChessPiece pawn, MoveStackObject obj) {
    var offset = pawn.player == PlayerID.player1 ? -1 : 1;
    var tile = Tile(pawn.tile.row + offset, pawn.tile.col);
    var takenPiece = pieceAtTile(tile);
    if (takenPiece != null && takenPiece == enPassantPiece) {
      removePiece(takenPiece);
      obj.takenPiece = takenPiece;
      obj.enPassant = true;
    }
    enPassantPiece = null;
  }

  ChessPiece pieceAtTile(Tile tile) { return board[tile.row][tile.col]; }

  List<ChessPiece> piecesForPlayer(PlayerID player) {
    return player == PlayerID.player1 ? player1Pieces : player2Pieces;
  }

  List<ChessPiece> piecesOfTypeForPlayer(ChessPieceType type, PlayerID player) {
    var pieces = piecesForPlayer(player);
    List<ChessPiece> piecesOfType = [];
    for (var piece in pieces) {
      if (piece.type == type) {
        piecesOfType.add(piece);
      }
    }
    return piecesOfType;
  }

  ChessPiece kingForPlayer(PlayerID player) {
    return player == PlayerID.player1 ? player1King : player2King;
  }

  List<ChessPiece> rooksForPlayer(PlayerID player) {
    return player == PlayerID.player1 ? player1Rooks : player2Rooks;
  }

  List<ChessPiece> queensForPlayer(PlayerID player) {
    return player == PlayerID.player1 ? player1Queens : player2Queens;
  }

  bool castled(ChessPiece movedPiece, ChessPiece takenPiece) {
    return takenPiece != null && takenPiece.player == movedPiece.player;
  }

  bool promotion(ChessPiece movedPiece) {
    return movedPiece.type == ChessPieceType.pawn &&
      (movedPiece.tile.row == 7 || movedPiece.tile.row == 0);
  }

  bool canTakeEnPassant(ChessPiece movedPiece) {
    return movedPiece.moveCount == 1 &&
      (movedPiece.tile.row == 3 || movedPiece.tile.col == 4);
  }
}
