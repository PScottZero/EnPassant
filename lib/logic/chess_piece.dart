import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

import 'move_calculation/move_classes/tile.dart';

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
  
  int get value {
    int value = 0;
    switch (type) {
      case ChessPieceType.pawn: { value = 100; }
      break;
      case ChessPieceType.knight: { value = 320; }
      break;
      case ChessPieceType.bishop: { value = 330; }
      break;
      case ChessPieceType.rook: { value = 500; }
      break;
      case ChessPieceType.queen: { value = 900; }
      break;
      case ChessPieceType.king: { value = 20000; }
      break;
      default: { value = 0 ;}
    }
    return (player == PlayerID.player1) ? value : -value;
  }

  ChessPiece({ChessPieceType type, PlayerID belongsTo, Tile tile}) {
    this.type = type;
    this.tile = tile;
    this.player = belongsTo;
    initSprite();
  }

  void update({@required double tileSize, @required AppModel appModel}) {
    var currX = SharedFunctions.getXFromCol(tile.col, tileSize, appModel);
    var currY = SharedFunctions.getYFromRow(tile.row, tileSize, appModel);
    if ((currX - spriteX).abs() <= 0.1 && (currY - spriteY).abs() <= 0.1) {
      spriteX = currX;
      spriteY = currY;
      offsetX = 0;
      offsetY = 0;
    } else {
      if (offsetX == 0) {
        offsetX = (currX - spriteX) / 10;
      }
      if (offsetY == 0) {
        offsetY = (currY - spriteY) / 10;
      }
      spriteX += offsetX;
      spriteY += offsetY;
      if ((currX - spriteX).abs() <= 0.1 && (currY - spriteY).abs() <= 0.1) {
        if (appModel.soundEnabled) {
          Flame.audio.play('piece_moved.ogg');
        }
      }
    }
  }

  void initSprite() {
    String color = player == PlayerID.player1 ? 'white' : 'black';
    String pieceName = type.toString().substring(type.toString().indexOf('.') + 1);
    sprite = Sprite('pieces/' + pieceName + '_' + color + '.png');
  }

  void initSpritePosition(double tileSize, AppModel appModel) {
    spriteX = SharedFunctions.getXFromCol(tile.col, tileSize, appModel);
    spriteY = SharedFunctions.getYFromRow(tile.row, tileSize, appModel);
  }

  void promote() {
    this.type = ChessPieceType.queen;
    this.initSprite();
  }

  void demote() {
    this.type = ChessPieceType.pawn;
    this.initSprite();
  }
  
  @override
  bool operator == (obj) {
    return obj is ChessPiece && obj.sprite == sprite;
  }

  @override
  int get hashCode => sprite.hashCode;
}
