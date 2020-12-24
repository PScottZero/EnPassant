import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/settings/game_settings.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

import 'move_classes.dart';

enum ChessPieceType { pawn, rook, knight, bishop, king, queen }

class ChessPiece {
  ChessPieceType type;
  PlayerID player;
  int moveCount = 0;
  Tile tile;
  Sprite sprite;

  // for animations
  double spriteX;
  double spriteY;
  double offsetX = 0;
  double offsetY = 0;
  bool isMoving = false;
  
  int get value {
    int value = 0;
    switch (type) {
      case ChessPieceType.pawn: { value = 1; }
      break;
      case ChessPieceType.bishop: { value = 3; }
      break;
      case ChessPieceType.knight: { value = 3; }
      break;
      case ChessPieceType.rook: { value = 5; }
      break;
      case ChessPieceType.queen: { value = 9; }
      break;
      case ChessPieceType.king: { value = 10000; }
      break;
      default: { value = 0 ;}
    }
    return (player == PlayerID.player1) ? value : -value;
  }

  ChessPiece({ChessPieceType type, PlayerID belongsTo, Tile tile}) {
    this.type = type;
    this.tile = tile;
    player = belongsTo;
    initSprite();
  }

  ChessPiece.fromPiece({@required ChessPiece existingPiece}) {
    this.type = existingPiece.type;
    this.player = existingPiece.player;
    this.moveCount = existingPiece.moveCount;
    this.tile = existingPiece.tile.copy();
    this.sprite = existingPiece.sprite;
  }

  void update({@required double tileSize, @required GameSettings gameSettings}) {
    var currX = SharedFunctions.getXFromCol(tile.col, tileSize, gameSettings);
    var currY = SharedFunctions.getYFromRow(tile.row, tileSize, gameSettings);
    if ((currX - spriteX).abs() <= 0.1) {
      spriteX = currX;
      offsetX = 0;
      isMoving = false;
    } else {
      if (offsetX == 0) {
        offsetX = (currX - spriteX) / 10;
      }
      spriteX += offsetX;
      isMoving = true;
    }
    if ((currY - spriteY).abs() <= 0.1) {
      spriteY = currY;
      offsetY = 0;
      isMoving = false;
    } else {
      if (offsetY == 0) {
        offsetY = (currY - spriteY) / 10;
      }
      spriteY += offsetY;
      isMoving = true;
    }
  }

  void initSprite() {
    String color = player == PlayerID.player1 ? 'white' : 'black';
    String pieceName = type.toString().substring(type.toString().indexOf('.') + 1);
    sprite = Sprite('pieces/' + pieceName + '_' + color + '.png');
  }

  void initSpritePosition(double tileSize, GameSettings gameSettings) {
    spriteX = SharedFunctions.getXFromCol(tile.col, tileSize, gameSettings);
    spriteY = SharedFunctions.getYFromRow(tile.row, tileSize, gameSettings);
  }
  
  @override
  bool operator == (obj) {
    return obj is ChessPiece && obj.sprite == sprite;
  }

  @override
  int get hashCode => sprite.hashCode;
}
