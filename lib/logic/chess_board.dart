import 'package:en_passant/logic/move_calculation/move_classes/move_stack_object.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';

import 'chess_piece.dart';
import 'move_calculation/move_calculation.dart';

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
      var pawn = ChessPiece(ChessPieceType.pawn, player, pawnRowOffset + index);
      piecesForPlayer(player, this).addAll([piece, pawn]);
      if (piece.type == ChessPieceType.king) {
        player == Player.player1 ? player1King = piece : player2King = piece;
      } else if (piece.type == ChessPieceType.queen) {
        queensForPlayer(player, this).add(piece);
      } else if (piece.type == ChessPieceType.rook) {
        rooksForPlayer(player, this).add(piece);
      }
    }
  }
}
