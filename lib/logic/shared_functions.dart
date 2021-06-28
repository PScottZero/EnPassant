import 'package:en_passant/logic/chess_piece.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/model/player.dart';

int tileToRow(int tile) {
  return (tile / 8).floor();
}

int tileToCol(int tile) {
  return tile % 8;
}

double getXFromTile(int tile, double tileSize, AppModel appModel) {
  return appModel.flip &&
          appModel.gameData.playingWithAI &&
          appModel.gameData.playerSide == Player.player2
      ? (7 - tileToCol(tile)) * tileSize
      : tileToCol(tile) * tileSize;
}

double getYFromTile(int tile, double tileSize, AppModel appModel) {
  return appModel.flip &&
          appModel.gameData.playingWithAI &&
          appModel.gameData.playerSide == Player.player2
      ? (7 - tileToRow(tile)) * tileSize
      : tileToRow(tile) * tileSize;
}

String themeNameToDir(String themeName) {
  return themeName.toLowerCase().replaceAll(' ', '');
}

String pieceTypeToString(ChessPieceType type) {
  return type.toString().substring(type.toString().indexOf('.') + 1);
}
