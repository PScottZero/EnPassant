import 'package:en_passant/model/game_data.dart';
import 'package:en_passant/model/theme_preferences.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';

import 'chess_piece.dart';
import 'constants.dart';

const zeroAccuracy = 0.1;

class ChessPieceSprite {
  GameData gameData;
  ChessPieceType pieceType;
  ThemePreferences themePreferences;
  double tileSize;
  late String color;
  late int tile;
  late Sprite sprite;
  Vector2 spritePosition;
  Vector2 _offset = Vector2(0, 0);

  ChessPieceSprite(
      this.gameData, this.pieceType, this.themePreferences, this.tileSize) {
    this.color = gameData.isP1Turn ? 'white' : 'black';
    initSprite();
  }

  void update(
    double tileSize,
    ChessPiece piece,
    bool flip,
    bool playingWithAi,
    bool isP2Turn,
  ) {
    if (piece.type != type) {
      this.type = piece.type;
      initSprite(appModel.themePrefs.pieceTheme);
    }
    if (piece.tile != this.tile) {
      this.tile = piece.tile;
      _offset = Vector2(0, 0);
    }
    var destination = Vector2(
      getXFromTile(tile, tileSize, flip, playingWithAi, isP2Turn),
      getYFromTile(tile, tileSize, flip, playingWithAi, isP2Turn),
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
      if (_offset == Vector2.zero()) FlameAudio.play('audio/piece_moved.mp3');
    }
  }

  bool _isApproxZero(double value) => value <= zeroAccuracy;

  void initSprite(
    bool flip,
    bool playingWithAI,
    bool isP2Turn,
  ) async {
    String pieceName = pieceTypeToString(piece.type);
    if (piece.type == ChessPieceType.promotion) pieceName = 'pawn';
    sprite = Sprite(await Flame.images.load(
        'pieces/${themeNameToAssetDir(pieceTheme)}/${pieceName}_$color.png'));
    spritePosition = Vector2(
      getXFromTile(piece.tile, tileSize, flip, playingWithAI, isP2Turn),
      getYFromTile(piece.tile, tileSize, flip, playingWithAI, isP2Turn),
    );
  }
}
