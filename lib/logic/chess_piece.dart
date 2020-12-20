import 'package:en_passant/views/components/main_menu/piece_color_picker.dart';

enum ChessPieceType { pawn, rook, knight, bishop, king, queen }

class ChessPiece {
  ChessPieceType type;
  PlayerID player;
  double value;
  int moveCount = 0;

  ChessPiece({ChessPieceType type, PlayerID belongsTo}) {
    this.type = type;
    player = belongsTo;
    value = getValue();
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
