import 'package:en_passant/settings/game_settings.dart';
import 'package:en_passant/views/components/main_menu_view/ai_difficulty_picker.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettings>(
      builder: (context, gameSettings, child) => 
        Text(getStatus(gameSettings), style: TextStyle(fontSize: 24))
    );
  }

  String getStatus(GameSettings gameSettings) {
    if (!gameSettings.gameOver) {
      if (gameSettings.playerCount == 1) {
        if (gameSettings.isAIsTurn) {
          return "AI [${getAIDifficulty(gameSettings)}] is thinking...";
        } else {
          return "Your turn";
        }
      } else {
        if (gameSettings.turn == PlayerID.player1) {
          return "White's turn";
        } else {
          return "Black's turn";
        }
      }
    } else {
      if (gameSettings.playerCount == 1) {
        if (gameSettings.isAIsTurn) {
          return "You Win!";
        } else {
          return "You Lose :(";
        }
      } else {
        if (gameSettings.turn == PlayerID.player1) {
          return "Black wins!";
        } else {
          return "White wins!";
        }
      }
    }
  }

  String getAIDifficulty(GameSettings gameSettings) {
    switch (gameSettings.aiDifficulty) {
      case AIDifficulty.easy: { return 'Easy'; }
      case AIDifficulty.normal: { return 'Normal'; }
      case AIDifficulty.hard: { return 'Hard'; }
      case AIDifficulty.deepblue: { return 'Deep Blue'; }
      default: { return ''; }
    }
  }
}
