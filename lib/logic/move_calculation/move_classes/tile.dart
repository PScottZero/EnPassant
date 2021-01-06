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
