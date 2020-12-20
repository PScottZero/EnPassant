import 'dart:ui';

import 'package:flame/game/game.dart';

class ChessGame extends Game {

  ChessGame() {
    resize(const Size(320, 320));
  }

  void drawBoard(Canvas canvas) {
    for (int tileNo = 0; tileNo < 64; tileNo++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (tileNo % 8) * 40.0,
          (tileNo / 8).floor() * 40.0, 
          40, 40
        ),
        Paint()..color = Color((tileNo + (tileNo / 8).floor()) % 2 == 0 ? 0xFFC9B28F : 0xFF857050)
      );
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    drawBoard(canvas);
    canvas.restore();
  }
  
  @override
  void update(double t) {
  // TODO: implement update
  }
}