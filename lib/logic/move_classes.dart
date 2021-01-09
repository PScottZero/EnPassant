import 'package:en_passant/logic/chess_piece.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';

class Tile {
  int row;
  int col;
  
  Tile(this.row, this.col);
  
  Tile.invalid() {
    this.row = -1;
    this.col = -1;
  }

  Tile.copy(Tile existingTile) {
    this.row = existingTile.row;
    this.col = existingTile.col;
  }

  @override
  bool operator == (obj) {
    return obj is Tile && obj.row == row && obj.col == col;
  }

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

class MoveStackObject {
  Move move;
  ChessPiece movedPiece;
  ChessPiece takenPiece;
  bool castling = false;
  bool promotion = false;
  bool enPassant = false;
  MoveStackObject(this.move, this.movedPiece, this.takenPiece);
}

class Move {
  Tile from;
  Tile to;
  MoveMeta meta = MoveMeta();
  Move(this.from, this.to);
  Move.invalid() {
    this.from = Tile.invalid();
    this.to = Tile.invalid();
  }
}

class MoveMeta {
  PlayerID player;
  ChessPieceType type;
  bool took = false;
  bool kingCastle = false;
  bool queenCastle = false;
  bool promotion = false;
  bool isCheck = false;
  bool isCheckmate = false;
  bool rowIsAmbiguous = false;
  bool colIsAmbiguous = false;
}

class MoveAndValue {
  Move move;
  int value;
  MoveAndValue(this.move, this.value);
}
