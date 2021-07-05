import 'package:en_passant/logic/player.dart';

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
  ChessPieceType type;
  ChessPieceType startType;
  Player player;
  int moveCount = 0;
  int tile;

  int get value => player.isP1 ? PIECE_VALUES[type] : -PIECE_VALUES[type];
  bool get isKing => hasType(ChessPieceType.king);
  bool get isQueen => hasType(ChessPieceType.queen);
  bool get isRook => hasType(ChessPieceType.rook);
  bool get isBishop => hasType(ChessPieceType.bishop);
  bool get isKnight => hasType(ChessPieceType.knight);
  bool get isPawn => hasType(ChessPieceType.pawn);
  bool get needsPromotion => hasType(ChessPieceType.promotion);
  bool hasType(ChessPieceType type) => this.type == type;

  ChessPiece(this.startType, this.player, this.tile) {
    this.type = this.startType;
  }
}
