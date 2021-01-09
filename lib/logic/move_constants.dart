import 'package:en_passant/views/components/main_menu_view/side_picker.dart';

import 'move_classes.dart';

class MoveConstants {
  static List<Tile> pawnStandardMove(PlayerID player) {
    return player == PlayerID.player1 ? 
      [Tile(1, 0)] : [Tile(-1, 0)];
  }
  static List<Tile> pawnFirstMove(PlayerID player) {
    return player == PlayerID.player1 ? 
      [Tile(2, 0)] : [Tile(-2, 0)];
  }
  static List<Tile> pawnDiagonalMoves(PlayerID player) {
    return player == PlayerID.player1 ?
      [Tile(1, -1), Tile(1, 1)] :
      [Tile(-1, -1), Tile(-1, 1)];
  }
  static var knightMoves = [
    Tile(1, 2), Tile(1, -2),
    Tile(-1, 2), Tile(-1, -2),
    Tile(2, 1), Tile(2, -1),
    Tile(-2, 1), Tile(-2, -1)
  ];
  static var bishopMoves = [
    Tile(1, 1), Tile(1, -1),
    Tile(-1, 1), Tile(-1, -1)
  ];
  static var rookMoves = [
    Tile(1, 0), Tile(-1, 0),
    Tile(0, 1), Tile(0, -1)
  ];
  static var kingQueenMoves = [
    Tile(1, 0), Tile(-1, 0),
    Tile(0, 1), Tile(0, -1),
    Tile(1, 1), Tile(1, -1),
    Tile(-1, 1), Tile(-1, -1)
  ];
}