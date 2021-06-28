import 'package:en_passant/model/player.dart';

enum ChessPieceType { pawn, rook, knight, bishop, king, queen, promotion }

const PIECE_VALUES = <ChessPieceType, int>{
  ChessPieceType.pawn: 100,
  ChessPieceType.knight: 320,
  ChessPieceType.bishop: 330,
  ChessPieceType.rook: 500,
  ChessPieceType.queen: 900,
  ChessPieceType.king: 20000
};

class ChessPiece {
  int id;
  ChessPieceType type;
  Player player;
  int moveCount = 0;
  int tile;

  int get value {
    return (player == Player.player1)
        ? PIECE_VALUES[type]
        : -PIECE_VALUES[type];
  }

  ChessPiece(this.id, this.type, this.player, this.tile);
}
