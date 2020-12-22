import 'package:en_passant/views/components/main_menu_view/piece_color_picker.dart';

import 'tile.dart';

class SharedFunctions {
  static bool tileInBounds(Tile tile) {
    return tile.row >= 0 && tile.row < 8 && tile.col >= 0 && tile.col < 8;
  }

  static PlayerID oppositePlayer(PlayerID player) {
    return player == PlayerID.player1 ? PlayerID.player2 : PlayerID.player1;
  }

  static bool tileIsInTileList({Tile tile, List<Tile> tileList}) {
    for (var t in tileList) {
      if (t == tile) {
        return true;
      }
    }
    return false;
  }
}