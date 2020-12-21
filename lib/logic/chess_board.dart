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

  ChessBoard() {
    this.board = List.generate(8, (index) => List.generate(8, (index) => null));
    addPiecesFor(player: PlayerID.player1);
    addPiecesFor(player: PlayerID.player2);
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
}