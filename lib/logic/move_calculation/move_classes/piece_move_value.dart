import '../../chess_piece.dart';

class PieceMoveValue {
  ChessPiece piece;
  int tile;
  int value = 0;
  PieceMoveValue(this.piece, this.tile, {this.value = 0});
}