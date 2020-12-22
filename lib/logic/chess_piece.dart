import 'package:en_passant/logic/tile.dart';
import 'package:en_passant/views/components/main_menu/piece_color_picker.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

enum ChessPieceType { pawn, rook, knight, bishop, king, queen }

class ChessPiece {
  ChessPieceType type;
  PlayerID player;
  double value;
  int moveCount = 0;
  Tile tile;
  Sprite sprite;

  // for animations
  double spriteX;
  double spriteY;
  double offsetX = 0;
  double offsetY = 0;

  ChessPiece({ChessPieceType type, PlayerID belongsTo, Tile tile}) {
    this.type = type;
    this.tile = tile;
    player = belongsTo;
    value = belongsTo == PlayerID.player1 ? getValue() : -getValue();
    initSprite();
  }

  ChessPiece.fromPiece({@required ChessPiece existingPiece}) {
    this.type = existingPiece.type;
    this.player = existingPiece.player;
    this.value = existingPiece.value;
    this.moveCount = existingPiece.moveCount;
    this.tile = existingPiece.tile.copy();
    this.sprite = existingPiece.sprite;
  }

  void update({@required double tileSize}) {
    var currX = tile.col * tileSize;
    var currY = (7 - tile.row) * tileSize;
    if ((currX - spriteX).abs() <= 0.1) {
      spriteX = currX;
      offsetX = 0;
    } else {
      if (offsetX == 0) {
        offsetX = (currX - spriteX) / 10;
      }
      spriteX += offsetX;
    }
    if ((currY - spriteY).abs() <= 0.1) {
      spriteY = currY;
      offsetY = 0;
    } else {
      if (offsetY == 0) {
        offsetY = (currY - spriteY) / 10;
      }
      spriteY += offsetY;
    }
  }

  void initSprite() {
    String color = player == PlayerID.player1 ? 'white' : 'black';
    String pieceName = type.toString().substring(type.toString().indexOf('.') + 1);
    sprite = Sprite('pieces/' + pieceName + '_' + color + '.png');
  }

  void initSpritePosition(double tileSize) {
    spriteX = tile.col * tileSize;
    spriteY = (7 - tile.row) * tileSize;
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
  
  @override
  bool operator == (obj) {
    return obj is ChessPiece && obj.sprite == sprite;
  }

  @override
  int get hashCode => sprite.hashCode;
}
