import '../../chess_piece.dart';
import 'move.dart';

class MoveStackObject {
  Move move;
  ChessPiece movedPiece;
  ChessPiece takenPiece;
  ChessPiece enPassantPiece;
  bool castled = false;
  bool promotion = false;
  ChessPieceType promotionType;
  bool enPassant = false;
  List<List<Move>> possibleOpenings;

  MoveStackObject(this.move, this.movedPiece, this.takenPiece,
      this.enPassantPiece, this.possibleOpenings);
}
