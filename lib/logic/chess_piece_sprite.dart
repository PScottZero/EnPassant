import 'package:audioplayers/audioplayers.dart';
import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/logic/player.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'chess_piece.dart';
import 'constants.dart';

const ACCURACY = 0.1;

class ChessPieceSprite {
  ChessPieceType type;
  String pieceTheme;
  String color;
  int tile;
  Sprite sprite;
  Vector2 spritePosition;
  Vector2 _offset = Vector2(0, 0);

  AudioCache _audioCache = AudioCache();
  AudioPlayer _audioPlayer = AudioPlayer();

  ChessPieceSprite(ChessPiece piece, String pieceTheme) {
    this.tile = piece.tile;
    this.type = piece.type;
    this.color = piece.player.isP1 ? 'white' : 'black';
    initSprite(pieceTheme);
  }

  void update(double tileSize, AppModel appModel, ChessPiece piece) {
    if (piece.type != this.type) {
      this.type = piece.type;
      initSprite(appModel.themePrefs.pieceTheme);
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
      if (_isApproxZero(difference.x.abs())) {
        spritePosition.x = destination.x;
        _offset.x = 0;
      } else {
        if (_offset.x == 0) _offset.x = difference.x / 10;
      }
      if (_isApproxZero(difference.y.abs())) {
        spritePosition.y = destination.y;
        _offset.y = 0;
      } else {
        if (_offset.y == 0) _offset.y = difference.y / 10;
      }
      spritePosition.add(_offset);
      if (_offset == Vector2.zero()) _playSound();
    }
  }

  bool _isApproxZero(double value) => value <= ACCURACY;

  void _playSound() async {
    final bytes = await (await _audioCache.loadAsFile('audio/piece_moved.mp3'))
        .readAsBytes();
    _audioPlayer.playBytes(bytes);
  }

  void initSprite(String pieceTheme) async {
    String pieceName = pieceTypeToString(type);
    if (type == ChessPieceType.promotion) pieceName = 'pawn';
    sprite = Sprite(await Flame.images.load(
        'pieces/${themeNameToAssetDir(pieceTheme)}/${pieceName}_$color.png'));
  }

  void refreshSprite() async {}

  void initSpritePosition(double tileSize, AppModel appModel) {
    spritePosition = Vector2(
      getXFromTile(tile, tileSize, appModel),
      getYFromTile(tile, tileSize, appModel),
    );
  }
}
