import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';

import 'move_calculation/move_classes/tile.dart';

bool tileInBounds(int tile) {
  return tile >= 0 && tile < 64;
}

PlayerID oppositePlayer(PlayerID player) {
  return player == PlayerID.player1 ? PlayerID.player2 : PlayerID.player1;
}

bool tileIsInTileList(Tile tile, List<Tile> tileList) {
  for (var t in tileList) {
    if (t == tile) {
      return true;
    }
  }
  return false;
}

double getXFromCol(int col, double tileSize, AppModel appModel) {
  return appModel.playingWithAI && appModel.playerSide == PlayerID.player2 ? 
    (7 - col) * tileSize : col * tileSize;
}

double getYFromRow(int row, double tileSize, AppModel appModel) {
  return appModel.playingWithAI && appModel.playerSide == PlayerID.player2 ? 
    row * tileSize : (7 - row) * tileSize;
}
