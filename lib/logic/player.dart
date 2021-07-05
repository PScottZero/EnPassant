enum Player { player1, player2, random }

extension PlayerExtension on Player {
  bool get isP1 => this == Player.player1;
  bool get isP2 => this == Player.player2;
  bool get isRandom => this == Player.random;
  Player get opposite => this.isP1 ? Player.player2 : Player.player1;
}
