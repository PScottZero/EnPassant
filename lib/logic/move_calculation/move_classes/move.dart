class Move {
  int from;
  int to;
  Move(this.from, this.to);

  @override
  bool operator == (move) => this.from == move.from && this.to == move.to;

  @override
  int get hashCode => super.hashCode;
}