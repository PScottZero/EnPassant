import 'package:en_passant/logic/chess_board.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flutter/cupertino.dart';

import 'chess_piece.dart';
import 'shared_functions.dart';
import 'move_classes.dart';

class MoveCalculation {
  static List<Tile> movesFor({
    ChessPiece piece,
    ChessBoard board,
    bool skipSafetyCheck = false
  }) {
    switch (piece.type) {
      case ChessPieceType.pawn:{
        return pawnMoves(pawn: piece, board: board, skipSafetyCheck: skipSafetyCheck);
      }
      case ChessPieceType.bishop: {
        return bishopMoves(bishop: piece, board: board, skipSafetyCheck: skipSafetyCheck);
      }
      case ChessPieceType.knight: {
        return knightMoves(knight: piece, board: board, skipSafetyCheck: skipSafetyCheck);
      }
      case ChessPieceType.rook: {
        return rookMoves(rook: piece, board: board, skipSafetyCheck: skipSafetyCheck);
      }
      case ChessPieceType.queen: {
        return queenMoves(queen: piece, board: board, skipSafetyCheck: skipSafetyCheck);
      }
      case ChessPieceType.king: {
        return kingMoves(king: piece, board: board, skipSafetyCheck: skipSafetyCheck);
      }
      default: { return []; }
    }
  }

  static List<Tile> pawnMoves({ChessPiece pawn, ChessBoard board, bool skipSafetyCheck}) {
    var validMoves = kingKnightPawnMoveHelper(
      piece: pawn,
      board: board,
      relativeMoves: pawnStandardMoves(pawn: pawn),
      skipSafetyCheck: skipSafetyCheck
    );
    if (validMoves.length == 1) {
      if ((validMoves[0].row - pawn.tile.row).abs() > 1) {
        validMoves = [];
      }
    }
    validMoves += MoveCalculation.pawnDiagonalAttack(pawn: pawn, board: board);
    return MoveCalculation.filterSafeMoves(
      piece: pawn,
      board: board,
      possibleMoves: validMoves,
      skipSafetyCheck: skipSafetyCheck
    );
  }

  static List<Tile> pawnStandardMoves({ChessPiece pawn}) {
    List<Tile> relativeMoves = pawn.player == PlayerID.player1 ? 
      [Tile(row: 1, col: 0)] : [Tile(row: -1, col: 0)];
    if (pawn.moveCount == 0) {
      pawn.player == PlayerID.player1 ?
        relativeMoves.add(Tile(row: 2, col: 0)) : 
        relativeMoves.add(Tile(row: -2, col: 0));
    }
    return relativeMoves;
  }

  static List<Tile> pawnDiagonalAttack({ChessPiece pawn, ChessBoard board}) {
    List<Tile> validMoves = [];
    var diagonals = pawn.player == PlayerID.player1 ?
      [Tile(row: 1, col: -1), Tile(row: 1, col: 1)] :
      [Tile(row: -1, col: -1), Tile(row: -1, col: 1)];
    for (var diagonal in diagonals) {
      var possibleMove = Tile(
        row: pawn.tile.row + diagonal.row,
        col: pawn.tile.col + diagonal.col
      );
      if (SharedFunctions.tileInBounds(possibleMove)) {
        var takenPiece = board.pieceAtTile(possibleMove);
        if ((takenPiece != null && takenPiece.player != pawn.player) ||
          canTakeEnPassant(pawnPlayer: pawn.player, diagonal: possibleMove, board: board)) {
          validMoves.add(possibleMove);
        }
      }
    }
    return validMoves;
  }

  static bool canTakeEnPassant({PlayerID pawnPlayer, Tile diagonal, ChessBoard board}) {
    var rowOffset = (pawnPlayer == PlayerID.player1) ? -1 : 1;
    var takenPiece = board.pieceAtTile(
      Tile(row: diagonal.row + rowOffset, col: diagonal.col)
    );
    return takenPiece != null && takenPiece == board.enPassantPiece;
  }

  static List<Tile> bishopMoves({ChessPiece bishop, ChessBoard board, bool skipSafetyCheck}) {
    return MoveCalculation.bishopQueenRookMoveHelper(
      piece: bishop,
      board: board,
      directions: [
        Tile(row: 1, col: 1), Tile(row: 1, col: -1),
        Tile(row: -1, col: 1), Tile(row: -1, col: -1)
      ],
      skipSafetyCheck: skipSafetyCheck
    );
  }
  
  static List<Tile> knightMoves({ChessPiece knight, ChessBoard board, bool skipSafetyCheck}) {
    return MoveCalculation.kingKnightPawnMoveHelper(
      piece: knight,
      board: board,
      relativeMoves: [
        Tile(row: 1, col: 2), Tile(row: 1, col: -2),
        Tile(row: -1, col: 2), Tile(row: -1, col: -2),
        Tile(row: 2, col: 1), Tile(row: 2, col: -1),
        Tile(row: -2, col: 1), Tile(row: -2, col: -1)
      ],
      skipSafetyCheck: skipSafetyCheck
    );
  }

  static List<Tile> rookMoves({ChessPiece rook, ChessBoard board, bool skipSafetyCheck}) {
    return MoveCalculation.bishopQueenRookMoveHelper(
      piece: rook,
      board: board,
      directions: [
        Tile(row: 1, col: 0), Tile(row: -1, col: 0),
        Tile(row: 0, col: 1), Tile(row: 0, col: -1)
      ],
      skipSafetyCheck: skipSafetyCheck
    ) + rookCastling(rook: rook, board: board, skipSafetyCheck: skipSafetyCheck);
  }

  static List<Tile> rookCastling({ChessPiece rook, ChessBoard board, bool skipSafetyCheck}) {
    var king = board.kingForPlayer(rook.player);
    if (canCastle(king: king, rook: rook, board: board, skipSafetyCheck: skipSafetyCheck)) {
      return MoveCalculation.filterSafeMoves(
        piece: rook,
        board: board,
        possibleMoves: [king.tile],
        skipSafetyCheck: skipSafetyCheck
      );
    }
    return [];
  }

  static List<Tile> queenMoves({ChessPiece queen, ChessBoard board, bool skipSafetyCheck}) {
    return MoveCalculation.bishopQueenRookMoveHelper(
      piece: queen,
      board: board,
      directions: [
        Tile(row: 1, col: 0), Tile(row: -1, col: 0),
        Tile(row: 0, col: 1), Tile(row: 0, col: -1),
        Tile(row: 1, col: 1), Tile(row: 1, col: -1),
        Tile(row: -1, col: 1), Tile(row: -1, col: -1)
      ],
      skipSafetyCheck: skipSafetyCheck
    );
  }

  static List<Tile> kingMoves({ChessPiece king, ChessBoard board, bool skipSafetyCheck}) {
    return MoveCalculation.kingKnightPawnMoveHelper(
      piece: king,
      board: board,
      relativeMoves: [
        Tile(row: 1, col: 0), Tile(row: -1, col: 0),
        Tile(row: 0, col: 1), Tile(row: 0, col: -1),
        Tile(row: 1, col: 1), Tile(row: 1, col: -1),
        Tile(row: -1, col: 1), Tile(row: -1, col: -1)
      ],
      skipSafetyCheck: skipSafetyCheck
    ) + kingCastling(king: king, board: board, skipSafetyCheck: skipSafetyCheck);
  }

  static List<Tile> kingCastling({ChessPiece king, ChessBoard board, bool skipSafetyCheck}) {
    List<Tile> castleMoves = [];
    for (var rook in board.rooksForPlayer(king.player)) {
      if (canCastle(king: king, rook: rook, board: board, skipSafetyCheck: skipSafetyCheck)) {
        castleMoves.add(rook.tile);
      }
    }
    return MoveCalculation.filterSafeMoves(
      piece: king,
      board: board,
      possibleMoves: castleMoves,
      skipSafetyCheck: skipSafetyCheck
    );
  }

  static bool canCastle({
    @required ChessPiece king,
    @required ChessPiece rook,
    @required ChessBoard board,
    @required bool skipSafetyCheck
  }) {
    bool kingInCheck;
    if (skipSafetyCheck) {
      kingInCheck = false;
    } else {
      kingInCheck = kingIsInCheck(player: king.player, board: board, skipSafetyCheck: true);
    }
    if (rook.moveCount == 0 && king.moveCount == 0 && !kingInCheck) {
      var range = (king.tile.col - rook.tile.col).abs();
      var offset = king.tile.col - rook.tile.col > 0 ? 1 : -1;
      var tileToCheck = rook.tile;
      for (var index = 0; index < range; index++) {
        tileToCheck = Tile(row: tileToCheck.row, col: tileToCheck.col + offset);
        if (tileToCheck == king.tile) {
          return true;
        }
        if (board.pieceAtTile(tileToCheck) != null) {
          break;
        }
      }
    }
    return false;
  }

  static List<Tile> kingKnightPawnMoveHelper({
    ChessPiece piece,
    ChessBoard board,
    List<Tile> relativeMoves,
    bool skipSafetyCheck
  }) {
    List<Tile> validMoves = [];
    for (var move in relativeMoves) {
      var possibleMove = Tile(
        row: piece.tile.row + move.row,
        col: piece.tile.col + move.col
      );
      if (SharedFunctions.tileInBounds(possibleMove)) {
        var takenPiece = board.pieceAtTile(possibleMove);
        if (takenPiece == null || (takenPiece.player != piece.player && piece.type != ChessPieceType.pawn)) {
          validMoves.add(possibleMove);
        }
      }
    }
    return MoveCalculation.filterSafeMoves(
        piece: piece,
        board: board,
        possibleMoves: validMoves,
        skipSafetyCheck: skipSafetyCheck
    );
  }

  static List<Tile> bishopQueenRookMoveHelper({
    ChessPiece piece,
    ChessBoard board,
    List<Tile> directions,
    bool skipSafetyCheck
  }) {
    List<Tile> validMoves = [];
    for (var direction in directions) {
      var possibleMove = piece.tile;
      while (SharedFunctions.tileInBounds(possibleMove)) {
        possibleMove = Tile(
          row: possibleMove.row + direction.row,
          col: possibleMove.col + direction.col
        );
        if (SharedFunctions.tileInBounds(possibleMove)) {
          var takenPiece = board.pieceAtTile(possibleMove);
          if (takenPiece == null) {
            validMoves.add(possibleMove);
          } else {
            if (takenPiece.player != piece.player) {
              validMoves.add(possibleMove);
            }
            break;
          }
        }
      }
    }
    return MoveCalculation.filterSafeMoves(
      piece: piece,
      board: board,
      possibleMoves: validMoves,
      skipSafetyCheck: skipSafetyCheck
    );
  }

  static List<Tile> filterSafeMoves({
    ChessPiece piece,
    ChessBoard board,
    List<Tile> possibleMoves,
    bool skipSafetyCheck
  }) {
    List<Tile> validMoves = [];
    for (var move in possibleMoves) {
      if (!MoveCalculation.movePutsKingInCheck(
        piece: piece,
        to: move,
        board: board,
        skipSafetyCheck: skipSafetyCheck
      )) {
        validMoves.add(move);
      }
    }
    return validMoves;
  }

  static bool movePutsKingInCheck({
    ChessPiece piece,
    Tile to,
    ChessBoard board,
    bool skipSafetyCheck
  }) {
    if (!skipSafetyCheck) {
      var boardCopy = board.copy();
      boardCopy.movePiece(from: piece.tile, to: to);
      return MoveCalculation.kingIsInCheck(player: piece.player, board: boardCopy, skipSafetyCheck: true);
    }
    return false;
  }

  static bool kingIsInCheck({PlayerID player, ChessBoard board, bool skipSafetyCheck = false}) {
    var enemyPieces = board.piecesForPlayer(SharedFunctions.oppositePlayer(player));
    for (var piece in enemyPieces) {
      if (SharedFunctions.tileIsInTileList(
        tile: board.kingForPlayer(player).tile,
        tileList: MoveCalculation.movesFor(piece: piece, board: board, skipSafetyCheck: skipSafetyCheck)
      )) {
        return true;
      }
    }
    return false;
  }

  static bool kingIsInCheckmate({PlayerID player, ChessBoard board}) {
    for (var piece in board.piecesForPlayer(player)) {
      if (MoveCalculation.movesFor(piece: piece, board: board).isNotEmpty) {
        return false;
      }
    }
    return true;
  }
}
