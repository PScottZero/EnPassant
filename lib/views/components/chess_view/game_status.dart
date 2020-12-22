import 'package:en_passant/settings/game_settings.dart';
import 'package:en_passant/views/components/main_menu_view/piece_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettings>(
      builder: (context, gameSettings, child) => Container(
        height: 60,
        child: Text(getStatus(gameSettings), style: TextStyle(fontSize: 32))
      )
    );
  }

  String getStatus(GameSettings gameSettings) {
    if (!gameSettings.gameOver) {
      if (gameSettings.playerCount == 1) {
        if (gameSettings.isAIsTurn) {
          return "AI (Level ${gameSettings.aiDifficulty}) is thinking...";
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
}