import 'chess_piece.dart';
import 'move_classes.dart';

const aiPlayerArg = 'aiPlayer';
const aiDifficultyArg = 'aiDifficulty';
const aiBoardArg = 'board';
const tileCount = 64;
const tileCountPerRow = tileCount ~/ 8;
const minDimIndex = 0;
const maxDimIndex = 7;
const middleTileIndices = [3, 4];
const endTileIndices = [minDimIndex, maxDimIndex];

const directionUp = Direction(1, 0);
const directionUpRight = Direction(1, 1);
const directionRight = Direction(0, 1);
const directionDownRight = Direction(-1, 1);
const directionDown = Direction(-1, 0);
const directionDownLeft = Direction(-1, -1);
const directionLeft = Direction(0, -1);
const directionUpLeft = Direction(1, -1);

int tileToRow(int tile) => (tile / tileCountPerRow).floor();

int tileToCol(int tile) => tile % tileCountPerRow;

double getXFromTile(
  int tile,
  double tileSize,
  bool flip,
  bool playingWithAI,
  bool isP2Turn,
) =>
    flip && playingWithAI && isP2Turn
        ? ((tileCountPerRow - 1) - tileToCol(tile)) * tileSize
        : tileToCol(tile) * tileSize;

double getYFromTile(
  int tile,
  double tileSize,
  bool flip,
  bool playingWithAI,
  bool isP2Turn,
) =>
    flip && playingWithAI && isP2Turn
        ? ((tileCountPerRow - 1) - tileToRow(tile)) * tileSize
        : tileToRow(tile) * tileSize;

String themeNameToAssetDir(String themeName) =>
    themeName.toLowerCase().replaceAll(' ', '');

String pieceTypeToString(ChessPieceType type) =>
    type.toString().substring(type.toString().indexOf('.') + 1);

bool equalToAny<T>(T obj, List<T> objs) {
  for (var obj1 in objs) if (obj == obj1) return true;
  return false;
}
