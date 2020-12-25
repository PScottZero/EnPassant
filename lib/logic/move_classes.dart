import 'package:en_passant/logic/chess_piece.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';

class Tile {
  int row;
  int col;
  
  Tile({this.row, this.col});

  Tile copy() { return Tile(row: row, col: col); }

  @override
  bool operator == (obj) {
    return obj is Tile && obj.row == row && obj.col == col;
  }

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

class Move {
  Tile from;
  Tile to;
  MoveMeta meta = MoveMeta();
  Move({this.from, this.to});
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
  MoveAndValue({this.move, this.value});
}
