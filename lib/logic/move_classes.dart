import 'chess_piece.dart';

class Move {
  int from;
  int to;
  MoveMeta meta = MoveMeta();

  Move(this.from, this.to);

  Move.invalidMove() {
    from = -1;
    to = -1;
  }

  setEqualTo(Move move) {
    this.from = move.from;
    this.to = move.to;
    this.meta = move.meta;
  }

  @override
  bool operator ==(move) => this.from == move.from && this.to == move.to;

  @override
  int get hashCode => super.hashCode;
}

class MoveMeta {
  int value = 0;
  _Flags flags = _Flags();
  ChessPiece movedPiece;
  ChessPiece takenPiece;
  ChessPiece enPassantPiece;
  List<List<Move>> possibleOpenings;
  ChessPieceType promotionType = ChessPieceType.promotion;
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
