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
  List<List<Move>> possibleOpenings;
  MoveStackObject(this.move, this.movedPiece,
    this.takenPiece, this.enPassantPiece, this.possibleOpenings);
}
