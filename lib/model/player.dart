enum Player { player1, player2, random }

extension PlayerExtension on Player {
  Player get opposite {
    return this == Player.player1 ? Player.player2 : Player.player1;
  }
}
