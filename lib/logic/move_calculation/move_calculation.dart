import 'package:en_passant/logic/chess_board.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';

import '../chess_piece.dart';
import 'move_classes/move.dart';
import 'move_classes/tile.dart';
import 'move_constants.dart';
import '../shared_functions.dart';

class MoveCalculation {
  static List<Move> allMoves(PlayerID player, ChessBoard board) {
    List<Move> moves = [];
    var pieces = board.piecesForPlayer(player);
    for (var piece in pieces) {
      var tiles = movesForPiece(piece, board);
      for (var tile in tiles) {
        moves.add(Move(piece.tile, tile));
      }
    }
    moves.sort((a, b) => MoveCalculation.compareMoves(a, b, player, board));
    return moves;
  }

  static int compareMoves(Move a, Move b, PlayerID player, ChessBoard board) {
    board.push(a);
    var aVal = board.value;
    board.pop();
    board.push(b);
    var bVal = board.value;
    board.pop();
    return player == PlayerID.player1 ?
      bVal.compareTo(aVal) : aVal.compareTo(bVal);
  }

  static List<Tile> movesForPiece(ChessPiece piece, ChessBoard board,
    {bool skipSafetyCheck = false}) {
    switch (piece.type) {
      case ChessPieceType.pawn:{
        return _pawnMoves(piece, board, skipSafetyCheck);
      }
      case ChessPieceType.bishop: {
        return _bishopMoves(piece, board, skipSafetyCheck);
      }
      case ChessPieceType.knight: {
        return _knightMoves(piece, board, skipSafetyCheck);
      }
      case ChessPieceType.rook: {
        return _rookMoves(piece, board, skipSafetyCheck);
      }
      case ChessPieceType.queen: {
        return _queenMoves(piece, board, skipSafetyCheck);
      }
      case ChessPieceType.king: {
        return _kingMoves(piece, board, skipSafetyCheck);
      }
      default: { return []; }
    }
  }

  static List<Tile> _pawnMoves(ChessPiece pawn, ChessBoard board,
    bool skipSafetyCheck) {
    var validMoves = _kingKnightPawnMoveHelper(pawn, board,
      _pawnStandardMoves(pawn), skipSafetyCheck);
    if (validMoves.length == 1) {
      if ((validMoves[0].row - pawn.tile.row).abs() > 1) {
        validMoves = [];
      }
    }
    validMoves += MoveCalculation._pawnDiagonalAttack(pawn, board);
    return MoveCalculation._filterSafeMoves(pawn, board, validMoves,
      skipSafetyCheck);
  }

  static List<Tile> _pawnStandardMoves(ChessPiece pawn) {
    List<Tile> relativeMoves = MoveConstants.pawnStandardMove(pawn.player);
    if (pawn.moveCount == 0) {
      relativeMoves += MoveConstants.pawnFirstMove(pawn.player);
    }
    return relativeMoves;
  }

  static List<Tile> _pawnDiagonalAttack(ChessPiece pawn, ChessBoard board) {
    List<Tile> validMoves = [];
    for (var diagonal in MoveConstants.pawnDiagonalMoves(pawn.player)) {
      var possibleMove = Tile(pawn.tile.row + diagonal.row,
        pawn.tile.col + diagonal.col);
      if (SharedFunctions.tileInBounds(possibleMove)) {
        var takenPiece = board.pieceAtTile(possibleMove);
        if ((takenPiece != null && takenPiece.player != pawn.player) ||
          _canTakeEnPassant(pawn.player, possibleMove, board)) {
          validMoves.add(possibleMove);
        }
      }
    }
    return validMoves;
  }

  static bool _canTakeEnPassant(PlayerID pawnPlayer, Tile diagonal,
    ChessBoard board) {
    var rowOffset = (pawnPlayer == PlayerID.player1) ? -1 : 1;
    var takenPiece = board.pieceAtTile(
      Tile(diagonal.row + rowOffset, diagonal.col)
    );
    return takenPiece != null && takenPiece == board.enPassantPiece;
  }

  static List<Tile> _bishopMoves(ChessPiece bishop, ChessBoard board,
    bool skipSafetyCheck) {
    return MoveCalculation._bishopQueenRookMoveHelper(bishop, board,
      MoveConstants.bishopMoves, skipSafetyCheck);
  }
  
  static List<Tile> _knightMoves(ChessPiece knight, ChessBoard board,
    bool skipSafetyCheck) {
    return MoveCalculation._kingKnightPawnMoveHelper(knight, board,
      MoveConstants.knightMoves, skipSafetyCheck);
  }

  static List<Tile> _rookMoves(ChessPiece rook, ChessBoard board,
    bool skipSafetyCheck) {
    return MoveCalculation._bishopQueenRookMoveHelper(rook, board,
      MoveConstants.rookMoves, skipSafetyCheck) +
      _rookCastling(rook, board, skipSafetyCheck);
  }

  static List<Tile> _rookCastling(ChessPiece rook, ChessBoard board,
    bool skipSafetyCheck) {
    var king = board.kingForPlayer(rook.player);
    if (_canCastle(king, rook, board, skipSafetyCheck)) {
      return MoveCalculation._filterSafeMoves(rook, board, [king.tile],
        skipSafetyCheck);
    }
    return [];
  }

  static List<Tile> _queenMoves(ChessPiece queen, ChessBoard board,
    bool skipSafetyCheck) {
    return MoveCalculation._bishopQueenRookMoveHelper(queen, board,
      MoveConstants.kingQueenMoves, skipSafetyCheck);
  }

  static List<Tile> _kingMoves(ChessPiece king, ChessBoard board,
    bool skipSafetyCheck) {
    return MoveCalculation._kingKnightPawnMoveHelper(king, board,
      MoveConstants.kingQueenMoves, skipSafetyCheck) +
      _kingCastling(king, board, skipSafetyCheck);
  }

  static List<Tile> _kingCastling(ChessPiece king, ChessBoard board,
    bool skipSafetyCheck) {
    List<Tile> castleMoves = [];
    for (var rook in board.rooksForPlayer(king.player)) {
      if (_canCastle(king, rook, board, skipSafetyCheck)) {
        castleMoves.add(rook.tile);
      }
    }
    return MoveCalculation._filterSafeMoves(king, board, castleMoves,
      skipSafetyCheck);
  }

  static bool _canCastle(ChessPiece king, ChessPiece rook, ChessBoard board,
    bool skipSafetyCheck) {
    bool kingInCheck;
    if (skipSafetyCheck) {
      kingInCheck = false;
    } else {
      kingInCheck = kingIsInCheck(king.player, board, skipSafetyCheck: true);
    }
    if (rook.moveCount == 0 && king.moveCount == 0 && !kingInCheck) {
      var range = (king.tile.col - rook.tile.col).abs();
      var offset = king.tile.col - rook.tile.col > 0 ? 1 : -1;
      var tileToCheck = rook.tile;
      for (var index = 0; index < range; index++) {
        tileToCheck = Tile(tileToCheck.row, tileToCheck.col + offset);
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

  static List<Tile> _kingKnightPawnMoveHelper(ChessPiece piece,
    ChessBoard board, List<Tile> relativeMoves, bool skipSafetyCheck) {
    List<Tile> validMoves = [];
    for (var move in relativeMoves) {
      var possibleMove = Tile(piece.tile.row + move.row,
        piece.tile.col + move.col);
      if (SharedFunctions.tileInBounds(possibleMove)) {
        var takenPiece = board.pieceAtTile(possibleMove);
        if (takenPiece == null ||
          (takenPiece.player != piece.player &&
          piece.type != ChessPieceType.pawn)) {
          validMoves.add(possibleMove);
        }
      }
    }
    return MoveCalculation._filterSafeMoves(piece, board, validMoves,
      skipSafetyCheck);
  }

  static List<Tile> _bishopQueenRookMoveHelper(ChessPiece piece,
    ChessBoard board, List<Tile> directions, bool skipSafetyCheck) {
    List<Tile> validMoves = [];
    for (var direction in directions) {
      var possibleMove = piece.tile;
      while (SharedFunctions.tileInBounds(possibleMove)) {
        possibleMove = Tile(possibleMove.row + direction.row,
          possibleMove.col + direction.col);
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
    return MoveCalculation._filterSafeMoves(piece, board, validMoves,
      skipSafetyCheck);
  }

  static List<Tile> _filterSafeMoves(ChessPiece piece, ChessBoard board,
    List<Tile> possibleMoves, bool skipSafetyCheck) {
    List<Tile> validMoves = [];
    for (var move in possibleMoves) {
      if (!MoveCalculation._movePutsKingInCheck(piece, move, board,
        skipSafetyCheck)) {
        validMoves.add(move);
      }
    }
    return validMoves;
  }

  static bool _movePutsKingInCheck(ChessPiece piece, Tile to, ChessBoard board,
    bool skipSafetyCheck) {
    if (!skipSafetyCheck) {
      board.push(Move(piece.tile, to));
      var kingInCheck = MoveCalculation.kingIsInCheck(piece.player,
        board, skipSafetyCheck: true);
      board.pop();
      return kingInCheck;
    }
    return false;
  }

  static bool kingIsInCheck(PlayerID player, ChessBoard board,
    {bool skipSafetyCheck = false}) {
    var enemyPieces = board.piecesForPlayer(
      SharedFunctions.oppositePlayer(player));
    for (var piece in enemyPieces) {
      if (SharedFunctions.tileIsInTileList(board.kingForPlayer(player).tile,
        MoveCalculation.movesForPiece(piece, board,
        skipSafetyCheck: skipSafetyCheck))) {
        return true;
      }
    }
    return false;
  }

  static bool kingIsInCheckmate(PlayerID player, ChessBoard board) {
    for (var piece in board.piecesForPlayer(player)) {
      if (MoveCalculation.movesForPiece(piece, board).isNotEmpty) {
        return false;
      }
    }
    return true;
  }
}
