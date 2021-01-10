import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import '../chess_piece.dart';
import '../shared_functions.dart';

class ChessPieceSprite {
  ChessPieceType type;
  int tile;
  Sprite sprite;
  double spriteX;
  double spriteY;
  double offsetX = 0;
  double offsetY = 0;

  ChessPieceSprite(ChessPiece piece) {
    this.tile = piece.tile;
    this.type = piece.type;
    initSprite(piece);
  }

  void update(double tileSize, AppModel appModel, ChessPiece piece) {
    if (piece.type != this.type) {
      initSprite(piece);
    }
    if (piece.tile != this.tile) {
      this.tile = piece.tile;
    }
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
  
  void initSprite(ChessPiece piece) {
    String color = piece.player == Player.player1 ? 'white' : 'black';
    String pieceName = type.toString().substring(type.toString().indexOf('.') + 1);
    sprite = Sprite('pieces/' + pieceName + '_' + color + '.png');
  }

  void initSpritePosition(double tileSize, AppModel appModel) {
    spriteX = getXFromTile(tile, tileSize, appModel);
    spriteY = getYFromTile(tile, tileSize, appModel);
  }
}