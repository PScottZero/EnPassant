import 'package:en_passant/settings/game_settings.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';

import 'move_classes.dart';

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

  static double getXFromCol(int col, double tileSize, GameSettings gameSettings) {
    return gameSettings.playingWithAI && gameSettings.playerSide == PlayerID.player2 ? 
      (7 - col) * tileSize : col * tileSize;
  }

  static double getYFromRow(int row, double tileSize, GameSettings gameSettings) {
    return gameSettings.playingWithAI && gameSettings.playerSide == PlayerID.player2 ? 
      row * tileSize : (7 - row) * tileSize;
  }
}