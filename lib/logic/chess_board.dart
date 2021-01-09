import 'package:en_passant/logic/move_calculation.dart';
import 'package:en_passant/logic/piece_square_tables.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chess_piece.dart';
import 'move_classes.dart';

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

  ChessBoard({bool initPieces = true}) {
    this.board = List.generate(8, (index) => List.generate(8, (index) => null));
    if (initPieces) {
      addPiecesFor(player: PlayerID.player1);
      addPiecesFor(player: PlayerID.player2);
    }
  }

  ChessBoard copy() {
    var boardCopy = ChessBoard(initPieces: false);
    for (var piece in player1Pieces + player2Pieces) {
      var pieceCopy = ChessPiece.fromPiece(existingPiece: piece);
      boardCopy.addPiece(piece: pieceCopy, tile: pieceCopy.tile);
      if (pieceCopy.type == ChessPieceType.king) {
        pieceCopy.player == PlayerID.player1 ?
          boardCopy.player1King = pieceCopy : boardCopy.player2King = pieceCopy;
      } else if (pieceCopy.type == ChessPieceType.rook) {
        pieceCopy.player == PlayerID.player1 ?
          boardCopy.player1Rooks.add(pieceCopy) : boardCopy.player2Rooks.add(pieceCopy);
      }
      if (enPassantPiece != null && enPassantPiece == pieceCopy) {
        boardCopy.enPassantPiece = enPassantPiece;
      }
    }
    return boardCopy;
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
      addPiece(piece: pawn, tile: pawn.tile);
      addPiece(piece: piece, tile: piece.tile);
      if (piece.type == ChessPieceType.king) {
        piece.player == PlayerID.player1 ?
          player1King = piece : player2King = piece;
      }
    }
  }

  void addPiece({@required ChessPiece piece, @required Tile tile}) {
    board[tile.row][tile.col] = piece;
    piece.player == PlayerID.player1 ?
      player1Pieces.add(piece) : player2Pieces.add(piece);
    if (piece.type == ChessPieceType.rook) {
      piece.player == PlayerID.player1 ?
        player1Rooks.add(piece) : player2Rooks.add(piece);
    }
    if (piece.type == ChessPieceType.queen) {
      piece.player == PlayerID.player1 ?
        player1Queens.add(piece) : player2Queens.add(piece);
    }
  }

  void removePiece({@required Tile tile}) {
    var possiblePiece = pieceAtTile(tile);
    board[tile.row][tile.col] = null;
    if (possiblePiece != null) {
      piecesForPlayer(possiblePiece.player).remove(possiblePiece);
      if (possiblePiece.type == ChessPieceType.rook) {
        rooksForPlayer(possiblePiece.player).remove(possiblePiece);
      }
      if (possiblePiece.type == ChessPieceType.queen) {
        queensForPlayer(possiblePiece.player).remove(possiblePiece);
      }
    }
  }

  Move movePiece({
    @required Tile from,
    @required Tile to,
    bool getMoveMeta = false
  }) {
    var move = Move(from, to);
    var movedPiece = board[from.row][from.col];
    var takenPiece = board[to.row][to.col];
    if (getMoveMeta) {
      checkMoveAmbiguity(from: from, to: to, moveMeta: move.meta);
    }
    board[from.row][from.col] = null;
    movedPiece.moveCount++;
    move.meta.player = movedPiece.player;
    move.meta.type = movedPiece.type;
    if (takenPiece != null && takenPiece.player == movedPiece.player) {
      takenPiece.moveCount++;
      movedPiece.type == ChessPieceType.king ?
          castling(king: movedPiece, rook: takenPiece) :
          castling(king: takenPiece, rook: movedPiece);
      if (movedPiece.tile.col == 2 || movedPiece.tile.col == 3) {
        move.meta.queenCastle = true;
      } else {
        move.meta.kingCastle = true;
      }
    } else {
      if (takenPiece != null) {
        move.meta.took = true;
      }
      removePiece(tile: to);
      board[to.row][to.col] = movedPiece;
      movedPiece.tile = to;
      if (movedPiece.type == ChessPieceType.pawn) {
        if (to.row == 7 || to.row == 0) {
          pawnToQueen(pawn: movedPiece);
          move.meta.promotion = true;
        }
        checkEnPassant(pawn: movedPiece);
        if ((from.row - to.row).abs() == 2) {
          enPassantPiece = movedPiece;
        }
      }
    }
    return move;
  }

  void checkMoveAmbiguity({
    @required Tile from,
    @required Tile to,
    @required MoveMeta moveMeta
  }) {
    var piece = board[from.row][from.col];
    for (var otherPiece in piecesOfTypeForPlayer(type: piece.type, player: piece.player)) {
      if (piece != otherPiece) {
        if (SharedFunctions.tileIsInTileList(
          tile: to,
          tileList: MoveCalculation.movesFor(piece: otherPiece, board: this)
        )) {
          if (otherPiece.tile.col == piece.tile.col) {
            moveMeta.colIsAmbiguous = true;
          } else {
            moveMeta.rowIsAmbiguous = true;
          }
        }
      }
    }
  }

  void castling({@required ChessPiece king, @required ChessPiece rook}) {
    board[king.tile.row][king.tile.col] = null;
    board[rook.tile.row][rook.tile.col] = null;
    var rookCol = rook.tile.col == 0 ? 3 : 5;
    var kingCol = rook.tile.col == 0 ? 2 : 6;
    board[rook.tile.row][rook.tile.col == 0 ? 3 : 5] = rook;
    board[rook.tile.row][rook.tile.col == 0 ? 2 : 6] = king;
    rook.tile = Tile(rook.tile.row, rookCol);
    king.tile = Tile(rook.tile.row, kingCol);
  }

  void pawnToQueen({@required ChessPiece pawn}) {
    removePiece(tile: pawn.tile);
    var queen = ChessPiece(
      belongsTo: pawn.player,
      type: ChessPieceType.queen,
      tile: pawn.tile
    );
    addPiece(piece: queen, tile: pawn.tile);
    queen.spriteX = pawn.spriteX;
    queen.spriteY = pawn.spriteY;
  }

  void checkEnPassant({@required ChessPiece pawn}) {
    var offset = pawn.player == PlayerID.player1 ? -1 : 1;
    var tile = Tile(pawn.tile.row + offset, pawn.tile.col);
    var takenPiece = pieceAtTile(tile);
    if (takenPiece != null && takenPiece == enPassantPiece) {
      removePiece(tile: tile);
    }
    enPassantPiece = null;
  }

  ChessPiece pieceAtTile(Tile tile) {
    return board[tile.row][tile.col];
  }

  List<ChessPiece> piecesForPlayer(PlayerID player) {
    return player == PlayerID.player1 ? player1Pieces : player2Pieces;
  }

  List<ChessPiece> piecesOfTypeForPlayer({
    @required ChessPieceType type,
    @required PlayerID player
  }) {
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
}
