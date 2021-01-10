import '../../chess_piece.dart';

class MoveStackObject {
  int from;
  int to;
  ChessPiece movedPiece;
  ChessPiece takenPiece;
  ChessPiece enPassantPiece;
  bool castled = false;
  bool promotion = false;
  bool enPassant = false;
  MoveStackObject(this.from, this.to, this.movedPiece,
    this.takenPiece, this.enPassantPiece);
}
