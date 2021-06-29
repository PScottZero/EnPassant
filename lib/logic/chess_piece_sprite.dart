import 'package:audioplayers/audioplayers.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/model/player.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'chess_piece.dart';
import 'shared_functions.dart';

const ACCURACY = 0.1;

class ChessPieceSprite {
  ChessPieceType type;
  String pieceTheme;
  int tile;
  Sprite sprite;
  Vector2 spritePosition;
  Vector2 _offset = Vector2(0, 0);

  AudioCache _audioCache = AudioCache();
  AudioPlayer _audioPlayer = AudioPlayer();

  ChessPieceSprite(ChessPiece piece, String pieceTheme) {
    this.tile = piece.tile;
    this.type = piece.type;
    this.pieceTheme = pieceTheme;
    initSprite(piece);
  }

  void update(double tileSize, AppModel appModel, ChessPiece piece) {
    if (piece.type != this.type) {
      this.type = piece.type;
      initSprite(piece);
    }
    if (piece.tile != this.tile) {
      this.tile = piece.tile;
      _offset = Vector2(0, 0);
    }
    var destination = Vector2(
      getXFromTile(tile, tileSize, appModel),
      getYFromTile(tile, tileSize, appModel),
    );
    var difference = destination.clone();
    difference.sub(spritePosition);
    if (difference != Vector2.zero()) {
      if (_isApproxZero(difference.x)) {
        spritePosition.x = destination.x;
        _offset.x = 0;
      } else {
        if (_offset.x == 0) _offset.x = difference.x / 10;
      }
      if (_isApproxZero(difference.y)) {
        spritePosition.y = destination.y;
        _offset.y = 0;
      } else {
        if (_offset.y == 0) _offset.y = difference.y / 10;
      }
      spritePosition.add(_offset);
      if (_offset == Vector2.zero()) _playSound();
    }
  }

  bool _isApproxZero(double value) {
    return value <= ACCURACY;
  }

  void _playSound() async {
    final bytes = await (await _audioCache.loadAsFile('audio/piece_moved.mp3'))
        .readAsBytes();
    _audioPlayer.playBytes(bytes);
  }

  void initSprite(ChessPiece piece) async {
    String color = piece.player == Player.player1 ? 'white' : 'black';
    String pieceName = pieceTypeToString(piece.type);
    if (piece.type == ChessPieceType.promotion) {
      pieceName = 'pawn';
    }
    sprite = Sprite(await Flame.images
        .load('pieces/${themeNameToDir(pieceTheme)}/${pieceName}_$color.png'));
  }

  void initSpritePosition(double tileSize, AppModel appModel) {
    spritePosition = Vector2(
      getXFromTile(tile, tileSize, appModel),
      getYFromTile(tile, tileSize, appModel),
    );
  }
}
