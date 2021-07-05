import 'package:en_passant/logic/chess_piece.dart';
import 'package:en_passant/model/app_model.dart';

const AI_PLAYER_ARG = 'aiPlayer';
const AI_DIFFICULTY_ARG = 'aiDifficulty';
const AI_BOARD_ARG = 'board';
const TILE_COUNT = 64;
const TILE_COUNT_PER_ROW = TILE_COUNT ~/ 8;
const MIN_DIM_INDEX = 0;
const MAX_DIM_INDEX = 7;
const MIDDLE_TILE_INDICES = [3, 4];
const END_TILE_INDICES = [MIN_DIM_INDEX, MAX_DIM_INDEX];

int tileToRow(int tile) => (tile / TILE_COUNT_PER_ROW).floor();

int tileToCol(int tile) => tile % TILE_COUNT_PER_ROW;

double getXFromTile(int tile, double tileSize, AppModel model) =>
    model.flip && model.gameData.playingWithAI && model.gameData.isP2Turn
        ? ((TILE_COUNT_PER_ROW - 1) - tileToCol(tile)) * tileSize
        : tileToCol(tile) * tileSize;

double getYFromTile(int tile, double tileSize, AppModel model) =>
    model.flip && model.gameData.playingWithAI && model.gameData.isP2Turn
        ? ((TILE_COUNT_PER_ROW - 1) - tileToRow(tile)) * tileSize
        : tileToRow(tile) * tileSize;

String themeNameToAssetDir(String themeName) =>
    themeName.toLowerCase().replaceAll(' ', '');

String pieceTypeToString(ChessPieceType type) =>
    type.toString().substring(type.toString().indexOf('.') + 1);

bool equalToAny<T>(T obj, List<T> objs) {
  for (var obj1 in objs) if (obj == obj1) return true;
  return false;
}
