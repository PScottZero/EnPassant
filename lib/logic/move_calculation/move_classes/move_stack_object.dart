import '../../chess_piece.dart';
import 'move.dart';

class MoveStackObject {
  Move move;
  ChessPiece movedPiece;
  ChessPiece takenPiece;
  ChessPiece enPassantPiece;
  bool castled = false;
  bool promotion = false;
  bool enPassant = false;
  MoveStackObject(this.move, this.movedPiece, this.takenPiece, this.enPassantPiece) {
    move.meta.player = movedPiece.player;
    move.meta.type = movedPiece.type;
  }
}
