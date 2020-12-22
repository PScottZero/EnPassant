import 'package:en_passant/logic/tile.dart';

class Move {
  Tile from;
  Tile to;
  Move({this.from, this.to});
}

class MoveAndValue {
  Move move;
  int value;
  MoveAndValue({this.move, this.value});
}