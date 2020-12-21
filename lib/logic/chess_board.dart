import 'package:en_passant/logic/tile.dart';
import 'package:en_passant/views/components/main_menu/piece_color_picker.dart';

import 'chess_piece.dart';

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
  ChessPiece enPassantPiece;

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

  void addPiecesFor({PlayerID player}) {
    for (var index = 0; index < 8; index++) {
      var pawn = ChessPiece(
        type: ChessPieceType.pawn,
        belongsTo: player,
        tile: Tile(row: player == PlayerID.player1 ? 1 : 6, col: index)
      );
      var piece = ChessPiece(
        type: KING_ROW_PIECES[index],
        belongsTo: player,
        tile: Tile(row: player == PlayerID.player1 ? 0 : 7, col: index)
      );
      addPiece(piece: pawn, tile: pawn.tile);
      addPiece(piece: piece, tile: piece.tile);
      if (piece.type == ChessPieceType.king) {
        piece.player == PlayerID.player1 ?
          player1King = piece : player2King = piece;
      } else if (piece.type == ChessPieceType.rook) {
        piece.player == PlayerID.player1 ?
          player1Rooks.add(piece) : player2Rooks.add(piece);
      }
    }
  }

  void addPiece({ChessPiece piece, Tile tile}) {
    board[tile.row][tile.col] = piece;
    piece.player == PlayerID.player1 ?
      player1Pieces.add(piece) : player2Pieces.add(piece);
  }

  ChessPiece pieceAtTile(Tile tile) {
    return board[tile.row][tile.col];
  }

  List<ChessPiece> piecesForPlayer(PlayerID player) {
    return player == PlayerID.player1 ? player1Pieces : player2Pieces;
  }

  ChessPiece kingForPlayer(PlayerID player) {
    return player == PlayerID.player1 ? player1King : player2King;
  }
}