import 'package:en_passant/logic/chess_board.dart';
import 'package:en_passant/views/components/main_menu/piece_color_picker.dart';

import 'chess_piece.dart';
import 'shared_functions.dart';
import 'tile.dart';

class MoveCalculation {
  static List<Tile> movesFor({ChessPiece piece, ChessBoard board, bool skipCheck = false}) {
    switch (piece.type) {
      case ChessPieceType.pawn: {
        return pawnMoves(pawn: piece, board: board, skipCheck: skipCheck);
      }
      default: { return []; }
    }
  }

  static List<Tile> pawnMoves({ChessPiece pawn, ChessBoard board, bool skipCheck}) {
    var validMoves = kingKnightPawnMoveHelper(
      piece: pawn,
      board: board,
      relativeMoves: pawnStandardMoves(pawn: pawn),
      skipCheck: skipCheck
    );
    if (validMoves.length == 1) {
      if ((validMoves[0].row - pawn.tile.row).abs() > 1) {
        validMoves = [];
      }
    }
    validMoves += MoveCalculation.pawnDiagonalAttack(pawn: pawn, board: board);
    return validMoves;
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
      [Tile(row: -1, col: -1), Tile(row: -1, col: -1)];
    for (var diagonal in diagonals) {
      var possibleMove = Tile(
        row: pawn.tile.row + diagonal.row,
        col: pawn.tile.col + diagonal.col
      );
      if (SharedFunctions.tileInBounds(possibleMove)) {
        var takenPiece = board.pieceAtTile(possibleMove);
        if ((takenPiece != null && takenPiece.player != takenPiece.player) ||
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

  static List<Tile> kingKnightPawnMoveHelper({
    ChessPiece piece,
    ChessBoard board,
    List<Tile> relativeMoves,
    bool skipCheck
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
    return validMoves;
  }

  static bool movePutsKingInCheck({
    Tile from,
    Tile to,
    PlayerID player,
    ChessBoard board,
    bool skipCheck
  }) {
    if (!skipCheck) {
      var boardCopy = board.copy();
      // boardCopy.movePiece(from: from, to: to);
      return MoveCalculation.kingIsInCheck(player: player, board: boardCopy, skipCheck: true);
    }
    return false;
  }

  static bool kingIsInCheck({PlayerID player, ChessBoard board, bool skipCheck = false}) {
    var enemyPieces = board.piecesForPlayer(SharedFunctions.oppositePlayer(player));
    for (var piece in enemyPieces) {
      if (SharedFunctions.tileIsInTileList(
        tile: board.kingForPlayer(player).tile,
        tileList: MoveCalculation.movesFor(piece: piece, board: board, skipCheck: skipCheck)
      )) {
        return true;
      }
    }
    return false;
  }
}