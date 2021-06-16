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
