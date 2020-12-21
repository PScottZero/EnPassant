import 'package:en_passant/logic/tile.dart';
import 'package:en_passant/views/components/main_menu/piece_color_picker.dart';
import 'package:flame/sprite.dart';

enum ChessPieceType { pawn, rook, knight, bishop, king, queen }

class ChessPiece {
  ChessPieceType type;
  PlayerID player;
  double value;
  int moveCount = 0;
  Tile tile;
  Sprite sprite;

  ChessPiece({ChessPieceType type, PlayerID belongsTo, Tile tile}) {
    this.type = type;
    this.tile = tile;
    player = belongsTo;
    value = belongsTo == PlayerID.player1 ? getValue() : -getValue();
    initSprite();
  }

  void initSprite() {
    String color = player == PlayerID.player1 ? 'white' : 'black';
    String pieceName = type.toString().substring(type.toString().indexOf('.') + 1);
    sprite = Sprite('pieces/' + pieceName + '_' + color + '.png');
  }

  double getValue() {
    switch (type) {
      case ChessPieceType.pawn: { return 1; }
      case ChessPieceType.bishop: { return 3; }
      case ChessPieceType.knight: { return 3; }
      case ChessPieceType.rook: { return 5; }
      case ChessPieceType.queen: { return 9; }
      case ChessPieceType.king: { return double.infinity; }
      default: { return 0; }
    }
  }
}
