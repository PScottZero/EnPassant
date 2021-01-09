import '../../chess_piece.dart';
import 'tile.dart';

class MoveStackObject {
  Tile from;
  ChessPiece movedPiece;
  ChessPiece takenPiece;
  bool castling = false;
  bool promotion = false;
  bool enPassant = false;
  MoveStackObject(this.from, this.movedPiece, this.takenPiece);
}
