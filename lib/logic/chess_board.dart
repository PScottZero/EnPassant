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
      setTile(pawn.tile, pawn);
      addPiece(piece);
      setTile(piece.tile, piece);
      if (piece.type == ChessPieceType.king) {
        piece.player == PlayerID.player1 ?
          player1King = piece : player2King = piece;
      }
    }
  }

  void addPiece(ChessPiece piece) {
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
    var obj = MoveStackObject(move, board[move.from.row][move.from.col],
      board[move.to.row][move.to.col], enPassantPiece);
    if (getMoveMeta) {
      checkMoveAmbiguity(move);
    }
    if (castled(obj.movedPiece, obj.takenPiece)) {
      castle(obj);
    } else {
      standardMove(obj);
      if (obj.movedPiece.type == ChessPieceType.pawn) {
        if (promotion(obj.movedPiece)) {
          promote(obj);
        } else {
          checkEnPassant(obj);
        }
      }
    }
    moveStack.add(obj);
  }

  void pop() {
    var obj = moveStack.removeLast();
    enPassantPiece = obj.enPassantPiece;
    if (obj.castled) {
      undoCastle(obj);
    } else {
      undoStandardMove(obj);
      if (obj.promotion) {
        undoPromote(obj);
      }
      if (obj.enPassant) {
        addPiece(obj.enPassantPiece);
        setTile(obj.enPassantPiece.tile, obj.enPassantPiece);
      }
    }
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

  void standardMove(MoveStackObject obj) {
    setTile(obj.move.to, obj.movedPiece);
    setTile(obj.move.from, null);
    obj.movedPiece.tile = obj.move.to;
    obj.movedPiece.moveCount++;
    if (obj.takenPiece != null) {
      removePiece(obj.takenPiece);
      obj.move.meta.took = true;
    }
  }

  void undoStandardMove(MoveStackObject obj) {
    setTile(obj.move.from, obj.movedPiece);
    setTile(obj.move.to, null);
    if (obj.takenPiece != null) {
      addPiece(obj.takenPiece);
      setTile(obj.move.to, obj.takenPiece);
    }
    obj.movedPiece.tile = obj.move.from;
    obj.movedPiece.moveCount--;
  }

  void castle(MoveStackObject obj) {
    var king = obj.movedPiece.type == ChessPieceType.king ?
      obj.movedPiece : obj.takenPiece;
    var rook = obj.movedPiece.type == ChessPieceType.rook ?
      obj.movedPiece : obj.takenPiece;
    setTile(king.tile, null);
    setTile(rook.tile, null);
    setTile(Tile(king.tile.row, rook.tile.col == 0 ? 2 : 6), king);
    setTile(Tile(rook.tile.row, rook.tile.col == 0 ? 3 : 5), rook);
    rook.tile.col == 3 ? obj.move.meta.queenCastle = true :
      obj.move.meta.kingCastle = true;
    king.moveCount++;
    rook.moveCount++;
    obj.castled = true;
  }

  void undoCastle(MoveStackObject obj) {
    var king = obj.movedPiece.type == ChessPieceType.king ?
      obj.movedPiece : obj.takenPiece;
    var rook = obj.movedPiece.type == ChessPieceType.rook ?
      obj.movedPiece : obj.takenPiece;
    setTile(king.tile, null);
    setTile(rook.tile, null);
    setTile(Tile(king.tile.row, 4), king);
    setTile(Tile(rook.tile.row, rook.tile.col == 3 ? 0 : 7), rook);
    king.moveCount--;
    rook.moveCount--;
  }

  void promote(MoveStackObject obj) {
    obj.movedPiece.promote();
    queensForPlayer(obj.movedPiece.player).add(obj.movedPiece);
    obj.move.meta.promotion = true;
    obj.promotion = true;
  }

  void undoPromote(MoveStackObject obj) {
    obj.movedPiece.demote();
    queensForPlayer(obj.movedPiece.player).remove(obj.movedPiece);
  }

  void checkEnPassant(MoveStackObject obj) {
    var offset = obj.movedPiece.player == PlayerID.player1 ? -1 : 1;
    var tile = Tile(obj.movedPiece.tile.row + offset, obj.movedPiece.tile.col);
    var takenPiece = pieceAtTile(tile);
    if (takenPiece != null && takenPiece == enPassantPiece) {
      removePiece(takenPiece);
      setTile(tile, null);
      obj.enPassant = true;
    }
    if (canTakeEnPassant(obj.movedPiece)) {
      enPassantPiece = obj.movedPiece;
    } else {
      enPassantPiece = null;
    }
  }

  void setTile(Tile tile, ChessPiece piece) {
    board[tile.row][tile.col] = piece;
    if (piece != null) {
      piece.tile = tile;
    }
  }

  ChessPiece pieceAtTile(Tile tile) {
    return board[tile.row][tile.col];
  }

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
      (movedPiece.tile.row == 3 || movedPiece.tile.row == 4);
  }
}
