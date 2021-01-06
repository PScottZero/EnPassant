import 'move_meta.dart';
import 'tile.dart';

class Move {
  Tile from;
  Tile to;
  MoveMeta meta = MoveMeta();
  Move(this.from, this.to);
  Move.invalid() {
    this.from = Tile.invalid();
    this.to = Tile.invalid();
  }
}
