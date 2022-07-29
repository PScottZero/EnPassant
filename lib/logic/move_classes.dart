import 'chess_piece.dart';

class Move {
  int from;
  int to;
  MoveMeta meta = MoveMeta();

  Move(this.from, this.to);

  Move.invalidMove() : this(-1, -1);

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
  Flags flags = Flags();
  ChessPiece? movedPiece;
  ChessPiece? takenPiece;
  ChessPiece? enPassantPiece;
  List<List<Move>> possibleOpenings = [];
  ChessPieceType promotionType = ChessPieceType.promotion;
}

class Flags {
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
