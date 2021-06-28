import 'package:en_passant/model/player.dart';

import '../chess_piece.dart';

class Move {
  int from;
  int to;
  MoveMeta meta = MoveMeta();

  Move(this.from, this.to);

  Move.invalidMove() {
    from = -1;
    to = -1;
  }

  @override
  bool operator ==(move) => this.from == move.from && this.to == move.to;

  @override
  int get hashCode => super.hashCode;
}

class MoveMeta {
  int value = 0;
  _Flags flags = _Flags();
  ChessPieceType promotionType;
  ChessPiece movedPiece;
  ChessPiece takenPiece;
  ChessPiece enPassantPiece;
  List<List<Move>> possibleOpenings;

  Player get player {
    return movedPiece.player;
  }

  ChessPieceType get type {
    return movedPiece.type;
  }
}

class _Flags {
  bool took = false;
  bool kingCastle = false;
  bool queenCastle = false;
  bool promotion = false;
  bool castled = false;
  bool enPassant = false;
  bool isCheck = false;
  bool isCheckmate = false;
  bool isStalemate = false;
  bool rowIsAmbiguous = false;
  bool colIsAmbiguous = false;
}

class Direction {
  final int up;
  final int right;

  const Direction(this.up, this.right);
}

const UP = Direction(1, 0);
const UP_RIGHT = Direction(1, 1);
const RIGHT = Direction(0, 1);
const DOWN_RIGHT = Direction(-1, 1);
const DOWN = Direction(-1, 0);
const DOWN_LEFT = Direction(-1, -1);
const LEFT = Direction(0, -1);
const UP_LEFT = Direction(1, -1);

const PAWN_DIAGONALS_1 = [DOWN_LEFT, DOWN_RIGHT];
const PAWN_DIAGONALS_2 = [UP_LEFT, UP_RIGHT];
const KNIGHT_MOVES = [
  Direction(1, 2),
  Direction(-1, 2),
  Direction(1, -2),
  Direction(-1, -2),
  Direction(2, 1),
  Direction(-2, 1),
  Direction(2, -1),
  Direction(-2, -1)
];
const BISHOP_MOVES = [UP_RIGHT, DOWN_RIGHT, DOWN_LEFT, UP_LEFT];
const ROOK_MOVES = [UP, RIGHT, DOWN, LEFT];
const KING_QUEEN_MOVES = [
  UP,
  UP_RIGHT,
  RIGHT,
  DOWN_RIGHT,
  DOWN,
  DOWN_LEFT,
  LEFT,
  UP_LEFT
];
