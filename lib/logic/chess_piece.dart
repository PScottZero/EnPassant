import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

enum ChessPieceType { pawn, rook, knight, bishop, king, queen }

class ChessPiece {
  ChessPieceType type;
  Player player;
  int moveCount = 0;
  int tile;
  Sprite sprite;
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
    return (player == Player.player1) ? value : -value;
  }

  ChessPiece(ChessPieceType type, Player player, int tile) {
    this.type = type;
    this.tile = tile;
    this.player = player;
    initSprite(this);
  }

  void update({@required double tileSize, @required AppModel appModel}) {
    var currX = getXFromTile(tile, tileSize, appModel);
    var currY = getYFromTile(tile, tileSize, appModel);
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

  void initSpritePosition(double tileSize, AppModel appModel) {
    spriteX = getXFromTile(tile, tileSize, appModel);
    spriteY = getYFromTile(tile, tileSize, appModel);
  }
}

void initSprite(ChessPiece piece) {
  String color = piece.player == Player.player1 ? 'white' : 'black';
  String pieceName = piece.type.toString().substring(piece.type.toString().indexOf('.') + 1);
  piece.sprite = Sprite('pieces/' + pieceName + '_' + color + '.png');
}
