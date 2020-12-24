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
  Move({this.from, this.to});
}

class MoveAndValue {
  Move move;
  int value;
  MoveAndValue({this.move, this.value});
}
